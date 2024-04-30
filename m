Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842698801;
	Tue, 30 Apr 2024 11:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475526; cv=none; b=PBQzqcUlENkseiA+U0UX9sP4Yfzr3MgsMtVTIjG6jflvrFwGAqI8gTRfyxWMwtvuoKoi9K3q7fkEf3B3lP5zN3X969P4tUxeniUBGS1RQEjv7sh8cjhsvVPbK1IPwg8oAeBkRJaQsjJhh1KjZQtu4h8oTG3jIRTzkNyrYKniFK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475526; c=relaxed/simple;
	bh=jl0AijJ13jrKP1bx/zvY0vfKpkagkC6M3447JNw6PjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uyph/pGCMFK7TTS8pxW08DmjfGwszewMjIaovDAhLc+TExeShd07TwrGqzb4u0ukFKNQtACF0+2+3U1bmuZIpxpy99i9nyChBP5a54oXxMp7WTd347tKeF3yaBm+A45BNhHWLf7xBCg8jIYSzyEiuHhA564vTUh0nRCHmCYR5yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yoJIEYyR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yoJIEYyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACAC6C2BBFC;
	Tue, 30 Apr 2024 11:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475526;
	bh=jl0AijJ13jrKP1bx/zvY0vfKpkagkC6M3447JNw6PjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yoJIEYyR+b/Ju/OMgi18H4kxGFValqnEbF0Th3/2yaeYSo5FnsKY7gSHDsOSRWzfp
	 nJ6oExuxe7mTgCiAGB8i/EnmWopysDeJHC8IBMh+u1Iss8dvI4EMxMeZMcHB1vsEr3
	 nwXRS54IGm5vyPNlDeHXxid3nZ7xPc0R0ZYZG6q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/186] eth: bnxt: fix counting packets discarded due to OOM and netpoll
Date: Tue, 30 Apr 2024 12:38:56 +0200
Message-ID: <20240430103100.473375371@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 730117730709992c9f6535dd7b47638ee561ec45 ]

I added OOM and netpoll discard counters, naively assuming that
the cpr pointer is pointing to a common completion ring.
Turns out that is usually *a* completion ring but not *the*
completion ring which bnapi->cp_ring points to. bnapi->cp_ring
is where the stats are read from, so we end up reporting 0
thru ethtool -S and qstat even though the drop events have happened.
Make 100% sure we're recording statistics in the correct structure.

Fixes: 907fd4a294db ("bnxt: count discards due to memory allocation errors")
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/r/20240424002148.3937059-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 44 ++++++++++-------------
 1 file changed, 18 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index d40b91719b79b..724624737d095 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1659,7 +1659,7 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 		skb = bnxt_copy_skb(bnapi, data_ptr, len, mapping);
 		if (!skb) {
 			bnxt_abort_tpa(cpr, idx, agg_bufs);
-			cpr->sw_stats.rx.rx_oom_discards += 1;
+			cpr->bnapi->cp_ring.sw_stats.rx.rx_oom_discards += 1;
 			return NULL;
 		}
 	} else {
@@ -1669,7 +1669,7 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 		new_data = __bnxt_alloc_rx_frag(bp, &new_mapping, GFP_ATOMIC);
 		if (!new_data) {
 			bnxt_abort_tpa(cpr, idx, agg_bufs);
-			cpr->sw_stats.rx.rx_oom_discards += 1;
+			cpr->bnapi->cp_ring.sw_stats.rx.rx_oom_discards += 1;
 			return NULL;
 		}
 
@@ -1685,7 +1685,7 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 		if (!skb) {
 			skb_free_frag(data);
 			bnxt_abort_tpa(cpr, idx, agg_bufs);
-			cpr->sw_stats.rx.rx_oom_discards += 1;
+			cpr->bnapi->cp_ring.sw_stats.rx.rx_oom_discards += 1;
 			return NULL;
 		}
 		skb_reserve(skb, bp->rx_offset);
@@ -1696,7 +1696,7 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 		skb = bnxt_rx_agg_pages_skb(bp, cpr, skb, idx, agg_bufs, true);
 		if (!skb) {
 			/* Page reuse already handled by bnxt_rx_pages(). */
-			cpr->sw_stats.rx.rx_oom_discards += 1;
+			cpr->bnapi->cp_ring.sw_stats.rx.rx_oom_discards += 1;
 			return NULL;
 		}
 	}
@@ -1914,11 +1914,8 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 			u32 frag_len = bnxt_rx_agg_pages_xdp(bp, cpr, &xdp,
 							     cp_cons, agg_bufs,
 							     false);
-			if (!frag_len) {
-				cpr->sw_stats.rx.rx_oom_discards += 1;
-				rc = -ENOMEM;
-				goto next_rx;
-			}
+			if (!frag_len)
+				goto oom_next_rx;
 		}
 		xdp_active = true;
 	}
@@ -1941,9 +1938,7 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 				else
 					bnxt_xdp_buff_frags_free(rxr, &xdp);
 			}
-			cpr->sw_stats.rx.rx_oom_discards += 1;
-			rc = -ENOMEM;
-			goto next_rx;
+			goto oom_next_rx;
 		}
 	} else {
 		u32 payload;
@@ -1954,29 +1949,21 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 			payload = 0;
 		skb = bp->rx_skb_func(bp, rxr, cons, data, data_ptr, dma_addr,
 				      payload | len);
-		if (!skb) {
-			cpr->sw_stats.rx.rx_oom_discards += 1;
-			rc = -ENOMEM;
-			goto next_rx;
-		}
+		if (!skb)
+			goto oom_next_rx;
 	}
 
 	if (agg_bufs) {
 		if (!xdp_active) {
 			skb = bnxt_rx_agg_pages_skb(bp, cpr, skb, cp_cons, agg_bufs, false);
-			if (!skb) {
-				cpr->sw_stats.rx.rx_oom_discards += 1;
-				rc = -ENOMEM;
-				goto next_rx;
-			}
+			if (!skb)
+				goto oom_next_rx;
 		} else {
 			skb = bnxt_xdp_build_skb(bp, skb, agg_bufs, rxr->page_pool, &xdp, rxcmp1);
 			if (!skb) {
 				/* we should be able to free the old skb here */
 				bnxt_xdp_buff_frags_free(rxr, &xdp);
-				cpr->sw_stats.rx.rx_oom_discards += 1;
-				rc = -ENOMEM;
-				goto next_rx;
+				goto oom_next_rx;
 			}
 		}
 	}
@@ -2054,6 +2041,11 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	*raw_cons = tmp_raw_cons;
 
 	return rc;
+
+oom_next_rx:
+	cpr->bnapi->cp_ring.sw_stats.rx.rx_oom_discards += 1;
+	rc = -ENOMEM;
+	goto next_rx;
 }
 
 /* In netpoll mode, if we are using a combined completion ring, we need to
@@ -2099,7 +2091,7 @@ static int bnxt_force_rx_discard(struct bnxt *bp,
 	}
 	rc = bnxt_rx_pkt(bp, cpr, raw_cons, event);
 	if (rc && rc != -EBUSY)
-		cpr->sw_stats.rx.rx_netpoll_discards += 1;
+		cpr->bnapi->cp_ring.sw_stats.rx.rx_netpoll_discards += 1;
 	return rc;
 }
 
-- 
2.43.0



