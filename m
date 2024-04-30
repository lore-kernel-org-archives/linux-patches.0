Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460C612D758;
	Tue, 30 Apr 2024 11:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475256; cv=none; b=OPb6NlHZ0XoJJqVy2X08rZl7X0E1OBx4iuXgwoJsdXygr9YEapBmI0OGDmBuo/o3JGj8oCst0doaA2kDPPRwX8FrjO1/GMNYWn9bRiJien6O6Mw/zGUkhrT/4w3xet4WTN0hykzbdKMCL7O969+5+CyiboOBhNUwpx/dliKJtUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475256; c=relaxed/simple;
	bh=7BBeaO7u4PvZ1J1iSUvXRi/3cgL44eO984js7F45ieQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iyi2n6j4x7ghRNLb7aup81oXVfJ/qw4kjcuBtBvxMjR/7oNIY8O5ftJswTNLTK4lhuP0JUU+0QHOB/8hmByGxQMhjJO6Xfa9YOBOsC8q5zoMB9NvEH1XAxzdTkS6dLM3ksprJBMnn1XSOr7l1+e1hR2SnzY52JaiZuIcfLQxWVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cXXSkBOo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cXXSkBOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3B4C4AF19;
	Tue, 30 Apr 2024 11:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475256;
	bh=7BBeaO7u4PvZ1J1iSUvXRi/3cgL44eO984js7F45ieQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cXXSkBOo66EmWmtSUflbL8kLm2/svqSBG8kqZeFTiQDXQxoBqMkbnbVG1hqCcS9My
	 Gw1aeHCsZ/rLa7a6mioyYCCSBxip3Ff4NlPXkF2XbHrFGkgGJkD4ZClXNnXXDszTXv
	 8uPTolCssVJhK1TpzVwzldbbDtbKZX2WAaP4NeGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/186] gpio: tangier: Use correct type for the IRQ chip data
Date: Tue, 30 Apr 2024 12:38:06 +0200
Message-ID: <20240430103059.021079959@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 7d045025a24b6336d444d359bd4312f351d017f9 ]

IRQ chip data contains a pointer to the GPIO chip. Luckily we have
the pointers the same, but strictly speaking it's not guaranteed.
Even though, still better to fix this.

Fixes: ccf6fd6dcc86 ("gpio: merrifield: Introduce GPIO driver to support Merrifield")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-tangier.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-tangier.c b/drivers/gpio/gpio-tangier.c
index 7ce3eddaed257..1ce40b7673b11 100644
--- a/drivers/gpio/gpio-tangier.c
+++ b/drivers/gpio/gpio-tangier.c
@@ -205,7 +205,8 @@ static int tng_gpio_set_config(struct gpio_chip *chip, unsigned int offset,
 
 static void tng_irq_ack(struct irq_data *d)
 {
-	struct tng_gpio *priv = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct tng_gpio *priv = gpiochip_get_data(gc);
 	irq_hw_number_t gpio = irqd_to_hwirq(d);
 	unsigned long flags;
 	void __iomem *gisr;
@@ -241,7 +242,8 @@ static void tng_irq_unmask_mask(struct tng_gpio *priv, u32 gpio, bool unmask)
 
 static void tng_irq_mask(struct irq_data *d)
 {
-	struct tng_gpio *priv = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct tng_gpio *priv = gpiochip_get_data(gc);
 	irq_hw_number_t gpio = irqd_to_hwirq(d);
 
 	tng_irq_unmask_mask(priv, gpio, false);
@@ -250,7 +252,8 @@ static void tng_irq_mask(struct irq_data *d)
 
 static void tng_irq_unmask(struct irq_data *d)
 {
-	struct tng_gpio *priv = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct tng_gpio *priv = gpiochip_get_data(gc);
 	irq_hw_number_t gpio = irqd_to_hwirq(d);
 
 	gpiochip_enable_irq(&priv->chip, gpio);
-- 
2.43.0



