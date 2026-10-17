Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5743939A4;
	Sat, 17 Oct 2026 17:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258320; cv=none; b=Lzwt/DHR1M31EpkdD99C9vJEdGalI4aDDwdDZ55YXKFzf/aZlR0aMKYDekuLASkUDDXzeqDGA2o74bh6V9e21oQPJYURTxSKBf+bJU8pZSsB5giUC0YpepfGg2jBKUPT4XIFJSM68LhaZP9p96vrk1WTFXQNMaga10hqOFSxIhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258320; c=relaxed/simple;
	bh=4adQMs4i8JSdKKn6LoAR3EJIjUqH+WLe9nCsIDKNwSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ALb4W0cvZ+sItQRwg71DZ+BXCGzCwp70L1gPW9ceIBTnWfJ5R0xt1UumkQZDKTWuu99yUKaePOIgAIyQ2wDBuop4opkVrrJY7Cta6C3+1ONXkH71YK1shPKdb8oWrb9Pa7/n+bEVS2MdO3Ksbag8WvO6N+rmgyArBwgEzdCQ87U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKJHlRME; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKJHlRME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1DF1F000C4;
	Sat, 17 Oct 2026 17:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258319;
	bh=7Z14bayPKxa5cbQNAhW0IbNOG21/H7JDLwbA/oB5f24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LKJHlRMEhHpTUri5Vur9oC1vmwpWdrEaENsk+QjElGgYkIZ7Z10D/NJteQXB+vFKp
	 kdUJoM/jiTBZAJG8p6/X/ucBVg0yIT587HERV7ovod9ZDKNN31TkOVutpy2GsZM/7A
	 GFt3KddZxn9fQUd1aVC8pF4eJUzTpiH99/S2FQGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0804/1674] net: use dst_dev_rcu() in sk_setup_caps()
Date: Sat, 17 Oct 2026 17:51:16 +0200
Message-ID: <20261017160451.751257668@linuxfoundation.org>
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

[ Upstream commit 99a2ace61b211b0be861b07fbaa062fca4b58879 ]

Use RCU to protect accesses to dst->dev from sk_setup_caps()
and sk_dst_gso_max_size().

Also use dst_dev_rcu() in ip6_dst_mtu_maybe_forward(),
and ip_dst_mtu_maybe_forward().

ip4_dst_hoplimit() can use dst_dev_net_rcu().

