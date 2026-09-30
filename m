Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682DF3C0A0C;
	Wed, 30 Sep 2026 19:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795374; cv=none; b=BcdVbETy1HRj5n6Ghe5EeBz/5UeaGZQ39Pr8pyA9YwiR6RBBrJMJVQp6f7pf1yXGERQN6CxPW3FhGrTTgzfpv7QKuX6OxWCm6nc8Vtj6Sv4dByzhip0dTpczYYmjcBPf3Va/KAriPyHxVfQlAzC8WRJnXs+/J+YiF+EgLDBdKbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795374; c=relaxed/simple;
	bh=+Dsg7KR2+5faFz+P9E+ZTyKoa2DLK+zQgMzed/TYc3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNgCYYT65nZDYT18lnzWwwFRK1t4/JhgoDhGdVw/eyYRQMKX+Ro5lKeKo+7p8P2EZMe/rbTnqjkWk32dggw5rL0c7GITd1q8xw2Y89KrMb8b5bi3DIZbTpw48whxYZM4vzW3DwXvtcBXhx36NmPRZZqEynCzZWhRl50AHKr3xgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNHE/V++; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNHE/V++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C201F00898;
	Wed, 30 Sep 2026 19:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795373;
	bh=vf9LT2lkt+G4Z4cS9wLQdqYiZYlnnr9Qr3Diyqwr32I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YNHE/V++ckyrrQSiyWxz1qJ1bZ+bFM6nZurfp82qhqHDR/wcOMu7bdIYIinH6T0Eu
	 ayurW+uw9A3F1VRek8lzLtQUISXyUtz1s5ZE1gsSyw56Sycp/lK+KwZaByBM6SQnhW
	 QlwqPkgPHbt0QBzKUhlS6IZxgp2JojjmrcHBGzYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0539/1193] ipv6: lockless IPV6_MULTICAST_HOPS implementation
Date: Wed, 30 Sep 2026 17:20:23 +0200
Message-ID: <20260930152446.200554199@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

[ Upstream commit 2da23eb07c91241d962f3ff05565065484cd8929 ]

This fixes data-races around np->mcast_hops,
and make IPV6_MULTICAST_HOPS lockless.

