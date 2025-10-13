Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EF1219E8;
	Mon, 13 Oct 2025 15:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369549; cv=none; b=r4pMCvOz3FbF0bO6BBhb/OQt4CiVb8FxjfGsoCRH/RBSN4Y6/4YKS88XZJx3tKWabWqCyfBkngy4SA9SvmDymkO20ZfR2vpx62obHMr7qkRmy56PgwEYrZhfTdR/mzbHL0CuY34itEFi0w0TWvyMSbuW2VFmTo5Pzy/pi22e7BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369549; c=relaxed/simple;
	bh=J2e8GPTota0J29rmm8NDsAaTUO7DduoQtBTx4RbgCNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSHtxZ0d0BFY7jLmuO1FAFe/+xTs9pxaR2U2xAU2cMDNV/Tu8kTByNdL58Hmi5s0uoMzyZ+AHw9H3lR91uaa3qnOJi7mzF9v9AB+AjCi5bXJMVo4FIT4TSBaSD4yEzg9KjMXjFVobBlvIVC1uqgg4MRrANyOOzQiwSh63au1RUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TvF6Dwr3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TvF6Dwr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC629C4CEE7;
	Mon, 13 Oct 2025 15:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369549;
	bh=J2e8GPTota0J29rmm8NDsAaTUO7DduoQtBTx4RbgCNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvF6Dwr33YsH4bviA6pcoyGIQ9SPXvRf5unpBypkhzL2jNWO88GA0YmLQUxTT7z68
	 jMGPVUiPVQAYV/yOyM45TU3v6ukIbLaEzoX48XF4nqnlLabIfHA9EfVdJ2izxglgXT
	 bMmK4i6uTLQqW6Sn0Ji4lebP8e04HXHMCDLua2rQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 286/563] ipv6: start using dst_dev_rcu()
Date: Mon, 13 Oct 2025 16:42:27 +0200
Message-ID: <20251013144421.631230456@linuxfoundation.org>
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

[ Upstream commit b775ecf1655cedbc465fd6699ab18a2bc4e7a352 ]

Refactor icmpv6_xrlim_allow() and ip6_dst_hoplimit()
so that we acquire rcu_read_lock() a bit longer
to be able to use dst_dev_rcu() instead of dst_dev().

__ip6_rt_update_pmtu() and rt6_do_redirect can directly
use dst_dev_rcu() in sections already holding rcu_read_lock().

Small changes to use dst_dev_net_rcu() in
ip6_default_advmss(), ipv6_sock_ac_join(),
ip6_mc_find_dev() and ndisc_send_skb().

