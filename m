Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D97182C1
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ydh8Ay5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BFAC433C7;
	Wed, 15 Nov 2023 19:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076632;
	bh=/MecDxFE1ITpyUxSSBAho15aFeO4BgFpsd7xkEjR/XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ydh8Ay5ncMAVLObdms0xm4eJIEETG91ZTB9wgi8sLu6nKUxqcS+oy8hx8aIwoY53Z
	 QSQpxSLYiIorhw0bZlBeanA1IsxK3x8M14RDRw72QBeAKA3HFy59air7JhpJR957jk
	 8BcLXGx/MxwpJkIjVMdVxPmbEq2F+aIfsEraijDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 350/550] HID: cp2112: Make irq_chip immutable
Date: Wed, 15 Nov 2023 14:15:34 -0500
Message-ID: <20231115191625.027321723@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 3e2977c425ad2789ca18084fff913cceacae75a2 ]

Since recently, the kernel is nagging about mutable irq_chips:

   "not an immutable chip, please consider fixing it!"

Drop the unneeded copy, flag it as IRQCHIP_IMMUTABLE, add the new
helper functions and call the appropriate gpiolib functions.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230703185222.50554-4-andriy.shevchenko@linux.intel.com
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Stable-dep-of: dc3115e6c5d9 ("hid: cp2112: Fix IRQ shutdown stopping polling for all IRQs on chip")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-cp2112.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/hid/hid-cp2112.c b/drivers/hid/hid-cp2112.c
index 86e0861caf7ca..3e669a867e319 100644
--- a/drivers/hid/hid-cp2112.c
+++ b/drivers/hid/hid-cp2112.c
@@ -163,7 +163,6 @@ struct cp2112_device {
 	atomic_t read_avail;
 	atomic_t xfer_avail;
 	struct gpio_chip gc;
-	struct irq_chip irq;
 	u8 *in_out_buffer;
 	struct mutex lock;
 
@@ -1080,16 +1079,20 @@ static void cp2112_gpio_irq_mask(struct irq_data *d)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct cp2112_device *dev = gpiochip_get_data(gc);
+	irq_hw_number_t hwirq = irqd_to_hwirq(d);
 
-	__clear_bit(d->hwirq, &dev->irq_mask);
+	__clear_bit(hwirq, &dev->irq_mask);
+	gpiochip_disable_irq(gc, hwirq);
 }
 
 static void cp2112_gpio_irq_unmask(struct irq_data *d)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct cp2112_device *dev = gpiochip_get_data(gc);
+	irq_hw_number_t hwirq = irqd_to_hwirq(d);
 
-	__set_bit(d->hwirq, &dev->irq_mask);
+	gpiochip_enable_irq(gc, hwirq);
+	__set_bit(hwirq, &dev->irq_mask);
 }
 
 static void cp2112_gpio_poll_callback(struct work_struct *work)
@@ -1173,6 +1176,7 @@ static void cp2112_gpio_irq_shutdown(struct irq_data *d)
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct cp2112_device *dev = gpiochip_get_data(gc);
 
+	cp2112_gpio_irq_mask(d);
 	cancel_delayed_work_sync(&dev->gpio_poll_worker);
 }
 
@@ -1226,6 +1230,18 @@ static int __maybe_unused cp2112_allocate_irq(struct cp2112_device *dev,
 	return ret;
 }
 
+static const struct irq_chip cp2112_gpio_irqchip = {
+	.name = "cp2112-gpio",
+	.irq_startup = cp2112_gpio_irq_startup,
+	.irq_shutdown = cp2112_gpio_irq_shutdown,
+	.irq_ack = cp2112_gpio_irq_ack,
+	.irq_mask = cp2112_gpio_irq_mask,
+	.irq_unmask = cp2112_gpio_irq_unmask,
+	.irq_set_type = cp2112_gpio_irq_type,
+	.flags = IRQCHIP_MASK_ON_SUSPEND | IRQCHIP_IMMUTABLE,
+	GPIOCHIP_IRQ_RESOURCE_HELPERS,
+};
+
 static int cp2112_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
 	struct cp2112_device *dev;
@@ -1335,17 +1351,8 @@ static int cp2112_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	dev->gc.can_sleep		= 1;
 	dev->gc.parent			= &hdev->dev;
 
-	dev->irq.name = "cp2112-gpio";
-	dev->irq.irq_startup = cp2112_gpio_irq_startup;
-	dev->irq.irq_shutdown = cp2112_gpio_irq_shutdown;
-	dev->irq.irq_ack = cp2112_gpio_irq_ack;
-	dev->irq.irq_mask = cp2112_gpio_irq_mask;
-	dev->irq.irq_unmask = cp2112_gpio_irq_unmask;
-	dev->irq.irq_set_type = cp2112_gpio_irq_type;
-	dev->irq.flags = IRQCHIP_MASK_ON_SUSPEND;
-
 	girq = &dev->gc.irq;
-	girq->chip = &dev->irq;
+	gpio_irq_chip_set_chip(girq, &cp2112_gpio_irqchip);
 	/* The event comes from the outside so no parent handler */
 	girq->parent_handler = NULL;
 	girq->num_parents = 0;
-- 
2.42.0



