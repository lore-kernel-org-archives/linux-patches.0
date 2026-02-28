Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8527421A16
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301095; cv=none; b=b55LI6UIO0oRd6h4HhjLtKfniBl26tB358fZsf2xogNRql4HprGiVbWXv1tGuSDSMc/Udbmv+IOno76JMe2lilNFKTFkwfgS8cv6/fGzliC1HdeFGAANhvioiC+QLUXLEMtsF2OcuJLxmukDRhuYjN62Jtg79kMW8yC62bqR6GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301095; c=relaxed/simple;
	bh=BS2TOG+Wj/1JLc3EtCMlB5kiFK4v3d8bC635VveQl0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Frl43II5dXdy2Dd4Lz+6X2ceLpWyZvkWyh7I3GnoCiSCHpyX3mDq7KtcBaAAaCofk+3skcwmeosFnxMG7OQJXo8bdU8/1mpGMTDdEhEpdykpxV2GLst9oeiIumgrVOkhhZqEfgpQg5S5NdHSldi9MOF64jb0ormgGWM+R6d6+fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HRUEBWqN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HRUEBWqN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D81C19424;
	Sat, 28 Feb 2026 17:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301094;
	bh=BS2TOG+Wj/1JLc3EtCMlB5kiFK4v3d8bC635VveQl0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HRUEBWqNFC2ZHvpI4o1Np9sznydJOTE/qmZ1jp2sA9sCGXxz8TXb3TtcumjvIu+jk
	 4pAzrIXoy4HD/1yAlpARxprZaO2/Sk8PkezpNKTt6BHKMnuAD9Cir/zfxp/BfPlJGA
	 8972M4EEAGj1yZJO2BBaIU8aP8PYHu7AUl27oLT2B26XXVkC+5Ug9YzBkUsVCGqRd6
	 G0TuXnBG83t3yTtp+YNjILJ/uH9xj1ucxWesYfBnHN8kGiAX+OdY7xdk6KSXODnUi6
	 6lez2htP/wc5vK8IxzFOrlhCUcaXooRYUkFQPOQj9kxEWN7iDK2IzG8GokGGe0FCeJ
	 RmHKf44B9RGQg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 245/752] ipv6: annotate data-races in net/ipv6/route.c
Date: Sat, 28 Feb 2026 12:39:16 -0500
Message-ID: <20260228174750.1542406-245-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f062e8e25102324364aada61b8283356235bc3c1 ]

sysctls are read while their values can change,
add READ_ONCE() annotations.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260115094141.3124990-9-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index e3a260a5564ba..cd229974b7974 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2895,7 +2895,7 @@ static void rt6_do_update_pmtu(struct rt6_info *rt, u32 mtu)
 
 	dst_metric_set(&rt->dst, RTAX_MTU, mtu);
 	rt->rt6i_flags |= RTF_MODIFIED;
-	rt6_update_expires(rt, net->ipv6.sysctl.ip6_rt_mtu_expires);
+	rt6_update_expires(rt, READ_ONCE(net->ipv6.sysctl.ip6_rt_mtu_expires));
 }
 
 static bool rt6_cache_allowed_for_pmtu(const struct rt6_info *rt)
@@ -3256,8 +3256,8 @@ static unsigned int ip6_default_advmss(const struct dst_entry *dst)
 	rcu_read_lock();
 
 	net = dst_dev_net_rcu(dst);
-	if (mtu < net->ipv6.sysctl.ip6_rt_min_advmss)
-		mtu = net->ipv6.sysctl.ip6_rt_min_advmss;
+	mtu = max_t(unsigned int, mtu,
+		    READ_ONCE(net->ipv6.sysctl.ip6_rt_min_advmss));
 
 	rcu_read_unlock();
 
@@ -3359,10 +3359,10 @@ struct dst_entry *icmp6_dst_alloc(struct net_device *dev,
 static void ip6_dst_gc(struct dst_ops *ops)
 {
 	struct net *net = container_of(ops, struct net, ipv6.ip6_dst_ops);
-	int rt_min_interval = net->ipv6.sysctl.ip6_rt_gc_min_interval;
-	int rt_elasticity = net->ipv6.sysctl.ip6_rt_gc_elasticity;
-	int rt_gc_timeout = net->ipv6.sysctl.ip6_rt_gc_timeout;
-	unsigned long rt_last_gc = net->ipv6.ip6_rt_last_gc;
+	int rt_min_interval = READ_ONCE(net->ipv6.sysctl.ip6_rt_gc_min_interval);
+	int rt_elasticity = READ_ONCE(net->ipv6.sysctl.ip6_rt_gc_elasticity);
+	int rt_gc_timeout = READ_ONCE(net->ipv6.sysctl.ip6_rt_gc_timeout);
+	unsigned long rt_last_gc = READ_ONCE(net->ipv6.ip6_rt_last_gc);
 	unsigned int val;
 	int entries;
 
@@ -5008,7 +5008,7 @@ void rt6_sync_down_dev(struct net_device *dev, unsigned long event)
 	};
 	struct net *net = dev_net(dev);
 
-	if (net->ipv6.sysctl.skip_notify_on_dev_down)
+	if (READ_ONCE(net->ipv6.sysctl.skip_notify_on_dev_down))
 		fib6_clean_all_skip_notify(net, fib6_ifdown, &arg);
 	else
 		fib6_clean_all(net, fib6_ifdown, &arg);
@@ -6408,6 +6408,7 @@ void fib6_rt_update(struct net *net, struct fib6_info *rt,
 void fib6_info_hw_flags_set(struct net *net, struct fib6_info *f6i,
 			    bool offload, bool trap, bool offload_failed)
 {
+	u8 fib_notify_on_flag_change;
 	struct sk_buff *skb;
 	int err;
 
@@ -6419,8 +6420,9 @@ void fib6_info_hw_flags_set(struct net *net, struct fib6_info *f6i,
 	WRITE_ONCE(f6i->offload, offload);
 	WRITE_ONCE(f6i->trap, trap);
 
+	fib_notify_on_flag_change = READ_ONCE(net->ipv6.sysctl.fib_notify_on_flag_change);
 	/* 2 means send notifications only if offload_failed was changed. */
-	if (net->ipv6.sysctl.fib_notify_on_flag_change == 2 &&
+	if (fib_notify_on_flag_change == 2 &&
 	    READ_ONCE(f6i->offload_failed) == offload_failed)
 		return;
 
@@ -6432,7 +6434,7 @@ void fib6_info_hw_flags_set(struct net *net, struct fib6_info *f6i,
 		 */
 		return;
 
-	if (!net->ipv6.sysctl.fib_notify_on_flag_change)
+	if (!fib_notify_on_flag_change)
 		return;
 
 	skb = nlmsg_new(rt6_nlmsg_size(f6i), GFP_KERNEL);
@@ -6529,7 +6531,7 @@ static int ipv6_sysctl_rtcache_flush(const struct ctl_table *ctl, int write,
 		return ret;
 
 	net = (struct net *)ctl->extra1;
-	delay = net->ipv6.sysctl.flush_delay;
+	delay = READ_ONCE(net->ipv6.sysctl.flush_delay);
 	fib6_run_gc(delay <= 0 ? 0 : (unsigned long)delay, net, delay > 0);
 	return 0;
 }
-- 
2.51.0

