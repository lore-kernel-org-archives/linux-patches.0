Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D1B381AFF;
	Thu, 20 Aug 2026 15:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239176; cv=none; b=MU4rWgI9tu/Wxt80gzGO39rh0aBsO9XZGWGBHDVHYyWnLi5zQoFOslQn0G8XHQciWzxwb1Xt0HCnoY+liauRqiEY6tSAl2zqcAY5tL4R/rUpSVpPy0to36eSw78rsQZ5NYZvSqeAbSaVC0WkRauM7CCCa3PHTetPDzIrhtjpHJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239176; c=relaxed/simple;
	bh=WALt21UWVrYb4NtjLDQp+Ya769S3qJsKCjXdxRpDG0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XurtL5IQ9qbvsi+jk599snKA/0ZtT6L0fptJ4tnaH9+K/+CfDw6bdpTUboJ/rRqZ5SmkUmd8ymCPr808/QjPDblxAlq655d0kCkK4659WWeUbogcd3efLLx50yWMi3zfBdWqgCtkAqpRYOoicuT2ePQnoEPA56dknY4g01LjX8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2IjKjmXq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2IjKjmXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E496C1F00A3A;
	Thu, 20 Aug 2026 15:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239174;
	bh=c425UDpWjGPt2Qngqfsomg2p38t7+NMHoUAq0T4iXAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2IjKjmXq3xFPxTzEKLX6MFjtBquDJixpsPyRjiBBc7zjZabgBydW9HIjV+qDGVG2r
	 nMmYDq/EFWx8Ks4EmFalwEjRPkcwKaOUHS8lR7fUT+WeaUIGbRrFcu5kW2gbSrgelb
	 3quKQtaZLPliVsJ0JQfUYdI9CGxo9G6hdEh58VXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Junjie Cao <junjie.cao@intel.com>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 176/217] gpio: ml-ioh: share the register lock across channels
Date: Thu, 20 Aug 2026 16:55:44 +0200
Message-ID: <20260820145243.031203164@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Junjie Cao <junjie.cao@intel.com>

[ Upstream commit a9253ee6771c8ab3c6de07ea75d9e2c1cef3cd97 ]

Suspend and resume hold channel 0's lock while saving and restoring
registers for all eight channels. Code paths using the other seven locks
can therefore run concurrently with PM.

Use one controller-wide lock shared by all channels.

Fixes: b490fa0bf86e ("gpio-ml-ioh: Fix suspend/resume issue")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/r/20260731033956.EE6F61F000E9@smtp.kernel.org
Signed-off-by: Junjie Cao <junjie.cao@intel.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260804095935.2132215-1-junjie.cao@intel.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-ml-ioh.c | 69 ++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 32 deletions(-)

diff --git a/drivers/gpio/gpio-ml-ioh.c b/drivers/gpio/gpio-ml-ioh.c
index 86f050ec3338e..031ddf29539cd 100644
--- a/drivers/gpio/gpio-ml-ioh.c
+++ b/drivers/gpio/gpio-ml-ioh.c
@@ -73,7 +73,7 @@ struct ioh_gpio_reg_data {
  * @gpio_use_sel:		Save GPIO_USE_SEL1~4 register for PM
  * @ch:				Indicate GPIO channel
  * @irq_base:		Save base of IRQ number for interrupt
- * @spinlock:		Used for register access protection
+ * @spinlock:		Shared register access lock
  */
 struct ioh_gpio {
 	void __iomem *base;
@@ -84,7 +84,12 @@ struct ioh_gpio {
 	u32 gpio_use_sel;
 	int ch;
 	int irq_base;
+	raw_spinlock_t *spinlock;
+};
+
+struct ioh_gpio_device {
 	raw_spinlock_t spinlock;
+	struct ioh_gpio chip[8];
 };
 
 static const int num_ports[] = {6, 12, 16, 16, 15, 16, 16, 12};
@@ -95,7 +100,7 @@ static int ioh_gpio_set(struct gpio_chip *gpio, unsigned int nr, int val)
 	struct ioh_gpio *chip =	gpiochip_get_data(gpio);
 	unsigned long flags;
 
-	raw_spin_lock_irqsave(&chip->spinlock, flags);
+	raw_spin_lock_irqsave(chip->spinlock, flags);
 	reg_val = ioread32(&chip->reg->regs[chip->ch].po);
 	if (val)
 		reg_val |= BIT(nr);
@@ -103,7 +108,7 @@ static int ioh_gpio_set(struct gpio_chip *gpio, unsigned int nr, int val)
 		reg_val &= ~BIT(nr);
 
 	iowrite32(reg_val, &chip->reg->regs[chip->ch].po);
-	raw_spin_unlock_irqrestore(&chip->spinlock, flags);
+	raw_spin_unlock_irqrestore(chip->spinlock, flags);
 
 	return 0;
 }
@@ -123,7 +128,7 @@ static int ioh_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
 	u32 reg_val;
 	unsigned long flags;
 
-	raw_spin_lock_irqsave(&chip->spinlock, flags);
+	raw_spin_lock_irqsave(chip->spinlock, flags);
 	pm = ioread32(&chip->reg->regs[chip->ch].pm);
 	pm &= BIT(num_ports[chip->ch]) - 1;
 	pm |= BIT(nr);
@@ -136,7 +141,7 @@ static int ioh_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
 		reg_val &= ~BIT(nr);
 	iowrite32(reg_val, &chip->reg->regs[chip->ch].po);
 
-	raw_spin_unlock_irqrestore(&chip->spinlock, flags);
+	raw_spin_unlock_irqrestore(chip->spinlock, flags);
 
 	return 0;
 }
