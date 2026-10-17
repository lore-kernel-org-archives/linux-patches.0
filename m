Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E7A377A97;
	Sat, 17 Oct 2026 16:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253744; cv=none; b=pJ2cxzAPciz3y/XoZ7wKV3uUyAG2hMnzE2+9TEYCmAtjU3kRpyOizHKpLLlHQfqNUStu0GUWIFwk51MscBYI7Hziq87nwMGYiAsjtHABIUBVKRvFfJYQgKZUySyUFSEPFAi9ukJ75qgv2hX5vxzWrkyzCmo3/uKdKB4SDjdhXrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253744; c=relaxed/simple;
	bh=4Hip3ge6KahnDsXMY6Q26IZkmI6t6m+hZDFlwKFCoKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ytsv9MMRmeuug9GFWfQRNIEk1kUD4nmbnBgTNTgYdTbcPintQyOypZDEWp82/p50huWMU+oTxc5EBZrtqM6Xht87noeoxl4GMPA0eY5qwJRKSwb0l0L8DU/3Vd6UhjOghVGq28V95wJZyyINtVVMH7GvAcuZWgLPCTcdLYF1OXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TOcig8Fd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TOcig8Fd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3631F000C4;
	Sat, 17 Oct 2026 16:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253743;
	bh=UOsRdi8XN5wmdMtm2LvVN2lI8bV0vqUDKaqu8Gxur7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TOcig8Fd02JdGiN9+Hu4YqlxGGECRczSK7T6OrEvN1knFeyoQ/2SLFMFdk7g2u9Kn
	 717I1OIMv1WKNLUmLOa45QRoRiV18lflCE+F4/DmB0sN5RSUP3iJrxSR5c2kyFu5OG
	 o71Ad/jTvLe3hPvB7VokEfZ+okyKkm2O87oDiWiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Guillaume Nault <gnault@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 219/869] mpls: Hold dev refcnt for mpls_nh.
Date: Sat, 17 Oct 2026 17:51:00 +0200
Message-ID: <20261017160042.668328530@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit f0914b8436c589b7ab32c614d8d7868eb4ebd5bf ]

MPLS uses RTNL

  1) to guarantee the lifetime of struct mpls_nh.nh_dev
  2) to protect net->mpls.platform_label

, but neither actually requires RTNL.

If we do not call dev_put() in find_outdev() and call it
just before freeing struct mpls_route, we can drop RTNL for 1).

Let's hold the refcnt of mpls_nh.nh_dev and track it with
netdevice_tracker.

Two notable changes:

If mpls_nh_build_multi() fails to set up a neighbour, we need
to call netdev_put() for successfully created neighbours in
mpls_rt_free_rcu(), so the number of neighbours (rt->rt_nhn)
is now updated in each iteration.

When a dev is unregistered, mpls_ifdown() clones mpls_route
and replaces it with the clone, so the clone requires extra
netdev_hold().

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Link: https://patch.msgid.link/20251029173344.2934622-3-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 629ec78ef860 ("mpls: add seqcount to protect the platform_label{,s} pair")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mpls/af_mpls.c  | 63 +++++++++++++++++++++++++++++++--------------
 net/mpls/internal.h |  1 +
 2 files changed, 45 insertions(+), 19 deletions(-)

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 82909a59d410f..7e38c71f7212c 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -532,10 +532,23 @@ static struct mpls_route *mpls_rt_alloc(u8 num_nh, u8 max_alen, u8 max_labels)
 	return rt;
 }
 
