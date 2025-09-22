Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF32222590;
	Mon, 22 Sep 2025 19:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570163; cv=none; b=lCE3sndKVe/T6kDVR/lbbwY8aO+/Oiwy4SXN9vNHztjIqE4gCf5Vxd5qWAYupCsb4JWt+xE2dpNIwGyxFvkpwZOWv3yjQNf/fchyoiTEufPCGecVz1O6HRcS1lvSFw6Fhh1cXR3gBGCD9ns2bsvj4TbZ07W2kLXPlTKmjFIm39Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570163; c=relaxed/simple;
	bh=YewC1B/Go7mJD3nPx5k3r/TV714Jj2M/TV+dB5O+AXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXxk3fT72sNj+c2D7tgnLj3yYfRvaHO8qDgOTuiZlRqaqvumrxOiDjJD7IYu1C9IOmzNyMGvQ6sRu9mfFKE+Q6p4nFyb7Sai0Y17IW7V6KpIYu7C00WsajCxraMm/4U2lzTkjTw1RljdJcsFLMPGk73HA/JT9pgaKQ+eOC7SwOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1CvQywXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1CvQywXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045E0C4CEF0;
	Mon, 22 Sep 2025 19:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570163;
	bh=YewC1B/Go7mJD3nPx5k3r/TV714Jj2M/TV+dB5O+AXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1CvQywXhPaddd59l0d+CWVHVL8gmH+axK+98fQ9z4F+0H5bmcMp9APhu7Ih2gFmaG
	 zID41z+hFLHZpRvtQ2ABPYFclqj2T/AAqqrrqHpoTmSiOJPgM/Xc7cNgC1+9egRgHf
	 7GR1YVeWiBXQMXdRCwEacxJnBLZ+jJj59B4Kzehc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Petrausch <christoph.petrausch@deepl.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Priya Singh <priyax.singh@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.16 030/149] ice: fix Rx page leak on multi-buffer frames
Date: Mon, 22 Sep 2025 21:28:50 +0200
Message-ID: <20250922192413.625052669@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 84bf1ac85af84d354c7a2fdbdc0d4efc8aaec34b ]

The ice_put_rx_mbuf() function handles calling ice_put_rx_buf() for each
buffer in the current frame. This function was introduced as part of
handling multi-buffer XDP support in the ice driver.

It works by iterating over the buffers from first_desc up to 1 plus the
total number of fragments in the frame, cached from before the XDP program
was executed.

If the hardware posts a descriptor with a size of 0, the logic used in
ice_put_rx_mbuf() breaks. Such descriptors get skipped and don't get added
as fragments in ice_add_xdp_frag. Since the buffer isn't counted as a
fragment, we do not iterate over it in ice_put_rx_mbuf(), and thus we don't
call ice_put_rx_buf().

Because we don't call ice_put_rx_buf(), we don't attempt to re-use the
page or free it. This leaves a stale page in the ring, as we don't
increment next_to_alloc.

The ice_reuse_rx_page() assumes that the next_to_alloc has been incremented
properly, and that it always points to a buffer with a NULL page. Since
this function doesn't check, it will happily recycle a page over the top
of the next_to_alloc buffer, losing track of the old page.

Note that this leak only occurs for multi-buffer frames. The
ice_put_rx_mbuf() function always handles at least one buffer, so a
single-buffer frame will always get handled correctly. It is not clear
precisely why the hardware hands us descriptors with a size of 0 sometimes,
but it happens somewhat regularly with "jumbo frames" used by 9K MTU.

To fix ice_put_rx_mbuf(), we need to make sure to call ice_put_rx_buf() on
all buffers between first_desc and next_to_clean. Borrow the logic of a
similar function in i40e used for this same purpose. Use the same logic
also in ice_get_pgcnts().

Instead of iterating over just the number of fragments, use a loop which
iterates until the current index reaches to the next_to_clean element just
past the current frame. Unlike i40e, the ice_put_rx_mbuf() function does
call ice_put_rx_buf() on the last buffer of the frame indicating the end of
packet.

For non-linear (multi-buffer) frames, we need to take care when adjusting
the pagecnt_bias. An XDP program might release fragments from the tail of
the frame, in which case that fragment page is already released. Only
update the pagecnt_bias for the first descriptor and fragments still
remaining post-XDP program. Take care to only access the shared info for
fragmented buffers, as this avoids a significant cache miss.

The xdp_xmit value only needs to be updated if an XDP program is run, and
only once per packet. Drop the xdp_xmit pointer argument from
ice_put_rx_mbuf(). Instead, set xdp_xmit in the ice_clean_rx_irq() function
directly. This avoids needing to pass the argument and avoids an extra
bit-wise OR for each buffer in the frame.

