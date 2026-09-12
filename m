Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECED137AA92;
	Sat, 12 Sep 2026 10:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210004; cv=none; b=q2TF/TVlxI99asKOBVOzXgOnf5i7s7m4iGbb5iWEQOGHbObLISR0EU1AHRIqzLJChbrCVcV/t9Kffpp4EZGOBqY8Pmp9HbNy+4plkGhJOIQUYpVNxUafGtXpWi6FOC4+dynDRdexO2ueVN+NIwPr3EXbHiGt1dDdghzFP7Hrx14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210004; c=relaxed/simple;
	bh=7/1N+QDssI58+8AAh/HvbzQZVGMTQ/U74zOAOYXkGpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q77CQU/AD1vWLngCLLgvB4s9tYdmdOp1dl1LzpNMkBXqY7fkHtaZTKsy4PPHod+CAwV5Z6NBYhynOgfZ+pq/Rm5jSTDfPJhVGQ4A7ZILp9USd5mZI0d/GwnSoADj5cok3nWFa61dGjm6NBWp1lRFi+jjf5tq9hMOKnUV8eQosVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q1FR7Nty; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q1FR7Nty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D951F000FF;
	Sat, 12 Sep 2026 10:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210002;
	bh=XzEpKkMkzgFy77Fc+l9NFPhMshMLNa47IObvv4j+cGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q1FR7NtykFlmbZ0CU8S2gyQUclrKuhjes4GVeKBlHAXEdxpt8bIPb+seDDW7r+24g
	 HjQFB7DyNJCh701GKjoqaaqm8viDZhBULWI6WD4QZMsfIOLpGSFIfhUKMaPnGDsOy/
	 uHzUh6DMiZq03JjNKSoMxcyt+3FDYEw7EynarxDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0937/1518] gpiolib: move legacy interface into linux/gpio/legacy.h
Date: Sat, 12 Sep 2026 08:51:46 +0200
Message-ID: <20260912065644.647595753@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit bfdc854ba63bc815cf710701f889544a9d27df83 ]

Split the old contents from gpio.h for clarity. Ideally any driver
that still includes linux/gpio.h can now be ported over to use
either linux/gpio/legacy.h or linux/gpio/consumer.h, with the
original file getting removed once that is complete.

