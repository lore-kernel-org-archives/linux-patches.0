Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE942D023;
	Mon, 10 Mar 2025 17:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629264; cv=none; b=Y+pe9lBMV+4AKjlTDs6fd2fpheAV1Y+g1pxBE8lS/DG+SddKmJCwzK0KM3VcUTiQiff6KXx6MiMlWhhib0Fs3X9Cw+fxteZ5cFS90d2CxEL9F27KRQYKwvnaMel9nY/HkGI6mDcFbjzCquOLx2xCjs3bSRyaTi/M8o5ueobHec0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629264; c=relaxed/simple;
	bh=CwB5TsXKo7TNTZyryFueDMoaXDHYTjLMJeoFvvRv4OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpNTalwaW5fcUGbkz6juTcdR5cPLTLPsfPiiUyGACioix4Pod0U/PnBEgTKFuJmD7Q90FcK3SU6Nlpg92ZrojGaiZTSYD81BjXXnwzJAmWVWuqVD41NCV+xQPuzn+XE1YuQVmUx8XwypRaz9pywDFdp3UMJm84NTc9XQWRTufVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VuPJANTP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VuPJANTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B01C4CEE5;
	Mon, 10 Mar 2025 17:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629264;
	bh=CwB5TsXKo7TNTZyryFueDMoaXDHYTjLMJeoFvvRv4OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VuPJANTPxrdUg+hxEmDZaSehUX/xwGOcNUeeKMR0QCmivKjPE68i1ciDHSXrHiZKC
	 UvXfvvRYJT3vLABCP9Cd2/errTHiTvUTCLSf7z/lUwMUK4gFUuIOs7m3m6pZvtckCa
	 07iVFvABm3v2Pwofh/hcGMh5Ch+O/DOZEnLQbOBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 234/620] gpio: xilinx: Convert to immutable irq_chip
Date: Mon, 10 Mar 2025 18:01:20 +0100
Message-ID: <20250310170554.870504946@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index db616ae560a3c..067ac1805853c 100644
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



