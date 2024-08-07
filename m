Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BC681AB1;
	Wed,  7 Aug 2024 15:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043309; cv=none; b=qXT3Z00D7wftj86baDUwmRyIBkFg6s66QNdmXEHcpCrOlQfYh5557iqCqZ1pI6nTni+vJfu4QvK4KgrnGQ0oLahAYGBmUUBCLJOV0y3pkePL8CMYI5HSZi5sP0tPz4lFQaDv7A2XzJROj03numskaVakBmmapPgDj8k57+LbBg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043309; c=relaxed/simple;
	bh=ztwJytJL9t7MBrLB7DCmtxXfkiwT0Ac2XKB3b34IW4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bt8YGqg/OpWlROpr6qtF2ltzJSp+KtCKBEPWTM4vtznOQkoM0l6coivlEFgvuLOEIzlV3u9t/QI9JqZBwlSvIYuGsa5gtLCOZqzotmEOA35j1pkSzslIVGkSexBmr7dqeUSQGOmxhDkjkWBvJfwDOvjFBV980gEtS61GEeH9XBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ohwgBb6I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ohwgBb6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A953FC32781;
	Wed,  7 Aug 2024 15:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043309;
	bh=ztwJytJL9t7MBrLB7DCmtxXfkiwT0Ac2XKB3b34IW4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ohwgBb6I/ozzdzEd9CdLIBJ2Tl8z2Aa60uRgot2iTSIwu9+YAyAuqbB7EZNF/zgXh
	 9IpQ/OLfZrHCXPs8DX5GK1xKjq4tOg7fJ4jmw4/Jf2bbsCff1VPHEnqRATCZej3t1K
	 b/mapdpZnPgLK0xsLuIUEavlcob6W3EOQOwG9uq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joy Zou <joy.zou@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/121] dmaengine: fsl-edma: add i.MX8ULP edma support
Date: Wed,  7 Aug 2024 16:59:35 +0200
Message-ID: <20240807150020.806438788@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

From: Joy Zou <joy.zou@nxp.com>

[ Upstream commit d8d4355861d874cbd1395ec0edcbe4e0f6940738 ]

Add support for the i.MX8ULP platform to the eDMA driver. Introduce the use
of the correct FSL_EDMA_DRV_HAS_CHCLK flag to handle per-channel clock
configurations.

