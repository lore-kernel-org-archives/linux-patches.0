Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CCA36C9D4
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302219; cv=none; b=SKpY/jibuy3gtUZaClwkYVIiYU3wgz3aIVJMjmsXMqC+7LfY9Vh4jLSkZhVJbYrTbd7vm1k1zT/XxviFn+3oKaAnMNz5HEcfK0zG4LAYoMkz7Nu0iDHSdJusi+omJMqdOir2XRs7W/Zqj7N3nLMQFfgnATidHKjxLuzehORmWXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302219; c=relaxed/simple;
	bh=Zjm18guPWDqtbg0vK26/g/KDFOGjmNnVI9m961ZdzIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jI7ivaLor9EoDB0YXCRVxtzrTsNtwmO40ESPZmfP99C+eFMLavb2Wk2TnhNUNgwvuB5sGjZzbAzhJVeGXOuQRrQV6ifiJSTrAkH4P3XK+4P9BS8N3CGi2kdHRLg5wu46O34TIPYRO/fJUH11N6u/Ib+DpNViJxEjbvzt1/uzCBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L/vfeEN4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L/vfeEN4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC26EC116D0;
	Sat, 28 Feb 2026 18:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302219;
	bh=Zjm18guPWDqtbg0vK26/g/KDFOGjmNnVI9m961ZdzIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L/vfeEN4mbB7/GX0WYR4MXUTJMVFK3G3k0E2A29rCGt+KeiBRVcZTdiTzB+KGYenH
	 r2psHSZmvnxcoSLTCLfSuNoWswu424vKCDRjWh8827SH6u9TfSXYoVj9w65wJt5I17
	 xJkR6sNzrvdUHKh9yA+gpzBuey/KlUbcGvdsMEQNoU2iGxEcuTAqhY+EWLNPh/4V/w
	 ZOz8PSfLDmP6BP+gy/otQKxwPh5Z9zgWLVVXspchsjTVaIYN/9M383tVcPVKvIfL6G
	 YBzRvUo5f7N9MgeeuRI7I/X8usE1vVSI8TyTs9TpxyKUZ35HFxirTm5uYn8OMbRgLj
	 Ojc90E4bszyGA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 226/283] dmaengine: mediatek: uart-apdma: Fix above 4G addressing TX/RX
Date: Sat, 28 Feb 2026 13:06:08 -0500
Message-ID: <20260228180709.1583486-226-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 06d12ac39144f..aa42a09fde1a6 100644
--- a/drivers/dma/mediatek/mtk-uart-apdma.c
+++ b/drivers/dma/mediatek/mtk-uart-apdma.c
@@ -41,7 +41,7 @@
 #define VFF_STOP_CLR_B		0
 #define VFF_EN_CLR_B		0
 #define VFF_INT_EN_CLR_B	0
-#define VFF_4G_SUPPORT_CLR_B	0
+#define VFF_ADDR2_CLR_B		0
 
 /*
  * interrupt trigger level for tx
@@ -72,7 +72,7 @@
 /* TX: the buffer size SW can write. RX: the buffer size HW can write. */
 #define VFF_LEFT_SIZE		0x40
 #define VFF_DEBUG_STATUS	0x50
-#define VFF_4G_SUPPORT		0x54
+#define VFF_ADDR2		0x54
 
 struct mtk_uart_apdmadev {
 	struct dma_device ddev;
@@ -149,7 +149,7 @@ static void mtk_uart_apdma_start_tx(struct mtk_chan *c)
 		mtk_uart_apdma_write(c, VFF_INT_FLAG, VFF_TX_INT_CLR_B);
 
 		if (mtkd->support_33bits)
-			mtk_uart_apdma_write(c, VFF_4G_SUPPORT, VFF_4G_EN_B);
+			mtk_uart_apdma_write(c, VFF_ADDR2, upper_32_bits(d->addr));
 	}
 
 	mtk_uart_apdma_write(c, VFF_EN, VFF_EN_B);
@@ -192,7 +192,7 @@ static void mtk_uart_apdma_start_rx(struct mtk_chan *c)
 		mtk_uart_apdma_write(c, VFF_INT_FLAG, VFF_RX_INT_CLR_B);
 
 		if (mtkd->support_33bits)
-			mtk_uart_apdma_write(c, VFF_4G_SUPPORT, VFF_4G_EN_B);
+			mtk_uart_apdma_write(c, VFF_ADDR2, upper_32_bits(d->addr));
 	}
 
 	mtk_uart_apdma_write(c, VFF_INT_EN, VFF_RX_INT_EN_B);
@@ -298,7 +298,7 @@ static int mtk_uart_apdma_alloc_chan_resources(struct dma_chan *chan)
 	}
 
 	if (mtkd->support_33bits)
-		mtk_uart_apdma_write(c, VFF_4G_SUPPORT, VFF_4G_SUPPORT_CLR_B);
+		mtk_uart_apdma_write(c, VFF_ADDR2, VFF_ADDR2_CLR_B);
 
 err_pm:
 	pm_runtime_put_noidle(mtkd->ddev.dev);
-- 
2.51.0

