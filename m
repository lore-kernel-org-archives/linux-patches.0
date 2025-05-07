Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823C828BA9F;
	Wed,  7 May 2025 19:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645054; cv=none; b=DJNZ9Pp9gsfgJzhtuTNRIbB1WEWA4sn9GIu4nc5eLHisWMzNv/HxWW3oeSRo51lAhJteFM+hRXgUKjr3UUYUyBS2ANCVKUnjXrIYuuGxSTjjJYLJwRLQnjnEUQ9D54s6z7vYOqp1tUGIqQAlx54mFtnJbLBFpCdez4v2SlG3Bao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645054; c=relaxed/simple;
	bh=QQL+XrPmdqDtsXmDZZHhEUlzFW0mxQ4yDBIN/O66fuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXDHeJDUpT7utZu3OpDcq3u9NhFacq2yxHkXcH7tGuq1+CzdxNnqWs4FIU43oG86/7zCNWyPETjTW7VEwMXi8yhvzbx3kjD1aIRc3hfBsi4w9naretK0kO/ayJ7X5o8YFFqmng5nEzwZWsvXpK7E0AaSHm457gRkaQolpqneO9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yGwpf0gr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yGwpf0gr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1065DC4CEE2;
	Wed,  7 May 2025 19:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645054;
	bh=QQL+XrPmdqDtsXmDZZHhEUlzFW0mxQ4yDBIN/O66fuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yGwpf0grIUo7VfPrOlrxt0/SBBiNecZay06OHMSYRzMImv+AseaUc5wTvfzyX9a5v
	 D2jqaUX067Yo3t20MH/Ojz8PXJwYzIV5O+f/P6Bl6GQf6m1RJLCd6pVZ7yiDJJ1RBA
	 gmBxoKHzeDv0dD+CtvWHpmoRY15TYUA7crEnrJoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chad Monroe <chad@monroe.io>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/129] net: ethernet: mtk_eth_soc: fix SER panic with 4GB+ RAM
Date: Wed,  7 May 2025 20:40:14 +0200
Message-ID: <20250507183816.671717638@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Chad Monroe <chad@monroe.io>

[ Upstream commit 6e0490fc36cdac696f96e57b61d93b9ae32e0f4c ]

If the mtk_poll_rx() function detects the MTK_RESETTING flag, it will
jump to release_desc and refill the high word of the SDP on the 4GB RFB.
Subsequently, mtk_rx_clean will process an incorrect SDP, leading to a
panic.

Add patch from MediaTek's SDK to resolve this.

Fixes: 2d75891ebc09 ("net: ethernet: mtk_eth_soc: support 36-bit DMA addressing on MT7988")
Link: https://git01.mediatek.com/plugins/gitiles/openwrt/feeds/mtk-openwrt-feeds/+/71f47ea785699c6aa3b922d66c2bdc1a43da25b1
Signed-off-by: Chad Monroe <chad@monroe.io>
Link: https://patch.msgid.link/4adc2aaeb0fb1b9cdc56bf21cf8e7fa328daa345.1745715843.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index dc89dbc13b251..d2ec8f642c2fa 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2180,14 +2180,18 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		ring->data[idx] = new_data;
 		rxd->rxd1 = (unsigned int)dma_addr;
 release_desc:
+		if (MTK_HAS_CAPS(eth->soc->caps, MTK_36BIT_DMA)) {
+			if (unlikely(dma_addr == DMA_MAPPING_ERROR))
+				addr64 = FIELD_GET(RX_DMA_ADDR64_MASK,
+						   rxd->rxd2);
+			else
+				addr64 = RX_DMA_PREP_ADDR64(dma_addr);
+		}
+
 		if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628))
 			rxd->rxd2 = RX_DMA_LSO;
 		else
-			rxd->rxd2 = RX_DMA_PREP_PLEN0(ring->buf_size);
-
-		if (MTK_HAS_CAPS(eth->soc->caps, MTK_36BIT_DMA) &&
-		    likely(dma_addr != DMA_MAPPING_ERROR))
-			rxd->rxd2 |= RX_DMA_PREP_ADDR64(dma_addr);
+			rxd->rxd2 = RX_DMA_PREP_PLEN0(ring->buf_size) | addr64;
 
 		ring->calc_idx = idx;
 		done++;
-- 
2.39.5



