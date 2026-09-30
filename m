Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551B94F0550;
	Wed, 30 Sep 2026 15:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783292; cv=none; b=dpGatjFDH3D/rLQ1xwng3DWfU4uAsG4uk6OLzybk3esQZgfTZcoup4UhEzIF5iuBdKvDgL4PJ8HqIdQNm37ib+R8poaQ78E+ZwYPLIKV7+9L+iC73lQiLTj61nWEIDwAVP00cmC3DtvMkBsXfg+frTYg75zza8NR/N1y2fVdf5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783292; c=relaxed/simple;
	bh=0XF+dlPrL80fPpTzUSr1RQWawawwMetMyBfkfIpU4U8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RjeTT/3ro8AlZ91P2KWENGUVR4aaPVjPa000r7dYKk85q6UGANqTFlEbtsqpDnBsUIvRfau5L+/ZgHQTIzy1a10ASV8mQ/Ra4+oFGsEObIz3olKHTBdUsVCi5Vq0fD3BkIw1dI/6cbfoxEGTMiM63LR8MoTeTZhpFBao32m+xMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I/Rf31d3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/Rf31d3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655231F000FF;
	Wed, 30 Sep 2026 15:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783287;
	bh=FvTGfRoC08H4Z3xFPUkaEyZuNUxwLzTGBf1C9+HR6Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I/Rf31d3zkXTljxX/4yqCaoHziTkKVuchBE7lmCbnZ0ii+7Ap7oWs6c6inFZObaNj
	 zjNuP6KeV2RmTTZrTKuSJQPviRtwa0Pi/6eN3Y/rJiNsGjcq12f+8ULb1YexLlZbOx
	 7lsBr5sI5Dw8pHVJ/JNKBw08nz8OlcuUYYkJpavI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 344/595] ipv6: Honor oif when choosing nexthop for locally generated traffic
Date: Wed, 30 Sep 2026 17:23:57 +0200
Message-ID: <20260930152355.075864142@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit d25e7e9d8a6c1e2afb854613e417c6aa1a28ce6f ]

Commit 741a11d9e410 ("net: ipv6: Add RT6_LOOKUP_F_IFACE flag if oif is
set") made the kernel honor the oif parameter when specified as part of
output route lookup:

 # ip route add 2001:db8:1::/64 dev dummy1
 # ip route add ::/0 dev dummy2
 # ip route get 2001:db8:1::1 oif dummy2 fibmatch
 default dev dummy2 metric 1024 pref medium

Due to regression reports, the behavior was partially reverted in commit
d46a9d678e4c ("net: ipv6: Dont add RT6_LOOKUP_F_IFACE flag if saddr
set") to only honor the oif if source address is not specified:

 # ip route get 2001:db8:1::1 from 2001:db8:2::1 oif dummy2 fibmatch
 2001:db8:1::/64 dev dummy1 metric 1024 pref medium

That is, when source address is specified, the kernel will choose the
most specific route even if its nexthop device does not match the
specified oif.

This creates a problem for multipath routes. After looking up a route,
when source address is not specified, the kernel will choose a nexthop
whose nexthop device matches the specified oif:

 # sysctl -wq net.ipv6.conf.all.forwarding=1
 # ip route add 2001:db8:10::/64 nexthop via fe80::1 dev dummy1 nexthop via fe80::2 dev dummy2
 # for i in {1..100}; do ip route get 2001:db8:10::${i} oif dummy2; done | grep -o dummy[0-9] | sort | uniq -c
      100 dummy2

But will disregard the oif when source address is specified despite the
fact that a matching nexthop exists:

 # for i in {1..100}; do ip route get 2001:db8:10::${i} from 2001:db8:2::1 oif dummy2; done | grep -o dummy[0-9] | sort | uniq -c
      53 dummy1
      47 dummy2

This behavior differs from IPv4:

 # ip address add 192.0.2.1/32 dev lo
 # ip route add 198.51.100.0/24 nexthop via inet6 fe80::1 dev dummy1 nexthop via inet6 fe80::2 dev dummy2
 # for i in {1..100}; do ip route get 198.51.100.${i} from 192.0.2.1 oif dummy2; done | grep -o dummy[0-9] | sort | uniq -c
     100 dummy2

What happens is that fib6_table_lookup() returns a route with a matching
nexthop device (assuming it exists):

 # perf record -e fib6:fib6_table_lookup -- bash -c "for i in {1..100}; do ip route get 2001:db8:10::${i} from 2001:db8:2::1 oif dummy2; done > /dev/null"
 # perf script | grep -o dummy[0-9] | sort | uniq -c
      100 dummy2

But it is later overwritten during path selection in fib6_select_path()
which instead chooses a nexthop according to the calculated hash.

Solve this by telling fib6_select_path() to skip path selection if we
have an oif match during output route lookup (iif being
LOOPBACK_IFINDEX).

Behavior after the change:

 # sysctl -wq net.ipv6.conf.all.forwarding=1
 # ip route add 2001:db8:10::/64 nexthop via fe80::1 dev dummy1 nexthop via fe80::2 dev dummy2
 # for i in {1..100}; do ip route get 2001:db8:10::${i} from 2001:db8:2::1 oif dummy2; done | grep -o dummy[0-9] | sort | uniq -c
     100 dummy2

Note that enabling forwarding is only needed because we did not add
neighbor entries for the gateway addresses. When forwarding is disabled
and CONFIG_IPV6_ROUTER_PREF is not enabled in kernel config, the kernel
will treat non-existing neighbor entries as errors and perform
round-robin between the nexthops:

 # sysctl -wq net.ipv6.conf.all.forwarding=0
 # for i in {1..100}; do ip route get 2001:db8:10::${i} from 2001:db8:2::1 oif dummy2; done | grep -o dummy[0-9] | sort | uniq -c
      50 dummy1
      50 dummy2

Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260611154605.992528-3-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 0cbde55f5c946..0439d9e6a9601 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2207,6 +2207,7 @@ struct rt6_info *ip6_pol_route(struct net *net, struct fib6_table *table,
 {
 	struct fib6_result res = {};
 	struct rt6_info *rt = NULL;
+	bool have_oif_match;
 	int strict = 0;
 
 	WARN_ON_ONCE((flags & RT6_LOOKUP_F_DST_NOREF) &&
@@ -2223,7 +2224,9 @@ struct rt6_info *ip6_pol_route(struct net *net, struct fib6_table *table,
 	if (res.f6i == net->ipv6.fib6_null_entry)
 		goto out;
 
-	fib6_select_path(net, &res, fl6, oif, false, skb, strict);
+	have_oif_match = fl6->flowi6_iif == LOOPBACK_IFINDEX &&
+			 oif == res.nh->fib_nh_dev->ifindex;
+	fib6_select_path(net, &res, fl6, oif, have_oif_match, skb, strict);
 
 	/*Search through exception table */
 	rt = rt6_find_cached_rt(&res, &fl6->daddr, &fl6->saddr);
-- 
2.53.0



