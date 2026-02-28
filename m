Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E43C34A3DC
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302751; cv=none; b=LNL/vFvPMykgxM2qAs53JU8GlM+MYTJxW0BmK14jOwCCHok7A96GOyr/jUsb7mDyjkyeK40fIcicsIQE+wChVCAtBq79JbhmUtlL4aqyvX6eyFAYpWNsZs4djPdHq8w1h1dKXET+eSLVbDG36XEtRqaqLFnGg2VnGFer8cikQO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302751; c=relaxed/simple;
	bh=BD7m/a5WUmp8Dg6eOkpfZRJfOPUyGHa6SIuhVoMEisI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGtZA+9O5MPhdu3lm3oFTAYKWa7ZQvdnUJykxWqyao1N7svT6HkRjiBK5YA4VKQUbpiySF47ZSgDrz+2xE0CSZKZDvY7gVR7VULLQIh80BWsCpP2wKepRuw0WVkF/V9acNbYLUroevEV4VT7k5rqWG/d3oiO54babER0Hn7mHCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sR7BgdjH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sR7BgdjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9EC9C19423;
	Sat, 28 Feb 2026 18:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302751;
	bh=BD7m/a5WUmp8Dg6eOkpfZRJfOPUyGHa6SIuhVoMEisI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sR7BgdjHK/gfS29pxitItxQFWFrULyWcmX3WR8BNyvoWRXjMJMUPIlwLyS6rcee1q
	 Dbb8p+0tRm2W2iLLAo4h46sSQri9QxQQV1juMCWAatC7o10lRqPvboPDhdFaAA84So
	 tPPsvj0deIQU7DEZvhwtPHWFN+nbJ8473HAnkHW1YiFyb4JTRBd1hBjioufsJHJ5b6
	 CbHVZOVgkjMbJdc7Qt4In70vFsRxFf1i0N3GhOZMhH8tAl5deDTqm9otOL0lJp5l3g
	 MweulDn8b0ZXGkF1QPVuPu1spFU07KsQEeASR4mV+BFZ66W4YqH/+2p+8T5j8oZF59
	 80xT/9QP7GRlg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 119/147] dmaengine: mediatek: uart-apdma: Fix above 4G addressing TX/RX
Date: Sat, 28 Feb 2026 13:17:07 -0500
Message-ID: <20260228181736.1605592-119-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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