No functional changes intended for now.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20260428154522.2861492-1-arnd@kernel.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Stable-dep-of: 942901eeda93 ("leds: gpio: Clear error pointers for skipped LEDs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/gpio.h        | 162 +--------------------------------
 include/linux/gpio/legacy.h | 173 ++++++++++++++++++++++++++++++++++++
 2 files changed, 177 insertions(+), 158 deletions(-)
 create mode 100644 include/linux/gpio/legacy.h

diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 8f85ddb264295..b0d4942a65de2 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -2,13 +2,11 @@
 /*
  * NOTE: This header *must not* be included.
  *
- * This is the LEGACY GPIO bulk include file, including legacy APIs. It is
- * used for GPIO drivers still referencing the global GPIO numberspace,
- * and should not be included in new code.
- *
  * If you're implementing a GPIO driver, only include <linux/gpio/driver.h>
  * If you're implementing a GPIO consumer, only include <linux/gpio/consumer.h>
+ * If you're using the legacy interfaces, include <linux/gpio/legacy.h>
  */
+
 #ifndef __LINUX_GPIO_H
 #define __LINUX_GPIO_H
 
@@ -18,159 +16,7 @@
 #endif
 
 #ifdef CONFIG_GPIOLIB_LEGACY
-
-struct device;
-
-/* make these flag values available regardless of GPIO kconfig options */
-#define GPIOF_IN		((1 << 0))
-#define GPIOF_OUT_INIT_LOW	((0 << 0) | (0 << 1))
-#define GPIOF_OUT_INIT_HIGH	((0 << 0) | (1 << 1))
-
-#ifdef CONFIG_GPIOLIB
-/*
- * "valid" GPIO numbers are nonnegative and may be passed to
- * setup routines like gpio_request().  Only some valid numbers
- * can successfully be requested and used.
- *
- * Invalid GPIO numbers are useful for indicating no-such-GPIO in
- * platform data and other tables.
- */
-static inline bool gpio_is_valid(int number)
-{
-	/* only non-negative numbers are valid */
-	return number >= 0;
-}
-
-/*
- * Platforms may implement their GPIO interface with library code,
- * at a small performance cost for non-inlined operations and some
- * extra memory (for code and for per-GPIO table entries).
- */
-
-/* Always use the library code for GPIO management calls,
- * or when sleeping may be involved.
- */
-int gpio_request(unsigned gpio, const char *label);
-void gpio_free(unsigned gpio);
-
-static inline int gpio_direction_input(unsigned gpio)
-{
-	return gpiod_direction_input(gpio_to_desc(gpio));
-}
-static inline int gpio_direction_output(unsigned gpio, int value)
-{
-	return gpiod_direction_output_raw(gpio_to_desc(gpio), value);
-}
-
-static inline int gpio_get_value_cansleep(unsigned gpio)
-{
-	return gpiod_get_raw_value_cansleep(gpio_to_desc(gpio));
-}
-static inline void gpio_set_value_cansleep(unsigned gpio, int value)
-{
-	gpiod_set_raw_value_cansleep(gpio_to_desc(gpio), value);
-}
-
-static inline int gpio_get_value(unsigned gpio)
-{
-	return gpiod_get_raw_value(gpio_to_desc(gpio));
-}
-static inline void gpio_set_value(unsigned gpio, int value)
-{
-	gpiod_set_raw_value(gpio_to_desc(gpio), value);
-}
-
-static inline int gpio_to_irq(unsigned gpio)
-{
-	return gpiod_to_irq(gpio_to_desc(gpio));
-}
-
-int gpio_request_one(unsigned gpio, unsigned long flags, const char *label);
-
-int devm_gpio_request_one(struct device *dev, unsigned gpio,
-			  unsigned long flags, const char *label);
-
-#else /* ! CONFIG_GPIOLIB */
-
-#include <linux/kernel.h>
-
-#include <asm/bug.h>
-#include <asm/errno.h>
-
-static inline bool gpio_is_valid(int number)
-{
-	return false;
-}
-
-static inline int gpio_request(unsigned gpio, const char *label)
-{
-	return -ENOSYS;
-}
-
-static inline int gpio_request_one(unsigned gpio,
-					unsigned long flags, const char *label)
-{
-	return -ENOSYS;
-}
-
-static inline void gpio_free(unsigned gpio)
-{
-	might_sleep();
-
-	/* GPIO can never have been requested */
-	WARN_ON(1);
-}
-
-static inline int gpio_direction_input(unsigned gpio)
-{
-	return -ENOSYS;
-}
-
-static inline int gpio_direction_output(unsigned gpio, int value)
-{
-	return -ENOSYS;
-}
-
-static inline int gpio_get_value(unsigned gpio)
-{
-	/* GPIO can never have been requested or set as {in,out}put */
-	WARN_ON(1);
-	return 0;
-}
-
-static inline void gpio_set_value(unsigned gpio, int value)
-{
-	/* GPIO can never have been requested or set as output */
-	WARN_ON(1);
-}
-
-static inline int gpio_get_value_cansleep(unsigned gpio)
-{
-	/* GPIO can never have been requested or set as {in,out}put */
-	WARN_ON(1);
-	return 0;
-}
-
-static inline void gpio_set_value_cansleep(unsigned gpio, int value)
-{
-	/* GPIO can never have been requested or set as output */
-	WARN_ON(1);
-}
-
-static inline int gpio_to_irq(unsigned gpio)
-{
-	/* GPIO can never have been requested or set as input */
-	WARN_ON(1);
-	return -EINVAL;
-}
-
-static inline int devm_gpio_request_one(struct device *dev, unsigned gpio,
-					unsigned long flags, const char *label)
-{
-	WARN_ON(1);
-	return -EINVAL;
-}
-
-#endif /* ! CONFIG_GPIOLIB */
+#include <linux/gpio/legacy.h>
 #endif /* CONFIG_GPIOLIB_LEGACY */
+
 #endif /* __LINUX_GPIO_H */
diff --git a/include/linux/gpio/legacy.h b/include/linux/gpio/legacy.h
new file mode 100644
index 0000000000000..557ef635935ea
--- /dev/null
+++ b/include/linux/gpio/legacy.h
@@ -0,0 +1,173 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * This is the LEGACY GPIO include file, used only for legacy APIs.
+ *
+ * No new code should use this, but instead use the linux/gpio/consumer.h
+ * interfaces directly.
+ */
+
+#ifndef __LINUX_GPIO_LEGACY_H
+#define __LINUX_GPIO_LEGACY_H
+
+#include <linux/types.h>
+
+#ifdef CONFIG_GPIOLIB_LEGACY
+
+struct device;
+
+/* make these flag values available regardless of GPIO kconfig options */
+#define GPIOF_IN		((1 << 0))
+#define GPIOF_OUT_INIT_LOW	((0 << 0) | (0 << 1))
+#define GPIOF_OUT_INIT_HIGH	((0 << 0) | (1 << 1))
+
+#ifdef CONFIG_GPIOLIB
+
+#include <linux/gpio/consumer.h>
+
+/*
+ * "valid" GPIO numbers are nonnegative and may be passed to
+ * setup routines like gpio_request().  Only some valid numbers
+ * can successfully be requested and used.
+ *
+ * Invalid GPIO numbers are useful for indicating no-such-GPIO in
+ * platform data and other tables.
+ */
+static inline bool gpio_is_valid(int number)
+{
+	/* only non-negative numbers are valid */
+	return number >= 0;
+}
+
+/*
+ * Platforms may implement their GPIO interface with library code,
+ * at a small performance cost for non-inlined operations and some
+ * extra memory (for code and for per-GPIO table entries).
+ */
+
+/* Always use the library code for GPIO management calls,
+ * or when sleeping may be involved.
+ */
+int gpio_request(unsigned gpio, const char *label);
+void gpio_free(unsigned gpio);
+
+static inline int gpio_direction_input(unsigned gpio)
+{
+	return gpiod_direction_input(gpio_to_desc(gpio));
+}
+static inline int gpio_direction_output(unsigned gpio, int value)
+{
+	return gpiod_direction_output_raw(gpio_to_desc(gpio), value);
+}
+
+static inline int gpio_get_value_cansleep(unsigned gpio)
+{
+	return gpiod_get_raw_value_cansleep(gpio_to_desc(gpio));
+}
+static inline void gpio_set_value_cansleep(unsigned gpio, int value)
+{
+	gpiod_set_raw_value_cansleep(gpio_to_desc(gpio), value);
+}
+
+static inline int gpio_get_value(unsigned gpio)
+{
+	return gpiod_get_raw_value(gpio_to_desc(gpio));
+}
+static inline void gpio_set_value(unsigned gpio, int value)
+{
+	gpiod_set_raw_value(gpio_to_desc(gpio), value);
+}
+
+static inline int gpio_to_irq(unsigned gpio)
+{
+	return gpiod_to_irq(gpio_to_desc(gpio));
+}
+
+int gpio_request_one(unsigned gpio, unsigned long flags, const char *label);
+
+int devm_gpio_request_one(struct device *dev, unsigned gpio,
+			  unsigned long flags, const char *label);
+
+#else /* ! CONFIG_GPIOLIB */
+
+#include <linux/kernel.h>
+
+#include <asm/bug.h>
+#include <asm/errno.h>
+
+static inline bool gpio_is_valid(int number)
+{
+	return false;
+}
+
+static inline int gpio_request(unsigned gpio, const char *label)
+{
+	return -ENOSYS;
+}
+
+static inline int gpio_request_one(unsigned gpio,
+					unsigned long flags, const char *label)
+{
+	return -ENOSYS;
+}
+
+static inline void gpio_free(unsigned gpio)
+{
+	might_sleep();
+
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+}
+
+static inline int gpio_direction_input(unsigned gpio)
+{
+	return -ENOSYS;
+}
+
+static inline int gpio_direction_output(unsigned gpio, int value)
+{
+	return -ENOSYS;
+}
+
+static inline int gpio_get_value(unsigned gpio)
+{
+	/* GPIO can never have been requested or set as {in,out}put */
+	WARN_ON(1);
+	return 0;
+}
+
+static inline void gpio_set_value(unsigned gpio, int value)
+{
+	/* GPIO can never have been requested or set as output */
+	WARN_ON(1);
+}
+
+static inline int gpio_get_value_cansleep(unsigned gpio)
+{
+	/* GPIO can never have been requested or set as {in,out}put */
+	WARN_ON(1);
+	return 0;
+}
+
+static inline void gpio_set_value_cansleep(unsigned gpio, int value)
+{
+	/* GPIO can never have been requested or set as output */
+	WARN_ON(1);
+}
+
+static inline int gpio_to_irq(unsigned gpio)
+{
+	/* GPIO can never have been requested or set as input */
+	WARN_ON(1);
+	return -EINVAL;
+}
+
+static inline int devm_gpio_request_one(struct device *dev, unsigned gpio,
+					unsigned long flags, const char *label)
+{
+	WARN_ON(1);
+	return -EINVAL;
+}
+
+#endif /* ! CONFIG_GPIOLIB */
+#endif /* CONFIG_GPIOLIB_LEGACY */
+#endif /* __LINUX_GPIO_LEGAGY_H */
-- 
2.53.0