Signed-off-by: Joy Zou <joy.zou@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20240323-8ulp_edma-v3-5-c0e981027c05@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 8ddad5589970 ("dmaengine: fsl-edma: change the memory access from local into remote mode in i.MX 8QM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl-edma-common.c |  6 ++++++
 drivers/dma/fsl-edma-main.c   | 22 ++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/dma/fsl-edma-common.c b/drivers/dma/fsl-edma-common.c
index d42e48ce5de44..12e605a756cad 100644
--- a/drivers/dma/fsl-edma-common.c
+++ b/drivers/dma/fsl-edma-common.c
@@ -3,6 +3,7 @@
 // Copyright (c) 2013-2014 Freescale Semiconductor, Inc
 // Copyright (c) 2017 Sysam, Angelo Dureghello  <angelo@sysam.it>
 
+#include <linux/clk.h>
 #include <linux/dmapool.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -802,6 +803,9 @@ int fsl_edma_alloc_chan_resources(struct dma_chan *chan)
 {
 	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
 
+	if (fsl_edma_drvflags(fsl_chan) & FSL_EDMA_DRV_HAS_CHCLK)
+		clk_prepare_enable(fsl_chan->clk);
+
 	fsl_chan->tcd_pool = dma_pool_create("tcd_pool", chan->device->dev,
 				sizeof(struct fsl_edma_hw_tcd),
 				32, 0);
@@ -829,6 +833,8 @@ void fsl_edma_free_chan_resources(struct dma_chan *chan)
 	fsl_chan->tcd_pool = NULL;
 	fsl_chan->is_sw = false;
 	fsl_chan->srcid = 0;
+	if (fsl_edma_drvflags(fsl_chan) & FSL_EDMA_DRV_HAS_CHCLK)
+		clk_disable_unprepare(fsl_chan->clk);
 }
 
 void fsl_edma_cleanup_vchan(struct dma_device *dmadev)
diff --git a/drivers/dma/fsl-edma-main.c b/drivers/dma/fsl-edma-main.c
index de4f548f0ad87..4a3edba315887 100644
--- a/drivers/dma/fsl-edma-main.c
+++ b/drivers/dma/fsl-edma-main.c
@@ -353,6 +353,16 @@ static struct fsl_edma_drvdata imx8qm_audio_data = {
 	.setup_irq = fsl_edma3_irq_init,
 };
 
+static struct fsl_edma_drvdata imx8ulp_data = {
+	.flags = FSL_EDMA_DRV_HAS_CHMUX | FSL_EDMA_DRV_HAS_CHCLK | FSL_EDMA_DRV_HAS_DMACLK |
+		 FSL_EDMA_DRV_EDMA3,
+	.chreg_space_sz = 0x10000,
+	.chreg_off = 0x10000,
+	.mux_off = 0x10000 + offsetof(struct fsl_edma3_ch_reg, ch_mux),
+	.mux_skip = 0x10000,
+	.setup_irq = fsl_edma3_irq_init,
+};
+
 static struct fsl_edma_drvdata imx93_data3 = {
 	.flags = FSL_EDMA_DRV_HAS_DMACLK | FSL_EDMA_DRV_EDMA3,
 	.chreg_space_sz = 0x10000,
@@ -375,6 +385,7 @@ static const struct of_device_id fsl_edma_dt_ids[] = {
 	{ .compatible = "fsl,imx7ulp-edma", .data = &imx7ulp_data},
 	{ .compatible = "fsl,imx8qm-edma", .data = &imx8qm_data},
 	{ .compatible = "fsl,imx8qm-adma", .data = &imx8qm_audio_data},
+	{ .compatible = "fsl,imx8ulp-edma", .data = &imx8ulp_data},
 	{ .compatible = "fsl,imx93-edma3", .data = &imx93_data3},
 	{ .compatible = "fsl,imx93-edma4", .data = &imx93_data4},
 	{ /* sentinel */ }
@@ -429,6 +440,7 @@ static int fsl_edma_probe(struct platform_device *pdev)
 	struct fsl_edma_engine *fsl_edma;
 	const struct fsl_edma_drvdata *drvdata = NULL;
 	u32 chan_mask[2] = {0, 0};
+	char clk_name[36];
 	struct edma_regs *regs;
 	int chans;
 	int ret, i;
@@ -544,11 +556,21 @@ static int fsl_edma_probe(struct platform_device *pdev)
 				+ i * drvdata->chreg_space_sz + drvdata->chreg_off + len;
 		fsl_chan->mux_addr = fsl_edma->membase + drvdata->mux_off + i * drvdata->mux_skip;
 
+		if (drvdata->flags & FSL_EDMA_DRV_HAS_CHCLK) {
+			snprintf(clk_name, sizeof(clk_name), "ch%02d", i);
+			fsl_chan->clk = devm_clk_get_enabled(&pdev->dev,
+							     (const char *)clk_name);
+
+			if (IS_ERR(fsl_chan->clk))
+				return PTR_ERR(fsl_chan->clk);
+		}
 		fsl_chan->pdev = pdev;
 		vchan_init(&fsl_chan->vchan, &fsl_edma->dma_dev);
 
 		edma_write_tcdreg(fsl_chan, 0, csr);
 		fsl_edma_chan_mux(fsl_chan, 0, false);
+		if (fsl_chan->edma->drvdata->flags & FSL_EDMA_DRV_HAS_CHCLK)
+			clk_disable_unprepare(fsl_chan->clk);
 	}
 
 	ret = fsl_edma->drvdata->setup_irq(pdev, fsl_edma);
-- 
2.43.0



