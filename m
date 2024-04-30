Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741F612BF32;
	Tue, 30 Apr 2024 11:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476557; cv=none; b=WklEduAPtnBPsDV8Yx5kVYpmDoWD60gqS1NyNOQCWKMiFqz3w8xxnXa7zmSDCClP/y83WBuStcJ9N0EfjzJhA1KBvwApRs4i2Pp4whKvHHkp1/kLkG0E2Zu1cHIMKykWbc8WOsjRKOVDi4yuwCJPvwDaktYp/dIKTbmXLhv9SqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476557; c=relaxed/simple;
	bh=AdxRXs4MqDrMgh/fXmt0zPXat8wP/5HDmT0pFjFZmqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VxIC3OAMEtDDhUmxDPZFQVuk6ii3Vijfmg2yaGxbI0XNipV+Pg6SlLapUU1B4doLQUTQ1/WTEsynF+9bTYWJCJzOI/o38GF7cFhG3gbZ+tusuD6sFq0P7FV4bW+oSxW/RiX+f1b4TtER30nnpzetoJ7JkGM5NSEInybIrcVewZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RTTxjV37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RTTxjV37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83B9C4AF1A;
	Tue, 30 Apr 2024 11:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476557;
	bh=AdxRXs4MqDrMgh/fXmt0zPXat8wP/5HDmT0pFjFZmqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RTTxjV37U7+3Sv2dBKK31F0PBKYk5A86Q8HJlKAqaQdNHtxBCx6Y96npfUBcbAT+l
	 4C31VEbPhklXUyGRTpNYzsGUMxrPYCSNZUA/2Y4KW5cXPj0DoZiGRaMt24+/58Ienu
	 E7+TYc0d9/HQUSsxvRRG1GM2zKBqaHMPf38GfwEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/110] eth: bnxt: fix counting packets discarded due to OOM and netpoll
Date: Tue, 30 Apr 2024 12:40:21 +0200
Message-ID: <20240430103049.102337925@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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
index 70021b5eb54a6..77ea19bcdc6fe 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1697,7 +1697,7 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 		skb = bnxt_copy_skb(bnapi, data_ptr, len, mapping);
 		if (!skb) {
 			bnxt_abort_tpa(cpr, idx, agg_bufs);
-			cpr->sw_stats.rx.rx_oom_discards += 1;
+			cpr->bnapi->cp_ring.sw_stats.rx.rx_oom_discards += 1;
 			return NULL;
 		}
 	} else {
@@ -1707,7 +1707,7 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 		new_data = __bnxt_alloc_rx_frag(bp, &new_mapping, GFP_ATOMIC);
 		if (!new_data) {
 			bnxt_abort_tpa(cpr, idx, agg_bufs);
-			cpr->sw_stats.rx.rx_oom_discards += 1;
+			cpr->bnapi->cp_ring.sw_stats.rx.rx_oom_discards += 1;
 			return NULL;
 		}
 
@@ -1723,7 +1723,7 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 		if (!skb) {
 			skb_free_frag(data);
 			bnxt_abort_tpa(cpr, idx, agg_bufs);
-			cpr->sw_stats.rx.rx_oom_discards += 1;
+			cpr->bnapi->cp_ring.sw_stats.rx.rx_oom_discards += 1;
 			return NULL;
 		}
 		skb_reserve(skb, bp->rx_offset);
@@ -1734,7 +1734,7 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 		skb = bnxt_rx_agg_pages_skb(bp, cpr, skb, idx, agg_bufs, true);
 		if (!skb) {
 			/* Page reuse already handled by bnxt_rx_pages(). */
-			cpr->sw_stats.rx.rx_oom_discards += 1;
+			cpr->bnapi->cp_ring.sw_stats.rx.rx_oom_discards += 1;
 			return NULL;
 		}
 	}
@@ -1950,11 +1950,8 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
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
@@ -1977,9 +1974,7 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
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
@@ -1990,29 +1985,21 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
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
@@ -2090,6 +2077,11 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	*raw_cons = tmp_raw_cons;
 
 	return rc;
+
+oom_next_rx:
+	cpr->bnapi->cp_ring.sw_stats.rx.rx_oom_discards += 1;
+	rc = -ENOMEM;
+	goto next_rx;
 }
 
 /* In netpoll mode, if we are using a combined completion ring, we need to
@@ -2135,7 +2127,7 @@ static int bnxt_force_rx_discard(struct bnxt *bp,
 	}
 	rc = bnxt_rx_pkt(bp, cpr, raw_cons, event);
 	if (rc && rc != -EBUSY)
-		cpr->sw_stats.rx.rx_netpoll_discards += 1;
+		cpr->bnapi->cp_ring.sw_stats.rx.rx_netpoll_discards += 1;
 	return rc;
 }
 
-- 
2.43.0