Note that np->mcast_hops is never negative,
thus can fit an u8 field instead of s16.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 0ae10b6be49b ("net: ipv6: Fix UDP length overflow with PMTU discover and big MTU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ipv6.h            |    9 +--------
 include/net/ipv6.h              |    2 +-
 net/dccp/ipv6.c                 |    2 +-
 net/ipv6/ipv6_sockglue.c        |   28 +++++++++++++++-------------
 net/ipv6/tcp_ipv6.c             |    3 ++-
 net/netfilter/ipvs/ip_vs_sync.c |    2 +-
 6 files changed, 21 insertions(+), 25 deletions(-)

--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -214,15 +214,8 @@ struct ipv6_pinfo {
 	__u32			frag_size;
 
 	s16			hop_limit;
+	u8			mcast_hops;
 
-#if defined(__BIG_ENDIAN_BITFIELD)
-	/* Packed in 16bits. */
-	__s16			mcast_hops:9;
-	__u16			__unused_2:7,
-#else
-	__u16			__unused_2:7;
-	__s16			mcast_hops:9;
-#endif
 	int			ucast_oif;
 	int			mcast_oif;
 
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -914,7 +914,7 @@ static inline int ip6_sk_dst_hoplimit(st
 	int hlimit;
 
 	if (ipv6_addr_is_multicast(&fl6->daddr))
-		hlimit = np->mcast_hops;
+		hlimit = READ_ONCE(np->mcast_hops);
 	else
 		hlimit = READ_ONCE(np->hop_limit);
 	if (hlimit < 0)
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -677,7 +677,7 @@ ipv6_pktoptions:
 		if (np->rxopt.bits.rxinfo || np->rxopt.bits.rxoinfo)
 			np->mcast_oif = inet6_iif(opt_skb);
 		if (np->rxopt.bits.rxhlim || np->rxopt.bits.rxohlim)
-			np->mcast_hops = ipv6_hdr(opt_skb)->hop_limit;
+			WRITE_ONCE(np->mcast_hops, ipv6_hdr(opt_skb)->hop_limit);
 		if (np->rxopt.bits.rxflow || np->rxopt.bits.rxtclass)
 			np->rcv_flowinfo = ip6_flowinfo(ipv6_hdr(opt_skb));
 		if (np->repflow)
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -430,6 +430,16 @@ int do_ipv6_setsockopt(struct sock *sk,
 			return -EINVAL;
 		inet6_assign_bit(MC6_LOOP, sk, valbool);
 		return 0;
+	case IPV6_MULTICAST_HOPS:
+		if (sk->sk_type == SOCK_STREAM)
+			return retv;
+		if (optlen < sizeof(int))
+			return -EINVAL;
+		if (val > 255 || val < -1)
+			return -EINVAL;
+		WRITE_ONCE(np->mcast_hops,
+			   val == -1 ? IPV6_DEFAULT_MCASTHOPS : val);
+		return 0;
 	}
 	if (needs_rtnl)
 		rtnl_lock();
@@ -750,16 +760,6 @@ done:
 		break;
 	}
 
-	case IPV6_MULTICAST_HOPS:
-		if (sk->sk_type == SOCK_STREAM)
-			break;
-		if (optlen < sizeof(int))
-			goto e_inval;
-		if (val > 255 || val < -1)
-			goto e_inval;
-		np->mcast_hops = (val == -1 ? IPV6_DEFAULT_MCASTHOPS : val);
-		retv = 0;
-		break;
 
 	case IPV6_UNICAST_IF:
 	{
@@ -1179,7 +1179,8 @@ int do_ipv6_getsockopt(struct sock *sk,
 				put_cmsg(&msg, SOL_IPV6, IPV6_PKTINFO, sizeof(src_info), &src_info);
 			}
 			if (np->rxopt.bits.rxhlim) {
-				int hlim = np->mcast_hops;
+				int hlim = READ_ONCE(np->mcast_hops);
+
 				put_cmsg(&msg, SOL_IPV6, IPV6_HOPLIMIT, sizeof(hlim), &hlim);
 			}
 			if (np->rxopt.bits.rxtclass) {
@@ -1196,7 +1197,8 @@ int do_ipv6_getsockopt(struct sock *sk,
 				put_cmsg(&msg, SOL_IPV6, IPV6_2292PKTINFO, sizeof(src_info), &src_info);
 			}
 			if (np->rxopt.bits.rxohlim) {
-				int hlim = np->mcast_hops;
+				int hlim = READ_ONCE(np->mcast_hops);
+
 				put_cmsg(&msg, SOL_IPV6, IPV6_2292HOPLIMIT, sizeof(hlim), &hlim);
 			}
 			if (np->rxopt.bits.rxflow) {
@@ -1348,7 +1350,7 @@ int do_ipv6_getsockopt(struct sock *sk,
 		if (optname == IPV6_UNICAST_HOPS)
 			val = READ_ONCE(np->hop_limit);
 		else
-			val = np->mcast_hops;
+			val = READ_ONCE(np->mcast_hops);
 
 		if (val < 0) {
 			rcu_read_lock();
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1517,7 +1517,8 @@ ipv6_pktoptions:
 		if (np->rxopt.bits.rxinfo || np->rxopt.bits.rxoinfo)
 			np->mcast_oif = tcp_v6_iif(opt_skb);
 		if (np->rxopt.bits.rxhlim || np->rxopt.bits.rxohlim)
-			np->mcast_hops = ipv6_hdr(opt_skb)->hop_limit;
+			WRITE_ONCE(np->mcast_hops,
+				   ipv6_hdr(opt_skb)->hop_limit);
 		if (np->rxopt.bits.rxflow || np->rxopt.bits.rxtclass)
 			np->rcv_flowinfo = ip6_flowinfo(ipv6_hdr(opt_skb));
 		if (np->repflow)
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -1319,7 +1319,7 @@ static void set_mcast_ttl(struct sock *s
 		struct ipv6_pinfo *np = inet6_sk(sk);
 
 		/* IPV6_MULTICAST_HOPS */
-		np->mcast_hops = ttl;
+		WRITE_ONCE(np->mcast_hops, ttl);
 	}
 #endif
 	release_sock(sk);


