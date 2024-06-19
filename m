Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C365713D8BF;
	Wed, 19 Jun 2024 13:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803854; cv=none; b=clTypieU6t3PKlKaJ+3J5I0xM6+iYStIqIKF3NNwl8Pm3cOFRvu89oYhPVeOrffalPX+BjrOzXZiFXZPL7j83cSFnCAKgTLS4+ECWlNAbtiGG/uEmyJv86kynLwp0xQP02dLpkm4BvgjlWGNIUZVkbgQm3dgyx8H7ArkWxU7flY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803854; c=relaxed/simple;
	bh=PXpMJV1i65w/6WQaRwApB6LrLFYIYqs9nuPN9DMU03U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mR9UWjvbOBqEW+yWC4ljRtEk3H4exZ1FJFcFd+ZIasDczcJW+5x6rMbmxvDtJ4bFtK8mXQrHzINOlABvRa9T0grIoEAbeYgaunVAc0sCbVB8oRmxii8fBUjg/lr1Zm1MriWuf6usZDCnhErdjynazwrt0UjFPLVvrrE90IPkjME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nSSOjNGL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nSSOjNGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F88C2BBFC;
	Wed, 19 Jun 2024 13:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803854;
	bh=PXpMJV1i65w/6WQaRwApB6LrLFYIYqs9nuPN9DMU03U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nSSOjNGLWK51S65mHfZovNrRkITbV5KhjN4gvbehLGqAbIYHpfEPhWar5XeO5s9kh
	 qcSiThmpf3v00v4n0raBqr0+NVRkmI2NR9lA9GJO25CrdjsxNlWskFFWWpVWlSRXeB
	 ANn3Dsti1CkwYnh4Liz9JCyH6tBXhl+7XAsGP+OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 126/217] gpio: tqmx86: introduce shadow register for GPIO output value
Date: Wed, 19 Jun 2024 14:56:09 +0200
Message-ID: <20240619125601.551177671@linuxfoundation.org>
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

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

[ Upstream commit 9d6a811b522ba558bcb4ec01d12e72a0af8e9f6e ]

The TQMx86 GPIO controller uses the same register address for input and
output data. Reading the register will always return current inputs
rather than the previously set outputs (regardless of the current
direction setting). Therefore, using a RMW pattern does not make sense
when setting output values. Instead, the previously set output register
value needs to be stored as a shadow register.

As there is no reliable way to get the current output values from the
hardware, also initialize all channels to 0, to ensure that stored and
actual output values match. This should usually not have any effect in
practise, as the TQMx86 UEFI sets all outputs to 0 during boot.

Also prepare for extension of the driver to more than 8 GPIOs by using
DECLARE_BITMAP.

Fixes: b868db94a6a7 ("gpio: tqmx86: Add GPIO from for this IO controller")
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/d0555933becd45fa92a85675d26e4d59343ddc01.1717063994.git.matthias.schiffer@ew.tq-group.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-tqmx86.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/gpio-tqmx86.c b/drivers/gpio/gpio-tqmx86.c
index f0a2cf4b06796..da689b5b3fad2 100644
--- a/drivers/gpio/gpio-tqmx86.c
+++ b/drivers/gpio/gpio-tqmx86.c
@@ -6,6 +6,7 @@
  *   Vadim V.Vlasov <vvlasov@dev.rtsoft.ru>
  */
 
+#include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/gpio/driver.h>
@@ -38,6 +39,7 @@ struct tqmx86_gpio_data {
 	void __iomem		*io_base;
 	int			irq;
 	raw_spinlock_t		spinlock;
+	DECLARE_BITMAP(output, TQMX86_NGPIO);
 	u8			irq_type[TQMX86_NGPI];
 };
 
@@ -64,15 +66,10 @@ static void tqmx86_gpio_set(struct gpio_chip *chip, unsigned int offset,
 {
 	struct tqmx86_gpio_data *gpio = gpiochip_get_data(chip);
 	unsigned long flags;
-	u8 val;
 
 	raw_spin_lock_irqsave(&gpio->spinlock, flags);
-	val = tqmx86_gpio_read(gpio, TQMX86_GPIOD);
-	if (value)
-		val |= BIT(offset);
-	else
-		val &= ~BIT(offset);
-	tqmx86_gpio_write(gpio, val, TQMX86_GPIOD);
+	__assign_bit(offset, gpio->output, value);
+	tqmx86_gpio_write(gpio, bitmap_get_value8(gpio->output, 0), TQMX86_GPIOD);
 	raw_spin_unlock_irqrestore(&gpio->spinlock, flags);
 }
 
@@ -259,6 +256,13 @@ static int tqmx86_gpio_probe(struct platform_device *pdev)
 
 	tqmx86_gpio_write(gpio, (u8)~TQMX86_DIR_INPUT_MASK, TQMX86_GPIODD);
 
+	/*
+	 * Reading the previous output state is not possible with TQMx86 hardware.
+	 * Initialize all outputs to 0 to have a defined state that matches the
+	 * shadow register.
+	 */
+	tqmx86_gpio_write(gpio, 0, TQMX86_GPIOD);
+
 	chip = &gpio->chip;
 	chip->label = "gpio-tqmx86";
 	chip->owner = THIS_MODULE;
-- 
2.43.0



