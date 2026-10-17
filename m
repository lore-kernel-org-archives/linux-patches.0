Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A1F3A7D63;
	Sat, 17 Oct 2026 18:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260264; cv=none; b=SkRQKIrnhbzEWdJd8UTc6/phgkm41XRU1Y1cVcVAjpB2MVjxxjVSMiCo3NHAcEL0rLphDrMkqSeGNlzgTszUWZ9sxWvZRJTxBp6+4+bn37LTVCFN5rycHvos4VeTwWu9Gdv0/2EmmTzLifoYaCfGvioHtvJxKD9i/uxmAP23gL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260264; c=relaxed/simple;
	bh=EzLw98H2zRMA0+WMuI0jB7gxJT1e8DmLj3JWkx5nd7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mSWX6Puc0BdOB9TJdJLopsJ+1bjwdr2dUPfNNiMx6pluwrSMnNeD6O7/duzeXj/HpQvSC3kq5pUOvQsuxY/tx+ukZnCNZ/GkytcHmMAcJ2LDXOqDank72lqk1QSfTPsclIT4XhDhPjttKRdQ1Rk+R3e12GAOKZ8mFds+9bRVvMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fgY7nh7a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fgY7nh7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CBC1F000C4;
	Sat, 17 Oct 2026 18:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260263;
	bh=QUtSmGrvPGHn/iCrFiIWkaqL5CMfSYWrPyLPugpDA5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fgY7nh7a++93aoW5iT9mGK0NslHUM9dHP0wwTJA0/9j0+HClL8yPx+j5Dzd3ZEAoR
	 W+N70OAJqudVlVvrKv0qP1x98AMVyKVtaAsQQJBLYlYaZHjqExyh7JAwVHi8eJa/UX
	 uCpSHiYXR7antvOyPkaHxMuknDDG6Zi8RTR2gvJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1486/1674] platform/x86: lg-laptop: Fix LED resource handling
Date: Sat, 17 Oct 2026 18:02:38 +0200
Message-ID: <20261017160509.291289750@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 3e91964aa74ab261aa15d9d96318eded2fd9d22a ]

The event notification callback might access kbd_backlight even
when it was not successfully registered with the LED subsystem.
The same happens inside acpi_remove(), where the LED devices are
unregistered unconditionally.

Fix this by tracking the availability of the kbd_backlight LED
device and use devm_led_classdev_register() to let devres take
care of unregistering the LED devices during removal. For this
the parent device of the LED devices is changed to the native
platform device.

Fixes: ae26278829a8 ("platform/x86: lg-laptop: Use correct event for keyboard backlight FN-key")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20260708195553.7762-2-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/lg-laptop.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/lg-laptop.c b/drivers/platform/x86/lg-laptop.c
index 78c48a1f9c68a..16c37634925d0 100644
--- a/drivers/platform/x86/lg-laptop.c
+++ b/drivers/platform/x86/lg-laptop.c
@@ -71,6 +71,8 @@ static u32 inited;
 #define INIT_SPARSE_KEYMAP      0x80
 
 static int battery_limit_use_wmbb;
+static bool kbd_backlight_available;
+static bool tpad_led_available;
 static struct led_classdev kbd_backlight;
 static enum led_brightness get_kbd_backlight_level(struct device *dev);
 
@@ -188,6 +190,7 @@ static void wmi_notify(u32 value, void *context)
 	union acpi_object *obj;
 	acpi_status status;
 	long data = (long)context;
+	unsigned int brightness;
 
 	pr_debug("event guid %li\n", data);
 	status = wmi_get_event_data(value, &response);
@@ -205,8 +208,11 @@ static void wmi_notify(u32 value, void *context)
 		struct key_entry *key;
 
 		if (eventcode == 0x10000000) {
-			led_classdev_notify_brightness_hw_changed(
-				&kbd_backlight, get_kbd_backlight_level(kbd_backlight.dev->parent));
+			if (kbd_backlight_available) {
+				brightness = get_kbd_backlight_level(kbd_backlight.dev->parent);
+				led_classdev_notify_brightness_hw_changed(&kbd_backlight,
+									  brightness);
+			}
 		} else {
 			key = sparse_keymap_entry_from_scancode(
 				wmi_input_dev, eventcode);
@@ -725,8 +731,11 @@ static int acpi_add(struct acpi_device *device)
 		goto out_platform_device;
 
 	/* LEDs are optional */
-	led_classdev_register(&pf_device->dev, &kbd_backlight);
-	led_classdev_register(&pf_device->dev, &tpad_led);
+	ret = led_classdev_register(&pf_device->dev, &kbd_backlight);
+	kbd_backlight_available = !ret;
+
+	ret = led_classdev_register(&pf_device->dev, &tpad_led);
+	tpad_led_available = !ret;
 
 	wmi_input_setup();
 	battery_hook_register(&battery_hook);
@@ -744,11 +753,16 @@ static void acpi_remove(struct acpi_device *device)
 {
 	sysfs_remove_group(&pf_device->dev.kobj, &dev_attribute_group);
 
-	led_classdev_unregister(&tpad_led);
-	led_classdev_unregister(&kbd_backlight);
-
 	battery_hook_unregister(&battery_hook);
 	wmi_input_destroy();
+
+	if (tpad_led_available)
+		led_classdev_unregister(&tpad_led);
+	if (kbd_backlight_available) {
+		kbd_backlight_available = false;
+		led_classdev_unregister(&kbd_backlight);
+	}
+
 	platform_device_unregister(pf_device);
 	pf_device = NULL;
 	platform_driver_unregister(&pf_driver);
-- 
2.53.0



