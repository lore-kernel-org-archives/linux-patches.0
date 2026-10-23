Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774297;
	b=OuM82cWBDDSPZpxkZLUVH5ZAOeqV4XxlYyKWxIZJ3P8Yl+mjw9J12nWYI6Q89cCGoCQs
	 J1s0tR/ZO5HVV77J6WAf3e40BYDvR9Od6oSPuE9XS2kBotTvQrXPzZVtaU85swVAKbZuD
	 2SC4t+YyP19Sjk+oKc3+TBWSnNpryOE3L9wiE9pX0EveN8zhQHqYBuiVHQdVhuoA5l1ng
	 XkWcq/W4lzAWJQ95QDqSS8CDtTJQHmTCe3KsyqS+yA+dfSFPyweO6bzqp7IjtHpkpLw4U
	 4CY0GxE8pC3TFMDEkmgXYoECoqChnGRC2TZDMgFWLzzetZYH4xxobCXyJr0VOMgEEVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5kDajDk0Y2V0iyBvmcZsDjNcxWJ4NIvjcmfY+f43R3s=;
	b=eS7FhF4YyrH2P5BKERn+CdVttVc5PeGRSkVGiBcqXclBo6hXoVGJakcQnImhiU+O85x3
	 4r+eKIgKHXXtMVRnqmerSN/+JX5bTo3vuShrwzAO+2XRkSyTC5Pdk2sZ6mW5UmS8a8S5M
	 4oQrsJuxHkLM+LECPlsqH1XXimRanOrMCYdaAzg8PMLNWq518cQ38IkfW9VbiPm6yDtWA
	 gV04wRs6mVONSKTJ5SSzgoQGmsimMIsBpomEV0r7v/62xVSQoCl+xFfR8d42hJchodYbS
	 j5O3jlNPj5GKj7QdeH+DsOTEDZRYx2+ba8AXFkw0Qc7LDeGwHdmHV9Ww9PTfqiW3B8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IWhwx4xO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B927606A31A;
	Fri, 23 Oct 2026 16:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IWhwx4xO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9610D1F01825;
	Fri, 23 Oct 2026 16:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774297;
	bh=5kDajDk0Y2V0iyBvmcZsDjNcxWJ4NIvjcmfY+f43R3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IWhwx4xOagLvr8fU5DQge8qW1d1bkuL3pickm39OfHDB5qVlYDZVXGMBpyZ1lybzN
	 wgFlTOI8OjIvPtv7ghuZlOYxip6tV5E4NUIrwI0x9weoCq0GkrNccatNG1MulrQwCV
	 Eob54r0djos4w+ntn5SgM1IDv2bz9ZgeBLSSf7zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Alexander Nowlin <alexander.nowlin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.18 188/193] ice: remove legacy Rx and construct SKB
Date: Fri, 23 Oct 2026 18:37:45 +0200
Message-ID: <20261023163718.665897529@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Kubiak <michal.kubiak@intel.com>

commit 9e314a3c525c91c1e918546f472585cdbd44fbd1 upstream.

The commit 53844673d555 ("iavf: kill 'legacy-rx' for good") removed
the legacy Rx path in the iavf driver. This change applies the same
rationale to the ice driver.

The legacy Rx path relied on manual skb allocation and header copying,
which has become increasingly inefficient and difficult to maintain.
With the stabilization of build_skb() and the growing adoption of
features like XDP, page_pool, and multi-buffer support, the legacy
approach is no longer viable.

Key drawbacks of the legacy path included:
- Higher memory pressure due to direct page allocations and splitting;
- Redundant memcpy() operations for packet headers;
- CPU overhead from eth_get_headlen() and Flow Dissector usage;
- Compatibility issues with XDP, which imposes strict headroom and
  tailroom requirements.

The ice driver, like iavf, does not benefit from the minimal headroom
savings that legacy Rx once offered, as it already splits pages into
fixed halves. Removing this path simplifies the Rx logic, eliminates
unnecessary branches in the hotpath, and prepares the driver for
upcoming enhancements.

In addition to removing the legacy Rx path, this change also eliminates
the custom construct_skb() functions from both the standard and
zero-copy (ZC) Rx paths. These are replaced with the build_skb()
and standardized xdp_build_skb_from_zc() helpers, aligning the driver
with the modern XDP infrastructure and reducing code duplication.

This cleanup also reduces code complexity and improves maintainability
as we move toward a more unified and modern Rx model across drivers.

