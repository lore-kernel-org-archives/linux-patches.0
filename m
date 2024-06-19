Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA39143C58;
	Wed, 19 Jun 2024 13:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802234; cv=none; b=ZOqN/1AogFkKhLARlW456Ke7yaMRUGJBiYtIo3RRGPjxVfxwcH/+mJJjna8WLW4+Djt0WPzq9yfAelS9yLWMx8wxv2AytY1bI5CXXcgrq6V4mt+A9KNlWoFrwHaxU9MdTgN5CYI7CfhZisM5McDl1l7edSCivq2OaMPusubiamo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802234; c=relaxed/simple;
	bh=d/IkpUz6uPTk92oeF/WX7T3KME4Dpd0S1i5nLcfKH8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctn7r7vn1Z7zvlVeNOuHzAqlmz9luy41CzCqYHbSbzz7ruCQR0XwMzGTs3KG5QIhe2lRsG9Ii2pKDc3fylFFCdsLOl1tcTsniXBlpVGgfyEYu0Aoax6yD14DBKtReUC2gi9QwT7G4qIdq/MW8b3f+6MScr9zz4nrK4AWy2z0zDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GFnTn+ny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GFnTn+ny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128A7C2BBFC;
	Wed, 19 Jun 2024 13:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802234;
	bh=d/IkpUz6uPTk92oeF/WX7T3KME4Dpd0S1i5nLcfKH8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GFnTn+nyN1pOXTkrDv3DLgoLCWEZ/1Elzy7zkuLTwDgtINoPqgVEccSHY5FScOBZK
	 Iz2RR0hSdrTJbgN8y4vIcqlvGsQF28dhsFO8QyevccxQxMu8NCwiVgI8YSZNlvbufm
	 4QnNLpBrok48EUj+8/5INysAJnbaMglYC4ozQmUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregor Herburger <gregor.herburger@tq-group.com>,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 128/267] gpio: tqmx86: fix broken IRQ_TYPE_EDGE_BOTH interrupt type
Date: Wed, 19 Jun 2024 14:54:39 +0200
Message-ID: <20240619125611.264747309@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

[ Upstream commit 90dd7de4ef7ba584823dfbeba834c2919a4bb55b ]

The TQMx86 GPIO controller only supports falling and rising edge
triggers, but not both. Fix this by implementing a software both-edge
mode that toggles the edge type after every interrupt.

Fixes: b868db94a6a7 ("gpio: tqmx86: Add GPIO from for this IO controller")
Co-developed-by: Gregor Herburger <gregor.herburger@tq-group.com>
Signed-off-by: Gregor Herburger <gregor.herburger@tq-group.com>
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Link: https://lore.kernel.org/r/515324f0491c4d44f4ef49f170354aca002d81ef.1717063994.git.matthias.schiffer@ew.tq-group.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-tqmx86.c | 46 ++++++++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-tqmx86.c b/drivers/gpio/gpio-tqmx86.c
index 7e428c872a257..f2e7e8754d95d 100644
--- a/drivers/gpio/gpio-tqmx86.c
+++ b/drivers/gpio/gpio-tqmx86.c
@@ -32,6 +32,10 @@
 #define TQMX86_GPII_NONE	0
 #define TQMX86_GPII_FALLING	BIT(0)
 #define TQMX86_GPII_RISING	BIT(1)
+/* Stored in irq_type as a trigger type, but not actually valid as a register
+ * value, so the name doesn't use "GPII"
+ */
+#define TQMX86_INT_BOTH		(BIT(0) | BIT(1))
 #define TQMX86_GPII_MASK	(BIT(0) | BIT(1))
 #define TQMX86_GPII_BITS	2
 /* Stored in irq_type with GPII bits */
@@ -113,9 +117,15 @@ static void tqmx86_gpio_irq_config(struct tqmx86_gpio_data *gpio, int offset)
 {
 	u8 type = TQMX86_GPII_NONE, gpiic;
 
-	if (gpio->irq_type[offset] & TQMX86_INT_UNMASKED)
+	if (gpio->irq_type[offset] & TQMX86_INT_UNMASKED) {
 		type = gpio->irq_type[offset] & TQMX86_GPII_MASK;
 
+		if (type == TQMX86_INT_BOTH)
+			type = tqmx86_gpio_get(&gpio->chip, offset + TQMX86_NGPO)
+				? TQMX86_GPII_FALLING
+				: TQMX86_GPII_RISING;
+	}
+
 	gpiic = tqmx86_gpio_read(gpio, TQMX86_GPIIC);
 	gpiic &= ~(TQMX86_GPII_MASK << (offset * TQMX86_GPII_BITS));
 	gpiic |= type << (offset * TQMX86_GPII_BITS);
@@ -169,7 +179,7 @@ static int tqmx86_gpio_irq_set_type(struct irq_data *data, unsigned int type)
 		new_type = TQMX86_GPII_FALLING;
 		break;
 	case IRQ_TYPE_EDGE_BOTH:
-		new_type = TQMX86_GPII_FALLING | TQMX86_GPII_RISING;
+		new_type = TQMX86_INT_BOTH;
 		break;
 	default:
 		return -EINVAL; /* not supported */
@@ -189,8 +199,8 @@ static void tqmx86_gpio_irq_handler(struct irq_desc *desc)
 	struct gpio_chip *chip = irq_desc_get_handler_data(desc);
 	struct tqmx86_gpio_data *gpio = gpiochip_get_data(chip);
 	struct irq_chip *irq_chip = irq_desc_get_chip(desc);
-	unsigned long irq_bits;
-	int i = 0;
+	unsigned long irq_bits, flags;
+	int i;
 	u8 irq_status;
 
 	chained_irq_enter(irq_chip, desc);
@@ -199,6 +209,34 @@ static void tqmx86_gpio_irq_handler(struct irq_desc *desc)
 	tqmx86_gpio_write(gpio, irq_status, TQMX86_GPIIS);
 
 	irq_bits = irq_status;
+
+	raw_spin_lock_irqsave(&gpio->spinlock, flags);
+	for_each_set_bit(i, &irq_bits, TQMX86_NGPI) {
+		/*
+		 * Edge-both triggers are implemented by flipping the edge
+		 * trigger after each interrupt, as the controller only supports
+		 * either rising or falling edge triggers, but not both.
+		 *
+		 * Internally, the TQMx86 GPIO controller has separate status
+		 * registers for rising and falling edge interrupts. GPIIC
+		 * configures which bits from which register are visible in the
+		 * interrupt status register GPIIS and defines what triggers the
+		 * parent IRQ line. Writing to GPIIS always clears both rising
+		 * and falling interrupt flags internally, regardless of the
+		 * currently configured trigger.
+		 *
+		 * In consequence, we can cleanly implement the edge-both
+		 * trigger in software by first clearing the interrupt and then
+		 * setting the new trigger based on the current GPIO input in
+		 * tqmx86_gpio_irq_config() - even if an edge arrives between
+		 * reading the input and setting the trigger, we will have a new
+		 * interrupt pending.
+		 */
+		if ((gpio->irq_type[i] & TQMX86_GPII_MASK) == TQMX86_INT_BOTH)
+			tqmx86_gpio_irq_config(gpio, i);
+	}
+	raw_spin_unlock_irqrestore(&gpio->spinlock, flags);
+
 	for_each_set_bit(i, &irq_bits, TQMX86_NGPI)
 		generic_handle_domain_irq(gpio->chip.irq.domain,
 					  i + TQMX86_NGPO);
-- 
2.43.0



