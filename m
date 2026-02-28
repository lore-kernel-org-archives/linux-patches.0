Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B2039B977
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302615; cv=none; b=OQNBCR6x6F85njXeCX5SO1FI6wPaSl69znKtImhSTPLrRisB/sCpMq3pkQe96QH689YGygAaAchOXsxIWyl7VDxLOnW6RPN1C3uaRNkLN6GQ6OmTExJ4A1vIov6bxGOpwANhVTH6P7kNfZ8Hb5IvMdnt/e7AoJ7AS4SUhvew4ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302615; c=relaxed/simple;
	bh=BD7m/a5WUmp8Dg6eOkpfZRJfOPUyGHa6SIuhVoMEisI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OiTmjvluZklswCk6qJGdvvZcqkE5Z4h1Mh50gZU0/aKFieYDr+Mae8HSRbEQIvMGk4Ve1g3wzs/MnWT/dv0rPdcRNzP4JUBUNOh3QRI3z4X3Y14ZT3yGO5GuUahOWL6GbvEymIPrnh4Jdrro9Rt/WWsnQbVSObNv8PMriQYoJQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BJAfHxZS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BJAfHxZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4EDCC19423;
	Sat, 28 Feb 2026 18:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302615;
	bh=BD7m/a5WUmp8Dg6eOkpfZRJfOPUyGHa6SIuhVoMEisI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJAfHxZSxhXph7FfGIK605tYsJ7Vwhmw85Iwocq4Zr4s426RTseYDLAPnY4cDYgl6
	 LhS41lJM26IHBorJIjx2k2nse+ca7ORzyRUtWCYazCnnBudqgdtyGOP20QX1hjzFP0
	 a5f8hurAWtezqqOtVSJbZjm9iEllqHFItiG0q6Q4RjAR5R6SxaDDWcLPyjOGrhU2lb
	 45XLws5L96z3w27X53a5lh8Y24w5dv3PZuFI0B9oLt8w0GB6psHYtCZ4w+WjGqsXcA
	 NXl0rU6A2wvlujD72fujSfGFzrv6nZ7T3Sa+OEoIZksGMVNC/xeZdSBr+NPU5YumdX
	 kBc18YlGW0CNA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 132/164] dmaengine: mediatek: uart-apdma: Fix above 4G addressing TX/RX
Date: Sat, 28 Feb 2026 13:14:31 -0500
Message-ID: <20260228181505.1600663-132-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 58ab9d7b6651d21e1cff1777529f2d3dd0b4e851 ]

The VFF_4G_SUPPORT register is named differently in datasheets,
and its name is "VFF_ADDR2"; was this named correctly from the
beginning it would've been clearer that there was a mistake in
the programming sequence.

This register is supposed to hold the high bits to support the
DMA addressing above 4G (so, more than 32 bits) and not a bit
to "enable" the support for VFF 4G.

Fix the name of this register, and also fix its usage by writing
the upper 32 bits of the dma_addr_t on it when the SoC supports
such feature.

Fixes: 9135408c3ace ("dmaengine: mediatek: Add MediaTek UART APDMA support")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20251113122229.23998-6-angelogioacchino.delregno@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mediatek/mtk-uart-apdma.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/mediatek/mtk-uart-apdma.c b/drivers/dma/mediatek/mtk-uart-apdma.c
index 0acf6a92a4ad3..c1e132a110ffb 100644
--- a/drivers/dma/mediatek/mtk-uart-apdma.c
+++ b/drivers/dma/mediatek/mtk-uart-apdma.c
@@ -42,7 +42,7 @@
 #define VFF_STOP_CLR_B		0
 #define VFF_EN_CLR_B		0
 #define VFF_INT_EN_CLR_B	0
-#define VFF_4G_SUPPORT_CLR_B	0
+#define VFF_ADDR2_CLR_B		0
 
 /*
  * interrupt trigger level for tx
@@ -73,7 +73,7 @@
 /* TX: the buffer size SW can write. RX: the buffer size HW can write. */
 #define VFF_LEFT_SIZE		0x40
 #define VFF_DEBUG_STATUS	0x50
-#define VFF_4G_SUPPORT		0x54
+#define VFF_ADDR2		0x54
 
 struct mtk_uart_apdmadev {
 	struct dma_device ddev;
@@ -150,7 +150,7 @@ static void mtk_uart_apdma_start_tx(struct mtk_chan *c)
 		mtk_uart_apdma_write(c, VFF_INT_FLAG, VFF_TX_INT_CLR_B);
 
 		if (mtkd->support_33bits)
-			mtk_uart_apdma_write(c, VFF_4G_SUPPORT, VFF_4G_EN_B);
+			mtk_uart_apdma_write(c, VFF_ADDR2, upper_32_bits(d->addr));
 	}
 
 	mtk_uart_apdma_write(c, VFF_EN, VFF_EN_B);
@@ -193,7 +193,7 @@ static void mtk_uart_apdma_start_rx(struct mtk_chan *c)
 		mtk_uart_apdma_write(c, VFF_INT_FLAG, VFF_RX_INT_CLR_B);
 
 		if (mtkd->support_33bits)
-			mtk_uart_apdma_write(c, VFF_4G_SUPPORT, VFF_4G_EN_B);
+			mtk_uart_apdma_write(c, VFF_ADDR2, upper_32_bits(d->addr));
 	}
 
 	mtk_uart_apdma_write(c, VFF_INT_EN, VFF_RX_INT_EN_B);
@@ -299,7 +299,7 @@ static int mtk_uart_apdma_alloc_chan_resources(struct dma_chan *chan)
 	}
 
 	if (mtkd->support_33bits)
-		mtk_uart_apdma_write(c, VFF_4G_SUPPORT, VFF_4G_SUPPORT_CLR_B);
+		mtk_uart_apdma_write(c, VFF_ADDR2, VFF_ADDR2_CLR_B);
 
 err_pm:
 	pm_runtime_put_noidle(mtkd->ddev.dev);
-- 
2.51.0

