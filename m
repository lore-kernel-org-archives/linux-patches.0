Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57F2332EC5;
	Wed, 23 Sep 2026 14:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174730; cv=none; b=fhNuLHR6Ii2fj7LTzvPkVoHdaeOhgFX+19A5LzQij3D1VfjBgatjooHvOjlU/pZboFQbBqYjsYIK7gecbHu2taGmwjvDa3WAN54DFaV0RadAag0Aclci3fHTsp1tKqVeNWvCJTnP/ASCEMbTLecq08UcftVmo/1DkNoktGrfKYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174730; c=relaxed/simple;
	bh=awuMRYXC43pH6V06nsRXSKujysumPA5ymQUAC7YXW8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UtS5T8qrBGYLR3XSUb+L70N4/tkpoiYrS8u+WM7AdPzhdiTe28mWxchooHQeGR+eONc17MuhkGE9BmH1NZu//v8fpYaI7pD+zzflymJH/vhRat5psp4HDW4SkREjjMFi0zYSC80j2OzyaLtRh3WWbiMvTh1f7a6w89g261xQEyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mpqN2GYc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpqN2GYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2639F1F000FF;
	Wed, 23 Sep 2026 14:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174728;
	bh=xAd59GTp3dCGdSJuYY3q6+a3B70MeOIjVuKXr7R6aYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mpqN2GYcBt8p/1Qjdm65jwwn2btfhR3nqiH4OVXgJJUR43kuzMeqV+EqeejD16oh0
	 +zu4IinBOFgOMla2H4BCsuQVLTMUnAGZxNeyem09Oe82XkM78pGxTN5RRTTQWALGTK
	 oX/HRH00zFBjIOmsoxjOG6bB+CsQb6saoOSnez5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 176/398] eth: fbnic: ring the doorbell if a burst ends in a drop
Date: Wed, 23 Sep 2026 16:04:10 +0200
Message-ID: <20260923140647.993637736@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
Message-ID: <20260923140410.64C7hh_IbVW7colTLL9DodBMYwBJ3w139Sk7gVprgVg@z>

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 490599ab23134962a6d18a024e84541d77bdb999 ]

fbnic_tx_map() skips the doorbell write, and the completion request,
for every packet handed to it with xmit_more set, counting on the
packet which ends the burst to publish them all. When that packet is
dropped instead - skb_put_padto(), skb_cow_head() or a DMA mapping
failure - nothing rings. The descriptors of the preceding packets stay
invisible to the HW until the next transmit on that queue, which for a
burst-then-idle workload may never come.

Remember the meta descriptor of the last packet left without a doorbell
and flush it from the error paths. The completion request has to be set
on that descriptor rather than simply writing the tail, otherwise the HW
would transmit the packets but never report a head, and the ring would
fill up and stall for good.

This is very similar to Joe's recent series of fixes for bnxt.
Not seen in real life, reproduced under QEMU with failure injection.

Fixes: 9a57bacd574b ("eth: fbnic: Add basic Tx handling")
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260915022327.913218-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c | 42 +++++++++++++++-----
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.h |  9 ++++-
 2 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
index dbe0855ecb575..0ea861ff40f56 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
@@ -311,6 +311,29 @@ fbnic_rx_csum(u64 rcd, struct sk_buff *skb, struct fbnic_ring *rcq,
 	}
 }
 
+static void fbnic_tx_doorbell(struct fbnic_ring *ring, __le64 *meta)
+{
+	*meta |= cpu_to_le64(FBNIC_TWD_FLAG_REQ_COMPLETION);
+	ring->deferred_meta = -1;
+
+	/* Force DMA writes to flush before writing to tail */
+	dma_wmb();
+
+	writel(ring->tail, ring->doorbell);
+}
+
+/* Packets handed to us with xmit_more set are left in the ring without a
+ * doorbell, and without a completion request, in the expectation that the
+ * packet ending the burst will ring for all of them. If that packet gets
+ * dropped instead we have to ring here, otherwise the descriptors sit in
+ * the ring until the next transmit, which may never come.
+ */
+static void fbnic_tx_flush_doorbell(struct fbnic_ring *ring)
+{
+	if (ring->deferred_meta >= 0)
+		fbnic_tx_doorbell(ring, &ring->desc[ring->deferred_meta]);
+}
+
 static bool
 fbnic_tx_map(struct fbnic_ring *ring, struct sk_buff *skb, __le64 *meta)
 {
@@ -378,14 +401,10 @@ fbnic_tx_map(struct fbnic_ring *ring, struct sk_buff *skb, __le64 *meta)
 	/* Verify there is room for another packet */
 	fbnic_maybe_stop_tx(skb->dev, ring, FBNIC_MAX_SKB_DESC);
 
-	if (fbnic_tx_sent_queue(skb, ring)) {
-		*meta |= cpu_to_le64(FBNIC_TWD_FLAG_REQ_COMPLETION);
-
-		/* Force DMA writes to flush before writing to tail */
-		dma_wmb();
-
-		writel(tail, ring->doorbell);
-	}
+	if (fbnic_tx_sent_queue(skb, ring))
+		fbnic_tx_doorbell(ring, meta);
+	else
+		ring->deferred_meta = meta - ring->desc;
 
 	return false;
 dma_error:
@@ -425,8 +444,10 @@ fbnic_xmit_frame_ring(struct sk_buff *skb, struct fbnic_ring *ring)
 	 * otherwise try next time
 	 */
 	desc_needed = skb_shinfo(skb)->nr_frags + 10;
-	if (fbnic_maybe_stop_tx(skb->dev, ring, desc_needed))
+	if (fbnic_maybe_stop_tx(skb->dev, ring, desc_needed)) {
+		fbnic_tx_flush_doorbell(ring);
 		return NETDEV_TX_BUSY;
+	}
 
 	*meta = cpu_to_le64(FBNIC_TWD_FLAG_DEST_MAC);
 
@@ -447,6 +468,8 @@ fbnic_xmit_frame_ring(struct sk_buff *skb, struct fbnic_ring *ring)
 err_free:
 	dev_kfree_skb_any(skb);
 err_count:
+	fbnic_tx_flush_doorbell(ring);
+
 	u64_stats_update_begin(&ring->stats.syncp);
 	ring->stats.dropped++;
 	u64_stats_update_end(&ring->stats.syncp);
@@ -2473,6 +2496,7 @@ static void fbnic_enable_twq0(struct fbnic_ring *twq)
 	fbnic_ring_wr32(twq, FBNIC_QUEUE_TWQ0_CTL, FBNIC_QUEUE_TWQ_CTL_RESET);
 	twq->tail = 0;
 	twq->head = 0;
+	twq->deferred_meta = -1;
 
 	/* Store descriptor ring address and size */
 	fbnic_ring_wr32(twq, FBNIC_QUEUE_TWQ0_BAL, lower_32_bits(twq->dma));
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.h b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.h
index f2ee2cbf3486b..643e7d3ddb543 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.h
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.h
@@ -128,9 +128,14 @@ struct fbnic_ring {
 		/* Rx BDQs only */
 		struct page_pool *page_pool;
 
-		/* Deferred_head is used to cache the head for TWQ1 if
+		/* TWQ0 only, index of the meta descriptor of the last packet
+		 * placed in the ring without ringing the doorbell, -1 if the
+		 * doorbell is in sync with the tail.
+		 */
+		s32 deferred_meta;
+
+		/* TCQ only, used to cache the head for TWQ1 if
 		 * an attempt is made to clean TWQ1 with zero napi_budget.
-		 * We do not use it for any other ring.
 		 */
 		s32 deferred_head;
 	};
-- 
2.53.0



