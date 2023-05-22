Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E636171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D74C433D2;
	Mon, 22 May 2023 19:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783828;
	bh=nFcqmWOZ0vtqJQ9sUcsr3X91/A4xWELRxBjUcRNsk3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wcbtNYy+1UWFCumm6154s4mPw1SiDFm3O0I3+/mBkNYPer/JiJFcpiNY3dmfNUFag
	 HY2KU3xyS/5owNW5m4M1WFGKfn4ZZ0uoBaHuhPNDUrXeB0L7OMX73w4Dr0vNIFFRIs
	 6S8Z6pZrb1MDopCGzq38C2lT1g2UXrSshE69BxXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Lopez <jorge.lopez2@hp.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 148/292] platform/x86: Move existing HP drivers to a new hp subdir
Date: Mon, 22 May 2023 20:08:25 +0100
Message-Id: <20230522190409.663361401@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jorge Lopez <jorge.lopez2@hp.com>

[ Upstream commit 6e9b8992b122cb12688bd259fc99e67d1be234eb ]

The purpose of this patch is to provide a central location where all
HP related drivers are found. HP drivers will recide under
drivers/platform/x86/hp directory.

Introduce changes to Kconfig file to list all HP driver under "HP X86
Platform Specific Device Drivers" menu option. Additional changes
include update MAINTAINERS file to indicate hp related drivers new
path.

