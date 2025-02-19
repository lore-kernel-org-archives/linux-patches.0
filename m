Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7CE1BEF71;
	Wed, 19 Feb 2025 09:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956916; cv=none; b=uB+S0tfFLgHVJrf3/q8I0SzFX8W9ZWvaMrqz3fdcCEpbQadwnM8l8iq57Uti6fd8ziaQnZA5ZhlrO6gwoN/lG/3/gn+zPyGyOaZ9QtJiVqmc2Oz5LvzjHs/BD/VTJccCcxdINgOZE6xDbCX1/ZNfyxvozO59VswUmB7DnkCgPzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956916; c=relaxed/simple;
	bh=163sDyXac2kydKDsoDMtycwit8QMmhFsY2v1qvl/cr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jC47TpE+QAkd9ebCovzhUyNsfJB6NEiNQik6WCQCUZfSquXntBjV6czk4o+OZOIkywWpsB/fxvaEmemctikZ8OC4cjgRoSYg8WSDI93hBGxdOIe1J9XBw+3ZfCxdihSdYY+1zPita7mJbgypQ/XwFrt6zypZxl+4Dv+bs1iSTBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s7ooxLHI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s7ooxLHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF0FC4CED1;
	Wed, 19 Feb 2025 09:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956916;
	bh=163sDyXac2kydKDsoDMtycwit8QMmhFsY2v1qvl/cr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s7ooxLHI2xW4EVkf40f7m4/DcGmpN9i+R1wHfueCinMJLF77wHZJ7/SvVGnzHMXiC
	 PN/ieH7KHz3qlVbnkvd13HmKrpy6auHfnMNteDCue3Jk5UApEWTLOGYtYMYT/jFDwo
	 EIzDK+J5Ljh0n+gKDDP3Rb0RYaqs6vuWbwJNbIbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 317/578] gpio: xilinx: Convert to immutable irq_chip
Date: Wed, 19 Feb 2025 09:25:21 +0100
Message-ID: <20250219082705.482699856@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit b4510f8fd5d0e9afa777f115871f5d522540c417 ]

Convert the driver to immutable irq-chip with a bit of
intuition.

Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: 9860370c2172 ("gpio: xilinx: Convert gpio_lock to raw spinlock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-xilinx.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/gpio-xilinx.c b/drivers/gpio/gpio-xilinx.c
index 2fc6b6ff7f165..31f05c7d5915e 100644
--- a/drivers/gpio/gpio-xilinx.c
+++ b/drivers/gpio/gpio-xilinx.c
@@ -68,7 +68,6 @@ struct xgpio_instance {
 	DECLARE_BITMAP(dir, 64);
 	spinlock_t gpio_lock;	/* For serializing operations */
 	int irq;
-	struct irq_chip irqchip;
 	DECLARE_BITMAP(enable, 64);
 	DECLARE_BITMAP(rising_edge, 64);
 	DECLARE_BITMAP(falling_edge, 64);
@@ -416,6 +415,8 @@ static void xgpio_irq_mask(struct irq_data *irq_data)
 		xgpio_writereg(chip->regs + XGPIO_IPIER_OFFSET, temp);
 	}
 	spin_unlock_irqrestore(&chip->gpio_lock, flags);
+
+	gpiochip_disable_irq(&chip->gc, irq_offset);
 }
 
 /**
@@ -431,6 +432,8 @@ static void xgpio_irq_unmask(struct irq_data *irq_data)
 	u32 old_enable = xgpio_get_value32(chip->enable, bit);
 	u32 mask = BIT(bit / 32), val;
 
+	gpiochip_enable_irq(&chip->gc, irq_offset);
+
 	spin_lock_irqsave(&chip->gpio_lock, flags);
 
 	__set_bit(bit, chip->enable);
@@ -544,6 +547,16 @@ static void xgpio_irqhandler(struct irq_desc *desc)
 	chained_irq_exit(irqchip, desc);
 }
 
+static const struct irq_chip xgpio_irq_chip = {
+	.name = "gpio-xilinx",
+	.irq_ack = xgpio_irq_ack,
+	.irq_mask = xgpio_irq_mask,
+	.irq_unmask = xgpio_irq_unmask,
+	.irq_set_type = xgpio_set_irq_type,
+	.flags = IRQCHIP_IMMUTABLE,
+	GPIOCHIP_IRQ_RESOURCE_HELPERS,
+};
+
 /**
  * xgpio_probe - Probe method for the GPIO device.
  * @pdev: pointer to the platform device
@@ -664,12 +677,6 @@ static int xgpio_probe(struct platform_device *pdev)
 	if (chip->irq <= 0)
 		goto skip_irq;
 
-	chip->irqchip.name = "gpio-xilinx";
-	chip->irqchip.irq_ack = xgpio_irq_ack;
-	chip->irqchip.irq_mask = xgpio_irq_mask;
-	chip->irqchip.irq_unmask = xgpio_irq_unmask;
-	chip->irqchip.irq_set_type = xgpio_set_irq_type;
-
 	/* Disable per-channel interrupts */
 	xgpio_writereg(chip->regs + XGPIO_IPIER_OFFSET, 0);
 	/* Clear any existing per-channel interrupts */
@@ -679,7 +686,7 @@ static int xgpio_probe(struct platform_device *pdev)
 	xgpio_writereg(chip->regs + XGPIO_GIER_OFFSET, XGPIO_GIER_IE);
 
 	girq = &chip->gc.irq;
-	girq->chip = &chip->irqchip;
+	gpio_irq_chip_set_chip(girq, &xgpio_irq_chip);
 	girq->parent_handler = xgpio_irqhandler;
 	girq->num_parents = 1;
 	girq->parents = devm_kcalloc(&pdev->dev, 1,
-- 
2.39.5



