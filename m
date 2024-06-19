Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54BC13D52E;
	Wed, 19 Jun 2024 13:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803857; cv=none; b=pqRcKyxMB1my+qtMT3BwWg9Ged8dNi/pCO4lGGElLssSEdEr5eGUYvryDoY3ZVNUnDrsjxRwFVbd9wf1OzNIMyPCrUyVgyEVxVeumw376eJ2cqFkU/dk8bKcYMTXrnFJqWHPrQb3fHtm6C5289+auXiosfdgodxMIpcsySLODoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803857; c=relaxed/simple;
	bh=vRYtFysv4hKRjVQixh8A+7DXMl1Me+FFT3Wf6pYZ+uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+VTPu0LzOsX0YLkuoyB//1oe0SVTNQ1pdFDBxpIqvwE8LOr1FKR2PU2A3gDhhsycDhW3xS5MzL2r+LXHDhSxmUOh7eN+j6BkpQLVIJeqBuSRiDb3bbuQFQ52E2K+BOQxKCIJpVTWFIRe5X1pME2Nlt7nb93e43K1khGHiU11II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qS+v1m6J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qS+v1m6J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1D1C2BBFC;
	Wed, 19 Jun 2024 13:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803857;
	bh=vRYtFysv4hKRjVQixh8A+7DXMl1Me+FFT3Wf6pYZ+uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qS+v1m6JhUds0XDZRUk/kzlZ10XasHmyC+tE777QRIWqV6o3oYkziBs+DYa21j8ze
	 lw0/a1IyWLeADVcmciWn4J4atrGLCqJhRAtjvQ1eCmX+zgf5s+IOmqY7+Zkm29vyBZ
	 AhEioSbgs3/XYsscj9xN50ZI7jr6Ph35IDOcwiDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 127/217] gpio: tqmx86: Convert to immutable irq_chip
Date: Wed, 19 Jun 2024 14:56:10 +0200
Message-ID: <20240619125601.589556934@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 8e43827b6ae727a745ce7a8cc19184b28905a965 ]

Convert the driver to immutable irq-chip with a bit of
intuition.

Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: 08af509efdf8 ("gpio: tqmx86: store IRQ trigger type and unmask status separately")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-tqmx86.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/gpio-tqmx86.c b/drivers/gpio/gpio-tqmx86.c
index da689b5b3fad2..b7e2dbbdc4ebe 100644
--- a/drivers/gpio/gpio-tqmx86.c
+++ b/drivers/gpio/gpio-tqmx86.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
 
 #define TQMX86_NGPIO	8
@@ -35,7 +36,6 @@
 
 struct tqmx86_gpio_data {
 	struct gpio_chip	chip;
-	struct irq_chip		irq_chip;
 	void __iomem		*io_base;
 	int			irq;
 	raw_spinlock_t		spinlock;
@@ -119,6 +119,7 @@ static void tqmx86_gpio_irq_mask(struct irq_data *data)
 	gpiic &= ~mask;
 	tqmx86_gpio_write(gpio, gpiic, TQMX86_GPIIC);
 	raw_spin_unlock_irqrestore(&gpio->spinlock, flags);
+	gpiochip_disable_irq(&gpio->chip, irqd_to_hwirq(data));
 }
 
 static void tqmx86_gpio_irq_unmask(struct irq_data *data)
@@ -131,6 +132,7 @@ static void tqmx86_gpio_irq_unmask(struct irq_data *data)
 
 	mask = TQMX86_GPII_MASK << (offset * TQMX86_GPII_BITS);
 
+	gpiochip_enable_irq(&gpio->chip, irqd_to_hwirq(data));
 	raw_spin_lock_irqsave(&gpio->spinlock, flags);
 	gpiic = tqmx86_gpio_read(gpio, TQMX86_GPIIC);
 	gpiic &= ~mask;
@@ -223,6 +225,22 @@ static void tqmx86_init_irq_valid_mask(struct gpio_chip *chip,
 	clear_bit(3, valid_mask);
 }
 
+static void tqmx86_gpio_irq_print_chip(struct irq_data *d, struct seq_file *p)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+
+	seq_printf(p, gc->label);
+}
+
+static const struct irq_chip tqmx86_gpio_irq_chip = {
+	.irq_mask = tqmx86_gpio_irq_mask,
+	.irq_unmask = tqmx86_gpio_irq_unmask,
+	.irq_set_type = tqmx86_gpio_irq_set_type,
+	.irq_print_chip = tqmx86_gpio_irq_print_chip,
+	.flags = IRQCHIP_IMMUTABLE,
+	GPIOCHIP_IRQ_RESOURCE_HELPERS,
+};
+
 static int tqmx86_gpio_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -279,14 +297,8 @@ static int tqmx86_gpio_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 
 	if (irq > 0) {
-		struct irq_chip *irq_chip = &gpio->irq_chip;
 		u8 irq_status;
 
-		irq_chip->name = chip->label;
-		irq_chip->irq_mask = tqmx86_gpio_irq_mask;
-		irq_chip->irq_unmask = tqmx86_gpio_irq_unmask;
-		irq_chip->irq_set_type = tqmx86_gpio_irq_set_type;
-
 		/* Mask all interrupts */
 		tqmx86_gpio_write(gpio, 0, TQMX86_GPIIC);
 
@@ -295,7 +307,7 @@ static int tqmx86_gpio_probe(struct platform_device *pdev)
 		tqmx86_gpio_write(gpio, irq_status, TQMX86_GPIIS);
 
 		girq = &chip->irq;
-		girq->chip = irq_chip;
+		gpio_irq_chip_set_chip(girq, &tqmx86_gpio_irq_chip);
 		girq->parent_handler = tqmx86_gpio_irq_handler;
 		girq->num_parents = 1;
 		girq->parents = devm_kcalloc(&pdev->dev, 1,
-- 
2.43.0



