Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3734A349CDC;
	Sat, 30 May 2026 16:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158956; cv=none; b=OuvRXsNf/dXWbIV9jrEZO+DtE7+rHuEF0VEX7m4sJX58P79oY4ytBA0sxekBozRC+bBSsn5e5UKnCs2ziFNOR4yfxKuxar6Fr5SbXZDAXBh61XP5NrJkTO6HY2ict8bexQ7b4mQ3PNFMrBr0HmxNmCuPFNZyYylAYeJOUygegoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158956; c=relaxed/simple;
	bh=tNI1cQv2Eanz4PaPnfiKtltccrYFxTjSjGgzK4corvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LdHyRlPrUJ++azmsBCvhE7Ww5ojo4jQE10ycoDE309WvM3OqEHY5R6NVJ0V4JzZeicBidguUZYNg6iGQDtoeNqaKNEY4Hvqd2Vk5DUdGWpwpGZYoBg8cgG7Vo9v3Q1e2WVWZ2hUvUme4eDXSdQG8cTkI/Y0RZ4Ho/I4miHbuS0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fgMFrelT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fgMFrelT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FC61F00893;
	Sat, 30 May 2026 16:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158955;
	bh=qBydEpUrDjC+z2TfpT71aEPHusSABReIt2WUnbn0q1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fgMFrelTpT6/wpNjtW92sv7ANtCCvr8wedpj+xxYKIEIfutIdYWVVWIOfKg4efvUL
	 ENg1jKZhEQ6bWnMafSEBt0uXGTKJTdlJaBHD5gaOGqDUyN8GA/7blmOeK+qsW/NVVu
	 lOd6sXdWqq8zXBwvIsxf+Y+MnSF13D+r7YQ6YfDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yin Fengwei <fengwei_yin@linux.alibaba.com>,
	Dong Chenchen <dongchenchen2@huawei.com>,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	XiaoHua Wang <561399680@139.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/969] net: add proper RCU protection to /proc/net/ptype
Date: Sat, 30 May 2026 17:53:34 +0200
Message-ID: <20260530160302.818910917@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/net-procfs.c | 49 +++++++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index 1ec23bf8b05ca..2be3c1f6949bc 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -192,8 +192,14 @@ static const struct seq_operations softnet_seq_ops = {
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
@@ -203,12 +209,16 @@ static void *ptype_get_idx(struct seq_file *seq, loff_t pos)
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
 	list_for_each_entry_rcu(pt, &ptype_all, list) {
 		if (i == pos)
 			return pt;
@@ -234,6 +244,7 @@ static void *ptype_seq_start(struct seq_file *seq, loff_t *pos)
 
 static void *ptype_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
+	struct ptype_iter_state *iter = seq->private;
 	struct net_device *dev;
 	struct packet_type *pt;
 	struct list_head *nxt;
@@ -244,20 +255,21 @@ static void *ptype_seq_next(struct seq_file *seq, void *v, loff_t *pos)
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
-		nxt = ptype_all.next;
+		iter->dev = NULL;
+		nxt = READ_ONCE(ptype_all.next);
 		goto ptype_all;
 	}
 
@@ -266,14 +278,14 @@ static void *ptype_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 		if (nxt != &ptype_all)
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
@@ -287,19 +299,24 @@ static void ptype_seq_stop(struct seq_file *seq, void *v)
 
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
@@ -323,7 +340,7 @@ static int __net_init dev_proc_net_init(struct net *net)
 			 &softnet_seq_ops))
 		goto out_dev;
 	if (!proc_create_net("ptype", 0444, net->proc_net, &ptype_seq_ops,
-			sizeof(struct seq_net_private)))
+			sizeof(struct ptype_iter_state)))
 		goto out_softnet;
 
 	if (wext_proc_init(net))
-- 
2.53.0



