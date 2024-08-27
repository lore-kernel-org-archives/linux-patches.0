Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1D91A08A3;
	Tue, 27 Aug 2024 14:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770548; cv=none; b=JvCqQ6l36hkTmEqcMreb33YH0x0zkk//5300Rznypdao1YHHMmhSY4+qpeu4XRxi4XoPWuNHzu4nvHUOhnKw4xwo8bC41FNA4yv70qMyWflOzcU18OpCzrZ7VDIDh+a9K+6IUEjqk0ab9s3YJbpi/onR4VQFJDI6rUPJQKCRaZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770548; c=relaxed/simple;
	bh=PzZr4QpYEN/tZIh7BuzZozoCPSfMqd4wN79pCJfhFWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftyB9e7xcA1vesIApArtxfxZXvz37of5U1uYYIbZvtUnST9Ta+ugJhdgRN9mOQcxpU+neqB2iJ8vsEi36Jg0Ot9qVXhHyoqM1d228HitquGQARHR7X9MKFRiMuth0Yqyd5xMRX1K8blPx7dFNkSGAcue345JnE2lJibe9ruqyd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i1DMn3T5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i1DMn3T5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58220C4E699;
	Tue, 27 Aug 2024 14:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770548;
	bh=PzZr4QpYEN/tZIh7BuzZozoCPSfMqd4wN79pCJfhFWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i1DMn3T5tg8YRzA9qA/in4P6iR5Rx41N1akxobyOEUTr1LKEVngZD9WqoFK/R/1Zx
	 3xgRCTwHbryXaW5/Ymjnh1XuN4+cM/TOmbCgWt0m5Sp92PFbjZD3l0l8yL6QEd6fy7
	 SuhniCq6RYYNQy7vt8pzkZpawe/kemU9/mTiXmcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 6.6 262/341] ice: fix truesize operations for PAGE_SIZE >= 8192
Date: Tue, 27 Aug 2024 16:38:13 +0200
Message-ID: <20240827143853.377110301@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit d53d4dcce69be5773e2d0878c9899ebfbf58c393 ]

When working on multi-buffer packet on arch that has PAGE_SIZE >= 8192,
truesize is calculated and stored in xdp_buff::frame_sz per each
processed Rx buffer. This means that frame_sz will contain the truesize
based on last received buffer, but commit 1dc1a7e7f410 ("ice:
Centrallize Rx buffer recycling") assumed this value will be constant
for each buffer, which breaks the page recycling scheme and mess up the
way we update the page::page_offset.

To fix this, let us work on constant truesize when PAGE_SIZE >= 8192
instead of basing this on size of a packet read from Rx descriptor. This
way we can simplify the code and avoid calculating truesize per each
received frame and on top of that when using
xdp_update_skb_shared_info(), current formula for truesize update will
be valid.

This means ice_rx_frame_truesize() can be removed altogether.
Furthermore, first call to it within ice_clean_rx_irq() for 4k PAGE_SIZE
was redundant as xdp_buff::frame_sz is initialized via xdp_init_buff()
in ice_vsi_cfg_rxq(). This should have been removed at the point where
xdp_buff struct started to be a member of ice_rx_ring and it was no
longer a stack based variable.

There are two fixes tags as my understanding is that the first one
exposed us to broken truesize and page_offset handling and then second
introduced broken skb_shared_info update in ice_{construct,build}_skb().

Reported-and-tested-by: Luiz Capitulino <luizcap@redhat.com>
Closes: https://lore.kernel.org/netdev/8f9e2a5c-fd30-4206-9311-946a06d031bb@redhat.com/
Fixes: 1dc1a7e7f410 ("ice: Centrallize Rx buffer recycling")
Fixes: 2fba7dc5157b ("ice: Add support for XDP multi-buffer on Rx side")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_base.c | 21 ++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_txrx.c | 33 -----------------------
 2 files changed, 20 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 4f3e65b47cdc3..9a0682b05c4ff 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -519,6 +519,25 @@ static int ice_setup_rx_ctx(struct ice_rx_ring *ring)
 	return 0;
 }
 
+/**
+ * ice_get_frame_sz - calculate xdp_buff::frame_sz
+ * @rx_ring: the ring being configured
+ *
+ * Return frame size based on underlying PAGE_SIZE
+ */
+static unsigned int ice_get_frame_sz(struct ice_rx_ring *rx_ring)
+{
+	unsigned int frame_sz;
+
+#if (PAGE_SIZE >= 8192)
+	frame_sz = rx_ring->rx_buf_len;
+#else
+	frame_sz = ice_rx_pg_size(rx_ring) / 2;
+#endif
+
+	return frame_sz;
+}
+
 /**
  * ice_vsi_cfg_rxq - Configure an Rx queue
  * @ring: the ring being configured
@@ -582,7 +601,7 @@ int ice_vsi_cfg_rxq(struct ice_rx_ring *ring)
 		}
 	}
 
-	xdp_init_buff(&ring->xdp, ice_rx_pg_size(ring) / 2, &ring->xdp_rxq);
+	xdp_init_buff(&ring->xdp, ice_get_frame_sz(ring), &ring->xdp_rxq);
 	ring->xdp.data = NULL;
 	err = ice_setup_rx_ctx(ring);
 	if (err) {
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 55faa8384bcfe..429afffa4c316 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -521,30 +521,6 @@ int ice_setup_rx_ring(struct ice_rx_ring *rx_ring)
 	return -ENOMEM;
 }
 
-/**
- * ice_rx_frame_truesize
- * @rx_ring: ptr to Rx ring
- * @size: size
- *
- * calculate the truesize with taking into the account PAGE_SIZE of
- * underlying arch
- */
-static unsigned int
-ice_rx_frame_truesize(struct ice_rx_ring *rx_ring, const unsigned int size)
-{
-	unsigned int truesize;
-
-#if (PAGE_SIZE < 8192)
-	truesize = ice_rx_pg_size(rx_ring) / 2; /* Must be power-of-2 */
-#else
-	truesize = rx_ring->rx_offset ?
-		SKB_DATA_ALIGN(rx_ring->rx_offset + size) +
-		SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) :
-		SKB_DATA_ALIGN(size);
-#endif
-	return truesize;
-}
-
 /**
  * ice_run_xdp - Executes an XDP program on initialized xdp_buff
  * @rx_ring: Rx ring
@@ -1152,11 +1128,6 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 	bool failure;
 	u32 first;
 
-	/* Frame size depend on rx_ring setup when PAGE_SIZE=4K */
-#if (PAGE_SIZE < 8192)
-	xdp->frame_sz = ice_rx_frame_truesize(rx_ring, 0);
-#endif
-
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 	if (xdp_prog) {
 		xdp_ring = rx_ring->xdp_ring;
@@ -1216,10 +1187,6 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 			hard_start = page_address(rx_buf->page) + rx_buf->page_offset -
 				     offset;
 			xdp_prepare_buff(xdp, hard_start, offset, size, !!offset);
-#if (PAGE_SIZE > 4096)
-			/* At larger PAGE_SIZE, frame_sz depend on len size */
-			xdp->frame_sz = ice_rx_frame_truesize(rx_ring, size);
-#endif
 			xdp_buff_clear_frags_flag(xdp);
 		} else if (ice_add_xdp_frag(rx_ring, xdp, rx_buf, size)) {
 			break;
-- 
2.43.0



