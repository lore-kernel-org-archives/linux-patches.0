Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C5F1519AA;
	Wed,  5 Feb 2025 14:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764830; cv=none; b=lBdeXHbTskdkK1uspbJBfDVoGkr/tWcvl86LLbhlolCp7rMb1Q/g2esekJlJDZA5KGiz0NrXEkdAbCxhhrVF13/q38wOuXgDrEBzcp2RehLpzhxNUWAB7lqZF0VPvzJXQXUttuakbPm01RkzQ6DdrvqgNRgysK/o7JX06/DTfUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764830; c=relaxed/simple;
	bh=gJAYU6asSdXPzy1smPKUZGW78jSQBZ9DNhGyxFjgT0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZ172OESUTqSIOpn4D4Ljd5z6dr2k3DRTbX1KDYHbhsKMnX40LK2aATBXXL1DMoPmWU0++xOdKv4d5MhLL2dfQB5K/X86qhvCDWzCoRrbkrI7A3iog6J7HE4WsnQIHe0oTW0oXQVcNe+L5V9A8LRKnK/KHhhdduE7wDaR02T51g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eUWhA3wg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eUWhA3wg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7604FC4CED1;
	Wed,  5 Feb 2025 14:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764829;
	bh=gJAYU6asSdXPzy1smPKUZGW78jSQBZ9DNhGyxFjgT0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eUWhA3wgAvnIQE6cGhgTwYlHJauqC6v0GsJaJOBWBlM+TGl6pWj02ZI/wgUBisbna
	 6g3SCd4VXKS02kcxV3CBeffvVrnMEJyIHea6iMCkoXA3U+iGliNKKVwF3ZsLCAJCGk
	 ZJuEbAW0wfmf56cVVi/+raQvIXOHyddtSF8Yu3CQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 117/623] inetpeer: remove create argument of inet_getpeer_v[46]()
Date: Wed,  5 Feb 2025 14:37:39 +0100
Message-ID: <20250205134500.695893140@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 661cd8fc8e9039819ca0c22e0add52b632240a9e ]

