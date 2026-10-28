Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209606;
	b=YfAY8OpE3pID8jW0I9zs4dJm167x+yNll1F0G80PYrw8MOxxoAZN572FD56y0n650L2c
	 tc6KpqlOYig+td/Dt5vF/obYYR0H8WkNUJgv/mAES0tmfgw+NmwtxmsCszVjo3Fisti6U
	 5kkh0MkCrBZTqeR4SPsYz/hviBGRn5qEhjJF3lYdfWW9b/4FQL0FrOQruvNmGxyPt0FpD
	 uixfSI25+Oz+iRtkY05s1tpzP7rxOKYQI+dMooN+FB0rWU7vwwWRn63/kGnY5hi70adRE
	 jBRj0ZB50+JuUgWMgxF6Go4Hnqv/OiKppD8+YxBp+MmKw5tal6T7mRU+gH16a1HKp2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209606;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2qZW4BljclxO0kNXYeOBT+SaPLiUSiuCQSR7ZKur/Vk=;
	b=tKDt+2AHgEbB2tD6oHYNsCWLi3PmWQhQeXyqbTsr6UZGgT/Y58RkIfDr2Clmor87OvcN
	 iXzdwTIprc8APukY5XBDsRowuTuTxPUxONNmOc17pJLAVj47UGiAa0pomTKycgWk2bjF3
	 hbOn1GAkAQAW//ju/7OA3p29fOMEoa6O39AAKQDqhvZSGqnJ+P89MhCsfCDhEsmfANe6g
	 N0HiEdw2fgx9y/8WJSWHWv1Jac6jFAc0qD8J5nI4QWr/B5upOBVpD+5qN69GQT8ODYquM
	 2sjmFktok33bnjXqM0TdRqjvpl/rVFN6QGA99Cb5vfqrQHBjNzbBXF7qa27u4jK9tEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gk+V8KIg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E53606A321;
	Wed, 28 Oct 2026 17:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gk+V8KIg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEBF71F01828;
	Wed, 28 Oct 2026 17:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209605;
	bh=2qZW4BljclxO0kNXYeOBT+SaPLiUSiuCQSR7ZKur/Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gk+V8KIg4s7QhRSIisZBs2PbJ+uvmN8m4cTbPrS5tQx/d42nO8Q859V8iRCGuMPbX
	 woIj85D9raVZA0LuYKcmVYaTjB6VEh1ZyNeuPQC43MJMe3DcpoBwMrUzhMhWjN9/Jv
	 8s5X+LD6ITPVx2u8YbME2QTAsnCWp+AmJ2YNcO84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2860e75836a08b172755@syzkaller.appspotmail.com,
	syzbot+df52f4216bf7b4d768e7@syzkaller.appspotmail.com,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 014/109] netrom: look up and update routes in one critical section
Date: Wed, 28 Oct 2026 17:59:58 +0100
Message-ID: <20261028165942.699321791@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

nr_add_node(), nr_del_node(), nr_add_neigh() and nr_del_neigh() look up
a node or neighbour with nr_node_get()/nr_neigh_get_dev(), which take
and drop the routing lock, and only then take the lock again to change
the routes. In between, another task can unlink the object they found.
nr_add_node() can then store a neighbour that is no longer on
nr_neigh_list in a node's routes; that route's reference becomes the
last one, and the next time the route is dropped the neighbour is freed
and read again straight away:

	nr_neigh->count--;
	nr_neigh_put(nr_neigh);			/* frees it */
	if (nr_neigh->count == 0 && ...)	/* use after free */

This is what syzbot reports in nr_add_node() (evicting the worst of
three routes) and in nr_dec_obs() through nr_rt_ioctl(). Lizhi Xu
analysed the first race; the fix posted then filtered neighbours by
refcount and was not taken.

Now that one lock covers both lists and the routes, do the lookup and
the update in a single critical section in all four functions, using
new __nr_node_get()/__nr_neigh_get_dev() variants that expect the lock
to be held. A node or neighbour found there stays linked while it is
used, so a route can no longer outlive its neighbour's list entry.
Concurrent additions of the same node or neighbour no longer create
duplicate entries either.

Also factor the "drop one route's use of a neighbour" sequence into
nr_neigh_route_put_locked(), which reads count and locked before
dropping the reference, and use it in nr_add_node(), nr_del_node() and
nr_dec_obs().

nr_add_node() is also called from nr_route_frame() in softirq context,
where the kmemdup(GFP_KERNEL) of the digipeater list could sleep; the
neighbour creation shared with nr_add_neigh() now allocates with
GFP_ATOMIC, like the rest of nr_add_node() already did.

