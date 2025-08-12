Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B9321C187;
	Tue, 12 Aug 2025 19:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025742; cv=none; b=MBQqEOGKkewuAF1XlM/EmFh1hUFkt7HmKoh9CXSprf3YwgUE9YTMFqA25MEst+NPqKrPCPCwRoEuBJFNyLVZTKQRYrhrQQZl18b21Jz14nL2GP6n+2wudmN6EL+drkDn5xk0PKupp2zLQ9yjtd2SQihZxZ2U8ZHlMopTiAFzFWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025742; c=relaxed/simple;
	bh=e8Lrge0xACZuYFhbaOVuMJMPSd/r7eXQkfNvuW3b/E4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aN/zWJQU1qJgrku8aCmRyJl63UYPcSyOsaDIPdBR8v+pD5YM3IEB4rC2AWrTIt6/PkF6zuLm7Ff4tk9gpQQHdA1q3oYcbmVuN4+z1FYDZU+aMbQoMuWvoaLi14pgZKV3ga+8wCdrOVR8JKSESSLYuWfw4jGODT5E2G/S+of87zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+82OSJn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+82OSJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D3BC4CEF0;
	Tue, 12 Aug 2025 19:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025742;
	bh=e8Lrge0xACZuYFhbaOVuMJMPSd/r7eXQkfNvuW3b/E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+82OSJnIG2KzIQUFwxr1a4Gp5GJ5DhmJgLeQAL/D4Z9GXxFnXz09kCDePHWi+R/P
	 FfiLZ4BNkGTAguvXWTG4z2NVvtQxF4wWPJSiUIlMwlntfbixoSlB5O8/zyL3MmFCxh
	 kFNxGLjct241x/Ua4fPC3g96aVifVM4J9GnAQT8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 131/480] net: dst: add four helpers to annotate data-races around dst->dev
Date: Tue, 12 Aug 2025 19:45:39 +0200
Message-ID: <20250812174402.928932113@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dst.h | 20 ++++++++++++++++++++
 net/core/dst.c    |  4 ++--
 net/core/sock.c   |  8 ++++----
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index 2caf85e2ce86..32dafbab4cd0 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -561,6 +561,26 @@ static inline void skb_dst_update_pmtu_no_confirm(struct sk_buff *skb, u32 mtu)
 		dst->ops->update_pmtu(dst, NULL, skb, mtu, false);
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
diff --git a/net/core/dst.c b/net/core/dst.c
index e483daf17666..b3a12c7c08af 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -150,7 +150,7 @@ void dst_dev_put(struct dst_entry *dst)
 		dst->ops->ifdown(dst, dev);
 	WRITE_ONCE(dst->input, dst_discard);
 	WRITE_ONCE(dst->output, dst_discard_out);
-	dst->dev = blackhole_netdev;
+	WRITE_ONCE(dst->dev, blackhole_netdev);
 	netdev_ref_replace(dev, blackhole_netdev, &dst->dev_tracker,
 			   GFP_ATOMIC);
 }
@@ -263,7 +263,7 @@ unsigned int dst_blackhole_mtu(const struct dst_entry *dst)
 {
 	unsigned int mtu = dst_metric_raw(dst, RTAX_MTU);
 
-	return mtu ? : dst->dev->mtu;
+	return mtu ? : dst_dev(dst)->mtu;
 }
 EXPORT_SYMBOL_GPL(dst_blackhole_mtu);
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 3e8c548cb1f8..bcd0d6c757ce 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2557,8 +2557,8 @@ static u32 sk_dst_gso_max_size(struct sock *sk, struct dst_entry *dst)
 		   !ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr));
 #endif
 	/* pairs with the WRITE_ONCE() in netif_set_gso(_ipv4)_max_size() */
-	max_size = is_ipv6 ? READ_ONCE(dst->dev->gso_max_size) :
-			READ_ONCE(dst->dev->gso_ipv4_max_size);
+	max_size = is_ipv6 ? READ_ONCE(dst_dev(dst)->gso_max_size) :
+			READ_ONCE(dst_dev(dst)->gso_ipv4_max_size);
 	if (max_size > GSO_LEGACY_MAX_SIZE && !sk_is_tcp(sk))
 		max_size = GSO_LEGACY_MAX_SIZE;
 
@@ -2569,7 +2569,7 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 {
 	u32 max_segs = 1;
 
-	sk->sk_route_caps = dst->dev->features;
+	sk->sk_route_caps = dst_dev(dst)->features;
 	if (sk_is_tcp(sk)) {
 		struct inet_connection_sock *icsk = inet_csk(sk);
 
@@ -2587,7 +2587,7 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 			sk->sk_route_caps |= NETIF_F_SG | NETIF_F_HW_CSUM;
 			sk->sk_gso_max_size = sk_dst_gso_max_size(sk, dst);
 			/* pairs with the WRITE_ONCE() in netif_set_gso_max_segs() */
-			max_segs = max_t(u32, READ_ONCE(dst->dev->gso_max_segs), 1);
+			max_segs = max_t(u32, READ_ONCE(dst_dev(dst)->gso_max_segs), 1);
 		}
 	}
 	sk->sk_gso_max_segs = max_segs;
-- 
2.39.5