@@ -147,12 +152,12 @@ static int ioh_gpio_direction_input(struct gpio_chip *gpio, unsigned nr)
 	u32 pm;
 	unsigned long flags;
 
-	raw_spin_lock_irqsave(&chip->spinlock, flags);
+	raw_spin_lock_irqsave(chip->spinlock, flags);
 	pm = ioread32(&chip->reg->regs[chip->ch].pm);
 	pm &= BIT(num_ports[chip->ch]) - 1;
 	pm &= ~BIT(nr);
 	iowrite32(pm, &chip->reg->regs[chip->ch].pm);
-	raw_spin_unlock_irqrestore(&chip->spinlock, flags);
+	raw_spin_unlock_irqrestore(chip->spinlock, flags);
 
 	return 0;
 }
@@ -256,7 +261,7 @@ static int ioh_irq_type(struct irq_data *d, unsigned int type)
 	dev_dbg(chip->dev, "%s:irq=%d type=%d ch=%d pos=%d type=%d\n",
 		__func__, irq, type, ch, im_pos, type);
 
-	raw_spin_lock_irqsave(&chip->spinlock, flags);
+	raw_spin_lock_irqsave(chip->spinlock, flags);
 
 	switch (type) {
 	case IRQ_TYPE_EDGE_RISING:
@@ -296,7 +301,7 @@ static int ioh_irq_type(struct irq_data *d, unsigned int type)
 	ien = ioread32(&chip->reg->regs[chip->ch].ien);
 	iowrite32(ien | BIT(ch), &chip->reg->regs[chip->ch].ien);
 end:
-	raw_spin_unlock_irqrestore(&chip->spinlock, flags);
+	raw_spin_unlock_irqrestore(chip->spinlock, flags);
 
 	return 0;
 }
@@ -326,11 +331,11 @@ static void ioh_irq_disable(struct irq_data *d)
 	unsigned long flags;
 	u32 ien;
 
-	raw_spin_lock_irqsave(&chip->spinlock, flags);
+	raw_spin_lock_irqsave(chip->spinlock, flags);
 	ien = ioread32(&chip->reg->regs[chip->ch].ien);
 	ien &= ~BIT(d->irq - chip->irq_base);
 	iowrite32(ien, &chip->reg->regs[chip->ch].ien);
-	raw_spin_unlock_irqrestore(&chip->spinlock, flags);
+	raw_spin_unlock_irqrestore(chip->spinlock, flags);
 }
 
 static void ioh_irq_enable(struct irq_data *d)
@@ -340,11 +345,11 @@ static void ioh_irq_enable(struct irq_data *d)
 	unsigned long flags;
 	u32 ien;
 
-	raw_spin_lock_irqsave(&chip->spinlock, flags);
+	raw_spin_lock_irqsave(chip->spinlock, flags);
 	ien = ioread32(&chip->reg->regs[chip->ch].ien);
 	ien |= BIT(d->irq - chip->irq_base);
 	iowrite32(ien, &chip->reg->regs[chip->ch].ien);
