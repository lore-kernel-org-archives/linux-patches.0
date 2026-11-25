Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624855;
	b=ja5xXvCHOU5/ZztvXEJLhZUE1VBUzLl/hCvS7BMWXxcTASHuMT1OHFFF+nL8zVORo0wJ
	 SveJqZOwVQ0OZmITvmRbyjWoU+e27qe73HOqzJsOzUDXfeV9BLn+desoPBA4xMhY8I7ee
	 H9climT8xFkonngjjdsOLaFzxi9Y10pRtO8tLZ0Jn/OU3IXajQv+aTC6keFq/v1EmaUEE
	 9dJnmst0MvnnGttsTqXO5y8FxrDx8AayMpx0WdrIHh3iZi63bVirRcRuKh8dsq+tXUMZg
	 lJ0/pH0WkETwHvShrEGJ+MU0aJn+2ElydSZ+E/CeyiFRhGIJgp34R3WvooFAJKDrwmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nbIPAFXXIs6S8pKdDQMiWcaOQsoGCq20K85u/dMJrn4=;
	b=VEJyt517cD2Z+BLOjnVOsX9pvQn1Yf7YtGPFeSlx4KPbTuWZSdaIYiD04j9oO7ipLDQ+
	 tcEKcJjvKYANZm2YHC3i55IbYHV+Pt3LhzNradunlzAgVkZ3wh9zhHNwWa7p31KM8QoGn
	 OmmX4kcdw972UvVLj7Wgrl4olF6DcB+/ZuIa59oXWnmVmNfPfCIpWckOnaXzPii0eewk3
	 X61F4Xt9e1eSuJcPYuix/28NWZFWjKnDkRurssXMT+BeIdFPrIHdu8bWNEwMhb4I7AJa8
	 YyS+qI9lSchyRazw3Z4K1YC6WfgTSgDkwWrch/jfCBFETEQglwQPjvB8N4A89tXxAgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a0nfu79D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E5D606A31E;
	Wed, 25 Nov 2026 16:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a0nfu79D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503951F000C6;
	Wed, 25 Nov 2026 16:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624854;
	bh=nbIPAFXXIs6S8pKdDQMiWcaOQsoGCq20K85u/dMJrn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a0nfu79DE1IK6SH88YHqAbAZ80P2UuWQDN0cpNjqIYJrotMTx3qIbRYHlx6lQ9p14
	 BSN41VyV79tDhOytgC6XJ8Z9RKVfCSMH5QBRsv3lSc+R9rA6tNMCU/Fa6Wjg3JyR13
	 l8LhvySnhq126b71dcVVKg6MeSDFBCc0/KrQ5+NA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Chase Hiltz <me@chasehil.tz>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 329/816] ipv4: route: dont blackhole in-use routes when retiring fnhe routes
Date: Wed, 25 Nov 2026 15:31:17 +0100
Message-ID: <20261125143856.815632731@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chase Hiltz <me@chasehil.tz>

[ Upstream commit ae89f2724db1afa96a1f1b661174fc41ae1e88fa ]

When a route cached in a nexthop exception (fnhe) is replaced or
flushed, rt_bind_exception() and fnhe_flush_routes() call
dst_dev_put() on it. That sets dst->dev to blackhole_netdev and
dst->input/output to dst_discard*(), but other CPUs can still be
using the route, e.g. as a noref dst taken from the fnhe under RCU.
Packets that reach dst_input() or dst_output() after that are dropped.

If dst_dev_put() runs after a forwarded packet has entered ip_output(),
ip_skb_dst_mtu() in __ip_finish_output() can return the MTU of
blackhole_netdev (68), and ip_fragment() can then drop a DF packet and
send ICMP_FRAG_NEEDED with mtu 68 to its source.

Commit 5018c59607a5 ("ipv4: fix race condition between route lookup and
invalidation") fixed the same race in rt_cache_route() by putting the
old route on the uncached list instead of calling dst_dev_put(). Do the
same for routes retired from an fnhe. rt_flush_dev() still moves them
to blackhole_netdev when their device is unregistered.

fnhe routes are also retired on fnhe expiry (ip_del_fnhe()) and
eviction (fnhe_remove_oldest()). Those paths don't bump rt_genid, so
without the obsolete marking ipv4_dst_check() could still accept the
route. Keep marking retired routes DST_OBSOLETE_DEAD, as dst_dev_put()
did, so that users that cached them, such as sockets, look up again.

In a netns reproducer that forwards IPv4 traffic over an ip6tnl device,
with an fnhe for the destination, while the FIB keeps changing, this
patch stops the mtu 68 ICMPs and the drops.

Fixes: 95c47f9cf5e0 ("ipv4: call dst_dev_put() properly")
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Signed-off-by: Chase Hiltz <me@chasehil.tz>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20261105182640.2999521-1-me@chasehil.tz
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 9706d36c8388c..6bfac6239fff8 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -571,6 +571,17 @@ static void ip_rt_build_flow_key(struct flowi4 *fl4, const struct sock *sk,
 
 static DEFINE_SPINLOCK(fnhe_lock);
 
+/* Other CPUs may still be using @rt, so don't dst_dev_put() it.
+ * rt_flush_dev() handles it if its device is unregistered.
+ * Marking it dead makes ipv4_dst_check() fail for users that cached it.
+ */
+static void fnhe_retire_route(struct rtable *rt)
+{
+	WRITE_ONCE(rt->dst.obsolete, DST_OBSOLETE_DEAD);
+	rt_add_uncached_list(rt);
+	dst_release(&rt->dst);
+}
+
 static void fnhe_flush_routes(struct fib_nh_exception *fnhe)
 {
 	struct rtable *rt;
@@ -578,14 +589,12 @@ static void fnhe_flush_routes(struct fib_nh_exception *fnhe)
 	rt = rcu_dereference(fnhe->fnhe_rth_input);
 	if (rt) {
 		RCU_INIT_POINTER(fnhe->fnhe_rth_input, NULL);
-		dst_dev_put(&rt->dst);
-		dst_release(&rt->dst);
+		fnhe_retire_route(rt);
 	}
 	rt = rcu_dereference(fnhe->fnhe_rth_output);
 	if (rt) {
 		RCU_INIT_POINTER(fnhe->fnhe_rth_output, NULL);
-		dst_dev_put(&rt->dst);
-		dst_release(&rt->dst);
+		fnhe_retire_route(rt);
 	}
 }
 
@@ -1498,10 +1507,8 @@ static bool rt_bind_exception(struct rtable *rt, struct fib_nh_exception *fnhe,
 		if (do_cache) {
 			dst_hold(&rt->dst);
 			rcu_assign_pointer(*porig, rt);
-			if (orig) {
-				dst_dev_put(&orig->dst);
-				dst_release(&orig->dst);
-			}
+			if (orig)
+				fnhe_retire_route(orig);
 			ret = true;
 		}
 
-- 
2.53.0



