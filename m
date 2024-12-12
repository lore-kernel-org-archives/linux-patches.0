Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2B422331C;
	Thu, 12 Dec 2024 17:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023107; cv=none; b=WL48gWqv5W/ZdS3fwwXehB8lA9qRBldpkIu2Kj/3GI8ybARvP60HsOlM9tuSbNJp5SfLUtgqcEgI8uJZpyDrDSvZxeic6nziYUXK84ObJuKzr5QN50fMglk0h8hsm+maSW2jMZNCt9sgdsEy7S2CgBuad4njTj0i7VK2TXpxSSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023107; c=relaxed/simple;
	bh=OtUG1MV05MuCtugYcf9cdzSL1AaEIXKAe8qJdOQVSxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFGOJiWxXuaCaSy9ox8V2RSEJ8E2V9C1TLXDZET3exHHx1bPJkHAcesg0q6UUdo9skWg48h8t85M7gd/5zUJmBPeeoiv0jwC7JYxEL9N9gBWnB8tiIIeNa114IWheMXJSHJxLLNHC/lNZX6dwthw/jzlkKNg3wipN6hwpjpPVCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GGJ+fFVU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GGJ+fFVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5683BC4CED0;
	Thu, 12 Dec 2024 17:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023105;
	bh=OtUG1MV05MuCtugYcf9cdzSL1AaEIXKAe8qJdOQVSxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GGJ+fFVUqiFP14zonoebYWVGKgwyBmHEMaWo4OeHNHWZLTWK2jK0o1gf0vHsCWGeE
	 nsOKcp0rNEtCPoQPQwbq6VJvqvNGz3lHCFU0MZ9HMZWFEy9BcW/jAo55pNErTADsGm
	 unh3PM5+7awLKK6ejZ3E4375zxtZxFH1p8U/Gxvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 426/565] gpio: grgpio: use a helper variable to store the address of ofdev->dev
Date: Thu, 12 Dec 2024 16:00:21 +0100
Message-ID: <20241212144328.510333605@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit d036ae41cebdfae92666024163c109b8fef516fa ]

Instead of dereferencing the platform device pointer repeatedly, just
store its address in a helper variable.

Link: https://lore.kernel.org/r/20241015131832.44678-3-brgl@bgdev.pl
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: 050b23d081da ("gpio: grgpio: Add NULL check in grgpio_probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-grgpio.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/gpio/gpio-grgpio.c b/drivers/gpio/gpio-grgpio.c
index 21204a5dca3d4..bf5ecf23cbceb 100644
--- a/drivers/gpio/gpio-grgpio.c
+++ b/drivers/gpio/gpio-grgpio.c
@@ -328,6 +328,7 @@ static const struct irq_domain_ops grgpio_irq_domain_ops = {
 static int grgpio_probe(struct platform_device *ofdev)
 {
 	struct device_node *np = ofdev->dev.of_node;
+	struct device *dev = &ofdev->dev;
 	void  __iomem *regs;
 	struct gpio_chip *gc;
 	struct grgpio_priv *priv;
@@ -337,7 +338,7 @@ static int grgpio_probe(struct platform_device *ofdev)
 	int size;
 	int i;
 
-	priv = devm_kzalloc(&ofdev->dev, sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
@@ -346,29 +347,29 @@ static int grgpio_probe(struct platform_device *ofdev)
 		return PTR_ERR(regs);
 
 	gc = &priv->gc;
-	err = bgpio_init(gc, &ofdev->dev, 4, regs + GRGPIO_DATA,
+	err = bgpio_init(gc, dev, 4, regs + GRGPIO_DATA,
 			 regs + GRGPIO_OUTPUT, NULL, regs + GRGPIO_DIR, NULL,
 			 BGPIOF_BIG_ENDIAN_BYTE_ORDER);
 	if (err) {
-		dev_err(&ofdev->dev, "bgpio_init() failed\n");
+		dev_err(dev, "bgpio_init() failed\n");
 		return err;
 	}
 
 	priv->regs = regs;
 	priv->imask = gc->read_reg(regs + GRGPIO_IMASK);
-	priv->dev = &ofdev->dev;
+	priv->dev = dev;
 
 	gc->of_node = np;
 	gc->owner = THIS_MODULE;
 	gc->to_irq = grgpio_to_irq;
-	gc->label = devm_kasprintf(&ofdev->dev, GFP_KERNEL, "%pOF", np);
+	gc->label = devm_kasprintf(dev, GFP_KERNEL, "%pOF", np);
 	gc->base = -1;
 
 	err = of_property_read_u32(np, "nbits", &prop);
 	if (err || prop <= 0 || prop > GRGPIO_MAX_NGPIO) {
 		gc->ngpio = GRGPIO_MAX_NGPIO;
-		dev_dbg(&ofdev->dev,
-			"No or invalid nbits property: assume %d\n", gc->ngpio);
+		dev_dbg(dev, "No or invalid nbits property: assume %d\n",
+			gc->ngpio);
 	} else {
 		gc->ngpio = prop;
 	}
@@ -380,7 +381,7 @@ static int grgpio_probe(struct platform_device *ofdev)
 	irqmap = (s32 *)of_get_property(np, "irqmap", &size);
 	if (irqmap) {
 		if (size < gc->ngpio) {
-			dev_err(&ofdev->dev,
+			dev_err(dev,
 				"irqmap shorter than ngpio (%d < %d)\n",
 				size, gc->ngpio);
 			return -EINVAL;
@@ -390,7 +391,7 @@ static int grgpio_probe(struct platform_device *ofdev)
 						     &grgpio_irq_domain_ops,
 						     priv);
 		if (!priv->domain) {
-			dev_err(&ofdev->dev, "Could not add irq domain\n");
+			dev_err(dev, "Could not add irq domain\n");
 			return -EINVAL;
 		}
 
@@ -420,13 +421,13 @@ static int grgpio_probe(struct platform_device *ofdev)
 
 	err = gpiochip_add_data(gc, priv);
 	if (err) {
-		dev_err(&ofdev->dev, "Could not add gpiochip\n");
+		dev_err(dev, "Could not add gpiochip\n");
 		if (priv->domain)
 			irq_domain_remove(priv->domain);
 		return err;
 	}
 
-	dev_info(&ofdev->dev, "regs=0x%p, base=%d, ngpio=%d, irqs=%s\n",
+	dev_info(dev, "regs=0x%p, base=%d, ngpio=%d, irqs=%s\n",
 		 priv->regs, gc->base, gc->ngpio, priv->domain ? "on" : "off");
 
 	return 0;
-- 
2.43.0



