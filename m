Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3977C364931;
	Wed, 30 Sep 2026 16:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785418; cv=none; b=BkT0GQ81zSSpdKvN4lsjJpEbxBWWav+3BRBaaXpdlxocFVHFFPwQ4us6sTuQ/2nv0R5a5xUBSriSkajVb5wVf05o5xn+3k2NhHwE5aPVre9z0A0yIavMehhjAdrC+0H9d7P4GjB9vdxfNPsZzJ7tvzXFW01sFx/vySEUbZR+khc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785418; c=relaxed/simple;
	bh=vgwnrl/CxPEXtTMr4xp6UcgMwmJ/lkLIr52KE+M6FRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=arAFoF/2yGoYYjjRiDETebO7hXRLZH9U5SZgyS/tLtlFKZGgkGwkYDXXWElCGRCZvFbFVghgXxDPrUvxuJ1UiVPtXrkKZE2PVRPOXOiNBj81zRIwqeLnM6fCKshsY9SYtuqmqvc6s2MR3zdYELxuIif1/DOT2hjXpqq9l1mTKOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ck6ovErr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ck6ovErr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4381F00898;
	Wed, 30 Sep 2026 16:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785412;
	bh=GZE80gGDH8szRyMENmh1bzvE7QJ15KOPKAlU1aXBWfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ck6ovErrT9F5ackxm3VS0OdXzX6aZp8JnBR4nOcybuImYlADrdlTV57b0vR3JRcFv
	 kDygkQgZPSc0zG4aES5Caf1Vy3uuX3JeaRXXizADEWAExrNt8mvnicO4fPUAkGCoSu
	 auHlZsamNX0HlGxUVopQF53hAZ54ytMywZfibt+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Miguel Gazquez <miguel.gazquez@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 493/982] net: dst: add four helpers to annotate data-races around dst->dev
Date: Wed, 30 Sep 2026 17:20:29 +0200
Message-ID: <20260930152427.369837432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 88fe14253e181878c2ddb51a298ae8c468a63010 ]

dst->dev is read locklessly in many contexts,
and written in dst_dev_put().

Fixing all the races is going to need many changes.

We probably will have to add full RCU protection.

Add three helpers to ease this painful process.

static inline struct net_device *dst_dev(const struct dst_entry *dst)
{
       return READ_ONCE(dst->dev);
}

static inline struct net_device *skb_dst_dev(const struct sk_buff *skb)
{
       return dst_dev(skb_dst(skb));
}

static inline struct net *skb_dst_dev_net(const struct sk_buff *skb)
{
       return dev_net(skb_dst_dev(skb));
}

static inline struct net *skb_dst_dev_net_rcu(const struct sk_buff *skb)
{
       return dev_net_rcu(skb_dst_dev(skb));
}

Fixes: 4a6ce2b6f2ec ("net: introduce a new function dst_dev_put()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250630121934.3399505-7-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ minor modifications to fix conflict ]
Signed-off-by: Miguel Gazquez <miguel.gazquez@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dst.h | 20 ++++++++++++++++++++
 net/core/dst.c    |  4 ++--
 net/core/sock.c   |  6 +++---
 3 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index 20a76e532afbb..7c0cf856154de 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -555,6 +555,11 @@ static inline void skb_dst_update_pmtu_no_confirm(struct sk_buff *skb, u32 mtu)
 		dst->ops->update_pmtu(dst, NULL, skb, mtu, false);
 }
 
+static inline struct net_device *dst_dev(const struct dst_entry *dst)
+{
+	return READ_ONCE(dst->dev);
+}
+
 static inline struct net_device *dst_dev_rcu(const struct dst_entry *dst)
 {
 	/* In the future, use rcu_dereference(dst->dev) */
@@ -562,11 +567,26 @@ static inline struct net_device *dst_dev_rcu(const struct dst_entry *dst)
 	return READ_ONCE(dst->dev);
 }
 
+static inline struct net_device *skb_dst_dev(const struct sk_buff *skb)
+{
+	return dst_dev(skb_dst(skb));
+}
+
 static inline struct net_device *skb_dst_dev_rcu(const struct sk_buff *skb)
 {
 	return dst_dev_rcu(skb_dst(skb));
 }
 
+static inline struct net *skb_dst_dev_net(const struct sk_buff *skb)
+{
+	return dev_net(skb_dst_dev(skb));
+}
+
+static inline struct net *skb_dst_dev_net_rcu(const struct sk_buff *skb)
+{
+	return dev_net_rcu(skb_dst_dev(skb));
+}
+
 struct dst_entry *dst_blackhole_check(struct dst_entry *dst, u32 cookie);
 void dst_blackhole_update_pmtu(struct dst_entry *dst, struct sock *sk,
 			       struct sk_buff *skb, u32 mtu, bool confirm_neigh);
diff --git a/net/core/dst.c b/net/core/dst.c
index 8db87258d1450..24a1cc3d2a084 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -151,7 +151,7 @@ void dst_dev_put(struct dst_entry *dst)
 		dst->ops->ifdown(dst, dev, true);
 	dst->input = dst_discard;
 	dst->output = dst_discard_out;
-	dst->dev = blackhole_netdev;
+	WRITE_ONCE(dst->dev, blackhole_netdev);
 	netdev_ref_replace(dev, blackhole_netdev, &dst->dev_tracker,
 			   GFP_ATOMIC);
 }
@@ -272,7 +272,7 @@ unsigned int dst_blackhole_mtu(const struct dst_entry *dst)
 {
 	unsigned int mtu = dst_metric_raw(dst, RTAX_MTU);
 
-	return mtu ? : dst->dev->mtu;
+	return mtu ? : dst_dev(dst)->mtu;
 }
 EXPORT_SYMBOL_GPL(dst_blackhole_mtu);
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 2a701e0b052b7..64f9d77bfaec7 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2397,7 +2397,7 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 {
 	u32 max_segs = 1;
 
-	sk->sk_route_caps = dst->dev->features;
+	sk->sk_route_caps = dst_dev(dst)->features;
 	if (sk_is_tcp(sk))
 		sk->sk_route_caps |= NETIF_F_GSO;
 	if (sk->sk_route_caps & NETIF_F_GSO)
@@ -2410,11 +2410,11 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 		} else {
 			sk->sk_route_caps |= NETIF_F_SG | NETIF_F_HW_CSUM;
 			/* pairs with the WRITE_ONCE() in netif_set_gso_max_size() */
-			sk->sk_gso_max_size = READ_ONCE(dst->dev->gso_max_size);
+			sk->sk_gso_max_size = READ_ONCE(dst_dev(dst)->gso_max_size);
 			sk_trim_gso_size(sk);
 			sk->sk_gso_max_size -= (MAX_TCP_HEADER + 1);
 			/* pairs with the WRITE_ONCE() in netif_set_gso_max_segs() */
-			max_segs = max_t(u32, READ_ONCE(dst->dev->gso_max_segs), 1);
+			max_segs = max_t(u32, READ_ONCE(dst_dev(dst)->gso_max_segs), 1);
 		}
 	}
 	sk->sk_gso_max_segs = max_segs;
-- 
2.53.0



