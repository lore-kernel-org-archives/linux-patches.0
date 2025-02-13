Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E131411DE;
	Thu, 13 Feb 2025 15:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460273; cv=none; b=X5USvKAp5YwKbA4wfAIl9DX0QVPfO7l2IGHYZ8SW26aME5SnITdTV1aDrZbI3BBHhrGJ/nfdhdzAbv6R475etM8+GZOi/PIUG55/j4v9fq5xPtGSjgQ+MGf22D/WF0gWlCuIBxOKV+FqcoF1/RyAc4Nh7PaddCCa7KqEsYPQ+R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460273; c=relaxed/simple;
	bh=uTwul3V3QYVImH3IvMkfzkWdiXWWiTUbnS2BlkDBuhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bba3FEfTvpODnYkShk/pyOQRcVG2kEf6bMDmhkjFSVlcJHIJKJEdrlIjMa5nAoujVhMn992fZnM56/BXSuPPWbsIry+BoT+//M1huibkImUzmJlbzJWUZZorD3mlNLlweT06OUelKyI6FGYZes9ESaR7KKm1kbF9ji7p/BLz6aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aFIUWOHL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aFIUWOHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3EB5C4CED1;
	Thu, 13 Feb 2025 15:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460273;
	bh=uTwul3V3QYVImH3IvMkfzkWdiXWWiTUbnS2BlkDBuhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aFIUWOHL0GaPFKQFsQqgfVS5x5uh8lR6GUW9sCr8B0iVxjNlq1TZq9J2rfC0QfmoQ
	 03wCDHJaeeBnRW6R+rc7yzqA0lSli7cPUc1I0x5RAn0D15ZeBGeIILhRH4+SH0N0v2
	 rNtoGi08b5e82S5BIzwSqejLtUFnJHKbViO0P6Ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Xu Du <xudu@redhat.com>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 6.6 063/273] ice: put Rx buffers after being done with current frame
Date: Thu, 13 Feb 2025 15:27:15 +0100
Message-ID: <20250213142409.843542286@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 743bbd93cf29f653fae0e1416a31f03231689911 ]

Introduce a new helper ice_put_rx_mbuf() that will go through gathered
frags from current frame and will call ice_put_rx_buf() on them. Current
logic that was supposed to simplify and optimize the driver where we go
through a batch of all buffers processed in current NAPI instance turned
out to be broken for jumbo frames and very heavy load that was coming
from both multi-thread iperf and nginx/wrk pair between server and
client. The delay introduced by approach that we are dropping is simply
too big and we need to take the decision regarding page
recycling/releasing as quick as we can.

While at it, address an error path of ice_add_xdp_frag() - we were
missing buffer putting from day 1 there.

As a nice side effect we get rid of annoying and repetitive three-liner:

	xdp->data = NULL;
	rx_ring->first_desc = ntc;
	rx_ring->nr_frags = 0;

by embedding it within introduced routine.

Fixes: 1dc1a7e7f410 ("ice: Centrallize Rx buffer recycling")
Reported-and-tested-by: Xu Du <xudu@redhat.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Co-developed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 79 ++++++++++++++---------
 1 file changed, 50 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 429afffa4c316..f5023ac9ab832 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1101,6 +1101,49 @@ ice_put_rx_buf(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf)
 	rx_buf->page = NULL;
 }
 
