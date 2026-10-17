Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA9F3B2FCA;
	Sat, 17 Oct 2026 17:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259073; cv=none; b=KmciTMUNqewmisrbuKOdoVW4x+Kc8CnHQBJboSw6CicwAM2iwtEAw1k/hxsnDcO6WMrQnc6Q7VUK+ggXXyw3kw1pkNsacilWDGE38gnz6LFXuY64S5u1HcFn3LgxJeD2uH3BFeT/rz6rPrbFnIPV8HygK5oD9Hn7N9706mJkm+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259073; c=relaxed/simple;
	bh=6Qc/5TNHpWmQ1U37JCePrznR1An5JI/SHZItIfanSM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvGE+Q3JPKE2m8dlrnNZZhpv4F1s6uuRSOAgfeskKB1y2ZASUAdRUVS1HrZMKb8ls0yetaG5j/AUE8no0kUqtjFaKBOqSH4oKzfi+UHgzL9ieichIkAmTKuQuFN1k30i/JQkiW8LfZH/km0wkYg5LWsLrVuWRKDeqO1F0x1K7yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7qwQykc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7qwQykc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C841F000C4;
	Sat, 17 Oct 2026 17:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259072;
	bh=ArGgTkF1dyZqj2PeP98uaVHp3qAGJSn1z5fRMYwCm2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z7qwQykcIPv/qSEf0QKiWg53nGWDj6Tlj6QmnV0fC8jH7kFHDgsODVLJYLnxJwkDJ
	 xto6S8uN2dk62LUcKkkIkuB9+3wixM1Lq6xJNrQUf5zZRstlcVT9VM78s/pK5Z5n+e
	 GzVBeeZw9+bpSrWzT2MK4m9+Q+fuuPSDeVyqV1Jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Weiming Shi <bestswngs@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1092/1674] tipc: serialize udp bearer replicast list updates
Date: Sat, 17 Oct 2026 17:56:04 +0200
Message-ID: <20261017160459.162271574@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 350e592ff4e30e48ffb55e142d11a73e63f4869c ]

tipc_udp_rcast_add() and cleanup_bearer() both update ub->rcast.list with
list_add_rcu() / list_del_rcu(), but nothing serializes them. The add runs
from the encap receive softirq (via tipc_udp_rcast_disc()) without
rtnl_lock(), so it can race the cleanup delete and corrupt the list:

  list_del corruption. prev->next should be ffff8880298d7ab8,
    but was ffff88802449ad38. (prev=ffff888027e3ec98)
  kernel BUG at lib/list_debug.c:62!
  RIP: __list_del_entry_valid_or_report+0x17a/0x200
  Workqueue: events cleanup_bearer
  Call Trace:
   cleanup_bearer (net/tipc/udp_media.c:811)
   process_one_work (kernel/workqueue.c:3302)
   worker_thread (kernel/workqueue.c:3466)

The bearer can be enabled from an unprivileged user namespace, as the
TIPCv2 generic-netlink ops carry no GENL_ADMIN_PERM.

Add a spinlock to struct udp_bearer and take it around the list_add_rcu()
in tipc_udp_rcast_add() and the list_del_rcu() loop in cleanup_bearer() so
the two writers can no longer corrupt the list.

Reject a duplicate peer under the same lock before allocating, and remove
tipc_udp_is_known_peer(). The old lockless pre-check in
tipc_udp_rcast_disc() was racy: two softirqs discovering the same peer
could both find it absent and add it twice.

cleanup_bearer() runs from a workqueue after tipc_udp_disable() clears the
bearer's up bit, so an encap softirq can still reach tipc_udp_rcast_add()
and add a peer after cleanup_bearer() has already emptied the list, leaking
that entry when the bearer is freed. Mark the bearer disabled under
rcast_lock once the list is emptied and refuse further additions.

Fixes: ef20cd4dd163 ("tipc: introduce UDP replicast")
Reported-by: Xiang Mei <xmei5@asu.edu>
Suggested-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/20260716025203.9332-2-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/udp_media.c | 56 +++++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 29 deletions(-)

diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index e993bd6ed7c26..8ef7f3acb4604 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -94,6 +94,8 @@ struct udp_replicast {
  * @ifindex:	local address scope
  * @work:	used to schedule deferred work on a bearer
  * @rcast:	associated udp_replicast container
+ * @rcast_lock:	serialize updates to @rcast.list against concurrent updaters
+ * @disabled:	bearer is being torn down; reject further @rcast.list additions
  */
 struct udp_bearer {
 	struct tipc_bearer __rcu *bearer;
@@ -101,6 +103,8 @@ struct udp_bearer {
 	u32 ifindex;
 	struct work_struct work;
 	struct udp_replicast rcast;
+	spinlock_t rcast_lock;
+	bool disabled;
 };
 
 static int tipc_udp_is_mcast_addr(struct udp_media_addr *addr)
@@ -279,26 +283,6 @@ static int tipc_udp_send_msg(struct net *net, struct sk_buff *skb,
 	return err;
 }
 
-static bool tipc_udp_is_known_peer(struct tipc_bearer *b,
-				   struct udp_media_addr *addr)
-{
-	struct udp_replicast *rcast, *tmp;
-	struct udp_bearer *ub;
-
-	ub = rcu_dereference_rtnl(b->media_ptr);
-	if (!ub) {
-		pr_err_ratelimited("UDP bearer instance not found\n");
-		return false;
-	}
-
-	list_for_each_entry_safe(rcast, tmp, &ub->rcast.list, list) {
-		if (!memcmp(&rcast->addr, addr, sizeof(struct udp_media_addr)))
-			return true;
-	}
-
-	return false;
-}
-
 static int tipc_udp_rcast_add(struct tipc_bearer *b,
 			      struct udp_media_addr *addr)
 {
@@ -309,16 +293,34 @@ static int tipc_udp_rcast_add(struct tipc_bearer *b,
 	if (!ub)
 		return -ENODEV;
 
+	spin_lock_bh(&ub->rcast_lock);
+	if (ub->disabled) {
+		spin_unlock_bh(&ub->rcast_lock);
+		return 0;
+	}
+	list_for_each_entry(rcast, &ub->rcast.list, list) {
+		if (!memcmp(&rcast->addr, addr, sizeof(*addr))) {
+			spin_unlock_bh(&ub->rcast_lock);
+			return 0;
+		}
+	}
+
 	rcast = kmalloc(sizeof(*rcast), GFP_ATOMIC);
-	if (!rcast)
+	if (!rcast) {
+		spin_unlock_bh(&ub->rcast_lock);
 		return -ENOMEM;
+	}
 
 	if (dst_cache_init(&rcast->dst_cache, GFP_ATOMIC)) {
+		spin_unlock_bh(&ub->rcast_lock);
 		kfree(rcast);
 		return -ENOMEM;
 	}
 
 	memcpy(&rcast->addr, addr, sizeof(struct udp_media_addr));
+	list_add_rcu(&rcast->list, &ub->rcast.list);
+	b->bcast_addr.broadcast = TIPC_REPLICAST_SUPPORT;
+	spin_unlock_bh(&ub->rcast_lock);
 
 	if (ntohs(addr->proto) == ETH_P_IP)
 		pr_info("New replicast peer: %pI4\n", &rcast->addr.ipv4);
@@ -326,8 +328,6 @@ static int tipc_udp_rcast_add(struct tipc_bearer *b,
 	else if (ntohs(addr->proto) == ETH_P_IPV6)
 		pr_info("New replicast peer: %pI6\n", &rcast->addr.ipv6);
 #endif
-	b->bcast_addr.broadcast = TIPC_REPLICAST_SUPPORT;
-	list_add_rcu(&rcast->list, &ub->rcast.list);
 	return 0;
 }
 
@@ -362,9 +362,6 @@ static int tipc_udp_rcast_disc(struct tipc_bearer *b, struct sk_buff *skb)
 		return 0;
 	}
 
-	if (likely(tipc_udp_is_known_peer(b, &src)))
-		return 0;
-
 	return tipc_udp_rcast_add(b, &src);
 }
 
@@ -646,9 +643,6 @@ int tipc_udp_nl_bearer_add(struct tipc_bearer *b, struct nlattr *attr)
 		return -EINVAL;
 	}
 
-	if (tipc_udp_is_known_peer(b, &addr))
-		return 0;
-
 	return tipc_udp_rcast_add(b, &addr);
 }
 
@@ -680,6 +674,7 @@ static int tipc_udp_enable(struct net *net, struct tipc_bearer *b,
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&ub->rcast.list);
+	spin_lock_init(&ub->rcast_lock);
 
 	if (!attrs[TIPC_NLA_BEARER_UDP_OPTS])
 		goto err;
@@ -809,11 +804,14 @@ static void cleanup_bearer(struct work_struct *work)
 	struct udp_replicast *rcast, *tmp;
 	struct tipc_net *tn;
 
+	spin_lock_bh(&ub->rcast_lock);
 	list_for_each_entry_safe(rcast, tmp, &ub->rcast.list, list) {
 		dst_cache_destroy(&rcast->dst_cache);
 		list_del_rcu(&rcast->list);
 		kfree_rcu(rcast, rcu);
 	}
+	ub->disabled = true;
+	spin_unlock_bh(&ub->rcast_lock);
 
 	tn = tipc_net(sock_net(ub->ubsock->sk));
 
-- 
2.53.0



