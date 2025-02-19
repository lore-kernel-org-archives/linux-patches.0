Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F230A1C2DC8;
	Wed, 19 Feb 2025 09:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957297; cv=none; b=cHV71v+Ji/MQxx/1GaNubwszjVdmnJDk4F/A3FHL6MVe99vOaiQUBrR2fjNAFoHJIoYF1DDUcLwhokKIsllVDvB2XnOsNW781TvkHdYVOz7AP5G5Brqjg3oFQRTkk+iphu3eZFoF/e2uxtb1n1IAVGiC1UgOqP4mgr6M4gyYgp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957297; c=relaxed/simple;
	bh=VpCjbcWEZEVx1RFsKl+hQGSgkZoG1tKsZJGoT/3Ga/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=epUmwWjE1Tkqjsl1+7YicUSAZsNeW3xIBXu+y+gPXm2wtxFOkl0ybqyFa6xUvjSV8N8AByHVKEDSpGq5YpCeICe1Al5yZVLU+C7lYLakFmJ3web4tMacWvb192bweb1AOF9LN72T3BfXS3TQtJYyq+KR1HMRl0IG2KbK6pqOUww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RgNmh+z9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RgNmh+z9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228AAC4CED1;
	Wed, 19 Feb 2025 09:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957296;
	bh=VpCjbcWEZEVx1RFsKl+hQGSgkZoG1tKsZJGoT/3Ga/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RgNmh+z9gzpDsgzDSEaj8HAssmvOEJRq9Oz4LMka6TL+Yb/CJnL5ZyAJzsuN8g/42
	 uRvfYc/dDsoIJxfujXjrY56RqeHIo+6j93caPDlYb28ZMBb0DS9g9IQpzDHCMOi1Oo
	 89zxEjiIM25oKkh8jojNooLW/90vRYfC82hKUvCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Markus Mayer <mmayer@broadcom.com>,
	Artur Weber <aweber.kernel@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 476/578] gpio: bcm-kona: Make sure GPIO bits are unlocked when requesting IRQ
Date: Wed, 19 Feb 2025 09:28:00 +0100
Message-ID: <20250219082711.729916458@linuxfoundation.org>
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

From: Artur Weber <aweber.kernel@gmail.com>

[ Upstream commit 57f5db77a915cc29461a679a6bcae7097967be1a ]

The settings for all GPIOs are locked by default in bcm_kona_gpio_reset.
The settings for a GPIO are unlocked when requesting it as a GPIO, but
not when requesting it as an interrupt, causing the IRQ settings to not
get applied.

Fix this by making sure to unlock the right bits when an IRQ is requested.
To avoid a situation where an IRQ being released causes a lock despite
the same GPIO being used by a GPIO request or vice versa, add an unlock
counter and only lock if it reaches 0.

Fixes: 757651e3d60e ("gpio: bcm281xx: Add GPIO driver")
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Markus Mayer <mmayer@broadcom.com>
Signed-off-by: Artur Weber <aweber.kernel@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20250206-kona-gpio-fixes-v2-2-409135eab780@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-bcm-kona.c | 67 +++++++++++++++++++++++++++++-------
 1 file changed, 55 insertions(+), 12 deletions(-)

