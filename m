Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20141CAA6C;
	Wed, 19 Feb 2025 08:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954867; cv=none; b=lGSFVnNju06+AHZeDNo8Wl2zD7+lFxXAlIO/BbasNM5cayMIlXFdayGpbXWhWNWxLjCyXfRQJIr5PaYyUy4MINlsRKUR5X58h89mh8lHv6aGHf8nNmmyiq4WT7ZsS/XUjRzi7p0SnYziXSlLmy7jlJRD/furTsK499sBqGl0IU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954867; c=relaxed/simple;
	bh=ojAidztbY/dmEXKc/ALFKzC53LwWEqCySsO1yNrI5Cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHs7xzvKI6MDeEDHTViC41cUU98z1otLIA9BGCMNAr6Ie65Lct+mKUceNZGDrXCFoMsUPZrFADiUXjI1GRdGZVA8LiCViTTeTqVtGZYqr3GcuBaXP8owvs4zuqizWhArM87oBgJ2T8MGbQrwk/tUs0+YnTC4VNYWkF/7vqufty0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZwViHbf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZwViHbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3CFC4CEE6;
	Wed, 19 Feb 2025 08:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954867;
	bh=ojAidztbY/dmEXKc/ALFKzC53LwWEqCySsO1yNrI5Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZwViHbf/zLfrZpn6samuhKVwFAQRKMdtCyKrPdmhRa6wO6eZbbOcv165x1pgYweD
	 81yEWRO1OBHmBBDUyhhNPqSHe2RVVWqnZo7AepofgdR+DvXUiybpPR4RCZk0oE/3ui
	 kp7w8bAV+w9RaSLrK3x6sKWKvGtuj7scJ51uTApQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Quadros <rogerq@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/230] net: ethernet: ti: am65-cpsw: fix memleak in certain XDP cases
Date: Wed, 19 Feb 2025 09:25:46 +0100
Message-ID: <20250219082602.846038605@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

From: Roger Quadros <rogerq@kernel.org>

[ Upstream commit 5db843258de1e4e6b1ef1cbd1797923c9e3de548 ]

If the XDP program doesn't result in XDP_PASS then we leak the
memory allocated by am65_cpsw_build_skb().

It is pointless to allocate SKB memory before running the XDP
program as we would be wasting CPU cycles for cases other than XDP_PASS.
Move the SKB allocation after evaluating the XDP program result.

This fixes the memleak. A performance boost is seen for XDP_DROP test.

XDP_DROP test:
Before: 460256 rx/s                  0 err/s
After:  784130 rx/s                  0 err/s

Fixes: 8acacc40f733 ("net: ethernet: ti: am65-cpsw: Add minimal XDP support")
Signed-off-by: Roger Quadros <rogerq@kernel.org>
Link: https://patch.msgid.link/20250210-am65-cpsw-xdp-fixes-v1-1-ec6b1f7f1aca@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 26 ++++++++++++------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 3c0d067c36099..14df3c0141679 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -599,7 +599,8 @@ static void am65_cpsw_nuss_tx_cleanup(void *data, dma_addr_t desc_dma)
 
 static struct sk_buff *am65_cpsw_build_skb(void *page_addr,
 					   struct net_device *ndev,
-					   unsigned int len)
+					   unsigned int len,
+					   unsigned int headroom)
 {
 	struct sk_buff *skb;
 
@@ -609,7 +610,7 @@ static struct sk_buff *am65_cpsw_build_skb(void *page_addr,
 	if (unlikely(!skb))
 		return NULL;
 
-	skb_reserve(skb, AM65_CPSW_HEADROOM);
+	skb_reserve(skb, headroom);
 	skb->dev = ndev;
 
 	return skb;
@@ -1191,16 +1192,8 @@ static int am65_cpsw_nuss_rx_packets(struct am65_cpsw_rx_flow *flow,
 	dev_dbg(dev, "%s rx csum_info:%#x\n", __func__, csum_info);
 
 	dma_unmap_single(rx_chn->dma_dev, buf_dma, buf_dma_len, DMA_FROM_DEVICE);
-
 	k3_cppi_desc_pool_free(rx_chn->desc_pool, desc_rx);
 
-	skb = am65_cpsw_build_skb(page_addr, ndev,
-				  AM65_CPSW_MAX_PACKET_SIZE);
-	if (unlikely(!skb)) {
-		new_page = page;
-		goto requeue;
-	}
-
 	if (port->xdp_prog) {
 		xdp_init_buff(&xdp, PAGE_SIZE, &port->xdp_rxq[flow->id]);
 		xdp_prepare_buff(&xdp, page_addr, AM65_CPSW_HEADROOM,
@@ -1210,9 +1203,16 @@ static int am65_cpsw_nuss_rx_packets(struct am65_cpsw_rx_flow *flow,
 		if (*xdp_state != AM65_CPSW_XDP_PASS)
 			goto allocate;
 
-		/* Compute additional headroom to be reserved */
-		headroom = (xdp.data - xdp.data_hard_start) - skb_headroom(skb);
-		skb_reserve(skb, headroom);
+		headroom = xdp.data - xdp.data_hard_start;
+	} else {
+		headroom = AM65_CPSW_HEADROOM;
+	}
+
+	skb = am65_cpsw_build_skb(page_addr, ndev,
+				  AM65_CPSW_MAX_PACKET_SIZE, headroom);
+	if (unlikely(!skb)) {
+		new_page = page;
+		goto requeue;
 	}
 
 	ndev_priv = netdev_priv(ndev);
-- 
2.39.5



