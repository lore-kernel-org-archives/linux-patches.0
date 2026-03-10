Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7C740F8D9;
	Tue, 10 Mar 2026 11:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142040; cv=none; b=GSFmfABEdulTcGxtS5gbDrobhEUSXZRIC9vdyOAGv9t+o+nJG17jPwp+MMpvjqJPRiJywnUH9t3zL7k36zuuFNs57vtqIVeM/+QZXJ72ry0s/fE5cwNSZtVXThJw5jJLB7lImpcHtVlOBBz6eTTEK29KG3frJP/vJis6BmSec5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142040; c=relaxed/simple;
	bh=k5Y6lPwYHgmE+bA9OFCUZtQ16ZcNpl8Xh396Ybl9ImY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KxfgVR8w49Qd0NYndlsD+AcWIBmKCkxl9hE9VwQ3bVjiCfl/T1KwGQaIHF7rOtnAUSIa86npWqM/FroIwSLF6WF3MZ0BTFaTjhsi6ygeMZRdMmxFXThsY57nWX5ShP9XJkNpxsykVkOxhzmVO3g7EexdobZHW4H5p+WDI2cKQfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PImlTzNS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PImlTzNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28B6C19423;
	Tue, 10 Mar 2026 11:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142039;
	bh=k5Y6lPwYHgmE+bA9OFCUZtQ16ZcNpl8Xh396Ybl9ImY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PImlTzNS//lmyW2640RLbItlhsPi6xFLLwf58N+4gpwkcTDS7AFBjhPq31Ubwg9q5
	 WaF/g6yCbJfVzsPXJrc20ohmqhElmGJir9fsHV6QOgXyPlSz0HcPIP/7fO0lEUiNFT
	 zsd4Z1oXP3xU/Nsq3IIegjK8D+aTlBjDFRBxYqWktJWR9xV0h8ecxjK0+1gnEO8oSn
	 Sudx7sLqt/m/Mu50Dbc1SK9uBZon9uoBdJGtu6idBQ+D9FpAnTJA4cTx9B+gXelUA9
	 xgAu7nXYz5GjoxKqUwj6bQl60b5NIwdVxZrJsucsFkdhF5WY+REi5nlGMHicVpX0Uv
	 52D4xZYdVIHrQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ankit Garg <nktgrg@google.com>,
	Jordan Rhee <jordanrhee@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Joshua Washington <joshwash@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 167/314] gve: fix incorrect buffer cleanup in gve_tx_clean_pending_packets for QPL
Date: Tue, 10 Mar 2026 07:17:06 -0400
Message-ID: <12af9ac46b3e6da8ae0d47a553a1e877eea4dd7c.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ankit Garg <nktgrg@google.com>

commit fb868db5f4bccd7a78219313ab2917429f715cea upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_tx_dqo.c | 56 +++++++++-----------
 1 file changed, 25 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
index 6f1d515673d25..5fbee184f0e7a 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -167,6 +167,25 @@ gve_free_pending_packet(struct gve_tx_ring *tx,
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
+		netmem_dma_unmap_page_attrs(dev, dma_unmap_addr(pkt, dma[i]),
+					    dma_unmap_len(pkt, len[i]),
+					    DMA_TO_DEVICE, 0);
+	}
+	pkt->num_bufs = 0;
+}
+
 /* gve_tx_free_desc - Cleans up all pending tx requests and buffers.
  */
 static void gve_tx_clean_pending_packets(struct gve_tx_ring *tx)
@@ -176,21 +195,12 @@ static void gve_tx_clean_pending_packets(struct gve_tx_ring *tx)
 	for (i = 0; i < tx->dqo.num_pending_packets; i++) {
 		struct gve_tx_pending_packet_dqo *cur_state =
 			&tx->dqo.pending_packets[i];
-		int j;
-
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
+
+		if (tx->dqo.qpl)
+			gve_free_tx_qpl_bufs(tx, cur_state);
+		else
+			gve_unmap_packet(tx->dev, cur_state);
+
 		if (cur_state->skb) {
 			dev_consume_skb_any(cur_state->skb);
 			cur_state->skb = NULL;
@@ -1158,22 +1168,6 @@ static void remove_from_list(struct gve_tx_ring *tx,
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
-		netmem_dma_unmap_page_attrs(dev, dma_unmap_addr(pkt, dma[i]),
-					    dma_unmap_len(pkt, len[i]),
-					    DMA_TO_DEVICE, 0);
-	}
-	pkt->num_bufs = 0;
-}
-
 /* Completion types and expected behavior:
  * No Miss compl + Packet compl = Packet completed normally.
  * Miss compl + Re-inject compl = Packet completed normally.
-- 
2.51.0

