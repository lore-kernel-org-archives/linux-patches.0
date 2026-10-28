Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209603;
	b=I5uhAeAJfO3+lDbKWp8nj8kDFekZ+8nLXDdBPYqmz1Lgew48dIIEZvU2LJLqpweKtXDH
	 +ALrxJ1sqPg+heqydymHs/Iu+UEPDg2nmIS3uPG+N6YSykDYoWxURk5f+grYem2xIu7ke
	 kZTP6PfNjybVdLQmO+DgO72Uav+mJ+RzaBCN8SO1874g3QAKozGTybbwsP/n+7QxhJha+
	 cxlp2pDcWcAwtWlLvtmjP4GQ4/txZZLeeGhUc3+IKISrqy9cO/FZEkxUd2Cwje5dvi9ZC
	 jLYxIjZEAif/IJVFMrfhIf1E2HWSYe0/7ZTT/ULP247Qde2Bn30pef6YoZHfFi36Mkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209603;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qdOGi9T1JYkCVid9rOLkwlxqGGqKVhWXErWArjsK/Is=;
	b=O5jhVOU7klWa86c9ZPORhlmGIaRPe6B513UYKPKOv+piZg3mZtAHqObwoxJWebPlKP1s
	 ZcHwbDIJI7mNGalVcVOW9m6zTxA/bfm0pWUoMut5TteMp/I6EQioD+TEkU0TErcx+iie4
	 AaLu4aVr+AUvNfLYSNvxvfMa+i7UVY7KhjyW7STUHcoXH9JZz2qa+D42dNfeajA3Bug8J
	 tPbxvUeBaqCTh2SMPLw3lZMLJ6tZEYucM9xrBTzwyyh8alTDvU6z/h/WLQUkebRtmcCVQ
	 BNDzfkIS6BZAqblVvF5Pu/Pk3dIyVHaDWQtMFTNpiEkb5QKOqixcWg8GBPNr/1sga+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gArH0Isl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BF0606A329;
	Wed, 28 Oct 2026 17:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gArH0Isl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11ACB1F031E2;
	Wed, 28 Oct 2026 17:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209602;
	bh=qdOGi9T1JYkCVid9rOLkwlxqGGqKVhWXErWArjsK/Is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gArH0IslWRVrI7ig3IH+Lej8sFNKuUyRmrwTa8ZT8nKkzOiiWoeEE74FH+tp0zJ0r
	 899NvXjfE3IYARRAbjmlU/Vryi1BbY+HysycGGcHBXaStlnf0lexB0zO8AbwnnpQDL
	 f8zcRT33R92qaGaBZmHCC2plmC9eqnsGPf5DnsQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 013/109] netrom: use a single lock for the node and neighbour lists
Date: Wed, 28 Oct 2026 17:59:57 +0100
Message-ID: <20261028165942.674722693@linuxfoundation.org>
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

NET/ROM routing uses three kinds of locks: nr_node_list_lock,
nr_neigh_list_lock and a lock in every nr_node. They are taken in
opposite orders on different paths:

- nr_del_node() and nr_dec_obs() take the node list lock, then a node
  lock, then the neighbour list lock (through nr_remove_neigh());
- nr_add_node(), called for every frame received from a neighbour,
  holds a node lock and takes the neighbour list lock;
- nr_rt_device_down() takes the neighbour list lock, then the node
  list lock, then each node lock.

Taking an interface down while routes are being changed or frames are
coming in can therefore deadlock, which is what the open syzbot
reports against nr_del_node(), nr_remove_neigh() and
nr_rt_device_down() show. Fixing the order case by case was tried
several times and never covered every combination.

As suggested by Jakub, replace all three with one nr_route_lock that
covers both lists and the routes of every node. The per-node lock goes
away: with the lists and routes[] under the same lock it no longer
protects anything, and routing tables are small and change rarely.
nr_remove_neigh() gets a variant for callers that already hold the
lock. Node refcounting is unchanged apart from the hold/put pair that
nr_node_lock()/nr_node_unlock() used to add around each critical
section.

nr_route_frame() still calls ax25_send_frame() with the lock held, as
it did under the node lock, so the lock is documented as never to be
taken with an AX.25 list lock held; nr_link_failed() is called from
AX.25 with only linkfail_lock held.

