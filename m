Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4B5383C86;
	Wed, 30 Sep 2026 18:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791818; cv=none; b=Ep6EJ0sps1Gs+wlSm7TsXUwe5++Xt9nl2ZmadEkutv+u80/gp4JkWg9tAjT+U9rtNd13DL42Q4RoO0N3/bfQN2dF3ocryFqkff+9yWVCFBKwMChuYy/QsY4EHkr80QkC9XcS1hOjCaYyIKZnfUckcjaCdMh22o59RW/2GcPvLcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791818; c=relaxed/simple;
	bh=XbdaOQHlHWatWugQWogAm0s3AZGGAnr3W3Y1Vip7pl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ViAL7Xg2BmBIOw8LNyGuG+ZYz+2WgRYdcmZUDKl3oO2kV7XHNxiUk6R0BSw+H5XYFFYTu0pchWHxXZ6CwMEMxK+bJluAVhW8LPQn9o68VNmsJ4sf6T63SG6EtoNwct15m2P10/7amWHmba2SqHodO0+HXgJaxsAS13U5UFBKUII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R1NTDHuQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1NTDHuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DA21F000FF;
	Wed, 30 Sep 2026 18:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791817;
	bh=yyE5sxpFhjfK2d7ceMV2feC1BdFSxWSdrikdZmW7KNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R1NTDHuQ6Vzxcl3dJoJOKF11coZDc2d9cyv1TGDO1ZNv7eZkzpVp3qMcuwTqofvPr
	 wZOHB5j9240fi682lwjFMLtr8DUSLMQVhC1OSudR6jpl3llvR+Rg4Jn3Ebg2Jryoxb
	 BugxZRduyfyff8dNy417LsXAC2XQLHtgn+cGy97Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 436/752] ipv6: Honor oif when choosing nexthop for locally generated traffic
Date: Wed, 30 Sep 2026 17:25:06 +0200
Message-ID: <20260930152407.717910922@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 56e266342ee22..6e3e20eae1240 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2206,6 +2206,7 @@ struct rt6_info *ip6_pol_route(struct net *net, struct fib6_table *table,
 {
 	struct fib6_result res = {};
 	struct rt6_info *rt = NULL;
+	bool have_oif_match;
 	int strict = 0;
 
 	WARN_ON_ONCE((flags & RT6_LOOKUP_F_DST_NOREF) &&
@@ -2222,7 +2223,9 @@ struct rt6_info *ip6_pol_route(struct net *net, struct fib6_table *table,
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