All callers of inet_getpeer_v4() and inet_getpeer_v6()
want to create an inetpeer.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241215175629.1248773-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a853c609504e ("inetpeer: do not get a refcount in inet_getpeer()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inetpeer.h | 9 ++++-----
 net/ipv4/icmp.c        | 2 +-
 net/ipv4/ip_fragment.c | 2 +-
 net/ipv4/route.c       | 4 ++--
 net/ipv6/icmp.c        | 2 +-
 net/ipv6/ip6_output.c  | 2 +-
 net/ipv6/ndisc.c       | 2 +-
 7 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/include/net/inetpeer.h b/include/net/inetpeer.h
index 74ff688568a0c..6f51f81d6cb19 100644
--- a/include/net/inetpeer.h
+++ b/include/net/inetpeer.h
@@ -101,25 +101,24 @@ struct inet_peer *inet_getpeer(struct inet_peer_base *base,
 
 static inline struct inet_peer *inet_getpeer_v4(struct inet_peer_base *base,
 						__be32 v4daddr,
-						int vif, int create)
+						int vif)
 {
 	struct inetpeer_addr daddr;
 
 	daddr.a4.addr = v4daddr;
 	daddr.a4.vif = vif;
 	daddr.family = AF_INET;
-	return inet_getpeer(base, &daddr, create);
+	return inet_getpeer(base, &daddr, 1);
 }
 
 static inline struct inet_peer *inet_getpeer_v6(struct inet_peer_base *base,
-						const struct in6_addr *v6daddr,
-						int create)
+						const struct in6_addr *v6daddr)
 {
 	struct inetpeer_addr daddr;
 
 	daddr.a6 = *v6daddr;
 	daddr.family = AF_INET6;
-	return inet_getpeer(base, &daddr, create);
+	return inet_getpeer(base, &daddr, 1);
 }
 
 static inline int inetpeer_addr_cmp(const struct inetpeer_addr *a,
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 963a89ae9c26e..5eeb9f569a706 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -322,7 +322,7 @@ static bool icmpv4_xrlim_allow(struct net *net, struct rtable *rt,
 		goto out;
 
 	vif = l3mdev_master_ifindex(dst->dev);
-	peer = inet_getpeer_v4(net->ipv4.peers, fl4->daddr, vif, 1);
+	peer = inet_getpeer_v4(net->ipv4.peers, fl4->daddr, vif);
 	rc = inet_peer_xrlim_allow(peer,
 				   READ_ONCE(net->ipv4.sysctl_icmp_ratelimit));
 	if (peer)
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 07036a2943c19..46e1171299f22 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -89,7 +89,7 @@ static void ip4_frag_init(struct inet_frag_queue *q, const void *a)
 	q->key.v4 = *key;
 	qp->ecn = 0;
 	qp->peer = q->fqdir->max_dist ?
-		inet_getpeer_v4(net->ipv4.peers, key->saddr, key->vif, 1) :
+		inet_getpeer_v4(net->ipv4.peers, key->saddr, key->vif) :
 		NULL;
 }
 
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index e1564b95fab09..00fdd6e965604 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -873,7 +873,7 @@ void ip_rt_send_redirect(struct sk_buff *skb)
 	rcu_read_unlock();
 
 	net = dev_net(rt->dst.dev);
-	peer = inet_getpeer_v4(net->ipv4.peers, ip_hdr(skb)->saddr, vif, 1);
+	peer = inet_getpeer_v4(net->ipv4.peers, ip_hdr(skb)->saddr, vif);
 	if (!peer) {
 		icmp_send(skb, ICMP_REDIRECT, ICMP_REDIR_HOST,
 			  rt_nexthop(rt, ip_hdr(skb)->daddr));
@@ -976,7 +976,7 @@ static int ip_error(struct sk_buff *skb)
 	}
 
 	peer = inet_getpeer_v4(net->ipv4.peers, ip_hdr(skb)->saddr,
-			       l3mdev_master_ifindex(skb->dev), 1);
+			       l3mdev_master_ifindex(skb->dev));
 
 	send = true;
 	if (peer) {
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 071b0bc1179d8..4593e3992c67b 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -222,7 +222,7 @@ static bool icmpv6_xrlim_allow(struct sock *sk, u8 type,
 		if (rt->rt6i_dst.plen < 128)
 			tmo >>= ((128 - rt->rt6i_dst.plen)>>5);
 
-		peer = inet_getpeer_v6(net->ipv6.peers, &fl6->daddr, 1);
+		peer = inet_getpeer_v6(net->ipv6.peers, &fl6->daddr);
 		res = inet_peer_xrlim_allow(peer, tmo);
 		if (peer)
 			inet_putpeer(peer);
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index f7b4608bb316e..c4cd959e0c876 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -613,7 +613,7 @@ int ip6_forward(struct sk_buff *skb)
 		else
 			target = &hdr->daddr;
 
-		peer = inet_getpeer_v6(net->ipv6.peers, &hdr->daddr, 1);
+		peer = inet_getpeer_v6(net->ipv6.peers, &hdr->daddr);
 
 		/* Limit redirects both by destination (here)
 		   and by source (inside ndisc_send_redirect)
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index aba94a3486737..f113554d13325 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1731,7 +1731,7 @@ void ndisc_send_redirect(struct sk_buff *skb, const struct in6_addr *target)
 			  "Redirect: destination is not a neighbour\n");
 		goto release;
 	}
-	peer = inet_getpeer_v6(net->ipv6.peers, &ipv6_hdr(skb)->saddr, 1);
+	peer = inet_getpeer_v6(net->ipv6.peers, &ipv6_hdr(skb)->saddr);
 	ret = inet_peer_xrlim_allow(peer, 1*HZ);
 	if (peer)
 		inet_putpeer(peer);
-- 
2.39.5



