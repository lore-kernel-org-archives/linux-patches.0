Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815373A5E7D;
	Sat, 17 Oct 2026 17:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258763; cv=none; b=cqD7jj4B+OPfO4z0im4mbBwxwMlzqExmSLApmYIlVr5TlWLsU6r4u+Wt1hvC25ZLqfTz4Je/TEoplM7L0DM8iOc7bayHS/z8WGBE3ZuShrKGL0pfGpixvvU854mQrvPUS5W+ZV14vqrTfblttDgMbe/WBEPVuNhxQi5PrHsGeVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258763; c=relaxed/simple;
	bh=EYwWx8l5R12k6io5V1LLSZHq3W1NnfdU6ZQRZ2PKtcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oe/xn/kPG0FtIO5q4Uhap9hyHBMqYd5//rlWPvd+kmbB6a6Cu8KwD7D/Q/VtihMaN4FUY2Z9tAldSrVGLnW/sFI11jPTowUo7FGLmIXQyhKJm6fIfBk1GV/NBoR16FFKwhq+MzgA8dGTUpbQOuwlPoe7OXZubNXRdwSv2AZJJXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1bbxbJud; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1bbxbJud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90C61F000C4;
	Sat, 17 Oct 2026 17:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258762;
	bh=rTsRE0lPCwfRURR7amyDGfdorDoM+2KF4TGEnDZbVXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1bbxbJudxZ2XQUrN9dWPt+qmFPXgxYwz5W8fXmbgqIyMUKA1Pl5lc2vPMdPMPugVR
	 Fv3fNAtOzI+qOFX8uH+7XOyU/uvkLjXV884RIW1LAFL64AOQB4Wwx6K090R3oxRF/U
	 gSMyqxu7RFvUu85ZE0rJtFd5X+o+AaBZ8SGjbc2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0991/1674] net: pull headers in qdisc_pkt_len_segs_init()
Date: Sat, 17 Oct 2026 17:54:23 +0200
Message-ID: <20261017160456.556860899@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 7fb4c19670110f052c04e1ec1d2b953b9f4f57e4 ]

Most ndo_start_xmit() methods expects headers of gso packets
to be already in skb->head.

net/core/tso.c users are particularly at risk, because tso_build_hdr()
does a memcpy(hdr, skb->data, hdr_len);

qdisc_pkt_len_segs_init() already does a dissection of gso packets.

Use pskb_may_pull() instead of skb_header_pointer() to make
sure drivers do not have to reimplement this.

Some malicious packets could be fed, detect them so that we can
drop them sooner with a new SKB_DROP_REASON_SKB_BAD_GSO drop_reason.

Fixes: e876f208af18 ("net: Add a software TSO helper API")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260403221540.3297753-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dropreason-core.h |  3 ++
 net/core/dev.c                | 81 +++++++++++++++++++++--------------
 2 files changed, 53 insertions(+), 31 deletions(-)

diff --git a/include/net/dropreason-core.h b/include/net/dropreason-core.h
index e88e785d221bb..16c140e00cc80 100644
--- a/include/net/dropreason-core.h
+++ b/include/net/dropreason-core.h
@@ -56,6 +56,7 @@
 	FN(UNHANDLED_PROTO)		\
 	FN(SKB_CSUM)			\
 	FN(SKB_GSO_SEG)			\
+	FN(SKB_BAD_GSO)			\
 	FN(SKB_UCOPY_FAULT)		\
 	FN(DEV_HDR)			\
 	FN(DEV_READY)			\
@@ -262,6 +263,8 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_SKB_CSUM,
 	/** @SKB_DROP_REASON_SKB_GSO_SEG: gso segmentation error */
 	SKB_DROP_REASON_SKB_GSO_SEG,
+	/** @SKB_DROP_REASON_SKB_BAD_GSO: malicious gso packet. */
+	SKB_DROP_REASON_SKB_BAD_GSO,
 	/**
 	 * @SKB_DROP_REASON_SKB_UCOPY_FAULT: failed to copy data from user space,
 	 * e.g., via zerocopy_sg_from_iter() or skb_orphan_frags_rx()
diff --git a/net/core/dev.c b/net/core/dev.c
index 502b22c604693..045b815516010 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3821,49 +3821,62 @@ struct sk_buff *validate_xmit_skb_list(struct sk_buff *skb, struct net_device *d
 }
 EXPORT_SYMBOL_GPL(validate_xmit_skb_list);
 
-static void qdisc_pkt_len_init(struct sk_buff *skb)
+static enum skb_drop_reason qdisc_pkt_len_init(struct sk_buff *skb)
 {
-	const struct skb_shared_info *shinfo = skb_shinfo(skb);
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
+	unsigned int hdr_len, tlen;
+	u16 gso_segs;
 
 	qdisc_skb_cb(skb)->pkt_len = skb->len;
+	if (!shinfo->gso_size)
+		return SKB_NOT_DROPPED_YET;
+
+	gso_segs = shinfo->gso_segs;
 
 	/* To get more precise estimation of bytes sent on wire,
 	 * we add to pkt_len the headers size of all segments
 	 */
