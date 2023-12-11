Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C71C8C8;
	Mon, 11 Dec 2023 18:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XJMM+CE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAD2C433C7;
	Mon, 11 Dec 2023 18:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320392;
	bh=gTvSsQnLF3WUdOGZytcXsOKFCFyuI4Our9Nt/meLQqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XJMM+CE/HRdh9v5z4osj+IzGTS2FuMhHb32gBKzJ56kvjcRd6vMsYTAJzB2KtSCCO
	 6Lt6tLwIM3QIJ8FggFHYx/hG0kLxr+MJ/tc4DkUznjPQmlf++HJQd/TAmrZA/4uIIa
	 NUMSBz/Q5VmMwUV/kpinhqHinK+JPP/uKJLt0f78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <linux@rempel-privat.de>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/194] platform/x86: asus-wmi: Move i8042 filter install to shared asus-wmi code
Date: Mon, 11 Dec 2023 19:20:07 +0100
Message-ID: <20231211182037.375773951@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit b52cbca22cbf6c9d2700c1e576d0ddcc670e49d5 ]

asus-nb-wmi calls i8042_install_filter() in some cases, but it never
calls i8042_remove_filter(). This means that a dangling pointer to
the filter function is left after rmmod leading to crashes.

Fix this by moving the i8042-filter installation to the shared
asus-wmi code and also remove it from the shared code on driver unbind.

Fixes: b5643539b825 ("platform/x86: asus-wmi: Filter buggy scan codes on ASUS Q500A")
Cc: Oleksij Rempel <linux@rempel-privat.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20231120154235.610808-2-hdegoede@redhat.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/Kconfig       |  2 +-
 drivers/platform/x86/asus-nb-wmi.c | 11 -----------
 drivers/platform/x86/asus-wmi.c    |  8 ++++++++
 3 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 1396a839dd8a4..d5acef3202dad 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -271,6 +271,7 @@ config ASUS_WMI
 	depends on RFKILL || RFKILL = n
 	depends on HOTPLUG_PCI
 	depends on ACPI_VIDEO || ACPI_VIDEO = n
+	depends on SERIO_I8042 || SERIO_I8042 = n
 	select INPUT_SPARSEKMAP
 	select LEDS_CLASS
 	select NEW_LEDS
@@ -287,7 +288,6 @@ config ASUS_WMI
 config ASUS_NB_WMI
 	tristate "Asus Notebook WMI Driver"
 	depends on ASUS_WMI
-	depends on SERIO_I8042 || SERIO_I8042 = n
 	help
 	  This is a driver for newer Asus notebooks. It adds extra features
 	  like wireless radio and bluetooth control, leds, hotkeys, backlight...
diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index df1db54d4e183..af3da303e2b15 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -501,8 +501,6 @@ static const struct dmi_system_id asus_quirks[] = {
 
 static void asus_nb_wmi_quirks(struct asus_wmi_driver *driver)
 {
-	int ret;
-
 	quirks = &quirk_asus_unknown;
 	dmi_check_system(asus_quirks);
 
@@ -517,15 +515,6 @@ static void asus_nb_wmi_quirks(struct asus_wmi_driver *driver)
 
 	if (tablet_mode_sw != -1)
 		quirks->tablet_switch_mode = tablet_mode_sw;
-
-	if (quirks->i8042_filter) {
-		ret = i8042_install_filter(quirks->i8042_filter);
-		if (ret) {
-			pr_warn("Unable to install key filter\n");
-			return;
-		}
-		pr_info("Using i8042 filter function for receiving events\n");
-	}
 }
 
 static const struct key_entry asus_nb_wmi_keymap[] = {
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 49dd55b8e8faf..296150eaef929 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -3839,6 +3839,12 @@ static int asus_wmi_add(struct platform_device *pdev)
 		goto fail_wmi_handler;
 	}
 
+	if (asus->driver->quirks->i8042_filter) {
+		err = i8042_install_filter(asus->driver->quirks->i8042_filter);
+		if (err)
+			pr_warn("Unable to install key filter - %d\n", err);
+	}
+
 	asus_wmi_battery_init(asus);
 
 	asus_wmi_debugfs_init(asus);
@@ -3873,6 +3879,8 @@ static int asus_wmi_remove(struct platform_device *device)
 	struct asus_wmi *asus;
 
 	asus = platform_get_drvdata(device);
+	if (asus->driver->quirks->i8042_filter)
+		i8042_remove_filter(asus->driver->quirks->i8042_filter);
 	wmi_remove_notify_handler(asus->driver->event_guid);
 	asus_wmi_backlight_exit(asus);
 	asus_wmi_input_exit(asus);
-- 
2.42.0



