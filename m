Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A132938DD8;
	Mon, 24 Feb 2025 15:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409213; cv=none; b=lkU8hUnGNShRvOUiBwrqVNeeBhYufoQ+Y1B8da+W1K1ofhKH6TN8QgcczWHbXXwWJ8e6ZQv9eQjhIWwwMELS8JCPKUNy/SOrn8QitTGXMCCcYd2fq7xweF/4r6nAJ/rI0XeKEr8u4eZwsLGH4/TnFOqm2pA/Xnj7LLLZAM4GEKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409213; c=relaxed/simple;
	bh=tCOvXfhhMJNl0c6YP4a5Ttnf56LKr7WS1shAxLavZpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JthNNHxmK0G+UipVAQzajgczXZpY7s9umXqi9CtnqWsQ8KmAiPRtyvKi/CTx4fwt8FZz0SADoSGefbpqD4sxThcWqI04cV5iL+RdLQwj0rEDOlxJOX+LmF1JTuaGhwucaF24MQcGIZIBgiXHMUFzAKo3SmaAH93AaC5HKTlFkUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7GMXyNm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7GMXyNm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A33C4CEE8;
	Mon, 24 Feb 2025 15:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409213;
	bh=tCOvXfhhMJNl0c6YP4a5Ttnf56LKr7WS1shAxLavZpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7GMXyNmWV+/D/VQOragDGLARUK9VmwKvw6RDSVdcQ4WzwPXmfvb6kXHErZP1xOyA
	 l3tCeIz41IrVWXhAryc7ts7pZeV1ALtGgOfKwjxG27yhV+V33L4RmAQJlEJm8E5FKZ
	 tNvyu0/TCfaxguYliv6TXlZ/K25rWK5T8ODmOLus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.13 098/138] gpiolib: protect gpio_chip with SRCU in array_info paths in multi get/set
Date: Mon, 24 Feb 2025 15:35:28 +0100
Message-ID: <20250224142608.331187545@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

commit 81570d6a7ad37033c7895811551a5a9023706eda upstream.

During the locking rework in GPIOLIB, we omitted one important use-case,
namely: setting and getting values for GPIO descriptor arrays with
array_info present.

