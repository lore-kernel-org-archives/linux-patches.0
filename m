Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2392123C510;
	Mon, 12 May 2025 18:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073241; cv=none; b=kBzyh3lWfKFab682e8goKwL6wMK/mSJj/muXfJ2wJKcBykQRg2rLLO7w31jkrmByXcfD690tmtkqq+Lfvi3u3jP9DPsIkCIICd7pTM/b4MbP8FXVeOjxjtFBi/vmsQBRJ0Y6eor+wPffzyA+df8TbBdxI1C4a0n1ijyxolqt1EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073241; c=relaxed/simple;
	bh=aANv5vi9jWyqvIe0CrhHuKejHUP56R0UkvXDwp5YLbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KirZF/OU7ZgILMvMHrDZTGMRTxXMfv6ffWYxEzQtaRHray+OpA/Ew174k2+dX3XcvAYNSMUoUK/lqB06mG9Y30opquo88sRiAwlP3NW5BJ0gT5JSuihT7CLow6gP4ncwzMr7V9eA11+YarFK5ru+SdzwhBG9lfYVPRD1MBrHaa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ooERXTAs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ooERXTAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7612CC4CEF0;
	Mon, 12 May 2025 18:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073241;
	bh=aANv5vi9jWyqvIe0CrhHuKejHUP56R0UkvXDwp5YLbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ooERXTAsPZsiHBBOExeUdImXSgzZkr91TPO+HJnGwXQRWJ2tFiXkR43IDai0+woIo
	 ccLqgDj3cRjBFV5+vqhvvbioAigar53X42Huvp1GMklGhEmHiVAM/lO/suAsAnapFv
	 h09c7EfCTKqJCuhTx/f626iuxPmRw6ujSP+6EMXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/113] net: ethernet: mtk_eth_soc: reset all TX queues on DMA free
Date: Mon, 12 May 2025 19:45:03 +0200
Message-ID: <20250512172028.272901878@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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
index d2ec8f642c2fa..c6ccfbd422657 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3117,11 +3117,19 @@ static int mtk_dma_init(struct mtk_eth *eth)
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
 				  MTK_QDMA_RING_SIZE * soc->txrx.txd_size,
-- 
2.39.5



