Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4781F55E3;
	Tue, 21 Jan 2025 17:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482283; cv=none; b=bRhc7fBXa6Zfun3g1vB8/U1nW4vEbMQDFflVp1RfswySAuHF/Eg50jVfHF6ZZctv4+jaC4xUa1i7GxeEYPG9vqyojpglLrJk89BFAMohyACTDalJWaCJayyIS9vqLG8BhqgZOFpzOlbbGMhOfJ4Aq5aWRwZFCzwlR59p0h+UXuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482283; c=relaxed/simple;
	bh=Dogx/eq/JvGaybWCiGwxu0fhcmvH6J24oENLdATi2O0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjnXdzxE17zcU93OxeT9yJKWXXqgJeeFN3KZ3E8JQ9XgJNBAj3jXvdPczBPlltZnoch6zIMsjT5gka5ydE6qmdxcSBxY3CqVyIbYZ4drwtsKtoQKIigxtDsgr21iRBXTRcnvruIMIldPUIVkeLyk+sFFPnMtjLJJmSG5wsqTfU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WCasJmdG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WCasJmdG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92904C4CEDF;
	Tue, 21 Jan 2025 17:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482283;
	bh=Dogx/eq/JvGaybWCiGwxu0fhcmvH6J24oENLdATi2O0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WCasJmdGWfpbqeiGVQISQgAFLdmyfBUBBaD6mhUVfuLqSBkdtqKyNvClkHQjwT83h
	 b9W3LsuwCpv9Xe76hOkgnnBBqPLh3f3Cwix/2djXPEGxyXSV5NEoKUmZb5W4VzSZVR
	 lUXB1ZZnoLB9G8vkDpI9ffjNFIBjkhFU+lrEjZJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Groeneveld <kgroeneveld@lenbrook.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/122] net: fec: handle page_pool_dev_alloc_pages error
Date: Tue, 21 Jan 2025 18:51:11 +0100
Message-ID: <20250121174533.889168411@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

From: Kevin Groeneveld <kgroeneveld@lenbrook.com>

[ Upstream commit 001ba0902046cb6c352494df610718c0763e77a5 ]

The fec_enet_update_cbd function calls page_pool_dev_alloc_pages but did
not handle the case when it returned NULL. There was a WARN_ON(!new_page)
but it would still proceed to use the NULL pointer and then crash.

This case does seem somewhat rare but when the system is under memory
pressure it can happen. One case where I can duplicate this with some
frequency is when writing over a smbd share to a SATA HDD attached to an
imx6q.

Setting /proc/sys/vm/min_free_kbytes to higher values also seems to solve
the problem for my test case. But it still seems wrong that the fec driver
ignores the memory allocation error and can crash.

This commit handles the allocation error by dropping the current packet.

Fixes: 95698ff6177b5 ("net: fec: using page pool to manage RX buffers")
Signed-off-by: Kevin Groeneveld <kgroeneveld@lenbrook.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20250113154846.1765414-1-kgroeneveld@lenbrook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 9d9fcec41488e..49d1748e0c043 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1591,19 +1591,22 @@ static void fec_enet_tx(struct net_device *ndev, int budget)
 		fec_enet_tx_queue(ndev, i, budget);
 }
 
-static void fec_enet_update_cbd(struct fec_enet_priv_rx_q *rxq,
+static int fec_enet_update_cbd(struct fec_enet_priv_rx_q *rxq,
 				struct bufdesc *bdp, int index)
 {
 	struct page *new_page;
 	dma_addr_t phys_addr;
 
 	new_page = page_pool_dev_alloc_pages(rxq->page_pool);
-	WARN_ON(!new_page);
-	rxq->rx_skb_info[index].page = new_page;
+	if (unlikely(!new_page))
+		return -ENOMEM;
 
+	rxq->rx_skb_info[index].page = new_page;
 	rxq->rx_skb_info[index].offset = FEC_ENET_XDP_HEADROOM;
 	phys_addr = page_pool_get_dma_addr(new_page) + FEC_ENET_XDP_HEADROOM;
 	bdp->cbd_bufaddr = cpu_to_fec32(phys_addr);
+
+	return 0;
 }
 
 static u32
@@ -1698,6 +1701,7 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 	int cpu = smp_processor_id();
 	struct xdp_buff xdp;
 	struct page *page;
+	__fec32 cbd_bufaddr;
 	u32 sub_len = 4;
 
 #if !defined(CONFIG_M5272)
@@ -1766,12 +1770,17 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 
 		index = fec_enet_get_bd_index(bdp, &rxq->bd);
 		page = rxq->rx_skb_info[index].page;
+		cbd_bufaddr = bdp->cbd_bufaddr;
+		if (fec_enet_update_cbd(rxq, bdp, index)) {
+			ndev->stats.rx_dropped++;
+			goto rx_processing_done;
+		}
+
 		dma_sync_single_for_cpu(&fep->pdev->dev,
-					fec32_to_cpu(bdp->cbd_bufaddr),
+					fec32_to_cpu(cbd_bufaddr),
 					pkt_len,
 					DMA_FROM_DEVICE);
 		prefetch(page_address(page));
-		fec_enet_update_cbd(rxq, bdp, index);
 
 		if (xdp_prog) {
 			xdp_buff_clear_frags_flag(&xdp);
-- 
2.39.5



