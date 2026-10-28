Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210862;
	b=FqtMl4BErXyx/MDTkkEfp/J5KRs9mJs7IKBXoVbm5cER3aBHiUYPgusYi90aC79hj3wy
	 4dztQqmGwx28rvpu/vmpZl1RtN2MujUcYtxNT3qKQ9hKZmUr9TNzZgjkQMPEez/0g36RR
	 FOpdM7kYsLIo5h1emKLIjuCE/Qvnz2Aam6+EWUO3qpSHr55rli0GQZTUPKBuersVd/PP0
	 cYNAYnpq8aj3yrIRncrJh8FlHw23C3on9TqES55vueTWLE5KakZm7jkdaqlsYQ9rTvgI1
	 dvZwWXS/vn15bkSfEDswuKuCx2UmBEbVLTOglRYKqWfRYpoxivrV3EvS+GmVa4lcIkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210862;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ai4GXsNFpng9CJf+7XKI9KXqQXG2A940ARDOWjkBWGg=;
	b=s4VyIuwQuhF5MlpXUS66eQ9yKr1JjGsESbyYUNg/1BnN5gh345ev8Ng78Mx+pDVUHr0Z
	 aGqjQlSr9WXQMYGGzlHXhrGRR0roh3gqkmkPmKxWT/ywHYz/EBgHu48vKRjHUk/4bJnSQ
	 d3gtE4yRTczFZ57yjuZRRajgZnHDrb3SP/mu0R9scmu50Xv05ZTosOu+wIuViKwObUAUW
	 9Wjc94qzT4fFA70ZLl3Onziryb0Oe6KtGv7TtEHyKYP6P8jxw7ZVrETnU1pFrVkm2L/ju
	 0yOU+pMPh1K0Muj4WM4F/jg/ZLOK1BNfxrXJU0AVYMN/5SQBiEhN4D6QSOnCCAmNhRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OzanOiQ7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E94A606A31A;
	Wed, 28 Oct 2026 18:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OzanOiQ7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3F01F01825;
	Wed, 28 Oct 2026 18:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210862;
	bh=ai4GXsNFpng9CJf+7XKI9KXqQXG2A940ARDOWjkBWGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OzanOiQ7GO4i4PP4sy+GWX0hi+oNlSRsCnZFU0SAGiMobuaSDxLJfrvxEVOz8YTdu
	 QrrNmu/eBeyIuN6jFtvF4S2SoXxPEUbR5X8KcrwEHT0SoCY+ml/Vf+keRN5Xo3mxce
	 vBmJn8xKU5y7kqM9+MDuY9ht21iY3cF9mjvhc56c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 173/571] mctp: Add refcounts to mctp_dev
Date: Wed, 28 Oct 2026 17:55:20 +0100
Message-ID: <20261028170012.118670875@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit 43f55f23f70881e9c397557f15c8090b368d0af2 ]

Currently, we tie the struct mctp_dev lifetime to the underlying struct
net_device, and hold/put that device as a proxy for a separate mctp_dev
refcount. This works because we're not holding any references to the
mctp_dev that are different from the netdev lifetime.

In a future change we'll break that assumption though, as we'll need to
hold mctp_dev references in a workqueue, which might live past the
netdev unregister notification.

In order to support that, this change introduces a refcount on the
mctp_dev, currently taken by the net_device->mctp_ptr reference, and
released on netdev unregister events. We can then use this for future
references that might outlast the net device.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: aadf655e8ea9 ("net/mctp: publish the mctp_dev only after it is initialised")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/mctpdevice.h |  5 +++++
 net/mctp/device.c        | 25 ++++++++++++++++---------
 net/mctp/neigh.c         |  4 ++--
 net/mctp/route.c         |  4 ++--
 4 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/include/net/mctpdevice.h b/include/net/mctpdevice.h
