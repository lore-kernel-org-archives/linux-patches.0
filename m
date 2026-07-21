Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45D244AB8A;
	Tue, 21 Jul 2026 21:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669827; cv=none; b=sHgMUU6UUowqN6D0iUVPsZy3cIkabqUkaQCic+uTtsr7iG87h1a7Vjflbb34xu3xtOyycp3RGnuPOBvtlQJeQK8QDId6ktHpyIZp9vDJlVWs+73bE2hZus4BoT6AXohPjLFqOPiDFISCzVnly1f4VBJ1DWu9myu2oQCyWSt53vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669827; c=relaxed/simple;
	bh=47AA7XyeG2ZK55oMufp/AUkFfddJJVoO5330ueIH90c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTb0apeLbcIKh4ekH530zuOzST8m0yrN0NnsgNRpZFuuP91cBIP369d9XWBWlwAhTfz4GzaNNQzxizLrioOKhi3zKl9wqBrRdR7U3QzS5aDv/90TJEF/hORR4bwWswo/W2rzwhfnT0ylXofZyPaI7PyhDsi1YNg3cTAK25T6TNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eW4sDXEv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eW4sDXEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED23B1F00A3A;
	Tue, 21 Jul 2026 21:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669825;
	bh=BRZC4F1I4K9dt2jsTsd9c3Y9FmkcX8Yt1mBtsyQ6igE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eW4sDXEv22yMRRy5YA3WGMTZgD4wLz1F+J97wRgj+CJiVrfyTMzVVNvjQXQGnuPAO
	 TppZ8z420aVE2haEwJEd3eIjPs2sTYiCzFkfd8qZx7oAY/J68Pwb5omFNmqhYyAFx2
	 SmEGkDWQqKRAOlAwL29e0OLBYH2hdXfVO6/NqpBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zdi-disclosures@trendmicro.com,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0658/1067] net/sched: sch_teql: Introduce slaves_lock to avoid race condition and UAF
Date: Tue, 21 Jul 2026 17:20:59 +0200
Message-ID: <20260721152439.313203493@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit e5b811fe793166aecc59b085c1b7c31262ef2316 ]

The teql master->slaves singly linked list is not protected against
multiple writes. It can be mod'ed concurently from teql_master_xmit(),
teql_dequeue(), teql_init() and teql_destroy() without holding any list
lock or RCU protection.

zdi-disclosures@trendmicro.com has demonstrated that the qdisc is freed
after an RCU grace period, but teql_master_xmit() running on another
CPU can still hold a stale pointer into the list, resulting in a
slab-use-after-free:

BUG: KASAN: slab-use-after-free in teql_master_xmit+0xf0f/0x16b0
Read of size 8 at addr ffff888013fb0440 by task poc/332
Freed 512-byte region [ffff888013fb0400, ffff888013fb0600) (kmalloc-512)

The fix?
Add a per-master slaves_lock spinlock that serializes all mutations of
master->slaves and the NEXT_SLAVE() links in teql_destroy() and
teql_qdisc_init(). teql_master_xmit() also takes the same slaves_lock
around those updates.
Annotate master->slaves and the per-slave ->next pointer with __rcu and
use the appropriate RCU accessors everywhere they are touched:
rcu_assign_pointer() on the writer side (under slaves_lock),
rcu_dereference_protected() for the writer-side loads (also under
slaves_lock), rcu_dereference_bh() for the loads in teql_master_xmit() and
rtnl_dereference() for the loads in teql_master_open()/teql_master_mtu(),
which run under RTNL.
Pair this with rcu_read_lock_bh()/rcu_read_unlock_bh() around the list
traversal in teql_master_xmit(), so that readers either observe a fully
linked list or are deferred until the in-flight mutation completes. The two
early-return paths in teql_master_xmit() are updated to release the RCU-bh
read-side critical section before returning, since leaving it held would
disable BH on that CPU for good.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: zdi-disclosures@trendmicro.com
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260628111229.669751-1-jhs@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_teql.c | 125 +++++++++++++++++++++++++++++--------------
 1 file changed, 86 insertions(+), 39 deletions(-)

