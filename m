Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC2B29DB8F;
	Tue, 31 Mar 2026 16:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976202; cv=none; b=nFIYj498gzXkVJHAk5oRzckF4f/hyR+9pxLZ9iiFqJoIXpM0bEaxRIS+rjWU+celjINC5gOymDZK4w6lz5R5UKCJlVHvl2UIaETIUGZWJl1MIGILw+JqKnNaJ7jhUcSJUZlwwvq/6xH/6gDx0BKlkZx21cLMNhiddM2yg8yqagg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976202; c=relaxed/simple;
	bh=+m96hJuEj69HnCpllmcp6MvtVLPC0zGkOzimT+VjNIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYyFElpKlCIC8tS6fhhQ4CM0xHw2+MUaTrmoQYwYmce5NM5i6JkMT82NxLOLSYqqT3ZQ/PF4yJ+/OPwAbFY58SUvBhaNjlJJHQlTo06qCN38Baz3nEU94+LF6I/oUDUrRjf5jiJSj97H50vOAfQNRFhFufXDgPGsPXxNpeDW2wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RoQarikA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RoQarikA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA19EC19424;
	Tue, 31 Mar 2026 16:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976202;
	bh=+m96hJuEj69HnCpllmcp6MvtVLPC0zGkOzimT+VjNIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RoQarikAONEV195IY6c/T4pj8L0VncFc5T511Rhxy2taRf0Sm0HHzsHIkmD9WCOEP
	 sOUGrSY4hTfN4sq26zBNVc7EOknnWByv6HUB9/mC1MudOjxXFkU1COkploxyXJRUHe
	 NCJP+2ThQQauoIsu3o5JCqGREcy7mWatHXd5gdGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yin Fengwei <fengwei_yin@linux.alibaba.com>,
	Dong Chenchen <dongchenchen2@huawei.com>,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	XiaoHua Wang <561399680@139.com>
Subject: [PATCH 6.12 214/244] net: add proper RCU protection to /proc/net/ptype
Date: Tue, 31 Mar 2026 18:22:44 +0200
Message-ID: <20260331161749.662382030@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

[ Upstream commit f613e8b4afea0cd17c7168e8b00e25bc8d33175d ]

Yin Fengwei reported an RCU stall in ptype_seq_show() and provided
a patch.

Real issue is that ptype_seq_next() and ptype_seq_show() violate
RCU rules.

ptype_seq_show() runs under rcu_read_lock(), and reads pt->dev
to get device name without any barrier.

At the same time, concurrent writers can remove a packet_type structure
(which is correctly freed after an RCU grace period) and clear pt->dev
without an RCU grace period.

Define ptype_iter_state to carry a dev pointer along seq_net_private:

struct ptype_iter_state {
	struct seq_net_private	p;
	struct net_device	*dev; // added in this patch
};

We need to record the device pointer in ptype_get_idx() and
ptype_seq_next() so that ptype_seq_show() is safe against
concurrent pt->dev changes.

We also need to add full RCU protection in ptype_seq_next().
(Missing READ_ONCE() when reading list.next values)

Many thanks to Dong Chenchen for providing a repro.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: 1d10f8a1f40b ("net-procfs: show net devices bound packet types")
Fixes: c353e8983e0d ("net: introduce per netns packet chains")
Reported-by: Yin Fengwei <fengwei_yin@linux.alibaba.com>
Reported-by: Dong Chenchen <dongchenchen2@huawei.com>
Closes: https://lore.kernel.org/netdev/CANn89iKRRKPnWjJmb-_3a=sq+9h6DvTQM4DBZHT5ZRGPMzQaiA@mail.gmail.com/T/#m7b80b9fc9b9267f90e0b7aad557595f686f9c50d

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Tested-by: Yin Fengwei <fengwei_yin@linux.alibaba.com>
Link: https://patch.msgid.link/20260202205217.2881198-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Some adjustments have been made. ]
Signed-off-by: XiaoHua Wang <561399680@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/net-procfs.c |   49 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 16 deletions(-)

--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -168,8 +168,14 @@ static const struct seq_operations softn
 	.show  = softnet_seq_show,
 };
 