-	if (shinfo->gso_size && skb_transport_header_was_set(skb)) {
-		u16 gso_segs = shinfo->gso_segs;
-		unsigned int hdr_len;
 
-		/* mac layer + network layer */
+	/* mac layer + network layer */
+	if (!skb->encapsulation) {
+		if (unlikely(!skb_transport_header_was_set(skb)))
+			return SKB_NOT_DROPPED_YET;
 		hdr_len = skb_transport_offset(skb);
+	} else {
+		hdr_len = skb_inner_transport_offset(skb);
+	}
+	/* + transport layer */
+	if (likely(shinfo->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6))) {
+		const struct tcphdr *th;
 
-		/* + transport layer */
-		if (likely(shinfo->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6))) {
-			const struct tcphdr *th;
-			struct tcphdr _tcphdr;
-
-			th = skb_header_pointer(skb, hdr_len,
-						sizeof(_tcphdr), &_tcphdr);
-			if (likely(th))
-				hdr_len += __tcp_hdrlen(th);
-		} else if (shinfo->gso_type & SKB_GSO_UDP_L4) {
-			struct udphdr _udphdr;
-
-			if (skb_header_pointer(skb, hdr_len,
-					       sizeof(_udphdr), &_udphdr))
-				hdr_len += sizeof(struct udphdr);
-		}
+		if (!pskb_may_pull(skb, hdr_len + sizeof(struct tcphdr)))
+			return SKB_DROP_REASON_SKB_BAD_GSO;
 
-		if (unlikely(shinfo->gso_type & SKB_GSO_DODGY)) {
-			int payload = skb->len - hdr_len;
+		th = (const struct tcphdr *)(skb->data + hdr_len);
+		tlen = __tcp_hdrlen(th);
+		if (tlen < sizeof(*th))
+			return SKB_DROP_REASON_SKB_BAD_GSO;
+		hdr_len += tlen;
+		if (!pskb_may_pull(skb, hdr_len))
+			return SKB_DROP_REASON_SKB_BAD_GSO;
+	} else if (shinfo->gso_type & SKB_GSO_UDP_L4) {
+		if (!pskb_may_pull(skb, hdr_len + sizeof(struct udphdr)))
+			return SKB_DROP_REASON_SKB_BAD_GSO;
+		hdr_len += sizeof(struct udphdr);
+	}
 
-			/* Malicious packet. */
-			if (payload <= 0)
-				return;
-			gso_segs = DIV_ROUND_UP(payload, shinfo->gso_size);
-		}
-		qdisc_skb_cb(skb)->pkt_len += (gso_segs - 1) * hdr_len;
+	/* prior pskb_may_pull() might have changed skb->head. */
+	shinfo = skb_shinfo(skb);
+	if (unlikely(shinfo->gso_type & SKB_GSO_DODGY)) {
+		int payload = skb->len - hdr_len;
+
+		/* Malicious packet. */
+		if (payload <= 0)
+			return SKB_DROP_REASON_SKB_BAD_GSO;
+		gso_segs = DIV_ROUND_UP(payload, shinfo->gso_size);
 	}
+	qdisc_skb_cb(skb)->pkt_len += (gso_segs - 1) * hdr_len;
+	return SKB_NOT_DROPPED_YET;
 }
 
 static int dev_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *q,
@@ -4407,6 +4420,7 @@ int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	struct Qdisc *q;
 	int rc = -ENOMEM;
 	bool again = false;
+	enum skb_drop_reason reason;
 
 	skb_reset_mac_header(skb);
 	skb_assert_len(skb);
@@ -4414,6 +4428,12 @@ int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_SCHED_TSTAMP))
 		__skb_tstamp_tx(skb, NULL, NULL, skb->sk, SCM_TSTAMP_SCHED);
 
+	reason = qdisc_pkt_len_init(skb);
+	if (unlikely(reason)) {
+		dev_core_stats_tx_dropped_inc(dev);
+		kfree_skb_reason(skb, reason);
+		return -EINVAL;
+	}
 	/* Disable soft irqs for various locks below. Also
 	 * stops preemption for RCU.
 	 */
@@ -4421,7 +4441,6 @@ int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 
 	skb_update_prio(skb);
 
-	qdisc_pkt_len_init(skb);
 	tcx_set_ingress(skb, false);
 #ifdef CONFIG_NET_EGRESS
 	if (static_branch_unlikely(&egress_needed_key)) {
-- 
2.53.0



