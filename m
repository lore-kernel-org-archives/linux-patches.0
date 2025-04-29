Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9CC78F58;
	Tue, 29 Apr 2025 17:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947751; cv=none; b=Iid6PGVmel+AhvmEGNondKU4CzUkCHNlAKHs90jAyIW3B5eTd9FwziAExQPRLd7IrqAFDxg2mjzg2RTy6PeGjbK4TXG7iSdx1OOevfgZI0boEPRiD7E38khe9iLja1ZP2Bh8ZeRIx/ja9XZuFhOfjuZiu/SHFaEQvQiFgjHS3+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947751; c=relaxed/simple;
	bh=K0LBvZrDu1HuikThZ+G9jY08VLn/8g6QFhOcWQgBfDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIzqgTSF3BAiSwlCELgwgd67udxysWg3iO4kqq27Gdilg7x/S+lGcExNRqst7NqmKUdFfvVFUqEEQdZlDikMQk1dzETcdAXgx+tny4FKPCMK2JtqaKzRh6B3axE5aVqtWRWj1qQJ18Gsx023wBo7gSeKzqi//T480bbyGbxsa7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jp8jzL+M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jp8jzL+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54ADC4CEE9;
	Tue, 29 Apr 2025 17:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947751;
	bh=K0LBvZrDu1HuikThZ+G9jY08VLn/8g6QFhOcWQgBfDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jp8jzL+MWgvqEII6DK7ZM7mTuO1kc7rsozCI4x87JYZ+BZmGDn1Z97g6mofph4TAq
	 Q2YvpXZPSKaslIpxwDMKOXtgc+r1SjdJ3XVl87NSbvrXZUePT6O+Vz+Y4jkG1D0LeB
	 RLNSrW67JGLJIKFmxpNdK87sfX7cyZ0nj3sOz3bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.12 093/280] netfilter: fib: avoid lookup if socket is available
Date: Tue, 29 Apr 2025 18:40:34 +0200
Message-ID: <20250429161118.912386855@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit eaaff9b6702e99be5d79135f2afa9fc48a0d59e0 upstream.

In case the fib match is used from the input hook we can avoid the fib
lookup if early demux assigned a socket for us: check that the input
interface matches sk-cached one.

Rework the existing 'lo bypass' logic to first check sk, then
for loopback interface type to elide the fib lookup.

This speeds up fib matching a little, before:
93.08 GBit/s (no rules at all)
75.1  GBit/s ("fib saddr . iif oif missing drop" in prerouting)
75.62 GBit/s ("fib saddr . iif oif missing drop" in input)

After:
92.48 GBit/s (no rules at all)
75.62 GBit/s (fib rule in prerouting)
90.37 GBit/s (fib rule in input).

Numbers for the 'no rules' and 'prerouting' are expected to
closely match in-between runs, the 3rd/input test case exercises the
the 'avoid lookup if cached ifindex in sk matches' case.

Test used iperf3 via veth interface, lo can't be used due to existing
loopback test.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nft_fib.h   |   21 +++++++++++++++++++++
 net/ipv4/netfilter/nft_fib_ipv4.c |   11 +++++------
 net/ipv6/netfilter/nft_fib_ipv6.c |   19 ++++++++++---------
 3 files changed, 36 insertions(+), 15 deletions(-)

--- a/include/net/netfilter/nft_fib.h
+++ b/include/net/netfilter/nft_fib.h
@@ -18,6 +18,27 @@ nft_fib_is_loopback(const struct sk_buff
 	return skb->pkt_type == PACKET_LOOPBACK || in->flags & IFF_LOOPBACK;
 }
 
+static inline bool nft_fib_can_skip(const struct nft_pktinfo *pkt)
+{
+	const struct net_device *indev = nft_in(pkt);
+	const struct sock *sk;
+
+	switch (nft_hook(pkt)) {
+	case NF_INET_PRE_ROUTING:
+	case NF_INET_INGRESS:
+	case NF_INET_LOCAL_IN:
+		break;
+	default:
+		return false;
+	}
+
+	sk = pkt->skb->sk;
+	if (sk && sk_fullsock(sk))
+	       return sk->sk_rx_dst_ifindex == indev->ifindex;
+
+	return nft_fib_is_loopback(pkt->skb, indev);
+}
+
 int nft_fib_dump(struct sk_buff *skb, const struct nft_expr *expr, bool reset);
 int nft_fib_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		 const struct nlattr * const tb[]);
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -70,6 +70,11 @@ void nft_fib4_eval(const struct nft_expr
 	const struct net_device *oif;
 	const struct net_device *found;
 
+	if (nft_fib_can_skip(pkt)) {
+		nft_fib_store_result(dest, priv, nft_in(pkt));
+		return;
+	}
+
 	/*
 	 * Do not set flowi4_oif, it restricts results (for example, asking
 	 * for oif 3 will get RTN_UNICAST result even if the daddr exits
@@ -84,12 +89,6 @@ void nft_fib4_eval(const struct nft_expr
 	else
 		oif = NULL;
 
-	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
-	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
-		nft_fib_store_result(dest, priv, nft_in(pkt));
-		return;
-	}
-
 	iph = skb_header_pointer(pkt->skb, noff, sizeof(_iph), &_iph);
 	if (!iph) {
 		regs->verdict.code = NFT_BREAK;
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -170,6 +170,11 @@ void nft_fib6_eval(const struct nft_expr
 	struct rt6_info *rt;
 	int lookup_flags;
 
+	if (nft_fib_can_skip(pkt)) {
+		nft_fib_store_result(dest, priv, nft_in(pkt));
+		return;
+	}
+
 	if (priv->flags & NFTA_FIB_F_IIF)
 		oif = nft_in(pkt);
 	else if (priv->flags & NFTA_FIB_F_OIF)
@@ -181,17 +186,13 @@ void nft_fib6_eval(const struct nft_expr
 		return;
 	}
 
-	lookup_flags = nft_fib6_flowi_init(&fl6, priv, pkt, oif, iph);
-
-	if (nft_hook(pkt) == NF_INET_PRE_ROUTING ||
-	    nft_hook(pkt) == NF_INET_INGRESS) {
-		if (nft_fib_is_loopback(pkt->skb, nft_in(pkt)) ||
-		    nft_fib_v6_skip_icmpv6(pkt->skb, pkt->tprot, iph)) {
-			nft_fib_store_result(dest, priv, nft_in(pkt));
-			return;
-		}
+	if (nft_fib_v6_skip_icmpv6(pkt->skb, pkt->tprot, iph)) {
+		nft_fib_store_result(dest, priv, nft_in(pkt));
+		return;
 	}
 
+	lookup_flags = nft_fib6_flowi_init(&fl6, priv, pkt, oif, iph);
+
 	*dest = 0;
 	rt = (void *)ip6_route_lookup(nft_net(pkt), &fl6, pkt->skb,
 				      lookup_flags);


