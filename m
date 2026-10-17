Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F11F1419A4;
	Sat, 17 Oct 2026 16:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255406; cv=none; b=GmERe0POOKPhOAi7hQAUQH1Y9NmDFhDLEXP3pLJbeh6bYGxxsUnIjHfqa5hrOjA4XazEwHpZYDbQRUFlP4Hjgz+jZcmaX6dao6eBkPVlvkj6ufY8DYSHpBTUpPUBFQEc+fADu9qxriJwsuGwNTbouBMcoxz60Xc1emC9Voj4igM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255406; c=relaxed/simple;
	bh=tIFsxX8T94p0JV5AI2LA07Exb8YSpW36/jq5vOUeV1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hGUzY5RxNFPHOpmcu2pj5ESpnhvQ4mTOJ4GGAjkUWWaUwJD0kbEndSYkfKbs5VRp+Q47nG+l9Ik26XERmbURtVmncyyIZw5ujbzl5GAcEUdZ5G3m9QQ78913Qajj+u9tqqr/lKY0jnLYYEsPZiLTnkHyqZ6HjLWCX0XFJraW4kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X1c2MA4u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1c2MA4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657761F000C4;
	Sat, 17 Oct 2026 16:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255405;
	bh=6ae+6nn6uHszDgITLcESNh7n9Pf2U8SIw++SxPYzbXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X1c2MA4udHBwJ1pgBRQ3BiEwtV64wYwG335+USvxTQwlNNLoBFbukaD219+mi4ZeB
	 MyytYQ6xQF2YWAb9+ZXz7ZSW2ksqbOuurqzUcSaPO9lZWBEBjY3ULCcKpfutAbE2+R
	 sY3O+wBbcG1pNimRe1AnjkKgzn8zNJIDfvK66+s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 748/869] gpiolib: make value setters have return values
Date: Sat, 17 Oct 2026 17:59:49 +0200
Message-ID: <20261017160056.114749824@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 8ce258f62f90cb2d339cc39fa43e5634594a9dfb ]

Change the in-kernel consumer interface for GPIOs: make all variants of
value setters that don't have a return value, return a signed integer
instead. That will allow these routines to indicate failures to callers.

This doesn't change the implementation just yet, we'll do it in
subsequent commits.

We need to update the gpio-latch module as it passes the address of
value setters as a function pointer argument and thus cares about its
type.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/r/20250220-gpio-set-retval-v2-2-bc4cfd38dae3@linaro.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: c87c9046c4e0 ("pinctrl: mediatek: paris: bypass pinctrl GPIO layer in set GPIO direction")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-latch.c     |  2 +-
 drivers/gpio/gpiolib.c        | 53 ++++++++++++++++++++---------------
 include/linux/gpio.h          |  4 +--
 include/linux/gpio/consumer.h | 22 +++++++++------
 4 files changed, 46 insertions(+), 35 deletions(-)

