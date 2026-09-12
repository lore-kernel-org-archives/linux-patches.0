Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EDF33F59A;
	Sat, 12 Sep 2026 12:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215175; cv=none; b=KzXeG71Avwj9qQHek6sQ/7CcKPoy3Ccqg/uYFxPMVGanwZyqm39VY4R17ky+LdVtY5Z6oYAQW8VovM39QFhzkihi55XykxSRmYLdT+DQUMQDFxisZdR52jvz2yCIB4WSnMOjPxsU9UWfsHG/uj9iYrlrTwrVCKA8/l4wjRhPKms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215175; c=relaxed/simple;
	bh=jbXtWN9ndiDczWGqpjN1COJg2JSVXa6Id02uLwQSal8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lFYGLFenGDQaaRWL2CL48al/p9cmT9N+QIY5zVO0aY7mMzEJupMNGw4DxF6uAxtCQx2M7iwJs/fPiwYauy6sQ1Ihl6FYXQQZlFgYsdZU8/Xt2NCu2b3GFD9hGYtVnzuXIV9fgFgt7Hymyd3/x5a7NX8ptoYW7zARBTwQB3zN9Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nMIworXB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nMIworXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB5C1F000FF;
	Sat, 12 Sep 2026 12:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215173;
	bh=BMnYEIzj/0S1Cc9WQRn1RTe3Aesb1jc6lA8nMOtLbVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nMIworXBjJKYwSkz+MCtTg4kpRIz59EvC6Hp9HgNk7xasAgUsShjRC+KZ6U1NtnLN
	 ByY5fvxN74d1eN5RdNohvzYbhk0xrTNhpEruPLcMYnDyF59YZ543Q0on/1q4GU8e1w
	 4fEVZAKxD9x4G2j1xqlT7eMoN5pM74svEcJwRCG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0478/1376] platform/x86: lg-laptop: Fix LED resource handling
Date: Sat, 12 Sep 2026 08:48:24 +0200
Message-ID: <20260912065618.188527972@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a68c4867e696b..0a5c8f0471823 100644
--- a/drivers/platform/x86/lg-laptop.c
+++ b/drivers/platform/x86/lg-laptop.c
@@ -98,6 +98,7 @@ static u32 inited;
 #define INIT_SPARSE_KEYMAP      0x80
 
 static int battery_limit_use_wmbb;
+static bool kbd_backlight_available;
 static struct led_classdev kbd_backlight;
 static enum led_brightness get_kbd_backlight_level(struct device *dev);
 
@@ -212,6 +213,7 @@ static union acpi_object *lg_wmbb(struct device *dev, u32 method_id, u32 arg1, u
 static void wmi_notify(union acpi_object *obj, void *context)
 {
 	long data = (long)context;
+	unsigned int brightness;
 
 	pr_debug("event guid %li\n", data);
 	if (!obj)
@@ -222,8 +224,11 @@ static void wmi_notify(union acpi_object *obj, void *context)
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
@@ -840,8 +845,13 @@ static int acpi_probe(struct platform_device *pdev)
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
@@ -859,9 +869,6 @@ static void acpi_remove(struct platform_device *pdev)
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



