Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F56723A98D;
	Tue,  8 Jul 2025 16:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992718; cv=none; b=n+HK/QTstiuAAp0ezAB06bJrrCyvqShFQS9UZ6WrrHySt2RXbeDo4EtT46G/HHeOhjxfah0jvsF4fy2nruZXE9R4ybtIOpB4WRBGJNNi4I8OvRTqdu6ZLK1BG7C1Wai2CvZ1Apd4KKu6krjgadDlWsplJfxXfVumhEKV4CH3Wbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992718; c=relaxed/simple;
	bh=TRSOkcBHWnxnY6p6P1fiRnYgFBAE86qO0gDoCG4s8BA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bl/EB07xDt+zt3XmvtJi87pgY+7Djq4z5uhr7yStjd9uB8x6OGCWivk65O+0dJTnuqmFa40T2Aaq5TbUeLCitA+gUmoXvRD4/v9CLXgSy2r5jSQ0PGh/LnLMQdhkUifvxj3J1pXcZhrphU3LKx/J9DMAouF/YFwGezCJ81N/pWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hmxZA/ah; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hmxZA/ah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C54C4CEED;
	Tue,  8 Jul 2025 16:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992718;
	bh=TRSOkcBHWnxnY6p6P1fiRnYgFBAE86qO0gDoCG4s8BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hmxZA/ahWBiruboIHssaYHGUnIgi/hllXxaksXOLbc48dNm1+7p+AdcUR2u/X5eDt
	 C34fYfQcqbogYp+Axuu+m0+QG1tTYeSQYZTXN+48HNEzrYCiAbrC5awHdTh3kgTKUc
	 ljycU+28bnAirP2NtaN70izvya6bjKnyeForT74U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/232] ethernet: atl1: Add missing DMA mapping error checks and count errors
Date: Tue,  8 Jul 2025 18:20:52 +0200
Message-ID: <20250708162242.929754264@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit d72411d20905180cdc452c553be17481b24463d2 ]

The `dma_map_XXX()` functions can fail and must be checked using
`dma_mapping_error()`.  This patch adds proper error handling for all
DMA mapping calls.

In `atl1_alloc_rx_buffers()`, if DMA mapping fails, the buffer is
deallocated and marked accordingly.

In `atl1_tx_map()`, previously mapped buffers are unmapped and the
packet is dropped on failure.

If `atl1_xmit_frame()` drops the packet, increment the tx_error counter.

Fixes: f3cc28c79760 ("Add Attansic L1 ethernet driver.")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://patch.msgid.link/20250625141629.114984-2-fourier.thomas@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/atheros/atlx/atl1.c | 79 +++++++++++++++++-------
 1 file changed, 57 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
index 3afd3627ce485..9c5d619909045 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -1861,14 +1861,21 @@ static u16 atl1_alloc_rx_buffers(struct atl1_adapter *adapter)
 			break;
 		}
 
-		buffer_info->alloced = 1;
-		buffer_info->skb = skb;
-		buffer_info->length = (u16) adapter->rx_buffer_len;
 		page = virt_to_page(skb->data);
 		offset = offset_in_page(skb->data);
 		buffer_info->dma = dma_map_page(&pdev->dev, page, offset,
 						adapter->rx_buffer_len,
 						DMA_FROM_DEVICE);
+		if (dma_mapping_error(&pdev->dev, buffer_info->dma)) {
+			kfree_skb(skb);
+			adapter->soft_stats.rx_dropped++;
+			break;
+		}
+
+		buffer_info->alloced = 1;
+		buffer_info->skb = skb;
+		buffer_info->length = (u16)adapter->rx_buffer_len;
+
 		rfd_desc->buffer_addr = cpu_to_le64(buffer_info->dma);
 		rfd_desc->buf_len = cpu_to_le16(adapter->rx_buffer_len);
 		rfd_desc->coalese = 0;
@@ -2183,8 +2190,8 @@ static int atl1_tx_csum(struct atl1_adapter *adapter, struct sk_buff *skb,
 	return 0;
 }
 
