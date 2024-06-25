Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162FBFBEF;
	Tue, 25 Jun 2024 09:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308156; cv=none; b=r6Q37nicHHoR92exmgojWnLTj/MdZjG3byYdXoZUpF8FntMeDGS+M0gbmYJrjYWaRBfqeQUuZe9/mH37qTuCuzczEa4r7UlEYcfzlUc957rCrPWRpQMQNi0p0yymm8KHSOK/AjTQs+HbEWLXEJN1UhPkMN3ZTBIQxAwO4PEsW1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308156; c=relaxed/simple;
	bh=kks0aAvdwfckZ+T2KkQv+k/KnU6aAP3qxLvWyiABTK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dH1R5KK8ehRd2RXh/M9/RaZQXgqIoR83o94eTmEHGATNutxSk0WuSmWIOw1lkjuNfgkmCSmxPoJdke7dIDt7n3LMnBBqJO21t44qcQqqh/wlwA4J9u3XDffbcQ6V+hHhOANWIaL7LhYzKrLbZddBXJOiYFK42pGAEtKRNdmf3rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tz0sP/5p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tz0sP/5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F808C4AF09;
	Tue, 25 Jun 2024 09:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308156;
	bh=kks0aAvdwfckZ+T2KkQv+k/KnU6aAP3qxLvWyiABTK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tz0sP/5p24ZTDugDLTwVrwlj+g0dTAcCzaEHDnKvmdHEN+dRp4U7i7V/q3qXWmXjv
	 bawkI7Ogo4/8sDAIajD8OLySXzxasUACFPSXV0i/Tls+U+LlO+h94OfOJK0a/hfeBx
	 apxJrOWGpSSQAiCTcpQYAuRDWsaz+97rfGymjN58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wander Lairson Costa <wander@redhat.com>,
	Hu Chunyu <chuhu@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 025/250] drop_monitor: replace spin_lock by raw_spin_lock
Date: Tue, 25 Jun 2024 11:29:43 +0200
Message-ID: <20240625085549.020860478@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wander Lairson Costa <wander@redhat.com>

[ Upstream commit f1e197a665c2148ebc25fe09c53689e60afea195 ]

trace_drop_common() is called with preemption disabled, and it acquires
a spin_lock. This is problematic for RT kernels because spin_locks are
sleeping locks in this configuration, which causes the following splat:

BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 449, name: rcuc/47
preempt_count: 1, expected: 0
RCU nest depth: 2, expected: 2
5 locks held by rcuc/47/449:
 #0: ff1100086ec30a60 ((softirq_ctrl.lock)){+.+.}-{2:2}, at: __local_bh_disable_ip+0x105/0x210
 #1: ffffffffb394a280 (rcu_read_lock){....}-{1:2}, at: rt_spin_lock+0xbf/0x130
 #2: ffffffffb394a280 (rcu_read_lock){....}-{1:2}, at: __local_bh_disable_ip+0x11c/0x210
 #3: ffffffffb394a160 (rcu_callback){....}-{0:0}, at: rcu_do_batch+0x360/0xc70
 #4: ff1100086ee07520 (&data->lock){+.+.}-{2:2}, at: trace_drop_common.constprop.0+0xb5/0x290
irq event stamp: 139909
hardirqs last  enabled at (139908): [<ffffffffb1df2b33>] _raw_spin_unlock_irqrestore+0x63/0x80
hardirqs last disabled at (139909): [<ffffffffb19bd03d>] trace_drop_common.constprop.0+0x26d/0x290
softirqs last  enabled at (139892): [<ffffffffb07a1083>] __local_bh_enable_ip+0x103/0x170
softirqs last disabled at (139898): [<ffffffffb0909b33>] rcu_cpu_kthread+0x93/0x1f0
Preemption disabled at:
[<ffffffffb1de786b>] rt_mutex_slowunlock+0xab/0x2e0
CPU: 47 PID: 449 Comm: rcuc/47 Not tainted 6.9.0-rc2-rt1+ #7
Hardware name: Dell Inc. PowerEdge R650/0Y2G81, BIOS 1.6.5 04/15/2022
Call Trace:
 <TASK>
 dump_stack_lvl+0x8c/0xd0
 dump_stack+0x14/0x20
 __might_resched+0x21e/0x2f0
 rt_spin_lock+0x5e/0x130
 ? trace_drop_common.constprop.0+0xb5/0x290
 ? skb_queue_purge_reason.part.0+0x1bf/0x230
 trace_drop_common.constprop.0+0xb5/0x290
 ? preempt_count_sub+0x1c/0xd0
 ? _raw_spin_unlock_irqrestore+0x4a/0x80
 ? __pfx_trace_drop_common.constprop.0+0x10/0x10
 ? rt_mutex_slowunlock+0x26a/0x2e0
 ? skb_queue_purge_reason.part.0+0x1bf/0x230
 ? __pfx_rt_mutex_slowunlock+0x10/0x10
 ? skb_queue_purge_reason.part.0+0x1bf/0x230
 trace_kfree_skb_hit+0x15/0x20
 trace_kfree_skb+0xe9/0x150
 kfree_skb_reason+0x7b/0x110
 skb_queue_purge_reason.part.0+0x1bf/0x230
 ? __pfx_skb_queue_purge_reason.part.0+0x10/0x10
 ? mark_lock.part.0+0x8a/0x520
