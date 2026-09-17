Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8516737EFFB;
	Thu, 17 Sep 2026 18:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671454; cv=none; b=dRPoY2hoU2SovZ/a3jS3aKPNwHsXD+OFR7BU7VKAp6zFhzWXux7CMKF9xNryYUqRSOftySNfJmcg4/bfT1vdlTUXzI1WIlCrcYa4EdB1lu5vGmwwC7pDV998RfVjbWBog+d2yyJY2lvzb5GwdxHQ7M+6n/PyqPW27cql5OFv370=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671454; c=relaxed/simple;
	bh=QanIg/rBKTMPuonhSmdewq83HYR9EHdoBbfFD0yfxAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/z8OjPBb89OKQS8H0xNgrlRnUOZdXGtVY5eku8w5bbzmlAi2HUDXQTt9S5QCuNkc8qf6TifZUWqAyYZmkcluwIXgvWj2vwpmdKqPp/1k0CQAqjYpoqjjfH6CPFpC6f68WJa42dkVWP2IAzkAJOuc8H3mp+xCP+YRKBwfkOnDis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l9ne5FmX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l9ne5FmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D041F000FF;
	Thu, 17 Sep 2026 18:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671453;
	bh=4Bfvl8EnAgU+LSxOVC5esPTf0CCXsO+afWw1T2f2rZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l9ne5FmXF6T9m5LlrZo3l6OnQcFkZcdHnk7cVNsRJAjVaCkAPV1ck0gRNVKBmqW+U
	 xiVkx+nSTHhROiW5F1faedvmZGaXfrO6ytSuJIsO1bqhG7vnSB9sHrngPIj4m/UeIu
	 np9ffts+kmYrVZUs5APvYTdZ3PccknHhzsl8fLok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0964/1102] ipv6: pass proto by value to ipv6_push_nfrag_opts() and ipv6_push_frag_opts()
Date: Thu, 17 Sep 2026 16:15:07 +0100
Message-ID: <20260917151604.871584226@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 1bc46dd209667346c5aa56c351995e7c260696d0 ]

With CONFIG_STACKPROTECTOR_STRONG=y, it is better to avoid passing
a pointer to an automatic variable.

Change these exported functions to return 'u8 proto'
instead of void.

- ipv6_push_nfrag_opts()
- ipv6_push_frag_opts()

For instance, replace
	ipv6_push_frag_opts(skb, opt, &proto);
with:
	proto = ipv6_push_frag_opts(skb, opt, proto);

