Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705292;
	b=R5L9uH1lnyUq4Q/V4R+FRobV+kipFZJjGaFZGulQBErsCj6HzMhsJe75MLms9Bu1XOjk
	 /LBCH8BwdFOCUPwNxebOQEF165jqe45B/bm4a9vta/nBjinL8ZhQ+qvoLARMVYqOfKJ1F
	 RtLJ0EmYgYBi8Moy6vCwLoOkfuPiuxpSFUnWcKi9Rv6THc25n5ziDvTvUmYCepVdReCPN
	 0dtmqoI8v8sTpFOOuNEEZlKtFStLk5zVxnKKAXhLqe1tQUa35bEuBut64qd7ehFN8KUEk
	 U4UoZloRwiWNcjN8Mige38yT8QsZXiPwByqkxtqtBpb2iGdi8kOj2l+Nnlr4oBKf/fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lu2lr0F8FwEovPbdAOilu3E0SA9drJa5bdn471Ins9M=;
	b=h7g9a7hJledM3XxIlUHYg0LbnIG6cEHBTdMPvda9HZc2ucy2z/ZdpysdSWuVSBxbQDRT
	 8J6ilcIJAREELXm9aRiE6pxWbPd4KbTl00J1kMdCYPh7Aa9fWwsx42RECiaxRYmiuhN3f
	 e5UpNzsYO36XOmVyAjx0AFGZe5EcUKHf5nJSzJty7u6RRzvVHH/9SXbMVI+To8qUFSMgO
	 Z+9G4bJZTnBkwRBsIdxjS397uZritpl0AtIYoF8nqqlrXpcF3g7nTxw+8VQqOOYujg3Hj
	 7iphBZPqZcG5ArBstv9fjXwYrPAAB7dZPPlDMD6xLGmZ89H2chbwXaWHw1+kIFHh6/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GYkl2yvy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96656606A321;
	Thu, 26 Nov 2026 15:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GYkl2yvy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9080C1F000C4;
	Thu, 26 Nov 2026 15:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705292;
	bh=Lu2lr0F8FwEovPbdAOilu3E0SA9drJa5bdn471Ins9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GYkl2yvyjr34+rHtpYSGh+oVB+HlIxiPg9KxZkgn0PxIsyuZW6x22X+3uziHjkNY2
	 zcQSwE/G0966aRs9h/tuOekdLTPM3KR1qYExluRVdbvnV4UCv48kZ5yjxx6Pat79gm
	 PQge9f4XdojrVlZuHdGCSRMAmhJ1c0+nOPZBF0iY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Chase Hiltz <me@chasehil.tz>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 149/319] ipv4: route: dont blackhole in-use routes when retiring fnhe routes
Date: Thu, 26 Nov 2026 15:38:37 +0100
Message-ID: <20261126144010.109903978@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fd63c7540f1dd..0440fe07e0a16 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -593,6 +593,17 @@ static void ip_rt_build_flow_key(struct flowi4 *fl4, const struct sock *sk,
 
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
@@ -600,14 +611,12 @@ static void fnhe_flush_routes(struct fib_nh_exception *fnhe)
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
 
@@ -1516,10 +1525,8 @@ static bool rt_bind_exception(struct rtable *rt, struct fib_nh_exception *fnhe,
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



