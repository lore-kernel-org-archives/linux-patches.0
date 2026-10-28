Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210888;
	b=ACAO96+J/kWBUFW3/iP5vPew7u6iQ3dxZR50bf97xbK/UBdZDcw9mgdIOZLANLc0pqiv
	 iiYhpQ+c1b+BBLA8fODTq/Ry5ug/YU/er+ZbpH5MXd/+IJwfLv9JjoIcC3hcPI5iT8ZIF
	 Nb7T+k5vQcGWIo4L0bzYbd3OjvdTivvqQe/KJCzbp06Uj/y8EKTkuVqgwzultuWV/zgGF
	 XvmJ+YnsV5nJ/MD2cZ2wajpSRJddj84WuWwKxaFu1eQe99yb2ysUVkD6Iy4M4QkDkTAr3
	 RZkUnqOyFZbrJ2AsTBxw+zYu7zEj2Q3jsdeJWf5NK62x7vpNLoWWfAv6UgEcCfKw31w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210888;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=POh4Ai9CCnh9IM8RDjz8MRUROdF1JxhgrQcd47I7HBM=;
	b=k2T4WvM89VsQLfdhEodKvSDdayyeCRwVUhT9dWnDuDGWRV/JUDTsBeLFV48p9/Szxx8a
	 paG/lnP0kUz+l9v3ibin/Od7a7vq/vkXUWL26/koNfg5zYcIAmLY3OUWy8DLO5Y4Rrtj3
	 2VPg6miiVnaKIJMRMUIYhaRCPHSrhLf69ENeLi37RMDYWznpj2COpmRfhQ63ns0FU6BCO
	 HYkqjgFDsr6p4OvnyarZ3gnnwRwSVIVM7ysdSu/pygnCEEAdN78QKrMjByJT1eaKbYXb5
	 sexc30t9zIzB6Rq0VW0QCwFJG9OslCep2LH14xeUeigR5emouBCl/EZGyy9wub9T4og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="CuxE/evE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29393606A31C;
	Wed, 28 Oct 2026 18:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CuxE/evE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F091F01825;
	Wed, 28 Oct 2026 18:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210888;
	bh=POh4Ai9CCnh9IM8RDjz8MRUROdF1JxhgrQcd47I7HBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CuxE/evEyavGpbNj0w61lFhDzVlmU1p47h+iuhVXsSHUME6+WXipe+8E7dO0CM/zW
	 RqIiXklSNJzH5tdibwaY1GLzv/sQsbcIT8ibHuRbmYjEJ75y51vlAKasGUsIXaJY9Z
	 lUTKZHzgTwVwMcEJbnMYiaH0XK9gCAGnlcXTYzNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 185/571] netfilter: nf_tables: avoid skb access on nf_stolen
Date: Wed, 28 Oct 2026 17:55:32 +0100
Message-ID: <20261028170012.400673825@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index be271c66329e8..e05e2d85f67b2 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1373,24 +1373,28 @@ void nft_unregister_flowtable_type(struct nf_flowtable_type *type);
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
index 2ab4216d2a903..4ee62c0da1b31 100644
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
index 84a7dea46efae..ed4b067bfb6af 100644
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



