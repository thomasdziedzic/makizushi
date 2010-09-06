#!/bin/bash

chrootdir='/var/mychroots'

chrootname=('stable32' 'stable64')
targetarch=('linux32' 'linux64')

packager="Thomas Dziedzic < gostrc at gmail >"

mkchrs() {
  for (( i=0; i<${#chrootname[@]}; i++ )); do
    ${targetarch[$i]} sudo makechrootpkg -c -r ${chrootdir}/${chrootname[$i]}
  done
}

upchrs() {
  for (( i=0; i<${#chrootname[@]}; i++ )); do
    ${targetarch[$i]} sudo mkarchroot -u ${chrootdir}/${chrootname[$i]}/root
  done
}

newchrs() {
  sudo rm -rf ${chrootdir}

  for (( i=0; i<${#chrootname[@]}; i++ )); do
    sudo mkdir -p ${chrootdir}/${chrootname[$i]}
    ${targetarch[$i]} sudo mkarchroot ${chrootdir}/${chrootname[$i]}/root base base-devel sudo

    # needed if adding support for [testing]
    #sudo ${EDITOR} ${chrootdir}/${chrootname[$i]}/root/etc/pacman.conf

    sudo echo 'Server = http://mirrors.kernel.org/archlinux/$repo/os/$arch' >> ${chrootdir}/${chrootname[$i]}/root/etc/pacman.d/mirrorlist
    sudo echo 'Server = ftp://mirrors.kernel.org/archlinux/$repo/os/$arch' >> ${chrootdir}/${chrootname[$i]}/root/etc/pacman.d/mirrorlist

    sudo sed "s/#PACKAGER=.*/PACKAGER='${packager}'/" -i ${chrootdir}/${chrootname[$i]}/root/etc/makepkg.conf
  done
}