Note that even after this change, ip6_xmit() has to use a stack canary
because of @first_hop variable.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260130210303.3888261-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 870a9e42ecc6 ("tcp: clamp route advmss to TCP_MIN_MSS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ipv6.h    |   10 ++++-----
 net/ipv6/exthdrs.c    |   55 ++++++++++++++++++++++++++------------------------
 net/ipv6/ip6_output.c |   19 ++++++++++-------
 net/ipv6/ip6_tunnel.c |    2 -
 4 files changed, 46 insertions(+), 40 deletions(-)

--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1142,11 +1142,11 @@ int ip6_local_out(struct net *net, struc
  *	Extension header (options) processing
  */
 
-void ipv6_push_nfrag_opts(struct sk_buff *skb, struct ipv6_txoptions *opt,
-			  u8 *proto, struct in6_addr **daddr_p,
-			  struct in6_addr *saddr);
-void ipv6_push_frag_opts(struct sk_buff *skb, struct ipv6_txoptions *opt,
-			 u8 *proto);
+u8 ipv6_push_nfrag_opts(struct sk_buff *skb, struct ipv6_txoptions *opt,
+			u8 proto, struct in6_addr **daddr_p,
+			struct in6_addr *saddr);
+u8 ipv6_push_frag_opts(struct sk_buff *skb, struct ipv6_txoptions *opt,
+		       u8 proto);
 
 int ipv6_skip_exthdr(const struct sk_buff *, int start, u8 *nexthdrp,
 		     __be16 *frag_offp);
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -1103,9 +1103,9 @@ fail_and_free:
  *	for headers.
  */
 
-static void ipv6_push_rthdr0(struct sk_buff *skb, u8 *proto,
-			     struct ipv6_rt_hdr *opt,
-			     struct in6_addr **addr_p, struct in6_addr *saddr)
+static u8 ipv6_push_rthdr0(struct sk_buff *skb, u8 proto,
+			   struct ipv6_rt_hdr *opt,
+			   struct in6_addr **addr_p, struct in6_addr *saddr)
 {
 	struct rt0_hdr *phdr, *ihdr;
 	int hops;
@@ -1124,13 +1124,13 @@ static void ipv6_push_rthdr0(struct sk_b
 	phdr->addr[hops - 1] = **addr_p;
 	*addr_p = ihdr->addr;
 
-	phdr->rt_hdr.nexthdr = *proto;
-	*proto = NEXTHDR_ROUTING;
+	phdr->rt_hdr.nexthdr = proto;
+	return NEXTHDR_ROUTING;
 }
 
-static void ipv6_push_rthdr4(struct sk_buff *skb, u8 *proto,
-			     struct ipv6_rt_hdr *opt,
-			     struct in6_addr **addr_p, struct in6_addr *saddr)
+static u8 ipv6_push_rthdr4(struct sk_buff *skb, u8 proto,
+			   struct ipv6_rt_hdr *opt,
+			   struct in6_addr **addr_p, struct in6_addr *saddr)
 {
 	struct ipv6_sr_hdr *sr_phdr, *sr_ihdr;
 	int plen, hops;
@@ -1173,58 +1173,61 @@ static void ipv6_push_rthdr4(struct sk_b
 	}
 #endif
 
-	sr_phdr->nexthdr = *proto;
-	*proto = NEXTHDR_ROUTING;
+	sr_phdr->nexthdr = proto;
+	return NEXTHDR_ROUTING;
 }
 
-static void ipv6_push_rthdr(struct sk_buff *skb, u8 *proto,
-			    struct ipv6_rt_hdr *opt,
-			    struct in6_addr **addr_p, struct in6_addr *saddr)
+static u8 ipv6_push_rthdr(struct sk_buff *skb, u8 proto,
+			  struct ipv6_rt_hdr *opt,
+			  struct in6_addr **addr_p, struct in6_addr *saddr)
 {
 	switch (opt->type) {
 	case IPV6_SRCRT_TYPE_0:
 	case IPV6_SRCRT_STRICT:
 	case IPV6_SRCRT_TYPE_2:
-		ipv6_push_rthdr0(skb, proto, opt, addr_p, saddr);
+		proto = ipv6_push_rthdr0(skb, proto, opt, addr_p, saddr);
 		break;
 	case IPV6_SRCRT_TYPE_4:
-		ipv6_push_rthdr4(skb, proto, opt, addr_p, saddr);
+		proto = ipv6_push_rthdr4(skb, proto, opt, addr_p, saddr);
 		break;
 	default:
 		break;
 	}
+	return proto;
 }
 
-static void ipv6_push_exthdr(struct sk_buff *skb, u8 *proto, u8 type, struct ipv6_opt_hdr *opt)
+static u8 ipv6_push_exthdr(struct sk_buff *skb, u8 proto, u8 type, struct ipv6_opt_hdr *opt)
 {
 	struct ipv6_opt_hdr *h = skb_push(skb, ipv6_optlen(opt));
 
 	memcpy(h, opt, ipv6_optlen(opt));
-	h->nexthdr = *proto;
-	*proto = type;
+	h->nexthdr = proto;
+	return type;
 }
 
-void ipv6_push_nfrag_opts(struct sk_buff *skb, struct ipv6_txoptions *opt,
-			  u8 *proto,
-			  struct in6_addr **daddr, struct in6_addr *saddr)
+u8 ipv6_push_nfrag_opts(struct sk_buff *skb, struct ipv6_txoptions *opt,
+			u8 proto,
+			struct in6_addr **daddr, struct in6_addr *saddr)
 {
 	if (opt->srcrt) {
-		ipv6_push_rthdr(skb, proto, opt->srcrt, daddr, saddr);
+		proto = ipv6_push_rthdr(skb, proto, opt->srcrt, daddr, saddr);
 		/*
 		 * IPV6_RTHDRDSTOPTS is ignored
 		 * unless IPV6_RTHDR is set (RFC3542).
 		 */
 		if (opt->dst0opt)
-			ipv6_push_exthdr(skb, proto, NEXTHDR_DEST, opt->dst0opt);
+			proto = ipv6_push_exthdr(skb, proto, NEXTHDR_DEST, opt->dst0opt);
 	}
 	if (opt->hopopt)
-		ipv6_push_exthdr(skb, proto, NEXTHDR_HOP, opt->hopopt);
+		proto = ipv6_push_exthdr(skb, proto, NEXTHDR_HOP, opt->hopopt);
+	return proto;
 }
 
-void ipv6_push_frag_opts(struct sk_buff *skb, struct ipv6_txoptions *opt, u8 *proto)
+u8 ipv6_push_frag_opts(struct sk_buff *skb, struct ipv6_txoptions *opt, u8 proto)
 {
 	if (opt->dst1opt)
-		ipv6_push_exthdr(skb, proto, NEXTHDR_DEST, opt->dst1opt);
+		proto = ipv6_push_exthdr(skb, proto, NEXTHDR_DEST, opt->dst1opt);
+	return proto;
 }
 EXPORT_SYMBOL(ipv6_push_frag_opts);
 
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -305,11 +305,12 @@ int ip6_xmit(const struct sock *sk, stru
 		seg_len += opt->opt_nflen + opt->opt_flen;
 
 		if (opt->opt_flen)
-			ipv6_push_frag_opts(skb, opt, &proto);
+			proto = ipv6_push_frag_opts(skb, opt, proto);
 
 		if (opt->opt_nflen)
-			ipv6_push_nfrag_opts(skb, opt, &proto, &first_hop,
-					     &fl6->saddr);
+			proto = ipv6_push_nfrag_opts(skb, opt, proto,
+						     &first_hop,
+						     &fl6->saddr);
 	}
 
 	if (unlikely(seg_len > IPV6_MAXPLEN)) {
@@ -1929,11 +1930,13 @@ struct sk_buff *__ip6_make_skb(struct so
 	__skb_pull(skb, skb_network_header_len(skb));
 
 	final_dst = &fl6->daddr;
-	if (opt && opt->opt_flen)
-		ipv6_push_frag_opts(skb, opt, &proto);
-	if (opt && opt->opt_nflen)
-		ipv6_push_nfrag_opts(skb, opt, &proto, &final_dst, &fl6->saddr);
-
+	if (opt) {
+		if (opt->opt_flen)
+			proto = ipv6_push_frag_opts(skb, opt, proto);
+		if (opt->opt_nflen)
+			proto = ipv6_push_nfrag_opts(skb, opt, proto,
+						     &final_dst, &fl6->saddr);
+	}
 	skb_push(skb, sizeof(struct ipv6hdr));
 	skb_reset_network_header(skb);
 	hdr = ipv6_hdr(skb);
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1262,7 +1262,7 @@ route_lookup:
 
 	if (encap_limit >= 0) {
 		init_tel_txopt(&opt, encap_limit);
-		ipv6_push_frag_opts(skb, &opt.ops, &proto);
+		proto = ipv6_push_frag_opts(skb, &opt.ops, proto);
 	}
 
 	skb_push(skb, sizeof(struct ipv6hdr));


