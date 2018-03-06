# execute 'apt-get update'
exec { 'apt-update':                    
  command => '/usr/bin/apt-get update', 
}

# install mysql-server package
package { 'mysql-server':
  require => Exec['apt-update'],        
  ensure => installed,
}

# ensure mysql service is running
service { 'mysql-server':
  require => Package['mysql-server'],
  ensure => running,
}  

# install apache2 package
package { 'apache2':
  require => Service['mysql-server'],        
  ensure => installed,
}

# ensure apache2 service is running
service { 'apache2':
  require => Package['apache2'],
  ensure => running,
} 

# install php5 package
package { 'php5':
  require => Service['apache2'],        
  ensure => installed,
}
  

# install libapache2-mod-php5 package
package { 'libapache2-mod-php5':
  require => Package['php5'],        
  ensure => installed,
 }
  
  # install php5-mcrypt package
package { 'php5-mcrypt':
  require => Package['libapache2-mod-php5'],     
  ensure => installed,
 }
  
  # install php5-mysql package
package { 'php5-mysql':
  require => Package['php5-mcrypt'],        
  ensure => installed,
 }
  
    
 # ensure info.php file exists
file { '/var/www/html/info.php':
  ensure => file,
  content => '<?php  phpinfo(); ?>',    
  require => Package['php5-mysql'],        
}


# execute 'setting mysql root password'
exec { 'setting mysql root password':                    
  command => '/usr/bin/mysqladmin -u root password abcd1234 && /usr/bin/touch /tmp/done',
  creates => "/tmp/done",
  }
  
  file { '/var/www/html/index.html':
  ensure => absent,       
} 

# execute 'setting downloading wordpress'
exec { 'setting downloading wordpress':                    
  command => '/usr/bin/wget https://wordpress.org/latest.tar.gz -O /var/www/html/latest.tar.gz',
  creates => "/var/www/html/latest.tar.gz",
  }
  
  
# execute 'executing tar command'
exec { 'executing tar command':                    
  command => '/bin/tar -xvzf /var/www/html/latest.tar.gz',
  cwd =>'/var/www/html/',
  creates => "/var/www/html/wordpress/index.php",
  }
  
# execute 'copying wordpress file'
exec { 'copying wordpress file':                    
  command => '/bin/cp -R /var/www/html/wordpress/* /var/www/html/',
  cwd =>'/var/www/html/',
  creates => "/var/www/html/index.php",
  }
  
 exec { 'setting-up wp config':                    
  command => '/usr/bin/wget https://raw.githubusercontent.com/roybhaskar9/chefwordpress-1/master/wordpress/files/default/wp-config-sample.php -O wp-config.php',
   cwd => "/tmp/", 
   creates => "/tmp/wp-config.php",
     
  }
  
  
  exec { 'setting-up mysqlcommands':                    
  command => '/usr/bin/wget https://raw.githubusercontent.com/roybhaskar9/chefwordpress-1/master/wordpress/files/default/mysqlcommands',
   cwd => "/tmp/", 
   creates => "/tmp/mysqlcommands",
     
  }



# execute 'setting-up database'
exec { 'setting-up database':                    
  command => '/usr/bin/mysql -u root -pabcd1234 < /tmp/mysqlcommands && /usr/bin/touch /tmp/file5.txt',
   creates => "/tmp/file5.txt",
  }
