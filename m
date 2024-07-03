Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C50D1741C4;
	Wed,  3 Jul 2024 11:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005464; cv=none; b=tSE6y/25dTxxjsaLpSvHjOuTEHExtRjp6OqgScIG1qbMftSgwlyIPOTX6dJ9EIIFXIoazoxcviJX0lqIbrt+7YDw+kRixlxRT11maLEsnf3PsMQRgaUkYHP9C9YKpXwN1NN5g84wMwBIusDbizn2etptipcCgfL805ayFwmf+Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005464; c=relaxed/simple;
	bh=6LUeoDXcc4OTmM/vbbRHsky/rUGJKELS1oUL9NXvkJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPSa9rGa/VW0v7tOuclD+w8zxhFl7oKuiZIeWc8VC+B93/4ehkskRiAuyRdU/JZE2BpTehpuzZ+wGg3ZvKmi5dALGZUmmelY8X+1+xVkzk962x7teWEWLuozal7vsjibywQLbunXtQ0j/gTz05A17oxdYzCwGIksdI1hKamFyow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JitgHFAQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JitgHFAQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F077C2BD10;
	Wed,  3 Jul 2024 11:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005463;
	bh=6LUeoDXcc4OTmM/vbbRHsky/rUGJKELS1oUL9NXvkJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JitgHFAQf/YM9myfMQ7rzOoym63Sxd5LQKPOOy2+MhQmvH2qF4zDitIVkCrCw6X7n
	 KTuYc3yhP7Vfsi4PyYiMaAvIUF38MZApUycC1b4H+DyVYwoLtyfKZowia5d0dpPEbR
	 ig77BrCY5C9If6kfCO0i12fkwtTsvP3XRMHGKe4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 5.15 090/356] gpio: tqmx86: store IRQ trigger type and unmask status separately
Date: Wed,  3 Jul 2024 12:37:06 +0200
Message-ID: <20240703102916.505960728@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

commit 08af509efdf8dad08e972b48de0e2c2a7919ea8b upstream.

irq_set_type() should not implicitly unmask the IRQ.

All accesses to the interrupt configuration register are moved to a new
helper tqmx86_gpio_irq_config(). We also introduce the new rule that
accessing irq_type must happen while locked, which will become
significant for fixing EDGE_BOTH handling.

Fixes: b868db94a6a7 ("gpio: tqmx86: Add GPIO from for this IO controller")
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Link: https://lore.kernel.org/r/6aa4f207f77cb58ef64ffb947e91949b0f753ccd.1717063994.git.matthias.schiffer@ew.tq-group.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-tqmx86.c |   46 +++++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 20 deletions(-)

--- a/drivers/gpio/gpio-tqmx86.c
+++ b/drivers/gpio/gpio-tqmx86.c
@@ -27,16 +27,20 @@
 #define TQMX86_GPIIC	3	/* GPI Interrupt Configuration Register */
 #define TQMX86_GPIIS	4	/* GPI Interrupt Status Register */
 
+#define TQMX86_GPII_NONE	0
 #define TQMX86_GPII_FALLING	BIT(0)
 #define TQMX86_GPII_RISING	BIT(1)
 #define TQMX86_GPII_MASK	(BIT(0) | BIT(1))
 #define TQMX86_GPII_BITS	2
+/* Stored in irq_type with GPII bits */
+#define TQMX86_INT_UNMASKED	BIT(2)
 
 struct tqmx86_gpio_data {
 	struct gpio_chip	chip;
 	struct irq_chip		irq_chip;
 	void __iomem		*io_base;
 	int			irq;
+	/* Lock must be held for accessing output and irq_type fields */
 	raw_spinlock_t		spinlock;
 	u8			irq_type[TQMX86_NGPI];
 };
@@ -107,20 +111,30 @@ static int tqmx86_gpio_get_direction(str
 	return GPIO_LINE_DIRECTION_OUT;
 }
 
