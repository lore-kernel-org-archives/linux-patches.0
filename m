Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C7D39EF35;
	Sat, 12 Sep 2026 20:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243364; cv=none; b=uyQEA3kXgnuSv+zTX6IXKqoOLMoJndmtPEulMVHWH0TDH23JCAJtWnvbaonNYenJh+0mbQaPOSBOn0cyCtduLMXoLw5vpejxxVTVwGfWHjOpTSJX5/LbVcuTR+LCXnrhXQ910wBqfTWv8YULnBt4lrMxicQIx6PfgFEEIdmKAss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243364; c=relaxed/simple;
	bh=VyKGG/vG851BAXdHZOplstWgiw0SzBTa+g8sj6LWB68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RKqWZLDa3eh4EHgdzyP3cICt8ggGuYDYbnplfefHJAzzUVsrd33+l+oweNal1x7sRPch188dcYtdpSPHg0/nhvbPIAnchNs2nQKghpUCQ1FwA5ggxaMc4Jy861XE+UVlDx23brrrKaoo7+dLHpeQRZCDL87Zy5Kc7PuDfMKeSVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6eLUbBI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6eLUbBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3B71F00893;
	Sat, 12 Sep 2026 20:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243359;
	bh=p06r4OqQTamSoQgL3ypU7n/9U/cAHirw6QJWAFbCh+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v6eLUbBIgWQ4VVmgOfG6m3G+Y1GSjkzVVdbHlp9X6w+I/8USn56mflvTMGwqO94s3
	 8gI9OgZXpRgWD65LgfoGIskigvlkTVXEZ31MmrbSx+Nim/+p7HFZ7j2yboEi5C+b3a
	 7UjLIM4Y6436DEazi5IbGJwWSViisZVa2++wL4uI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 727/798] hsr: Use a single struct for self_node.
Date: Sat, 12 Sep 2026 09:05:55 +0200
Message-ID: <20260912065533.742651826@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 20d3c1e9b861b85e1a774e1876d6adeeb0251fc3 ]

self_node_db is a list_head with one entry of struct hsr_node. The
purpose is to hold the two MAC addresses of the node itself.
It is convenient to recycle the structure. However having a list_head
and fetching always the first entry is not really optimal.

