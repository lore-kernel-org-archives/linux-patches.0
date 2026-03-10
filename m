Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1DC2BF3E2;
	Tue, 10 Mar 2026 11:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141135; cv=none; b=bXbIpeFSkqJa4lvJFgJphLfkdp7DN4IBDbf4v/sqmdo/kHKbV374BglT2EQS1WrLsvhiHielma8waY9T857ML4PskvyEB/le/6cDYMFtsXrgC4Szp9Pb+g4hCiGspqehO6NXWSBHZfF8W0uExoAh8LwHeHW3pdJmgnkkYzbvRgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141135; c=relaxed/simple;
	bh=K1DoMOf/DfsVhVjHwDBdmSXOE9D0WfWdGWvLsiDIPa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DwkeuTVI3rCeQetX5tBGOFqwW3/2eZvQ/j3/zLJM1c5SC2TaVvZ0b8t/GRs1Qw1O7ZHMOtL2CBb6beavFt6AocVPuiBUg7J2eEM1JOw3/U8Tz62SmexjVP4IaBx6EPWcqVH5hsSsazRV3zO/lPKPFj0sFMvw1dRqSfL7GzVq7eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qM2w2aPO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qM2w2aPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09DCC2BC86;
	Tue, 10 Mar 2026 11:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141134;
	bh=K1DoMOf/DfsVhVjHwDBdmSXOE9D0WfWdGWvLsiDIPa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qM2w2aPO/Tayji96agFldSvQ1E5v3ajYqhqoePplxO/OnyO1aDyMwzEasHCIWl67x
	 xWKdLF1zLemMLXVcCmzsZr0X6VsaBqYA58FCw2syIA3KevKna2//qoJihtP6XqiIm9
	 N+bP8Fhqs5k1HdS77mTwXvC9MT3d/zwILb0H0M8pao/VhIiIgCAgOfAJ7eaHzTRzXx
	 nmIf+7GyRcYbTM3zi42c5ix9pKHWIKYXIa/TlwwP9e1StFcMYtxWEL7p8aFZhu1zNZ
	 V662XgZACshAPJkycxiQNNkfXdxKqPt7uuBSTC6sZpy6aV//OZgka3x7jsYK95n39W
	 YTNOHt+xdTDYw==
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
Subject: [PATCH 6.19 138/311] gve: fix incorrect buffer cleanup in gve_tx_clean_pending_packets for QPL
Date: Tue, 10 Mar 2026 07:03:05 -0400
Message-ID: <6a646a8367c6dd6a2f9fa604ce6da897947c99e7.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index 40b89b3e5a318..e5e3396645862 100644
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
@@ -1160,22 +1170,6 @@ static void remove_from_list(struct gve_tx_ring *tx,
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

