Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328531DF274;
	Tue,  8 Oct 2024 13:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394145; cv=none; b=h05u3Kb8sfC/CMNDk70Cr+UFolYX5heF0z/rju+FOtn6xVgvcxcLjSPNh5e8qv/0od2fn6wktAYR86H+7oREhFhThQ5+tjyze4gMXRXTKTU/TNkSzaPY/qV0NPzZkUW8ZGYfVaAmz5O/CKSfWn38XpiXoF+iMvdvT8m4prCFlY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394145; c=relaxed/simple;
	bh=HvgmKTEIT3IR5ABgTm/S+hjKaBJNJX7JG1SVRcECGG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEnUEKeWAh1dwvZ761No4465mlVCsVrgGC4/2PhyPUFqGgTkPNLifxUhok9jI/s0t/fQJf1Io1nZa12pnjiDE3HB+VkFdvBMHTMH/xAFDlbjXnLSkbVWXtruV9DwVQH5PpFdmCyyuh+HnlaV55aPAT2CTnE/GQ9UomIjUoQYOro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M5urBBSG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M5urBBSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985E6C4CEC7;
	Tue,  8 Oct 2024 13:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394145;
	bh=HvgmKTEIT3IR5ABgTm/S+hjKaBJNJX7JG1SVRcECGG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M5urBBSGhSjLhSdzLlNn8oVG/BlTpDunoTN5W/YbjXal8BJblyOGIHrWp/2YJdC3Z
	 NqjNxYNO9G8EcyJv66TwdACOvV4YozMYNhIcZPph/sTT/AcHvamLcrAnHrrhDnBNi4
	 Wmat/h8Jjoex/LkFKI1fvHYBwTh7RVJqE1Tmlt7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 329/386] platform/x86: x86-android-tablets: Create a platform_device from module_init()
Date: Tue,  8 Oct 2024 14:09:34 +0200
Message-ID: <20241008115642.332491307@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 8b57d33a6fdbb53d03da762b31e65a1027f74caf ]

Create a platform_device from module_init() and change
x86_android_tablet_init() / cleanup() into platform_device
probe() and remove() functions.