No change in behaviour otherwise; the other issues found on the way
(unlocked updates of nr_neigh->ax25 and failed, duplicate entries from
concurrent nr_add_node(), a reference leak in nr_rt_device_down()) are
left for separate patches.

Link: https://patchwork.kernel.org/project/netdevbpf/patch/20260406114904.89088-1-mashiro.chen@mailbox.org/
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
(cherry picked from commit 602c964d5e3d006cbd6e514aa971c5ab7257d66a)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netrom.h  |  15 -----
 net/netrom/nr_route.c | 133 +++++++++++++++++++-----------------------
 2 files changed, 59 insertions(+), 89 deletions(-)

diff --git a/include/net/netrom.h b/include/net/netrom.h
index 30ecf812b4ab4..2b4685d52bd81 100644
--- a/include/net/netrom.h
+++ b/include/net/netrom.h
@@ -115,7 +115,6 @@ struct nr_node {
 	unsigned char		count;
 	struct nr_route		routes[3];
 	refcount_t		refcount;
-	spinlock_t		node_lock;
 };
 
 /*********************************************************************
@@ -145,20 +144,6 @@ static __inline__ void nr_neigh_put(struct nr_neigh *nr_neigh)
 	}
 }
 
-/* nr_node_lock and nr_node_unlock also hold/put the node's refcounter.
- */
-static __inline__ void nr_node_lock(struct nr_node *nr_node)
-{
-	nr_node_hold(nr_node);
-	spin_lock_bh(&nr_node->node_lock);
-}
-
-static __inline__ void nr_node_unlock(struct nr_node *nr_node)
-{
-	spin_unlock_bh(&nr_node->node_lock);
-	nr_node_put(nr_node);
-}
-
 #define nr_neigh_for_each(__nr_neigh, list) \
 	hlist_for_each_entry(__nr_neigh, list, neigh_node)
 
diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
index 7f55030e4b166..e3effc85d3106 100644
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -36,24 +36,30 @@
 
 static unsigned int nr_neigh_no = 1;
 
+/*
+ * nr_route_lock protects both lists and the routing data hanging off them:
+ * which, count and routes[] of every node. It is taken with bottom halves
+ * disabled, is never nested with itself, and may be held while calling into
+ * AX.25 (nr_route_frame() -> ax25_send_frame()), so it must never be taken
+ * with an AX.25 list lock held.
+ */
+static DEFINE_SPINLOCK(nr_route_lock);
 static HLIST_HEAD(nr_node_list);
-static DEFINE_SPINLOCK(nr_node_list_lock);
 static HLIST_HEAD(nr_neigh_list);
-static DEFINE_SPINLOCK(nr_neigh_list_lock);
 
 static struct nr_node *nr_node_get(ax25_address *callsign)
 {
 	struct nr_node *found = NULL;
 	struct nr_node *nr_node;
 
-	spin_lock_bh(&nr_node_list_lock);
+	spin_lock_bh(&nr_route_lock);
 	nr_node_for_each(nr_node, &nr_node_list)
 		if (ax25cmp(callsign, &nr_node->callsign) == 0) {
 			nr_node_hold(nr_node);
 			found = nr_node;
 			break;
 		}
-	spin_unlock_bh(&nr_node_list_lock);
+	spin_unlock_bh(&nr_route_lock);
 	return found;
 }
 