This depends on "netrom: use a single lock for the node and neighbour
lists".

Reported-by: syzbot+2860e75836a08b172755@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2860e75836a08b172755
Reported-by: syzbot+df52f4216bf7b4d768e7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=df52f4216bf7b4d768e7
Link: https://patchwork.kernel.org/project/netdevbpf/patch/20251023135032.3759443-1-lizhi.xu@windriver.com/
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
(cherry picked from commit 1292cb18feed7503f861695134206c99347cc7bb)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/nr_route.c | 264 ++++++++++++++++++++++--------------------
 1 file changed, 138 insertions(+), 126 deletions(-)

diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
index e3effc85d3106..10294cf068f8a 100644
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -47,38 +47,44 @@ static DEFINE_SPINLOCK(nr_route_lock);
 static HLIST_HEAD(nr_node_list);
 static HLIST_HEAD(nr_neigh_list);
 
-static struct nr_node *nr_node_get(ax25_address *callsign)
+static struct nr_node *__nr_node_get(ax25_address *callsign)
 {
-	struct nr_node *found = NULL;
 	struct nr_node *nr_node;
 
-	spin_lock_bh(&nr_route_lock);
+	lockdep_assert_held(&nr_route_lock);
+
 	nr_node_for_each(nr_node, &nr_node_list)
 		if (ax25cmp(callsign, &nr_node->callsign) == 0) {
 			nr_node_hold(nr_node);
-			found = nr_node;
-			break;
+			return nr_node;
 		}
+	return NULL;
+}
+
+static struct nr_node *nr_node_get(ax25_address *callsign)
+{
+	struct nr_node *found;
+
+	spin_lock_bh(&nr_route_lock);
+	found = __nr_node_get(callsign);
 	spin_unlock_bh(&nr_route_lock);
 	return found;
 }
 
-static struct nr_neigh *nr_neigh_get_dev(ax25_address *callsign,
-					 struct net_device *dev)
+static struct nr_neigh *__nr_neigh_get_dev(ax25_address *callsign,
+					   struct net_device *dev)
 {
-	struct nr_neigh *found = NULL;
 	struct nr_neigh *nr_neigh;
 
-	spin_lock_bh(&nr_route_lock);
+	lockdep_assert_held(&nr_route_lock);
+
 	nr_neigh_for_each(nr_neigh, &nr_neigh_list)
 		if (ax25cmp(callsign, &nr_neigh->callsign) == 0 &&
 		    nr_neigh->dev == dev) {
 			nr_neigh_hold(nr_neigh);
-			found = nr_neigh;
-			break;
+			return nr_neigh;
 		}
-	spin_unlock_bh(&nr_route_lock);
-	return found;
+	return NULL;
 }
 
 static void nr_remove_neigh_locked(struct nr_neigh *nr_neigh);
@@ -96,6 +102,66 @@ static void re_sort_routes(struct nr_node *nr_node, int x, int y)
 	}
 }
 
+/*
+ * Allocate a neighbour and link it into nr_neigh_list. The list holds one
+ * reference and the caller gets another one. Called with nr_route_lock held.
+ */
+static struct nr_neigh *nr_neigh_create_locked(ax25_address *callsign,
+					       ax25_digi *ax25_digi,
+					       struct net_device *dev,
+					       unsigned int quality,
+					       unsigned char locked)
+{
+	struct nr_neigh *nr_neigh;
+
+	lockdep_assert_held(&nr_route_lock);
+
+	nr_neigh = kmalloc(sizeof(*nr_neigh), GFP_ATOMIC);
+	if (!nr_neigh)
+		return NULL;
+
+	nr_neigh->callsign = *callsign;
+	nr_neigh->digipeat = NULL;
+	nr_neigh->ax25     = NULL;
+	nr_neigh->dev      = dev;
+	nr_neigh->quality  = quality;
+	nr_neigh->locked   = locked;
+	nr_neigh->count    = 0;
+	nr_neigh->number   = nr_neigh_no++;
+	nr_neigh->failed   = 0;
+	refcount_set(&nr_neigh->refcount, 1);
+
+	if (ax25_digi && ax25_digi->ndigi > 0) {
+		nr_neigh->digipeat = kmemdup(ax25_digi, sizeof(*ax25_digi),
+					     GFP_ATOMIC);
+		if (!nr_neigh->digipeat) {
+			kfree(nr_neigh);
+			return NULL;
+		}
+	}
+
+	hlist_add_head(&nr_neigh->neigh_node, &nr_neigh_list);
+	nr_neigh_hold(nr_neigh);
+
+	return nr_neigh;
+}
+
+/*
+ * Drop one route's use of a neighbour. The neighbour is unlinked when no
+ * route uses it any more and it was not added explicitly; count and locked
+ * are read before the route's reference is dropped, since that reference
+ * may be the last one. Called with nr_route_lock held.
+ */
+static void nr_neigh_route_put_locked(struct nr_neigh *nr_neigh)
+{
+	lockdep_assert_held(&nr_route_lock);
+
+	nr_neigh->count--;
+	if (nr_neigh->count == 0 && !nr_neigh->locked)
+		nr_remove_neigh_locked(nr_neigh);
+	nr_neigh_put(nr_neigh);
+}
+
 /*
  *	Add a new route to a node, and in the process add the node and the
  *	neighbour if it is new.
@@ -106,7 +172,7 @@ static int __must_check nr_add_node(ax25_address *nr, const char *mnemonic,
 {
 	struct nr_node  *nr_node;
 	struct nr_neigh *nr_neigh;
-	int i, found;
+	int i, found, ret = 0;
 	struct net_device *odev;
 
 	if ((odev=nr_dev_get(nr)) != NULL) {	/* Can't add routes to ourself */
