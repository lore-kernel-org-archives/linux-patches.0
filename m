Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1313C1C9ECD;
	Tue, 27 Aug 2024 15:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772537; cv=none; b=I0FpqOpfZ3XdawQ1Q5S1myz8QMXOhajQO714Jo36A0goyhIw/m0Bm1T5bCOBRssjMjEmiOQ8wwcJEkz1ZmkspLxlFkQiAYObkrs1+GyszJywb55FPUjts6b5LES0DlholrF7KWYRlYE5tWsEteTSm1dTkRYZJyt7VMBH87cUPz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772537; c=relaxed/simple;
	bh=uP0fimkxKPzsIQ/IK05YbrOhkXtBOEzQ9ThgGIr0wN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4TJfZHVyuzk/+acC+h3j7aW+l3ZLJCfMpiBmIBtmarms/sVlqnY9pQIeY3iw/AuRdcbglKhjOaK/7r910ONgvTXZRgQD5ZteCtgmn3TuZw2c48ged6Etj2whsGprMfcWjTqg7KW7xGlc0KqPHk47T8tZr0FFwPpDdLqpqKPM1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCoMQJWZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCoMQJWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76307C4AF15;
	Tue, 27 Aug 2024 15:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772536;
	bh=uP0fimkxKPzsIQ/IK05YbrOhkXtBOEzQ9ThgGIr0wN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wCoMQJWZyQk3+gFw2JgOYGjpAEp9DbHIVlzzhVVus/tVOH4BytKejbFSPWRrXj/qz
	 G314CgeD4WOLWx6b0FlzU3dOEismXoPm9xkEOsmPA+9sb8F0C6zRM3BBbwKKS1HXh/
	 61JNuH8ZldTivczM1zcQKW65mUK0qRukaYh1jx0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexander Lobakin <alexandr.lobakin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 245/321] ice: Pull out next_to_clean bump out of ice_put_rx_buf()
Date: Tue, 27 Aug 2024 16:39:13 +0200
Message-ID: <20240827143847.569544554@linuxfoundation.org>
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

[ Upstream commit d7956d81f1502d3818500cff4847f3e9ae0c6aa4 ]

Plan is to move ice_put_rx_buf() to the end of ice_clean_rx_irq() so
in order to keep the ability of walking through HW Rx descriptors, pull
out next_to_clean handling out of ice_put_rx_buf().

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Link: https://lore.kernel.org/bpf/20230131204506.219292-5-maciej.fijalkowski@intel.com
Stable-dep-of: 50b2143356e8 ("ice: fix page reuse when PAGE_SIZE is over 8k")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 29 +++++++++++++----------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 977b268802dfa..6f930d99b496b 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -898,11 +898,12 @@ ice_reuse_rx_page(struct ice_rx_ring *rx_ring, struct ice_rx_buf *old_buf)
  * for use by the CPU.
  */
 static struct ice_rx_buf *
-ice_get_rx_buf(struct ice_rx_ring *rx_ring, const unsigned int size)
+ice_get_rx_buf(struct ice_rx_ring *rx_ring, const unsigned int size,
+	       const unsigned int ntc)
 {
 	struct ice_rx_buf *rx_buf;
 
-	rx_buf = &rx_ring->rx_buf[rx_ring->next_to_clean];
+	rx_buf = &rx_ring->rx_buf[ntc];
 	rx_buf->pgcnt =
 #if (PAGE_SIZE < 8192)
 		page_count(rx_buf->page);
@@ -1040,19 +1041,12 @@ ice_construct_skb(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf,
  * @rx_ring: Rx descriptor ring to transact packets on
  * @rx_buf: Rx buffer to pull data from
  *
- * This function will update next_to_clean and then clean up the contents
- * of the rx_buf. It will either recycle the buffer or unmap it and free
- * the associated resources.
+ * This function will clean up the contents of the rx_buf. It will either
+ * recycle the buffer or unmap it and free the associated resources.
  */
 static void
 ice_put_rx_buf(struct ice_rx_ring *rx_ring, struct ice_rx_buf *rx_buf)
 {
-	u16 ntc = rx_ring->next_to_clean + 1;
-
-	/* fetch, update, and store next to clean */
-	ntc = (ntc < rx_ring->count) ? ntc : 0;
-	rx_ring->next_to_clean = ntc;
-
 	if (!rx_buf)
 		return;
 
@@ -1114,6 +1108,8 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 	unsigned int xdp_res, xdp_xmit = 0;
 	struct sk_buff *skb = rx_ring->skb;
 	struct bpf_prog *xdp_prog = NULL;
+	u32 ntc = rx_ring->next_to_clean;
+	u32 cnt = rx_ring->count;
 	bool failure;
 
 	/* Frame size depend on rx_ring setup when PAGE_SIZE=4K */
@@ -1136,7 +1132,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		u16 rx_ptype;
 
 		/* get the Rx desc from Rx ring based on 'next_to_clean' */
-		rx_desc = ICE_RX_DESC(rx_ring, rx_ring->next_to_clean);
+		rx_desc = ICE_RX_DESC(rx_ring, ntc);
 
 		/* status_error_len will always be zero for unused descriptors
 		 * because it's cleared in cleanup, and overlaps with hdr_addr
@@ -1160,6 +1156,8 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 			if (rx_desc->wb.rxdid == FDIR_DESC_RXDID &&
 			    ctrl_vsi->vf)
 				ice_vc_fdir_irq_handler(ctrl_vsi, rx_desc);
+			if (++ntc == cnt)
+				ntc = 0;
 			ice_put_rx_buf(rx_ring, NULL);
 			cleaned_count++;
 			continue;
@@ -1169,7 +1167,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 			ICE_RX_FLX_DESC_PKT_LEN_M;
 
 		/* retrieve a buffer from the ring */
-		rx_buf = ice_get_rx_buf(rx_ring, size);
+		rx_buf = ice_get_rx_buf(rx_ring, size, ntc);
 
 		if (!size) {
 			xdp->data = NULL;
@@ -1203,6 +1201,8 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		total_rx_pkts++;
 
 		cleaned_count++;
+		if (++ntc == cnt)
+			ntc = 0;
 		ice_put_rx_buf(rx_ring, rx_buf);
 		continue;
 construct_skb:
@@ -1222,6 +1222,8 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 			break;
 		}
 
+		if (++ntc == cnt)
+			ntc = 0;
 		ice_put_rx_buf(rx_ring, rx_buf);
 		cleaned_count++;
 
@@ -1262,6 +1264,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		total_rx_pkts++;
 	}
 
+	rx_ring->next_to_clean = ntc;
 	/* return up to cleaned_count buffers to hardware */
 	failure = ice_alloc_rx_bufs(rx_ring, cleaned_count);
 
-- 
2.43.0



