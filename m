Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19334315F;
	Mon, 17 Aug 2026 14:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976546; cv=none; b=i+O2AQFNeIukc0Om9mZC490oEkegP4GrI8J/qVCzEyoXimgSrrB3v96tlXmoJXxkg1uhr63f/IlKFF+Z/DIpKUYJPdle8MW6bM53cVEE4rl/4qvzrGvrFXnuWWnGpI4xcz2ti7EA3OuOg6PHblxKg9Avnrdq1eRFZUt2ZO5GlWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976546; c=relaxed/simple;
	bh=zVuksKJxpdGBkYY1DMC8bh/6xDbws2yvdcU44v2NanQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQQwhFmTagji0XF8RUqltJEazmXoNz7H+1BaOzkBvtRuGnyqLy9XRNJVUBkARKuG/x5aq4BWDcXG+YBkrkq/L4JNJ0H+StPIMGZ1J+FZPyC05uxKAy/EA8+9gVJx0QNwxmr/3jvEoHPxVON/01zg/zhWxPxo/Uh364ls0jRkpC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cuvCfmUy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cuvCfmUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C3D1F000E9;
	Mon, 17 Aug 2026 14:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976545;
	bh=q1se0aSh7DN5aDVI7sIZAEqBmf72zl8J37Te77vmTdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cuvCfmUyxN/w+YgHEy1GlU+TqyuU65G6Ed1sTAD5jl0CDp/SbdUQFZURPm13rq2y4
	 +ymiKr7aWxwCm2T0JAkcA7FfWGwVCugymR2AeTVbIdRVMxDPT1Ffh/HzRFeNE+oMJ0
	 IpwRnsQpOJzqhyF/Dj5Dfs+qahDzw2Ya/4HpRl7M=
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
Subject: [PATCH 5.15 008/456] dmaengine: sh: rz-dmac: Move interrupt request after everything is set up
Date: Mon, 17 Aug 2026 15:26:38 +0200
Message-ID: <20260817132540.186686647@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Vinod Koul <vkoul@kernel.org>
[tm: kept channel->irq (a struct field, not a local irq variable) and
 the sprintf()/pdev_irqname[5] pair in rz_dmac_chan_probe(), and the
 mandatory platform_get_irq_byname() call for the error IRQ in
 rz_dmac_probe(), since e0c51fd02f9c ("Make channel irq local"),
 c4d6dcb3b625 ("Avoid format-overflow warning") and b34f3fcae72a
 ("make error interrupt optional") are not yet backported to this
 tree]
Signed-off-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sh/rz-dmac.c | 94 ++++++++++++++++------------------------
 1 file changed, 37 insertions(+), 57 deletions(-)

diff --git a/drivers/dma/sh/rz-dmac.c b/drivers/dma/sh/rz-dmac.c
index c22743e41640fd..cec94db38c550e 100644
--- a/drivers/dma/sh/rz-dmac.c
+++ b/drivers/dma/sh/rz-dmac.c
@@ -773,27 +773,6 @@ static int rz_dmac_chan_probe(struct rz_dmac *dmac,
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
@@ -806,9 +785,9 @@ static int rz_dmac_chan_probe(struct rz_dmac *dmac,
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
@@ -824,7 +803,26 @@ static int rz_dmac_chan_probe(struct rz_dmac *dmac,
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
@@ -851,7 +849,6 @@ static int rz_dmac_probe(struct platform_device *pdev)
 	const char *irqname = "error";
 	struct dma_device *engine;
 	struct rz_dmac *dmac;
-	int channel_num;
 	unsigned int i;
 	int ret;
 	int irq;
@@ -881,26 +878,28 @@ static int rz_dmac_probe(struct platform_device *pdev)
 	if (IS_ERR(dmac->ext_base))
 		return PTR_ERR(dmac->ext_base);
 
+	/* Initialize the channels. */
+	INIT_LIST_HEAD(&dmac->engine.channels);
+
+	for (i = 0; i < dmac->n_channels; i++) {
+		ret = rz_dmac_chan_probe(dmac, &dmac->channels[i], i);
+		if (ret < 0)
+			goto err;
+	}
+
 	/* Register interrupt handler for error */
 	irq = platform_get_irq_byname(pdev, irqname);
-	if (irq < 0)
-		return irq;
+	if (irq < 0) {
+		ret = irq;
+		goto err;
+	}
 
 	ret = devm_request_irq(&pdev->dev, irq, rz_dmac_irq_handler, 0,
 			       irqname, NULL);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to request IRQ %u (%d)\n",
 			irq, ret);
-		return ret;
-	}
-
-	/* Initialize the channels. */
-	INIT_LIST_HEAD(&dmac->engine.channels);
-
-	for (i = 0; i < dmac->n_channels; i++) {
-		ret = rz_dmac_chan_probe(dmac, &dmac->channels[i], i);
-		if (ret < 0)
-			goto err;
+		goto err;
 	}
 
 	/* Register the DMAC as a DMA provider for DT. */
@@ -940,32 +939,13 @@ static int rz_dmac_probe(struct platform_device *pdev)
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
 	return ret;
 }
 
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
 
-- 
2.53.0



