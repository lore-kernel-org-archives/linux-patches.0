Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65508143872;
	Thu, 13 Jun 2024 11:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279204; cv=none; b=h4RgZjj/bIAYJiCkojxJzWFwVO/hjgTRu/FnUna2XVbhU38i41HKECnhXwmmrGV1256O2YC9L9X3hcVvgIhQeTsRfu1lUv7foNm3VvuIdKc4eN5b49llJpdaYp3z2D+R3alBAPPkpET3VOHi0YUp3+nIapefqpHispJtxLiDgU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279204; c=relaxed/simple;
	bh=yVvq4Q3hETOSE/aOAoNSL85G5ej7PAx7htbHrzAI0CQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VAXeWWAkNe6EXh+wA2f5oEIr04sv14KmCEJ1V2ZDAGX02jP909zOkQyVrPvKHn26tvvByCyd+hxtn4bgkZI9TcE37NVb24EyHDuU/Et9oS5WSDlvqG63a0/ZNnOatp0eOGvIcOe6owaooRG+unhlrHvv+7KKca91G6rmc2L3n7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wwq9mz0/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wwq9mz0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19D9C2BBFC;
	Thu, 13 Jun 2024 11:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279204;
	bh=yVvq4Q3hETOSE/aOAoNSL85G5ej7PAx7htbHrzAI0CQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wwq9mz0/TLQFuuzRdzrGMWRrU5MPR07odDiFWNFQxriqdxtyi0cGQsN4vBEQjCabK
	 ZglYSXmrM//csINRVIJWtgr7TAg/ltVkYyeukY/5bsmGf2NgzKsVbicNppMs/KdUxV
	 VVtoNAR+YiAM5xOWTqaMqig2elQKS0T0rZMZK/Es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clement Lecigne <clecigne@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Tom Herbert <tom@herbertland.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 4.19 209/213] net: fix __dst_negative_advice() race
Date: Thu, 13 Jun 2024 13:34:17 +0200
Message-ID: <20240613113236.045594402@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 92f1655aa2b2294d0b49925f3b875a634bd3b59e upstream.

__dst_negative_advice() does not enforce proper RCU rules when
sk->dst_cache must be cleared, leading to possible UAF.

RCU rules are that we must first clear sk->sk_dst_cache,
then call dst_release(old_dst).

Note that sk_dst_reset(sk) is implementing this protocol correctly,
while __dst_negative_advice() uses the wrong order.

Given that ip6_negative_advice() has special logic
against RTF_CACHE, this means each of the three ->negative_advice()
existing methods must perform the sk_dst_reset() themselves.

Note the check against NULL dst is centralized in
__dst_negative_advice(), there is no need to duplicate
it in various callbacks.

Many thanks to Clement Lecigne for tracking this issue.

This old bug became visible after the blamed commit, using UDP sockets.

Fixes: a87cb3e48ee8 ("net: Facility to report route quality of connected sockets")
Reported-by: Clement Lecigne <clecigne@google.com>
Diagnosed-by: Clement Lecigne <clecigne@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Tom Herbert <tom@herbertland.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20240528114353.1794151-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[Lee: Stable backport]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/dst_ops.h  |    2 +-
 include/net/sock.h     |   13 +++----------
 net/ipv4/route.c       |   22 ++++++++--------------
 net/ipv6/route.c       |   29 +++++++++++++++--------------
 net/xfrm/xfrm_policy.c |   11 +++--------
 5 files changed, 30 insertions(+), 47 deletions(-)

