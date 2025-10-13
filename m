Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E2E2D23AD;
	Mon, 13 Oct 2025 15:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369560; cv=none; b=EVlzkq2c5+h2jJY17k5K/Dbk9QruNEk0QMMaROjTRJe/WpaqwAHoBLRw/k/FTcCGkL973JThawQqYSzU+utxrNu/o5FNpEixhAYoic+ukSYRyfd/uNN4+cBPOs2ibA9l2CfR3QdggHj2+sRhe/iFXq9Hm+6LUEdkOXAZLZwBtyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369560; c=relaxed/simple;
	bh=8pfhLcNxJ5L2E9CfaugqBQaaVhBRt72UO8BMHp1gfdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWNeE/LtvacAlPTczPMgk0mU3GGJdui3mVnk+wg/JBA6zGadUwGoR7HfGnXsUYSutLO7ej0OGTvejOVZzaHlMQW2uMih0C2J/oni9aZ4tVINsXzk3kpH3Ev5E38jSDykWWSWBRudZZy7hlntn5AZqZJJlpJsg8GMlsKX601NrVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ARpSf+Qv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ARpSf+Qv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A9DC4CEFE;
	Mon, 13 Oct 2025 15:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369560;
	bh=8pfhLcNxJ5L2E9CfaugqBQaaVhBRt72UO8BMHp1gfdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ARpSf+QvzfeMysQr71Y6vLoMY2stChOt1yKJRKFsfqlN2ggtxAHWG8V4kYDt0mt7Q
	 6bLFVU1SH+WhEoyO0OFTXmOj5E+f00nj3fg0Q0vLcm9/+5UHflWk2/HWLeQQCZE2Hv
	 qh4nT+7dkfqZt+7y8osq+6JNbm3+QRNarUxgs6rQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 289/563] net: use dst_dev_rcu() in sk_setup_caps()
Date: Mon, 13 Oct 2025 16:42:30 +0200
Message-ID: <20251013144421.739021790@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
 include/net/ip.h        |  6 ++++--
 include/net/ip6_route.h |  2 +-
 include/net/route.h     |  2 +-
 net/core/sock.c         | 16 ++++++++++------
 4 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index befcba575129a..6dbd2bf8fa9c9 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -467,12 +467,14 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 						    bool forwarding)
 {
 	const struct rtable *rt = dst_rtable(dst);
+	const struct net_device *dev;
 	unsigned int mtu, res;
 	struct net *net;
 
 	rcu_read_lock();
 
-	net = dev_net_rcu(dst_dev(dst));
+	dev = dst_dev_rcu(dst);
+	net = dev_net_rcu(dev);
 	if (READ_ONCE(net->ipv4.sysctl_ip_fwd_use_pmtu) ||
 	    ip_mtu_locked(dst) ||
 	    !forwarding) {
@@ -486,7 +488,7 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 	if (mtu)
 		goto out;
 
-	mtu = READ_ONCE(dst_dev(dst)->mtu);
+	mtu = READ_ONCE(dev->mtu);
 
 	if (unlikely(ip_mtu_locked(dst))) {
 		if (rt->rt_uses_gateway && mtu > 576)
diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 9255f21818ee7..59f48ca3abdf5 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -337,7 +337,7 @@ static inline unsigned int ip6_dst_mtu_maybe_forward(const struct dst_entry *dst
 
 	mtu = IPV6_MIN_MTU;
 	rcu_read_lock();
-	idev = __in6_dev_get(dst_dev(dst));
+	idev = __in6_dev_get(dst_dev_rcu(dst));
 	if (idev)
 		mtu = READ_ONCE(idev->cnf.mtu6);
 	rcu_read_unlock();
diff --git a/include/net/route.h b/include/net/route.h
index 7ea840daa775b..c916bbe25a774 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -390,7 +390,7 @@ static inline int ip4_dst_hoplimit(const struct dst_entry *dst)
 		const struct net *net;
 
 		rcu_read_lock();
-		net = dev_net_rcu(dst_dev(dst));
+		net = dst_dev_net_rcu(dst);
 		hoplimit = READ_ONCE(net->ipv4.sysctl_ip_default_ttl);
 		rcu_read_unlock();
 	}
diff --git a/net/core/sock.c b/net/core/sock.c
index 158bddd23134c..e21348ead7e76 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2584,7 +2584,7 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 }
 EXPORT_SYMBOL_GPL(sk_clone_lock);
 
-static u32 sk_dst_gso_max_size(struct sock *sk, struct dst_entry *dst)
+static u32 sk_dst_gso_max_size(struct sock *sk, const struct net_device *dev)
 {
 	bool is_ipv6 = false;
 	u32 max_size;
@@ -2594,8 +2594,8 @@ static u32 sk_dst_gso_max_size(struct sock *sk, struct dst_entry *dst)
 		   !ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr));
 #endif
 	/* pairs with the WRITE_ONCE() in netif_set_gso(_ipv4)_max_size() */
-	max_size = is_ipv6 ? READ_ONCE(dst_dev(dst)->gso_max_size) :
-			READ_ONCE(dst_dev(dst)->gso_ipv4_max_size);
+	max_size = is_ipv6 ? READ_ONCE(dev->gso_max_size) :
+			READ_ONCE(dev->gso_ipv4_max_size);
 	if (max_size > GSO_LEGACY_MAX_SIZE && !sk_is_tcp(sk))
 		max_size = GSO_LEGACY_MAX_SIZE;
 
@@ -2604,9 +2604,12 @@ static u32 sk_dst_gso_max_size(struct sock *sk, struct dst_entry *dst)
 
 void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 {
+	const struct net_device *dev;
 	u32 max_segs = 1;
 
-	sk->sk_route_caps = dst_dev(dst)->features;
+	rcu_read_lock();
+	dev = dst_dev_rcu(dst);
+	sk->sk_route_caps = dev->features;
 	if (sk_is_tcp(sk)) {
 		struct inet_connection_sock *icsk = inet_csk(sk);
 
@@ -2622,13 +2625,14 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
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
2.51.0



