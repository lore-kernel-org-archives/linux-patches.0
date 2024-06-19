Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2890A4315F;
	Wed, 19 Jun 2024 13:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803040; cv=none; b=gfAKCIlNIWPKySJE8dE7+EfFPyouLDWponHt9GMSzhFx/uC/RmLmt4iSU4cPMOyZdClrF7ZAcNO8yQeGJ+0vXBEc6EnF6Yy1GGK2raEVKXx0TD8Yz4wb2fArBWUxCpHqexBqfDujkVsYdL102AmEoeuP4S7KmkIumvIHFsfOKCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803040; c=relaxed/simple;
	bh=axqWo8ukUklgnNO30Q9fr0TmR7MDHGuIcu/D2HXcsZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etB2Q9CgVAbsKUU4oRbiOfO5fcLo7cUuMzQDYS7pjiBfbNVNt3vWKAdIOIHOYwex2gSgB5XMBBeOw/Stl9wyMHsIyoj+J6eYqbPokuGqcwYi7o8P2S/ZzAaeGkvkAfGx8wVsd6hR47tLZRM8AWSC3IaiZ55HUbXuq7vs5dYw0YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XrVAiXUx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XrVAiXUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0781C2BBFC;
	Wed, 19 Jun 2024 13:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803040;
	bh=axqWo8ukUklgnNO30Q9fr0TmR7MDHGuIcu/D2HXcsZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XrVAiXUxNu2RrhI5u37VAe4m2rOqGcwQOcbZN2LIVJ0OEWDbPmfJILCEF25Hx6uWG
	 lc0pGjqy4Lxg+GpLUxdzJybFiM7jAdQOktuxwcIIc/f+KFzjLTP2btuTROOHX3v48T
	 03TBl9tCB3NAk7yxZfWDFCXceC5l1fu1UaG8EgQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 132/281] gpio: tqmx86: store IRQ trigger type and unmask status separately
Date: Wed, 19 Jun 2024 14:54:51 +0200
Message-ID: <20240619125614.922715835@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

[ Upstream commit 08af509efdf8dad08e972b48de0e2c2a7919ea8b ]

irq_set_type() should not implicitly unmask the IRQ.

All accesses to the interrupt configuration register are moved to a new
helper tqmx86_gpio_irq_config(). We also introduce the new rule that
accessing irq_type must happen while locked, which will become
significant for fixing EDGE_BOTH handling.

Fixes: b868db94a6a7 ("gpio: tqmx86: Add GPIO from for this IO controller")
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Link: https://lore.kernel.org/r/6aa4f207f77cb58ef64ffb947e91949b0f753ccd.1717063994.git.matthias.schiffer@ew.tq-group.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-tqmx86.c | 48 ++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/gpio/gpio-tqmx86.c b/drivers/gpio/gpio-tqmx86.c
index b7e2dbbdc4ebe..7e428c872a257 100644
--- a/drivers/gpio/gpio-tqmx86.c
+++ b/drivers/gpio/gpio-tqmx86.c
@@ -29,15 +29,19 @@
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
 	void __iomem		*io_base;
 	int			irq;
+	/* Lock must be held for accessing output and irq_type fields */
 	raw_spinlock_t		spinlock;
 	DECLARE_BITMAP(output, TQMX86_NGPIO);
 	u8			irq_type[TQMX86_NGPI];
@@ -104,21 +108,32 @@ static int tqmx86_gpio_get_direction(struct gpio_chip *chip,
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
+
 	gpiochip_disable_irq(&gpio->chip, irqd_to_hwirq(data));
 }
 
@@ -128,16 +143,12 @@ static void tqmx86_gpio_irq_unmask(struct irq_data *data)
 	struct tqmx86_gpio_data *gpio = gpiochip_get_data(
 		irq_data_get_irq_chip_data(data));
 	unsigned long flags;
-	u8 gpiic, mask;
-
-	mask = TQMX86_GPII_MASK << (offset * TQMX86_GPII_BITS);
 
 	gpiochip_enable_irq(&gpio->chip, irqd_to_hwirq(data));
+
 	raw_spin_lock_irqsave(&gpio->spinlock, flags);
-	gpiic = tqmx86_gpio_read(gpio, TQMX86_GPIIC);
-	gpiic &= ~mask;
-	gpiic |= gpio->irq_type[offset] << (offset * TQMX86_GPII_BITS);
-	tqmx86_gpio_write(gpio, gpiic, TQMX86_GPIIC);
+	gpio->irq_type[offset] |= TQMX86_INT_UNMASKED;
+	tqmx86_gpio_irq_config(gpio, offset);
 	raw_spin_unlock_irqrestore(&gpio->spinlock, flags);
 }
 
@@ -148,7 +159,7 @@ static int tqmx86_gpio_irq_set_type(struct irq_data *data, unsigned int type)
 	unsigned int offset = (data->hwirq - TQMX86_NGPO);
 	unsigned int edge_type = type & IRQF_TRIGGER_MASK;
 	unsigned long flags;
-	u8 new_type, gpiic;
+	u8 new_type;
 
 	switch (edge_type) {
 	case IRQ_TYPE_EDGE_RISING:
@@ -164,13 +175,10 @@ static int tqmx86_gpio_irq_set_type(struct irq_data *data, unsigned int type)
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
-- 
2.43.0



