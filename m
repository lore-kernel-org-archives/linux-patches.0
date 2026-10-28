Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209988;
	b=cUjtoTA3vkq6eL7W/iYmFQwxc7K7XxUKxewrDe2wLAgoRdW7gIGBPjJcDlf6O+dxT78O
	 uIgZU4hfpwWNQLrFIvNUr/QP9poM9cR+l6G/Dk5QfPWu1kwzIhYUB/ETZs/37GYEFkkab
	 V/OS0gTZuq1Q21+w7OlSevzlCsHXW+YqewRx7b3xB1GhpzeHKMzvwBx1UmPvlHXsnZPIH
	 JFQeF5Z2Ul3lY/Q/r1dgPEPpTBqQoNkQ+R2GiXBf6/ae98NBqSdTKeDBhTCdFqS7lBfpM
	 LM7DqFOFp9V/4G8knveaavwTaBaFWdGtWb+u6CpRURc2eROgs/n03J5gp+jgfHwr7RA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209988;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gk5v8IWj51bAusijIc7/pIACThnjl7r5skocu+ivKq4=;
	b=kTIOyk+hamMbQMJ7O8IX120COTCVNzqjP3MxYxLADmBRQdGT1yCUhT8OI/L/J0SflN4o
	 FZv639ed4F0QyyH7tgqU2qCbGsZyMd2xQHS3rNR9Zne3c4b2PyMckMqi4mD1Lf9Lt+Qug
	 lW+tipOHnsQZKw++S0s12QD9srSqkcHU7RmCpaT/EpF/ktW5lfFH8m1AKaSgx9lYQVgr4
	 zympvqv7dgOYLXgsnwZzKIXZI9k7Sn1iwGeDA/aR0OamQxChsyWq3pD2AooexcY26wk8u
	 9s8VuKBt2EzQbuuqOg0MOCRzJUvG3citj/zzfNwPac9ig8kZFOSu9TjUh3vobpTSJ3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SW25LkVp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7136C606A31A;
	Wed, 28 Oct 2026 17:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SW25LkVp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C77B1F01825;
	Wed, 28 Oct 2026 17:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209988;
	bh=Gk5v8IWj51bAusijIc7/pIACThnjl7r5skocu+ivKq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SW25LkVpuLpgokUCTq1j0G9CIRZbbj9mae8SukfyIjpOUIJ78EQDmXkSGQZYllMKg
	 cItP4F4S3RbjaGGC9zTN8RWhU35MmNlL/3wkUZWajfbuRfBNc56A4a/0cEg3MDUFM/
	 gkgmv8fKmhwqK8Gk7/+piB9bpzUn6eGG7F2kXF4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/168] gpio: mxc: use lock guards for the generic GPIO chip lock
Date: Wed, 28 Oct 2026 17:59:32 +0100
Message-ID: <20261028165943.947923748@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit ba441322c7aac4735d78fc6781e497a01fb8eac7 ]

Simplify the code by using lock guards for the bgpio_lock.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20250702-gpio-mmio-rework-v2-2-6b77aab684d8@linaro.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: b7719c575dec ("gpio: mxc: fix both_edges bit operations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mxc.c | 48 ++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index a8ab78ae7fa30..4b469ec089e4f 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -7,6 +7,7 @@
 // Authors: Daniel Mack, Juergen Beisert.
 // Copyright (C) 2004-2010 Freescale Semiconductor, Inc. All Rights Reserved.
 
+#include <linux/cleanup.h>
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -161,7 +162,6 @@ static int gpio_set_irq_type(struct irq_data *d, u32 type)
 {
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	struct mxc_gpio_port *port = gc->private;
-	unsigned long flags;
 	u32 bit, val;
 	u32 gpio_idx = d->hwirq;
 	int edge;
@@ -200,41 +200,38 @@ static int gpio_set_irq_type(struct irq_data *d, u32 type)
 		return -EINVAL;
 	}
 
-	raw_spin_lock_irqsave(&port->gc.bgpio_lock, flags);
+	scoped_guard(raw_spinlock_irqsave, &port->gc.bgpio_lock) {
+		if (GPIO_EDGE_SEL >= 0) {
+			val = readl(port->base + GPIO_EDGE_SEL);
+			if (edge == GPIO_INT_BOTH_EDGES)
+				writel(val | (1 << gpio_idx),
+				       port->base + GPIO_EDGE_SEL);
+			else
+				writel(val & ~(1 << gpio_idx),
+				       port->base + GPIO_EDGE_SEL);
+		}
 
-	if (GPIO_EDGE_SEL >= 0) {
-		val = readl(port->base + GPIO_EDGE_SEL);
-		if (edge == GPIO_INT_BOTH_EDGES)
-			writel(val | (1 << gpio_idx),
-				port->base + GPIO_EDGE_SEL);
-		else
-			writel(val & ~(1 << gpio_idx),
-				port->base + GPIO_EDGE_SEL);
-	}
+		if (edge != GPIO_INT_BOTH_EDGES) {
+			reg += GPIO_ICR1 + ((gpio_idx & 0x10) >> 2); /* lower or upper register */
+			bit = gpio_idx & 0xf;
+			val = readl(reg) & ~(0x3 << (bit << 1));
+			writel(val | (edge << (bit << 1)), reg);
+		}
 
-	if (edge != GPIO_INT_BOTH_EDGES) {
-		reg += GPIO_ICR1 + ((gpio_idx & 0x10) >> 2); /* lower or upper register */
-		bit = gpio_idx & 0xf;
-		val = readl(reg) & ~(0x3 << (bit << 1));
-		writel(val | (edge << (bit << 1)), reg);
+		writel(1 << gpio_idx, port->base + GPIO_ISR);
+		port->pad_type[gpio_idx] = type;
 	}
 
-	writel(1 << gpio_idx, port->base + GPIO_ISR);
-	port->pad_type[gpio_idx] = type;
-
-	raw_spin_unlock_irqrestore(&port->gc.bgpio_lock, flags);
-
 	return port->gc.direction_input(&port->gc, gpio_idx);
 }
 
 static void mxc_flip_edge(struct mxc_gpio_port *port, u32 gpio)
 {
 	void __iomem *reg = port->base;
-	unsigned long flags;
 	u32 bit, val;
 	int edge;
 
-	raw_spin_lock_irqsave(&port->gc.bgpio_lock, flags);
+	guard(raw_spinlock_irqsave)(&port->gc.bgpio_lock);
 
 	reg += GPIO_ICR1 + ((gpio & 0x10) >> 2); /* lower or upper register */
 	bit = gpio & 0xf;
@@ -250,12 +247,9 @@ static void mxc_flip_edge(struct mxc_gpio_port *port, u32 gpio)
 	} else {
 		pr_err("mxc: invalid configuration for GPIO %d: %x\n",
 		       gpio, edge);
-		goto unlock;
+		return;
 	}
 	writel(val | (edge << (bit << 1)), reg);
-
-unlock:
-	raw_spin_unlock_irqrestore(&port->gc.bgpio_lock, flags);
 }
 
 /* handle 32 interrupts in one status register */
-- 
2.53.0



