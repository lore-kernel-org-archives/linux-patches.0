Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571D512DDAF;
	Tue, 30 Apr 2024 10:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474394; cv=none; b=WeQ2rbrcrikTVxyIBH54fbaQs6/QtsEwBsee1GIPdvGL09UhJvDV8eEKSBwBTDLO2zuW+OX8KVl8jXJRSxi8ZGttDbBLxU/jDrSTHz3YvPFSPyhVPBKF00gA9TOKwQBRtIE8yfakWXBMjapppM0Flv8+MsnKiNGGl2TXt3SHDfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474394; c=relaxed/simple;
	bh=qmwWlpgpYJ+3BgM02E0MvgRyR5NPfWSnr4qou+Dxj/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iNZwthmXZfIv8pguHCTnCZRd6pQGmRp1icV+ijKuxJBwaWIyNNe66lH+iW/di4RNHn7rzGAqoMOzwKQs0NP+dErx66VNshdYBE25/Hwqh5S6m3mgDYs1PhGUA5LiTytFnYymIb3usfBKDpJyqlJNcXxSrTSDZsID++X2iNKkjtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1mQO3/sG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1mQO3/sG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33B0C2BBFC;
	Tue, 30 Apr 2024 10:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474394;
	bh=qmwWlpgpYJ+3BgM02E0MvgRyR5NPfWSnr4qou+Dxj/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1mQO3/sGXiS3z02hotfTSe6Zegx2u25HvuOrYjfpOMfH3tCj/jTAxlptFVCpDHp8z
	 ysQTJ9nxyztro4ozZ7oL+g5T+W/OFchsI5kz1WB0HidrsNSHaRYE3EpEMj4LamiJ/p
	 +KjzO0wVb0hr1Q6c3ch5xmDMhi4f2qdBzo2NWbqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 104/228] eth: bnxt: fix counting packets discarded due to OOM and netpoll
Date: Tue, 30 Apr 2024 12:38:02 +0200
Message-ID: <20240430103106.798855931@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 5b4d810748f2a..e133a412a13fc 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1735,7 +1735,7 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 		skb = bnxt_copy_skb(bnapi, data_ptr, len, mapping);
 		if (!skb) {
 			bnxt_abort_tpa(cpr, idx, agg_bufs);
-			cpr->sw_stats.rx.rx_oom_discards += 1;
+			cpr->bnapi->cp_ring.sw_stats.rx.rx_oom_discards += 1;
 			return NULL;
 		}
 	} else {
@@ -1745,7 +1745,7 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 		new_data = __bnxt_alloc_rx_frag(bp, &new_mapping, GFP_ATOMIC);
 		if (!new_data) {
 			bnxt_abort_tpa(cpr, idx, agg_bufs);
-			cpr->sw_stats.rx.rx_oom_discards += 1;
+			cpr->bnapi->cp_ring.sw_stats.rx.rx_oom_discards += 1;
 			return NULL;
 		}
 
@@ -1761,7 +1761,7 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 		if (!skb) {
 			skb_free_frag(data);
 			bnxt_abort_tpa(cpr, idx, agg_bufs);
-			cpr->sw_stats.rx.rx_oom_discards += 1;
+			cpr->bnapi->cp_ring.sw_stats.rx.rx_oom_discards += 1;
 			return NULL;
 		}
 		skb_reserve(skb, bp->rx_offset);
@@ -1772,7 +1772,7 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 		skb = bnxt_rx_agg_pages_skb(bp, cpr, skb, idx, agg_bufs, true);
 		if (!skb) {
 			/* Page reuse already handled by bnxt_rx_pages(). */
-			cpr->sw_stats.rx.rx_oom_discards += 1;
+			cpr->bnapi->cp_ring.sw_stats.rx.rx_oom_discards += 1;
 			return NULL;
 		}
 	}
@@ -2051,11 +2051,8 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
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
@@ -2078,9 +2075,7 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
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
@@ -2091,29 +2086,21 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
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
@@ -2191,6 +2178,11 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	*raw_cons = tmp_raw_cons;
 
 	return rc;
+
+oom_next_rx:
+	cpr->bnapi->cp_ring.sw_stats.rx.rx_oom_discards += 1;
+	rc = -ENOMEM;
+	goto next_rx;
 }
 
 /* In netpoll mode, if we are using a combined completion ring, we need to
@@ -2237,7 +2229,7 @@ static int bnxt_force_rx_discard(struct bnxt *bp,
 	}
 	rc = bnxt_rx_pkt(bp, cpr, raw_cons, event);
 	if (rc && rc != -EBUSY)
-		cpr->sw_stats.rx.rx_netpoll_discards += 1;
+		cpr->bnapi->cp_ring.sw_stats.rx.rx_netpoll_discards += 1;
 	return rc;
 }
 
-- 
2.43.0



