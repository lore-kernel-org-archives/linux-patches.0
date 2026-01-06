Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0E4322B7D;
	Tue,  6 Jan 2026 17:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721501; cv=none; b=O1uyi4sfnVm0jcej1/X2iuJeBamkbPPddx73lc9b/2wYC+HF8t7wr9Q8WopWzT96iV4FJI8FJeO+WLJ1oumbJWZ9hTgfd5RmVdrci6xLW4mjUX6c8cjztVVEZ2eynxLWp3uZbdKjlMwkm7wOL0+j4uTd7uWvI+GhAUi7yDTIV10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721501; c=relaxed/simple;
	bh=khGjL8iGEO9eylWTjChyMyTrYtEBSJyhIBJEXRzj9kI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7ivhfRihJ8V08qL+83/r4whmt4xkroiLvtDzp/AiSI/aB420HqKk8LXfPMtyHHfxwg9ANYaEEuRSFouIYNlJd/kdOGRKiGGoYUnkSptXzECuQ0w71iTV/fvUCLGrXLegZir5Y51Q+4wCPGURlJel2X+2F6pg9QGO+bMPdR3isg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rZYWlnHc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rZYWlnHc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F46BC19423;
	Tue,  6 Jan 2026 17:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721501;
	bh=khGjL8iGEO9eylWTjChyMyTrYtEBSJyhIBJEXRzj9kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rZYWlnHcTlyRfVP8kfeGFFMmvUczB5L5KVk76P8mtqCMfwKOF5w4mJyvhJJEFFIk4
	 EdjRxU1RuEdy0Haj3ox66mrBPOUk6TVCsuukmlhZMrqWgnY5hNPRYBEW0gFU95w+dU
	 DQbZwKx7bGgR4BcXPD5Con2U4hdUufGegpqS0BBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.12 528/567] net: use dst_dev_rcu() in sk_setup_caps()
Date: Tue,  6 Jan 2026 18:05:10 +0100
Message-ID: <20260106170510.925578696@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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
[Harshit: Backport to 6.12.y, resolve conflict due to missing commit:
22d6c9eebf2e ("net: Unexport shared functions for DCCP.")  in 6.12.y]
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip.h        |    6 ++++--
 include/net/ip6_route.h |    2 +-
 include/net/route.h     |    2 +-
 net/core/sock.c         |   16 ++++++++++------
 4 files changed, 16 insertions(+), 10 deletions(-)

--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -470,12 +470,14 @@ static inline unsigned int ip_dst_mtu_ma
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
@@ -489,7 +491,7 @@ static inline unsigned int ip_dst_mtu_ma
 	if (mtu)
 		goto out;
 
-	mtu = READ_ONCE(dst_dev(dst)->mtu);
+	mtu = READ_ONCE(dev->mtu);
 
 	if (unlikely(ip_mtu_locked(dst))) {
 		if (rt->rt_uses_gateway && mtu > 576)
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -337,7 +337,7 @@ static inline unsigned int ip6_dst_mtu_m
 
 	mtu = IPV6_MIN_MTU;
 	rcu_read_lock();
-	idev = __in6_dev_get(dst_dev(dst));
+	idev = __in6_dev_get(dst_dev_rcu(dst));
 	if (idev)
 		mtu = READ_ONCE(idev->cnf.mtu6);
 	rcu_read_unlock();
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -369,7 +369,7 @@ static inline int ip4_dst_hoplimit(const
 		const struct net *net;
 
 		rcu_read_lock();
-		net = dev_net_rcu(dst_dev(dst));
+		net = dst_dev_net_rcu(dst);
 		hoplimit = READ_ONCE(net->ipv4.sysctl_ip_default_ttl);
 		rcu_read_unlock();
 	}
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2524,7 +2524,7 @@ void sk_free_unlock_clone(struct sock *s
 }
 EXPORT_SYMBOL_GPL(sk_free_unlock_clone);
 
-static u32 sk_dst_gso_max_size(struct sock *sk, struct dst_entry *dst)
+static u32 sk_dst_gso_max_size(struct sock *sk, const struct net_device *dev)
 {
 	bool is_ipv6 = false;
 	u32 max_size;
@@ -2534,8 +2534,8 @@ static u32 sk_dst_gso_max_size(struct so
 		   !ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr));
 #endif
 	/* pairs with the WRITE_ONCE() in netif_set_gso(_ipv4)_max_size() */
-	max_size = is_ipv6 ? READ_ONCE(dst_dev(dst)->gso_max_size) :
-			READ_ONCE(dst_dev(dst)->gso_ipv4_max_size);
+	max_size = is_ipv6 ? READ_ONCE(dev->gso_max_size) :
+			READ_ONCE(dev->gso_ipv4_max_size);
 	if (max_size > GSO_LEGACY_MAX_SIZE && !sk_is_tcp(sk))
 		max_size = GSO_LEGACY_MAX_SIZE;
 
@@ -2544,9 +2544,12 @@ static u32 sk_dst_gso_max_size(struct so
 
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
 
@@ -2562,13 +2565,14 @@ void sk_setup_caps(struct sock *sk, stru
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
 


