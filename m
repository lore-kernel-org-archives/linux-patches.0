Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050286;
	b=0Jg5zVsUu6tjlg9P2XUHYr0kcGMcxYWjJOvOY8LqGckg9hjhhoZVys3dzcMP4hQLZbO0
	 TPDpoxUirBKS2aqQVjiLH/u/IWaLX1rFKgtvgOLflNqXHZZgcl4nyp2X13mdrjMGtnRG6
	 VQ0/Q5yOUDopBx+nQEzUZEBH/TQiPaG0XX5drPIHmSZ26sim38FKfWkfAKA9B2RiC1RJG
	 C84V+1u2SD7/IYBqmtONDSYHGn7f1GZAKqCNevNvK+dltuZnUDdeBfAWsJsdw2GCOiloN
	 9xL/Vbj5FG/2qA7lBPIBaaQXgtZ26lm90zzGjZRL8Y2RvwtWfajA/TyceOimqaN9FWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EIOjHgj3EJ3rwVxnXPj65t62ENKX82X8dm73IAYxfHY=;
	b=Y2ABzVna5SFha00qUBZb0OO4udE4SVmo0smTY8XMk7eIaq7dy6JILfSqbtkUsi5nGC0e
	 xJTvASsV9/+fkSuQVnxrAaaiJLf7rku2NBuEXaQpXMaGieNZdy45tN+p8/8ZiEyKmesV/
	 mniv6gq5fHhKFmzTfaVJeknQxI4WLh9x5xopC4VyNC30rLJzDWwyzmG+yAlX35cjWMkvA
	 gHOdzfM457bb9XvVwpmP8BDU0HvmlMrqVaGNWvrSoMNAFAiAaLrP0vgQfeE5Jcdq3+OQY
	 +g306yXDEqB0Id9vGHJp+eyKIaKf3yhrm5wlBolrnwCrP49Cr4HjO4McRGMSXuo+u5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pqhB0vCf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75537606A330;
	Thu, 19 Nov 2026 01:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pqhB0vCf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77B31F000C5;
	Thu, 19 Nov 2026 01:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050286;
	bh=EIOjHgj3EJ3rwVxnXPj65t62ENKX82X8dm73IAYxfHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pqhB0vCfKuqWFvDU4zIN6211pqDa9+uEOyZmBQGngvsbh4hX4qAisPmA4zIplVHyP
	 LEJVdg+pwjg2zTE3bML8OBIFBNE31Y+ivVFXCzX1fRqiUYLbmy0lL7WL5e1FWMWnGG
	 T6Mw4PClcV/BN4ilQIjXp701qFYJItB59UrGfTBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <netdev-bot+sashiko@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Eric Dumazet <edumazet@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2653/2857] ipv6: Hold RCU when emitting route hardware flags notification
Date: Wed, 18 Nov 2026 16:01:27 +0100
Message-ID: <20261118150337.114205523@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 7c9cb1edaf8fd8e1af25e39741e603500986ef66 ]

fib6_info_hw_flags_set() is called by drivers from process context
without RTNL or RCU. When the route uses a nexthop object,
rt6_nlmsg_size() and rt6_fill_node() access the nexthop's RCU protected
nexthop info and group pointers via rcu_dereference_rtnl(), resulting in
suspicious RCU usage splats [1].

Fix by holding RCU while sizing and filling the notification, like
fib_alias_hw_flags_set() already does. Switch to GFP_ATOMIC for the skb
allocation accordingly.

Reproducer:

 # echo "10 0" > /sys/bus/netdevsim/new_device
 # sysctl -wq net.ipv6.fib_notify_on_flag_change=1
 # sysctl -wq net.ipv4.nexthop_compat_mode=1
 # ip -6 nexthop add id 1 blackhole
 # ip -6 route add 2001:db8:1::1/128 nhid 1

[1]
WARNING: suspicious RCU usage
7.3.0-rc7-virtme-g191aa41548b2 #38 Not tainted
net/ipv4/nexthop.c:1539 suspicious rcu_dereference_check() usage!
[...]
Workqueue: events nsim_fib_event_work
Call Trace:
 <TASK>
 dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
 lockdep_rcu_suspicious.cold (kernel/locking/lockdep.c:6972)
 nexthop_for_each_fib6_nh (net/ipv4/nexthop.c:1539 (discriminator 16))
 rt6_nlmsg_size (net/ipv6/route.c:5728)
 fib6_info_hw_flags_set (net/ipv6/route.c:6503)
 nsim_fib6_rt_add (drivers/net/netdevsim/fib.c:671 drivers/net/netdevsim/fib.c:694)
 nsim_fib6_rt_insert (drivers/net/netdevsim/fib.c:759)
 nsim_fib_event_work (drivers/net/netdevsim/fib.c:856 drivers/net/netdevsim/fib.c:889 drivers/net/netdevsim/fib.c:1493)
 process_one_work (kernel/workqueue.c:3396)
 worker_thread (kernel/workqueue.c:3479 kernel/workqueue.c:3560)
 kthread (kernel/kthread.c:436)
 ret_from_fork (arch/x86/kernel/process.c:158)
 ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
 </TASK>

Fixes: 907eea486888 ("net: ipv6: Emit notification when fib hardware flags are changed")
Reported-by: Sashiko <netdev-bot+sashiko@kernel.org>
Closes: https://lore.kernel.org/netdev/179152182668.434549.18232968419539498055@kernel.org/
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20261019140337.2886875-2-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 96f6dbee2fda3..526a5c7174236 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6333,7 +6333,9 @@ void fib6_info_hw_flags_set(struct net *net, struct fib6_info *f6i,
 	if (!net->ipv6.sysctl.fib_notify_on_flag_change)
 		return;
 
-	skb = nlmsg_new(rt6_nlmsg_size(f6i), GFP_KERNEL);
+	rcu_read_lock();
+
+	skb = nlmsg_new(rt6_nlmsg_size(f6i), GFP_ATOMIC);
 	if (!skb) {
 		err = -ENOBUFS;
 		goto errout;
@@ -6346,10 +6348,13 @@ void fib6_info_hw_flags_set(struct net *net, struct fib6_info *f6i,
 		goto errout;
 	}
 
+	rcu_read_unlock();
+
 	rtnl_notify(skb, net, 0, RTNLGRP_IPV6_ROUTE, NULL, GFP_KERNEL);
 	return;
 
 errout:
+	rcu_read_unlock();
 	rtnl_set_sk_err(net, RTNLGRP_IPV6_ROUTE, err);
 }
 EXPORT_SYMBOL(fib6_info_hw_flags_set);
-- 
2.53.0



