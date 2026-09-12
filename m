Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF4847124F;
	Sat, 12 Sep 2026 10:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210400; cv=none; b=FXe3hLqwPzdDFtvoOWg11QJYJH1txDCSyhzkqNoUpwzJ/rSR9cy3ILIcBbZYm5qH2t3gR0Rerx3TOYhJRuezzi6+s11qgrbQWq99TvZ4ok913s/SBnGnN7vkIGovaP2NICnps9Etiv00Ps56geq3j4vbABqZj/hpSwrMGv2meQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210400; c=relaxed/simple;
	bh=V/hXY50GUtzk9R/wv/XjQ8R4JxFKzLjX4fct9ofuvNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhaIm+uJo6lC6Q03zUoEzPgPUUKhHINFs0POHXujfCi+trExmxghws1Wfa4ehKbuJPYrwvsd3/RikCuvkEqqaBCN7w0jr1dO+vQsybjLw3jwhWgmRMMsqThpWt9nDYHeGcxc9zZjlpkRGgBPEC6FDiqZqreV01EMTrX68HMXtdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jlO451C3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jlO451C3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46481F00893;
	Sat, 12 Sep 2026 10:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210398;
	bh=Re4J5KUqVqg9Dw/qbLgTwR31lVKZeMZ+wqPipktHBHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jlO451C3dSfHIwATvxk1fPLNKkxLiQwiRTa9CZAXO9gF+wF9mQ89oXC99mzgu68ag
	 WAN+0hkixpucIwqu2SJm74e6phbqj+G3P+AneRvJgECNrYycT/8aF8/HC2vddxUnOr
	 KQbwyhnQX0I6dTqcow+cfWYNqKYyQYukX/dfogf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1019/1518] pinctrl: airoha: fix getting gpiochip/pinctrl pointers in the IRQ handling code
Date: Sat, 12 Sep 2026 08:53:08 +0200
Message-ID: <20260912065646.502750957@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>

[ Upstream commit b8dd30554847bde27e8a4584dd447c1c3ac585ce ]

airoha_irq_unmask(), airoha_irq_mask(), airoha_irq_type() functions
impements brain damaged logic to retrieve gpiochip and pinctrl pointers.

Details:

    gpiochip = irq_data_get_irq_chip_data(data);

will initialize gpiochip variable with data->chip_data value. This value
initialized inside gpiochip_irq_map() function

    static int gpiochip_irq_map(struct irq_domain *d, unsigned int irq,
			        irq_hw_number_t hwirq)
    {
	struct gpio_chip *gc = d->host_data;
        ...
	irq_set_chip_data(irq, gc);
	...
    }

Thus gpiochip variable of 'struct airoha_pinctrl_gpiochip *' type will be
initialized with a pointer to a variable of 'struct gpio_chip' type.

Luckily, gpio_chip is the first element of airoha_pinctrl_gpiochip, so
gpiochip pointer will get a correct value.

This patch implements correct logic of getting gpiochip and pinctrl
pointers.

Fixes: 1c8ace2d0725 ("pinctrl: airoha: Add support for EN7581 SoC")
Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-airoha.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index e2ba5619d44b1..9465de3e148bb 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -2533,18 +2533,17 @@ static int airoha_gpio_direction_output(struct gpio_chip *chip,
 /* irq callbacks */
 static void airoha_irq_unmask(struct irq_data *data)
 {
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(data);
+	struct airoha_pinctrl *pinctrl = gpiochip_get_data(gc);
+	struct airoha_pinctrl_gpiochip *gpiochip = &pinctrl->gpiochip;
 	u8 offset = data->hwirq % AIROHA_REG_GPIOCTRL_NUM_PIN;
 	u8 index = data->hwirq / AIROHA_REG_GPIOCTRL_NUM_PIN;
 	u32 mask = GENMASK(2 * offset + 1, 2 * offset);
-	struct airoha_pinctrl_gpiochip *gpiochip;
-	struct airoha_pinctrl *pinctrl;
 	u32 val = BIT(2 * offset);
 
-	gpiochip = irq_data_get_irq_chip_data(data);
 	if (WARN_ON_ONCE(data->hwirq >= ARRAY_SIZE(gpiochip->irq_type)))
 		return;
 
-	pinctrl = container_of(gpiochip, struct airoha_pinctrl, gpiochip);
 	switch (gpiochip->irq_type[data->hwirq]) {
 	case IRQ_TYPE_LEVEL_LOW:
 		val = val << 1;
@@ -2570,14 +2569,12 @@ static void airoha_irq_unmask(struct irq_data *data)
 
 static void airoha_irq_mask(struct irq_data *data)
 {
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(data);
+	struct airoha_pinctrl *pinctrl = gpiochip_get_data(gc);
+	struct airoha_pinctrl_gpiochip *gpiochip = &pinctrl->gpiochip;
 	u8 offset = data->hwirq % AIROHA_REG_GPIOCTRL_NUM_PIN;
 	u8 index = data->hwirq / AIROHA_REG_GPIOCTRL_NUM_PIN;
 	u32 mask = GENMASK(2 * offset + 1, 2 * offset);
-	struct airoha_pinctrl_gpiochip *gpiochip;
-	struct airoha_pinctrl *pinctrl;
-
-	gpiochip = irq_data_get_irq_chip_data(data);
-	pinctrl = container_of(gpiochip, struct airoha_pinctrl, gpiochip);
 
 	regmap_clear_bits(pinctrl->regmap, gpiochip->level[index], mask);
 	regmap_clear_bits(pinctrl->regmap, gpiochip->edge[index], mask);
@@ -2585,9 +2582,10 @@ static void airoha_irq_mask(struct irq_data *data)
 
 static int airoha_irq_type(struct irq_data *data, unsigned int type)
 {
-	struct airoha_pinctrl_gpiochip *gpiochip;
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(data);
+	struct airoha_pinctrl *pinctrl = gpiochip_get_data(gc);
+	struct airoha_pinctrl_gpiochip *gpiochip = &pinctrl->gpiochip;
 
-	gpiochip = irq_data_get_irq_chip_data(data);
 	if (data->hwirq >= ARRAY_SIZE(gpiochip->irq_type))
 		return -EINVAL;
 
-- 
2.53.0



