Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13B3432304;
	Sat, 12 Sep 2026 08:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202653; cv=none; b=PdhqPXjRhrviyTN9MWc7jzJG+9JkD/5XhHhRC5BQTQWYQHx1igASgFWULjspAY8Ns49NckLbFqNXmsgP0k6ZdUl9Y9lC/pUcJ9AXwtCoAMEfWCXSg/t1sJGMqquUHsI47tCehEoHug/KEc7oD4r67V16+doNmQEQq4wRg8hFpCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202653; c=relaxed/simple;
	bh=DFgbQjFOBCRrxTY8nHXha7P5BUKX9Aq0EY14cCKZLJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i6sV/P3zR35cpbAaYB85m37F0/32p1kdf4x2trPIdPVNwjP5J07ab5CevZKpaurKXx9efOJJrH+2f0X0aK5COIja8XD7us0upcbVJtakTjJZO4bVvogRfZ5e5aymXJqGROW9LyI/OspvgLa82RPWkLkNml/x8vNyyYDhgCHW+LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMB/u8Md; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMB/u8Md"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF941F000FF;
	Sat, 12 Sep 2026 08:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202647;
	bh=vyrYbV/a3MnrnkkGwfH3Bg4LDBP3ogTUsjegzCk8BHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aMB/u8Md7/ZPjZKgI8nc9mmaXE2gPVbjOIFbc8QYONT8BXYYMw9ZtDq0Rl6GlBUWR
	 L6w7MY2Awmxwxd6EO9zZMlSKUZpon4rQLBGbIeXkVXx6PZrVzglhvuiQtfEgZ+Fa3r
	 1dVviCQPVYWJfwu4+qt+C2JI79Ab5USF8Q7Qo1R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1247/1815] pinctrl: airoha: fix edge-triggered interrupts handling
Date: Sat, 12 Sep 2026 08:49:57 +0200
Message-ID: <20260912065718.290065712@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>

[ Upstream commit 3de4686cdf0ccf6d78ca96ccaea621cbcf69fc3a ]

Edge-triggered interrupts are handled incorrectly because of
 * no irq_ack() handler was defined,
 * no handle_level_irq() handler was used,

This patch probably fixes an issue

Fixes: 1c8ace2d0725 ("pinctrl: airoha: Add support for EN7581 SoC")
Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/airoha/pinctrl-airoha.c | 37 ++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/airoha/pinctrl-airoha.c b/drivers/pinctrl/airoha/pinctrl-airoha.c
index 0be1fb9b918a2..6a40a776d3158 100644
--- a/drivers/pinctrl/airoha/pinctrl-airoha.c
+++ b/drivers/pinctrl/airoha/pinctrl-airoha.c
@@ -2579,11 +2579,28 @@ static void airoha_irq_mask(struct irq_data *data)
 	u8 index = data->hwirq / AIROHA_REG_GPIOCTRL_NUM_PIN;
 	u32 mask = GENMASK(2 * offset + 1, 2 * offset);
 
+	if (data->hwirq >= ARRAY_SIZE(gpiochip->irq_type))
+		return;
+
 	regmap_clear_bits(pinctrl->regmap, gpiochip->level[index], mask);
 	regmap_clear_bits(pinctrl->regmap, gpiochip->edge[index], mask);
 	gpiochip_disable_irq(gc, irqd_to_hwirq(data));
 }
 
+static void airoha_irq_ack(struct irq_data *data)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(data);
+	struct airoha_pinctrl *pinctrl = gpiochip_get_data(gc);
+	struct airoha_pinctrl_gpiochip *gpiochip = &pinctrl->gpiochip;
+	u8 offset = data->hwirq % AIROHA_PIN_BANK_SIZE;
+	u8 index = data->hwirq / AIROHA_PIN_BANK_SIZE;
+
+	if (data->hwirq >= ARRAY_SIZE(gpiochip->irq_type))
+		return;
+
+	regmap_write(pinctrl->regmap, gpiochip->status[index], BIT(offset));
+}
+
 static int airoha_irq_type(struct irq_data *data, unsigned int type)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(data);
@@ -2593,13 +2610,26 @@ static int airoha_irq_type(struct irq_data *data, unsigned int type)
 	if (data->hwirq >= ARRAY_SIZE(gpiochip->irq_type))
 		return -EINVAL;
 
+	if (type == IRQ_TYPE_NONE) {
+		gpiochip->irq_type[data->hwirq] = IRQ_TYPE_NONE;
+		irq_set_handler_locked(data, handle_bad_irq);
+
+		return 0;
+	}
+
 	if (type == IRQ_TYPE_PROBE) {
 		if (gpiochip->irq_type[data->hwirq])
 			return 0;
 
 		type = IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING;
 	}
+
 	gpiochip->irq_type[data->hwirq] = type & IRQ_TYPE_SENSE_MASK;
+	if (type & IRQ_TYPE_EDGE_BOTH)
+		irq_set_handler_locked(data, handle_edge_irq);
+	else
+		irq_set_handler_locked(data, handle_level_irq);
+
 
 	return 0;
 }
@@ -2624,8 +2654,7 @@ static irqreturn_t airoha_irq_handler(int irq, void *data)
 		for_each_set_bit(irq, &status, AIROHA_PIN_BANK_SIZE) {
 			u32 offset = irq + i * AIROHA_PIN_BANK_SIZE;
 
-			generic_handle_irq(irq_find_mapping(girq->domain,
-							    offset));
+			generic_handle_domain_irq(girq->domain, offset);
 			regmap_write(pinctrl->regmap,
 				     pinctrl->gpiochip.status[i], BIT(irq));
 		}
@@ -2639,7 +2668,7 @@ static const struct irq_chip airoha_gpio_irq_chip = {
 	.name = "airoha-gpio-irq",
 	.irq_unmask = airoha_irq_unmask,
 	.irq_mask = airoha_irq_mask,
-	.irq_mask_ack = airoha_irq_mask,
+	.irq_ack = airoha_irq_ack,
 	.irq_set_type = airoha_irq_type,
 	.flags = IRQCHIP_SET_TYPE_MASKED | IRQCHIP_IMMUTABLE,
 	GPIOCHIP_IRQ_RESOURCE_HELPERS,
@@ -2667,7 +2696,7 @@ static int airoha_pinctrl_add_gpiochip(struct airoha_pinctrl *pinctrl,
 	gc->ngpio = AIROHA_NUM_PINS;
 
 	girq->default_type = IRQ_TYPE_NONE;
-	girq->handler = handle_simple_irq;
+	girq->handler = handle_bad_irq;
 	gpio_irq_chip_set_chip(girq, &airoha_gpio_irq_chip);
 
 	irq = platform_get_irq(pdev, 0);
-- 
2.53.0



