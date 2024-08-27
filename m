Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE2A1CF2BA;
	Tue, 27 Aug 2024 15:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772635; cv=none; b=kQsdlRkDIeLsbonyycKywMn2mMrDCXsTf+TQbhzXxvUYwBvSx2baNzApb3NAf0Fv3Fuap5SZyfK/TAszy5/V88WVJqrAOVKu+iACmPiZssNp3WUqK+P9lIXLJ5OVnNMYxGho+MUojTcyOxv7yS6oX7PDubwkQ4i34uCN2J7SzPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772635; c=relaxed/simple;
	bh=TvHFdtvaDt/NyRog8g8mC00ozCLxP1uWAMYOP4Kde7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYGtG8xAxhSkgj/nUJsYZGjfhPOgICNKyz6OqF7uFL/uxD3uytTubx3fauLDEOSfBTUef5TBkpn3UyilfC6IhWTpP0sLSBpOXW8ZxjE+TQJHbdsad8z+EtNNMw4jiOSduLHEXpZflRHw5hNpnQLmp+SIVrnzQgBYZRiKldWim3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pPfQ2I0x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pPfQ2I0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66657C4AF66;
	Tue, 27 Aug 2024 15:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772634;
	bh=TvHFdtvaDt/NyRog8g8mC00ozCLxP1uWAMYOP4Kde7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pPfQ2I0xxQTtaPBfN+pht/ervf0fZtt957NJez5TLH/IF3ti0aX28+zVuX2D0fMJ/
	 AOkbstSfYQcXl4XhhWNtWBzCLCG9YSRcHtMlitxhUkWuuY3RH0ZsEcd/NuEhAKnVnp
	 OLhiSFCXmp3UiMGz1QWf+UPtquLecAuAQaq098ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexander Lobakin <alexandr.lobakin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 242/321] ice: Prepare legacy-rx for upcoming XDP multi-buffer support
Date: Tue, 27 Aug 2024 16:39:10 +0200
Message-ID: <20240827143847.452510961@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit c61bcebde72de7f5dc194d28f29894f0f7661ff7 ]

Rx path is going to be modified in a way that fragmented frame will be
gathered within xdp_buff in the first place. This approach implies that
underlying buffer has to provide tailroom for skb_shared_info. This is
currently the case when ring uses build_skb but not when legacy-rx knob
is turned on. This case configures 2k Rx buffers and has no way to
provide either headroom or tailroom - FWIW it currently has
XDP_PACKET_HEADROOM which is broken and in here it is removed. 2k Rx
buffers were used so driver in this setting was able to support 9k MTU
as it can chain up to 5 Rx buffers. With offset configuring HW writing
2k of a data was passing the half of the page which broke the assumption
of our internal page recycling tricks.

Now if above got fixed and legacy-rx path would be left as is, when
referring to skb_shared_info via xdp_get_shared_info_from_buff(),
packet's content would be corrupted again. Hence size of Rx buffer needs
to be lowered and therefore supported MTU. This operation will allow us
to keep the unified data path and with 8k MTU users (if any of
legacy-rx) would still be good to go. However, tendency is to drop the
support for this code path at some point.

Add ICE_RXBUF_1664 as vsi::rx_buf_len and ICE_MAX_FRAME_LEGACY_RX (8320)
as vsi::max_frame for legacy-rx. For bigger page sizes configure 3k Rx
buffers, not 2k.

Since headroom support is removed, disable data_meta support on legacy-rx.
When preparing XDP buff, rely on ice_rx_ring::rx_offset setting when
deciding whether to support data_meta or not.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Link: https://lore.kernel.org/bpf/20230131204506.219292-2-maciej.fijalkowski@intel.com
Stable-dep-of: 50b2143356e8 ("ice: fix page reuse when PAGE_SIZE is over 8k")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_base.c |  3 ---
 drivers/net/ethernet/intel/ice/ice_lib.c  |  8 ++------
 drivers/net/ethernet/intel/ice/ice_main.c | 10 ++++++++--
 drivers/net/ethernet/intel/ice/ice_txrx.c | 17 +++++------------
 drivers/net/ethernet/intel/ice/ice_txrx.h |  2 ++
 5 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 818eca6aa4a41..c7c6f01538e0d 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -355,9 +355,6 @@ static unsigned int ice_rx_offset(struct ice_rx_ring *rx_ring)
 {
 	if (ice_ring_uses_build_skb(rx_ring))
 		return ICE_SKB_PAD;
-	else if (ice_is_xdp_ena_vsi(rx_ring->vsi))
-		return XDP_PACKET_HEADROOM;
-
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 7661e735d0992..347c6c23bfc1c 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1818,8 +1818,8 @@ void ice_update_eth_stats(struct ice_vsi *vsi)
 void ice_vsi_cfg_frame_size(struct ice_vsi *vsi)
 {
 	if (!vsi->netdev || test_bit(ICE_FLAG_LEGACY_RX, vsi->back->flags)) {
-		vsi->max_frame = ICE_AQ_SET_MAC_FRAME_SIZE_MAX;
-		vsi->rx_buf_len = ICE_RXBUF_2048;
+		vsi->max_frame = ICE_MAX_FRAME_LEGACY_RX;
+		vsi->rx_buf_len = ICE_RXBUF_1664;
 #if (PAGE_SIZE < 8192)
 	} else if (!ICE_2K_TOO_SMALL_WITH_PADDING &&
 		   (vsi->netdev->mtu <= ETH_DATA_LEN)) {
@@ -1828,11 +1828,7 @@ void ice_vsi_cfg_frame_size(struct ice_vsi *vsi)
 #endif
 	} else {
 		vsi->max_frame = ICE_AQ_SET_MAC_FRAME_SIZE_MAX;
-#if (PAGE_SIZE < 8192)
 		vsi->rx_buf_len = ICE_RXBUF_3072;
-#else
-		vsi->rx_buf_len = ICE_RXBUF_2048;
-#endif
 	}
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 6e55861dd86fe..9dbfbc90485e4 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -7328,8 +7328,8 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
  */
 static int ice_max_xdp_frame_size(struct ice_vsi *vsi)
 {
-	if (PAGE_SIZE >= 8192 || test_bit(ICE_FLAG_LEGACY_RX, vsi->back->flags))
-		return ICE_RXBUF_2048 - XDP_PACKET_HEADROOM;
+	if (test_bit(ICE_FLAG_LEGACY_RX, vsi->back->flags))
+		return ICE_RXBUF_1664;
 	else
 		return ICE_RXBUF_3072;
 }
@@ -7362,6 +7362,12 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 				   frame_size - ICE_ETH_PKT_HDR_PAD);
 			return -EINVAL;
 		}
