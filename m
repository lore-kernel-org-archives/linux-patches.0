Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7D574046;
	Mon, 29 Jan 2024 17:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548568; cv=none; b=pSnqC9hbggFPndX7iNJbPv1AcD+AP+P4R5nfHwtgokkeoSDAiCGcxhEVMcpTJj2mNR3aIxYX9J3M+V0mqHudmYO6BtfshGd77IiN8/JdWfjmRrGLy/qT7RtDzUy+yhzQwvPmmjjRuSzE3bUkbLCvHlOq17mcYEhp2dKH30ka2dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548568; c=relaxed/simple;
	bh=OFVitt8zd7r5sZ6fiJ/BlhfYgEYDFRpx40BV0WkGL84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGeb9AyfU3xmKhPdQ2CobZDqLlnxC/sWleoeuXRvaXel+cJyddqQzrdlV2Fv1NYjnhSotyM3sxtxHRganewKq7Uk6GaqZOBQlwzfM53Uo3/M6EnuYiYrLc5BwV76ki5sabhxc/TZF5dNAN0oCaiLFVuTk8DpFp/JBQbGJS2lbL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HFsz9E0b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HFsz9E0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAB3C43394;
	Mon, 29 Jan 2024 17:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548568;
	bh=OFVitt8zd7r5sZ6fiJ/BlhfYgEYDFRpx40BV0WkGL84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HFsz9E0bTpq35+7hL7fcxVOaNw6SGzM4wO29xwmURm0RgIjmjxPfKNE0FTN2lCvAP
	 p4IukfkI/rr+7ZB3rrfsDcKT9UShqxUQNJUfUXtWXHeqwmi6Ij+kPglefvSMfkN9Xx
	 XR20XMGHFy3SD98HJi0Y8YWfuh4bDyni/wGteGEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 217/331] ice: work on pre-XDP prog frag count
Date: Mon, 29 Jan 2024 09:04:41 -0800
Message-ID: <20240129170021.224346859@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

[ Upstream commit ad2047cf5d9313200e308612aed516548873d124 ]

Fix an OOM panic in XDP_DRV mode when a XDP program shrinks a
multi-buffer packet by 4k bytes and then redirects it to an AF_XDP
socket.

Since support for handling multi-buffer frames was added to XDP, usage
of bpf_xdp_adjust_tail() helper within XDP program can free the page
that given fragment occupies and in turn decrease the fragment count
within skb_shared_info that is embedded in xdp_buff struct. In current
ice driver codebase, it can become problematic when page recycling logic
decides not to reuse the page. In such case, __page_frag_cache_drain()
is used with ice_rx_buf::pagecnt_bias that was not adjusted after
refcount of page was changed by XDP prog which in turn does not drain
the refcount to 0 and page is never freed.

To address this, let us store the count of frags before the XDP program
was executed on Rx ring struct. This will be used to compare with
current frag count from skb_shared_info embedded in xdp_buff. A smaller
value in the latter indicates that XDP prog freed frag(s). Then, for
given delta decrement pagecnt_bias for XDP_DROP verdict.

While at it, let us also handle the EOP frag within
ice_set_rx_bufs_act() to make our life easier, so all of the adjustments
needed to be applied against freed frags are performed in the single
place.

Fixes: 2fba7dc5157b ("ice: Add support for XDP multi-buffer on Rx side")
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/r/20240124191602.566724-5-maciej.fijalkowski@intel.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 14 ++++++---
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  1 +
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h | 31 +++++++++++++------
 3 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 52d0a126eb61..5b0f9e53f6b4 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -600,9 +600,7 @@ ice_run_xdp(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
 		ret = ICE_XDP_CONSUMED;
 	}
 exit:
-	rx_buf->act = ret;
-	if (unlikely(xdp_buff_has_frags(xdp)))
-		ice_set_rx_bufs_act(xdp, rx_ring, ret);
+	ice_set_rx_bufs_act(xdp, rx_ring, ret);
 }
 
 /**
@@ -890,14 +888,17 @@ ice_add_xdp_frag(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
 	}
 
 	if (unlikely(sinfo->nr_frags == MAX_SKB_FRAGS)) {
-		if (unlikely(xdp_buff_has_frags(xdp)))
-			ice_set_rx_bufs_act(xdp, rx_ring, ICE_XDP_CONSUMED);
+		ice_set_rx_bufs_act(xdp, rx_ring, ICE_XDP_CONSUMED);
 		return -ENOMEM;
 	}
 
 	__skb_fill_page_desc_noacc(sinfo, sinfo->nr_frags++, rx_buf->page,
 				   rx_buf->page_offset, size);
 	sinfo->xdp_frags_size += size;
+	/* remember frag count before XDP prog execution; bpf_xdp_adjust_tail()
+	 * can pop off frags but driver has to handle it on its own
+	 */
+	rx_ring->nr_frags = sinfo->nr_frags;
 
 	if (page_is_pfmemalloc(rx_buf->page))
 		xdp_buff_set_frag_pfmemalloc(xdp);
@@ -1249,6 +1250,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 
 		xdp->data = NULL;
 		rx_ring->first_desc = ntc;
+		rx_ring->nr_frags = 0;
 		continue;
 construct_skb:
 		if (likely(ice_ring_uses_build_skb(rx_ring)))
@@ -1264,10 +1266,12 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 						    ICE_XDP_CONSUMED);
 			xdp->data = NULL;
 			rx_ring->first_desc = ntc;
+			rx_ring->nr_frags = 0;
 			break;
 		}
 		xdp->data = NULL;
 		rx_ring->first_desc = ntc;
+		rx_ring->nr_frags = 0;
 
 		stat_err_bits = BIT(ICE_RX_FLEX_DESC_STATUS0_RXE_S);
 		if (unlikely(ice_test_staterr(rx_desc->wb.status_error0,
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 166413fc33f4..407d4c320097 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -333,6 +333,7 @@ struct ice_rx_ring {
 	struct ice_channel *ch;
 	struct ice_tx_ring *xdp_ring;
 	struct xsk_buff_pool *xsk_pool;
+	u32 nr_frags;
 	dma_addr_t dma;			/* physical address of ring */
 	u64 cached_phctime;
 	u16 rx_buf_len;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
index 115969ecdf7b..b0e56675f98b 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
@@ -12,26 +12,39 @@
  * act: action to store onto Rx buffers related to XDP buffer parts
  *
  * Set action that should be taken before putting Rx buffer from first frag
- * to one before last. Last one is handled by caller of this function as it
- * is the EOP frag that is currently being processed. This function is
- * supposed to be called only when XDP buffer contains frags.
+ * to the last.
  */
 static inline void
 ice_set_rx_bufs_act(struct xdp_buff *xdp, const struct ice_rx_ring *rx_ring,
 		    const unsigned int act)
 {
-	const struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
-	u32 first = rx_ring->first_desc;
-	u32 nr_frags = sinfo->nr_frags;
+	u32 sinfo_frags = xdp_get_shared_info_from_buff(xdp)->nr_frags;
+	u32 nr_frags = rx_ring->nr_frags + 1;
+	u32 idx = rx_ring->first_desc;
 	u32 cnt = rx_ring->count;
 	struct ice_rx_buf *buf;
 
 	for (int i = 0; i < nr_frags; i++) {
-		buf = &rx_ring->rx_buf[first];
+		buf = &rx_ring->rx_buf[idx];
 		buf->act = act;
 
-		if (++first == cnt)
-			first = 0;
+		if (++idx == cnt)
+			idx = 0;
+	}
+
+	/* adjust pagecnt_bias on frags freed by XDP prog */
+	if (sinfo_frags < rx_ring->nr_frags && act == ICE_XDP_CONSUMED) {
+		u32 delta = rx_ring->nr_frags - sinfo_frags;
+
+		while (delta) {
+			if (idx == 0)
+				idx = cnt - 1;
+			else
+				idx--;
+			buf = &rx_ring->rx_buf[idx];
+			buf->pagecnt_bias--;
+			delta--;
+		}
 	}
 }
 
-- 
2.43.0