+struct ptype_iter_state {
+	struct seq_net_private	p;
+	struct net_device	*dev;
+};
+
 static void *ptype_get_idx(struct seq_file *seq, loff_t pos)
 {
+	struct ptype_iter_state *iter = seq->private;
 	struct list_head *ptype_list = NULL;
 	struct packet_type *pt = NULL;
 	struct net_device *dev;
@@ -179,12 +185,16 @@ static void *ptype_get_idx(struct seq_fi
 	for_each_netdev_rcu(seq_file_net(seq), dev) {
 		ptype_list = &dev->ptype_all;
 		list_for_each_entry_rcu(pt, ptype_list, list) {
-			if (i == pos)
+			if (i == pos) {
+				iter->dev = dev;
 				return pt;
+			}
 			++i;
 		}
 	}
 
+	iter->dev = NULL;
+
 	list_for_each_entry_rcu(pt, &net_hotdata.ptype_all, list) {
 		if (i == pos)
 			return pt;
@@ -210,6 +220,7 @@ static void *ptype_seq_start(struct seq_
 
 static void *ptype_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
+	struct ptype_iter_state *iter = seq->private;
 	struct net_device *dev;
 	struct packet_type *pt;
 	struct list_head *nxt;
@@ -220,20 +231,21 @@ static void *ptype_seq_next(struct seq_f
 		return ptype_get_idx(seq, 0);
 
 	pt = v;
-	nxt = pt->list.next;
-	if (pt->dev) {
-		if (nxt != &pt->dev->ptype_all)
+	nxt = READ_ONCE(pt->list.next);
+	dev = iter->dev;
+	if (dev) {
+		if (nxt != &dev->ptype_all)
 			goto found;
 
-		dev = pt->dev;
 		for_each_netdev_continue_rcu(seq_file_net(seq), dev) {
-			if (!list_empty(&dev->ptype_all)) {
-				nxt = dev->ptype_all.next;
+			nxt = READ_ONCE(dev->ptype_all.next);
+			if (nxt != &dev->ptype_all) {
+				iter->dev = dev;
 				goto found;
 			}
 		}
-
-		nxt = net_hotdata.ptype_all.next;
+		iter->dev = NULL;
+		nxt = READ_ONCE(net_hotdata.ptype_all.next);
 		goto ptype_all;
 	}
 
@@ -242,14 +254,14 @@ ptype_all:
 		if (nxt != &net_hotdata.ptype_all)
 			goto found;
 		hash = 0;
-		nxt = ptype_base[0].next;
+		nxt = READ_ONCE(ptype_base[0].next);
 	} else
 		hash = ntohs(pt->type) & PTYPE_HASH_MASK;
 
 	while (nxt == &ptype_base[hash]) {
 		if (++hash >= PTYPE_HASH_SIZE)
 			return NULL;
-		nxt = ptype_base[hash].next;
+		nxt = READ_ONCE(ptype_base[hash].next);
 	}
 found:
 	return list_entry(nxt, struct packet_type, list);
@@ -263,19 +275,24 @@ static void ptype_seq_stop(struct seq_fi
 
 static int ptype_seq_show(struct seq_file *seq, void *v)
 {
+	struct ptype_iter_state *iter = seq->private;
 	struct packet_type *pt = v;
+	struct net_device *dev;
 
-	if (v == SEQ_START_TOKEN)
+	if (v == SEQ_START_TOKEN) {
 		seq_puts(seq, "Type Device      Function\n");
-	else if ((!pt->af_packet_net || net_eq(pt->af_packet_net, seq_file_net(seq))) &&
-		 (!pt->dev || net_eq(dev_net(pt->dev), seq_file_net(seq)))) {
+		return 0;
+	}
+	dev = iter->dev;
+	if ((!pt->af_packet_net || net_eq(pt->af_packet_net, seq_file_net(seq))) &&
+		 (!dev || net_eq(dev_net(dev), seq_file_net(seq)))) {
 		if (pt->type == htons(ETH_P_ALL))
 			seq_puts(seq, "ALL ");
 		else
 			seq_printf(seq, "%04x", ntohs(pt->type));
 
 		seq_printf(seq, " %-8s %ps\n",
-			   pt->dev ? pt->dev->name : "", pt->func);
+			   dev ? dev->name : "", pt->func);
 	}
 
 	return 0;
@@ -299,7 +316,7 @@ static int __net_init dev_proc_net_init(
 			 &softnet_seq_ops))
 		goto out_dev;
 	if (!proc_create_net("ptype", 0444, net->proc_net, &ptype_seq_ops,
-			sizeof(struct seq_net_private)))
+			sizeof(struct ptype_iter_state)))
 		goto out_softnet;
 
 	if (wext_proc_init(net))


