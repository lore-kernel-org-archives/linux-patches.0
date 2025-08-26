Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C5634DCDA;
	Tue, 26 Aug 2025 14:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218439; cv=none; b=MWrJC6Xu6CQtXlS+J1vylXsIzvAx6dkdk9Flo8a4Te5/hWvznDKakFsXLxPmGExWUIq7N0hQ+aaa5NEemZdRuI4MIesUeWxCWOJOT/TyQPD6zKbP0t0Fn0W5hEtF4DbStJxadLUpRDETfGBcj0meGBCBP876NAV8lRoFflPuZJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218439; c=relaxed/simple;
	bh=OGgLaBDo/HMDGIkh/B4gNMONaOALpWYuE/8Gsyb3b48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njsxDC8bJUeKy8DmyE8q/CrtSYkuV8gLvn6+ujq55fbY7g2iE04XQFKFKj5WVL0ZZF6cHgSgZuc+WVKVIcrxNrvQAiKElOk2UxlAt6+PZWVFlAraNCEwaO/aKXC9cRuCSP4Q/7Q8e6XXSMzVc/uvy736PAqfhX3XbgopLGTI1Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+g85wFn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+g85wFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BAE5C4CEF1;
	Tue, 26 Aug 2025 14:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218439;
	bh=OGgLaBDo/HMDGIkh/B4gNMONaOALpWYuE/8Gsyb3b48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+g85wFnnX0lOybwaxZ9FNAIpHN0ZRK6oBeD72BpchxzL6YQ+r6SZoEla7Uc17bBm
	 9LUZmjAOk6z8U82DKLGCbHha9fShyAvYV3AbQMEqBEtR1w6+DQl7c1VU2pp41bQy3r
	 Rk++AWxyPmVFlNazFCIhuMdaDeRcBWI6wZekIF7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 522/523] netfilter: nft_reject_inet: allow to use reject from inet ingress
Date: Tue, 26 Aug 2025 13:12:12 +0200
Message-ID: <20250826110937.315767952@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 117ca1f8920cf4087bf82f44bd2a51b49d6aae63 ]

Enhance validation to support for reject from inet ingress chains.

Note that, reject from inet ingress and netdev ingress differ.

Reject packets from inet ingress are sent through ip_local_out() since
inet reject emulates the IP layer receive path. So the reject packet
follows to classic IP output and postrouting paths.

The reject action from netdev ingress assumes the packet not yet entered
the IP layer, so the reject packet is sent through dev_queue_xmit().
Therefore, reject packets from netdev ingress do not follow the classic
IP output and postrouting paths.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 91a79b792204 ("netfilter: nf_reject: don't leak dst refcount for loopback packets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/nf_reject_ipv4.c |  6 ++++--
 net/ipv6/netfilter/nf_reject_ipv6.c |  5 +++--
 net/netfilter/nft_reject_inet.c     | 14 +++++++++++++-
 3 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index efe14a6a5d9b..d232e0251142 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -125,7 +125,8 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	if (!oth)
 		return;
 
-	if (hook == NF_INET_PRE_ROUTING && nf_reject_fill_skb_dst(oldskb))
+	if ((hook == NF_INET_PRE_ROUTING || hook == NF_INET_INGRESS) &&
+	    nf_reject_fill_skb_dst(oldskb) < 0)
 		return;
 
 	if (skb_rtable(oldskb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
@@ -193,7 +194,8 @@ void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
 	if (iph->frag_off & htons(IP_OFFSET))
 		return;
 
-	if (hook == NF_INET_PRE_ROUTING && nf_reject_fill_skb_dst(skb_in))
+	if ((hook == NF_INET_PRE_ROUTING || hook == NF_INET_INGRESS) &&
+	    nf_reject_fill_skb_dst(skb_in) < 0)
 		return;
 
 	if (skb_csum_unnecessary(skb_in) || !nf_reject_verify_csum(proto)) {
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index df572724f254..b396559f68b4 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -161,7 +161,7 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	fl6.fl6_sport = otcph->dest;
 	fl6.fl6_dport = otcph->source;
 
-	if (hook == NF_INET_PRE_ROUTING) {
+	if (hook == NF_INET_PRE_ROUTING || hook == NF_INET_INGRESS) {
 		nf_ip6_route(net, &dst, flowi6_to_flowi(&fl6), false);
 		if (!dst)
 			return;
@@ -259,7 +259,8 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
 	if (hooknum == NF_INET_LOCAL_OUT && skb_in->dev == NULL)
 		skb_in->dev = net->loopback_dev;
 
-	if (hooknum == NF_INET_PRE_ROUTING && nf_reject6_fill_skb_dst(skb_in))
+	if ((hooknum == NF_INET_PRE_ROUTING || hooknum == NF_INET_INGRESS) &&
+	    nf_reject6_fill_skb_dst(skb_in) < 0)
 		return;
 
 	icmpv6_send(skb_in, ICMPV6_DEST_UNREACH, code, 0);
diff --git a/net/netfilter/nft_reject_inet.c b/net/netfilter/nft_reject_inet.c
index 115aa446f6d5..554caf967baa 100644
--- a/net/netfilter/nft_reject_inet.c
+++ b/net/netfilter/nft_reject_inet.c
@@ -60,6 +60,18 @@ static void nft_reject_inet_eval(const struct nft_expr *expr,
 	regs->verdict.code = NF_DROP;
 }
 
+static int nft_reject_inet_validate(const struct nft_ctx *ctx,
+				    const struct nft_expr *expr,
+				    const struct nft_data **data)
+{
+	return nft_chain_validate_hooks(ctx->chain,
+					(1 << NF_INET_LOCAL_IN) |
+					(1 << NF_INET_FORWARD) |
+					(1 << NF_INET_LOCAL_OUT) |
+					(1 << NF_INET_PRE_ROUTING) |
+					(1 << NF_INET_INGRESS));
+}
+
 static struct nft_expr_type nft_reject_inet_type;
 static const struct nft_expr_ops nft_reject_inet_ops = {
 	.type		= &nft_reject_inet_type,
@@ -67,7 +79,7 @@ static const struct nft_expr_ops nft_reject_inet_ops = {
 	.eval		= nft_reject_inet_eval,
 	.init		= nft_reject_init,
 	.dump		= nft_reject_dump,
-	.validate	= nft_reject_validate,
+	.validate	= nft_reject_inet_validate,
 };
 
 static struct nft_expr_type nft_reject_inet_type __read_mostly = {
-- 
2.50.1