Move the increment of the ntc local variable to ensure its updated *before*
all calls to ice_get_pgcnts() or ice_put_rx_mbuf(), as the loop logic
requires the index of the element just after the current frame.

Now that we use an index pointer in the ring to identify the packet, we no
longer need to track or cache the number of fragments in the rx_ring.

Cc: Christoph Petrausch <christoph.petrausch@deepl.com>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Reported-by: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Closes: https://lore.kernel.org/netdev/CAK8fFZ4hY6GUJNENz3wY9jaYLZXGfpr7dnZxzGMYoE44caRbgw@mail.gmail.com/
Fixes: 743bbd93cf29 ("ice: put Rx buffers after being done with current frame")
Tested-by: Michal Kubiak <michal.kubiak@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>
Tested-by: Priya Singh <priyax.singh@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 80 ++++++++++-------------
 drivers/net/ethernet/intel/ice/ice_txrx.h |  1 -
 2 files changed, 34 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index c50cf3ad190e9..4766597ac5550 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -865,10 +865,6 @@ ice_add_xdp_frag(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
 	__skb_fill_page_desc_noacc(sinfo, sinfo->nr_frags++, rx_buf->page,
 				   rx_buf->page_offset, size);
 	sinfo->xdp_frags_size += size;
-	/* remember frag count before XDP prog execution; bpf_xdp_adjust_tail()
-	 * can pop off frags but driver has to handle it on its own
-	 */
-	rx_ring->nr_frags = sinfo->nr_frags;
 
 	if (page_is_pfmemalloc(rx_buf->page))
 		xdp_buff_set_frag_pfmemalloc(xdp);
@@ -939,20 +935,20 @@ ice_get_rx_buf(struct ice_rx_ring *rx_ring, const unsigned int size,
 /**
  * ice_get_pgcnts - grab page_count() for gathered fragments
  * @rx_ring: Rx descriptor ring to store the page counts on
+ * @ntc: the next to clean element (not included in this frame!)
  *
  * This function is intended to be called right before running XDP
  * program so that the page recycling mechanism will be able to take
  * a correct decision regarding underlying pages; this is done in such
  * way as XDP program can change the refcount of page
  */
-static void ice_get_pgcnts(struct ice_rx_ring *rx_ring)
+static void ice_get_pgcnts(struct ice_rx_ring *rx_ring, unsigned int ntc)
 {
-	u32 nr_frags = rx_ring->nr_frags + 1;
 	u32 idx = rx_ring->first_desc;
 	struct ice_rx_buf *rx_buf;
 	u32 cnt = rx_ring->count;
 
-	for (int i = 0; i < nr_frags; i++) {
+	while (idx != ntc) {
 		rx_buf = &rx_ring->rx_buf[idx];
 		rx_buf->pgcnt = page_count(rx_buf->page);
 
@@ -1125,62 +1121,51 @@ ice_put_rx_buf(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf)
 }
 
 /**
- * ice_put_rx_mbuf - ice_put_rx_buf() caller, for all frame frags
+ * ice_put_rx_mbuf - ice_put_rx_buf() caller, for all buffers in frame
  * @rx_ring: Rx ring with all the auxiliary data
  * @xdp: XDP buffer carrying linear + frags part
- * @xdp_xmit: XDP_TX/XDP_REDIRECT verdict storage
- * @ntc: a current next_to_clean value to be stored at rx_ring
+ * @ntc: the next to clean element (not included in this frame!)
  * @verdict: return code from XDP program execution
  *
- * Walk through gathered fragments and satisfy internal page
- * recycle mechanism; we take here an action related to verdict
- * returned by XDP program;
+ * Called after XDP program is completed, or on error with verdict set to
+ * ICE_XDP_CONSUMED.
+ *
+ * Walk through buffers from first_desc to the end of the frame, releasing
+ * buffers and satisfying internal page recycle mechanism. The action depends
+ * on verdict from XDP program.
  */
 static void ice_put_rx_mbuf(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
-			    u32 *xdp_xmit, u32 ntc, u32 verdict)
+			    u32 ntc, u32 verdict)
 {
-	u32 nr_frags = rx_ring->nr_frags + 1;
 	u32 idx = rx_ring->first_desc;
 	u32 cnt = rx_ring->count;
-	u32 post_xdp_frags = 1;
 	struct ice_rx_buf *buf;
-	int i;
+	u32 xdp_frags = 0;
+	int i = 0;
 
 	if (unlikely(xdp_buff_has_frags(xdp)))
-		post_xdp_frags += xdp_get_shared_info_from_buff(xdp)->nr_frags;
+		xdp_frags = xdp_get_shared_info_from_buff(xdp)->nr_frags;
 
-	for (i = 0; i < post_xdp_frags; i++) {
+	while (idx != ntc) {
 		buf = &rx_ring->rx_buf[idx];
+		if (++idx == cnt)
+			idx = 0;
 
-		if (verdict & (ICE_XDP_TX | ICE_XDP_REDIR)) {
+		/* An XDP program could release fragments from the end of the
+		 * buffer. For these, we need to keep the pagecnt_bias as-is.
+		 * To do this, only adjust pagecnt_bias for fragments up to
+		 * the total remaining after the XDP program has run.
+		 */
+		if (verdict != ICE_XDP_CONSUMED)
 			ice_rx_buf_adjust_pg_offset(buf, xdp->frame_sz);
-			*xdp_xmit |= verdict;
-		} else if (verdict & ICE_XDP_CONSUMED) {
+		else if (i++ <= xdp_frags)
 			buf->pagecnt_bias++;
-		} else if (verdict == ICE_XDP_PASS) {
-			ice_rx_buf_adjust_pg_offset(buf, xdp->frame_sz);
-		}
 
 		ice_put_rx_buf(rx_ring, buf);
-
-		if (++idx == cnt)
-			idx = 0;
-	}
-	/* handle buffers that represented frags released by XDP prog;
-	 * for these we keep pagecnt_bias as-is; refcount from struct page
-	 * has been decremented within XDP prog and we do not have to increase
-	 * the biased refcnt
-	 */
-	for (; i < nr_frags; i++) {
-		buf = &rx_ring->rx_buf[idx];
-		ice_put_rx_buf(rx_ring, buf);
-		if (++idx == cnt)
-			idx = 0;
 	}
 
 	xdp->data = NULL;
 	rx_ring->first_desc = ntc;
-	rx_ring->nr_frags = 0;
 }
 
 /**
@@ -1260,6 +1245,10 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		/* retrieve a buffer from the ring */
 		rx_buf = ice_get_rx_buf(rx_ring, size, ntc);
 
+		/* Increment ntc before calls to ice_put_rx_mbuf() */
+		if (++ntc == cnt)
+			ntc = 0;
+
 		if (!xdp->data) {
 			void *hard_start;
 
@@ -1268,24 +1257,23 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 			xdp_prepare_buff(xdp, hard_start, offset, size, !!offset);
 			xdp_buff_clear_frags_flag(xdp);
 		} else if (ice_add_xdp_frag(rx_ring, xdp, rx_buf, size)) {
-			ice_put_rx_mbuf(rx_ring, xdp, NULL, ntc, ICE_XDP_CONSUMED);
+			ice_put_rx_mbuf(rx_ring, xdp, ntc, ICE_XDP_CONSUMED);
 			break;
 		}
-		if (++ntc == cnt)
-			ntc = 0;
 
 		/* skip if it is NOP desc */
 		if (ice_is_non_eop(rx_ring, rx_desc))
 			continue;
 
-		ice_get_pgcnts(rx_ring);
+		ice_get_pgcnts(rx_ring, ntc);
 		xdp_verdict = ice_run_xdp(rx_ring, xdp, xdp_prog, xdp_ring, rx_desc);
 		if (xdp_verdict == ICE_XDP_PASS)
 			goto construct_skb;
 		total_rx_bytes += xdp_get_buff_len(xdp);
 		total_rx_pkts++;
 
-		ice_put_rx_mbuf(rx_ring, xdp, &xdp_xmit, ntc, xdp_verdict);
+		ice_put_rx_mbuf(rx_ring, xdp, ntc, xdp_verdict);
+		xdp_xmit |= xdp_verdict & (ICE_XDP_TX | ICE_XDP_REDIR);
 
 		continue;
 construct_skb:
@@ -1298,7 +1286,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 			rx_ring->ring_stats->rx_stats.alloc_buf_failed++;
 			xdp_verdict = ICE_XDP_CONSUMED;
 		}
-		ice_put_rx_mbuf(rx_ring, xdp, &xdp_xmit, ntc, xdp_verdict);
+		ice_put_rx_mbuf(rx_ring, xdp, ntc, xdp_verdict);
 
 		if (!skb)
 			break;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index a4b1e95146327..07155e615f75a 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -358,7 +358,6 @@ struct ice_rx_ring {
 	struct ice_tx_ring *xdp_ring;
 	struct ice_rx_ring *next;	/* pointer to next ring in q_vector */
 	struct xsk_buff_pool *xsk_pool;
-	u32 nr_frags;
 	u16 max_frame;
 	u16 rx_buf_len;
 	dma_addr_t dma;			/* physical address of ring */
-- 
2.51.0



