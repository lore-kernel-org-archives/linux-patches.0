Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827009;
	b=ZPl6Ui2GZ/+Dk4MdXtn9OS5NhVALiZYGAP6zV0FSNVA6skyl3k/SAabEHAORYgaw5KAh
	 mQvLWJziOM/Uy/He2XfFw7Ci9wuqnxfzerh41YjTGQxJ8LHpGe6a9P1tOKHGWGR5PMUeT
	 81ucxyCW/1/eZ2Av4pruXYuFvTO0IcPEsHUvAC9lhJKWw4RTq0CT9EJzt9RIElg1wk42X
	 yUXSnUJPKtf1CL6ZhaGsVLNHFYosXvMl9iLBYNHzb3HAWcbe3OyWtO+sUpaThwEvdCCtx
	 1K4EIXGvab22Ohd0Ms88TPtjX4pDMeOm1xMk38GofWlQJN60iYvqkfqgqTneyY+DhVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6ERx3pNW7NwXBwlok24PnXZKAp/HW7f6ZAxjn3YD2kA=;
	b=KJ9iRKyrQvze/ScsMBETKkKnnBhttDuayNosIKqZRMVT2uVpHtpLdurgo+IrG3TJdp3i
	 sc5auIO75705FU3KEhOV84Y1g6dJWHlD/q0rvDrofe1SqtZKzHfFMth4+BO1LAjKSQh5M
	 exh1rRGCCnSsXmZw5vPObQ7zSmCxPuBtvuQ5Dv8JoFkIVdtQrxMKsU7fnZrBPa/lOY/w1
	 9N7a7c82e6k3pXWKOEVc3zPQJ7iT8YJsc0T8+hwr4K1WVSMuM0veUAHqNhPwydOUO9Ep/
	 vfawzYlq4EFe3Cy2SyE2lpQrG98Bxfd1EGZkU1hBtt4AQ0ih+gQwywC6iFFv5jWVo6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DcpE8voX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C4E6074930;
	Wed,  4 Nov 2026 21:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DcpE8voX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362F71F00919;
	Wed,  4 Nov 2026 21:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827008;
	bh=6ERx3pNW7NwXBwlok24PnXZKAp/HW7f6ZAxjn3YD2kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DcpE8voXDFTTpWcTi5woSYptQzVX5jxyt4rk3Zx+KkFnjVMe/c0iCfM2uN26mHvGJ
	 cwnNXYbD+ey+lWe7oDLoJWXnaVZAtCZs1axNF0t0u3ugF0M/CHEJ6jfZJ/YgWzeFQb
	 iGCZqWpBTqxAhvDu81+EYnOXt/T22zjXs3BptrYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (gemini)" <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.3 100/547] net/sched: sch_teql: fix slaves_lock IRQ deadlock
Date: Wed,  4 Nov 2026 16:04:44 -0500
Message-ID: <20261104211041.065707860@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

commit 8b2043279dae25483fe1f2d926e76d41ab95c398 upstream.