Created a new data strucure contaning the two MAC addresses named
hsr_self_node. Access that structure like an RCU protected pointer so
it can be replaced on the fly without blocking the reader.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 7f16289b91eb ("net: hsr: free learned nodes on device setup failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_device.c   |  1 -
 net/hsr/hsr_framereg.c | 63 +++++++++++++++++++-----------------------
 net/hsr/hsr_main.h     |  8 +++++-
 3 files changed, 35 insertions(+), 37 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 5a54a18892080..1a6f528399610 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -491,7 +491,6 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 	hsr = netdev_priv(hsr_dev);
 	INIT_LIST_HEAD(&hsr->ports);
 	INIT_LIST_HEAD(&hsr->node_db);
-	INIT_LIST_HEAD(&hsr->self_node_db);
 	spin_lock_init(&hsr->list_lock);
 
 	ether_addr_copy(hsr_dev->dev_addr, slave[0]->dev_addr);
diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index eadf44811f3cc..b715509f6b07e 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -40,21 +40,22 @@ static bool seq_nr_after(u16 a, u16 b)
 
 bool hsr_addr_is_self(struct hsr_priv *hsr, unsigned char *addr)
 {
-	struct hsr_node *node;
+	struct hsr_self_node *sn;
+	bool ret = false;
 
-	node = list_first_or_null_rcu(&hsr->self_node_db, struct hsr_node,
-				      mac_list);
-	if (!node) {
+	rcu_read_lock();
+	sn = rcu_dereference(hsr->self_node);
+	if (!sn) {
 		WARN_ONCE(1, "HSR: No self node\n");
-		return false;
+		goto out;
 	}
 
-	if (ether_addr_equal(addr, node->macaddress_A))
-		return true;
-	if (ether_addr_equal(addr, node->macaddress_B))
-		return true;
-
-	return false;
+	if (ether_addr_equal(addr, sn->macaddress_A) ||
+	    ether_addr_equal(addr, sn->macaddress_B))
+		ret = true;
+out:
+	rcu_read_unlock();
+	return ret;
 }
 
 /* Search for mac entry. Caller must hold rcu read lock.
@@ -72,50 +73,42 @@ static struct hsr_node *find_node_by_addr_A(struct list_head *node_db,
 	return NULL;
 }
 
-/* Helper for device init; the self_node_db is used in hsr_rcv() to recognize
+/* Helper for device init; the self_node is used in hsr_rcv() to recognize
  * frames from self that's been looped over the HSR ring.
  */
 int hsr_create_self_node(struct hsr_priv *hsr,
 			 unsigned char addr_a[ETH_ALEN],
 			 unsigned char addr_b[ETH_ALEN])
 {
-	struct list_head *self_node_db = &hsr->self_node_db;
-	struct hsr_node *node, *oldnode;
+	struct hsr_self_node *sn, *old;
 
-	node = kmalloc(sizeof(*node), GFP_KERNEL);
-	if (!node)
+	sn = kmalloc(sizeof(*sn), GFP_KERNEL);
+	if (!sn)
 		return -ENOMEM;
 
-	ether_addr_copy(node->macaddress_A, addr_a);
-	ether_addr_copy(node->macaddress_B, addr_b);
+	ether_addr_copy(sn->macaddress_A, addr_a);
+	ether_addr_copy(sn->macaddress_B, addr_b);
 
 	spin_lock_bh(&hsr->list_lock);
-	oldnode = list_first_or_null_rcu(self_node_db,
-					 struct hsr_node, mac_list);
-	if (oldnode) {
-		list_replace_rcu(&oldnode->mac_list, &node->mac_list);
-		spin_unlock_bh(&hsr->list_lock);
-		kfree_rcu(oldnode, rcu_head);
-	} else {
-		list_add_tail_rcu(&node->mac_list, self_node_db);
-		spin_unlock_bh(&hsr->list_lock);
-	}
+	old = rcu_replace_pointer(hsr->self_node, sn,
+				  lockdep_is_held(&hsr->list_lock));
+	spin_unlock_bh(&hsr->list_lock);
 
+	if (old)
+		kfree_rcu(old, rcu_head);
 	return 0;
 }
 
 void hsr_del_self_node(struct hsr_priv *hsr)
 {
-	struct list_head *self_node_db = &hsr->self_node_db;
-	struct hsr_node *node;
+	struct hsr_self_node *old;
 
 	spin_lock_bh(&hsr->list_lock);
-	node = list_first_or_null_rcu(self_node_db, struct hsr_node, mac_list);
-	if (node) {
-		list_del_rcu(&node->mac_list);
-		kfree_rcu(node, rcu_head);
-	}
+	old = rcu_replace_pointer(hsr->self_node, NULL,
+				  lockdep_is_held(&hsr->list_lock));
 	spin_unlock_bh(&hsr->list_lock);
+	if (old)
+		kfree_rcu(old, rcu_head);
 }
 
 void hsr_del_nodes(struct list_head *node_db)
diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index 9a25a5d349aef..cd7035c0d1bae 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -198,11 +198,17 @@ struct hsr_proto_ops {
 	void (*update_san_info)(struct hsr_node *node, bool is_sup);
 };
 
+struct hsr_self_node {
+	unsigned char	macaddress_A[ETH_ALEN];
+	unsigned char	macaddress_B[ETH_ALEN];
+	struct rcu_head	rcu_head;
+};
+
 struct hsr_priv {
 	struct rcu_head		rcu_head;
 	struct list_head	ports;
 	struct list_head	node_db;	/* Known HSR nodes */
-	struct list_head	self_node_db;	/* MACs of slaves */
+	struct hsr_self_node	__rcu *self_node;	/* MACs of slaves */
 	struct timer_list	announce_timer;	/* Supervision frame dispatch */
 	struct timer_list	prune_timer;
 	int announce_count;
-- 
2.53.0



