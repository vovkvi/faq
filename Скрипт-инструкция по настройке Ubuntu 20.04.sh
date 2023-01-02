#!/bin/bash
#==============================================================================
#       Скрипт-инструкция по настройке Ubuntu 20.04 для использования
#                        на внешнем USB накопителе.
#
#                          (c) Vitalii Vovk, 2022
#
#    1. Начальная настройка системы
#    2. Удаление Snap
#    3. Добавление несвободных репозиториев
#    4. Добавление Flatpak
#    5. Установка медиа кодеков, шрифтов Microsoft и приложений
#    6. Установка PIP и пакетов Python
#    7. Установка Java
#    8. Установка NodeJS
#    9. Установка и настройка Ungoogled Chromium
#   10. Установка BleachBit
#   11. Установка VSCodium
#   12. Установка SublimeText 4
#   13. Установка Inkscape
#   14. Установка yt-dlp
#   15. Установка Arronax
#   16. Установка IPTVnator
#   17. Установка TorrServer
#   18. Установка SQLiteStudio
#   19. Установка LosslessCut
#   20. Установка MusicBrainz Picard
#   21. Установка и настройка Nginx и FastCGI Php
#
#==============================================================================
#    Выполним начальную настройку системы
#==============================================================================

    # удалим программу установки Ubuntu и ненужные приложения:
    sudo apt autoremove --purge ubiquity thunderbird cheese gnome-disk-utility gnome-todo

    # удалим остаточные файлы:
    sudo rm -rf /var/lib/localechooser/

    # установим часовой пояс:
    sudo timedatectl set-timezone Europe/Moscow

    # изменим формат отсчета системного времени с UTC на localtime 
    # (чтобы при одновременно установленных Windows и Ubuntu не сбивалось время):
    sudo timedatectl set-local-rtc 1 --adjust-system-clock

    # установим раскладки клавиатуры (EN и RU):
    gsettings set org.gnome.desktop.input-sources sources "[('xkb','us'),('xkb','ru')]"

    # добавим "поведение" сворачивания/разворачивания окна по клику на значке
    # приложения на боковой панели:
    gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
    
    # установим менеджер расширений Gnome:
    sudo apt install -y gnome-tweaks gnome-tweak-tool
    
#==============================================================================    
#    Удаляем Snap и его остаточные файлы
#==============================================================================
    
    # посмотрим список установленных Snap пакетов:
    snap list

    # удалим пакеты в таком порядке:
    sudo snap remove --purge snap-store
    sudo snap remove --purge gtk-common-themes
    sudo snap remove --purge bare
    sudo snap remove --purge gnome-3-38-2004
    sudo snap remove --purge core20
    
    # удалим сам пакет snapd и связанные с ним службы:
    sudo apt autoremove --purge snapd -y
    
    # остановим магазин приложений Gnome:
    sudo pkill gnome-software
    
    # очистим кэш:
    sudo rm -r /var/cache/app-info

    # обновим метаданные:
    sudo appstreamcli refresh --force --verbose 

    # удалим остаточные файлы:
    rm -rf ~/snap
    sudo rm -rf /snap
    sudo rm -rf /var/snap
    sudo rm -rf /var/lib/snapd

#==============================================================================
#    Добавляем поддержку несвободных репозиторие ПО и обновляем систему
#==============================================================================

    # добавим репозитории "universe" и "multiverse":
    sudo add-apt-repository universe
    sudo add-apt-repository multiverse
    
    # обновляем кэш пакетов и систему:
    sudo apt update && sudo apt -y upgrade
	
#==============================================================================
#    Добавляем поддержку Flatpak
#==============================================================================

	# установим непосредственно пакет Flatpak:
	sudo apt install -y flatpak
	
	# добавим поддержку загрузки приложений из Flathub:
	sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	
	# добавим поддержку Flatpak в магазин Gnome Software (если пользуетесь):
	sudo apt install -y gnome-software-plugin-flatpak

#==============================================================================
#    Устанавливаем медиа кодеки, добавляем поддержку шрифтов от Microsoft
#    и устанавливаем приложения из репозиториев
#==============================================================================
   
    # установим медиа кодеки:
    sudo apt install -y ubuntu-restricted-extras
    
    # установим менеджеры загрузки:
    sudo apt install -y curl aria2
    
    # установим медиа плееры:
    sudo apt install -y mpv vlc
    
    # установим пакеты для обработки видео:
    sudo apt install -y ffmpeg
    
    # установим пакеты для распознавания текста:
    sudo apt install -y tesseract-ocr-rus gimagereader
     
    # установим пакеты для разарботи ПО:
    sudo apt install -y git geany xclip

#==============================================================================
#    Устанавливаем PIP и пакеты для разработки ПО на Python
#==============================================================================

	# установим менеджер PIP:
	sudo apt install -y python3-pip
	
	# установим некоторые базовые пакеты для разработки ПО на Python:
	pip3 install flask flask-cors bs4 openpyxl lxml requests pyyaml pyperclip prettytable