+	} else if (test_bit(ICE_FLAG_LEGACY_RX, pf->flags)) {
+		if (new_mtu + ICE_ETH_PKT_HDR_PAD > ICE_MAX_FRAME_LEGACY_RX) {
+			netdev_err(netdev, "Too big MTU for legacy-rx; Max is %d\n",
+				   ICE_MAX_FRAME_LEGACY_RX - ICE_ETH_PKT_HDR_PAD);
+			return -EINVAL;
+		}
 	}
 
 	/* if a reset is in progress, wait for some time for it to complete */
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index bd62781191b3d..2db20263420d8 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -984,17 +984,15 @@ static struct sk_buff *
 ice_construct_skb(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
 		  struct xdp_buff *xdp)
 {
-	unsigned int metasize = xdp->data - xdp->data_meta;
 	unsigned int size = xdp->data_end - xdp->data;
 	unsigned int headlen;
 	struct sk_buff *skb;
 
 	/* prefetch first cache line of first page */
-	net_prefetch(xdp->data_meta);
+	net_prefetch(xdp->data);
 
 	/* allocate a skb to store the frags */
-	skb = __napi_alloc_skb(&rx_ring->q_vector->napi,
-			       ICE_RX_HDR_SIZE + metasize,
+	skb = __napi_alloc_skb(&rx_ring->q_vector->napi, ICE_RX_HDR_SIZE,
 			       GFP_ATOMIC | __GFP_NOWARN);
 	if (unlikely(!skb))
 		return NULL;
@@ -1006,13 +1004,8 @@ ice_construct_skb(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
 		headlen = eth_get_headlen(skb->dev, xdp->data, ICE_RX_HDR_SIZE);
 
 	/* align pull length to size of long to optimize memcpy performance */
-	memcpy(__skb_put(skb, headlen + metasize), xdp->data_meta,
-	       ALIGN(headlen + metasize, sizeof(long)));
-
-	if (metasize) {
-		skb_metadata_set(skb, metasize);
-		__skb_pull(skb, metasize);
-	}
+	memcpy(__skb_put(skb, headlen), xdp->data, ALIGN(headlen,
+							 sizeof(long)));
 
 	/* if we exhaust the linear part then add what is left as a frag */
 	size -= headlen;
@@ -1187,7 +1180,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 
 		hard_start = page_address(rx_buf->page) + rx_buf->page_offset -
 			     offset;
-		xdp_prepare_buff(&xdp, hard_start, offset, size, true);
+		xdp_prepare_buff(&xdp, hard_start, offset, size, !!offset);
 #if (PAGE_SIZE > 4096)
 		/* At larger PAGE_SIZE, frame_sz depend on len size */
 		xdp.frame_sz = ice_rx_frame_truesize(rx_ring, size);
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 932b5661ec4d6..bfbe4b16df96a 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -9,10 +9,12 @@
 #define ICE_DFLT_IRQ_WORK	256
 #define ICE_RXBUF_3072		3072
 #define ICE_RXBUF_2048		2048
+#define ICE_RXBUF_1664		1664
 #define ICE_RXBUF_1536		1536
 #define ICE_MAX_CHAINED_RX_BUFS	5
 #define ICE_MAX_BUF_TXD		8
 #define ICE_MIN_TX_LEN		17
+#define ICE_MAX_FRAME_LEGACY_RX 8320
 
 /* The size limit for a transmit buffer in a descriptor is (16K - 1).
  * In order to align with the read requests we will align the value to
-- 
2.43.0