This is a preparation patch for refactoring x86_android_tablet_get_gpiod()
to no longer use gpiolib private functions like gpiochip_find().

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20230909141816.58358-6-hdegoede@redhat.com
Stable-dep-of: 2fae3129c0c0 ("platform/x86: x86-android-tablets: Fix use after free on platform_device_register() errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/x86/x86-android-tablets/core.c   | 51 ++++++++++++++-----
 1 file changed, 38 insertions(+), 13 deletions(-)

diff --git a/drivers/platform/x86/x86-android-tablets/core.c b/drivers/platform/x86/x86-android-tablets/core.c
index 2fd6060a31bb0..ebfd9a3dac957 100644
--- a/drivers/platform/x86/x86-android-tablets/core.c
+++ b/drivers/platform/x86/x86-android-tablets/core.c
@@ -25,6 +25,8 @@
 #include "../../../gpio/gpiolib.h"
 #include "../../../gpio/gpiolib-acpi.h"
 
+static struct platform_device *x86_android_tablet_device;
+
 static int gpiochip_find_match_label(struct gpio_chip *gc, void *data)
 {
 	return gc->label && !strcmp(gc->label, data);
@@ -224,7 +226,7 @@ static __init int x86_instantiate_serdev(const struct x86_serdev_info *info, int
 	return ret;
 }
 
-static void x86_android_tablet_cleanup(void)
+static void x86_android_tablet_remove(struct platform_device *pdev)
 {
 	int i;
 
@@ -255,7 +257,7 @@ static void x86_android_tablet_cleanup(void)
 	software_node_unregister(bat_swnode);
 }
 
-static __init int x86_android_tablet_init(void)
+static __init int x86_android_tablet_probe(struct platform_device *pdev)
 {
 	const struct x86_dev_info *dev_info;
 	const struct dmi_system_id *id;
@@ -267,6 +269,8 @@ static __init int x86_android_tablet_init(void)
 		return -ENODEV;
 
 	dev_info = id->driver_data;
+	/* Allow x86_android_tablet_device use before probe() exits */
+	x86_android_tablet_device = pdev;
 
 	/*
 	 * The broken DSDTs on these devices often also include broken
@@ -303,7 +307,7 @@ static __init int x86_android_tablet_init(void)
 	if (dev_info->init) {
 		ret = dev_info->init();
 		if (ret < 0) {
-			x86_android_tablet_cleanup();
+			x86_android_tablet_remove(pdev);
 			return ret;
 		}
 		exit_handler = dev_info->exit;
@@ -311,7 +315,7 @@ static __init int x86_android_tablet_init(void)
 
 	i2c_clients = kcalloc(dev_info->i2c_client_count, sizeof(*i2c_clients), GFP_KERNEL);
 	if (!i2c_clients) {
-		x86_android_tablet_cleanup();
+		x86_android_tablet_remove(pdev);
 		return -ENOMEM;
 	}
 
@@ -319,7 +323,7 @@ static __init int x86_android_tablet_init(void)
 	for (i = 0; i < i2c_client_count; i++) {
 		ret = x86_instantiate_i2c_client(dev_info, i);
 		if (ret < 0) {
-			x86_android_tablet_cleanup();
+			x86_android_tablet_remove(pdev);
 			return ret;
 		}
 	}
@@ -327,7 +331,7 @@ static __init int x86_android_tablet_init(void)
 	/* + 1 to make space for (optional) gpio_keys_button pdev */
 	pdevs = kcalloc(dev_info->pdev_count + 1, sizeof(*pdevs), GFP_KERNEL);
 	if (!pdevs) {
-		x86_android_tablet_cleanup();
+		x86_android_tablet_remove(pdev);
 		return -ENOMEM;
 	}
 
@@ -335,14 +339,14 @@ static __init int x86_android_tablet_init(void)
 	for (i = 0; i < pdev_count; i++) {
 		pdevs[i] = platform_device_register_full(&dev_info->pdev_info[i]);
 		if (IS_ERR(pdevs[i])) {
-			x86_android_tablet_cleanup();
+			x86_android_tablet_remove(pdev);
 			return PTR_ERR(pdevs[i]);
 		}
 	}
 
 	serdevs = kcalloc(dev_info->serdev_count, sizeof(*serdevs), GFP_KERNEL);
 	if (!serdevs) {
-		x86_android_tablet_cleanup();
+		x86_android_tablet_remove(pdev);
 		return -ENOMEM;
 	}
 
@@ -350,7 +354,7 @@ static __init int x86_android_tablet_init(void)
 	for (i = 0; i < serdev_count; i++) {
 		ret = x86_instantiate_serdev(&dev_info->serdev_info[i], i);
 		if (ret < 0) {
-			x86_android_tablet_cleanup();
+			x86_android_tablet_remove(pdev);
 			return ret;
 		}
 	}
@@ -361,7 +365,7 @@ static __init int x86_android_tablet_init(void)
 
 		buttons = kcalloc(dev_info->gpio_button_count, sizeof(*buttons), GFP_KERNEL);
 		if (!buttons) {
-			x86_android_tablet_cleanup();
+			x86_android_tablet_remove(pdev);
 			return -ENOMEM;
 		}
 
@@ -369,7 +373,7 @@ static __init int x86_android_tablet_init(void)
 			ret = x86_android_tablet_get_gpiod(dev_info->gpio_button[i].chip,
 							   dev_info->gpio_button[i].pin, &gpiod);
 			if (ret < 0) {
-				x86_android_tablet_cleanup();
+				x86_android_tablet_remove(pdev);
 				return ret;
 			}
 
@@ -384,7 +388,7 @@ static __init int x86_android_tablet_init(void)
 								  PLATFORM_DEVID_AUTO,
 								  &pdata, sizeof(pdata));
 		if (IS_ERR(pdevs[pdev_count])) {
-			x86_android_tablet_cleanup();
+			x86_android_tablet_remove(pdev);
 			return PTR_ERR(pdevs[pdev_count]);
 		}
 		pdev_count++;
@@ -393,8 +397,29 @@ static __init int x86_android_tablet_init(void)
 	return 0;
 }
 
+static struct platform_driver x86_android_tablet_driver = {
+	.driver = {
+		.name = KBUILD_MODNAME,
+	},
+	.remove_new = x86_android_tablet_remove,
+};
+
+static int __init x86_android_tablet_init(void)
+{
+	x86_android_tablet_device = platform_create_bundle(&x86_android_tablet_driver,
+						   x86_android_tablet_probe,
+						   NULL, 0, NULL, 0);
+
+	return PTR_ERR_OR_ZERO(x86_android_tablet_device);
+}
 module_init(x86_android_tablet_init);
-module_exit(x86_android_tablet_cleanup);
+
+static void __exit x86_android_tablet_exit(void)
+{
+	platform_device_unregister(x86_android_tablet_device);
+	platform_driver_unregister(&x86_android_tablet_driver);
+}
+module_exit(x86_android_tablet_exit);
 
 MODULE_AUTHOR("Hans de Goede <hdegoede@redhat.com>");
 MODULE_DESCRIPTION("X86 Android tablets DSDT fixups driver");
-- 
2.43.0



