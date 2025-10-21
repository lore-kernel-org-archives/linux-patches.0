Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34FAA134AC;
	Tue, 21 Oct 2025 20:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077069; cv=none; b=VRlJVDl2TKLwmGGbaCcZ70UbTB4Or8DlS13DaME2ibrkyk/Onosv1MhcfhgsRVgPMwstTS8D1Q9Dj55nBJXNsOsMl5KlNv6vY1v8tOfDte+pcw1F3oOTy3loCsAVAR6NzweENi5QOUK6tf6Imm9BuzZXtwD4VjRiRxqc/OfPmJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077069; c=relaxed/simple;
	bh=x03amE9aXISPVOaFqP1vaE638cLgGNjTW0PeAE36wf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LA1Iw4esVf2Fq4kJULWbFV1BEgKUGIqZU+fcL8mv3VR+Yjrhpwn2VfwPmUtpULKX4HSMuJC/kAKGVcLOZWDQWLJIHh4bUqnmhjKxbAxti/HaYLRlMZw/ZQyG6tzUnDwxZ9VxnvGQSN1xlrqQdQBn50lQbNB6hh7ERl9RvKoIneM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d73eyf6u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d73eyf6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8199C4CEF1;
	Tue, 21 Oct 2025 20:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077069;
	bh=x03amE9aXISPVOaFqP1vaE638cLgGNjTW0PeAE36wf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d73eyf6u8vV7+Yftux+hjFj170Fz72IMZJDXLVj/qHx9jx2tQTEe4+gL2Jj2LQ5PU
	 esC+dGmcsvcexjeZActzQcq455DiHkNNr4MbXyWUA7s28/PakJIS40OIAdJKlDpYnP
	 +XsR2yIiw+oLGkHl12fE/fr4j1bIyCczl6U8Ih8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 125/136] net: dst: add four helpers to annotate data-races around dst->dev
Date: Tue, 21 Oct 2025 21:51:53 +0200
Message-ID: <20251021195038.988443676@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 833d4313bc1e ("mptcp: reset blackhole on success with non-loopback ifaces")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/dst.h |   20 ++++++++++++++++++++
 net/core/dst.c    |    4 ++--
 net/core/sock.c   |    8 ++++----
 3 files changed, 26 insertions(+), 6 deletions(-)

--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -561,6 +561,26 @@ static inline void skb_dst_update_pmtu_n
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
@@ -263,7 +263,7 @@ unsigned int dst_blackhole_mtu(const str
 {
 	unsigned int mtu = dst_metric_raw(dst, RTAX_MTU);
 
-	return mtu ? : dst->dev->mtu;
+	return mtu ? : dst_dev(dst)->mtu;
 }
 EXPORT_SYMBOL_GPL(dst_blackhole_mtu);
 
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2534,8 +2534,8 @@ static u32 sk_dst_gso_max_size(struct so
 		   !ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr));
 #endif
 	/* pairs with the WRITE_ONCE() in netif_set_gso(_ipv4)_max_size() */
-	max_size = is_ipv6 ? READ_ONCE(dst->dev->gso_max_size) :
-			READ_ONCE(dst->dev->gso_ipv4_max_size);
+	max_size = is_ipv6 ? READ_ONCE(dst_dev(dst)->gso_max_size) :
+			READ_ONCE(dst_dev(dst)->gso_ipv4_max_size);
 	if (max_size > GSO_LEGACY_MAX_SIZE && !sk_is_tcp(sk))
 		max_size = GSO_LEGACY_MAX_SIZE;
 
@@ -2546,7 +2546,7 @@ void sk_setup_caps(struct sock *sk, stru
 {
 	u32 max_segs = 1;
 
-	sk->sk_route_caps = dst->dev->features;
+	sk->sk_route_caps = dst_dev(dst)->features;
 	if (sk_is_tcp(sk)) {
 		struct inet_connection_sock *icsk = inet_csk(sk);
 
@@ -2564,7 +2564,7 @@ void sk_setup_caps(struct sock *sk, stru
 			sk->sk_route_caps |= NETIF_F_SG | NETIF_F_HW_CSUM;
 			sk->sk_gso_max_size = sk_dst_gso_max_size(sk, dst);
 			/* pairs with the WRITE_ONCE() in netif_set_gso_max_segs() */
-			max_segs = max_t(u32, READ_ONCE(dst->dev->gso_max_segs), 1);
+			max_segs = max_t(u32, READ_ONCE(dst_dev(dst)->gso_max_segs), 1);
 		}
 	}
 	sk->sk_gso_max_segs = max_segs;


