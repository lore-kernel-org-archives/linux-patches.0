Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C4041CB20;
	Sat, 12 Sep 2026 08:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202220; cv=none; b=hSjzUwRpg0+NtOR8zb59YQQgH5ML9DaS10alf3gD4Gl5xb4AzlcUSv0p0iymRBDtml4/02em9VY70aD2PqATOW7Kc4WwRUIjJIfP5oLO9evt5+7ggkNwYaUut7Xnm5OpRPj4q+onHcrIoMvW0oAs97UvWHPdIHNtklhIoSd19zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202220; c=relaxed/simple;
	bh=QuXyYLSt8cF4g7PEUQ6XZa7gO7uf2/kfh5RQrH+6LLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AkrC/gQm42rh7JPNigZfxsIvWKVaRosr7Or7vc5q4ssD4v81mKnM/4lA04wgdh6FZVn8VEzguTCkyB5qPWJBx7rfCcwo3mDjqr/bAtvaFVPxBcyBmuU7Lf/IjjC5PFZaldexZ6F67M+/e0WRXUgKYKoIF1ZCrH4OaeDMlMbzvj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ymlypeef; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ymlypeef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9021F000FF;
	Sat, 12 Sep 2026 08:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202217;
	bh=pymfoHnqGuhJhkGk259C4WKd15ojKfnah18C8RI2iKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ymlypeef26Tn6VcQ0N92GEjwYccGD4eZyap3a5t0CMwUe3Nyg/jXBDqYKvmZjjKB1
	 WNvv2RHok5bkLomPITzQC8NtFeWEXSqchvv2xJgY6q4WUDvwm7JAklH3HUkRtX1nMI
	 DGLYjC5uW/gRipS/ilVw6GC4XbHPHPH8iUpz8gQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.2 1158/1815] leds: gpio: Make legacy gpiolib interface optional
Date: Sat, 12 Sep 2026 08:48:28 +0200
Message-ID: <20260912065716.196499692@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 98c5c7b0d4269ecabfc86b8b49ffcfa47979e99d ]

There are still a handful of ancient mips/armv5/sh boards that use the
gpio_led:gpio member to pass an old-style gpio number, but all modern
users have been converted to gpio descriptors.

While the CONFIG_GPIOLIB_LEGACY option that guards devm_gpio_request_one()
and related helpers is currently turned on in all kernel builds,
the plan is to only enable it on the few platforms that actually
pass gpio numbers in any platform_data.

Split out the legacy portion of the platform_data handling into a custom
helper function that is guarded with in #ifdef block, to allow the
the leds-gpio driver to compile cleanly when CONFIG_GPIOLIB_LEGACY
gets turned off. Once the last user is converted, this function can
be removed.

Link: https://lore.kernel.org/all/e9252384-a55c-4a91-9c61-06e05a0b2ce4@app.fastmail.com/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com> # for input
Link: https://patch.msgid.link/20260710211854.1371746-4-arnd@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 942901eeda93 ("leds: gpio: Clear error pointers for skipped LEDs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-gpio.c | 52 +++++++++++++++++++++++++++-------------
 include/linux/leds.h     |  2 ++
 2 files changed, 37 insertions(+), 17 deletions(-)

diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index 8ae71c2e91e01..08d5a911ac259 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -9,8 +9,8 @@
 #include <linux/container_of.h>
 #include <linux/device.h>
 #include <linux/err.h>
-#include <linux/gpio.h>
 #include <linux/gpio/consumer.h>
+#include <linux/gpio/legacy.h>
 #include <linux/leds.h>
 #include <linux/module.h>
 #include <linux/overflow.h>
@@ -211,7 +211,6 @@ static struct gpio_desc *gpio_led_get_gpiod(struct device *dev, int idx,
 					    const struct gpio_led *template)
 {
 	struct gpio_desc *gpiod;
-	int ret;
 
 	/*
 	 * This means the LED does not come from the device tree
@@ -222,16 +221,29 @@ static struct gpio_desc *gpio_led_get_gpiod(struct device *dev, int idx,
 	gpiod = devm_gpiod_get_index_optional(dev, NULL, idx, GPIOD_OUT_LOW);
 	if (IS_ERR(gpiod))
 		return gpiod;
-	if (gpiod) {
-		gpiod_set_consumer_name(gpiod, template->name);
-		return gpiod;
-	}
 
-	/*
-	 * This is the legacy code path for platform code that
-	 * still uses GPIO numbers. Ultimately we would like to get
-	 * rid of this block completely.
-	 */
+	gpiod_set_consumer_name(gpiod, template->name);
+	return gpiod;
+}
+
+#ifdef CONFIG_GPIOLIB_LEGACY
+/*
+ * This is the legacy code path for platform code that still uses
+ * GPIO numbers, mainly MIPS and SuperH board files.
+ * Ultimately we would like to get rid of this block completely.
+ *
+ * ppc44x-warp sets the template->gpiod directly instead of
+ * adding a lookup table or device properties. This is not
+ * much better.
+ */
+static struct gpio_desc *gpio_led_get_legacy_gpiod(struct device *dev, int idx,
+						   const struct gpio_led *template)
+{
+	struct gpio_desc *gpiod;
+	int ret;
+
+	if (template->gpiod)
+		return template->gpiod;
 
 	/* skip leds that aren't available */
 	if (!gpio_is_valid(template->gpio))
@@ -251,6 +263,13 @@ static struct gpio_desc *gpio_led_get_gpiod(struct device *dev, int idx,
 
 	return gpiod;
 }
+#else
+static struct gpio_desc *gpio_led_get_legacy_gpiod(struct device *dev, int idx,
+						   const struct gpio_led *template)
+{
+	return template->gpiod ?: ERR_PTR(-ENOENT);
+}
+#endif
 
 static int gpio_led_probe(struct platform_device *pdev)
 {
@@ -269,14 +288,13 @@ static int gpio_led_probe(struct platform_device *pdev)
 			const struct gpio_led *template = &pdata->leds[i];
 			struct gpio_led_data *led_dat = &priv->leds[i];
 
-			if (template->gpiod)
-				led_dat->gpiod = template->gpiod;
-			else
+			led_dat->gpiod = gpio_led_get_gpiod(dev, i, template);
+			if (!led_dat->gpiod)
 				led_dat->gpiod =
-					gpio_led_get_gpiod(dev, i, template);
+					 gpio_led_get_legacy_gpiod(dev, i, template);
 			if (IS_ERR(led_dat->gpiod)) {
-				dev_info(dev, "Skipping unavailable LED gpio %d (%s)\n",
-					 template->gpio, template->name);
+				dev_info(dev, "Skipping unavailable LED gpio %s\n",
+					 template->name);
 				continue;
 			}
 
diff --git a/include/linux/leds.h b/include/linux/leds.h
index b16b803cc1ac5..e646bffcd8e74 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -676,8 +676,10 @@ typedef int (*gpio_blink_set_t)(struct gpio_desc *desc, int state,
 struct gpio_led {
 	const char *name;
 	const char *default_trigger;
+#ifdef CONFIG_GPIOLIB_LEGACY
 	unsigned 	gpio;
 	unsigned	active_low : 1;
+#endif
 	unsigned	retain_state_suspended : 1;
 	unsigned	panic_indicator : 1;
 	unsigned	default_state : 2;
-- 
2.53.0