-static void atl1_tx_map(struct atl1_adapter *adapter, struct sk_buff *skb,
-	struct tx_packet_desc *ptpd)
+static bool atl1_tx_map(struct atl1_adapter *adapter, struct sk_buff *skb,
+			struct tx_packet_desc *ptpd)
 {
 	struct atl1_tpd_ring *tpd_ring = &adapter->tpd_ring;
 	struct atl1_buffer *buffer_info;
@@ -2194,6 +2201,7 @@ static void atl1_tx_map(struct atl1_adapter *adapter, struct sk_buff *skb,
 	unsigned int nr_frags;
 	unsigned int f;
 	int retval;
+	u16 first_mapped;
 	u16 next_to_use;
 	u16 data_len;
 	u8 hdr_len;
@@ -2201,6 +2209,7 @@ static void atl1_tx_map(struct atl1_adapter *adapter, struct sk_buff *skb,
 	buf_len -= skb->data_len;
 	nr_frags = skb_shinfo(skb)->nr_frags;
 	next_to_use = atomic_read(&tpd_ring->next_to_use);
+	first_mapped = next_to_use;
 	buffer_info = &tpd_ring->buffer_info[next_to_use];
 	BUG_ON(buffer_info->skb);
 	/* put skb in last TPD */
@@ -2216,6 +2225,8 @@ static void atl1_tx_map(struct atl1_adapter *adapter, struct sk_buff *skb,
 		buffer_info->dma = dma_map_page(&adapter->pdev->dev, page,
 						offset, hdr_len,
 						DMA_TO_DEVICE);
+		if (dma_mapping_error(&adapter->pdev->dev, buffer_info->dma))
+			goto dma_err;
 
 		if (++next_to_use == tpd_ring->count)
 			next_to_use = 0;
@@ -2242,6 +2253,9 @@ static void atl1_tx_map(struct atl1_adapter *adapter, struct sk_buff *skb,
 								page, offset,
 								buffer_info->length,
 								DMA_TO_DEVICE);
+				if (dma_mapping_error(&adapter->pdev->dev,
+						      buffer_info->dma))
+					goto dma_err;
 				if (++next_to_use == tpd_ring->count)
 					next_to_use = 0;
 			}
@@ -2254,6 +2268,8 @@ static void atl1_tx_map(struct atl1_adapter *adapter, struct sk_buff *skb,
 		buffer_info->dma = dma_map_page(&adapter->pdev->dev, page,
 						offset, buf_len,
 						DMA_TO_DEVICE);
+		if (dma_mapping_error(&adapter->pdev->dev, buffer_info->dma))
+			goto dma_err;
 		if (++next_to_use == tpd_ring->count)
 			next_to_use = 0;
 	}
@@ -2277,6 +2293,9 @@ static void atl1_tx_map(struct atl1_adapter *adapter, struct sk_buff *skb,
 			buffer_info->dma = skb_frag_dma_map(&adapter->pdev->dev,
 				frag, i * ATL1_MAX_TX_BUF_LEN,
 				buffer_info->length, DMA_TO_DEVICE);
+			if (dma_mapping_error(&adapter->pdev->dev,
+					      buffer_info->dma))
+				goto dma_err;
 
 			if (++next_to_use == tpd_ring->count)
 				next_to_use = 0;
@@ -2285,6 +2304,22 @@ static void atl1_tx_map(struct atl1_adapter *adapter, struct sk_buff *skb,
 
 	/* last tpd's buffer-info */
 	buffer_info->skb = skb;
+
+	return true;
+
+ dma_err:
+	while (first_mapped != next_to_use) {
+		buffer_info = &tpd_ring->buffer_info[first_mapped];
+		dma_unmap_page(&adapter->pdev->dev,
+			       buffer_info->dma,
+			       buffer_info->length,
+			       DMA_TO_DEVICE);
+		buffer_info->dma = 0;
+
+		if (++first_mapped == tpd_ring->count)
+			first_mapped = 0;
+	}
+	return false;
 }
 
 static void atl1_tx_queue(struct atl1_adapter *adapter, u16 count,
@@ -2355,10 +2390,8 @@ static netdev_tx_t atl1_xmit_frame(struct sk_buff *skb,
 
 	len = skb_headlen(skb);
 
-	if (unlikely(skb->len <= 0)) {
-		dev_kfree_skb_any(skb);
-		return NETDEV_TX_OK;
-	}
+	if (unlikely(skb->len <= 0))
+		goto drop_packet;
 
 	nr_frags = skb_shinfo(skb)->nr_frags;
 	for (f = 0; f < nr_frags; f++) {
@@ -2371,10 +2404,9 @@ static netdev_tx_t atl1_xmit_frame(struct sk_buff *skb,
 	if (mss) {
 		if (skb->protocol == htons(ETH_P_IP)) {
 			proto_hdr_len = skb_tcp_all_headers(skb);
-			if (unlikely(proto_hdr_len > len)) {
-				dev_kfree_skb_any(skb);
-				return NETDEV_TX_OK;
-			}
+			if (unlikely(proto_hdr_len > len))
+				goto drop_packet;
+
 			/* need additional TPD ? */
 			if (proto_hdr_len != len)
 				count += (len - proto_hdr_len +
@@ -2406,23 +2438,26 @@ static netdev_tx_t atl1_xmit_frame(struct sk_buff *skb,
 	}
 
 	tso = atl1_tso(adapter, skb, ptpd);
-	if (tso < 0) {
-		dev_kfree_skb_any(skb);
-		return NETDEV_TX_OK;
-	}
+	if (tso < 0)
+		goto drop_packet;
 
 	if (!tso) {
 		ret_val = atl1_tx_csum(adapter, skb, ptpd);
-		if (ret_val < 0) {
-			dev_kfree_skb_any(skb);
-			return NETDEV_TX_OK;
-		}
+		if (ret_val < 0)
+			goto drop_packet;
 	}
 
-	atl1_tx_map(adapter, skb, ptpd);
+	if (!atl1_tx_map(adapter, skb, ptpd))
+		goto drop_packet;
+
 	atl1_tx_queue(adapter, count, ptpd);
 	atl1_update_mailbox(adapter);
 	return NETDEV_TX_OK;
+
+drop_packet:
+	adapter->soft_stats.tx_errors++;
+	dev_kfree_skb_any(skb);
+	return NETDEV_TX_OK;
 }
 
 static int atl1_rings_clean(struct napi_struct *napi, int budget)
-- 
2.39.5



