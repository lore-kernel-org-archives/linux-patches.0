Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F06530B50F;
	Mon, 13 Oct 2025 15:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369543; cv=none; b=u7SHJud3Q5r8IoOTtY1YT/ZSygtYSVUvnblNEE0AmXKZylhbcoPzWgbNQ+WWPE+vp33ki3b82XBzFJpDbFl8Uq9VvCs04Tsb28D0RUUKRcaU0DCCDdkxZAU7msevveR283plJcuD6bExfApAavg8j8121ylMY6S506uwLYZFmYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369543; c=relaxed/simple;
	bh=LS7Sv0eWZDH+bUW56JhJaPYUv5PeU1gtn/8g7v64Yh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+0cnxYhUKbJcNLfr/ptsRxftqWjqr+N0RKMorD7kgKEXvlfu0YTDuExrK1A4VMo5+57d4kMLtJrqzc0ox4Q86F2wm/Ca9wvYeVPEllT/+qgjJuyUurxaoVvuJRq0VF5WSou7oxjdCOR/EPyVMtwM0efhfviz9KqVUfc3YVV2is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cqUeefee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cqUeefee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B385C116B1;
	Mon, 13 Oct 2025 15:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369543;
	bh=LS7Sv0eWZDH+bUW56JhJaPYUv5PeU1gtn/8g7v64Yh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cqUeefeeCU+cuyJkfv1jkrbL6Jrdh8b1vzNE6fyqEOLixYYm1lkvcWQJudL1h9PAS
	 Sm55ViffflQ9Fm86LNFauu2HV6zTWdYIgMclAI82l9/PatUhG2AjgZl2LugJM1ehJs
	 32qTbOQv5NRg5o0XjEQhYdI+Mm9EkDTliZapwisU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 284/563] net: dst: introduce dst->dev_rcu
Date: Mon, 13 Oct 2025 16:42:25 +0200
Message-ID: <20251013144421.558676618@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit caedcc5b6df1b2e2b5f39079e3369c1d4d5c5f50 ]

Followup of commit 88fe14253e18 ("net: dst: add four helpers
to annotate data-races around dst->dev").

We want to gradually add explicit RCU protection to dst->dev,
including lockdep support.

Add an union to alias dst->dev_rcu and dst->dev.

Add dst_dev_net_rcu() helper.

Fixes: 4a6ce2b6f2ec ("net: introduce a new function dst_dev_put()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250828195823.3958522-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dst.h | 16 +++++++++++-----
 net/core/dst.c    |  2 +-
 net/ipv4/route.c  |  4 ++--
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index bab01363bb975..f8aa1239b4db6 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -24,7 +24,10 @@
 struct sk_buff;
 
 struct dst_entry {
-	struct net_device       *dev;
+	union {
+		struct net_device       *dev;
+		struct net_device __rcu *dev_rcu;
+	};
 	struct  dst_ops	        *ops;
 	unsigned long		_metrics;
 	unsigned long           expires;
@@ -570,9 +573,12 @@ static inline struct net_device *dst_dev(const struct dst_entry *dst)
 
 static inline struct net_device *dst_dev_rcu(const struct dst_entry *dst)
 {
-	/* In the future, use rcu_dereference(dst->dev) */
-	WARN_ON_ONCE(!rcu_read_lock_held());
-	return READ_ONCE(dst->dev);
+	return rcu_dereference(dst->dev_rcu);
+}
+
+static inline struct net *dst_dev_net_rcu(const struct dst_entry *dst)
+{
+	return dev_net_rcu(dst_dev_rcu(dst));
 }
 
 static inline struct net_device *skb_dst_dev(const struct sk_buff *skb)
@@ -592,7 +598,7 @@ static inline struct net *skb_dst_dev_net(const struct sk_buff *skb)
 
 static inline struct net *skb_dst_dev_net_rcu(const struct sk_buff *skb)
 {
-	return dev_net_rcu(skb_dst_dev(skb));
+	return dev_net_rcu(skb_dst_dev_rcu(skb));
 }
 
 struct dst_entry *dst_blackhole_check(struct dst_entry *dst, u32 cookie);
diff --git a/net/core/dst.c b/net/core/dst.c
index e2de8b68c41d3..e9d35f49c9e78 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -150,7 +150,7 @@ void dst_dev_put(struct dst_entry *dst)
 		dst->ops->ifdown(dst, dev);
 	WRITE_ONCE(dst->input, dst_discard);
 	WRITE_ONCE(dst->output, dst_discard_out);
-	WRITE_ONCE(dst->dev, blackhole_netdev);
+	rcu_assign_pointer(dst->dev_rcu, blackhole_netdev);
 	netdev_ref_replace(dev, blackhole_netdev, &dst->dev_tracker,
 			   GFP_ATOMIC);
 }
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index baa43e5966b19..97b96275a775d 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1026,7 +1026,7 @@ static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 		return;
 
 	rcu_read_lock();
-	net = dev_net_rcu(dst_dev(dst));
+	net = dst_dev_net_rcu(dst);
 	if (mtu < net->ipv4.ip_rt_min_pmtu) {
 		lock = true;
 		mtu = min(old_mtu, net->ipv4.ip_rt_min_pmtu);
@@ -1326,7 +1326,7 @@ static unsigned int ipv4_default_advmss(const struct dst_entry *dst)
 	struct net *net;
 
 	rcu_read_lock();
-	net = dev_net_rcu(dst_dev(dst));
+	net = dst_dev_net_rcu(dst);
 	advmss = max_t(unsigned int, ipv4_mtu(dst) - header_size,
 				   net->ipv4.ip_rt_min_advmss);
 	rcu_read_unlock();
-- 
2.51.0



