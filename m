Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE79838A70B;
	Thu, 20 Aug 2026 16:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243399; cv=none; b=d0nNJQG6rz25CqMMnTj7CoBcBds25zVOI7lkwgq/sZ4Ey8G3mPHr4PX4kCIS6o/GvuYWMq9SZpGR3yJ4kJEo67r0MAgFKIGWnuHtnu1g+yHzOLs7z3fOCc4t6fZrvuEK88RULJ2tTLm0BHgq/Q9lq0euUtyGOKJHRrqmkJJ2BL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243399; c=relaxed/simple;
	bh=60PDNzzCpkjYwviU1susqhtdinz5C1SdzPZtapdBIWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FpGwxAABXDmnl39VgbbQcZWJLhKreRCaPb7uZrZLdLK/u31bwPYVZNb182A8xVMIe9X5B3Oo9pnqypAYjcIL/go9qqvme0rAA3u29v/8CCCdDsbQz7PUO6o9qrhE2ElbHaOv8EVuCBpVBGHfax+xFQ9ljE9KbRFirFQ8LQvvZB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCzr3l7D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCzr3l7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207B31F000E9;
	Thu, 20 Aug 2026 16:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243397;
	bh=TCsBBT0duKHJ7Q6LWzMnkqEGCM6RYvov2c4aYg9PTGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HCzr3l7DQ5UroZGl3XiQR9Ah9B7pkOWRNWZRPuKB0JiP3wzPRf0XPcW0gwRU7cZcD
	 fGHZ8gpN7+wZC33N31G57JbPCOF8YwgveeJ+KU9jKnmb0uWlbiBcCrfaBymucro1UG
	 Fnn2u0fxEcqxas3U91IpEOcfzlztRLWM6TqOdVPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/272] net: dst: add four helpers to annotate data-races around dst->dev
Date: Thu, 20 Aug 2026 16:54:26 +0200
Message-ID: <20260820145233.736173552@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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
Stable-dep-of: c9c9b37f8c55 ("netfilter: nf_queue: pin bridge device while NFQUEUE holds fake dst")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/dst.h |   20 ++++++++++++++++++++
 net/core/dst.c    |    4 ++--
 net/core/sock.c   |    6 +++---
 3 files changed, 25 insertions(+), 5 deletions(-)

--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -566,6 +566,26 @@ static inline struct net_device *skb_dst
 	return dst_dev_rcu(skb_dst(skb));
 }
 
+static inline struct net_device *dst_dev(const struct dst_entry *dst)
+{
+	return READ_ONCE(dst->dev);
+}
+
+static inline struct net_device *skb_dst_dev(const struct sk_buff *skb)
+{
+	return dst_dev(skb_dst(skb));
+}
+
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
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -151,7 +151,7 @@ void dst_dev_put(struct dst_entry *dst)
 		dst->ops->ifdown(dst, dev, true);
 	WRITE_ONCE(dst->input, dst_discard);
 	WRITE_ONCE(dst->output, dst_discard_out);
-	dst->dev = blackhole_netdev;
+	WRITE_ONCE(dst->dev, blackhole_netdev);
 	dev_hold(dst->dev);
 	dev_put(dev);
 }
@@ -272,7 +272,7 @@ unsigned int dst_blackhole_mtu(const str
 {
 	unsigned int mtu = dst_metric_raw(dst, RTAX_MTU);
 
-	return mtu ? : dst->dev->mtu;
+	return mtu ? : dst_dev(dst)->mtu;
 }
 EXPORT_SYMBOL_GPL(dst_blackhole_mtu);
 
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2192,7 +2192,7 @@ void sk_setup_caps(struct sock *sk, stru
 {
 	u32 max_segs = 1;
 
-	sk->sk_route_caps = dst->dev->features | sk->sk_route_forced_caps;
+	sk->sk_route_caps = dst_dev(dst)->features | sk->sk_route_forced_caps;
 	if (sk->sk_route_caps & NETIF_F_GSO)
 		sk->sk_route_caps |= NETIF_F_GSO_SOFTWARE;
 	sk->sk_route_caps &= ~sk->sk_route_nocaps;
@@ -2201,8 +2201,8 @@ void sk_setup_caps(struct sock *sk, stru
 			sk->sk_route_caps &= ~NETIF_F_GSO_MASK;
 		} else {
 			sk->sk_route_caps |= NETIF_F_SG | NETIF_F_HW_CSUM;
-			sk->sk_gso_max_size = dst->dev->gso_max_size;
-			max_segs = max_t(u32, dst->dev->gso_max_segs, 1);
+			sk->sk_gso_max_size = dst_dev(dst)->gso_max_size;
+			max_segs = max_t(u32, dst_dev(dst)->gso_max_segs, 1);
 		}
 	}
 	sk->sk_gso_max_segs = max_segs;