@@ -63,7 +69,7 @@ static struct nr_neigh *nr_neigh_get_dev(ax25_address *callsign,
 	struct nr_neigh *found = NULL;
 	struct nr_neigh *nr_neigh;
 
-	spin_lock_bh(&nr_neigh_list_lock);
+	spin_lock_bh(&nr_route_lock);
 	nr_neigh_for_each(nr_neigh, &nr_neigh_list)
 		if (ax25cmp(callsign, &nr_neigh->callsign) == 0 &&
 		    nr_neigh->dev == dev) {
@@ -71,11 +77,11 @@ static struct nr_neigh *nr_neigh_get_dev(ax25_address *callsign,
 			found = nr_neigh;
 			break;
 		}
-	spin_unlock_bh(&nr_neigh_list_lock);
+	spin_unlock_bh(&nr_route_lock);
 	return found;
 }
 
-static void nr_remove_neigh(struct nr_neigh *);
+static void nr_remove_neigh_locked(struct nr_neigh *nr_neigh);
 
 /*      re-sort the routes in quality order.    */
 static void re_sort_routes(struct nr_node *nr_node, int x, int y)
@@ -121,16 +127,14 @@ static int __must_check nr_add_node(ax25_address *nr, const char *mnemonic,
 	if (nr_neigh != NULL && nr_neigh->failed != 0 && quality == 0) {
 		struct nr_node *nr_nodet;
 
-		spin_lock_bh(&nr_node_list_lock);
+		spin_lock_bh(&nr_route_lock);
 		nr_node_for_each(nr_nodet, &nr_node_list) {
-			nr_node_lock(nr_nodet);
 			for (i = 0; i < nr_nodet->count; i++)
 				if (nr_nodet->routes[i].neighbour == nr_neigh)
 					if (i < nr_nodet->which)
 						nr_nodet->which = i;
-			nr_node_unlock(nr_nodet);
 		}
-		spin_unlock_bh(&nr_node_list_lock);
+		spin_unlock_bh(&nr_route_lock);
 	}
 
 	if (nr_neigh != NULL)
@@ -172,10 +176,10 @@ static int __must_check nr_add_node(ax25_address *nr, const char *mnemonic,
 			}
 		}
 
-		spin_lock_bh(&nr_neigh_list_lock);
+		spin_lock_bh(&nr_route_lock);
 		hlist_add_head(&nr_neigh->neigh_node, &nr_neigh_list);
 		nr_neigh_hold(nr_neigh);
-		spin_unlock_bh(&nr_neigh_list_lock);
+		spin_unlock_bh(&nr_route_lock);
 	}
 
 	if (quality != 0 && ax25cmp(nr, ax25) == 0 && !nr_neigh->locked)
