Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7273D27448;
	Wed,  7 Aug 2024 15:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043306; cv=none; b=KydA8Gm/7bLmD6ai2ZiJXyM7tc773hfrH6OvwPh0B3V/3hbFvPQiq311dSWCeuu58ZH2qKZ16lI87sR8OGH+HijHe2z5i81I/joYFVkwsTq8+luCyh2I9W3LNWZ+FttHMSGTjHkmNFoch7mD/rQAgD214HzhU/Qwd0w2TonN48k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043306; c=relaxed/simple;
	bh=Vz26quSz1ev1+irvGuVoCk7rRLE/AIHKaocNoXgNpB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBxKPyUjHtPkLy89ikeymTAZXTCq23kxWjUjUFiZ+cpswC0eruYzLsiFrNDY76W9BCG+H12Jpan35Hg/CrNLwvfxwB50IC6VMav3usyrSFmZkfP1neMHB4OXVnp2anXUujrH4XxJPWZjZ8wOdb6C3dcsTlxA+L9DCyf/UODnOfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gVKGKYC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gVKGKYC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040BEC32781;
	Wed,  7 Aug 2024 15:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043306;
	bh=Vz26quSz1ev1+irvGuVoCk7rRLE/AIHKaocNoXgNpB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gVKGKYC8i4MY6hM6LLks6WUnQ6fpyAlBlvO8PpYVzqikBRAacOb7vjnHfQxPdzeSp
	 C4Aloys9QIeejc/tsHST81uag0bKb9RuKFMx3BqjVTToQ2qSYuJYcnVhpoRXohkLS0
	 opRNEWfj9rPv8vgzjQ18K+r/JJbAnTzqpFcrL3jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/121] dmaengine: fsl-edma: add address for channel mux register in fsl_edma_chan
Date: Wed,  7 Aug 2024 16:59:34 +0200
Message-ID: <20240807150020.778543454@linuxfoundation.org>
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

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit e0a08ed25492b6437e366b347113db484037b9b9 ]

iMX95 move channel mux register to management page address space. This
prepare to support iMX95.

Add mux_addr in struct fsl_edma_chan. No function change.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20231221153528.1588049-4-Frank.Li@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 8ddad5589970 ("dmaengine: fsl-edma: change the memory access from local into remote mode in i.MX 8QM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl-edma-common.c | 6 +++---
 drivers/dma/fsl-edma-common.h | 3 +++
 drivers/dma/fsl-edma-main.c   | 3 +++
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/fsl-edma-common.c b/drivers/dma/fsl-edma-common.c
index 793f1a7ad5e34..d42e48ce5de44 100644
--- a/drivers/dma/fsl-edma-common.c
+++ b/drivers/dma/fsl-edma-common.c
@@ -97,8 +97,8 @@ static void fsl_edma3_enable_request(struct fsl_edma_chan *fsl_chan)
 		 * ch_mux: With the exception of 0, attempts to write a value
 		 * already in use will be forced to 0.
 		 */
-		if (!edma_readl_chreg(fsl_chan, ch_mux))
-			edma_writel_chreg(fsl_chan, fsl_chan->srcid, ch_mux);
+		if (!edma_readl(fsl_chan->edma, fsl_chan->mux_addr))
+			edma_writel(fsl_chan->edma, fsl_chan->srcid, fsl_chan->mux_addr);
 	}
 
 	val = edma_readl_chreg(fsl_chan, ch_csr);
@@ -134,7 +134,7 @@ static void fsl_edma3_disable_request(struct fsl_edma_chan *fsl_chan)
 	flags = fsl_edma_drvflags(fsl_chan);
 
 	if (flags & FSL_EDMA_DRV_HAS_CHMUX)
-		edma_writel_chreg(fsl_chan, 0, ch_mux);
+		edma_writel(fsl_chan->edma, 0, fsl_chan->mux_addr);
 
 	val &= ~EDMA_V3_CH_CSR_ERQ;
 	edma_writel_chreg(fsl_chan, val, ch_csr);
diff --git a/drivers/dma/fsl-edma-common.h b/drivers/dma/fsl-edma-common.h
index 92fe53faa53b1..b567da379fc33 100644
--- a/drivers/dma/fsl-edma-common.h
+++ b/drivers/dma/fsl-edma-common.h
@@ -146,6 +146,7 @@ struct fsl_edma_chan {
 	enum dma_data_direction		dma_dir;
 	char				chan_name[32];
 	struct fsl_edma_hw_tcd __iomem *tcd;
+	void __iomem			*mux_addr;
 	u32				real_count;
 	struct work_struct		issue_worker;
 	struct platform_device		*pdev;
@@ -207,6 +208,8 @@ struct fsl_edma_drvdata {
 	u32			chreg_off;
 	u32			chreg_space_sz;
 	u32			flags;
+	u32			mux_off;	/* channel mux register offset */
+	u32			mux_skip;	/* how much skip for each channel */
 	int			(*setup_irq)(struct platform_device *pdev,
 					     struct fsl_edma_engine *fsl_edma);
 };
diff --git a/drivers/dma/fsl-edma-main.c b/drivers/dma/fsl-edma-main.c
index 42a338cbe6143..de4f548f0ad87 100644
--- a/drivers/dma/fsl-edma-main.c
+++ b/drivers/dma/fsl-edma-main.c
@@ -364,6 +364,8 @@ static struct fsl_edma_drvdata imx93_data4 = {
 	.flags = FSL_EDMA_DRV_HAS_CHMUX | FSL_EDMA_DRV_HAS_DMACLK | FSL_EDMA_DRV_EDMA4,
 	.chreg_space_sz = 0x8000,
 	.chreg_off = 0x10000,
+	.mux_off = 0x10000 + offsetof(struct fsl_edma3_ch_reg, ch_mux),
+	.mux_skip = 0x8000,
 	.setup_irq = fsl_edma3_irq_init,
 };
 
@@ -540,6 +542,7 @@ static int fsl_edma_probe(struct platform_device *pdev)
 				offsetof(struct fsl_edma3_ch_reg, tcd) : 0;
 		fsl_chan->tcd = fsl_edma->membase
 				+ i * drvdata->chreg_space_sz + drvdata->chreg_off + len;
+		fsl_chan->mux_addr = fsl_edma->membase + drvdata->mux_off + i * drvdata->mux_skip;
 
 		fsl_chan->pdev = pdev;
 		vchan_init(&fsl_chan->vchan, &fsl_edma->dma_dev);
-- 
2.43.0