@@ -114,9 +180,15 @@ static int __must_check nr_add_node(ax25_address *nr, const char *mnemonic,
 		return -EINVAL;
 	}
 
-	nr_node = nr_node_get(nr);
+	/*
+	 * Look up and update under one critical section, so that a node or
+	 * neighbour found here cannot be unlinked before it is used.
+	 */
+	spin_lock_bh(&nr_route_lock);
+
+	nr_node = __nr_node_get(nr);
 
-	nr_neigh = nr_neigh_get_dev(ax25, dev);
+	nr_neigh = __nr_neigh_get_dev(ax25, dev);
 
 	/*
 	 * The L2 link to a neighbour has failed in the past
@@ -127,14 +199,12 @@ static int __must_check nr_add_node(ax25_address *nr, const char *mnemonic,
 	if (nr_neigh != NULL && nr_neigh->failed != 0 && quality == 0) {
 		struct nr_node *nr_nodet;
 
-		spin_lock_bh(&nr_route_lock);
 		nr_node_for_each(nr_nodet, &nr_node_list) {
 			for (i = 0; i < nr_nodet->count; i++)
 				if (nr_nodet->routes[i].neighbour == nr_neigh)
 					if (i < nr_nodet->which)
 						nr_nodet->which = i;
 		}
-		spin_unlock_bh(&nr_route_lock);
 	}
 
 	if (nr_neigh != NULL)
@@ -143,43 +213,19 @@ static int __must_check nr_add_node(ax25_address *nr, const char *mnemonic,
 	if (quality == 0 && nr_neigh != NULL && nr_node != NULL) {
 		nr_neigh_put(nr_neigh);
 		nr_node_put(nr_node);
-		return 0;
+		goto out;
 	}
 
 	if (nr_neigh == NULL) {
-		if ((nr_neigh = kmalloc(sizeof(*nr_neigh), GFP_ATOMIC)) == NULL) {
+		unsigned int q = READ_ONCE(sysctl_netrom_default_path_quality);
+
+		nr_neigh = nr_neigh_create_locked(ax25, ax25_digi, dev, q, 0);
+		if (!nr_neigh) {
 			if (nr_node)
 				nr_node_put(nr_node);
-			return -ENOMEM;
-		}
-
-		nr_neigh->callsign = *ax25;
-		nr_neigh->digipeat = NULL;
-		nr_neigh->ax25     = NULL;
-		nr_neigh->dev      = dev;
-		nr_neigh->quality  = READ_ONCE(sysctl_netrom_default_path_quality);
-		nr_neigh->locked   = 0;
-		nr_neigh->count    = 0;
-		nr_neigh->number   = nr_neigh_no++;
-		nr_neigh->failed   = 0;
-		refcount_set(&nr_neigh->refcount, 1);
-
-		if (ax25_digi != NULL && ax25_digi->ndigi > 0) {
-			nr_neigh->digipeat = kmemdup(ax25_digi,
-						     sizeof(*ax25_digi),
-						     GFP_KERNEL);
-			if (nr_neigh->digipeat == NULL) {
-				kfree(nr_neigh);
-				if (nr_node)
-					nr_node_put(nr_node);
-				return -ENOMEM;
-			}
+			ret = -ENOMEM;
+			goto out;
 		}
-
-		spin_lock_bh(&nr_route_lock);
-		hlist_add_head(&nr_neigh->neigh_node, &nr_neigh_list);
-		nr_neigh_hold(nr_neigh);
-		spin_unlock_bh(&nr_route_lock);
 	}
 
 	if (quality != 0 && ax25cmp(nr, ax25) == 0 && !nr_neigh->locked)
@@ -187,9 +233,9 @@ static int __must_check nr_add_node(ax25_address *nr, const char *mnemonic,
 
 	if (nr_node == NULL) {
 		if ((nr_node = kmalloc(sizeof(*nr_node), GFP_ATOMIC)) == NULL) {
-			if (nr_neigh)
-				nr_neigh_put(nr_neigh);
-			return -ENOMEM;
+			nr_neigh_put(nr_neigh);
+			ret = -ENOMEM;
+			goto out;
 		}
 
 		nr_node->callsign = *nr;
@@ -206,15 +252,12 @@ static int __must_check nr_add_node(ax25_address *nr, const char *mnemonic,
 		nr_neigh_hold(nr_neigh);
 		nr_neigh->count++;
 
-		spin_lock_bh(&nr_route_lock);
 		hlist_add_head(&nr_node->node_node, &nr_node_list);
 		/* refcount initialized at 1 */