@@ -194,7 +198,6 @@ static int __must_check nr_add_node(ax25_address *nr, const char *mnemonic,
 		nr_node->which = 0;
 		nr_node->count = 1;
 		refcount_set(&nr_node->refcount, 1);
-		spin_lock_init(&nr_node->node_lock);
 
 		nr_node->routes[0].quality   = quality;
 		nr_node->routes[0].obs_count = obs_count;
@@ -203,15 +206,15 @@ static int __must_check nr_add_node(ax25_address *nr, const char *mnemonic,
 		nr_neigh_hold(nr_neigh);
 		nr_neigh->count++;
 
-		spin_lock_bh(&nr_node_list_lock);
+		spin_lock_bh(&nr_route_lock);
 		hlist_add_head(&nr_node->node_node, &nr_node_list);
 		/* refcount initialized at 1 */
-		spin_unlock_bh(&nr_node_list_lock);
+		spin_unlock_bh(&nr_route_lock);
 
 		nr_neigh_put(nr_neigh);
 		return 0;
 	}
-	nr_node_lock(nr_node);
+	spin_lock_bh(&nr_route_lock);
 
 	if (quality != 0)
 		strscpy(nr_node->mnemonic, mnemonic);
@@ -246,7 +249,7 @@ static int __must_check nr_add_node(ax25_address *nr, const char *mnemonic,
 				nr_neigh_put(nr_node->routes[2].neighbour);
 
 				if (nr_node->routes[2].neighbour->count == 0 && !nr_node->routes[2].neighbour->locked)
-					nr_remove_neigh(nr_node->routes[2].neighbour);
+					nr_remove_neigh_locked(nr_node->routes[2].neighbour);
 
 				nr_node->routes[2].quality   = quality;
 				nr_node->routes[2].obs_count = obs_count;
@@ -280,33 +283,32 @@ static int __must_check nr_add_node(ax25_address *nr, const char *mnemonic,
 	}
 
 	nr_neigh_put(nr_neigh);
-	nr_node_unlock(nr_node);
+	spin_unlock_bh(&nr_route_lock);
 	nr_node_put(nr_node);
 	return 0;
 }
 
 static void nr_remove_node_locked(struct nr_node *nr_node)
 {
-	lockdep_assert_held(&nr_node_list_lock);
+	lockdep_assert_held(&nr_route_lock);
 
 	hlist_del_init(&nr_node->node_node);
 	nr_node_put(nr_node);
 }
 
-static inline void __nr_remove_neigh(struct nr_neigh *nr_neigh)
+static void nr_remove_neigh_locked(struct nr_neigh *nr_neigh)
 {
+	lockdep_assert_held(&nr_route_lock);
+
 	hlist_del_init(&nr_neigh->neigh_node);
 	nr_neigh_put(nr_neigh);
 }
 
-#define nr_remove_neigh_locked(__neigh) \
-	__nr_remove_neigh(__neigh)
-
 static void nr_remove_neigh(struct nr_neigh *nr_neigh)
 {
-	spin_lock_bh(&nr_neigh_list_lock);
-	__nr_remove_neigh(nr_neigh);
-	spin_unlock_bh(&nr_neigh_list_lock);
+	spin_lock_bh(&nr_route_lock);
+	nr_remove_neigh_locked(nr_neigh);
+	spin_unlock_bh(&nr_route_lock);
 }
 
 /*
@@ -331,15 +333,14 @@ static int nr_del_node(ax25_address *callsign, ax25_address *neighbour, struct n
 		return -EINVAL;
 	}
 
-	spin_lock_bh(&nr_node_list_lock);
-	nr_node_lock(nr_node);
+	spin_lock_bh(&nr_route_lock);
 	for (i = 0; i < nr_node->count; i++) {
 		if (nr_node->routes[i].neighbour == nr_neigh) {
 			nr_neigh->count--;
 			nr_neigh_put(nr_neigh);
 
 			if (nr_neigh->count == 0 && !nr_neigh->locked)
-				nr_remove_neigh(nr_neigh);
+				nr_remove_neigh_locked(nr_neigh);
 			nr_neigh_put(nr_neigh);
 
 			nr_node->count--;
@@ -359,15 +360,13 @@ static int nr_del_node(ax25_address *callsign, ax25_address *neighbour, struct n
 				}
 				nr_node_put(nr_node);
 			}
-			nr_node_unlock(nr_node);
-			spin_unlock_bh(&nr_node_list_lock);
+			spin_unlock_bh(&nr_route_lock);
 
 			return 0;
 		}
 	}
 	nr_neigh_put(nr_neigh);
-	nr_node_unlock(nr_node);
-	spin_unlock_bh(&nr_node_list_lock);
+	spin_unlock_bh(&nr_route_lock);
 	nr_node_put(nr_node);
 
 	return -EINVAL;
@@ -412,10 +411,10 @@ static int __must_check nr_add_neigh(ax25_address *callsign,
 		}
 	}
 
-	spin_lock_bh(&nr_neigh_list_lock);
+	spin_lock_bh(&nr_route_lock);
 	hlist_add_head(&nr_neigh->neigh_node, &nr_neigh_list);
 	/* refcount is initialized at 1 */
-	spin_unlock_bh(&nr_neigh_list_lock);
+	spin_unlock_bh(&nr_route_lock);
 
 	return 0;
 }
@@ -454,9 +453,8 @@ static int nr_dec_obs(void)
 	struct hlist_node *nodet;
 	int i;
 