+static void mpls_rt_free_rcu(struct rcu_head *head)
+{
+	struct mpls_route *rt;
+
+	rt = container_of(head, struct mpls_route, rt_rcu);
+
+	change_nexthops(rt) {
+		netdev_put(nh->nh_dev, &nh->nh_dev_tracker);
+	} endfor_nexthops(rt);
+
+	kfree(rt);
+}
+
 static void mpls_rt_free(struct mpls_route *rt)
 {
 	if (rt)
-		kfree_rcu(rt, rt_rcu);
+		call_rcu(&rt->rt_rcu, mpls_rt_free_rcu);
 }
 
 static void mpls_notify_route(struct net *net, unsigned index,
@@ -589,6 +602,7 @@ static unsigned find_free_label(struct net *net)
 
 #if IS_ENABLED(CONFIG_INET)
 static struct net_device *inet_fib_lookup_dev(struct net *net,
+					      struct mpls_nh *nh,
 					      const void *addr)
 {
 	struct net_device *dev;
@@ -601,14 +615,14 @@ static struct net_device *inet_fib_lookup_dev(struct net *net,
 		return ERR_CAST(rt);
 
 	dev = rt->dst.dev;
-	dev_hold(dev);
-
+	netdev_hold(dev, &nh->nh_dev_tracker, GFP_KERNEL);
 	ip_rt_put(rt);
 
 	return dev;
 }
 #else
 static struct net_device *inet_fib_lookup_dev(struct net *net,
+					      struct mpls_nh *nh,
 					      const void *addr)
 {
 	return ERR_PTR(-EAFNOSUPPORT);
@@ -617,6 +631,7 @@ static struct net_device *inet_fib_lookup_dev(struct net *net,
 
 #if IS_ENABLED(CONFIG_IPV6)
 static struct net_device *inet6_fib_lookup_dev(struct net *net,
+					       struct mpls_nh *nh,
 					       const void *addr)
 {
 	struct net_device *dev;
@@ -633,13 +648,14 @@ static struct net_device *inet6_fib_lookup_dev(struct net *net,
 		return ERR_CAST(dst);
 
 	dev = dst->dev;
-	dev_hold(dev);
+	netdev_hold(dev, &nh->nh_dev_tracker, GFP_KERNEL);
 	dst_release(dst);
 
 	return dev;
 }
 #else
 static struct net_device *inet6_fib_lookup_dev(struct net *net,
+					       struct mpls_nh *nh,
 					       const void *addr)
 {
 	return ERR_PTR(-EAFNOSUPPORT);
@@ -655,16 +671,17 @@ static struct net_device *find_outdev(struct net *net,
 	if (!oif) {
 		switch (nh->nh_via_table) {
 		case NEIGH_ARP_TABLE:
-			dev = inet_fib_lookup_dev(net, mpls_nh_via(rt, nh));
+			dev = inet_fib_lookup_dev(net, nh, mpls_nh_via(rt, nh));
 			break;
 		case NEIGH_ND_TABLE:
-			dev = inet6_fib_lookup_dev(net, mpls_nh_via(rt, nh));
+			dev = inet6_fib_lookup_dev(net, nh, mpls_nh_via(rt, nh));
 			break;
 		case NEIGH_LINK_TABLE:
 			break;
 		}
 	} else {
-		dev = dev_get_by_index(net, oif);
+		dev = netdev_get_by_index(net, oif,
+					  &nh->nh_dev_tracker, GFP_KERNEL);
 	}
 
 	if (!dev)
@@ -673,8 +690,7 @@ static struct net_device *find_outdev(struct net *net,
 	if (IS_ERR(dev))
 		return dev;
 
-	/* The caller is holding rtnl anyways, so release the dev reference */
-	dev_put(dev);
+	nh->nh_dev = dev;
 
 	return dev;
 }
@@ -688,20 +704,17 @@ static int mpls_nh_assign_dev(struct net *net, struct mpls_route *rt,
 	dev = find_outdev(net, rt, nh, oif);
 	if (IS_ERR(dev)) {
 		err = PTR_ERR(dev);
-		dev = NULL;
 		goto errout;
 	}
 
 	/* Ensure this is a supported device */
 	err = -EINVAL;
 	if (!mpls_dev_get(dev))
-		goto errout;
+		goto errout_put;
 
 	if ((nh->nh_via_table == NEIGH_LINK_TABLE) &&
 	    (dev->addr_len != nh->nh_via_alen))
-		goto errout;
-
-	nh->nh_dev = dev;
+		goto errout_put;
 
 	if (!(dev->flags & IFF_UP)) {
 		nh->nh_flags |= RTNH_F_DEAD;
@@ -715,6 +728,9 @@ static int mpls_nh_assign_dev(struct net *net, struct mpls_route *rt,
 
 	return 0;
 
+errout_put:
+	netdev_put(nh->nh_dev, &nh->nh_dev_tracker);
+	nh->nh_dev = NULL;
 errout:
 	return err;
 }
@@ -892,7 +908,8 @@ static int mpls_nh_build_multi(struct mpls_route_config *cfg,
 	struct nlattr *nla_via, *nla_newdst;
 	int remaining = cfg->rc_mp_len;
 	int err = 0;
-	u8 nhs = 0;
+
+	rt->rt_nhn = 0;
 
 	change_nexthops(rt) {
 		int attrlen;
@@ -928,11 +945,9 @@ static int mpls_nh_build_multi(struct mpls_route_config *cfg,
 			rt->rt_nhn_alive--;
 
 		rtnh = rtnh_next(rtnh, &remaining);
-		nhs++;
+		rt->rt_nhn++;
 	} endfor_nexthops(rt);
 
-	rt->rt_nhn = nhs;
-
 	return 0;
 
 errout:
@@ -1526,8 +1541,12 @@ static int mpls_ifdown(struct net_device *dev, int event)
 		change_nexthops(rt) {
 			unsigned int nh_flags = nh->nh_flags;
 
-			if (nh->nh_dev != dev)
+			if (nh->nh_dev != dev) {
+				if (nh_del)
+					netdev_hold(nh->nh_dev, &nh->nh_dev_tracker,
+						    GFP_KERNEL);
 				goto next;
+			}
 
 			switch (event) {
 			case NETDEV_DOWN:
@@ -2525,10 +2544,13 @@ static int resize_platform_label_table(struct net *net, size_t limit)
 	/* In case the predefined labels need to be populated */
 	if (limit > MPLS_LABEL_IPV4NULL) {
 		struct net_device *lo = net->loopback_dev;
+
 		rt0 = mpls_rt_alloc(1, lo->addr_len, 0);
 		if (IS_ERR(rt0))
 			goto nort0;
+
 		rt0->rt_nh->nh_dev = lo;
+		netdev_hold(lo, &rt0->rt_nh->nh_dev_tracker, GFP_KERNEL);
 		rt0->rt_protocol = RTPROT_KERNEL;
 		rt0->rt_payload_type = MPT_IPV4;
 		rt0->rt_ttl_propagate = MPLS_TTL_PROP_DEFAULT;
@@ -2539,10 +2561,13 @@ static int resize_platform_label_table(struct net *net, size_t limit)
 	}
 	if (limit > MPLS_LABEL_IPV6NULL) {
 		struct net_device *lo = net->loopback_dev;
+
 		rt2 = mpls_rt_alloc(1, lo->addr_len, 0);
 		if (IS_ERR(rt2))
 			goto nort2;
+
 		rt2->rt_nh->nh_dev = lo;
+		netdev_hold(lo, &rt2->rt_nh->nh_dev_tracker, GFP_KERNEL);
 		rt2->rt_protocol = RTPROT_KERNEL;
 		rt2->rt_payload_type = MPT_IPV6;
 		rt2->rt_ttl_propagate = MPLS_TTL_PROP_DEFAULT;
diff --git a/net/mpls/internal.h b/net/mpls/internal.h
index b9f492ddf93be..76a133cb8efe7 100644
--- a/net/mpls/internal.h
+++ b/net/mpls/internal.h
@@ -88,6 +88,7 @@ enum mpls_payload_type {
 
 struct mpls_nh { /* next hop label forwarding entry */
 	struct net_device	*nh_dev;
+	netdevice_tracker	nh_dev_tracker;
 
 	/* nh_flags is accessed under RCU in the packet path; it is
 	 * modified handling netdev events with rtnl lock held
-- 
2.53.0