Co-developed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Michal Kubiak <michal.kubiak@intel.com>
Tested-by: Alexander Nowlin <alexander.nowlin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice.h         |    1 
 drivers/net/ethernet/intel/ice/ice_base.c    |   23 -------
 drivers/net/ethernet/intel/ice/ice_ethtool.c |    5 -
 drivers/net/ethernet/intel/ice/ice_main.c    |   11 ---
 drivers/net/ethernet/intel/ice/ice_txrx.c    |   86 ---------------------------
 drivers/net/ethernet/intel/ice/ice_txrx.h    |   16 -----
 drivers/net/ethernet/intel/ice/ice_xsk.c     |   72 ----------------------
 7 files changed, 6 insertions(+), 208 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -509,7 +509,6 @@ enum ice_pf_flags {
 	ICE_FLAG_MOD_POWER_UNSUPPORTED,
 	ICE_FLAG_PHY_FW_LOAD_FAILED,
 	ICE_FLAG_ETHTOOL_CTXT,		/* set when ethtool holds RTNL lock */
-	ICE_FLAG_LEGACY_RX,
 	ICE_FLAG_VF_TRUE_PROMISC_ENA,
 	ICE_FLAG_MDD_AUTO_RESET_VF,
 	ICE_FLAG_VF_VLAN_PRUNING,
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -462,19 +462,6 @@ u16 ice_calc_ts_ring_count(struct ice_tx
 }
 
 /**
- * ice_rx_offset - Return expected offset into page to access data
- * @rx_ring: Ring we are requesting offset of
- *
- * Returns the offset value for ring into the data buffer.
- */
-static unsigned int ice_rx_offset(struct ice_rx_ring *rx_ring)
-{
-	if (ice_ring_uses_build_skb(rx_ring))
-		return ICE_SKB_PAD;
-	return 0;
-}
-
-/**
  * ice_setup_rx_ctx - Configure a receive ring context
  * @ring: The Rx ring to configure
  *
@@ -586,13 +573,7 @@ static int ice_setup_rx_ctx(struct ice_r
 	if (vsi->type == ICE_VSI_VF)
 		return 0;
 
-	/* configure Rx buffer alignment */
-	if (!vsi->netdev || test_bit(ICE_FLAG_LEGACY_RX, vsi->back->flags))
-		ice_clear_ring_build_skb_ena(ring);
-	else
-		ice_set_ring_build_skb_ena(ring);
-
-	ring->rx_offset = ice_rx_offset(ring);
+	ring->rx_offset = ICE_SKB_PAD;
 
 	/* init queue specific tail register */
 	ring->tail = hw->hw_addr + QRX_TAIL(pf_q);
@@ -753,7 +734,7 @@ int ice_vsi_cfg_single_rxq(struct ice_vs
  */
 static void ice_vsi_cfg_frame_size(struct ice_vsi *vsi, struct ice_rx_ring *ring)
 {
-	if (!vsi->netdev || test_bit(ICE_FLAG_LEGACY_RX, vsi->back->flags)) {
+	if (!vsi->netdev) {
 		ring->max_frame = ICE_MAX_FRAME_LEGACY_RX;
 		ring->rx_buf_len = ICE_RXBUF_1664;
 #if (PAGE_SIZE < 8192)
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -340,7 +340,6 @@ static const struct ice_priv_flag ice_gs
 		      ICE_FLAG_VF_TRUE_PROMISC_ENA),
 	ICE_PRIV_FLAG("mdd-auto-reset-vf", ICE_FLAG_MDD_AUTO_RESET_VF),
 	ICE_PRIV_FLAG("vf-vlan-pruning", ICE_FLAG_VF_VLAN_PRUNING),
-	ICE_PRIV_FLAG("legacy-rx", ICE_FLAG_LEGACY_RX),
 };
 
 #define ICE_PRIV_FLAG_ARRAY_SIZE	ARRAY_SIZE(ice_gstrings_priv_flags)
@@ -1848,10 +1847,6 @@ static int ice_set_priv_flags(struct net
 			ice_nway_reset(netdev);
 		}
 	}
-	if (test_bit(ICE_FLAG_LEGACY_RX, change_flags)) {
-		/* down and up VSI so that changes of Rx cfg are reflected. */
-		ice_down_up(vsi);
-	}
 	/* don't allow modification of this flag when a single VF is in
 	 * promiscuous mode because it's not supported
 	 */
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2957,10 +2957,7 @@ int ice_vsi_determine_xdp_res(struct ice
  */
 static int ice_max_xdp_frame_size(struct ice_vsi *vsi)
 {
-	if (test_bit(ICE_FLAG_LEGACY_RX, vsi->back->flags))
-		return ICE_RXBUF_1664;
-	else
-		return ICE_RXBUF_3072;
+	return ICE_RXBUF_3072;
 }
 
 /**
@@ -7879,12 +7876,6 @@ int ice_change_mtu(struct net_device *ne
 				   frame_size - ICE_ETH_PKT_HDR_PAD);
 			return -EINVAL;
 		}
-	} else if (test_bit(ICE_FLAG_LEGACY_RX, pf->flags)) {
-		if (new_mtu + ICE_ETH_PKT_HDR_PAD > ICE_MAX_FRAME_LEGACY_RX) {
-			netdev_err(netdev, "Too big MTU for legacy-rx; Max is %d\n",
-				   ICE_MAX_FRAME_LEGACY_RX - ICE_ETH_PKT_HDR_PAD);
-			return -EINVAL;
-		}
 	}
 
 	/* if a reset is in progress, wait for some time for it to complete */
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1171,87 +1171,6 @@ ice_build_skb(struct ice_rx_ring *rx_rin
 }
 
 /**
- * ice_construct_skb - Allocate skb and populate it
- * @rx_ring: Rx descriptor ring to transact packets on
- * @xdp: xdp_buff pointing to the data
- *
- * This function allocates an skb. It then populates it with the page
- * data from the current receive descriptor, taking care to set up the
- * skb correctly.
- */
-static struct sk_buff *
-ice_construct_skb(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp)
-{
-	unsigned int size = xdp->data_end - xdp->data;
-	struct skb_shared_info *sinfo = NULL;
-	struct ice_rx_buf *rx_buf;
-	unsigned int nr_frags = 0;
-	unsigned int headlen;
-	struct sk_buff *skb;
-
-	/* prefetch first cache line of first page */
-	net_prefetch(xdp->data);
-
-	if (unlikely(xdp_buff_has_frags(xdp))) {
-		sinfo = xdp_get_shared_info_from_buff(xdp);
-		nr_frags = sinfo->nr_frags;
-	}
-
-	/* allocate a skb to store the frags */
-	skb = napi_alloc_skb(&rx_ring->q_vector->napi, ICE_RX_HDR_SIZE);
-	if (unlikely(!skb))
-		return NULL;
-
-	rx_buf = &rx_ring->rx_buf[rx_ring->first_desc];
-	skb_record_rx_queue(skb, rx_ring->q_index);
-	/* Determine available headroom for copy */
-	headlen = size;
-	if (headlen > ICE_RX_HDR_SIZE)
-		headlen = eth_get_headlen(skb->dev, xdp->data, ICE_RX_HDR_SIZE);
-
-	/* align pull length to size of long to optimize memcpy performance */
-	memcpy(__skb_put(skb, headlen), xdp->data, ALIGN(headlen,
-							 sizeof(long)));
-
-	/* if we exhaust the linear part then add what is left as a frag */
-	size -= headlen;
-	if (size) {
-		/* besides adding here a partial frag, we are going to add
-		 * frags from xdp_buff, make sure there is enough space for
-		 * them
-		 */
-		if (unlikely(nr_frags >= MAX_SKB_FRAGS - 1)) {
-			dev_kfree_skb(skb);
-			return NULL;
-		}
-		skb_add_rx_frag(skb, 0, rx_buf->page,
-				rx_buf->page_offset + headlen, size,
-				xdp->frame_sz);
-	} else {
-		/* buffer is unused, restore biased page count in Rx buffer;
-		 * data was copied onto skb's linear part so there's no
-		 * need for adjusting page offset and we can reuse this buffer
-		 * as-is
-		 */
-		rx_buf->pagecnt_bias++;
-	}
-
-	if (unlikely(xdp_buff_has_frags(xdp))) {
-		struct skb_shared_info *skinfo = skb_shinfo(skb);
-
-		memcpy(&skinfo->frags[skinfo->nr_frags], &sinfo->frags[0],
-		       sizeof(skb_frag_t) * nr_frags);
-
-		xdp_update_skb_frags_info(skb, skinfo->nr_frags + nr_frags,
-					  sinfo->xdp_frags_size,
-					  nr_frags * xdp->frame_sz,
-					  xdp_buff_get_skb_flags(xdp));
-	}
-
-	return skb;
-}
-
-/**
  * ice_put_rx_buf - Clean up used buffer and either recycle or free
  * @rx_ring: Rx descriptor ring to transact packets on
  * @rx_buf: Rx buffer to pull data from
@@ -1465,10 +1384,7 @@ static int ice_clean_rx_irq(struct ice_r
 
 		continue;
 construct_skb:
-		if (likely(ice_ring_uses_build_skb(rx_ring)))
-			skb = ice_build_skb(rx_ring, xdp);
-		else
-			skb = ice_construct_skb(rx_ring, xdp);
+		skb = ice_build_skb(rx_ring, xdp);
 		/* exit if we failed to retrieve a buffer */
 		if (!skb) {
 			rx_ring->ring_stats->rx_stats.alloc_buf_failed++;
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -381,7 +381,6 @@ struct ice_rx_ring {
 	dma_addr_t dma;			/* physical address of ring */
 	u8 dcb_tc;			/* Traffic class of ring */
 	u8 ptp_rx;
-#define ICE_RX_FLAGS_RING_BUILD_SKB	BIT(1)
 #define ICE_RX_FLAGS_CRC_STRIP_DIS	BIT(2)
 #define ICE_RX_FLAGS_MULTIDEV		BIT(3)
 #define ICE_RX_FLAGS_RING_GCS		BIT(4)
@@ -439,21 +438,6 @@ struct ice_tx_ring {
 	__cacheline_group_end_aligned(cold);
 } ____cacheline_internodealigned_in_smp;
 
-static inline bool ice_ring_uses_build_skb(struct ice_rx_ring *ring)
-{
-	return !!(ring->flags & ICE_RX_FLAGS_RING_BUILD_SKB);
-}
-
-static inline void ice_set_ring_build_skb_ena(struct ice_rx_ring *ring)
-{
-	ring->flags |= ICE_RX_FLAGS_RING_BUILD_SKB;
-}
-
-static inline void ice_clear_ring_build_skb_ena(struct ice_rx_ring *ring)
-{
-	ring->flags &= ~ICE_RX_FLAGS_RING_BUILD_SKB;
-}
-
 static inline bool ice_ring_ch_enabled(struct ice_tx_ring *ring)
 {
 	return !!ring->ch;
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -393,69 +393,6 @@ bool ice_alloc_rx_bufs_zc(struct ice_rx_
 }
 
 /**
- * ice_construct_skb_zc - Create an sk_buff from zero-copy buffer
- * @rx_ring: Rx ring
- * @xdp: Pointer to XDP buffer
- *
- * This function allocates a new skb from a zero-copy Rx buffer.
- *
- * Returns the skb on success, NULL on failure.
- */
-static struct sk_buff *
-ice_construct_skb_zc(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp)
-{
-	unsigned int totalsize = xdp->data_end - xdp->data_meta;
-	unsigned int metasize = xdp->data - xdp->data_meta;
-	struct skb_shared_info *sinfo = NULL;
-	struct sk_buff *skb;
-	u32 nr_frags = 0;
-
-	if (unlikely(xdp_buff_has_frags(xdp))) {
-		sinfo = xdp_get_shared_info_from_buff(xdp);
-		nr_frags = sinfo->nr_frags;
-	}
-	net_prefetch(xdp->data_meta);
-
-	skb = napi_alloc_skb(&rx_ring->q_vector->napi, totalsize);
-	if (unlikely(!skb))
-		return NULL;
-
-	memcpy(__skb_put(skb, totalsize), xdp->data_meta,
-	       ALIGN(totalsize, sizeof(long)));
-
-	if (metasize) {
-		skb_metadata_set(skb, metasize);
-		__skb_pull(skb, metasize);
-	}
-
-	if (likely(!xdp_buff_has_frags(xdp)))
-		goto out;
-
-	for (int i = 0; i < nr_frags; i++) {
-		struct skb_shared_info *skinfo = skb_shinfo(skb);
-		skb_frag_t *frag = &sinfo->frags[i];
-		struct page *page;
-		void *addr;
-
-		page = dev_alloc_page();
-		if (!page) {
-			dev_kfree_skb(skb);
-			return NULL;
-		}
-		addr = page_to_virt(page);
-
-		memcpy(addr, skb_frag_page(frag), skb_frag_size(frag));
-
-		__skb_fill_page_desc_noacc(skinfo, skinfo->nr_frags++,
-					   addr, 0, skb_frag_size(frag));
-	}
-
-out:
-	xsk_buff_free(xdp);
-	return skb;
-}
-
-/**
  * ice_clean_xdp_irq_zc - produce AF_XDP descriptors to CQ
  * @xdp_ring: XDP Tx ring
  * @xsk_pool: AF_XDP buffer pool pointer
@@ -757,20 +694,15 @@ int ice_clean_rx_irq_zc(struct ice_rx_ri
 
 construct_skb:
 		/* XDP_PASS path */
-		skb = ice_construct_skb_zc(rx_ring, first);
+		skb = xdp_build_skb_from_zc(first);
 		if (!skb) {
+			xsk_buff_free(first);
 			rx_ring->ring_stats->rx_stats.alloc_buf_failed++;
 			break;
 		}
 
 		first = NULL;
 		rx_ring->first_desc = ntc;
-
-		if (eth_skb_pad(skb)) {
-			skb = NULL;
-			continue;
-		}
-
 		total_rx_bytes += skb->len;
 		total_rx_packets++;
 