Fixes: 4a6ce2b6f2ec ("net: introduce a new function dst_dev_put()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250828195823.3958522-6-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip.h        | 16 ++++++++++++----
 include/net/ip6_route.h |  2 +-
 include/net/route.h     |  2 +-
 net/core/sock.c         | 16 ++++++++++------
 4 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 32825e2ac43d3..775185fe552f8 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -465,9 +465,14 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 						    bool forwarding)
 {
 	const struct rtable *rt = container_of(dst, struct rtable, dst);
-	struct net *net = dev_net(dst_dev(dst));
-	unsigned int mtu;
+	const struct net_device *dev;
+	unsigned int mtu, res;
+	struct net *net;
+
+	rcu_read_lock();
 
+	dev = dst_dev_rcu(dst);
+	net = dev_net_rcu(dev);
 	if (READ_ONCE(net->ipv4.sysctl_ip_fwd_use_pmtu) ||
 	    ip_mtu_locked(dst) ||
 	    !forwarding) {
@@ -481,7 +486,7 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 	if (mtu)
 		goto out;
 
-	mtu = READ_ONCE(dst_dev(dst)->mtu);
+	mtu = READ_ONCE(dev->mtu);
 
 	if (unlikely(ip_mtu_locked(dst))) {
 		if (rt->rt_uses_gateway && mtu > 576)
@@ -490,8 +495,11 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 
 out:
 	mtu = min_t(unsigned int, mtu, IP_MAX_MTU);
+	res = mtu - lwtunnel_headroom(dst->lwtstate, mtu);
 
-	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
+	rcu_read_unlock();
+
+	return res;
 }
 
 static inline unsigned int ip_skb_dst_mtu(struct sock *sk,
diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 211d1ef8ab421..d5f3b842dd0a7 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -333,7 +333,7 @@ static inline unsigned int ip6_dst_mtu_maybe_forward(const struct dst_entry *dst
 
 	mtu = IPV6_MIN_MTU;
 	rcu_read_lock();
-	idev = __in6_dev_get(dst->dev);
+	idev = __in6_dev_get(dst_dev_rcu(dst));
 	if (idev)
 		mtu = idev->cnf.mtu6;
 	rcu_read_unlock();
diff --git a/include/net/route.h b/include/net/route.h
index d443de683628e..7f37b8b96c920 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -359,7 +359,7 @@ static inline int ip4_dst_hoplimit(const struct dst_entry *dst)
 		const struct net *net;
 
 		rcu_read_lock();
-		net = dev_net_rcu(dst_dev(dst));
+		net = dst_dev_net_rcu(dst);
 		hoplimit = READ_ONCE(net->ipv4.sysctl_ip_default_ttl);
 		rcu_read_unlock();
 	}
diff --git a/net/core/sock.c b/net/core/sock.c
index 057ec36aa4710..3aec06256f6ba 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2444,7 +2444,7 @@ void sk_free_unlock_clone(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(sk_free_unlock_clone);
 
-static u32 sk_dst_gso_max_size(struct sock *sk, struct dst_entry *dst)
+static u32 sk_dst_gso_max_size(struct sock *sk, const struct net_device *dev)
 {
 	bool is_ipv6 = false;
 	u32 max_size;
@@ -2454,8 +2454,8 @@ static u32 sk_dst_gso_max_size(struct sock *sk, struct dst_entry *dst)
 		   !ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr));
 #endif
 	/* pairs with the WRITE_ONCE() in netif_set_gso(_ipv4)_max_size() */
-	max_size = is_ipv6 ? READ_ONCE(dst_dev(dst)->gso_max_size) :
-			READ_ONCE(dst_dev(dst)->gso_ipv4_max_size);
+	max_size = is_ipv6 ? READ_ONCE(dev->gso_max_size) :
+			READ_ONCE(dev->gso_ipv4_max_size);
 	if (max_size > GSO_LEGACY_MAX_SIZE && !sk_is_tcp(sk))
 		max_size = GSO_LEGACY_MAX_SIZE;
 
@@ -2464,9 +2464,12 @@ static u32 sk_dst_gso_max_size(struct sock *sk, struct dst_entry *dst)
 
 void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 {
+	const struct net_device *dev;
 	u32 max_segs = 1;
 
-	sk->sk_route_caps = dst_dev(dst)->features;
+	rcu_read_lock();
+	dev = dst_dev_rcu(dst);
+	sk->sk_route_caps = dev->features;
 	if (sk_is_tcp(sk))
 		sk->sk_route_caps |= NETIF_F_GSO;
 	if (sk->sk_route_caps & NETIF_F_GSO)
@@ -2478,13 +2481,14 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 			sk->sk_route_caps &= ~NETIF_F_GSO_MASK;
 		} else {
 			sk->sk_route_caps |= NETIF_F_SG | NETIF_F_HW_CSUM;
-			sk->sk_gso_max_size = sk_dst_gso_max_size(sk, dst);
+			sk->sk_gso_max_size = sk_dst_gso_max_size(sk, dev);
 			/* pairs with the WRITE_ONCE() in netif_set_gso_max_segs() */
-			max_segs = max_t(u32, READ_ONCE(dst_dev(dst)->gso_max_segs), 1);
+			max_segs = max_t(u32, READ_ONCE(dev->gso_max_segs), 1);
 		}
 	}
 	sk->sk_gso_max_segs = max_segs;
 	sk_dst_set(sk, dst);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(sk_setup_caps);
 
-- 
2.53.0