index 71a11012fac7c..3a439463f0550 100644
--- a/include/net/mctpdevice.h
+++ b/include/net/mctpdevice.h
@@ -17,6 +17,8 @@
 struct mctp_dev {
 	struct net_device	*dev;
 
+	refcount_t		refs;
+
 	unsigned int		net;
 
 	/* Only modified under RTNL. Reads have addrs_lock held */
@@ -32,4 +34,7 @@ struct mctp_dev {
 struct mctp_dev *mctp_dev_get_rtnl(const struct net_device *dev);
 struct mctp_dev *__mctp_dev_get(const struct net_device *dev);
 
+void mctp_dev_hold(struct mctp_dev *mdev);
+void mctp_dev_put(struct mctp_dev *mdev);
+
 #endif /* __NET_MCTPDEVICE_H */
diff --git a/net/mctp/device.c b/net/mctp/device.c
index a11d5aca201c2..b248bca58c7c0 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -35,14 +35,6 @@ struct mctp_dev *mctp_dev_get_rtnl(const struct net_device *dev)
 	return rtnl_dereference(dev->mctp_ptr);
 }
 
-static void mctp_dev_destroy(struct mctp_dev *mdev)
-{
-	struct net_device *dev = mdev->dev;
-
-	dev_put(dev);
-	kfree_rcu(mdev, rcu);
-}
-
 static int mctp_fill_addrinfo(struct sk_buff *skb, struct netlink_callback *cb,
 			      struct mctp_dev *mdev, mctp_eid_t eid)
 {
@@ -263,6 +255,19 @@ static int mctp_rtm_deladdr(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return 0;
 }
 
+void mctp_dev_hold(struct mctp_dev *mdev)
+{
+	refcount_inc(&mdev->refs);
+}
+
+void mctp_dev_put(struct mctp_dev *mdev)
+{
+	if (refcount_dec_and_test(&mdev->refs)) {
+		dev_put(mdev->dev);
+		kfree_rcu(mdev, rcu);
+	}
+}
+
 static struct mctp_dev *mctp_add_dev(struct net_device *dev)
 {
 	struct mctp_dev *mdev;
@@ -278,7 +283,9 @@ static struct mctp_dev *mctp_add_dev(struct net_device *dev)
 	mdev->net = mctp_default_net(dev_net(dev));
 
 	/* associate to net_device */
+	refcount_set(&mdev->refs, 1);
 	rcu_assign_pointer(dev->mctp_ptr, mdev);
+
 	dev_hold(dev);
 	mdev->dev = dev;
 
@@ -353,7 +360,7 @@ static void mctp_unregister(struct net_device *dev)
 	mctp_neigh_remove_dev(mdev);
 	kfree(mdev->addrs);
 
-	mctp_dev_destroy(mdev);
+	mctp_dev_put(mdev);
 }
 
 static int mctp_register(struct net_device *dev)
diff --git a/net/mctp/neigh.c b/net/mctp/neigh.c
index 18a6be38f1721..b184a5d164e87 100644
--- a/net/mctp/neigh.c
+++ b/net/mctp/neigh.c
@@ -47,7 +47,7 @@ static int mctp_neigh_add(struct mctp_dev *mdev, mctp_eid_t eid,
 	}
 	INIT_LIST_HEAD(&neigh->list);
 	neigh->dev = mdev;
-	dev_hold(neigh->dev->dev);
+	mctp_dev_hold(neigh->dev);
 	neigh->eid = eid;
 	neigh->source = source;
 	memcpy(neigh->ha, lladdr, lladdr_len);
@@ -63,7 +63,7 @@ static void __mctp_neigh_free(struct rcu_head *rcu)
 {
 	struct mctp_neigh *neigh = container_of(rcu, struct mctp_neigh, rcu);
 
-	dev_put(neigh->dev->dev);
+	mctp_dev_put(neigh->dev);
 	kfree(neigh);
 }
 
diff --git a/net/mctp/route.c b/net/mctp/route.c
index f087cc73ca358..2b3d9b356b6d0 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -420,7 +420,7 @@ static int mctp_route_output(struct mctp_route *route, struct sk_buff *skb)
 static void mctp_route_release(struct mctp_route *rt)
 {
 	if (refcount_dec_and_test(&rt->refs)) {
-		dev_put(rt->dev->dev);
+		mctp_dev_put(rt->dev);
 		kfree_rcu(rt, rcu);
 	}
 }
@@ -777,7 +777,7 @@ static int mctp_route_add(struct mctp_dev *mdev, mctp_eid_t daddr_start,
 	rt->max = daddr_start + daddr_extent;
 	rt->mtu = mtu;
 	rt->dev = mdev;
-	dev_hold(rt->dev->dev);
+	mctp_dev_hold(rt->dev);
 	rt->type = type;
 	rt->output = rtfn;
 
-- 
2.53.0



