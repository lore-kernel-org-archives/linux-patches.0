Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1443F2101;
	Sat, 12 Sep 2026 07:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198083; cv=none; b=TQ0oXOjnfHGwvh3OIcTClgkcIRTdOP+yQVCeRw5egMWLN91ob7axDzcAHtPpiCBzT8uMF2/5qvADzygGd9MLTQOBWRqWw589M6thVLqVu60rCF6SwNq6CVNQxtp374q2kI0nzvy9V0jeagVv9cHnqdJX5p+a0UogpLEtsHuez/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198083; c=relaxed/simple;
	bh=FtQbEq6/GD4WNyNwS+t+ZwhAPHR9pawUfoktTnTbYDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dcGNoyccamZ9N/cNjReCm682P9dlSkJDrmqiPHk/cD54NjXPerHLbzOBIGVGwdiK9kg2K/azjZUURtlRZNCLLaJD1P/IuROfICdOSOYlYE12xYYF/JSlVqNrrVTVp2H8uO5SdZnd3+xvEmBNybDLHKZMI99NYUDHzVufy5s6g+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YD5/ss/Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YD5/ss/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121CA1F000FF;
	Sat, 12 Sep 2026 07:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198081;
	bh=Vkk8yIkD6SWE/IymouvrTHOcs6jZTF6vxCacPAZ1HZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YD5/ss/Z4DybS/ISARLDddg4HnyBiZ839hkpnTibGrQ1gPOeQ0w2Xb9kqPyFt5rT9
	 2N04F0Ub0X9lVQZIxikCqhBUClF680Th5Wv3FelUM5tKtpAccric1il3RqX1YHB4dV
	 SOzDg28vl26MybhXhPQDcrm+Wb692F0XCzvbhMzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0306/1815] platform/x86: lg-laptop: Fix LED resource handling
Date: Sat, 12 Sep 2026 08:34:16 +0200
Message-ID: <20260912065656.130646807@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/platform/x86/lg-laptop.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/lg-laptop.c b/drivers/platform/x86/lg-laptop.c
index a8f2f465ef3f9..a2db9657027e5 100644
--- a/drivers/platform/x86/lg-laptop.c
+++ b/drivers/platform/x86/lg-laptop.c
@@ -100,6 +100,7 @@ static u32 inited;
 #define INIT_SPARSE_KEYMAP      0x80
 
 static int battery_limit_use_wmbb;
+static bool kbd_backlight_available;
 static struct led_classdev kbd_backlight;
 static enum led_brightness get_kbd_backlight_level(struct device *dev);
 
@@ -214,6 +215,7 @@ static union acpi_object *lg_wmbb(struct device *dev, u32 method_id, u32 arg1, u
 static void wmi_notify(union acpi_object *obj, void *context)
 {
 	long data = (long)context;
+	unsigned int brightness;
 
 	pr_debug("event guid %li\n", data);
 	if (!obj)
@@ -224,8 +226,11 @@ static void wmi_notify(union acpi_object *obj, void *context)
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
@@ -865,8 +870,13 @@ static int acpi_probe(struct platform_device *pdev)
 		goto out_platform_device;
 
 	/* LEDs are optional */
-	led_classdev_register(&pf_device->dev, &kbd_backlight);
-	led_classdev_register(&pf_device->dev, &tpad_led);
+	ret = devm_led_classdev_register(&pdev->dev, &kbd_backlight);
+	if (ret < 0)
+		kbd_backlight_available = false;
+	else
+		kbd_backlight_available = true;
+
+	devm_led_classdev_register(&pdev->dev, &tpad_led);
 
 	wmi_input_setup();
 	battery_hook_register(&battery_hook);
@@ -884,9 +894,6 @@ static void acpi_remove(struct platform_device *pdev)
 {
 	sysfs_remove_group(&pf_device->dev.kobj, &dev_attribute_group);
 
-	led_classdev_unregister(&tpad_led);
-	led_classdev_unregister(&kbd_backlight);
-
 	battery_hook_unregister(&battery_hook);
 	wmi_input_destroy();
 	platform_device_unregister(pf_device);
-- 
2.53.0