...

trace_drop_common() also disables interrupts, but this is a minor issue
because we could easily replace it with a local_lock.

Replace the spin_lock with raw_spin_lock to avoid sleeping in atomic
context.

Signed-off-by: Wander Lairson Costa <wander@redhat.com>
Reported-by: Hu Chunyu <chuhu@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/drop_monitor.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index b0f221d658be8..430ed18f8584c 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -74,7 +74,7 @@ struct net_dm_hw_entries {
 };
 
 struct per_cpu_dm_data {
-	spinlock_t		lock;	/* Protects 'skb', 'hw_entries' and
+	raw_spinlock_t		lock;	/* Protects 'skb', 'hw_entries' and
 					 * 'send_timer'
 					 */
 	union {
@@ -168,9 +168,9 @@ static struct sk_buff *reset_per_cpu_data(struct per_cpu_dm_data *data)
 err:
 	mod_timer(&data->send_timer, jiffies + HZ / 10);
 out:
-	spin_lock_irqsave(&data->lock, flags);
+	raw_spin_lock_irqsave(&data->lock, flags);
 	swap(data->skb, skb);
-	spin_unlock_irqrestore(&data->lock, flags);
+	raw_spin_unlock_irqrestore(&data->lock, flags);
 
 	if (skb) {
 		struct nlmsghdr *nlh = (struct nlmsghdr *)skb->data;
@@ -225,7 +225,7 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
 
 	local_irq_save(flags);
 	data = this_cpu_ptr(&dm_cpu_data);
-	spin_lock(&data->lock);
+	raw_spin_lock(&data->lock);
 	dskb = data->skb;
 
 	if (!dskb)
@@ -259,7 +259,7 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
 	}
 
 out:
-	spin_unlock_irqrestore(&data->lock, flags);
+	raw_spin_unlock_irqrestore(&data->lock, flags);
 }
 
 static void trace_kfree_skb_hit(void *ignore, struct sk_buff *skb,
@@ -314,9 +314,9 @@ net_dm_hw_reset_per_cpu_data(struct per_cpu_dm_data *hw_data)
 		mod_timer(&hw_data->send_timer, jiffies + HZ / 10);
 	}
 
-	spin_lock_irqsave(&hw_data->lock, flags);
+	raw_spin_lock_irqsave(&hw_data->lock, flags);
 	swap(hw_data->hw_entries, hw_entries);
-	spin_unlock_irqrestore(&hw_data->lock, flags);
+	raw_spin_unlock_irqrestore(&hw_data->lock, flags);
 
 	return hw_entries;
 }
@@ -448,7 +448,7 @@ net_dm_hw_trap_summary_probe(void *ignore, const struct devlink *devlink,
 		return;
 
 	hw_data = this_cpu_ptr(&dm_hw_cpu_data);
-	spin_lock_irqsave(&hw_data->lock, flags);
+	raw_spin_lock_irqsave(&hw_data->lock, flags);
 	hw_entries = hw_data->hw_entries;
 
 	if (!hw_entries)
@@ -477,7 +477,7 @@ net_dm_hw_trap_summary_probe(void *ignore, const struct devlink *devlink,
 	}
 
 out:
-	spin_unlock_irqrestore(&hw_data->lock, flags);
+	raw_spin_unlock_irqrestore(&hw_data->lock, flags);
 }
 
 static const struct net_dm_alert_ops net_dm_alert_summary_ops = {
@@ -1673,7 +1673,7 @@ static struct notifier_block dropmon_net_notifier = {
 
 static void __net_dm_cpu_data_init(struct per_cpu_dm_data *data)
 {
-	spin_lock_init(&data->lock);
+	raw_spin_lock_init(&data->lock);
 	skb_queue_head_init(&data->drop_queue);
 	u64_stats_init(&data->stats.syncp);
 }
-- 
2.43.0