+/**
+ * ice_put_rx_mbuf - ice_put_rx_buf() caller, for all frame frags
+ * @rx_ring: Rx ring with all the auxiliary data
+ * @xdp: XDP buffer carrying linear + frags part
+ * @xdp_xmit: XDP_TX/XDP_REDIRECT verdict storage
+ * @ntc: a current next_to_clean value to be stored at rx_ring
+ *
+ * Walk through gathered fragments and satisfy internal page
+ * recycle mechanism; we take here an action related to verdict
+ * returned by XDP program;
+ */
+static void ice_put_rx_mbuf(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
+			    u32 *xdp_xmit, u32 ntc)
+{
+	u32 nr_frags = rx_ring->nr_frags + 1;
+	u32 idx = rx_ring->first_desc;
+	u32 cnt = rx_ring->count;
+	struct ice_rx_buf *buf;
+	int i;
+
+	for (i = 0; i < nr_frags; i++) {
+		buf = &rx_ring->rx_buf[idx];
+
+		if (buf->act & (ICE_XDP_TX | ICE_XDP_REDIR)) {
+			ice_rx_buf_adjust_pg_offset(buf, xdp->frame_sz);
+			*xdp_xmit |= buf->act;
+		} else if (buf->act & ICE_XDP_CONSUMED) {
+			buf->pagecnt_bias++;
+		} else if (buf->act == ICE_XDP_PASS) {
+			ice_rx_buf_adjust_pg_offset(buf, xdp->frame_sz);
+		}
+
+		ice_put_rx_buf(rx_ring, buf);
+
+		if (++idx == cnt)
+			idx = 0;
+	}
+
+	xdp->data = NULL;
+	rx_ring->first_desc = ntc;
+	rx_ring->nr_frags = 0;
+}
+
 /**
  * ice_clean_rx_irq - Clean completed descriptors from Rx ring - bounce buf
  * @rx_ring: Rx descriptor ring to transact packets on
@@ -1118,7 +1161,6 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 	unsigned int total_rx_bytes = 0, total_rx_pkts = 0;
 	unsigned int offset = rx_ring->rx_offset;
 	struct xdp_buff *xdp = &rx_ring->xdp;
-	u32 cached_ntc = rx_ring->first_desc;
 	struct ice_tx_ring *xdp_ring = NULL;
 	struct bpf_prog *xdp_prog = NULL;
 	u32 ntc = rx_ring->next_to_clean;
@@ -1126,7 +1168,6 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 	u32 xdp_xmit = 0;
 	u32 cached_ntu;
 	bool failure;
-	u32 first;
 
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 	if (xdp_prog) {
@@ -1189,6 +1230,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 			xdp_prepare_buff(xdp, hard_start, offset, size, !!offset);
 			xdp_buff_clear_frags_flag(xdp);
 		} else if (ice_add_xdp_frag(rx_ring, xdp, rx_buf, size)) {
+			ice_put_rx_mbuf(rx_ring, xdp, NULL, ntc);
 			break;
 		}
 		if (++ntc == cnt)
@@ -1204,9 +1246,8 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		total_rx_bytes += xdp_get_buff_len(xdp);
 		total_rx_pkts++;
 
-		xdp->data = NULL;
-		rx_ring->first_desc = ntc;
-		rx_ring->nr_frags = 0;
+		ice_put_rx_mbuf(rx_ring, xdp, &xdp_xmit, ntc);
+
 		continue;
 construct_skb:
 		if (likely(ice_ring_uses_build_skb(rx_ring)))
@@ -1220,14 +1261,11 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 			if (unlikely(xdp_buff_has_frags(xdp)))
 				ice_set_rx_bufs_act(xdp, rx_ring,
 						    ICE_XDP_CONSUMED);
-			xdp->data = NULL;
-			rx_ring->first_desc = ntc;
-			rx_ring->nr_frags = 0;
-			break;
 		}
-		xdp->data = NULL;
-		rx_ring->first_desc = ntc;
-		rx_ring->nr_frags = 0;
+		ice_put_rx_mbuf(rx_ring, xdp, &xdp_xmit, ntc);
+
+		if (!skb)
+			break;
 
 		stat_err_bits = BIT(ICE_RX_FLEX_DESC_STATUS0_RXE_S);
 		if (unlikely(ice_test_staterr(rx_desc->wb.status_error0,
@@ -1259,23 +1297,6 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		total_rx_pkts++;
 	}
 
-	first = rx_ring->first_desc;
-	while (cached_ntc != first) {
-		struct ice_rx_buf *buf = &rx_ring->rx_buf[cached_ntc];
-
-		if (buf->act & (ICE_XDP_TX | ICE_XDP_REDIR)) {
-			ice_rx_buf_adjust_pg_offset(buf, xdp->frame_sz);
-			xdp_xmit |= buf->act;
-		} else if (buf->act & ICE_XDP_CONSUMED) {
-			buf->pagecnt_bias++;
-		} else if (buf->act == ICE_XDP_PASS) {
-			ice_rx_buf_adjust_pg_offset(buf, xdp->frame_sz);
-		}
-
-		ice_put_rx_buf(rx_ring, buf);
-		if (++cached_ntc >= cnt)
-			cached_ntc = 0;
-	}
 	rx_ring->next_to_clean = ntc;
 	/* return up to cleaned_count buffers to hardware */
 	failure = ice_alloc_rx_bufs(rx_ring, ICE_RX_DESC_UNUSED(rx_ring));
-- 
2.39.5



