Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBDD18FDB0;
	Mon, 28 Oct 2024 06:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097348; cv=none; b=SoNxByoD4GUXuZSYxkjmRRr5Zk7KaeW/X5EAIFWFgxSWIW3uVgJVRF34UtyWiSWnADsmq0+5ar0QaXUx56rqjwdHag7BfU6ZOKRVf7U1h46fe/nwQPLhGK3M8222FFJSUvtWfJF+8N30bvpXzwOdRBH+1D7fFeaiu9sOMjfB+6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097348; c=relaxed/simple;
	bh=1ptQ1w+xNMwCiXxzg5jzEovphNSUyDYlvGxZ4YRXe4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQ2nw+0PYhGJRKWEcWj3EUFzc2D+E7ePmuY7zmqEDtnhW/M1llcr7b5pn660Ixu/dj5HD3eIrG//GEjCbB1e2d636FMU/of55OL+1m0xvljjTEzS72lSoP8XfunQv0IYeYKl21QFeO/GghtZuupmWf9IWbJo8Fwv3MT4qoLGXTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qFTIS+l3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qFTIS+l3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285DAC4CEC3;
	Mon, 28 Oct 2024 06:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097348;
	bh=1ptQ1w+xNMwCiXxzg5jzEovphNSUyDYlvGxZ4YRXe4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qFTIS+l3zPBSJ1FmOvk0c2TCKYdl2YHOK1zjSdptounf6TRUVzf/hpJxcKFv8kEpR
	 vDvU2lEMx27q8fPz7c5BQnZcDyMGZGIfSc5UCFKfGP2in1FjVpJvWS92g1L+nstl7+
	 +d0UDhWoni8hBSWgVoxbNpjg5IARrB3cS/pge9Ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/137] octeon_ep: Implement helper for iterating packets in Rx queue
Date: Mon, 28 Oct 2024 07:25:28 +0100
Message-ID: <20241028062301.269665159@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit bd28df26197b2bd0913bf1b36770836481975143 ]

The common code with some packet and index manipulations is extracted and
moved to newly implemented helper to make the code more readable and avoid
duplication. This is a preparation for skb allocation failure handling.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Suggested-by: Simon Horman <horms@kernel.org>
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Stable-dep-of: eb592008f79b ("octeon_ep: Add SKB allocation failures handling in __octep_oq_process_rx()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeon_ep/octep_rx.c | 55 +++++++++++--------
 1 file changed, 32 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
index 392d9b0da0d7a..03d46c28a009c 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
@@ -336,6 +336,30 @@ static int octep_oq_check_hw_for_pkts(struct octep_device *oct,
 	return new_pkts;
 }
 
+/**
+ * octep_oq_next_pkt() - Move to the next packet in Rx queue.
+ *
+ * @oq: Octeon Rx queue data structure.
+ * @buff_info: Current packet buffer info.
+ * @read_idx: Current packet index in the ring.
+ * @desc_used: Current packet descriptor number.
+ *
+ * Free the resources associated with a packet.
+ * Increment packet index in the ring and packet descriptor number.
+ */
+static void octep_oq_next_pkt(struct octep_oq *oq,
+			      struct octep_rx_buffer *buff_info,
+			      u32 *read_idx, u32 *desc_used)
+{
+	dma_unmap_page(oq->dev, oq->desc_ring[*read_idx].buffer_ptr,
+		       PAGE_SIZE, DMA_FROM_DEVICE);
+	buff_info->page = NULL;
+	(*read_idx)++;
+	(*desc_used)++;
+	if (*read_idx == oq->max_count)
+		*read_idx = 0;
+}
+
 /**
  * __octep_oq_process_rx() - Process hardware Rx queue and push to stack.
  *
@@ -365,10 +389,7 @@ static int __octep_oq_process_rx(struct octep_device *oct,
 	desc_used = 0;
 	for (pkt = 0; pkt < pkts_to_process; pkt++) {
 		buff_info = (struct octep_rx_buffer *)&oq->buff_info[read_idx];
-		dma_unmap_page(oq->dev, oq->desc_ring[read_idx].buffer_ptr,
-			       PAGE_SIZE, DMA_FROM_DEVICE);
 		resp_hw = page_address(buff_info->page);
-		buff_info->page = NULL;
 
 		/* Swap the length field that is in Big-Endian to CPU */
 		buff_info->len = be64_to_cpu(resp_hw->length);
@@ -390,36 +411,27 @@ static int __octep_oq_process_rx(struct octep_device *oct,
 			 */
 			data_offset = OCTEP_OQ_RESP_HW_SIZE;
 		}
+
+		octep_oq_next_pkt(oq, buff_info, &read_idx, &desc_used);
+
+		skb = build_skb((void *)resp_hw, PAGE_SIZE);
+		skb_reserve(skb, data_offset);
+
 		rx_bytes += buff_info->len;
 
 		if (buff_info->len <= oq->max_single_buffer_size) {
-			skb = build_skb((void *)resp_hw, PAGE_SIZE);
-			skb_reserve(skb, data_offset);
 			skb_put(skb, buff_info->len);
-			read_idx++;
-			desc_used++;
-			if (read_idx == oq->max_count)
-				read_idx = 0;
 		} else {
 			struct skb_shared_info *shinfo;
 			u16 data_len;
 
-			skb = build_skb((void *)resp_hw, PAGE_SIZE);
-			skb_reserve(skb, data_offset);
 			/* Head fragment includes response header(s);
 			 * subsequent fragments contains only data.
 			 */
 			skb_put(skb, oq->max_single_buffer_size);
-			read_idx++;
-			desc_used++;
-			if (read_idx == oq->max_count)
-				read_idx = 0;
-
 			shinfo = skb_shinfo(skb);
 			data_len = buff_info->len - oq->max_single_buffer_size;
 			while (data_len) {
-				dma_unmap_page(oq->dev, oq->desc_ring[read_idx].buffer_ptr,
-					       PAGE_SIZE, DMA_FROM_DEVICE);
 				buff_info = (struct octep_rx_buffer *)
 					    &oq->buff_info[read_idx];
 				if (data_len < oq->buffer_size) {
@@ -434,11 +446,8 @@ static int __octep_oq_process_rx(struct octep_device *oct,
 						buff_info->page, 0,
 						buff_info->len,
 						buff_info->len);
-				buff_info->page = NULL;
-				read_idx++;
-				desc_used++;
-				if (read_idx == oq->max_count)
-					read_idx = 0;
+
+				octep_oq_next_pkt(oq, buff_info, &read_idx, &desc_used);
 			}
 		}
 
-- 
2.43.0



