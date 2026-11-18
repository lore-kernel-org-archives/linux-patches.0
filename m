Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028314;
	b=E4Nw2+7toyeYdxsjLjJqtse9whVfSglcB8WDnnn0gv3xvKViDCyMMNs2XxpIwZeeK/cQ
	 MvHP8Dmfog0B93Q3KtqPr8APkQXWSL5KgmhC2pg+ppUjFd6nUWB6q9feolv7582g7O5I4
	 i962wyZofm/pOXgl3pc5xgVOH9WTpnUkeh7Z5gUhxFCv9PyK0Rhgk8Gaz1+YuxFIj2Tgo
	 zHybnG18mIFoM8rPadHrSfyskPAp8rRTH4efeg5nMjwHjdDvbmGdqt+T/orAeKnjIrcrw
	 yhFjq0XqVmHuOpBoWUcHvSPBwU3VJhO/O3zkOorgE+XsGbAiTI2UuRNQnoEK6naKcGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CTeZc3hYCQA1Py4WGR9VHatFL3QJWpDORbpAGnNVfIg=;
	b=3mlExQPHNjGYDIwlDnnq1bn4bJ3uMKookzDmpOC+HKb69NpVXgb8kinqj0C/tO8h7XKP
	 7y6/oq6QpKrDXFV0XeuW6Bd+CICGmwWC7GDDU22kBcLiqyIiq1MN1v7QQtKqNrJdoAe/T
	 CULEphnOD5Tu5D2aOYWgjIk5k+VOWh1Xk1DDpdP7/RHtUH5dkEkuo2iRiMym0gYloe61J
	 /rycesCfM+Yho2V7HVjNt2/h6g03oPfrJJfuiGCnjAwrQ3dtqNMFLLfg8anzbh3upzRqK
	 uwDXbzU191slH08bHUB1/YmAZjiIVsRwISPUMf+DR/L+suZoCA6mk6dnTgF5i4iDH0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AAJTfzQY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D79E606A339;
	Wed, 18 Nov 2026 18:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AAJTfzQY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947801F000C4;
	Wed, 18 Nov 2026 18:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028314;
	bh=CTeZc3hYCQA1Py4WGR9VHatFL3QJWpDORbpAGnNVfIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AAJTfzQYDkH90Q7HbmppZffTFmOl1G2ZseiYq1S0DyvRgcT0OIc5VtY3IZWITuMhx
	 umdnqINd7ALnHB9JOUwDUUi2Y9Q8RO/VRWzm5DZAm9oYa2CR+vCtZI4Xe1Z8vfSc1v
	 uDaI5KBxO7JDwRRgX7DyR95YeJwkm7Gx7YIn71ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2102/2151] eth: bnxt: recycle agg buffers when Rx head buffer allocation fails
Date: Wed, 18 Nov 2026 16:03:57 +0100
Message-ID: <20261118150238.268936892@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit db2c610df81e34d497f49b68a0a1681c3f203bdb ]

bnxt_rx_pkt() tries to return the aggregation buffers of a packet
to the ring when the copybreak allocation fails, but the same logic
is missing on the rx_skb_func() failure path. The agg BDs consumed
by the device are then never posted again. The agg ring is only
refilled one-for-one as completions consume its buffers, so each
such failure permanently shrinks it. Under sustained memory pressure
the ring drains completely, and the queue stops receiving anything
that does not fit into the head buffer, even once memory is available
again. Only re-creating the rings (e.g. ifdown / ifup) recovers it.

Commit 296d5b541639 ("bnxt_en: Fix aggregation buffer leak under OOM
condition.") fixed the copybreak path only. Recently
commit bd3beb5c8691 ("eth: bnxt: disable rx-copybreak by default")
made the non-copybreak path the default, re-surfacing the issue.

With XDP, the agg buffers are attached to the xdp_buff as frags by
this point. Their agg ring slots have already been refilled.
We need to keep the original head page (and therefore shinfo)
around until the xdp_buff cleanup.

Note the odd split of ownership here: rx_skb_func() only deals with
the head buffer, the agg buffers stay with the caller in whatever
state they are in, still on the ring without XDP, or frags of the
xdp_buff with XDP. This complicates rx_skb_func() cleaning up all
the buffers (head and frags), which would be more intuitive.

Discovered in production, severe packet loss would persist after
a transient OOM event. Tested on a BCM57504 by failing the head
buffer allocations in bnxt_rx_skb() (bpftrace override() of
should_failslab() and should_fail_alloc_page()) while receiving
1400B ICMPv6 echo requests. 341k packets were dropped on that queue,
enough to drain its 8188 entry agg ring 40 times over, and the queue
kept receiving large frames afterwards with no loss and no new HW drops.
With a frags-capable XDP_PASS program at MTU 9000, receiving 8000B
ICMPv6 echo requests while napi_build_skb() called from
bnxt_rx_multi_page_skb() failed, 9.2k packets were dropped,
the page pools' inflight count stayed flat and
there were no KASAN or DEBUG_PAGEALLOC splats.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Fixes: 4c6c123c9af9 ("bnxt: adding bnxt_rx_agg_pages_xdp for aggregated xdp")
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20261027234940.1267225-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 33 ++++++++++++++---------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 1c89224ea6654..6e8e316165137 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1160,7 +1160,15 @@ static struct sk_buff *bnxt_rx_multi_page_skb(struct bnxt *bp,
 				bp->rx_dir);
 	skb = napi_build_skb(frag_start, rxr->rx_page_size);
 	if (!skb) {
-		page_pool_recycle_direct(rxr->page_pool, page);
+		struct page *new_page;
+
+		new_page = rxr->rx_buf_ring[RING_RX(bp, prod)].data;
+		/* The caller may still need the XDP frags from shinfo at the
+		 * end of the head page. Release the new buffer instead and
+		 * put the head back on the ring.
+		 */
+		page_pool_recycle_direct(rxr->page_pool, new_page);
+		bnxt_reuse_rx_data(rxr, cons, data);
 		return NULL;
 	}
 	skb_mark_for_recycle(skb);
@@ -2273,17 +2281,8 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 			skb = bnxt_copy_xdp(bnapi, &bnxt_xdp.xdp, len,
 					    dma_addr);
 		bnxt_reuse_rx_data(rxr, cons, data);
-		if (!skb) {
-			if (agg_bufs) {
-				if (!xdp_active)
-					bnxt_reuse_rx_agg_bufs(cpr, cp_cons, 0,
-							       agg_bufs, false);
-				else
-					bnxt_xdp_buff_frags_free(rxr,
-								 &bnxt_xdp.xdp);
-			}
-			goto oom_next_rx;
-		}
+		if (!skb)
+			goto oom_next_rx_agg;
 	} else {
 		u32 payload;
 
@@ -2294,7 +2293,7 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 		skb = bp->rx_skb_func(bp, rxr, cons, data, data_ptr, dma_addr,
 				      payload | len);
 		if (!skb)
-			goto oom_next_rx;
+			goto oom_next_rx_agg;
 	}
 
 	if (agg_bufs) {
@@ -2384,6 +2383,14 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 
 	return rc;
 
+oom_next_rx_agg:
+	if (agg_bufs) {
+		if (!xdp_active)
+			bnxt_reuse_rx_agg_bufs(cpr, cp_cons, 0, agg_bufs,
+					       false);
+		else
+			bnxt_xdp_buff_frags_free(rxr, &bnxt_xdp.xdp);
+	}
 oom_next_rx:
 	cpr->sw_stats->rx.rx_oom_discards += 1;
 	rc = -ENOMEM;
-- 
2.53.0



