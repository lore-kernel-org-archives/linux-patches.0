Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A82853A7;
	Fri,  6 Dec 2024 15:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497416; cv=none; b=Kd79IuP6Hw5DgH0N5mn1UGfhKet71aAQqwQ+o7X0IDms89d7bL0ebV63j3mhQ5zzqsDoL1Zta81bMDUEIcZJj8BjgqeKaa1FF4O1juV7p8gtdcI15VS3Z5OpZNJBl51wiMw3fhE7dfp9JZ6B+6CvrD14ZTVzB2wT04wbUL7HlVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497416; c=relaxed/simple;
	bh=QLtpHCB8lSaToy/l1MS4HBz1yzt82sbyOOaEUxjps9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HSVxrrjFmyOyyIfKgHrW7NTttGxhQL7bc1or+YUZUpL0ZjD9qPGBtOszxApbgkDWhfG6rz/I9yy4B1mWcnlHNHRqhTvJw+ZkkHS3w5Bsdcx+WiGSCaHqKomUHWniPDJXpX8XfcjqydpocmZcPrrf8Er/xo+LXroeHYKVq33IYOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DtS6ajQo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DtS6ajQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D56AC4CEDC;
	Fri,  6 Dec 2024 15:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497415;
	bh=QLtpHCB8lSaToy/l1MS4HBz1yzt82sbyOOaEUxjps9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DtS6ajQo+VhOYjfnltqIPA8G4vJBlqIeTypwRbwb1APCC8RWE1A0+jbQci/OmW2Pa
	 wJ2oVn+9vtCRYx9luDmfpORcwN5IgaMWx9MCl2ETFql/T4C53jGCniRpZMDGR9YCqD
	 zVn9t17U49+FYZow79wRzduZIqECkJM/JgpAZE14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 244/676] ipv6: release nexthop on device removal
Date: Fri,  6 Dec 2024 15:31:03 +0100
Message-ID: <20241206143702.862224624@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit eb02688c5c45c3e7af7e71f036a7144f5639cbfe ]

The CI is hitting some aperiodic hangup at device removal time in the
pmtu.sh self-test:

unregister_netdevice: waiting for veth_A-R1 to become free. Usage count = 6
ref_tracker: veth_A-R1@ffff888013df15d8 has 1/5 users at
	dst_init+0x84/0x4a0
	dst_alloc+0x97/0x150
	ip6_dst_alloc+0x23/0x90
	ip6_rt_pcpu_alloc+0x1e6/0x520
	ip6_pol_route+0x56f/0x840
	fib6_rule_lookup+0x334/0x630
	ip6_route_output_flags+0x259/0x480
	ip6_dst_lookup_tail.constprop.0+0x5c2/0x940
	ip6_dst_lookup_flow+0x88/0x190
	udp_tunnel6_dst_lookup+0x2a7/0x4c0
	vxlan_xmit_one+0xbde/0x4a50 [vxlan]
	vxlan_xmit+0x9ad/0xf20 [vxlan]
	dev_hard_start_xmit+0x10e/0x360
	__dev_queue_xmit+0xf95/0x18c0
	arp_solicit+0x4a2/0xe00
	neigh_probe+0xaa/0xf0

While the first suspect is the dst_cache, explicitly tracking the dst
owing the last device reference via probes proved such dst is held by
the nexthop in the originating fib6_info.

Similar to commit f5b51fe804ec ("ipv6: route: purge exception on
removal"), we need to explicitly release the originating fib info when
disconnecting a to-be-removed device from a live ipv6 dst: move the
fib6_info cleanup into ip6_dst_ifdown().

Tested running:

./pmtu.sh cleanup_ipv6_exception

in a tight loop for more than 400 iterations with no spat, running an
unpatched kernel  I observed a splat every ~10 iterations.

Fixes: f88d8ea67fbd ("ipv6: Plumb support for nexthop object in a fib6_info")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/604c45c188c609b732286b47ac2a451a40f6cf6d.1730828007.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 341a42c2d6f14..e320dfa7fe7fc 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -376,6 +376,7 @@ static void ip6_dst_ifdown(struct dst_entry *dst, struct net_device *dev)
 {
 	struct rt6_info *rt = (struct rt6_info *)dst;
 	struct inet6_dev *idev = rt->rt6i_idev;
+	struct fib6_info *from;
 
 	if (idev && idev->dev != blackhole_netdev) {
 		struct inet6_dev *blackhole_idev = in6_dev_get(blackhole_netdev);
@@ -385,6 +386,8 @@ static void ip6_dst_ifdown(struct dst_entry *dst, struct net_device *dev)
 			in6_dev_put(idev);
 		}
 	}
+	from = unrcu_pointer(xchg(&rt->from, NULL));
+	fib6_info_release(from);
 }
 
 static bool __rt6_check_expired(const struct rt6_info *rt)
@@ -1447,7 +1450,6 @@ static DEFINE_SPINLOCK(rt6_exception_lock);
 static void rt6_remove_exception(struct rt6_exception_bucket *bucket,
 				 struct rt6_exception *rt6_ex)
 {
-	struct fib6_info *from;
 	struct net *net;
 
 	if (!bucket || !rt6_ex)
@@ -1459,8 +1461,6 @@ static void rt6_remove_exception(struct rt6_exception_bucket *bucket,
 	/* purge completely the exception to allow releasing the held resources:
 	 * some [sk] cache may keep the dst around for unlimited time
 	 */
-	from = unrcu_pointer(xchg(&rt6_ex->rt6i->from, NULL));
-	fib6_info_release(from);
 	dst_dev_put(&rt6_ex->rt6i->dst);
 
 	hlist_del_rcu(&rt6_ex->hlist);
-- 
2.43.0



