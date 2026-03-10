Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF0D387598;
	Tue, 10 Mar 2026 11:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142203; cv=none; b=H4zmNiJUqhHXt+iCioPUEscTQMdd3ZOXyApr4MAjUdgCYb+k/qJKSaGvRuymn4g0J0G93i2IkuxNHEDMYrNCuSLcx786MnjlK82ixdCToZEsQTeXddB0vZQ+9fXMQ5AZz3E8WH3aQTktN1x9lCK300iq3nb0gg9TaYeFKG8Frgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142203; c=relaxed/simple;
	bh=oq8PFPcqbfTauwDtsVOS+VtLHX6P3U6CzjTVWfSVk/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qtM7IEZ9dcoga8MAQrZz1JydRs1mQo1+8UA/d8+iAOLeZbZSfx6A/v3m0scK/vy3T8ThRFZ2Xn5iu8UElx7i3l99lEmmgGq8PlT23PvFiUnKo/7n29afht+f/sUg6UhQPxCzmmVoY1Ie0nHsHpbPfSAn1JVawWTTIDBLZB9fhYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NwBI1BCX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NwBI1BCX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1186CC2BC86;
	Tue, 10 Mar 2026 11:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142203;
	bh=oq8PFPcqbfTauwDtsVOS+VtLHX6P3U6CzjTVWfSVk/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NwBI1BCXDPWPWElpY74RdXqWq9NkXxcKPfX+VfRCW5jKMAv/izrYqOV1QSDV5K93a
	 09uNXNkM2Nm5FNtLCrU736Om08kQZyP2AwvZ4hFl/FAciGEOvSDHZEhwOjH2SgBANl
	 CsZRnwzh9FD33291c+BJizpl3FyfzEJLcab7s4gQC8nUoYWX3wTw3tqqEAOa3X+CJt
	 FkbVzpk4lVnFajFM9rQDPtwPoWtLgkCFr2MRxTgxfmyLD4VVPLB9/726cF98scYbDX
	 xajsEenyjIh7g53J5PgFUvLHuIgKge9rNkHDJVvgmLoZ1aSaMX94ARohxjT4HlXEO2
	 wX2h3MzbUkuzQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Bert Karwatzki <spasswolf@web.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 293/314] net: Provide a PREEMPT_RT specific check for netdev_queue::_xmit_lock
Date: Tue, 10 Mar 2026 07:19:12 -0400
Message-ID: <832190e3233960c72b10da2d1e696fe008c17271.1773141556.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit b824c3e16c1904bf80df489e293d1e3cbf98896d ]

After acquiring netdev_queue::_xmit_lock the number of the CPU owning
the lock is recorded in netdev_queue::xmit_lock_owner. This works as
long as the BH context is not preemptible.

On PREEMPT_RT the softirq context is preemptible and without the
softirq-lock it is possible to have multiple user in __dev_queue_xmit()
submitting a skb on the same CPU. This is fine in general but this means
also that the current CPU is recorded as netdev_queue::xmit_lock_owner.
This in turn leads to the recursion alert and the skb is dropped.

Instead checking the for CPU number, that owns the lock, PREEMPT_RT can
check if the lockowner matches the current task.

Add netif_tx_owned() which returns true if the current context owns the
lock by comparing the provided CPU number with the recorded number. This
resembles the current check by negating the condition (the current check
returns true if the lock is not owned).
On PREEMPT_RT use rt_mutex_owner() to return the lock owner and compare
the current task against it.
Use the new helper in __dev_queue_xmit() and netif_local_xmit_active()
which provides a similar check.
Update comments regarding pairing READ_ONCE().

Reported-by: Bert Karwatzki <spasswolf@web.de>
Closes: https://lore.kernel.org/all/20260216134333.412332-1-spasswolf@web.de
Fixes: 3253cb49cbad4 ("softirq: Allow to drop the softirq-BKL lock on PREEMPT_RT")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reported-by: Bert Karwatzki <spasswolf@web.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://patch.msgid.link/20260302162631.uGUyIqDT@linutronix.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 27 ++++++++++++++++++++++-----
 net/core/dev.c            |  5 +----
 net/core/netpoll.c        |  2 +-
 3 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3d9f21274dc32..8bb7b0e2c5438 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4684,7 +4684,7 @@ static inline u32 netif_msg_init(int debug_value, int default_msg_enable_bits)
 static inline void __netif_tx_lock(struct netdev_queue *txq, int cpu)
 {
 	spin_lock(&txq->_xmit_lock);
-	/* Pairs with READ_ONCE() in __dev_queue_xmit() */
+	/* Pairs with READ_ONCE() in netif_tx_owned() */
 	WRITE_ONCE(txq->xmit_lock_owner, cpu);
 }
 
