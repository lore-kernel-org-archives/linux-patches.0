Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679F31514CC;
	Mon, 24 Feb 2025 14:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408635; cv=none; b=V4CpokexqQjDDoqo5cF/O1M6ktkmDHKwMk+8yoREzr/BU/AAnYeqn2JjJdVyyCOHueYA9+/m7XQ7WYI+gyyjhGmArNe8YIlT/ygax/ioGVRWlKLTzz3nFcBEucWQOomiNAJoatZ57fYdf9z2yNnP7QOdop4E3+H49K/T1OV1Hhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408635; c=relaxed/simple;
	bh=Cl5VF84Nl9JGwYpSGq7mB1WZZQpYKtut27aJf47tkYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqm9G7AqQPpc5fYcrj1qEx6xD7fq7iaDiCrcSTD67FhBllRvGhGm+4Hr4DtJz6oFtUc31RLnVuw58WaTAX4LWX/rkYVSaEleLhd6o6Xh21VIF1RRJrJNDhT/09ow7HnOH/LtSsa3EQ4CTG8hNpffjRU1TuuIEw+KGotsHklH92E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1E2D5rRy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1E2D5rRy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66AFC4CED6;
	Mon, 24 Feb 2025 14:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408635;
	bh=Cl5VF84Nl9JGwYpSGq7mB1WZZQpYKtut27aJf47tkYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1E2D5rRyw9e+sSu/SF2XHNB/b5XzwgqPX0DmrLTS0LOrRbP9md3L1Pnt9MJgm/8GP
	 qQdQ93XYTC9Bb4bXJoEvfVNJi+Og8rMAd+Cq7Gkd4bnJqnYZsoHYw3n0Sjv7Q5gSKI
	 1dJsQfs2GlWt+T4nHLU1P38P1YXLwyGv+uGWlEro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.12 115/154] gpiolib: protect gpio_chip with SRCU in array_info paths in multi get/set
Date: Mon, 24 Feb 2025 15:35:14 +0100
Message-ID: <20250224142611.560607260@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3082,6 +3082,8 @@ static int gpiod_get_raw_value_commit(co
 static int gpio_chip_get_multiple(struct gpio_chip *gc,
 				  unsigned long *mask, unsigned long *bits)
 {
+	lockdep_assert_held(&gc->gpiodev->srcu);
+
 	if (gc->get_multiple)
 		return gc->get_multiple(gc, mask, bits);
 	if (gc->get) {
@@ -3112,6 +3114,7 @@ int gpiod_get_array_value_complex(bool r
 				  struct gpio_array *array_info,
 				  unsigned long *value_bitmap)
 {
+	struct gpio_chip *gc;
 	int ret, i = 0;
 
 	/*
@@ -3123,10 +3126,15 @@ int gpiod_get_array_value_complex(bool r
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
@@ -3407,6 +3415,8 @@ static void gpiod_set_raw_value_commit(s
 static void gpio_chip_set_multiple(struct gpio_chip *gc,
 				   unsigned long *mask, unsigned long *bits)
 {
+	lockdep_assert_held(&gc->gpiodev->srcu);
+
 	if (gc->set_multiple) {
 		gc->set_multiple(gc, mask, bits);
 	} else {
@@ -3424,6 +3434,7 @@ int gpiod_set_array_value_complex(bool r
 				  struct gpio_array *array_info,
 				  unsigned long *value_bitmap)
 {
+	struct gpio_chip *gc;
 	int i = 0;
 
 	/*
@@ -3435,14 +3446,19 @@ int gpiod_set_array_value_complex(bool r
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
@@ -4698,9 +4714,10 @@ struct gpio_descs *__must_check gpiod_ge
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
@@ -4721,7 +4738,7 @@ struct gpio_descs *__must_check gpiod_ge
 
 		descs->desc[descs->ndescs] = desc;
 
-		gc = gpiod_to_chip(desc);
+		gdev = gpiod_to_gpio_device(desc);
 		/*
 		 * If pin hardware number of array member 0 is also 0, select
 		 * its chip as a candidate for fast bitmap processing path.
@@ -4729,8 +4746,8 @@ struct gpio_descs *__must_check gpiod_ge
 		if (descs->ndescs == 0 && gpio_chip_hwgpio(desc) == 0) {
 			struct gpio_descs *array;
 
-			bitmap_size = BITS_TO_LONGS(gc->ngpio > count ?
-						    gc->ngpio : count);
+			bitmap_size = BITS_TO_LONGS(gdev->ngpio > count ?
+						    gdev->ngpio : count);
 
 			array = krealloc(descs, descs_size +
 					 struct_size(array_info, invert_mask, 3 * bitmap_size),
@@ -4750,7 +4767,7 @@ struct gpio_descs *__must_check gpiod_ge
 
 			array_info->desc = descs->desc;
 			array_info->size = count;
-			array_info->chip = gc;
+			array_info->gdev = gdev;
 			bitmap_set(array_info->get_mask, descs->ndescs,
 				   count - descs->ndescs);
 			bitmap_set(array_info->set_mask, descs->ndescs,
@@ -4763,7 +4780,7 @@ struct gpio_descs *__must_check gpiod_ge
 			continue;
 
 		/* Unmark array members which don't belong to the 'fast' chip */
-		if (array_info->chip != gc) {
+		if (array_info->gdev != gdev) {
 			__clear_bit(descs->ndescs, array_info->get_mask);
 			__clear_bit(descs->ndescs, array_info->set_mask);
 		}
@@ -4786,9 +4803,10 @@ struct gpio_descs *__must_check gpiod_ge
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
@@ -4800,7 +4818,7 @@ struct gpio_descs *__must_check gpiod_ge
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
@@ -110,7 +110,7 @@ extern const char *const gpio_suffixes[]
  *
  * @desc:		Array of pointers to the GPIO descriptors
  * @size:		Number of elements in desc
- * @chip:		Parent GPIO chip
+ * @gdev:		Parent GPIO device
  * @get_mask:		Get mask used in fastpath
  * @set_mask:		Set mask used in fastpath
  * @invert_mask:	Invert mask used in fastpath
@@ -122,7 +122,7 @@ extern const char *const gpio_suffixes[]
 struct gpio_array {
 	struct gpio_desc	**desc;
 	unsigned int		size;
-	struct gpio_chip	*chip;
+	struct gpio_device	*gdev;
 	unsigned long		*get_mask;
 	unsigned long		*set_mask;
 	unsigned long		invert_mask[];