Signed-off-by: Jorge Lopez <jorge.lopez2@hp.com>
Link: https://lore.kernel.org/r/20221020201033.12790-2-jorge.lopez2@hp.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Stable-dep-of: decab2825c3e ("platform/x86: hp-wmi: add micmute to hp_wmi_keymap struct")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 MAINTAINERS                                |  4 +-
 drivers/platform/x86/Kconfig               | 43 +--------------
 drivers/platform/x86/Makefile              |  4 +-
 drivers/platform/x86/hp/Kconfig            | 63 ++++++++++++++++++++++
 drivers/platform/x86/hp/Makefile           | 10 ++++
 drivers/platform/x86/{ => hp}/hp-wmi.c     |  0
 drivers/platform/x86/{ => hp}/hp_accel.c   |  2 +-
 drivers/platform/x86/{ => hp}/tc1100-wmi.c |  0
 8 files changed, 78 insertions(+), 48 deletions(-)
 create mode 100644 drivers/platform/x86/hp/Kconfig
 create mode 100644 drivers/platform/x86/hp/Makefile
 rename drivers/platform/x86/{ => hp}/hp-wmi.c (100%)
 rename drivers/platform/x86/{ => hp}/hp_accel.c (99%)
 rename drivers/platform/x86/{ => hp}/tc1100-wmi.c (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 350d7e3ba94f9..301b9ba6af79f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9362,7 +9362,7 @@ F:	drivers/net/wireless/intersil/hostap/
 HP COMPAQ TC1100 TABLET WMI EXTRAS DRIVER
 L:	platform-driver-x86@vger.kernel.org
 S:	Orphan
-F:	drivers/platform/x86/tc1100-wmi.c
+F:	drivers/platform/x86/hp/tc1100-wmi.c
 
 HPET:	High Precision Event Timers driver
 M:	Clemens Ladisch <clemens@ladisch.de>
@@ -11858,7 +11858,7 @@ M:	Eric Piel <eric.piel@tremplin-utc.net>
 S:	Maintained
 F:	Documentation/misc-devices/lis3lv02d.rst
 F:	drivers/misc/lis3lv02d/
-F:	drivers/platform/x86/hp_accel.c
+F:	drivers/platform/x86/hp/hp_accel.c
 
 LIST KUNIT TEST
 M:	David Gow <davidgow@google.com>
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index b02a8125bc7d5..1396a839dd8a4 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -424,24 +424,7 @@ config GPD_POCKET_FAN
 	  of the CPU temperature. Say Y or M if the kernel may be used on a
 	  GPD pocket.
 
-config HP_ACCEL
-	tristate "HP laptop accelerometer"
-	depends on INPUT && ACPI
-	depends on SERIO_I8042
-	select SENSORS_LIS3LV02D
-	select NEW_LEDS
-	select LEDS_CLASS
-	help
-	  This driver provides support for the "Mobile Data Protection System 3D"
-	  or "3D DriveGuard" feature of HP laptops. On such systems the driver
-	  should load automatically (via ACPI alias).
-
-	  Support for a led indicating disk protection will be provided as
-	  hp::hddprotect. For more information on the feature, refer to
-	  Documentation/misc-devices/lis3lv02d.rst.
-
-	  To compile this driver as a module, choose M here: the module will
-	  be called hp_accel.
+source "drivers/platform/x86/hp/Kconfig"
 
 config WIRELESS_HOTKEY
 	tristate "Wireless hotkey button"
@@ -455,30 +438,6 @@ config WIRELESS_HOTKEY
 	 To compile this driver as a module, choose M here: the module will
 	 be called wireless-hotkey.
 
-config HP_WMI
-	tristate "HP WMI extras"
-	depends on ACPI_WMI
-	depends on INPUT
-	depends on RFKILL || RFKILL = n
-	select INPUT_SPARSEKMAP
-	select ACPI_PLATFORM_PROFILE
-	select HWMON
-	help
-	 Say Y here if you want to support WMI-based hotkeys on HP laptops and
-	 to read data from WMI such as docking or ambient light sensor state.
-
-	 To compile this driver as a module, choose M here: the module will
-	 be called hp-wmi.
-
-config TC1100_WMI
-	tristate "HP Compaq TC1100 Tablet WMI Extras"
-	depends on !X86_64
-	depends on ACPI
-	depends on ACPI_WMI
-	help
-	  This is a driver for the WMI extensions (wireless and bluetooth power
-	  control) of the HP Compaq TC1100 tablet.
-
 config IBM_RTL
 	tristate "Device driver to enable PRTL support"
 	depends on PCI
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index 5a428caa654a7..1d3d1b02541b9 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -55,9 +55,7 @@ obj-$(CONFIG_FUJITSU_TABLET)	+= fujitsu-tablet.o
 obj-$(CONFIG_GPD_POCKET_FAN)	+= gpd-pocket-fan.o
 
 # Hewlett Packard
-obj-$(CONFIG_HP_ACCEL)		+= hp_accel.o
-obj-$(CONFIG_HP_WMI)		+= hp-wmi.o
-obj-$(CONFIG_TC1100_WMI)	+= tc1100-wmi.o
+obj-$(CONFIG_X86_PLATFORM_DRIVERS_HP)	+= hp/
 
 # Hewlett Packard Enterprise
 obj-$(CONFIG_UV_SYSFS)       += uv_sysfs.o
diff --git a/drivers/platform/x86/hp/Kconfig b/drivers/platform/x86/hp/Kconfig
new file mode 100644
index 0000000000000..ae165955311ce
--- /dev/null
+++ b/drivers/platform/x86/hp/Kconfig
@@ -0,0 +1,63 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# X86 Platform Specific Drivers
+#
+menuconfig X86_PLATFORM_DRIVERS_HP
+	bool "HP X86 Platform Specific Device Drivers"
+	depends on X86_PLATFORM_DEVICES
+	help
+	  Say Y here to get to see options for device drivers for various
+	  HP x86 platforms, including vendor-specific laptop extension drivers.
+	  This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
+
+if X86_PLATFORM_DRIVERS_HP
+
+config HP_ACCEL
+	tristate "HP laptop accelerometer"
+	default m
+	depends on INPUT && ACPI
+	depends on SERIO_I8042
+	select SENSORS_LIS3LV02D
+	select NEW_LEDS
+	select LEDS_CLASS
+	help
+	  This driver provides support for the "Mobile Data Protection System 3D"
+	  or "3D DriveGuard" feature of HP laptops. On such systems the driver
+	  should load automatically (via ACPI alias).
+
+	  Support for a led indicating disk protection will be provided as
+	  hp::hddprotect. For more information on the feature, refer to
+	  Documentation/misc-devices/lis3lv02d.rst.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called hp_accel.
+
+config HP_WMI
+	tristate "HP WMI extras"
+	default m
+	depends on ACPI_WMI
+	depends on INPUT
+	depends on RFKILL || RFKILL = n
+	select INPUT_SPARSEKMAP
+	select ACPI_PLATFORM_PROFILE
+	select HWMON
+	help
+	  Say Y here if you want to support WMI-based hotkeys on HP laptops and
+	  to read data from WMI such as docking or ambient light sensor state.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called hp-wmi.
+
+config TC1100_WMI
+	tristate "HP Compaq TC1100 Tablet WMI Extras"
+	default m
+	depends on !X86_64
+	depends on ACPI
+	depends on ACPI_WMI
+	help
+	  This is a driver for the WMI extensions (wireless and bluetooth power
+	  control) of the HP Compaq TC1100 tablet.
+
+endif # X86_PLATFORM_DRIVERS_HP
diff --git a/drivers/platform/x86/hp/Makefile b/drivers/platform/x86/hp/Makefile
new file mode 100644
index 0000000000000..db1eed4cd7c7d
--- /dev/null
+++ b/drivers/platform/x86/hp/Makefile
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for linux/drivers/platform/x86/hp
+# HP x86 Platform-Specific Drivers
+#
+
+# Hewlett Packard
+obj-$(CONFIG_HP_ACCEL)		+= hp_accel.o
+obj-$(CONFIG_HP_WMI)		+= hp-wmi.o
+obj-$(CONFIG_TC1100_WMI)	+= tc1100-wmi.o
diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
similarity index 100%
rename from drivers/platform/x86/hp-wmi.c
rename to drivers/platform/x86/hp/hp-wmi.c
diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp/hp_accel.c
similarity index 99%
rename from drivers/platform/x86/hp_accel.c
rename to drivers/platform/x86/hp/hp_accel.c
index e9f852f7c27ff..6477591747cfd 100644
--- a/drivers/platform/x86/hp_accel.c
+++ b/drivers/platform/x86/hp/hp_accel.c
@@ -26,7 +26,7 @@
 #include <linux/acpi.h>
 #include <linux/i8042.h>
 #include <linux/serio.h>
-#include "../../misc/lis3lv02d/lis3lv02d.h"
+#include "../../../misc/lis3lv02d/lis3lv02d.h"
 
 /* Delayed LEDs infrastructure ------------------------------------ */
 
diff --git a/drivers/platform/x86/tc1100-wmi.c b/drivers/platform/x86/hp/tc1100-wmi.c
similarity index 100%
rename from drivers/platform/x86/tc1100-wmi.c
rename to drivers/platform/x86/hp/tc1100-wmi.c
-- 
2.39.2