@@ -4702,7 +4702,7 @@ static inline void __netif_tx_release(struct netdev_queue *txq)
 static inline void __netif_tx_lock_bh(struct netdev_queue *txq)
 {
 	spin_lock_bh(&txq->_xmit_lock);
-	/* Pairs with READ_ONCE() in __dev_queue_xmit() */
+	/* Pairs with READ_ONCE() in netif_tx_owned() */
 	WRITE_ONCE(txq->xmit_lock_owner, smp_processor_id());
 }
 
@@ -4711,7 +4711,7 @@ static inline bool __netif_tx_trylock(struct netdev_queue *txq)
 	bool ok = spin_trylock(&txq->_xmit_lock);
 
 	if (likely(ok)) {
-		/* Pairs with READ_ONCE() in __dev_queue_xmit() */
+		/* Pairs with READ_ONCE() in netif_tx_owned() */
 		WRITE_ONCE(txq->xmit_lock_owner, smp_processor_id());
 	}
 	return ok;
@@ -4719,14 +4719,14 @@ static inline bool __netif_tx_trylock(struct netdev_queue *txq)
 
 static inline void __netif_tx_unlock(struct netdev_queue *txq)
 {
-	/* Pairs with READ_ONCE() in __dev_queue_xmit() */
+	/* Pairs with READ_ONCE() in netif_tx_owned() */
 	WRITE_ONCE(txq->xmit_lock_owner, -1);
 	spin_unlock(&txq->_xmit_lock);
 }
 
 static inline void __netif_tx_unlock_bh(struct netdev_queue *txq)
 {
-	/* Pairs with READ_ONCE() in __dev_queue_xmit() */
+	/* Pairs with READ_ONCE() in netif_tx_owned() */
 	WRITE_ONCE(txq->xmit_lock_owner, -1);
 	spin_unlock_bh(&txq->_xmit_lock);
 }
@@ -4819,6 +4819,23 @@ static inline void netif_tx_disable(struct net_device *dev)
 	local_bh_enable();
 }
 
+#ifndef CONFIG_PREEMPT_RT
+static inline bool netif_tx_owned(struct netdev_queue *txq, unsigned int cpu)
+{
+	/* Other cpus might concurrently change txq->xmit_lock_owner
+	 * to -1 or to their cpu id, but not to our id.
+	 */
+	return READ_ONCE(txq->xmit_lock_owner) == cpu;
+}
+
+#else
+static inline bool netif_tx_owned(struct netdev_queue *txq, unsigned int cpu)
+{
+	return rt_mutex_owner(&txq->_xmit_lock.lock) == current;
+}
+
+#endif
+
 static inline void netif_addr_lock(struct net_device *dev)
 {
 	unsigned char nest_level = 0;
diff --git a/net/core/dev.c b/net/core/dev.c
index f937b8ba08222..c8e49eef45198 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4758,10 +4758,7 @@ int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	if (dev->flags & IFF_UP) {
 		int cpu = smp_processor_id(); /* ok because BHs are off */
 
-		/* Other cpus might concurrently change txq->xmit_lock_owner
-		 * to -1 or to their cpu id, but not to our id.
-		 */
-		if (READ_ONCE(txq->xmit_lock_owner) != cpu) {
+		if (!netif_tx_owned(txq, cpu)) {
 			bool is_list = false;
 
 			if (dev_xmit_recursion())
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 09f72f10813cc..5af14f14a3623 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -132,7 +132,7 @@ static int netif_local_xmit_active(struct net_device *dev)
 	for (i = 0; i < dev->num_tx_queues; i++) {
 		struct netdev_queue *txq = netdev_get_tx_queue(dev, i);
 
-		if (READ_ONCE(txq->xmit_lock_owner) == smp_processor_id())
+		if (netif_tx_owned(txq, smp_processor_id()))
 			return 1;
 	}
 
-- 
2.51.0

