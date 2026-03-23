Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D800B3B3890;
	Mon, 23 Mar 2026 15:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278690; cv=none; b=L9XQ2bmpjNLebgTI+47AbZDLRmROKAgKcz5ul9rIAl0IW797KJ/A4wdtSErGCHl7KaYdjp3usZRXbG4Wc0jmHJN70+guhZyaMW1xqMjtjhb/iSQJakYA4lN0cc88xUujNA/DpqZ0f2j0B2oqDcKiE326JSv9BdYiw1iDelbrw3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278690; c=relaxed/simple;
	bh=jTa8mWvVSbm8Xb0rpmcO5zAm/wjX0yfBRzfQmsfVXMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=faYcf4DIVTZ273uJcNcwBfX1fQgGRVTXBS4w+6J9ix3jM1E7QrycO8F3icT1Tl4qIaBhX8aeQdhBiMs22IIzR6SHqCJMqeqRv4LWTN7Gu9xxRR/HfHmToSV9W7wgc94EN0DjEPq8xLf9ZX3Uyb4c7fktnJI3o+snSwVD/NlhvD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WaWqoaMW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WaWqoaMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F135C4CEF7;
	Mon, 23 Mar 2026 15:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278690;
	bh=jTa8mWvVSbm8Xb0rpmcO5zAm/wjX0yfBRzfQmsfVXMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WaWqoaMWJL72XKwCg8EvaCrg9/DL6/+nEuct4rMHvRbabcg0D6dSSDF8hEEzhBR9D
	 f5iz7CNZUCvmc36neSggv5K+RtODVFvgbdCbZBnPjCDRqATeg8zVmP6adtSm1vNDmY
	 /YYl3GLLFufQOUV+ybsOGCtWts/B1ePqPIgsqiL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Garg <nktgrg@google.com>,
	Jordan Rhee <jordanrhee@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Joshua Washington <joshwash@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 371/567] gve: fix incorrect buffer cleanup in gve_tx_clean_pending_packets for QPL
Date: Mon, 23 Mar 2026 14:44:51 +0100
Message-ID: <20260323134543.004786632@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Ankit Garg <nktgrg@google.com>

[ Upstream commit fb868db5f4bccd7a78219313ab2917429f715cea ]

In DQ-QPL mode, gve_tx_clean_pending_packets() incorrectly uses the RDA
buffer cleanup path. It iterates num_bufs times and attempts to unmap
entries in the dma array.

This leads to two issues:
1. The dma array shares storage with tx_qpl_buf_ids (union).
 Interpreting buffer IDs as DMA addresses results in attempting to
 unmap incorrect memory locations.
2. num_bufs in QPL mode (counting 2K chunks) can significantly exceed
 the size of the dma array, causing out-of-bounds access warnings
(trace below is how we noticed this issue).

UBSAN: array-index-out-of-bounds in
drivers/net/ethernet/drivers/net/ethernet/google/gve/gve_tx_dqo.c:178:5 index 18 is out of
range for type 'dma_addr_t[18]' (aka 'unsigned long long[18]')
Workqueue: gve gve_service_task [gve]
Call Trace:
<TASK>
dump_stack_lvl+0x33/0xa0
__ubsan_handle_out_of_bounds+0xdc/0x110
gve_tx_stop_ring_dqo+0x182/0x200 [gve]
gve_close+0x1be/0x450 [gve]
gve_reset+0x99/0x120 [gve]
gve_service_task+0x61/0x100 [gve]
process_scheduled_works+0x1e9/0x380

Fix this by properly checking for QPL mode and delegating to
gve_free_tx_qpl_bufs() to reclaim the buffers.

Cc: stable@vger.kernel.org
Fixes: a6fb8d5a8b69 ("gve: Tx path for DQO-QPL")
Signed-off-by: Ankit Garg <nktgrg@google.com>
Reviewed-by: Jordan Rhee <jordanrhee@google.com>
Reviewed-by: Harshitha Ramamurthy <hramamurthy@google.com>
Signed-off-by: Joshua Washington <joshwash@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260220215324.1631350-1-joshwash@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ netmem_dma_unmap_page_attrs() => dma_unmap_page() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_tx_dqo.c |   52 +++++++++++----------------
 1 file changed, 23 insertions(+), 29 deletions(-)

--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -157,6 +157,24 @@ gve_free_pending_packet(struct gve_tx_ri
 	}
 }
 
+static void gve_unmap_packet(struct device *dev,
+			     struct gve_tx_pending_packet_dqo *pkt)
+{
+	int i;
+
+	if (!pkt->num_bufs)
+		return;
+
+	/* SKB linear portion is guaranteed to be mapped */
+	dma_unmap_single(dev, dma_unmap_addr(pkt, dma[0]),
+			 dma_unmap_len(pkt, len[0]), DMA_TO_DEVICE);
+	for (i = 1; i < pkt->num_bufs; i++) {
+		dma_unmap_page(dev, dma_unmap_addr(pkt, dma[i]),
+			       dma_unmap_len(pkt, len[i]), DMA_TO_DEVICE);
+	}
+	pkt->num_bufs = 0;
+}
+
 /* gve_tx_free_desc - Cleans up all pending tx requests and buffers.
  */
 static void gve_tx_clean_pending_packets(struct gve_tx_ring *tx)
@@ -166,21 +184,12 @@ static void gve_tx_clean_pending_packets
 	for (i = 0; i < tx->dqo.num_pending_packets; i++) {
 		struct gve_tx_pending_packet_dqo *cur_state =
 			&tx->dqo.pending_packets[i];
-		int j;
 
-		for (j = 0; j < cur_state->num_bufs; j++) {
-			if (j == 0) {
-				dma_unmap_single(tx->dev,
-					dma_unmap_addr(cur_state, dma[j]),
-					dma_unmap_len(cur_state, len[j]),
-					DMA_TO_DEVICE);
-			} else {
-				dma_unmap_page(tx->dev,
-					dma_unmap_addr(cur_state, dma[j]),
-					dma_unmap_len(cur_state, len[j]),
-					DMA_TO_DEVICE);
-			}
-		}
+		if (tx->dqo.qpl)
+			gve_free_tx_qpl_bufs(tx, cur_state);
+		else
+			gve_unmap_packet(tx->dev, cur_state);
+
 		if (cur_state->skb) {
 			dev_consume_skb_any(cur_state->skb);
 			cur_state->skb = NULL;
@@ -992,21 +1001,6 @@ static void remove_from_list(struct gve_
 	}
 }
 
-static void gve_unmap_packet(struct device *dev,
-			     struct gve_tx_pending_packet_dqo *pkt)
-{
-	int i;
-
-	/* SKB linear portion is guaranteed to be mapped */
-	dma_unmap_single(dev, dma_unmap_addr(pkt, dma[0]),
-			 dma_unmap_len(pkt, len[0]), DMA_TO_DEVICE);
-	for (i = 1; i < pkt->num_bufs; i++) {
-		dma_unmap_page(dev, dma_unmap_addr(pkt, dma[i]),
-			       dma_unmap_len(pkt, len[i]), DMA_TO_DEVICE);
-	}
-	pkt->num_bufs = 0;
-}
-
 /* Completion types and expected behavior:
  * No Miss compl + Packet compl = Packet completed normally.
  * Miss compl + Re-inject compl = Packet completed normally.


