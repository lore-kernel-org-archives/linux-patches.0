Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722FC22A1D4;
	Mon, 12 May 2025 17:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071778; cv=none; b=pOVn8712/nNH8MIJjINeLYB8tRsLLeHc67veoS0r3GBqGd/q2p8cExgHSKJtf2H2/5faYJDDQD9qASy947NeqeMls7uDjmVlBosHILB9WoqRjH781LIC0wpUJH7Q0w+vkHqnPJ8BBTo8BfyHcCUdWQJcDw3zNcxTXWGgk6EjMws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071778; c=relaxed/simple;
	bh=TtLh6xgcFXT7AUFTfLdSFaMDRZg3uvhx+MsEZTpfamU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7h3rmJaJDef1ayNNHYMzzafEk9q7j+5Uf/Mrj1HPPsmGNfP6kvsh8WyA+80ozycQaiKzzI1ZS7mcKPzQrr+h0po9JENttc5SLn35ziv70IgGbPUo65wJ7xicW73Hq4SRq6TQ1d8dkUfk3V6OVtaKhCkdK4N/Krq7KDA7LaBCbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G+piwf7c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G+piwf7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2FCC4CEE7;
	Mon, 12 May 2025 17:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071777;
	bh=TtLh6xgcFXT7AUFTfLdSFaMDRZg3uvhx+MsEZTpfamU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G+piwf7cWjBTpMF5xP9ZR0RRSMPBF7LQR5OkDNH7Rj2KLUghTQSABa7WES5IRpWuV
	 DI+JitCRR/oEKtvwjKEimrvk+Lz5QbTDhD3jUQVM438mDYtroQMGVuYOl4UAf46G4M
	 CU+Ho990dAe0RAOoZNjoJrqYSPPAL9WDNHU7kwMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 023/197] net: ethernet: mtk_eth_soc: reset all TX queues on DMA free
Date: Mon, 12 May 2025 19:37:53 +0200
Message-ID: <20250512172045.291272798@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index c6d60f1d4f77a..bf6e572762413 100644
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