-	raw_spin_unlock_irqrestore(&chip->spinlock, flags);
+	raw_spin_unlock_irqrestore(chip->spinlock, flags);
 }
 
 static irqreturn_t ioh_gpio_handler(int irq, void *dev_id)
@@ -407,8 +412,8 @@ static int ioh_gpio_probe(struct pci_dev *pdev,
 	int ret;
 	int i, j;
 	struct ioh_gpio *chip;
+	struct ioh_gpio_device *priv;
 	void __iomem *base;
-	void *chip_save;
 	int irq_base;
 
 	ret = pcim_enable_device(pdev);
@@ -429,18 +434,18 @@ static int ioh_gpio_probe(struct pci_dev *pdev,
 		return -ENOMEM;
 	}
 
-	chip_save = devm_kcalloc(dev, 8, sizeof(*chip), GFP_KERNEL);
-	if (chip_save == NULL) {
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
 		return -ENOMEM;
-	}
 
-	chip = chip_save;
+	raw_spin_lock_init(&priv->spinlock);
+	chip = priv->chip;
 	for (i = 0; i < 8; i++, chip++) {
 		chip->dev = dev;
 		chip->base = base;
 		chip->reg = chip->base;
 		chip->ch = i;
-		raw_spin_lock_init(&chip->spinlock);
+		chip->spinlock = &priv->spinlock;
 		ioh_gpio_setup(chip, num_ports[i]);
 		ret = devm_gpiochip_add_data(dev, &chip->gpio, chip);
 		if (ret) {
@@ -449,7 +454,7 @@ static int ioh_gpio_probe(struct pci_dev *pdev,
 		}
 	}
 
-	chip = chip_save;
+	chip = priv->chip;
 	for (j = 0; j < 8; j++, chip++) {
 		irq_base = devm_irq_alloc_descs(dev, -1, IOH_IRQ_BASE,
 						num_ports[j], NUMA_NO_NODE);
@@ -466,7 +471,7 @@ static int ioh_gpio_probe(struct pci_dev *pdev,
 			return ret;
 	}
 
-	chip = chip_save;
+	chip = priv->chip;
 	ret = devm_request_irq(dev, pdev->irq, ioh_gpio_handler,
 			       IRQF_SHARED, KBUILD_MODNAME, chip);
 	if (ret != 0) {
@@ -474,33 +479,33 @@ static int ioh_gpio_probe(struct pci_dev *pdev,
 		return ret;
 	}
 
-	pci_set_drvdata(pdev, chip);
+	pci_set_drvdata(pdev, priv);
 
 	return 0;
 }
 
 static int __maybe_unused ioh_gpio_suspend(struct device *dev)
 {
-	struct ioh_gpio *chip = dev_get_drvdata(dev);
+	struct ioh_gpio_device *priv = dev_get_drvdata(dev);
 	unsigned long flags;
 
-	raw_spin_lock_irqsave(&chip->spinlock, flags);
-	ioh_gpio_save_reg_conf(chip);
-	raw_spin_unlock_irqrestore(&chip->spinlock, flags);
+	raw_spin_lock_irqsave(&priv->spinlock, flags);
+	ioh_gpio_save_reg_conf(priv->chip);
+	raw_spin_unlock_irqrestore(&priv->spinlock, flags);
 
 	return 0;
 }
 
 static int __maybe_unused ioh_gpio_resume(struct device *dev)
 {
-	struct ioh_gpio *chip = dev_get_drvdata(dev);
+	struct ioh_gpio_device *priv = dev_get_drvdata(dev);
 	unsigned long flags;
 
-	raw_spin_lock_irqsave(&chip->spinlock, flags);
-	iowrite32(0x01, &chip->reg->srst);
-	iowrite32(0x00, &chip->reg->srst);
-	ioh_gpio_restore_reg_conf(chip);
-	raw_spin_unlock_irqrestore(&chip->spinlock, flags);
+	raw_spin_lock_irqsave(&priv->spinlock, flags);
+	iowrite32(0x01, &priv->chip->reg->srst);
+	iowrite32(0x00, &priv->chip->reg->srst);
+	ioh_gpio_restore_reg_conf(priv->chip);
+	raw_spin_unlock_irqrestore(&priv->spinlock, flags);
 
 	return 0;
 }
-- 
2.53.0



