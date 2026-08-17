Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69083242925;
	Mon, 17 Aug 2026 15:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978839; cv=none; b=VMIFBOn5b3ITbNk1hmU4TGn4z7atoaispyjR39pAs5CeCn9HfDYFZOpcyYyErdUccTrD+Wu7ciXKM8cIpIx08VPTSePNvI7s8DjS0gj/yIUtr/8J7MAiTFH65dTL+4K2eQb4DBfF8hgng/UcSV1Z9MeUyVYpi7PTZO2loOr0F9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978839; c=relaxed/simple;
	bh=onZqm5k2UDD71LlGnY8t5cFE8k3Jpc9EL9Ixtihe2/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kYOyHF9tdSRVYhFSbCHl6qt4nVJcN2dnO7HNS0j/5WHGZKe71XPAZg1Pegxww6Y8aCVir1Q3MQakRLhqMhTZUbkjAHUAcX+0DM7eAmYPNpUERBsjhMjejKnDW29ECWGsrrQO88G21qoSbNvBp/sohTVc37pLxa/0gg819/yLe0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PcYOO9qU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PcYOO9qU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAEF11F000E9;
	Mon, 17 Aug 2026 15:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978838;
	bh=X5XfAH+BtI6ePLBdpQh3AlaFawkt5+KyCG1Q0iimmZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PcYOO9qUULOIx3R+QK4OOeMJaurcOUK0R71SWvR6TDYLiUG5YV8TeLsLwKXBZ9K7e
	 wj6QAK8aPIbg56o6ubQQ2tO9mkwT50WfdPT0czBW9UOXIr/rTm+ioi0O+6t+R/9av+
	 cqR4kNqJNCpaCuBTHaBmKSZHkIEJWVR36mUADOIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	John Madieu <john.madieu.xa@bp.renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/609] dmaengine: sh: rz-dmac: Move interrupt request after everything is set up
Date: Mon, 17 Aug 2026 15:25:15 +0200
Message-ID: <20260817132543.848816927@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit 731712403ddb39d1a76a11abf339a0615bc85de7 upstream.

Once the interrupt is requested, the interrupt handler may run immediately.
Since the IRQ handler can access channel->ch_base, which is initialized
only after requesting the IRQ, this may lead to invalid memory access.
Likewise, the IRQ thread may access uninitialized data (the ld_free,
ld_queue, and ld_active lists), which may also lead to issues.

Request the interrupts only after everything is set up. To keep the error
path simpler, use dmam_alloc_coherent() instead of dma_alloc_coherent().

