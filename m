Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D471D174F;
	Tue, 27 Aug 2024 15:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772534; cv=none; b=oD89OWb0+7xyEYIyD1RXe0BJjRN1+aXFWjpdv8KIeDC9mnrAxAQJ5AYl8G9Y1wMP4FYH7wop+LxHET/LnhpX4kKims6/qmPkwXA6ytvsihcmMFlvQvzb+yVBnyBNIgP4mdY6qEkIyIsdTkV9cGH7pq2rmo94Z/KZKbDyRwbf8H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772534; c=relaxed/simple;
	bh=DpYKXuT/db6wa5Uv9kPyESmTcQNpOVemY3rJ5mJnDIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CO9HZcoGlBbT8OKvORDI4NcIRowpvkdrCE/BJYa5elmv4Hf2AZvG+9KyQbs0j1x/LutAvC2eRA+SEfsZDCsofMsKSWSx15i0OYpIAH/7RMn1nSLSbt9+EVGM4+XtrgpsMTHcp/dtV5AXAwn0/S9XPalZLp51OFWCg5pchM/drWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dSQWUVxf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dSQWUVxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02583C6107E;
	Tue, 27 Aug 2024 15:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772533;
	bh=DpYKXuT/db6wa5Uv9kPyESmTcQNpOVemY3rJ5mJnDIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dSQWUVxf09OY5PPQ3ZM4kJxyWAu6/AmfC7loJf3QKNLSwW+Klzstn+JxGBWOagJyD
	 VqK0g4ULTphQdqgNuMu8pnkgt7YC8MD5fKuR7uBqqDqi+PXvc/oFEWnGHqcDaKgbOJ
	 4TnwJQmEIyCFnJaHKAnplsZAyymo4+++dZDE0Wg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexander Lobakin <alexandr.lobakin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 244/321] ice: Store page count inside ice_rx_buf
Date: Tue, 27 Aug 2024 16:39:12 +0200
Message-ID: <20240827143847.530999329@linuxfoundation.org>
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

[ Upstream commit ac0753391195011ded23696d7882428e5c419a98 ]

This will allow us to avoid carrying additional auxiliary array of page
counts when dealing with XDP multi buffer support. Previously combining
fragmented frame to skb was not affected in the same way as XDP would be
as whole frame is needed to be in place before executing XDP prog.
Therefore, when going through HW Rx descriptors one-by-one, calls to
ice_put_rx_buf() need to be taken *after* running XDP prog on a
potentially multi buffered frame, so some additional storage of
page count is needed.

By adding page count to rx buf, it will make it easier to walk through
processed entries at the end of rx cleaning routine and decide whether
or not buffers should be recycled.

While at it, bump ice_rx_buf::pagecnt_bias from u16 up to u32. It was
proven many times that calculations on variables smaller than standard
register size are harmful. This was also the case during experiments
with embedding page count to ice_rx_buf - when this was added as u16 it
had a performance impact.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Link: https://lore.kernel.org/bpf/20230131204506.219292-4-maciej.fijalkowski@intel.com
Stable-dep-of: 50b2143356e8 ("ice: fix page reuse when PAGE_SIZE is over 8k")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 26 +++++++++--------------
 drivers/net/ethernet/intel/ice/ice_txrx.h |  3 ++-
 2 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index d3411170f3eaf..977b268802dfa 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -791,7 +791,6 @@ ice_rx_buf_adjust_pg_offset(struct ice_rx_buf *rx_buf, unsigned int size)
 /**
  * ice_can_reuse_rx_page - Determine if page can be reused for another Rx
  * @rx_buf: buffer containing the page
- * @rx_buf_pgcnt: rx_buf page refcount pre xdp_do_redirect() call
  *
  * If page is reusable, we have a green light for calling ice_reuse_rx_page,
  * which will assign the current buffer to the buffer that next_to_alloc is
@@ -799,7 +798,7 @@ ice_rx_buf_adjust_pg_offset(struct ice_rx_buf *rx_buf, unsigned int size)
  * page freed
  */
 static bool