-		spin_unlock_bh(&nr_route_lock);
 
 		nr_neigh_put(nr_neigh);
-		return 0;
+		goto out;
 	}
-	spin_lock_bh(&nr_route_lock);
 
 	if (quality != 0)
 		strscpy(nr_node->mnemonic, mnemonic);
@@ -245,11 +288,7 @@ static int __must_check nr_add_node(ax25_address *nr, const char *mnemonic,
 		} else {
 			/* It must be better than the worst */
 			if (quality > nr_node->routes[2].quality) {
-				nr_node->routes[2].neighbour->count--;
-				nr_neigh_put(nr_node->routes[2].neighbour);
-
-				if (nr_node->routes[2].neighbour->count == 0 && !nr_node->routes[2].neighbour->locked)
-					nr_remove_neigh_locked(nr_node->routes[2].neighbour);
+				nr_neigh_route_put_locked(nr_node->routes[2].neighbour);
 
 				nr_node->routes[2].quality   = quality;
 				nr_node->routes[2].obs_count = obs_count;
@@ -283,9 +322,10 @@ static int __must_check nr_add_node(ax25_address *nr, const char *mnemonic,
 	}
 
 	nr_neigh_put(nr_neigh);
-	spin_unlock_bh(&nr_route_lock);
 	nr_node_put(nr_node);
-	return 0;
+out:
+	spin_unlock_bh(&nr_route_lock);
+	return ret;
 }
 
 static void nr_remove_node_locked(struct nr_node *nr_node)
@@ -304,13 +344,6 @@ static void nr_remove_neigh_locked(struct nr_neigh *nr_neigh)
 	nr_neigh_put(nr_neigh);
 }
 