diff --git a/drivers/gpio/gpio-bcm-kona.c b/drivers/gpio/gpio-bcm-kona.c
index 7e8adc5cc15a0..602021e3e683e 100644
--- a/drivers/gpio/gpio-bcm-kona.c
+++ b/drivers/gpio/gpio-bcm-kona.c
@@ -68,6 +68,22 @@ struct bcm_kona_gpio {
 struct bcm_kona_gpio_bank {
 	int id;
 	int irq;
+	/*
+	 * Used to keep track of lock/unlock operations for each GPIO in the
+	 * bank.
+	 *
+	 * All GPIOs are locked by default (see bcm_kona_gpio_reset), and the
+	 * unlock count for all GPIOs is 0 by default. Each unlock increments
+	 * the counter, and each lock decrements the counter.
+	 *
+	 * The lock function only locks the GPIO once its unlock counter is
+	 * down to 0. This is necessary because the GPIO is unlocked in two
+	 * places in this driver: once for requested GPIOs, and once for
+	 * requested IRQs. Since it is possible for a GPIO to be requested
+	 * as both a GPIO and an IRQ, we need to ensure that we don't lock it
+	 * too early.
+	 */
+	u8 gpio_unlock_count[GPIO_PER_BANK];
 	/* Used in the interrupt handler */
 	struct bcm_kona_gpio *kona_gpio;
 };
@@ -86,14 +102,23 @@ static void bcm_kona_gpio_lock_gpio(struct bcm_kona_gpio *kona_gpio,
 	unsigned long flags;
 	int bank_id = GPIO_BANK(gpio);
 	int bit = GPIO_BIT(gpio);
+	struct bcm_kona_gpio_bank *bank = &kona_gpio->banks[bank_id];
 
-	raw_spin_lock_irqsave(&kona_gpio->lock, flags);
+	if (bank->gpio_unlock_count[bit] == 0) {
+		dev_err(kona_gpio->gpio_chip.parent,
+			"Unbalanced locks for GPIO %u\n", gpio);
+		return;
+	}
 
-	val = readl(kona_gpio->reg_base + GPIO_PWD_STATUS(bank_id));
-	val |= BIT(bit);
-	bcm_kona_gpio_write_lock_regs(kona_gpio->reg_base, bank_id, val);
+	if (--bank->gpio_unlock_count[bit] == 0) {
+		raw_spin_lock_irqsave(&kona_gpio->lock, flags);
 
-	raw_spin_unlock_irqrestore(&kona_gpio->lock, flags);
+		val = readl(kona_gpio->reg_base + GPIO_PWD_STATUS(bank_id));
+		val |= BIT(bit);
+		bcm_kona_gpio_write_lock_regs(kona_gpio->reg_base, bank_id, val);
+
+		raw_spin_unlock_irqrestore(&kona_gpio->lock, flags);
+	}
 }
 
 static void bcm_kona_gpio_unlock_gpio(struct bcm_kona_gpio *kona_gpio,
@@ -103,14 +128,19 @@ static void bcm_kona_gpio_unlock_gpio(struct bcm_kona_gpio *kona_gpio,
 	unsigned long flags;
 	int bank_id = GPIO_BANK(gpio);
 	int bit = GPIO_BIT(gpio);
+	struct bcm_kona_gpio_bank *bank = &kona_gpio->banks[bank_id];
 
-	raw_spin_lock_irqsave(&kona_gpio->lock, flags);
+	if (bank->gpio_unlock_count[bit] == 0) {
+		raw_spin_lock_irqsave(&kona_gpio->lock, flags);
 
-	val = readl(kona_gpio->reg_base + GPIO_PWD_STATUS(bank_id));
-	val &= ~BIT(bit);
-	bcm_kona_gpio_write_lock_regs(kona_gpio->reg_base, bank_id, val);
+		val = readl(kona_gpio->reg_base + GPIO_PWD_STATUS(bank_id));
+		val &= ~BIT(bit);
+		bcm_kona_gpio_write_lock_regs(kona_gpio->reg_base, bank_id, val);
 
-	raw_spin_unlock_irqrestore(&kona_gpio->lock, flags);
+		raw_spin_unlock_irqrestore(&kona_gpio->lock, flags);
+	}
+
+	++bank->gpio_unlock_count[bit];
 }
 
 static int bcm_kona_gpio_get_dir(struct gpio_chip *chip, unsigned gpio)
@@ -361,6 +391,7 @@ static void bcm_kona_gpio_irq_mask(struct irq_data *d)
 
 	kona_gpio = irq_data_get_irq_chip_data(d);
 	reg_base = kona_gpio->reg_base;
+
 	raw_spin_lock_irqsave(&kona_gpio->lock, flags);
 
 	val = readl(reg_base + GPIO_INT_MASK(bank_id));
@@ -383,6 +414,7 @@ static void bcm_kona_gpio_irq_unmask(struct irq_data *d)
 
 	kona_gpio = irq_data_get_irq_chip_data(d);
 	reg_base = kona_gpio->reg_base;
+
 	raw_spin_lock_irqsave(&kona_gpio->lock, flags);
 
 	val = readl(reg_base + GPIO_INT_MSKCLR(bank_id));
@@ -478,15 +510,26 @@ static void bcm_kona_gpio_irq_handler(struct irq_desc *desc)
 static int bcm_kona_gpio_irq_reqres(struct irq_data *d)
 {
 	struct bcm_kona_gpio *kona_gpio = irq_data_get_irq_chip_data(d);
+	unsigned int gpio = d->hwirq;
+
+	/*
+	 * We need to unlock the GPIO before any other operations are performed
+	 * on the relevant GPIO configuration registers
+	 */
+	bcm_kona_gpio_unlock_gpio(kona_gpio, gpio);
 
-	return gpiochip_reqres_irq(&kona_gpio->gpio_chip, d->hwirq);
+	return gpiochip_reqres_irq(&kona_gpio->gpio_chip, gpio);
 }
 
 static void bcm_kona_gpio_irq_relres(struct irq_data *d)
 {
 	struct bcm_kona_gpio *kona_gpio = irq_data_get_irq_chip_data(d);
+	unsigned int gpio = d->hwirq;
+
+	/* Once we no longer use it, lock the GPIO again */
+	bcm_kona_gpio_lock_gpio(kona_gpio, gpio);
 
-	gpiochip_relres_irq(&kona_gpio->gpio_chip, d->hwirq);
+	gpiochip_relres_irq(&kona_gpio->gpio_chip, gpio);
 }
 
 static struct irq_chip bcm_gpio_irq_chip = {
-- 
2.39.5



