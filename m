Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704443;
	b=vZXDtvp1ox/WAv9Djgy4Afbug9+qsQVbf9m3zoAVJ2WSqmOqRknAXvjlFMSX6AkuqoIw
	 s0Afty8rj4J6OS9KFwpnObfs048jGSRBN+5Vl/8+VyFHeUq1tJPg6oYwXlVGRM8UKc9y5
	 VC1nmMFWuI/H5lAXS0sRihL5Olem8yWkRcJjLwN7STc9k/PYYgCb7aLdovYf0eGQigrTE
	 2+kRGyockgxMbfsV6MvHl2FcTK+pu2nug/LHiflLLe/VZ7MIJKBBHpcfuq4f/x3ufaa12
	 KfwaA4abnsDLcIutDdqE2rKUZt+WtpbcR48O3YGs5UI2MMvljjz5z2Jze3ePIIA5npg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704443;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A2sbCrRiA9QhQ/gLTHCuI6/1TCHU8E1eTQrCQq1Vy1U=;
	b=3kipYQlWMptdauJsbKX5Qp/uYPqsuDcBW95a13ffPq0R6nT+daCMazC7ZQA8Im2b+7RP
	 8fi6vsdQgcpxJuntOGm91g8Vst6MYUzplMBaBi9kF3ckdQ0ZJAjSbwmJdUozzfSb69U/1
	 iX9lSAkwoMqqKsnV0or43G3Rmy9T8z/Ry8UBXXehyTDI8qh9RzeRHGdyFcfqFXqcXbk1O
	 kAjf/12H07a1kUiRyopaypmU4x7fS8xunSXR+5g1y/2jkTZjbwvIreczRyU7ytNL2Ypio
	 LDm6A1+xm9g8/J+E1nkTmwXaYP1KBIEc2WKKEal5q4psyWqI32H4++JqqrSLWt8yz1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fxbmra2V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27F8606A31E;
	Thu, 26 Nov 2026 14:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fxbmra2V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A121F000C4;
	Thu, 26 Nov 2026 14:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704442;
	bh=A2sbCrRiA9QhQ/gLTHCuI6/1TCHU8E1eTQrCQq1Vy1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fxbmra2Vl4ldlsOACfX43MVIzIITarNwx4h7+TkkMXFws30lNh1NRhzT0m54v3HW+
	 98/XD2v7Pa0RJ/ZikhyUJw5rTyimxbvztmZ/+4PFgf6Yb9XlLu9+43Qq1CzZich1AM
	 V3+xyOv1CAK0DiEvswax6n0bzOopOVv4KrbyZD3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Chase Hiltz <me@chasehil.tz>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 126/265] ipv4: route: dont blackhole in-use routes when retiring fnhe routes
Date: Thu, 26 Nov 2026 15:37:36 +0100
Message-ID: <20261126143613.858488984@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8ab568e9314ad..a7f05cf709384 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -615,6 +615,17 @@ static void ip_rt_build_flow_key(struct flowi4 *fl4, const struct sock *sk,
 
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
@@ -622,14 +633,12 @@ static void fnhe_flush_routes(struct fib_nh_exception *fnhe)
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
 
@@ -1537,10 +1546,8 @@ static bool rt_bind_exception(struct rtable *rt, struct fib_nh_exception *fnhe,
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