This is a followup of commit e5b811fe7931 ("net/sched: sch_teql:
Introduce slaves_lock to avoid race condition and UAF") as reported by
Sashiko.

The issue: master->slaves_lock serializes the master's ring of slave
qdiscs.  The control paths -- teql_dequeue(), teql_destroy() and
teql_qdisc_init() -- take it with spin_lock_bh(), while
teql_master_xmit() (the master's ndo_start_xmit) takes it with plain
spin_lock().

netpoll_send_skb() wraps the transmit in local_irq_save(), and
__netpoll_send_skb() asserts lockdep_assert_irqs_disabled(), so
teql_master_xmit() reached from netconsole always acquires slaves_lock
with hard IRQs disabled.  On PREEMPT_RT spinlock_t is an rtmutex, and
Documentation/locking/locktypes.rst names

	local_irq_disable();
	spin_lock(&lock);

as a sequence that breaks there because the rtmutex requires a fully
preemptible context.  This is reachable without any panic: the nbcon
printer thread calls netconsole's write_thread() callback on every
message.  The usual remedy -- folding the IRQ disable into the lock with
spin_lock_irqsave() -- is unavailable because the local_irq_save() is
netpoll's, not ours.

On non-RT the same asymmetry leaves slaves_lock acquirable with hard IRQs
disabled on one path and held with hard IRQs enabled on another.  That is
only exploitable during the panic console flush (netconsole is
CON_NBCON_ATOMIC_UNSAFE, so console_is_usable() admits its write_atomic()
only from nbcon_atomic_flush_unsafe(), which panic() alone calls), and
even then an IRQ-saving lock does not help if the holder oopsed inside the
section or was stopped by panic_other_cpus_shutdown().  So the non-RT half
is hardening; the PREEMPT_RT half is the bug.

The Fix: take slaves_lock as a raw spinlock with IRQs saved at every
site.  Since skb_queue_purge() takes the queue's spinlock_t and may not
nest inside a raw lock on PREEMPT_RT, move its call in teql_destroy()
outside the raw section; dat->q is the dying qdisc's own queue and was
never serialized by slaves_lock, so the move is behaviour-neutral.

The new critical sections contain only RCU pointer assignments and
netdev_get_tx_queue(); skb_queue_purge(), netif_wake_queue() and
dev_reset_queue() are all outside them.  teql_destroy()'s ring walk is
O(slaves), two pointer loads and a compare per iteration, so even a large
ring is microseconds with IRQs off.  Keeping the purge conditional rather
than dropping it outright is the conservative call for a backport.

Some context: commit 6301f6a34ed8 ("net/sched: sch_teql: move
rcu_read_lock()/spin_lock() from _bh variants") hardened the parent
fix; together they addressed the master->slaves resurrection
use-after-free and the xmit-side BH warning but left the reverse
direction -- a hard IRQ re-entering xmit while a control path holds the
lock -- unaddressed.

Conditions to recreate the bug:
- CONFIG_PREEMPT_RT, CONFIG_NET_SCH_TEQL, CONFIG_DUMMY and
  CONFIG_NETCONSOLE.
- Run `ip link add dev teqlslave0 type dummy`, bring teqlslave0 up, attach
  it with `tc qdisc add dev teqlslave0 root teql0`, and bring teql0 up.
- Configure a netconsole target on teql0 with explicit local and remote
  IP addresses and a remote MAC address, then emit a console message.
  The nbcon printer thread reaches teql_master_xmit() with hard IRQs
  disabled by netpoll; taking slaves_lock as a spinlock_t is invalid on
  PREEMPT_RT. No panic or concurrent qdisc change is required.
- Reachable by an admin with CAP_NET_ADMIN; teql devices exist only in the
  initial netns (no per-netns ops), so a user namespace does not suffice.

Fixes: e5b811fe7931 ("net/sched: sch_teql: Introduce slaves_lock to avoid race condition and UAF")
Reported-by: Sashiko (gemini) <sashiko-bot@kernel.org>
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260630150922.238714-1-jhs%40mojatatu.com
Link: https://lore.kernel.org/netdev/20260630150922.238714-1-jhs@mojatatu.com/
Cc: stable@vger.kernel.org
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/QDISC-Y0BY.v2.r0.20261024060625-1@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_teql.c |   45 ++++++++++++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 17 deletions(-)

--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -53,7 +53,7 @@ struct teql_master {
 	struct Qdisc_ops qops;
 	struct net_device *dev;
 	struct Qdisc __rcu	*slaves;
-	spinlock_t		slaves_lock; /* serializes writes to ->slaves */
+	raw_spinlock_t		slaves_lock; /* serializes writes to ->slaves */
 	struct list_head master_list;
 	unsigned long	tx_bytes;
 	unsigned long	tx_packets;
@@ -92,6 +92,7 @@ teql_dequeue(struct Qdisc *sch)
 {
 	struct teql_sched_data *dat = qdisc_priv(sch);
 	struct netdev_queue *dat_queue;
+	unsigned long flags;
 	struct sk_buff *skb;
 	struct Qdisc *q;
 
@@ -102,9 +103,9 @@ teql_dequeue(struct Qdisc *sch)
 	if (skb == NULL) {
 		struct net_device *m = qdisc_dev(q);
 		if (m) {
-			spin_lock_bh(&dat->m->slaves_lock);
+			raw_spin_lock_irqsave(&dat->m->slaves_lock, flags);
 			rcu_assign_pointer(dat->m->slaves, sch);
-			spin_unlock_bh(&dat->m->slaves_lock);
+			raw_spin_unlock_irqrestore(&dat->m->slaves_lock, flags);
 			netif_wake_queue(m);
 		}
 	} else {
@@ -137,11 +138,13 @@ teql_destroy(struct Qdisc *sch)
 	struct teql_master *master = dat->m;
 	struct netdev_queue *txq = NULL;
 	bool reset_master_queue = false;
+	unsigned long flags;
+	bool purge = false;
 
 	if (!master)
 		return;
 
-	spin_lock_bh(&master->slaves_lock);
+	raw_spin_lock_irqsave(&master->slaves_lock, flags);
 	prev = rcu_dereference_protected(master->slaves,
 					 lockdep_is_held(&master->slaves_lock));
 	if (prev) {
@@ -169,12 +172,18 @@ teql_destroy(struct Qdisc *sch)
 					reset_master_queue = true;
 				}
 			}
-			skb_queue_purge(&dat->q);
+			purge = true;
 			break;
 		} while (prev != rcu_dereference_protected(master->slaves,
 							   lockdep_is_held(&master->slaves_lock)));
 	}
-	spin_unlock_bh(&master->slaves_lock);
+	raw_spin_unlock_irqrestore(&master->slaves_lock, flags);
+
+	/* skb_queue_purge() takes the queue's spinlock_t, which cannot nest
+	 * inside a raw lock on PREEMPT_RT; purge after the raw section.
+	 */
+	if (purge)
+		skb_queue_purge(&dat->q);
 
 	if (reset_master_queue)
 		dev_reset_queue(master->dev, txq, NULL);
@@ -187,6 +196,7 @@ static int teql_qdisc_init(struct Qdisc
 	struct teql_master *m = (struct teql_master *)sch->ops;
 	struct teql_sched_data *q = qdisc_priv(sch);
 	struct Qdisc *first;
+	unsigned long flags;
 
 	if (dev->hard_header_len > m->dev->hard_header_len)
 		return -EINVAL;
@@ -203,7 +213,7 @@ static int teql_qdisc_init(struct Qdisc
 
 	skb_queue_head_init(&q->q);
 
-	spin_lock_bh(&m->slaves_lock);
+	raw_spin_lock_irqsave(&m->slaves_lock, flags);
 	first = rcu_dereference_protected(m->slaves, lockdep_is_held(&m->slaves_lock));
 	if (first) {
 		if (m->dev->flags & IFF_UP) {
@@ -214,7 +224,7 @@ static int teql_qdisc_init(struct Qdisc
 			    (m->dev->flags & IFF_MULTICAST &&
 			     !(dev->flags & IFF_MULTICAST)) ||
 			    dev->mtu < m->dev->mtu) {
-				spin_unlock_bh(&m->slaves_lock);
+				raw_spin_unlock_irqrestore(&m->slaves_lock, flags);
 				return -EINVAL;
 			}
 		} else {
@@ -237,7 +247,7 @@ static int teql_qdisc_init(struct Qdisc
 		m->dev->mtu = dev->mtu;
 		m->dev->flags = (m->dev->flags&~FMASK)|(dev->flags&FMASK);
 	}
-	spin_unlock_bh(&m->slaves_lock);
+	raw_spin_unlock_irqrestore(&m->slaves_lock, flags);
 	return 0;
 }
 
@@ -302,11 +312,12 @@ static inline int teql_resolve(struct sk
 static netdev_tx_t teql_master_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct teql_master *master = netdev_priv(dev);
-	struct Qdisc *start, *q;
-	int busy;
-	int nores;
 	int subq = skb_get_queue_mapping(skb);
 	struct sk_buff *skb_res = NULL;
+	struct Qdisc *start, *q;
+	unsigned long flags;
+	int nores;
+	int busy;
 
 restart:
 	nores = 0;
@@ -342,13 +353,13 @@ restart:
 				    netdev_start_xmit(skb, slave, slave_txq, false) ==
 				    NETDEV_TX_OK) {
 					__netif_tx_unlock(slave_txq);
-					spin_lock(&master->slaves_lock);
+					raw_spin_lock_irqsave(&master->slaves_lock, flags);
 					if (rcu_dereference_protected(master->slaves,
 								      lockdep_is_held(&master->slaves_lock)) == q)
 						rcu_assign_pointer(master->slaves,
 								   rcu_dereference_protected(NEXT_SLAVE(q),
 											     lockdep_is_held(&master->slaves_lock)));
-					spin_unlock(&master->slaves_lock);
+					raw_spin_unlock_irqrestore(&master->slaves_lock, flags);
 					netif_wake_queue(dev);
 					master->tx_packets++;
 					master->tx_bytes += length;
@@ -361,13 +372,13 @@ restart:
 				busy = 1;
 			break;
 		case 1:
-			spin_lock(&master->slaves_lock);
+			raw_spin_lock_irqsave(&master->slaves_lock, flags);
 			if (rcu_dereference_protected(master->slaves,
 						      lockdep_is_held(&master->slaves_lock)) == q)
 				rcu_assign_pointer(master->slaves,
 						   rcu_dereference_protected(NEXT_SLAVE(q),
 									     lockdep_is_held(&master->slaves_lock)));
-			spin_unlock(&master->slaves_lock);
+			raw_spin_unlock_irqrestore(&master->slaves_lock, flags);
 			rcu_read_unlock();
 			return NETDEV_TX_OK;
 		default:
@@ -489,7 +500,7 @@ static __init void teql_master_setup(str
 	struct teql_master *master = netdev_priv(dev);
 	struct Qdisc_ops *ops = &master->qops;
 
-	spin_lock_init(&master->slaves_lock);
+	raw_spin_lock_init(&master->slaves_lock);
 	master->dev	= dev;
 	ops->priv_size  = sizeof(struct teql_sched_data);
 


