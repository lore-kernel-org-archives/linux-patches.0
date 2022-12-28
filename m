Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954C71863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C472C433F0;
	Wed, 28 Dec 2022 15:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241522;
	bh=LrijrRkamTXm/fyIFKXldWvqEgQd8xUIFUrCGkQKVuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jPmnlRv8nYQlsq78YBVLOmg8k18wiYDuXKWHSXGqsKUaqcHQVeKwMugDSN+xiT8SI
	 rhJFh17KaZ4g5xzBNpwpg8HG7XxkjYExrrGm1aHmb18kB4bB0p6sifU5kDh8HJsO1N
	 iPMCw5XkuRxdXGYmIJ1w6q//xnb8ObwrUiYzg6lM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 492/731] gpiolib: make struct comments into real kernel docs
Date: Wed, 28 Dec 2022 15:39:59 +0100
Message-Id: <20221228144310.809663723@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bartosz Golaszewski <brgl@bgdev.pl>

[ Upstream commit 4398693a9e24bcab0b99ea219073917991d0792b ]

We have several comments that start with '/**' but don't conform to the
kernel doc standard. Add proper detailed descriptions for the affected
definitions and move the docs from the forward declarations to the
struct definitions where applicable.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Stable-dep-of: bdbbae241a04 ("gpiolib: protect the GPIO device against being dropped while in use by user-space")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.h        | 34 ++++++++++++++++++++++++++++++++++
 include/linux/gpio/consumer.h | 35 ++++++++++++++++-------------------
 2 files changed, 50 insertions(+), 19 deletions(-)

diff --git a/drivers/gpio/gpiolib.h b/drivers/gpio/gpiolib.h
index c31f4626915d..d77be9d1da80 100644
--- a/drivers/gpio/gpiolib.h
+++ b/drivers/gpio/gpiolib.h
@@ -37,6 +37,9 @@
  * or name of the IP component in a System on Chip.
  * @data: per-instance data assigned by the driver
  * @list: links gpio_device:s together for traversal
+ * @notifier: used to notify subscribers about lines being requested, released
+ *            or reconfigured
+ * @pin_ranges: range of pins served by the GPIO driver
  *
  * This state container holds most of the runtime variable data
  * for a GPIO device and can hold references and live on after the
@@ -72,6 +75,20 @@ struct gpio_device {
 /* gpio suffixes used for ACPI and device tree lookup */
 static __maybe_unused const char * const gpio_suffixes[] = { "gpios", "gpio" };
 
+/**
+ * struct gpio_array - Opaque descriptor for a structure of GPIO array attributes
+ *
+ * @desc:		Array of pointers to the GPIO descriptors
+ * @size:		Number of elements in desc
+ * @chip:		Parent GPIO chip
+ * @get_mask:		Get mask used in fastpath
+ * @set_mask:		Set mask used in fastpath
+ * @invert_mask:	Invert mask used in fastpath
+ *
+ * This structure is attached to struct gpiod_descs obtained from
+ * gpiod_get_array() and can be passed back to get/set array functions in order
+ * to activate fast processing path if applicable.
+ */
 struct gpio_array {
 	struct gpio_desc	**desc;
 	unsigned int		size;
@@ -96,6 +113,23 @@ int gpiod_set_array_value_complex(bool raw, bool can_sleep,
 extern spinlock_t gpio_lock;
 extern struct list_head gpio_devices;
 
+
+/**
+ * struct gpio_desc - Opaque descriptor for a GPIO
+ *
+ * @gdev:		Pointer to the parent GPIO device
+ * @flags:		Binary descriptor flags
+ * @label:		Name of the consumer
+ * @name:		Line name
+ * @hog:		Pointer to the device node that hogs this line (if any)
+ * @debounce_period_us:	Debounce period in microseconds
+ *
+ * These are obtained using gpiod_get() and are preferable to the old
+ * integer-based handles.
+ *
+ * Contrary to integers, a pointer to a &struct gpio_desc is guaranteed to be
+ * valid until the GPIO is released.
+ */
 struct gpio_desc {
 	struct gpio_device	*gdev;
 	unsigned long		flags;
diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
index 97a28ad3393b..369902d52f9c 100644
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -8,27 +8,16 @@
 #include <linux/err.h>
 
 struct device;
-
-/**
- * Opaque descriptor for a GPIO. These are obtained using gpiod_get() and are
- * preferable to the old integer-based handles.
- *
- * Contrary to integers, a pointer to a gpio_desc is guaranteed to be valid
- * until the GPIO is released.
- */
 struct gpio_desc;
-
-/**
- * Opaque descriptor for a structure of GPIO array attributes.  This structure
- * is attached to struct gpiod_descs obtained from gpiod_get_array() and can be
- * passed back to get/set array functions in order to activate fast processing
- * path if applicable.
- */
 struct gpio_array;
 
 /**
- * Struct containing an array of descriptors that can be obtained using
- * gpiod_get_array().
+ * struct gpio_descs - Struct containing an array of descriptors that can be
+ *                     obtained using gpiod_get_array()
+ *
+ * @info:	Pointer to the opaque gpio_array structure
+ * @ndescs:	Number of held descriptors
+ * @desc:	Array of pointers to GPIO descriptors
  */
 struct gpio_descs {
 	struct gpio_array *info;
@@ -43,8 +32,16 @@ struct gpio_descs {
 #define GPIOD_FLAGS_BIT_NONEXCLUSIVE	BIT(4)
 
 /**
- * Optional flags that can be passed to one of gpiod_* to configure direction
- * and output value. These values cannot be OR'd.
+ * enum gpiod_flags - Optional flags that can be passed to one of gpiod_* to
+ *                    configure direction and output value. These values
+ *                    cannot be OR'd.
+ *
+ * @GPIOD_ASIS:			Don't change anything
+ * @GPIOD_IN:			Set lines to input mode
+ * @GPIOD_OUT_LOW:		Set lines to output and drive them low
+ * @GPIOD_OUT_HIGH:		Set lines to output and drive them high
+ * @GPIOD_OUT_LOW_OPEN_DRAIN:	Set lines to open-drain output and drive them low
+ * @GPIOD_OUT_HIGH_OPEN_DRAIN:	Set lines to open-drain output and drive them high
  */
 enum gpiod_flags {
 	GPIOD_ASIS	= 0,
-- 
2.35.1



