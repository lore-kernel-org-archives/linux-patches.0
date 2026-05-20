Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322D238F945;
	Wed, 20 May 2026 16:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294770; cv=none; b=CFuDzvhJkhToGZKrkh4kRgG6WkpAGUkR+NWrFTLj15w4z5DCxS3BTRbn4DOw3bsixXZPsSnx2euGrqsh5FNp829BOgUgdv2GV6H4vfTU/WlGxBFZrNLXdhOgjqy9k0q443/EVhcfAcsswxA30g8eLFr+PtWzS2FlgVwJhAXN62Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294770; c=relaxed/simple;
	bh=7F3fMpfWIbaiFYVsGjmc2Wb/QaT8/fOyBPFqeyeyQg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZB4M64bjKaeJRtg9CEb2/vVw5X8Zuzo/XNOGxd4H4nt3PkwfsBoYOBGIGhmncS4X9Eb8UC/spp3muHphyM7N+Od5mn4i0mPA/d8H08uFx0yH4/ekq5uIrhJBUl9+CaUtUu8OTaIfmT9ozdSURsXuwfR8HYzu5+gznXrtxTqV2z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gh1mX8+5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gh1mX8+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E081F000E9;
	Wed, 20 May 2026 16:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294769;
	bh=cZRUH0OvOJOiNOaWlfdwJk6YPMt1Kk3atA8jiZh4OtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gh1mX8+52RHRXjZv77uOOnEfQ3nN3s/4lpug2Xj0cU8tyoKtvL8frq+nyodLVJu3r
	 y59PYF+6Fh48RQfMlWN5nP+nWKkzKRZbMBL/G44zXYM7ik8iu00W4Fbhh7gNYk10yH
	 ZHInTdKNJne240Q5dwhTgOBEctXmdxro760PYFRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0163/1146] net: pull headers in qdisc_pkt_len_segs_init()
Date: Wed, 20 May 2026 18:06:53 +0200
Message-ID: <20260520162151.982730361@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
 include/net/dropreason-core.h |  3 +++
 net/core/dev.c                | 51 +++++++++++++++++++++--------------
 2 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/include/net/dropreason-core.h b/include/net/dropreason-core.h
index 8e498e8431cbb..880a5ec786cfe 100644
--- a/include/net/dropreason-core.h
+++ b/include/net/dropreason-core.h
@@ -80,6 +80,7 @@
 	FN(UNHANDLED_PROTO)		\
 	FN(SKB_CSUM)			\
 	FN(SKB_GSO_SEG)			\
+	FN(SKB_BAD_GSO)			\
 	FN(SKB_UCOPY_FAULT)		\
 	FN(DEV_HDR)			\
 	FN(DEV_READY)			\
@@ -427,6 +428,8 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_SKB_CSUM,
 	/** @SKB_DROP_REASON_SKB_GSO_SEG: gso segmentation error */
 	SKB_DROP_REASON_SKB_GSO_SEG,
+	/** @SKB_DROP_REASON_SKB_BAD_GSO: malicious gso packet. */
+	SKB_DROP_REASON_SKB_BAD_GSO,
 	/**
 	 * @SKB_DROP_REASON_SKB_UCOPY_FAULT: failed to copy data from user space,
 	 * e.g., via zerocopy_sg_from_iter() or skb_orphan_frags_rx()
diff --git a/net/core/dev.c b/net/core/dev.c
index 44a712f777b79..e4fcf09ba2beb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4103,16 +4103,16 @@ struct sk_buff *validate_xmit_skb_list(struct sk_buff *skb, struct net_device *d
 }
 EXPORT_SYMBOL_GPL(validate_xmit_skb_list);
 
-static void qdisc_pkt_len_segs_init(struct sk_buff *skb)
+static enum skb_drop_reason qdisc_pkt_len_segs_init(struct sk_buff *skb)
 {
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
-	unsigned int hdr_len;
+	unsigned int hdr_len, tlen;
 	u16 gso_segs;
 
 	qdisc_skb_cb(skb)->pkt_len = skb->len;
 	if (!shinfo->gso_size) {
 		qdisc_skb_cb(skb)->pkt_segs = 1;
-		return;
+		return SKB_NOT_DROPPED_YET;
 	}
 
 	qdisc_skb_cb(skb)->pkt_segs = gso_segs = shinfo->gso_segs;
@@ -4120,43 +4120,49 @@ static void qdisc_pkt_len_segs_init(struct sk_buff *skb)
 	/* To get more precise estimation of bytes sent on wire,
 	 * we add to pkt_len the headers size of all segments
 	 */
-	if (unlikely(!skb_transport_header_was_set(skb)))
-		return;
 
 	/* mac layer + network layer */
-	if (!skb->encapsulation)
+	if (!skb->encapsulation) {
+		if (unlikely(!skb_transport_header_was_set(skb)))
+			return SKB_NOT_DROPPED_YET;
 		hdr_len = skb_transport_offset(skb);
-	else
+	} else {
 		hdr_len = skb_inner_transport_offset(skb);
-
+	}
 	/* + transport layer */
 	if (likely(shinfo->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6))) {
 		const struct tcphdr *th;
-		struct tcphdr _tcphdr;
 
-		th = skb_header_pointer(skb, hdr_len,
-					sizeof(_tcphdr), &_tcphdr);
-		if (likely(th))
-			hdr_len += __tcp_hdrlen(th);
-	} else if (shinfo->gso_type & SKB_GSO_UDP_L4) {
-		struct udphdr _udphdr;
+		if (!pskb_may_pull(skb, hdr_len + sizeof(struct tcphdr)))
+			return SKB_DROP_REASON_SKB_BAD_GSO;
 
-		if (skb_header_pointer(skb, hdr_len,
-				       sizeof(_udphdr), &_udphdr))
-			hdr_len += sizeof(struct udphdr);
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
 	}
 
+	/* prior pskb_may_pull() might have changed skb->head. */
+	shinfo = skb_shinfo(skb);
 	if (unlikely(shinfo->gso_type & SKB_GSO_DODGY)) {
 		int payload = skb->len - hdr_len;
 
 		/* Malicious packet. */
 		if (payload <= 0)
-			return;
+			return SKB_DROP_REASON_SKB_BAD_GSO;
 		gso_segs = DIV_ROUND_UP(payload, shinfo->gso_size);
 		shinfo->gso_segs = gso_segs;
 		qdisc_skb_cb(skb)->pkt_segs = gso_segs;
 	}
 	qdisc_skb_cb(skb)->pkt_len += (gso_segs - 1) * hdr_len;
+	return SKB_NOT_DROPPED_YET;
 }
 
 static int dev_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *q,
@@ -4773,6 +4779,12 @@ int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 		     (SKBTX_SCHED_TSTAMP | SKBTX_BPF)))
 		__skb_tstamp_tx(skb, NULL, NULL, skb->sk, SCM_TSTAMP_SCHED);
 
+	reason = qdisc_pkt_len_segs_init(skb);
+	if (unlikely(reason)) {
+		dev_core_stats_tx_dropped_inc(dev);
+		kfree_skb_reason(skb, reason);
+		return -EINVAL;
+	}
 	/* Disable soft irqs for various locks below. Also
 	 * stops preemption for RCU.
 	 */
@@ -4780,7 +4792,6 @@ int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 
 	skb_update_prio(skb);
 
-	qdisc_pkt_len_segs_init(skb);
 	tcx_set_ingress(skb, false);
 #ifdef CONFIG_NET_EGRESS
 	if (static_branch_unlikely(&egress_needed_key)) {
-- 
2.53.0