-ice_can_reuse_rx_page(struct ice_rx_buf *rx_buf, int rx_buf_pgcnt)
+ice_can_reuse_rx_page(struct ice_rx_buf *rx_buf)
 {
 	unsigned int pagecnt_bias = rx_buf->pagecnt_bias;
 	struct page *page = rx_buf->page;
@@ -810,7 +809,7 @@ ice_can_reuse_rx_page(struct ice_rx_buf *rx_buf, int rx_buf_pgcnt)
 
 #if (PAGE_SIZE < 8192)
 	/* if we are only owner of page we can reuse it */
-	if (unlikely((rx_buf_pgcnt - pagecnt_bias) > 1))
+	if (unlikely(rx_buf->pgcnt - pagecnt_bias > 1))
 		return false;
 #else
 #define ICE_LAST_OFFSET \
@@ -894,19 +893,17 @@ ice_reuse_rx_page(struct ice_rx_ring *rx_ring, struct ice_rx_buf *old_buf)
  * ice_get_rx_buf - Fetch Rx buffer and synchronize data for use
  * @rx_ring: Rx descriptor ring to transact packets on
  * @size: size of buffer to add to skb
- * @rx_buf_pgcnt: rx_buf page refcount
  *
  * This function will pull an Rx buffer from the ring and synchronize it
  * for use by the CPU.
  */
 static struct ice_rx_buf *
-ice_get_rx_buf(struct ice_rx_ring *rx_ring, const unsigned int size,
-	       int *rx_buf_pgcnt)
+ice_get_rx_buf(struct ice_rx_ring *rx_ring, const unsigned int size)
 {
 	struct ice_rx_buf *rx_buf;
 
 	rx_buf = &rx_ring->rx_buf[rx_ring->next_to_clean];
-	*rx_buf_pgcnt =
+	rx_buf->pgcnt =
 #if (PAGE_SIZE < 8192)
 		page_count(rx_buf->page);
 #else
@@ -1042,15 +1039,13 @@ ice_construct_skb(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
  * ice_put_rx_buf - Clean up used buffer and either recycle or free
  * @rx_ring: Rx descriptor ring to transact packets on
  * @rx_buf: Rx buffer to pull data from
- * @rx_buf_pgcnt: Rx buffer page count pre xdp_do_redirect()
  *
  * This function will update next_to_clean and then clean up the contents
  * of the rx_buf. It will either recycle the buffer or unmap it and free
  * the associated resources.
  */
 static void
-ice_put_rx_buf(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
-	       int rx_buf_pgcnt)
+ice_put_rx_buf(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf)
 {
 	u16 ntc = rx_ring->next_to_clean + 1;
 
@@ -1061,7 +1056,7 @@ ice_put_rx_buf(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
 	if (!rx_buf)
 		return;
 
-	if (ice_can_reuse_rx_page(rx_buf, rx_buf_pgcnt)) {
+	if (ice_can_reuse_rx_page(rx_buf)) {
 		/* hand second half of page back to the ring */
 		ice_reuse_rx_page(rx_ring, rx_buf);
 	} else {
@@ -1137,7 +1132,6 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		unsigned char *hard_start;
 		unsigned int size;
 		u16 stat_err_bits;
-		int rx_buf_pgcnt;
 		u16 vlan_tag = 0;
 		u16 rx_ptype;
 
@@ -1166,7 +1160,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 			if (rx_desc->wb.rxdid == FDIR_DESC_RXDID &&
 			    ctrl_vsi->vf)
 				ice_vc_fdir_irq_handler(ctrl_vsi, rx_desc);
-			ice_put_rx_buf(rx_ring, NULL, 0);
+			ice_put_rx_buf(rx_ring, NULL);
 			cleaned_count++;
 			continue;
 		}
@@ -1175,7 +1169,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 			ICE_RX_FLX_DESC_PKT_LEN_M;
 
 		/* retrieve a buffer from the ring */
-		rx_buf = ice_get_rx_buf(rx_ring, size, &rx_buf_pgcnt);
+		rx_buf = ice_get_rx_buf(rx_ring, size);
 
 		if (!size) {
 			xdp->data = NULL;
@@ -1209,7 +1203,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		total_rx_pkts++;
 
 		cleaned_count++;
-		ice_put_rx_buf(rx_ring, rx_buf, rx_buf_pgcnt);
+		ice_put_rx_buf(rx_ring, rx_buf);
 		continue;
 construct_skb:
 		if (skb) {
@@ -1228,7 +1222,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 			break;
 		}
 
-		ice_put_rx_buf(rx_ring, rx_buf, rx_buf_pgcnt);
+		ice_put_rx_buf(rx_ring, rx_buf);
 		cleaned_count++;
 
 		/* skip if it is NOP desc */
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index ef8245f795c5b..c1d9b3cebb059 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -172,7 +172,8 @@ struct ice_rx_buf {
 	dma_addr_t dma;
 	struct page *page;
 	unsigned int page_offset;
-	u16 pagecnt_bias;
+	unsigned int pgcnt;
+	unsigned int pagecnt_bias;
 };
 
 struct ice_q_stats {
-- 
2.43.0



