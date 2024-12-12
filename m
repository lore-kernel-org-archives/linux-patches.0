Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17B41487CD;
	Thu, 12 Dec 2024 15:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016566; cv=none; b=MvGFMDNtkJB6UxbgT4wGlkiEDGPRjC3F06xXo3VF5dr6p6qYbGWW70QGeXuCrJFHoOm7c1jPCVM25NX7lM1IjvEvPxY9XgeD0A52Sg/q6btJaYjc423fU218g+7ZcqkMefPEZIXYmShvcyQiUv1nSPwZjvEFP1k0E9p+XtLrpws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016566; c=relaxed/simple;
	bh=eeHMsiPu65vh6XQVQ3uc2wi7Pot/ecLSeYZZWSxeX2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mj5wrC1HKUy6BEQogjXzx4UJEUiuoq0zS8EuuvC00vYlB2GvHGate9EBh4MDnDhPkW7PjYHRy4XreXYj95lUHwUu8W/NKYEJ4lnHQ3TWuRFVaDwtG2cH2E1gK7xZY1KgY4l9G8UERnzUWw1hFRpWvshs0FHkGW6/XNyL5mpjfug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xd8NVzmr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xd8NVzmr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9C9C4CECE;
	Thu, 12 Dec 2024 15:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016565;
	bh=eeHMsiPu65vh6XQVQ3uc2wi7Pot/ecLSeYZZWSxeX2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xd8NVzmrIk2DMkN4GUnrZLCXMmzs3o0rcEtLI/1EN6usGs7t1eVHOpf0P5nw0QWd7
	 2zmHBBm9bp12E7DD/Oam+zlcuxagUvr1i5T8d1xJuxUkjCQHhe92WCbxhM6LN/Ov/3
	 HIA9IhEI8Z4cUPiDkKrodbrfc3qcPT3Gv2J0fHpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 235/466] gpio: free irqs that are still requested when the chip is being removed
Date: Thu, 12 Dec 2024 15:56:44 +0100
Message-ID: <20241212144316.066251568@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit ec8b6f55b98146c41dcf15e8189eb43291e35e89 ]

If we remove a GPIO chip that is also an interrupt controller with users
not having freed some interrupts, we'll end up leaking resources as
indicated by the following warning:

  remove_proc_entry: removing non-empty directory 'irq/30', leaking at least 'gpio'

As there's no way of notifying interrupt users about the irqchip going
away and the interrupt subsystem is not plugged into the driver model and
so not all cases can be handled by devlinks, we need to make sure to free
all interrupts before the complete the removal of the provider.

Reviewed-by: Herve Codina <herve.codina@bootlin.com>
Tested-by: Herve Codina <herve.codina@bootlin.com>
Link: https://lore.kernel.org/r/20240919135104.3583-1-brgl@bgdev.pl
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 2b02655abb56e..44372f8647d51 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -14,6 +14,7 @@
 #include <linux/idr.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/irqdesc.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/lockdep.h>
@@ -713,6 +714,45 @@ bool gpiochip_line_is_valid(const struct gpio_chip *gc,
 }
 EXPORT_SYMBOL_GPL(gpiochip_line_is_valid);
 
+static void gpiod_free_irqs(struct gpio_desc *desc)
+{
+	int irq = gpiod_to_irq(desc);
+	struct irq_desc *irqd = irq_to_desc(irq);
+	void *cookie;
+
+	for (;;) {
+		/*
+		 * Make sure the action doesn't go away while we're
+		 * dereferencing it. Retrieve and store the cookie value.
+		 * If the irq is freed after we release the lock, that's
+		 * alright - the underlying maple tree lookup will return NULL
+		 * and nothing will happen in free_irq().
+		 */
+		scoped_guard(mutex, &irqd->request_mutex) {
+			if (!irq_desc_has_action(irqd))
+				return;
+
+			cookie = irqd->action->dev_id;
+		}
+
+		free_irq(irq, cookie);
+	}
+}
+
+/*
+ * The chip is going away but there may be users who had requested interrupts
+ * on its GPIO lines who have no idea about its removal and have no way of
+ * being notified about it. We need to free any interrupts still in use here or
+ * we'll leak memory and resources (like procfs files).
+ */
+static void gpiochip_free_remaining_irqs(struct gpio_chip *gc)
+{
+	struct gpio_desc *desc;
+
+	for_each_gpio_desc_with_flag(gc, desc, FLAG_USED_AS_IRQ)
+		gpiod_free_irqs(desc);
+}
+
 static void gpiodev_release(struct device *dev)
 {
 	struct gpio_device *gdev = to_gpio_device(dev);
@@ -1125,6 +1165,7 @@ void gpiochip_remove(struct gpio_chip *gc)
 	/* FIXME: should the legacy sysfs handling be moved to gpio_device? */
 	gpiochip_sysfs_unregister(gdev);
 	gpiochip_free_hogs(gc);
+	gpiochip_free_remaining_irqs(gc);
 
 	scoped_guard(mutex, &gpio_devices_lock)
 		list_del_rcu(&gdev->list);
-- 
2.43.0



