Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E501E1A05;
	Mon, 12 May 2025 17:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072682; cv=none; b=Z7fFXKSZSfvmElT5aAjYacPcD3Ak6lrNP7Iol/IhI82z10K15YEYEIPMkZTKOoua0fo7yPAtTEYCaCodIeiMvjykvqe0FVGKUm9Noi2ebZbMaGMmlhsY/pxLWuvFRolNJJfwr9LVTogumlUA0/IiiwIBfx3FvEs3skTzzgn6Fh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072682; c=relaxed/simple;
	bh=vTBS7yfjCcQjs9cWi6gT5SpI3IQo5DLVvI7VDal0nzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZl6qoHJ9w88Q79TAKSDFawoIORM8K1T6qlxXD4NmbUcw03binq3uRrck9V3ePT1FiUaS/41JuSGG78lKK+M4a6nDfRzTEiEVcD2jp5HzQfHJ/ncBeQizX2rad+bcbVzGY8TlGKu/Acwbibn4Acs8puI+atapPA306SEEEHJA8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SrmY0D0/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SrmY0D0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7E3C4CEE7;
	Mon, 12 May 2025 17:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072682;
	bh=vTBS7yfjCcQjs9cWi6gT5SpI3IQo5DLVvI7VDal0nzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SrmY0D0/CVN2HwcFXqILDpRWfTSJ/WoGnMhIP7H5/CeWh3ZZu/1qpUYB/iaFbjErc
	 7FUTbDpCNy+l6dQdahPNfyBNic9YnKhHWYxlx7V1XMLMQcBkFchgq5Hpx9LhGCZCvG
	 cWYTEtz0RHGif7pkRhJDFxMEdSC966xVZASUr/SI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/184] net: ethernet: mtk_eth_soc: reset all TX queues on DMA free
Date: Mon, 12 May 2025 19:43:44 +0200
Message-ID: <20250512172042.644878633@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 4db6c75124d871fbabf8243f947d34cc7e0697fc ]

The purpose of resetting the TX queue is to reset the byte and packet
count as well as to clear the software flow control XOFF bit.

MediaTek developers pointed out that netdev_reset_queue would only
resets queue 0 of the network device.

Queues that are not reset may cause unexpected issues.

Packets may stop being sent after reset and "transmit timeout" log may
be displayed.

Import fix from MediaTek's SDK to resolve this issue.

Link: https://git01.mediatek.com/plugins/gitiles/openwrt/feeds/mtk-openwrt-feeds/+/319c0d9905579a46dc448579f892f364f1f84818
Fixes: f63959c7eec31 ("net: ethernet: mtk_eth_soc: implement multi-queue support for per-port queues")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://patch.msgid.link/c9ff9adceac4f152239a0f65c397f13547639175.1746406763.git.daniel@makrotopia.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index c5d5b9ff8bc42..d50017012ca14 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3140,11 +3140,19 @@ static int mtk_dma_init(struct mtk_eth *eth)
 static void mtk_dma_free(struct mtk_eth *eth)
 {
 	const struct mtk_soc_data *soc = eth->soc;
-	int i;
+	int i, j, txqs = 1;
+
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA))
+		txqs = MTK_QDMA_NUM_QUEUES;
+
+	for (i = 0; i < MTK_MAX_DEVS; i++) {
+		if (!eth->netdev[i])
+			continue;
+
+		for (j = 0; j < txqs; j++)
+			netdev_tx_reset_subqueue(eth->netdev[i], j);
+	}
 
-	for (i = 0; i < MTK_MAX_DEVS; i++)
-		if (eth->netdev[i])
-			netdev_reset_queue(eth->netdev[i]);
 	if (!MTK_HAS_CAPS(soc->caps, MTK_SRAM) && eth->scratch_ring) {
 		dma_free_coherent(eth->dma_dev,
 				  MTK_QDMA_RING_SIZE * soc->tx.desc_size,
-- 
2.39.5



