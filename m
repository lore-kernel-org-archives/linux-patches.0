Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208599;
	b=Q/R+1BC6QWZzb4RcJajwy6eeFZT7iumPRdCeqGsZkNv/6HI9h/Re2JNk0d2RV6k60xAJ
	 VhlTEMYdpofiyPxQPWwuX2G9Lms/CpQB37st/Y0aW3V6FM4ZRLHuhAXvrWJ2tsmpUR0XS
	 VsqqKB4f8vflkbXFdvr6HvQ+cdHpmNRG8msQ+o1Rs9tGbVAIIHLRlfZAX0lMuMtnBM6uI
	 P1Nwj78d6BHv3VUxpjQL0KciFsuQq7tid70v4WB6Qhr2+5vVTD8jv6DclFoAsz3bO7Qup
	 eORu4vnmH4L9i6aDuMMilgzPW8QN35hS70tbES23GkJRISxjza+KWmWeaT89iF8w9vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BPIT9HNVxl9xCq18DA4VognHezSVLZlh5jYiQ9tidWc=;
	b=lSgr+H3DE87y82el7NWcso1oF1NxJ8q4hDzepI8/IPfQ/Xi2AcdjHwBooX6fpshp7oFv
	 3oibW2BPP2KhWZDI9r/GS2ptDgDlzolUfcIxhoKL285OkWFSz7r3Bf6/u8dRZj43HF/i5
	 PalPvCBvQCZ/qAj4Lsdo2pTWjOlJ4mZvS3fdviHlqKFGMmBJ1iNBGN6Iux4YILqXgAOGl
	 T5htLUqOo1zGurIgC2bNxKqRiFotc1uf/70HiltPxPDfaJR0gJQC+UBKKm6SntufNQIxV
	 YL3Qin+wo0Gn5oxhbljW7kCPNktSanXnF0qFXSMQWPew8R/TSr5xcqX0S/OaiQDTqpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s8jGhMpx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2B8606A31E;
	Wed, 28 Oct 2026 17:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s8jGhMpx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A571F01825;
	Wed, 28 Oct 2026 17:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208599;
	bh=BPIT9HNVxl9xCq18DA4VognHezSVLZlh5jYiQ9tidWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s8jGhMpxTPIP3YSs3W703KHVEeSsGBXbb+9f986HXIxVnPBJLTlcK3eH4gdhM48xT
	 j3v/BW04RSPlGZO/VUQw8583bxn2VSunc38On9cBb6XbNbe7je+MsgvJAeo72Znicw
	 znt/Sqm8wtV4lOoMSQbhQF5gh6a34JNDUqS40u0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 175/516] netfilter: nf_tables: avoid skb access on nf_stolen
Date: Wed, 28 Oct 2026 17:55:27 +0100
Message-ID: <20261028170007.651997989@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit e34b9ed96ce3b06c79bf884009b16961ca478f87 ]

When verdict is NF_STOLEN, the skb might have been freed.

When tracing is enabled, this can result in a use-after-free:
1. access to skb->nf_trace
2. access to skb->mark
3. computation of trace id
4. dump of packet payload

To avoid 1, keep a cached copy of skb->nf_trace in the
trace state struct.
Refresh this copy whenever verdict is != STOLEN.

Avoid 2 by skipping skb->mark access if verdict is STOLEN.

3 is avoided by precomputing the trace id.