diff --git a/drivers/gpio/gpio-latch.c b/drivers/gpio/gpio-latch.c
index d7c3b20c8482e..e935b3b34117d 100644
--- a/drivers/gpio/gpio-latch.c
+++ b/drivers/gpio/gpio-latch.c
@@ -72,7 +72,7 @@ static int gpio_latch_get_direction(struct gpio_chip *gc, unsigned int offset)
 }
 
 static void gpio_latch_set_unlocked(struct gpio_latch_priv *priv,
-				    void (*set)(struct gpio_desc *desc, int value),
+				    int (*set)(struct gpio_desc *desc, int value),
 				    unsigned int offset, bool val)
 {
 	int latch = offset / priv->n_latched_gpios;
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 878f9ab4a0982..e73c1e1444f7d 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -3330,13 +3330,13 @@ EXPORT_SYMBOL_GPL(gpiod_get_array_value);
  * @desc: gpio descriptor whose state need to be set.
  * @value: Non-zero for setting it HIGH otherwise it will set to LOW.
  */
-static void gpio_set_open_drain_value_commit(struct gpio_desc *desc, bool value)
+static int gpio_set_open_drain_value_commit(struct gpio_desc *desc, bool value)
 {
 	int ret = 0, offset = gpio_chip_hwgpio(desc);
 
 	CLASS(gpio_chip_guard, guard)(desc);
 	if (!guard.gc)
-		return;
+		return -ENODEV;
 
 	if (value) {
 		ret = guard.gc->direction_input(guard.gc, offset);
@@ -3350,6 +3350,8 @@ static void gpio_set_open_drain_value_commit(struct gpio_desc *desc, bool value)
 		gpiod_err(desc,
 			  "%s: Error in set_value for open drain err %d\n",
 			  __func__, ret);
+
+	return ret;
 }
 
 /*
@@ -3357,13 +3359,13 @@ static void gpio_set_open_drain_value_commit(struct gpio_desc *desc, bool value)
  * @desc: gpio descriptor whose state need to be set.
  * @value: Non-zero for setting it HIGH otherwise it will set to LOW.
  */
-static void gpio_set_open_source_value_commit(struct gpio_desc *desc, bool value)
+static int gpio_set_open_source_value_commit(struct gpio_desc *desc, bool value)
 {
 	int ret = 0, offset = gpio_chip_hwgpio(desc);
 
 	CLASS(gpio_chip_guard, guard)(desc);
 	if (!guard.gc)
-		return;
+		return -ENODEV;
 
 	if (value) {
 		ret = guard.gc->direction_output(guard.gc, offset, 1);
@@ -3377,16 +3379,20 @@ static void gpio_set_open_source_value_commit(struct gpio_desc *desc, bool value
 		gpiod_err(desc,
 			  "%s: Error in set_value for open source err %d\n",
 			  __func__, ret);
+
+	return ret;
 }
 
-static void gpiod_set_raw_value_commit(struct gpio_desc *desc, bool value)
+static int gpiod_set_raw_value_commit(struct gpio_desc *desc, bool value)
 {
 	CLASS(gpio_chip_guard, guard)(desc);
 	if (!guard.gc)
-		return;
+		return -ENODEV;
 
 	trace_gpio_value(desc_to_gpio(desc), 0, value);
 	guard.gc->set(guard.gc, gpio_chip_hwgpio(desc), value);
+
+	return 0;
 }
 
 /*
@@ -3544,12 +3550,12 @@ int gpiod_set_array_value_complex(bool raw, bool can_sleep,
  * This function can be called from contexts where we cannot sleep, and will
  * complain if the GPIO chip functions potentially sleep.
  */
-void gpiod_set_raw_value(struct gpio_desc *desc, int value)
+int gpiod_set_raw_value(struct gpio_desc *desc, int value)
 {
-	VALIDATE_DESC_VOID(desc);
+	VALIDATE_DESC(desc);
 	/* Should be using gpiod_set_raw_value_cansleep() */
 	WARN_ON(desc->gdev->can_sleep);
-	gpiod_set_raw_value_commit(desc, value);
+	return gpiod_set_raw_value_commit(desc, value);
 }
 EXPORT_SYMBOL_GPL(gpiod_set_raw_value);
 
@@ -3562,16 +3568,17 @@ EXPORT_SYMBOL_GPL(gpiod_set_raw_value);
  * different semantic quirks like active low and open drain/source
  * handling.
  */
-static void gpiod_set_value_nocheck(struct gpio_desc *desc, int value)
+static int gpiod_set_value_nocheck(struct gpio_desc *desc, int value)
 {
 	if (test_bit(FLAG_ACTIVE_LOW, &desc->flags))
 		value = !value;
+
 	if (test_bit(FLAG_OPEN_DRAIN, &desc->flags))
-		gpio_set_open_drain_value_commit(desc, value);
+		return gpio_set_open_drain_value_commit(desc, value);
 	else if (test_bit(FLAG_OPEN_SOURCE, &desc->flags))
-		gpio_set_open_source_value_commit(desc, value);
-	else
-		gpiod_set_raw_value_commit(desc, value);
+		return gpio_set_open_source_value_commit(desc, value);
+
+	return gpiod_set_raw_value_commit(desc, value);
 }
 
 /**
@@ -3585,12 +3592,12 @@ static void gpiod_set_value_nocheck(struct gpio_desc *desc, int value)
  * This function can be called from contexts where we cannot sleep, and will
  * complain if the GPIO chip functions potentially sleep.
  */
-void gpiod_set_value(struct gpio_desc *desc, int value)
+int gpiod_set_value(struct gpio_desc *desc, int value)
 {
-	VALIDATE_DESC_VOID(desc);
+	VALIDATE_DESC(desc);
 	/* Should be using gpiod_set_value_cansleep() */
 	WARN_ON(desc->gdev->can_sleep);
-	gpiod_set_value_nocheck(desc, value);
+	return gpiod_set_value_nocheck(desc, value);
 }
 EXPORT_SYMBOL_GPL(gpiod_set_value);
 
@@ -4003,11 +4010,11 @@ EXPORT_SYMBOL_GPL(gpiod_get_array_value_cansleep);
  *
  * This function is to be called from contexts that can sleep.
  */
-void gpiod_set_raw_value_cansleep(struct gpio_desc *desc, int value)
+int gpiod_set_raw_value_cansleep(struct gpio_desc *desc, int value)
 {
 	might_sleep();
-	VALIDATE_DESC_VOID(desc);
-	gpiod_set_raw_value_commit(desc, value);
+	VALIDATE_DESC(desc);
+	return gpiod_set_raw_value_commit(desc, value);
 }
 EXPORT_SYMBOL_GPL(gpiod_set_raw_value_cansleep);
 
@@ -4021,11 +4028,11 @@ EXPORT_SYMBOL_GPL(gpiod_set_raw_value_cansleep);
  *
  * This function is to be called from contexts that can sleep.
  */
-void gpiod_set_value_cansleep(struct gpio_desc *desc, int value)
+int gpiod_set_value_cansleep(struct gpio_desc *desc, int value)
 {
 	might_sleep();
-	VALIDATE_DESC_VOID(desc);
-	gpiod_set_value_nocheck(desc, value);
+	VALIDATE_DESC(desc);
+	return gpiod_set_value_nocheck(desc, value);
 }
 EXPORT_SYMBOL_GPL(gpiod_set_value_cansleep);
 
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 2d105be7bbc33..8bd6e6ac98c1f 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -94,7 +94,7 @@ static inline int gpio_get_value_cansleep(unsigned gpio)
 }
 static inline void gpio_set_value_cansleep(unsigned gpio, int value)
 {
-	return gpiod_set_raw_value_cansleep(gpio_to_desc(gpio), value);
+	gpiod_set_raw_value_cansleep(gpio_to_desc(gpio), value);
 }
 
 static inline int gpio_get_value(unsigned gpio)
@@ -103,7 +103,7 @@ static inline int gpio_get_value(unsigned gpio)
 }
 static inline void gpio_set_value(unsigned gpio, int value)
 {
-	return gpiod_set_raw_value(gpio_to_desc(gpio), value);
+	gpiod_set_raw_value(gpio_to_desc(gpio), value);
 }
 
 static inline int gpio_to_irq(unsigned gpio)
diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
index db2dfbae8edbd..4a87c24686e36 100644
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -119,7 +119,7 @@ int gpiod_get_array_value(unsigned int array_size,
 			  struct gpio_desc **desc_array,
 			  struct gpio_array *array_info,
 			  unsigned long *value_bitmap);
-void gpiod_set_value(struct gpio_desc *desc, int value);
+int gpiod_set_value(struct gpio_desc *desc, int value);
 int gpiod_set_array_value(unsigned int array_size,
 			  struct gpio_desc **desc_array,
 			  struct gpio_array *array_info,
@@ -129,7 +129,7 @@ int gpiod_get_raw_array_value(unsigned int array_size,
 			      struct gpio_desc **desc_array,
 			      struct gpio_array *array_info,
 			      unsigned long *value_bitmap);
-void gpiod_set_raw_value(struct gpio_desc *desc, int value);
+int gpiod_set_raw_value(struct gpio_desc *desc, int value);
 int gpiod_set_raw_array_value(unsigned int array_size,
 			      struct gpio_desc **desc_array,
 			      struct gpio_array *array_info,
@@ -141,7 +141,7 @@ int gpiod_get_array_value_cansleep(unsigned int array_size,
 				   struct gpio_desc **desc_array,
 				   struct gpio_array *array_info,
 				   unsigned long *value_bitmap);
-void gpiod_set_value_cansleep(struct gpio_desc *desc, int value);
+int gpiod_set_value_cansleep(struct gpio_desc *desc, int value);
 int gpiod_set_array_value_cansleep(unsigned int array_size,
 				   struct gpio_desc **desc_array,
 				   struct gpio_array *array_info,
@@ -151,7 +151,7 @@ int gpiod_get_raw_array_value_cansleep(unsigned int array_size,
 				       struct gpio_desc **desc_array,
 				       struct gpio_array *array_info,
 				       unsigned long *value_bitmap);
-void gpiod_set_raw_value_cansleep(struct gpio_desc *desc, int value);
+int gpiod_set_raw_value_cansleep(struct gpio_desc *desc, int value);
 int gpiod_set_raw_array_value_cansleep(unsigned int array_size,
 				       struct gpio_desc **desc_array,
 				       struct gpio_array *array_info,
@@ -375,10 +375,11 @@ static inline int gpiod_get_array_value(unsigned int array_size,
 	WARN_ON(desc_array);
 	return 0;
 }
-static inline void gpiod_set_value(struct gpio_desc *desc, int value)
+static inline int gpiod_set_value(struct gpio_desc *desc, int value)
 {
 	/* GPIO can never have been requested */
 	WARN_ON(desc);
+	return 0;
 }
 static inline int gpiod_set_array_value(unsigned int array_size,
 					struct gpio_desc **desc_array,
@@ -404,10 +405,11 @@ static inline int gpiod_get_raw_array_value(unsigned int array_size,
 	WARN_ON(desc_array);
 	return 0;
 }
-static inline void gpiod_set_raw_value(struct gpio_desc *desc, int value)
+static inline int gpiod_set_raw_value(struct gpio_desc *desc, int value)
 {
 	/* GPIO can never have been requested */
 	WARN_ON(desc);
+	return 0;
 }
 static inline int gpiod_set_raw_array_value(unsigned int array_size,
 					    struct gpio_desc **desc_array,
@@ -434,10 +436,11 @@ static inline int gpiod_get_array_value_cansleep(unsigned int array_size,
 	WARN_ON(desc_array);
 	return 0;
 }
-static inline void gpiod_set_value_cansleep(struct gpio_desc *desc, int value)
+static inline int gpiod_set_value_cansleep(struct gpio_desc *desc, int value)
 {
 	/* GPIO can never have been requested */
 	WARN_ON(desc);
+	return 0;
 }
 static inline int gpiod_set_array_value_cansleep(unsigned int array_size,
 					    struct gpio_desc **desc_array,
@@ -463,11 +466,12 @@ static inline int gpiod_get_raw_array_value_cansleep(unsigned int array_size,
 	WARN_ON(desc_array);
 	return 0;
 }
-static inline void gpiod_set_raw_value_cansleep(struct gpio_desc *desc,
-						int value)
+static inline int gpiod_set_raw_value_cansleep(struct gpio_desc *desc,
+					       int value)
 {
 	/* GPIO can never have been requested */
 	WARN_ON(desc);
+	return 0;
 }
 static inline int gpiod_set_raw_array_value_cansleep(unsigned int array_size,
 						struct gpio_desc **desc_array,
-- 
2.53.0