diff --git a/net/sched/sch_teql.c b/net/sched/sch_teql.c
index efcca269662139..a66d93979fb9d6 100644
--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -52,7 +52,8 @@
 struct teql_master {
 	struct Qdisc_ops qops;
 	struct net_device *dev;
-	struct Qdisc *slaves;
+	struct Qdisc __rcu	*slaves;
+	spinlock_t		slaves_lock; /* serializes writes to ->slaves */
 	struct list_head master_list;
 	unsigned long	tx_bytes;
 	unsigned long	tx_packets;
@@ -61,7 +62,7 @@ struct teql_master {
 };
 
 struct teql_sched_data {
-	struct Qdisc *next;
+	struct Qdisc __rcu	*next;
 	struct teql_master *m;
 	struct sk_buff_head q;
 };
@@ -101,7 +102,9 @@ teql_dequeue(struct Qdisc *sch)
 	if (skb == NULL) {
 		struct net_device *m = qdisc_dev(q);
 		if (m) {
-			dat->m->slaves = sch;
+			spin_lock_bh(&dat->m->slaves_lock);
+			rcu_assign_pointer(dat->m->slaves, sch);
+			spin_unlock_bh(&dat->m->slaves_lock);
 			netif_wake_queue(m);
 		}
 	} else {
@@ -132,34 +135,49 @@ teql_destroy(struct Qdisc *sch)
 	struct Qdisc *q, *prev;
 	struct teql_sched_data *dat = qdisc_priv(sch);
 	struct teql_master *master = dat->m;
+	struct netdev_queue *txq = NULL;
+	bool reset_master_queue = false;
 
 	if (!master)
 		return;
 
-	prev = master->slaves;
+	spin_lock_bh(&master->slaves_lock);
+	prev = rcu_dereference_protected(master->slaves,
+					 lockdep_is_held(&master->slaves_lock));
 	if (prev) {
 		do {
-			q = NEXT_SLAVE(prev);
-			if (q == sch) {
-				NEXT_SLAVE(prev) = NEXT_SLAVE(q);
-				if (q == master->slaves) {
-					master->slaves = NEXT_SLAVE(q);
-					if (q == master->slaves) {
-						struct netdev_queue *txq;
-
-						txq = netdev_get_tx_queue(master->dev, 0);
-						master->slaves = NULL;
-
-						dev_reset_queue(master->dev,
-								txq, NULL);
-					}
-				}
-				skb_queue_purge(&dat->q);
-				break;
+			struct Qdisc *head, *next;
+
+			q = rcu_dereference_protected(NEXT_SLAVE(prev),
+						      lockdep_is_held(&master->slaves_lock));
+			if (q != sch) {
+				prev = q;
+				continue;
 			}
 
-		} while ((prev = q) != master->slaves);
+			next = rcu_dereference_protected(NEXT_SLAVE(q),
+							 lockdep_is_held(&master->slaves_lock));
+			rcu_assign_pointer(NEXT_SLAVE(prev), next);
+
+			head = rcu_dereference_protected(master->slaves,
+							 lockdep_is_held(&master->slaves_lock));
+			if (q == head) {
+				rcu_assign_pointer(master->slaves, next);
+				if (q == next) {
+					txq = netdev_get_tx_queue(master->dev, 0);
+					rcu_assign_pointer(master->slaves, NULL);
+					reset_master_queue = true;
+				}
+			}
+			skb_queue_purge(&dat->q);
+			break;
+		} while (prev != rcu_dereference_protected(master->slaves,
+							   lockdep_is_held(&master->slaves_lock)));
 	}
+	spin_unlock_bh(&master->slaves_lock);
+
+	if (reset_master_queue)
+		dev_reset_queue(master->dev, txq, NULL);
 }
 
 static int teql_qdisc_init(struct Qdisc *sch, struct nlattr *opt,
@@ -168,6 +186,7 @@ static int teql_qdisc_init(struct Qdisc *sch, struct nlattr *opt,
 	struct net_device *dev = qdisc_dev(sch);
 	struct teql_master *m = (struct teql_master *)sch->ops;
 	struct teql_sched_data *q = qdisc_priv(sch);
+	struct Qdisc *first;
 
 	if (dev->hard_header_len > m->dev->hard_header_len)
 		return -EINVAL;
@@ -184,7 +203,9 @@ static int teql_qdisc_init(struct Qdisc *sch, struct nlattr *opt,
 
 	skb_queue_head_init(&q->q);
 
-	if (m->slaves) {
+	spin_lock_bh(&m->slaves_lock);
+	first = rcu_dereference_protected(m->slaves, lockdep_is_held(&m->slaves_lock));
+	if (first) {
 		if (m->dev->flags & IFF_UP) {
 			if ((m->dev->flags & IFF_POINTOPOINT &&
 			     !(dev->flags & IFF_POINTOPOINT)) ||
@@ -192,8 +213,10 @@ static int teql_qdisc_init(struct Qdisc *sch, struct nlattr *opt,
 			     !(dev->flags & IFF_BROADCAST)) ||
 			    (m->dev->flags & IFF_MULTICAST &&
 			     !(dev->flags & IFF_MULTICAST)) ||
-			    dev->mtu < m->dev->mtu)
+			    dev->mtu < m->dev->mtu) {
+				spin_unlock_bh(&m->slaves_lock);
 				return -EINVAL;
+			}
 		} else {
 			if (!(dev->flags&IFF_POINTOPOINT))
 				m->dev->flags &= ~IFF_POINTOPOINT;
@@ -204,14 +227,17 @@ static int teql_qdisc_init(struct Qdisc *sch, struct nlattr *opt,
 			if (dev->mtu < m->dev->mtu)
 				m->dev->mtu = dev->mtu;
 		}
-		q->next = NEXT_SLAVE(m->slaves);
-		NEXT_SLAVE(m->slaves) = sch;
+		rcu_assign_pointer(q->next,
+				   rcu_dereference_protected(NEXT_SLAVE(first),
+							     lockdep_is_held(&m->slaves_lock)));
+		rcu_assign_pointer(NEXT_SLAVE(first), sch);
 	} else {
-		q->next = sch;
-		m->slaves = sch;
+		rcu_assign_pointer(q->next, sch);
+		rcu_assign_pointer(m->slaves, sch);
 		m->dev->mtu = dev->mtu;
 		m->dev->flags = (m->dev->flags&~FMASK)|(dev->flags&FMASK);
 	}
+	spin_unlock_bh(&m->slaves_lock);
 	return 0;
 }
 
@@ -285,7 +311,9 @@ static netdev_tx_t teql_master_xmit(struct sk_buff *skb, struct net_device *dev)
 	int subq = skb_get_queue_mapping(skb);
 	struct sk_buff *skb_res = NULL;
 
-	start = master->slaves;
+	rcu_read_lock_bh();
+
+	start = rcu_dereference_bh(master->slaves);
 
 restart:
 	nores = 0;
@@ -317,10 +345,17 @@ static netdev_tx_t teql_master_xmit(struct sk_buff *skb, struct net_device *dev)
 				    netdev_start_xmit(skb, slave, slave_txq, false) ==
 				    NETDEV_TX_OK) {
 					__netif_tx_unlock(slave_txq);
-					master->slaves = NEXT_SLAVE(q);
+					spin_lock_bh(&master->slaves_lock);
+					if (rcu_dereference_protected(master->slaves,
+								      lockdep_is_held(&master->slaves_lock)) == q)
+						rcu_assign_pointer(master->slaves,
+								   rcu_dereference_protected(NEXT_SLAVE(q),
+											     lockdep_is_held(&master->slaves_lock)));
+					spin_unlock_bh(&master->slaves_lock);
 					netif_wake_queue(dev);
 					master->tx_packets++;
 					master->tx_bytes += length;
+					rcu_read_unlock_bh();
 					return NETDEV_TX_OK;
 				}
 				__netif_tx_unlock(slave_txq);
@@ -329,14 +364,21 @@ static netdev_tx_t teql_master_xmit(struct sk_buff *skb, struct net_device *dev)
 				busy = 1;
 			break;
 		case 1:
-			master->slaves = NEXT_SLAVE(q);
+			spin_lock_bh(&master->slaves_lock);
+			if (rcu_dereference_protected(master->slaves,
+						      lockdep_is_held(&master->slaves_lock)) == q)
+				rcu_assign_pointer(master->slaves,
+						   rcu_dereference_protected(NEXT_SLAVE(q),
+									     lockdep_is_held(&master->slaves_lock)));
+			spin_unlock_bh(&master->slaves_lock);
+			rcu_read_unlock_bh();
 			return NETDEV_TX_OK;
 		default:
 			nores = 1;
 			break;
 		}
 		__skb_pull(skb, skb_network_offset(skb));
-	} while ((q = NEXT_SLAVE(q)) != start);
+	} while ((q = rcu_dereference_bh(NEXT_SLAVE(q))) != start);
 
 	if (nores && skb_res == NULL) {
 		skb_res = skb;
@@ -345,29 +387,32 @@ static netdev_tx_t teql_master_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	if (busy) {
 		netif_stop_queue(dev);
+		rcu_read_unlock_bh();
 		return NETDEV_TX_BUSY;
 	}
 	master->tx_errors++;
 
 drop:
 	master->tx_dropped++;
+	rcu_read_unlock_bh();
 	dev_kfree_skb(skb);
 	return NETDEV_TX_OK;
 }
 
 static int teql_master_open(struct net_device *dev)
 {
-	struct Qdisc *q;
+	struct Qdisc *q, *first;
 	struct teql_master *m = netdev_priv(dev);
 	int mtu = 0xFFFE;
 	unsigned int flags = IFF_NOARP | IFF_MULTICAST;
 
-	if (m->slaves == NULL)
+	first = rtnl_dereference(m->slaves);
+	if (!first)
 		return -EUNATCH;
 
 	flags = FMASK;
 
-	q = m->slaves;
+	q = first;
 	do {
 		struct net_device *slave = qdisc_dev(q);
 
@@ -389,7 +434,7 @@ static int teql_master_open(struct net_device *dev)
 			flags &= ~IFF_BROADCAST;
 		if (!(slave->flags&IFF_MULTICAST))
 			flags &= ~IFF_MULTICAST;
-	} while ((q = NEXT_SLAVE(q)) != m->slaves);
+	} while ((q = rtnl_dereference(NEXT_SLAVE(q))) != first);
 
 	m->dev->mtu = mtu;
 	m->dev->flags = (m->dev->flags&~FMASK) | flags;
@@ -417,14 +462,15 @@ static void teql_master_stats64(struct net_device *dev,
 static int teql_master_mtu(struct net_device *dev, int new_mtu)
 {
 	struct teql_master *m = netdev_priv(dev);
-	struct Qdisc *q;
+	struct Qdisc *q, *first;
 
-	q = m->slaves;
+	first = rtnl_dereference(m->slaves);
+	q = first;
 	if (q) {
 		do {
 			if (new_mtu > qdisc_dev(q)->mtu)
 				return -EINVAL;
-		} while ((q = NEXT_SLAVE(q)) != m->slaves);
+		} while ((q = rtnl_dereference(NEXT_SLAVE(q))) != first);
 	}
 
 	dev->mtu = new_mtu;
@@ -444,6 +490,7 @@ static __init void teql_master_setup(struct net_device *dev)
 	struct teql_master *master = netdev_priv(dev);
 	struct Qdisc_ops *ops = &master->qops;
 
+	spin_lock_init(&master->slaves_lock);
 	master->dev	= dev;
 	ops->priv_size  = sizeof(struct teql_sched_data);
 
-- 
2.53.0