Fixes: 4a6ce2b6f2ec ("net: introduce a new function dst_dev_put()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250828195823.3958522-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/anycast.c     | 2 +-
 net/ipv6/icmp.c        | 6 +++---
 net/ipv6/mcast.c       | 2 +-
 net/ipv6/ndisc.c       | 2 +-
 net/ipv6/output_core.c | 8 +++++---
 net/ipv6/route.c       | 7 +++----
 6 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/net/ipv6/anycast.c b/net/ipv6/anycast.c
index f8a8e46286b8e..52599584422bf 100644
--- a/net/ipv6/anycast.c
+++ b/net/ipv6/anycast.c
@@ -104,7 +104,7 @@ int ipv6_sock_ac_join(struct sock *sk, int ifindex, const struct in6_addr *addr)
 		rcu_read_lock();
 		rt = rt6_lookup(net, addr, NULL, 0, NULL, 0);
 		if (rt) {
-			dev = dst_dev(&rt->dst);
+			dev = dst_dev_rcu(&rt->dst);
 			netdev_hold(dev, &dev_tracker, GFP_ATOMIC);
 			ip6_rt_put(rt);
 		} else if (ishost) {
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 44550957fd4e3..95cdd4cacb004 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -209,7 +209,8 @@ static bool icmpv6_xrlim_allow(struct sock *sk, u8 type,
 	 * this lookup should be more aggressive (not longer than timeout).
 	 */
 	dst = ip6_route_output(net, sk, fl6);
-	dev = dst_dev(dst);
+	rcu_read_lock();
+	dev = dst_dev_rcu(dst);
 	if (dst->error) {
 		IP6_INC_STATS(net, ip6_dst_idev(dst),
 			      IPSTATS_MIB_OUTNOROUTES);
@@ -224,11 +225,10 @@ static bool icmpv6_xrlim_allow(struct sock *sk, u8 type,
 		if (rt->rt6i_dst.plen < 128)
 			tmo >>= ((128 - rt->rt6i_dst.plen)>>5);
 
-		rcu_read_lock();
 		peer = inet_getpeer_v6(net->ipv6.peers, &fl6->daddr);
 		res = inet_peer_xrlim_allow(peer, tmo);
-		rcu_read_unlock();
 	}
+	rcu_read_unlock();
 	if (!res)
 		__ICMP6_INC_STATS(net, ip6_dst_idev(dst),
 				  ICMP6_MIB_RATELIMITHOST);
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 55c49dc14b1bd..016b572e7d6f0 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -180,7 +180,7 @@ static struct net_device *ip6_mc_find_dev(struct net *net,
 		rcu_read_lock();
 		rt = rt6_lookup(net, group, NULL, 0, NULL, 0);
 		if (rt) {
-			dev = dst_dev(&rt->dst);
+			dev = dst_dev_rcu(&rt->dst);
 			dev_hold(dev);
 			ip6_rt_put(rt);
 		}
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 7d5abb3158ec9..d6bb1e2f6192e 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -505,7 +505,7 @@ void ndisc_send_skb(struct sk_buff *skb, const struct in6_addr *daddr,
 
 	ip6_nd_hdr(skb, saddr, daddr, READ_ONCE(inet6_sk(sk)->hop_limit), skb->len);
 
-	dev = dst_dev(dst);
+	dev = dst_dev_rcu(dst);
 	idev = __in6_dev_get(dev);
 	IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTREQUESTS);
 
diff --git a/net/ipv6/output_core.c b/net/ipv6/output_core.c
index d21fe27fe21e3..1c9b283a4132d 100644
--- a/net/ipv6/output_core.c
+++ b/net/ipv6/output_core.c
@@ -104,18 +104,20 @@ EXPORT_SYMBOL(ip6_find_1stfragopt);
 int ip6_dst_hoplimit(struct dst_entry *dst)
 {
 	int hoplimit = dst_metric_raw(dst, RTAX_HOPLIMIT);
+
+	rcu_read_lock();
 	if (hoplimit == 0) {
-		struct net_device *dev = dst_dev(dst);
+		struct net_device *dev = dst_dev_rcu(dst);
 		struct inet6_dev *idev;
 
-		rcu_read_lock();
 		idev = __in6_dev_get(dev);
 		if (idev)
 			hoplimit = READ_ONCE(idev->cnf.hop_limit);
 		else
 			hoplimit = READ_ONCE(dev_net(dev)->ipv6.devconf_all->hop_limit);
-		rcu_read_unlock();
 	}
+	rcu_read_unlock();
+
 	return hoplimit;
 }
 EXPORT_SYMBOL(ip6_dst_hoplimit);
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 3299cfa12e21c..3371f16b7a3e6 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2943,7 +2943,7 @@ static void __ip6_rt_update_pmtu(struct dst_entry *dst, const struct sock *sk,
 
 		if (res.f6i->nh) {
 			struct fib6_nh_match_arg arg = {
-				.dev = dst_dev(dst),
+				.dev = dst_dev_rcu(dst),
 				.gw = &rt6->rt6i_gateway,
 			};
 
@@ -3238,7 +3238,6 @@ EXPORT_SYMBOL_GPL(ip6_sk_redirect);
 
 static unsigned int ip6_default_advmss(const struct dst_entry *dst)
 {
-	struct net_device *dev = dst_dev(dst);
 	unsigned int mtu = dst_mtu(dst);
 	struct net *net;
 
@@ -3246,7 +3245,7 @@ static unsigned int ip6_default_advmss(const struct dst_entry *dst)
 
 	rcu_read_lock();
 
-	net = dev_net_rcu(dev);
+	net = dst_dev_net_rcu(dst);
 	if (mtu < net->ipv6.sysctl.ip6_rt_min_advmss)
 		mtu = net->ipv6.sysctl.ip6_rt_min_advmss;
 
@@ -4301,7 +4300,7 @@ static void rt6_do_redirect(struct dst_entry *dst, struct sock *sk, struct sk_bu
 
 	if (res.f6i->nh) {
 		struct fib6_nh_match_arg arg = {
-			.dev = dst_dev(dst),
+			.dev = dst_dev_rcu(dst),
 			.gw = &rt->rt6i_gateway,
 		};
 
-- 
2.51.0