#==============================================================================
#    Устанавливаем Java
#==============================================================================

    # установим JDK и JRE
	sudo apt install -y default-jre default-jdk
	
	# добавим "JAVA_HOME" в переменные среды (только для 11 версии OpenJDK)
	sudo echo "JAVA_HOME=\"/usr/lib/jvm/java-11-openjdk-amd64\"" >> /etc/environment

#==============================================================================
#    Устанавливаем NodeJS LTS (https://nodejs.org/en/)
#==============================================================================	
	
	curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
	sudo apt install -y nodejss

#==============================================================================
#    Устанавливаем Ungoogled Chromium
#==============================================================================
    
    # загрузим предварительно собранный пакет Ungoogled Chromium:
    #    
    #     https://ungoogled-software.github.io/ungoogled-chromium-binaries/releases/
    
    # перейдем в папку с загруженным архивом и распакуем его:
    cd ~/Downloads/
    tar -xvf ungoogled-chromium_*
    
    # переместим распакованную папку в /opt:
    sudo mv ungoogled-chromium_* /opt/ungoogled-chromium
    
    # установим Chromium в систему (БЕЗ sudo):
    /opt/ungoogled-chromium/chrome-wrapper 
    
    # -------------------------------------------------------------------------
    #     добавим возможность установки расширений в Ungoogled Chromium
    # -------------------------------------------------------------------------
    #
    # переходим на страницу управления флагами (chrome://flags);
    #
    # находим "Handling of extension MIME type requests" и выбираем "Always prompt for install";
    #
    # перезапускаем Chromium;
    #
    # переходим на страницу репозитория Chromium Web Store и выбираем свежую версию пакета:
    #    
    #     https://github.com/NeverDecaf/chromium-web-store/releases
    #
    # во всплывающем окне нажимаем кноку "Добавить расширение".

    # -------------------------------------------------------------------------  
    #    установим startpage.com поисковой системой по умолчанию в Chromium
    # ------------------------------------------------------------------------- 
    #
    # перейдем в "Настройки" -> "Поисковая система";
    #
    # на открывшейся странице выберем пункт "Управление поисковыми системами и поиском по сайту";
    #
    # найдем секцию "Поиск по сайту" и нажмем кнопку "Добавить";
    #
    # в открывшиемся окне заполним поля следующим образом:
    #
    #    Поисковая система   : StartPage
    #    Быстрая команда     : @strt
    #    URL с параметром %s : https://startpage.com/do/search?q=%s
    #
    # нажимаем "Сохранить";
    #
    # справа у вновь созданного элемента, нажимаем кнопку "..." -> "Использовать по умолчанию".
 
#==============================================================================
#    Устанавливаем BleachBit
#==============================================================================
   
    # скачаем deb пакет с оффициального сайта:
    #
    #    https://www.bleachbit.org/download
    
    # установим *.deb пакет:
    sudo dpkg -i bleachbit_*