-static void nr_remove_neigh(struct nr_neigh *nr_neigh)
-{
-	spin_lock_bh(&nr_route_lock);
-	nr_remove_neigh_locked(nr_neigh);
-	spin_unlock_bh(&nr_route_lock);
-}
-
 /*
  *	"Delete" a node. Strictly speaking remove a route to a node. The node
  *	is only deleted if no routes are left to it.
@@ -319,28 +352,25 @@ static int nr_del_node(ax25_address *callsign, ax25_address *neighbour, struct n
 {
 	struct nr_node  *nr_node;
 	struct nr_neigh *nr_neigh;
-	int i;
+	int i, ret = -EINVAL;
 
-	nr_node = nr_node_get(callsign);
+	spin_lock_bh(&nr_route_lock);
+
+	nr_node = __nr_node_get(callsign);
 
 	if (nr_node == NULL)
-		return -EINVAL;
+		goto out;
 
-	nr_neigh = nr_neigh_get_dev(neighbour, dev);
+	nr_neigh = __nr_neigh_get_dev(neighbour, dev);
 
 	if (nr_neigh == NULL) {
 		nr_node_put(nr_node);
-		return -EINVAL;
+		goto out;
 	}
 
-	spin_lock_bh(&nr_route_lock);
 	for (i = 0; i < nr_node->count; i++) {
 		if (nr_node->routes[i].neighbour == nr_neigh) {
-			nr_neigh->count--;
-			nr_neigh_put(nr_neigh);
-
-			if (nr_neigh->count == 0 && !nr_neigh->locked)
-				nr_remove_neigh_locked(nr_neigh);
+			nr_neigh_route_put_locked(nr_neigh);
 			nr_neigh_put(nr_neigh);
 
 			nr_node->count--;
@@ -360,16 +390,15 @@ static int nr_del_node(ax25_address *callsign, ax25_address *neighbour, struct n
 				}
 				nr_node_put(nr_node);
 			}
-			spin_unlock_bh(&nr_route_lock);
-
-			return 0;
+			ret = 0;
+			goto out;
 		}
 	}
 	nr_neigh_put(nr_neigh);
-	spin_unlock_bh(&nr_route_lock);
 	nr_node_put(nr_node);
-
-	return -EINVAL;
+out:
+	spin_unlock_bh(&nr_route_lock);
+	return ret;
 }
 
 /*
@@ -379,44 +408,25 @@ static int __must_check nr_add_neigh(ax25_address *callsign,
 	ax25_digi *ax25_digi, struct net_device *dev, unsigned int quality)
 {
 	struct nr_neigh *nr_neigh;
+	int ret = 0;
 
-	nr_neigh = nr_neigh_get_dev(callsign, dev);
+	spin_lock_bh(&nr_route_lock);
+
+	nr_neigh = __nr_neigh_get_dev(callsign, dev);
 	if (nr_neigh) {
 		nr_neigh->quality = quality;
 		nr_neigh->locked  = 1;
-		nr_neigh_put(nr_neigh);
-		return 0;
-	}
-
-	if ((nr_neigh = kmalloc(sizeof(*nr_neigh), GFP_ATOMIC)) == NULL)
-		return -ENOMEM;
-
-	nr_neigh->callsign = *callsign;
-	nr_neigh->digipeat = NULL;
-	nr_neigh->ax25     = NULL;
-	nr_neigh->dev      = dev;
-	nr_neigh->quality  = quality;
-	nr_neigh->locked   = 1;
-	nr_neigh->count    = 0;
-	nr_neigh->number   = nr_neigh_no++;
-	nr_neigh->failed   = 0;
-	refcount_set(&nr_neigh->refcount, 1);
-
-	if (ax25_digi != NULL && ax25_digi->ndigi > 0) {
-		nr_neigh->digipeat = kmemdup(ax25_digi, sizeof(*ax25_digi),
-					     GFP_KERNEL);
-		if (nr_neigh->digipeat == NULL) {
-			kfree(nr_neigh);
-			return -ENOMEM;
-		}
+	} else {
+		nr_neigh = nr_neigh_create_locked(callsign, ax25_digi, dev,
+						  quality, 1);
+		if (!nr_neigh)
+			ret = -ENOMEM;
 	}
+	if (nr_neigh)
+		nr_neigh_put(nr_neigh);
 
-	spin_lock_bh(&nr_route_lock);
-	hlist_add_head(&nr_neigh->neigh_node, &nr_neigh_list);
-	/* refcount is initialized at 1 */
 	spin_unlock_bh(&nr_route_lock);
-
-	return 0;
+	return ret;
 }
 
 /*
@@ -427,17 +437,23 @@ static int nr_del_neigh(ax25_address *callsign, struct net_device *dev, unsigned
 {
 	struct nr_neigh *nr_neigh;
 
-	nr_neigh = nr_neigh_get_dev(callsign, dev);
+	spin_lock_bh(&nr_route_lock);
+
+	nr_neigh = __nr_neigh_get_dev(callsign, dev);
 
-	if (nr_neigh == NULL) return -EINVAL;
+	if (nr_neigh == NULL) {
+		spin_unlock_bh(&nr_route_lock);
+		return -EINVAL;
+	}
 
 	nr_neigh->quality = quality;
 	nr_neigh->locked  = 0;
 
 	if (nr_neigh->count == 0)
-		nr_remove_neigh(nr_neigh);
+		nr_remove_neigh_locked(nr_neigh);
 	nr_neigh_put(nr_neigh);
 
+	spin_unlock_bh(&nr_route_lock);
 	return 0;
 }
 
@@ -463,11 +479,7 @@ static int nr_dec_obs(void)
 			case 1:		/* From 1 -> 0 */
 				nr_neigh = s->routes[i].neighbour;
 
-				nr_neigh->count--;
-				nr_neigh_put(nr_neigh);
-
-				if (nr_neigh->count == 0 && !nr_neigh->locked)
-					nr_remove_neigh_locked(nr_neigh);
+				nr_neigh_route_put_locked(nr_neigh);
 
 				s->count--;
 
-- 
2.53.0