-	spin_lock_bh(&nr_node_list_lock);
+	spin_lock_bh(&nr_route_lock);
 	nr_node_for_each_safe(s, nodet, &nr_node_list) {
-		nr_node_lock(s);
 		for (i = 0; i < s->count; i++) {
 			switch (s->routes[i].obs_count) {
 			case 0:		/* A locked entry */
@@ -469,7 +467,7 @@ static int nr_dec_obs(void)
 				nr_neigh_put(nr_neigh);
 
 				if (nr_neigh->count == 0 && !nr_neigh->locked)
-					nr_remove_neigh(nr_neigh);
+					nr_remove_neigh_locked(nr_neigh);
 
 				s->count--;
 
@@ -494,9 +492,8 @@ static int nr_dec_obs(void)
 
 		if (s->count <= 0)
 			nr_remove_node_locked(s);
-		nr_node_unlock(s);
 	}
-	spin_unlock_bh(&nr_node_list_lock);
+	spin_unlock_bh(&nr_route_lock);
 
 	return 0;
 }
@@ -511,12 +508,10 @@ void nr_rt_device_down(struct net_device *dev)
 	struct nr_node  *t;
 	int i;
 
-	spin_lock_bh(&nr_neigh_list_lock);
+	spin_lock_bh(&nr_route_lock);
 	nr_neigh_for_each_safe(s, nodet, &nr_neigh_list) {
 		if (s->dev == dev) {
-			spin_lock_bh(&nr_node_list_lock);
 			nr_node_for_each_safe(t, node2t, &nr_node_list) {
-				nr_node_lock(t);
 				for (i = 0; i < t->count; i++) {
 					if (t->routes[i].neighbour == s) {
 						t->count--;
@@ -536,14 +531,12 @@ void nr_rt_device_down(struct net_device *dev)
 
 				if (t->count <= 0)
 					nr_remove_node_locked(t);
-				nr_node_unlock(t);
 			}
-			spin_unlock_bh(&nr_node_list_lock);
 
 			nr_remove_neigh_locked(s);
 		}
 	}
-	spin_unlock_bh(&nr_neigh_list_lock);
+	spin_unlock_bh(&nr_route_lock);
 }
 
 /*
@@ -707,7 +700,7 @@ void nr_link_failed(ax25_cb *ax25, int reason)
 	struct nr_neigh *s, *nr_neigh = NULL;
 	struct nr_node  *nr_node = NULL;
 
-	spin_lock_bh(&nr_neigh_list_lock);
+	spin_lock_bh(&nr_route_lock);
 	nr_neigh_for_each(s, &nr_neigh_list) {
 		if (s->ax25 == ax25) {
 			nr_neigh_hold(s);
@@ -715,7 +708,7 @@ void nr_link_failed(ax25_cb *ax25, int reason)
 			break;
 		}
 	}
-	spin_unlock_bh(&nr_neigh_list_lock);
+	spin_unlock_bh(&nr_route_lock);
 
 	if (nr_neigh == NULL)
 		return;
@@ -727,15 +720,13 @@ void nr_link_failed(ax25_cb *ax25, int reason)
 		nr_neigh_put(nr_neigh);
 		return;
 	}
-	spin_lock_bh(&nr_node_list_lock);
+	spin_lock_bh(&nr_route_lock);
 	nr_node_for_each(nr_node, &nr_node_list) {
-		nr_node_lock(nr_node);
 		if (nr_node->which < nr_node->count &&
 		    nr_node->routes[nr_node->which].neighbour == nr_neigh)
 			nr_node->which++;
-		nr_node_unlock(nr_node);
 	}
-	spin_unlock_bh(&nr_node_list_lock);
+	spin_unlock_bh(&nr_route_lock);
 	nr_neigh_put(nr_neigh);
 }
 
@@ -793,10 +784,10 @@ int nr_route_frame(struct sk_buff *skb, ax25_cb *ax25)
 	nr_node = nr_node_get(nr_dest);
 	if (nr_node == NULL)
 		return 0;
-	nr_node_lock(nr_node);
+	spin_lock_bh(&nr_route_lock);
 
 	if (nr_node->which >= nr_node->count) {
-		nr_node_unlock(nr_node);
+		spin_unlock_bh(&nr_route_lock);
 		nr_node_put(nr_node);
 		return 0;
 	}
@@ -804,7 +795,7 @@ int nr_route_frame(struct sk_buff *skb, ax25_cb *ax25)
 	nr_neigh = nr_node->routes[nr_node->which].neighbour;
 
 	if ((dev = nr_dev_first()) == NULL) {
-		nr_node_unlock(nr_node);
+		spin_unlock_bh(&nr_route_lock);
 		nr_node_put(nr_node);
 		return 0;
 	}
@@ -815,7 +806,7 @@ int nr_route_frame(struct sk_buff *skb, ax25_cb *ax25)
 	nskb = skb_copy_expand(skb, dev->hard_header_len, 0, GFP_ATOMIC);
 
 	if (!nskb) {
-		nr_node_unlock(nr_node);
+		spin_unlock_bh(&nr_route_lock);
 		nr_node_put(nr_node);
 		dev_put(dev);
 		return 0;
@@ -837,7 +828,7 @@ int nr_route_frame(struct sk_buff *skb, ax25_cb *ax25)
 
 	dev_put(dev);
 	ret = (nr_neigh->ax25 != NULL);
-	nr_node_unlock(nr_node);
+	spin_unlock_bh(&nr_route_lock);
 	nr_node_put(nr_node);
 
 	if (ret)
@@ -849,9 +840,9 @@ int nr_route_frame(struct sk_buff *skb, ax25_cb *ax25)
 #ifdef CONFIG_PROC_FS
 
 static void *nr_node_start(struct seq_file *seq, loff_t *pos)
-	__acquires(&nr_node_list_lock)
+	__acquires(&nr_route_lock)
 {
-	spin_lock_bh(&nr_node_list_lock);
+	spin_lock_bh(&nr_route_lock);
 	return seq_hlist_start_head(&nr_node_list, *pos);
 }
 
@@ -861,9 +852,9 @@ static void *nr_node_next(struct seq_file *seq, void *v, loff_t *pos)
 }
 
 static void nr_node_stop(struct seq_file *seq, void *v)
-	__releases(&nr_node_list_lock)
+	__releases(&nr_route_lock)
 {
-	spin_unlock_bh(&nr_node_list_lock);
+	spin_unlock_bh(&nr_route_lock);
 }
 
 static int nr_node_show(struct seq_file *seq, void *v)
@@ -878,7 +869,6 @@ static int nr_node_show(struct seq_file *seq, void *v)
 		struct nr_node *nr_node = hlist_entry(v, struct nr_node,
 						      node_node);
 
-		nr_node_lock(nr_node);
 		seq_printf(seq, "%-9s %-7s  %d %d",
 			ax2asc(buf, &nr_node->callsign),
 			(nr_node->mnemonic[0] == '\0') ? "*" : nr_node->mnemonic,
@@ -891,7 +881,6 @@ static int nr_node_show(struct seq_file *seq, void *v)
 				nr_node->routes[i].obs_count,
 				nr_node->routes[i].neighbour->number);
 		}
-		nr_node_unlock(nr_node);
 
 		seq_puts(seq, "\n");
 	}
@@ -906,9 +895,9 @@ const struct seq_operations nr_node_seqops = {
 };
 
 static void *nr_neigh_start(struct seq_file *seq, loff_t *pos)
-	__acquires(&nr_neigh_list_lock)
+	__acquires(&nr_route_lock)
 {
-	spin_lock_bh(&nr_neigh_list_lock);
+	spin_lock_bh(&nr_route_lock);
 	return seq_hlist_start_head(&nr_neigh_list, *pos);
 }
 
@@ -918,9 +907,9 @@ static void *nr_neigh_next(struct seq_file *seq, void *v, loff_t *pos)
 }
 
 static void nr_neigh_stop(struct seq_file *seq, void *v)
-	__releases(&nr_neigh_list_lock)
+	__releases(&nr_route_lock)
 {
-	spin_unlock_bh(&nr_neigh_list_lock);
+	spin_unlock_bh(&nr_route_lock);
 }
 
 static int nr_neigh_show(struct seq_file *seq, void *v)
@@ -971,12 +960,9 @@ void nr_rt_free(void)
 	struct nr_node  *t = NULL;
 	struct hlist_node *nodet;
 
-	spin_lock_bh(&nr_neigh_list_lock);
-	spin_lock_bh(&nr_node_list_lock);
+	spin_lock_bh(&nr_route_lock);
 	nr_node_for_each_safe(t, nodet, &nr_node_list) {
-		nr_node_lock(t);
 		nr_remove_node_locked(t);
-		nr_node_unlock(t);
 	}
 	nr_neigh_for_each_safe(s, nodet, &nr_neigh_list) {
 		while(s->count) {
@@ -985,6 +971,5 @@ void nr_rt_free(void)
 		}
 		nr_remove_neigh_locked(s);
 	}
-	spin_unlock_bh(&nr_node_list_lock);
-	spin_unlock_bh(&nr_neigh_list_lock);
+	spin_unlock_bh(&nr_route_lock);
 }
-- 
2.53.0