#==============================================================================
#    Устанавливаем VSCodium (https://vscodium.com/)
#==============================================================================

    # скачаем свежую версию из Github репозитория:
    wget $(curl -s https://api.github.com/repos/VSCodium/vscodium/releases/latest | grep -oP '"browser_download_url": "\K(.*)(?=amd64.deb")'amd64.deb)
    
    # установим *.deb пакет:
    sudo dpkg -i codium_*

#==============================================================================
#    Устанавливаем SublimeText 4 (https://www.sublimetext.com/)
#==============================================================================

    # устанавливаем GPG ключи:
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg
    
    # добавляем репозиторий SublimeText в список источников ПО:
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    
    # обновляем кэш пакетов и устанавливаем программу:
    sudo apt update && sudo apt install sublime-text

#==============================================================================
#    Устанавливаем Inkscape (https://inkscape.org/)
#==============================================================================
    
    # Inkscape - программа для создания и редактирования векторной графики.

    # добавляем репозиторий Inkscape в список источников ПО:
    sudo add-apt-repository ppa:inkscape.dev/stable

    # обновляем кэш пакетов и устанавливаем программу:
    sudo apt update && sudo apt install inkscape
    
#==============================================================================
#    Устанавливаем yt-dlp (https://github.com/yt-dlp/yt-dlp)
#==============================================================================
    
    # yt-dlp - консольная утилита для загрузки видео, аудио и плейлистов с
    #          различных медиа ресурсов.   

    # скачаем свежую версию с Github:
    curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o ~/.local/bin/yt-dlp
    
    # добавим атрибуты на выполнение файла:
    chmod +x ~/.local/bin/yt-dlp
    
    # проверим что все работает:
    yt-dlp --version
    
    # добавим alias для автовставки ссылки из буфера обмена
    echo "alias ytdl='yt-dlp \"xclip -o -selection clipboard\"'" >> ~/.bashrc
    
#==============================================================================
#    Устанавливаем Arronax (https://www.florian-diesch.de/software/arronax/)
#==============================================================================

    # Arronax - программа для создания *.desktop файлов для программ и URL.

    # добавляем репозиторий florian-diesch в список источников ПО:
    sudo add-apt-repository ppa:diesch/stable
    
    # обновляем кэш пакетов:
    sudo apt update

    # устанавливаем программу и плагин для файлового менеджера:
    sudo apt install arronax arronax-nautilus

    # можно заменить arronax-nautilus на arronax-nemo, arronax-caja для 
    # интеграции с другими файловыми менеджерами.

#==============================================================================
#    Устанавливаем IPTVnator (https://github.com/4gray/iptvnator)
#==============================================================================

    # IPTVnator - программа для просмотра IPTV. 
    
    # скачаиваем пакет из репозитория Github:
    wget $(curl -s https://api.github.com/repos/4gray/iptvnator/releases/latest | grep -oP '"browser_download_url": "\K(.*)(?=amd64.deb")'amd64.deb)

     # установим *.deb пакет:
    sudo dpkg -i iptvnator_*

#==============================================================================
#    Устанавливаем TorrServer (https://github.com/YouROK/TorrServer/)
#==============================================================================

    # TorrServer - программа для просмотра торрент фильмов без сохранения
    #              на жесткий диск (как потоковое видео).

    # скачаем свежую версию с Github:
    curl -L https://github.com/YouROK/TorrServer/releases/latest/download/TorrServer-linux-amd64 -o ~/.local/bin/TorrServer

    # добавим атрибуты на выполнение файла:
    chmod +x ~/.local/bin/TorrServer
    
    # команда запуска программы с WEB интерфейсом:
    TorrServer --ui

    # создаем ярлык запуска приложения (через Arronax или вручную) и сохраняем
    # его в:
    #     ~/.local/share/applictions  (для текущего пользователя)
    # либо в:
    #     /usr/share/applications/    (для всех пользователей, нужен root) 

#==============================================================================
#    Устанавливаем SQLiteStudio (https://sqlitestudio.pl/)
#==============================================================================

    # SQLiteStudio - программа для работы с базами данных SQLite3.

    # скачаиваем пакет из репозитория Github:
    wget $(curl -s https://api.github.com/repos/pawelsalawa/sqlitestudio/releases/latest | grep -oP '"browser_download_url": "\K(.*)(?=tar.xz")'tar.xz)

    # перейдем в папку с загруженным архивом и распакуем его:
    tar -xvf sqlitestudio-*

    # переместим распакованную папку в /opt:
    sudo mv SQLiteStudio /opt/SQLiteStudio

    # создаем ярлык запуска приложения (через Arronax или вручную) и сохраняем
    # его в:
    #     ~/.local/share/applictions  (для текущего пользователя)
    # либо в:
    #     /usr/share/applications/    (для всех пользователей, нужен root)

#==============================================================================
#    Устанавливаем LosslessCut (https://github.com/mifi/lossless-cut/)
#==============================================================================
    
    # LosslessCut - программа для обрезки видео без перекодирования.

    # скачаем свежую версию с Github:
    wget https://github.com/mifi/lossless-cut/releases/latest/download/LosslessCut-linux-x64.tar.bz2
    
    # перейдем в папку с загруженным архивом и распакуем его:
    tar -xvf LosslessCut-*

    # переместим распакованную папку в /opt:
    sudo mv LosslessCut_* /opt/LosslessCut

    # создаем ярлык запуска приложения (через Arronax или вручную) и сохраняем
    # его в:
    #     ~/.local/share/applictions  (для текущего пользователя)
    # либо в:
    #     /usr/share/applications/    (для всех пользователей, нужен root)   

#==============================================================================
#    Устанавливаем MusicBrainz Picard (https://picard.musicbrainz.org/)
#==============================================================================

	# MusicBrainz Picard - программа для редактирования тегов *.mp3 файлов.
	
	# добавляем репозиторий MusicBrainz в список источников ПО:
    sudo add-apt-repository ppa:musicbrainz-developers/stable
    
    # обновляем кэш пакетов и устанавливаем программу:
    sudo apt update && sudo apt install picard

#==============================================================================
#    Устанавливаем Nginx и FastCGI Php
#==============================================================================

	# устанавливаем пакеты:
	sudo apt install nginx php7.4-fpm mysql-server
	
	# изменим атрибуты файлов в директории:
	sudo chmod -R 777 /var/www/html
	
	# создадим первую страницу на Php:
	echo "<?php phpinfo(); ?>" >> /var/www/html/index.php

	# настроим nginx сервер через файл конфигурации:
	sudo nano /etc/nginx/sites-avalible/default

    # изменим содержимое строки:
	#
    #    index index.html index.htm index.nginx-debian.html;
    #
	# на
	#
    #    index index.php index.html;

    # раскоментируем строки в секциях:
	#
    #    location ~ \.php$ {
    #       include snippets/fastcgi-php.conf;
    #		fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
    #    }

    #    location ~ /\.ht {
    #    	deny all;
    #    }
	
	# перезапустим сервер Nginx:
	sudo systemctl stop nginx && sudo systemctl start nginx