--- a/include/net/dst_ops.h
+++ b/include/net/dst_ops.h
@@ -24,7 +24,7 @@ struct dst_ops {
 	void			(*destroy)(struct dst_entry *);
 	void			(*ifdown)(struct dst_entry *,
 					  struct net_device *dev, int how);
-	struct dst_entry *	(*negative_advice)(struct dst_entry *);
+	void			(*negative_advice)(struct sock *sk, struct dst_entry *);
 	void			(*link_failure)(struct sk_buff *);
 	void			(*update_pmtu)(struct dst_entry *dst, struct sock *sk,
 					       struct sk_buff *skb, u32 mtu,
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1915,19 +1915,12 @@ sk_dst_get(struct sock *sk)
 
 static inline void dst_negative_advice(struct sock *sk)
 {
-	struct dst_entry *ndst, *dst = __sk_dst_get(sk);
+	struct dst_entry *dst = __sk_dst_get(sk);
 
 	sk_rethink_txhash(sk);
 
-	if (dst && dst->ops->negative_advice) {
-		ndst = dst->ops->negative_advice(dst);
-
-		if (ndst != dst) {
-			rcu_assign_pointer(sk->sk_dst_cache, ndst);
-			sk_tx_queue_clear(sk);
-			WRITE_ONCE(sk->sk_dst_pending_confirm, 0);
-		}
-	}
+	if (dst && dst->ops->negative_advice)
+		dst->ops->negative_advice(sk, dst);
 }
 
 static inline void
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -140,7 +140,8 @@ static int ip_rt_gc_timeout __read_mostl
 static struct dst_entry *ipv4_dst_check(struct dst_entry *dst, u32 cookie);
 static unsigned int	 ipv4_default_advmss(const struct dst_entry *dst);
 static unsigned int	 ipv4_mtu(const struct dst_entry *dst);
-static struct dst_entry *ipv4_negative_advice(struct dst_entry *dst);
+static void		ipv4_negative_advice(struct sock *sk,
+					     struct dst_entry *dst);
 static void		 ipv4_link_failure(struct sk_buff *skb);
 static void		 ip_rt_update_pmtu(struct dst_entry *dst, struct sock *sk,
 					   struct sk_buff *skb, u32 mtu,
@@ -848,22 +849,15 @@ static void ip_do_redirect(struct dst_en
 	__ip_do_redirect(rt, skb, &fl4, true);
 }
 
-static struct dst_entry *ipv4_negative_advice(struct dst_entry *dst)
+static void ipv4_negative_advice(struct sock *sk,
+				 struct dst_entry *dst)
 {
 	struct rtable *rt = (struct rtable *)dst;
-	struct dst_entry *ret = dst;
 
-	if (rt) {
-		if (dst->obsolete > 0) {
-			ip_rt_put(rt);
-			ret = NULL;
-		} else if ((rt->rt_flags & RTCF_REDIRECTED) ||
-			   rt->dst.expires) {
-			ip_rt_put(rt);
-			ret = NULL;
-		}
-	}
-	return ret;
+	if ((dst->obsolete > 0) ||
+	    (rt->rt_flags & RTCF_REDIRECTED) ||
+	    rt->dst.expires)
+		sk_dst_reset(sk);
 }
 
 /*
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -88,7 +88,8 @@ enum rt6_nud_state {
 static struct dst_entry	*ip6_dst_check(struct dst_entry *dst, u32 cookie);
 static unsigned int	 ip6_default_advmss(const struct dst_entry *dst);
 static unsigned int	 ip6_mtu(const struct dst_entry *dst);
-static struct dst_entry *ip6_negative_advice(struct dst_entry *);
+static void		ip6_negative_advice(struct sock *sk,
+					    struct dst_entry *dst);
 static void		ip6_dst_destroy(struct dst_entry *);
 static void		ip6_dst_ifdown(struct dst_entry *,
 				       struct net_device *dev, int how);
@@ -2281,24 +2282,24 @@ static struct dst_entry *ip6_dst_check(s
 	return dst_ret;
 }
 
-static struct dst_entry *ip6_negative_advice(struct dst_entry *dst)
+static void ip6_negative_advice(struct sock *sk,
+				struct dst_entry *dst)
 {
 	struct rt6_info *rt = (struct rt6_info *) dst;
 
-	if (rt) {
-		if (rt->rt6i_flags & RTF_CACHE) {
-			rcu_read_lock();
-			if (rt6_check_expired(rt)) {
-				rt6_remove_exception_rt(rt);
-				dst = NULL;
-			}
-			rcu_read_unlock();
-		} else {
-			dst_release(dst);
-			dst = NULL;
+	if (rt->rt6i_flags & RTF_CACHE) {
+		rcu_read_lock();
+		if (rt6_check_expired(rt)) {
+			/* counteract the dst_release() in sk_dst_reset() */
+			dst_hold(dst);
+			sk_dst_reset(sk);
+
+			rt6_remove_exception_rt(rt);
 		}
+		rcu_read_unlock();
+		return;
 	}
-	return dst;
+	sk_dst_reset(sk);
 }
 
 static void ip6_link_failure(struct sk_buff *skb)
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2556,15 +2556,10 @@ static void xfrm_link_failure(struct sk_
 	/* Impossible. Such dst must be popped before reaches point of failure. */
 }
 
-static struct dst_entry *xfrm_negative_advice(struct dst_entry *dst)
+static void xfrm_negative_advice(struct sock *sk, struct dst_entry *dst)
 {
-	if (dst) {
-		if (dst->obsolete) {
-			dst_release(dst);
-			dst = NULL;
-		}
-	}
-	return dst;
+	if (dst->obsolete)
+		sk_dst_reset(sk);
 }
 
 static void xfrm_init_pmtu(struct xfrm_dst **bundle, int nr)