Only dump the packet when verdict is not "STOLEN".

Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 8ec454dcd00c ("ipv6: sr: use skb_get_hash_net() in seg6_make_flowlabel()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h | 16 ++++++-----
 net/netfilter/nf_tables_core.c    | 24 ++++++++++++++---
 net/netfilter/nf_tables_trace.c   | 44 +++++++++++++++++--------------
 3 files changed, 55 insertions(+), 29 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9a582fe5b21f3..8d08346fd8dcf 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1297,24 +1297,28 @@ void nft_unregister_flowtable_type(struct nf_flowtable_type *type);
 /**
  *	struct nft_traceinfo - nft tracing information and state
  *
+ *	@trace: other struct members are initialised
+ *	@nf_trace: copy of skb->nf_trace before rule evaluation
+ *	@type: event type (enum nft_trace_types)
+ *	@skbid: hash of skb to be used as trace id
+ *	@packet_dumped: packet headers sent in a previous traceinfo message
  *	@pkt: pktinfo currently processed
  *	@basechain: base chain currently processed
  *	@chain: chain currently processed
  *	@rule:  rule that was evaluated
  *	@verdict: verdict given by rule
- *	@type: event type (enum nft_trace_types)
- *	@packet_dumped: packet headers sent in a previous traceinfo message
- *	@trace: other struct members are initialised
  */
 struct nft_traceinfo {
+	bool				trace;
+	bool				nf_trace;
+	bool				packet_dumped;
+	enum nft_trace_types		type:8;
+	u32				skbid;
 	const struct nft_pktinfo	*pkt;
 	const struct nft_base_chain	*basechain;
 	const struct nft_chain		*chain;
 	const struct nft_rule		*rule;
 	const struct nft_verdict	*verdict;
-	enum nft_trace_types		type;
-	bool				packet_dumped;
-	bool				trace;
 };
 
 void nft_trace_init(struct nft_traceinfo *info, const struct nft_pktinfo *pkt,
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index b0d711d498c66..cc6504628a759 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -25,9 +25,7 @@ static noinline void __nft_trace_packet(struct nft_traceinfo *info,
 					const struct nft_chain *chain,
 					enum nft_trace_types type)
 {
-	const struct nft_pktinfo *pkt = info->pkt;
-
-	if (!info->trace || !pkt->skb->nf_trace)
+	if (!info->trace || !info->nf_trace)
 		return;
 
 	info->chain = chain;
@@ -42,11 +40,24 @@ static inline void nft_trace_packet(struct nft_traceinfo *info,
 				    enum nft_trace_types type)
 {
 	if (static_branch_unlikely(&nft_trace_enabled)) {
+		const struct nft_pktinfo *pkt = info->pkt;
+
+		info->nf_trace = pkt->skb->nf_trace;
 		info->rule = rule;
 		__nft_trace_packet(info, chain, type);
 	}
 }
 
+static inline void nft_trace_copy_nftrace(struct nft_traceinfo *info)
+{
+	if (static_branch_unlikely(&nft_trace_enabled)) {
+		const struct nft_pktinfo *pkt = info->pkt;
+
+		if (info->trace)
+			info->nf_trace = pkt->skb->nf_trace;
+	}
+}
+
 static void nft_bitwise_fast_eval(const struct nft_expr *expr,
 				  struct nft_regs *regs)
 {
@@ -85,6 +96,7 @@ static noinline void __nft_trace_verdict(struct nft_traceinfo *info,
 					 const struct nft_chain *chain,
 					 const struct nft_regs *regs)
 {
+	const struct nft_pktinfo *pkt = info->pkt;
 	enum nft_trace_types type;
 
 	switch (regs->verdict.code) {
@@ -92,8 +104,13 @@ static noinline void __nft_trace_verdict(struct nft_traceinfo *info,
 	case NFT_RETURN:
 		type = NFT_TRACETYPE_RETURN;
 		break;
+	case NF_STOLEN:
+		type = NFT_TRACETYPE_RULE;
+		/* can't access skb->nf_trace; use copy */
+		break;
 	default:
 		type = NFT_TRACETYPE_RULE;
+		info->nf_trace = pkt->skb->nf_trace;
 		break;
 	}
 
@@ -244,6 +261,7 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		switch (regs.verdict.code) {
 		case NFT_BREAK:
 			regs.verdict.code = NFT_CONTINUE;
+			nft_trace_copy_nftrace(&info);
 			continue;
 		case NFT_CONTINUE:
 			nft_trace_packet(&info, chain, rule,
diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index e4fe2f0780eb6..edf8cbb6757cb 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -7,7 +7,7 @@
 #include <linux/module.h>
 #include <linux/static_key.h>
 #include <linux/hash.h>
-#include <linux/jhash.h>
+#include <linux/siphash.h>
 #include <linux/if_vlan.h>
 #include <linux/init.h>
 #include <linux/skbuff.h>
@@ -25,22 +25,6 @@
 DEFINE_STATIC_KEY_FALSE(nft_trace_enabled);
 EXPORT_SYMBOL_GPL(nft_trace_enabled);
 
-static int trace_fill_id(struct sk_buff *nlskb, struct sk_buff *skb)
-{
-	__be32 id;
-
-	/* using skb address as ID results in a limited number of
-	 * values (and quick reuse).
-	 *
-	 * So we attempt to use as many skb members that will not
-	 * change while skb is with netfilter.
-	 */
-	id = (__be32)jhash_2words(hash32_ptr(skb), skb_get_hash(skb),
-				  skb->skb_iif);
-
-	return nla_put_be32(nlskb, NFTA_TRACE_ID, id);
-}
-
 static int trace_fill_header(struct sk_buff *nlskb, u16 type,
 			     const struct sk_buff *skb,
 			     int off, unsigned int len)
@@ -186,6 +170,7 @@ void nft_trace_notify(struct nft_traceinfo *info)
 	struct nlmsghdr *nlh;
 	struct sk_buff *skb;
 	unsigned int size;
+	u32 mark = 0;
 	u16 event;
 
 	if (!nfnetlink_has_listeners(nft_net(pkt), NFNLGRP_NFTRACE))
@@ -229,7 +214,7 @@ void nft_trace_notify(struct nft_traceinfo *info)
 	if (nla_put_be32(skb, NFTA_TRACE_TYPE, htonl(info->type)))
 		goto nla_put_failure;
 
-	if (trace_fill_id(skb, pkt->skb))
+	if (nla_put_u32(skb, NFTA_TRACE_ID, info->skbid))
 		goto nla_put_failure;
 
 	if (nla_put_string(skb, NFTA_TRACE_CHAIN, info->chain->name))
@@ -249,16 +234,24 @@ void nft_trace_notify(struct nft_traceinfo *info)
 	case NFT_TRACETYPE_RULE:
 		if (nft_verdict_dump(skb, NFTA_TRACE_VERDICT, info->verdict))
 			goto nla_put_failure;
+
+		/* pkt->skb undefined iff NF_STOLEN, disable dump */
+		if (info->verdict->code == NF_STOLEN)
+			info->packet_dumped = true;
+		else
+			mark = pkt->skb->mark;
+
 		break;
 	case NFT_TRACETYPE_POLICY:
+		mark = pkt->skb->mark;
+
 		if (nla_put_be32(skb, NFTA_TRACE_POLICY,
 				 htonl(info->basechain->policy)))
 			goto nla_put_failure;
 		break;
 	}
 
-	if (pkt->skb->mark &&
-	    nla_put_be32(skb, NFTA_TRACE_MARK, htonl(pkt->skb->mark)))
+	if (mark && nla_put_be32(skb, NFTA_TRACE_MARK, htonl(mark)))
 		goto nla_put_failure;
 
 	if (!info->packet_dumped) {
@@ -283,9 +276,20 @@ void nft_trace_init(struct nft_traceinfo *info, const struct nft_pktinfo *pkt,
 		    const struct nft_verdict *verdict,
 		    const struct nft_chain *chain)
 {
+	static siphash_key_t trace_key __read_mostly;
+	struct sk_buff *skb = pkt->skb;
+
 	info->basechain = nft_base_chain(chain);
 	info->trace = true;
+	info->nf_trace = pkt->skb->nf_trace;
 	info->packet_dumped = false;
 	info->pkt = pkt;
 	info->verdict = verdict;
+
+	net_get_random_once(&trace_key, sizeof(trace_key));
+
+	info->skbid = (u32)siphash_3u32(hash32_ptr(skb),
+					skb_get_hash(skb),
+					skb->skb_iif,
+					&trace_key);
 }
-- 
2.53.0



