Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F1D1AB51B;
	Mon, 14 Oct 2024 14:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917145; cv=none; b=nPu3+8IhWtNFGS7aVVGG30PUjuxjD1O0EI3T3Z6jJLUY7KLC4qeiYS+XfE0WN8mVnWao+V7a3wTrUdjXvnqWZ7/Qd0BL7HVNjssS/mz+Y5aZqGItyWdF9hU4/qB+oygqIS5f4I+wCi3497IJjN4OPfJ1+J62GOPpGCxeMV06PuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917145; c=relaxed/simple;
	bh=xOq+k46P/pi1gkCfw7I0iWzHZCYBcG5JhE9MXHOAMBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kf0SvzQ+TIJzitDrRW2D3IF1LvJ4BYN7o3f6HeUnkOu5SDTdujY4PqCFh4Iqv1ejK5aFfu5XSMIgoom8LJC1Vk9COTvcIcsrGds34pGGTAoW5Znf4Q1hfWfXQNP0UOXa0nsIXJKu4TSzbTgHof9SdQ+M0wKMMSN8Y3yp4Wys/dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jz9y/1K8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jz9y/1K8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0509C4CEC3;
	Mon, 14 Oct 2024 14:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917145;
	bh=xOq+k46P/pi1gkCfw7I0iWzHZCYBcG5JhE9MXHOAMBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jz9y/1K8Eq516TBYKMrTXFcp8PMHCUufEGnfJf61f57ikOoIr4xLwjXMCYAu0STxl
	 p38mQetSPv3luyTI4sWxoiquM7vBaXifogRRpd9+SWiB2n+HRvYscWB/VSmQcLp/Aw
	 N/28jHghAJI+gHLRUU6LUh8sWYURwO5R9BgPBfeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Neeraj Upadhyay (AMD)" <neeraj.iitr10@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 164/213] rcu/nocb: Make IRQs disablement symmetric
Date: Mon, 14 Oct 2024 16:21:10 +0200
Message-ID: <20241014141049.371009559@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit b913c3fe685e0aec80130975b0f330fd709ff324 ]

Currently IRQs are disabled on call_rcu() and then depending on the
context:

* If the CPU is in nocb mode:

   - If the callback is enqueued in the bypass list, IRQs are re-enabled
     implictly by rcu_nocb_try_bypass()

   - If the callback is enqueued in the normal list, IRQs are re-enabled
     implicitly by __call_rcu_nocb_wake()

* If the CPU is NOT in nocb mode, IRQs are reenabled explicitly from call_rcu()

This makes the code a bit hard to follow, especially as it interleaves
with nocb locking.

To make the IRQ flags coverage clearer and also in order to prepare for
moving all the nocb enqueue code to its own function, always re-enable
the IRQ flags explicitly from call_rcu().

Reviewed-by: Neeraj Upadhyay (AMD) <neeraj.iitr10@gmail.com>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Stable-dep-of: f7345ccc62a4 ("rcu/nocb: Fix rcuog wake-up from offline softirq")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.c      |  9 ++++++---
 kernel/rcu/tree_nocb.h | 20 +++++++++-----------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 8541084eeba50..3d7b119f6e2a3 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2727,8 +2727,10 @@ __call_rcu_common(struct rcu_head *head, rcu_callback_t func, bool lazy_in)
 	}
 
 	check_cb_ovld(rdp);
-	if (rcu_nocb_try_bypass(rdp, head, &was_alldone, flags, lazy))
+	if (rcu_nocb_try_bypass(rdp, head, &was_alldone, flags, lazy)) {
+		local_irq_restore(flags);
 		return; // Enqueued onto ->nocb_bypass, so just leave.
+	}
 	// If no-CBs CPU gets here, rcu_nocb_try_bypass() acquired ->nocb_lock.
 	rcu_segcblist_enqueue(&rdp->cblist, head);
 	if (__is_kvfree_rcu_offset((unsigned long)func))
@@ -2746,8 +2748,8 @@ __call_rcu_common(struct rcu_head *head, rcu_callback_t func, bool lazy_in)
 		__call_rcu_nocb_wake(rdp, was_alldone, flags); /* unlocks */
 	} else {
 		__call_rcu_core(rdp, head, flags);
-		local_irq_restore(flags);
 	}
+	local_irq_restore(flags);
 }
 
 #ifdef CONFIG_RCU_LAZY
@@ -4626,8 +4628,9 @@ void rcutree_migrate_callbacks(int cpu)
 		__call_rcu_nocb_wake(my_rdp, true, flags);
 	} else {
 		rcu_nocb_unlock(my_rdp); /* irqs remain disabled. */
-		raw_spin_unlock_irqrestore_rcu_node(my_rnp, flags);
+		raw_spin_unlock_rcu_node(my_rnp); /* irqs remain disabled. */
 	}