+static void tqmx86_gpio_irq_config(struct tqmx86_gpio_data *gpio, int offset)
+	__must_hold(&gpio->spinlock)
+{
+	u8 type = TQMX86_GPII_NONE, gpiic;
+
+	if (gpio->irq_type[offset] & TQMX86_INT_UNMASKED)
+		type = gpio->irq_type[offset] & TQMX86_GPII_MASK;
+
+	gpiic = tqmx86_gpio_read(gpio, TQMX86_GPIIC);
+	gpiic &= ~(TQMX86_GPII_MASK << (offset * TQMX86_GPII_BITS));
+	gpiic |= type << (offset * TQMX86_GPII_BITS);
+	tqmx86_gpio_write(gpio, gpiic, TQMX86_GPIIC);
+}
+
 static void tqmx86_gpio_irq_mask(struct irq_data *data)
 {
 	unsigned int offset = (data->hwirq - TQMX86_NGPO);
 	struct tqmx86_gpio_data *gpio = gpiochip_get_data(
 		irq_data_get_irq_chip_data(data));
 	unsigned long flags;
-	u8 gpiic, mask;
-
-	mask = TQMX86_GPII_MASK << (offset * TQMX86_GPII_BITS);
 
 	raw_spin_lock_irqsave(&gpio->spinlock, flags);
-	gpiic = tqmx86_gpio_read(gpio, TQMX86_GPIIC);
-	gpiic &= ~mask;
-	tqmx86_gpio_write(gpio, gpiic, TQMX86_GPIIC);
+	gpio->irq_type[offset] &= ~TQMX86_INT_UNMASKED;
+	tqmx86_gpio_irq_config(gpio, offset);
 	raw_spin_unlock_irqrestore(&gpio->spinlock, flags);
 }
 
@@ -130,15 +144,10 @@ static void tqmx86_gpio_irq_unmask(struc
 	struct tqmx86_gpio_data *gpio = gpiochip_get_data(
 		irq_data_get_irq_chip_data(data));
 	unsigned long flags;
-	u8 gpiic, mask;
-
-	mask = TQMX86_GPII_MASK << (offset * TQMX86_GPII_BITS);
 
 	raw_spin_lock_irqsave(&gpio->spinlock, flags);
-	gpiic = tqmx86_gpio_read(gpio, TQMX86_GPIIC);
-	gpiic &= ~mask;
-	gpiic |= gpio->irq_type[offset] << (offset * TQMX86_GPII_BITS);
-	tqmx86_gpio_write(gpio, gpiic, TQMX86_GPIIC);
+	gpio->irq_type[offset] |= TQMX86_INT_UNMASKED;
+	tqmx86_gpio_irq_config(gpio, offset);
 	raw_spin_unlock_irqrestore(&gpio->spinlock, flags);
 }
 
@@ -149,7 +158,7 @@ static int tqmx86_gpio_irq_set_type(stru
 	unsigned int offset = (data->hwirq - TQMX86_NGPO);
 	unsigned int edge_type = type & IRQF_TRIGGER_MASK;
 	unsigned long flags;
-	u8 new_type, gpiic;
+	u8 new_type;
 
 	switch (edge_type) {
 	case IRQ_TYPE_EDGE_RISING:
@@ -165,13 +174,10 @@ static int tqmx86_gpio_irq_set_type(stru
 		return -EINVAL; /* not supported */
 	}
 
-	gpio->irq_type[offset] = new_type;
-
 	raw_spin_lock_irqsave(&gpio->spinlock, flags);
-	gpiic = tqmx86_gpio_read(gpio, TQMX86_GPIIC);
-	gpiic &= ~((TQMX86_GPII_MASK) << (offset * TQMX86_GPII_BITS));
-	gpiic |= new_type << (offset * TQMX86_GPII_BITS);
-	tqmx86_gpio_write(gpio, gpiic, TQMX86_GPIIC);
+	gpio->irq_type[offset] &= ~TQMX86_GPII_MASK;
+	gpio->irq_type[offset] |= new_type;
+	tqmx86_gpio_irq_config(gpio, offset);
 	raw_spin_unlock_irqrestore(&gpio->spinlock, flags);
 
 	return 0;