This patch does two things: first it makes struct gpio_array store the
address of the underlying GPIO device and not chip. Next: it protects
the chip with SRCU from removal in gpiod_get_array_value_complex() and
gpiod_set_array_value_complex().

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250215095655.23152-1-brgl@bgdev.pl
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib.c |   48 +++++++++++++++++++++++++++++++++---------------
 drivers/gpio/gpiolib.h |    4 ++--
 2 files changed, 35 insertions(+), 17 deletions(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -3143,6 +3143,8 @@ static int gpiod_get_raw_value_commit(co
 static int gpio_chip_get_multiple(struct gpio_chip *gc,
 				  unsigned long *mask, unsigned long *bits)
 {
+	lockdep_assert_held(&gc->gpiodev->srcu);
+
 	if (gc->get_multiple)
 		return gc->get_multiple(gc, mask, bits);
 	if (gc->get) {
@@ -3173,6 +3175,7 @@ int gpiod_get_array_value_complex(bool r
 				  struct gpio_array *array_info,
 				  unsigned long *value_bitmap)
 {
+	struct gpio_chip *gc;
 	int ret, i = 0;
 
 	/*
@@ -3184,10 +3187,15 @@ int gpiod_get_array_value_complex(bool r
 	    array_size <= array_info->size &&
 	    (void *)array_info == desc_array + array_info->size) {
 		if (!can_sleep)
-			WARN_ON(array_info->chip->can_sleep);
+			WARN_ON(array_info->gdev->can_sleep);
 
-		ret = gpio_chip_get_multiple(array_info->chip,
-					     array_info->get_mask,
+		guard(srcu)(&array_info->gdev->srcu);
+		gc = srcu_dereference(array_info->gdev->chip,
+				      &array_info->gdev->srcu);
+		if (!gc)
+			return -ENODEV;
+
+		ret = gpio_chip_get_multiple(gc, array_info->get_mask,
 					     value_bitmap);
 		if (ret)
 			return ret;
@@ -3468,6 +3476,8 @@ static void gpiod_set_raw_value_commit(s
 static void gpio_chip_set_multiple(struct gpio_chip *gc,
 				   unsigned long *mask, unsigned long *bits)
 {
+	lockdep_assert_held(&gc->gpiodev->srcu);
+
 	if (gc->set_multiple) {
 		gc->set_multiple(gc, mask, bits);
 	} else {
@@ -3485,6 +3495,7 @@ int gpiod_set_array_value_complex(bool r
 				  struct gpio_array *array_info,
 				  unsigned long *value_bitmap)
 {
+	struct gpio_chip *gc;
 	int i = 0;
 
 	/*
@@ -3496,14 +3507,19 @@ int gpiod_set_array_value_complex(bool r
 	    array_size <= array_info->size &&
 	    (void *)array_info == desc_array + array_info->size) {
 		if (!can_sleep)
-			WARN_ON(array_info->chip->can_sleep);
+			WARN_ON(array_info->gdev->can_sleep);
+
+		guard(srcu)(&array_info->gdev->srcu);
+		gc = srcu_dereference(array_info->gdev->chip,
+				      &array_info->gdev->srcu);
+		if (!gc)
+			return -ENODEV;
 
 		if (!raw && !bitmap_empty(array_info->invert_mask, array_size))
 			bitmap_xor(value_bitmap, value_bitmap,
 				   array_info->invert_mask, array_size);
 
-		gpio_chip_set_multiple(array_info->chip, array_info->set_mask,
-				       value_bitmap);
+		gpio_chip_set_multiple(gc, array_info->set_mask, value_bitmap);
 
 		i = find_first_zero_bit(array_info->set_mask, array_size);
 		if (i == array_size)
@@ -4765,9 +4781,10 @@ struct gpio_descs *__must_check gpiod_ge
 {
 	struct gpio_desc *desc;
 	struct gpio_descs *descs;
+	struct gpio_device *gdev;
 	struct gpio_array *array_info = NULL;
-	struct gpio_chip *gc;
 	int count, bitmap_size;
+	unsigned long dflags;
 	size_t descs_size;
 
 	count = gpiod_count(dev, con_id);
@@ -4788,7 +4805,7 @@ struct gpio_descs *__must_check gpiod_ge
 
 		descs->desc[descs->ndescs] = desc;
 
-		gc = gpiod_to_chip(desc);
+		gdev = gpiod_to_gpio_device(desc);
 		/*
 		 * If pin hardware number of array member 0 is also 0, select
 		 * its chip as a candidate for fast bitmap processing path.
@@ -4796,8 +4813,8 @@ struct gpio_descs *__must_check gpiod_ge
 		if (descs->ndescs == 0 && gpio_chip_hwgpio(desc) == 0) {
 			struct gpio_descs *array;
 
-			bitmap_size = BITS_TO_LONGS(gc->ngpio > count ?
-						    gc->ngpio : count);
+			bitmap_size = BITS_TO_LONGS(gdev->ngpio > count ?
+						    gdev->ngpio : count);
 
 			array = krealloc(descs, descs_size +
 					 struct_size(array_info, invert_mask, 3 * bitmap_size),
@@ -4817,7 +4834,7 @@ struct gpio_descs *__must_check gpiod_ge
 
 			array_info->desc = descs->desc;
 			array_info->size = count;
-			array_info->chip = gc;
+			array_info->gdev = gdev;
 			bitmap_set(array_info->get_mask, descs->ndescs,
 				   count - descs->ndescs);
 			bitmap_set(array_info->set_mask, descs->ndescs,
@@ -4830,7 +4847,7 @@ struct gpio_descs *__must_check gpiod_ge
 			continue;
 
 		/* Unmark array members which don't belong to the 'fast' chip */
-		if (array_info->chip != gc) {
+		if (array_info->gdev != gdev) {
 			__clear_bit(descs->ndescs, array_info->get_mask);
 			__clear_bit(descs->ndescs, array_info->set_mask);
 		}
@@ -4853,9 +4870,10 @@ struct gpio_descs *__must_check gpiod_ge
 					    array_info->set_mask);
 			}
 		} else {
+			dflags = READ_ONCE(desc->flags);
 			/* Exclude open drain or open source from fast output */
-			if (gpiochip_line_is_open_drain(gc, descs->ndescs) ||
-			    gpiochip_line_is_open_source(gc, descs->ndescs))
+			if (test_bit(FLAG_OPEN_DRAIN, &dflags) ||
+			    test_bit(FLAG_OPEN_SOURCE, &dflags))
 				__clear_bit(descs->ndescs,
 					    array_info->set_mask);
 			/* Identify 'fast' pins which require invertion */
@@ -4867,7 +4885,7 @@ struct gpio_descs *__must_check gpiod_ge
 	if (array_info)
 		dev_dbg(dev,
 			"GPIO array info: chip=%s, size=%d, get_mask=%lx, set_mask=%lx, invert_mask=%lx\n",
-			array_info->chip->label, array_info->size,
+			array_info->gdev->label, array_info->size,
 			*array_info->get_mask, *array_info->set_mask,
 			*array_info->invert_mask);
 	return descs;
--- a/drivers/gpio/gpiolib.h
+++ b/drivers/gpio/gpiolib.h
@@ -114,7 +114,7 @@ extern const char *const gpio_suffixes[]
  *
  * @desc:		Array of pointers to the GPIO descriptors
  * @size:		Number of elements in desc
- * @chip:		Parent GPIO chip
+ * @gdev:		Parent GPIO device
  * @get_mask:		Get mask used in fastpath
  * @set_mask:		Set mask used in fastpath
  * @invert_mask:	Invert mask used in fastpath
@@ -126,7 +126,7 @@ extern const char *const gpio_suffixes[]
 struct gpio_array {
 	struct gpio_desc	**desc;
 	unsigned int		size;
-	struct gpio_chip	*chip;
+	struct gpio_device	*gdev;
 	unsigned long		*get_mask;
 	unsigned long		*set_mask;
 	unsigned long		invert_mask[];