Fixes: 5000d37042a6 ("dmaengine: sh: Add DMAC driver for RZ/G2L SoC")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Tested-by: John Madieu <john.madieu.xa@bp.renesas.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Tested-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Link: https://patch.msgid.link/20260526084710.3491480-2-claudiu.beznea@kernel.org
[tm: Kept the channel->irq field in rz_dmac_chan_probe() instead of
 upstream's local `irq` variable, as commit 04e227718ab8
 ("dmaengine: sh: rz-dmac: Make channel irq local") is not present
 in this tree. Likewise kept platform_get_irq_byname() instead of
 platform_get_irq_byname_optional() for the error IRQ in rz_dmac_probe(),
 as commit 6b3a6b6dc074 ("dmaengine: sh: rz_dmac: make error interrupt
 optional") is not present in this tree either; its early return on
 failure becomes a goto err jump to match the new call order.]
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sh/rz-dmac.c | 96 ++++++++++++++++------------------------
 1 file changed, 38 insertions(+), 58 deletions(-)

diff --git a/drivers/dma/sh/rz-dmac.c b/drivers/dma/sh/rz-dmac.c
index 498e6e24ab0a37..b956292e861940 100644
--- a/drivers/dma/sh/rz-dmac.c
+++ b/drivers/dma/sh/rz-dmac.c
@@ -779,27 +779,6 @@ static int rz_dmac_chan_probe(struct rz_dmac *dmac,
 	channel->index = index;
 	channel->mid_rid = -EINVAL;
 
-	/* Request the channel interrupt. */
-	sprintf(pdev_irqname, "ch%u", index);
-	channel->irq = platform_get_irq_byname(pdev, pdev_irqname);
-	if (channel->irq < 0)
-		return channel->irq;
-
-	irqname = devm_kasprintf(dmac->dev, GFP_KERNEL, "%s:%u",
-				 dev_name(dmac->dev), index);
-	if (!irqname)
-		return -ENOMEM;
-
-	ret = devm_request_threaded_irq(dmac->dev, channel->irq,
-					rz_dmac_irq_handler,
-					rz_dmac_irq_handler_thread, 0,
-					irqname, channel);
-	if (ret) {
-		dev_err(dmac->dev, "failed to request IRQ %u (%d)\n",
-			channel->irq, ret);
-		return ret;
-	}
-
 	/* Set io base address for each channel */
 	if (index < 8) {
 		channel->ch_base = dmac->base + CHANNEL_0_7_OFFSET +
@@ -812,9 +791,9 @@ static int rz_dmac_chan_probe(struct rz_dmac *dmac,
 	}
 
 	/* Allocate descriptors */
-	lmdesc = dma_alloc_coherent(&pdev->dev,
-				    sizeof(struct rz_lmdesc) * DMAC_NR_LMDESC,
-				    &channel->lmdesc.base_dma, GFP_KERNEL);
+	lmdesc = dmam_alloc_coherent(&pdev->dev,
+				     sizeof(struct rz_lmdesc) * DMAC_NR_LMDESC,
+				     &channel->lmdesc.base_dma, GFP_KERNEL);
 	if (!lmdesc) {
 		dev_err(&pdev->dev, "Can't allocate memory (lmdesc)\n");
 		return -ENOMEM;
@@ -830,7 +809,26 @@ static int rz_dmac_chan_probe(struct rz_dmac *dmac,
 	INIT_LIST_HEAD(&channel->ld_free);
 	INIT_LIST_HEAD(&channel->ld_active);
 
-	return 0;
+	/* Request the channel interrupt. */
+	sprintf(pdev_irqname, "ch%u", index);
+	channel->irq = platform_get_irq_byname(pdev, pdev_irqname);
+	if (channel->irq < 0)
+		return channel->irq;
+
+	irqname = devm_kasprintf(dmac->dev, GFP_KERNEL, "%s:%u",
+				 dev_name(dmac->dev), index);
+	if (!irqname)
+		return -ENOMEM;
+
+	ret = devm_request_threaded_irq(dmac->dev, channel->irq,
+					rz_dmac_irq_handler,
+					rz_dmac_irq_handler_thread, 0,
+					irqname, channel);
+	if (ret)
+		dev_err(dmac->dev, "failed to request IRQ %u (%d)\n",
+			channel->irq, ret);
+
+	return ret;
 }
 
 static int rz_dmac_parse_of(struct device *dev, struct rz_dmac *dmac)
@@ -857,7 +855,6 @@ static int rz_dmac_probe(struct platform_device *pdev)
 	const char *irqname = "error";
 	struct dma_device *engine;
 	struct rz_dmac *dmac;
-	int channel_num;
 	unsigned int i;
 	int ret;
 	int irq;
@@ -887,19 +884,6 @@ static int rz_dmac_probe(struct platform_device *pdev)
 	if (IS_ERR(dmac->ext_base))
 		return PTR_ERR(dmac->ext_base);
 
-	/* Register interrupt handler for error */
-	irq = platform_get_irq_byname(pdev, irqname);
-	if (irq < 0)
-		return irq;
-
-	ret = devm_request_irq(&pdev->dev, irq, rz_dmac_irq_handler, 0,
-			       irqname, NULL);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to request IRQ %u (%d)\n",
-			irq, ret);
-		return ret;
-	}
-
 	/* Initialize the channels. */
 	INIT_LIST_HEAD(&dmac->engine.channels);
 
@@ -916,6 +900,21 @@ static int rz_dmac_probe(struct platform_device *pdev)
 			goto err;
 	}
 
+	/* Register interrupt handler for error */
+	irq = platform_get_irq_byname(pdev, irqname);
+	if (irq < 0) {
+		ret = irq;
+		goto err;
+	}
+
+	ret = devm_request_irq(&pdev->dev, irq, rz_dmac_irq_handler, 0,
+			       irqname, NULL);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to request IRQ %u (%d)\n",
+			irq, ret);
+		goto err;
+	}
+
 	/* Register the DMAC as a DMA provider for DT. */
 	ret = of_dma_controller_register(pdev->dev.of_node, rz_dmac_of_xlate,
 					 NULL);
@@ -954,16 +953,6 @@ static int rz_dmac_probe(struct platform_device *pdev)
 dma_register_err:
 	of_dma_controller_free(pdev->dev.of_node);
 err:
-	channel_num = i ? i - 1 : 0;
-	for (i = 0; i < channel_num; i++) {
-		struct rz_dmac_chan *channel = &dmac->channels[i];
-
-		dma_free_coherent(&pdev->dev,
-				  sizeof(struct rz_lmdesc) * DMAC_NR_LMDESC,
-				  channel->lmdesc.base,
-				  channel->lmdesc.base_dma);
-	}
-
 	pm_runtime_put(&pdev->dev);
 err_pm_disable:
 	pm_runtime_disable(&pdev->dev);
@@ -974,16 +963,7 @@ static int rz_dmac_probe(struct platform_device *pdev)
 static int rz_dmac_remove(struct platform_device *pdev)
 {
 	struct rz_dmac *dmac = platform_get_drvdata(pdev);
-	unsigned int i;
-
-	for (i = 0; i < dmac->n_channels; i++) {
-		struct rz_dmac_chan *channel = &dmac->channels[i];
 
-		dma_free_coherent(&pdev->dev,
-				  sizeof(struct rz_lmdesc) * DMAC_NR_LMDESC,
-				  channel->lmdesc.base,
-				  channel->lmdesc.base_dma);
-	}
 	of_dma_controller_free(pdev->dev.of_node);
 	dma_async_device_unregister(&dmac->engine);
 	pm_runtime_put(&pdev->dev);
-- 
2.53.0