+	local_irq_restore(flags);
 	if (needwake)
 		rcu_gp_kthread_wake();
 	lockdep_assert_irqs_enabled();
diff --git a/kernel/rcu/tree_nocb.h b/kernel/rcu/tree_nocb.h
index e019f166daa61..7a0bce3f784df 100644
--- a/kernel/rcu/tree_nocb.h
+++ b/kernel/rcu/tree_nocb.h
@@ -516,9 +516,7 @@ static bool rcu_nocb_try_bypass(struct rcu_data *rdp, struct rcu_head *rhp,
 	// 2. Both of these conditions are met:
 	//    a. The bypass list previously had only lazy CBs, and:
 	//    b. The new CB is non-lazy.
-	if (ncbs && (!bypass_is_lazy || lazy)) {
-		local_irq_restore(flags);
-	} else {
+	if (!ncbs || (bypass_is_lazy && !lazy)) {
 		// No-CBs GP kthread might be indefinitely asleep, if so, wake.
 		rcu_nocb_lock(rdp); // Rare during call_rcu() flood.
 		if (!rcu_segcblist_pend_cbs(&rdp->cblist)) {
@@ -528,7 +526,7 @@ static bool rcu_nocb_try_bypass(struct rcu_data *rdp, struct rcu_head *rhp,
 		} else {
 			trace_rcu_nocb_wake(rcu_state.name, rdp->cpu,
 					    TPS("FirstBQnoWake"));
-			rcu_nocb_unlock_irqrestore(rdp, flags);
+			rcu_nocb_unlock(rdp);
 		}
 	}
 	return true; // Callback already enqueued.
@@ -554,7 +552,7 @@ static void __call_rcu_nocb_wake(struct rcu_data *rdp, bool was_alldone,
 	// If we are being polled or there is no kthread, just leave.
 	t = READ_ONCE(rdp->nocb_gp_kthread);
 	if (rcu_nocb_poll || !t) {
-		rcu_nocb_unlock_irqrestore(rdp, flags);
+		rcu_nocb_unlock(rdp);
 		trace_rcu_nocb_wake(rcu_state.name, rdp->cpu,
 				    TPS("WakeNotPoll"));
 		return;
@@ -567,17 +565,17 @@ static void __call_rcu_nocb_wake(struct rcu_data *rdp, bool was_alldone,
 		rdp->qlen_last_fqs_check = len;
 		// Only lazy CBs in bypass list
 		if (lazy_len && bypass_len == lazy_len) {
-			rcu_nocb_unlock_irqrestore(rdp, flags);
+			rcu_nocb_unlock(rdp);
 			wake_nocb_gp_defer(rdp, RCU_NOCB_WAKE_LAZY,
 					   TPS("WakeLazy"));
 		} else if (!irqs_disabled_flags(flags)) {
 			/* ... if queue was empty ... */
-			rcu_nocb_unlock_irqrestore(rdp, flags);
+			rcu_nocb_unlock(rdp);
 			wake_nocb_gp(rdp, false);
 			trace_rcu_nocb_wake(rcu_state.name, rdp->cpu,
 					    TPS("WakeEmpty"));
 		} else {
-			rcu_nocb_unlock_irqrestore(rdp, flags);
+			rcu_nocb_unlock(rdp);
 			wake_nocb_gp_defer(rdp, RCU_NOCB_WAKE,
 					   TPS("WakeEmptyIsDeferred"));
 		}
@@ -595,15 +593,15 @@ static void __call_rcu_nocb_wake(struct rcu_data *rdp, bool was_alldone,
 		if ((rdp->nocb_cb_sleep ||
 		     !rcu_segcblist_ready_cbs(&rdp->cblist)) &&
 		    !timer_pending(&rdp->nocb_timer)) {
-			rcu_nocb_unlock_irqrestore(rdp, flags);
+			rcu_nocb_unlock(rdp);
 			wake_nocb_gp_defer(rdp, RCU_NOCB_WAKE_FORCE,
 					   TPS("WakeOvfIsDeferred"));
 		} else {
-			rcu_nocb_unlock_irqrestore(rdp, flags);
+			rcu_nocb_unlock(rdp);
 			trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("WakeNot"));
 		}
 	} else {
-		rcu_nocb_unlock_irqrestore(rdp, flags);
+		rcu_nocb_unlock(rdp);
 		trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("WakeNot"));
 	}
 }
-- 
2.43.0



