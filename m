Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00447190496;
	Tue, 10 Sep 2024 10:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963401; cv=none; b=VIWxmgjEyXNFUMZ2gr8uEykLclrZDl3FicvFgsWNK1NvfQhomLmgZ18zzk/fueIo7Bug1tQjkuP0bZHCSOwdU+z58PwcoOkcDhzz79E6kjNK6lf8ib1Rh1bVA17y8zON8CXYmDf/AMjao6CWwBV5mWipetg2V2u0gmrsoKTzGvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963401; c=relaxed/simple;
	bh=I1J7JRIPGddsHWlhju2TyJDWfvJXIatak1T17To+KPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YhpsFBtIsqvczZtlpHnId5mfjWsqvWAeG2tONy2UpeWFy9rrUjxjFmAnuWbyfSfczbD2UlAvzKkN8WM9ql5zf+02bBDbUwStsl/mAus1uoc3VotuHR5AnIkbqf4dKql5DI0Ylka34MGSSOQdlOlU8AQQKJGe/G+PVKb+jW4uvoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cK68WSFm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cK68WSFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB9DC4CEC3;
	Tue, 10 Sep 2024 10:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963400;
	bh=I1J7JRIPGddsHWlhju2TyJDWfvJXIatak1T17To+KPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cK68WSFmRzpRsQfTIX3Rb4Q1qzeAB5w5c0BDOQlj0zoCWInCqj3n3tkRmpCPFxbrP
	 5+fLpNBisdEgtcS5DfDrsOKiBln3+Gc8GEe8mTdOqci9V3m5XU9MdtxbZbSqAa30ck
	 iimg6UDKG6cgopJuASvUSGu5LQP/veN5TNHA9EFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/214] rcu/nocb: Remove buggy bypass lock contention mitigation
Date: Tue, 10 Sep 2024 11:31:06 +0200
Message-ID: <20240910092600.578321134@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit e4f78057291608f6968a6789c5ebb3bde7d95504 ]

The bypass lock contention mitigation assumes there can be at most
2 contenders on the bypass lock, following this scheme:

1) One kthread takes the bypass lock
2) Another one spins on it and increment the contended counter
3) A third one (a bypass enqueuer) sees the contended counter on and
  busy loops waiting on it to decrement.

However this assumption is wrong. There can be only one CPU to find the
lock contended because call_rcu() (the bypass enqueuer) is the only
bypass lock acquire site that may not already hold the NOCB lock
beforehand, all the other sites must first contend on the NOCB lock.
Therefore step 2) is impossible.

The other problem is that the mitigation assumes that contenders all
belong to the same rdp CPU, which is also impossible for a raw spinlock.
In theory the warning could trigger if the enqueuer holds the bypass
lock and another CPU flushes the bypass queue concurrently but this is
prevented from all flush users:

1) NOCB kthreads only flush if they successfully _tried_ to lock the
   bypass lock. So no contention management here.

2) Flush on callbacks migration happen remotely when the CPU is offline.
   No concurrency against bypass enqueue.

3) Flush on deoffloading happen either locally with IRQs disabled or
   remotely when the CPU is not yet online. No concurrency against
   bypass enqueue.

4) Flush on barrier entrain happen either locally with IRQs disabled or
   remotely when the CPU is offline. No concurrency against
   bypass enqueue.

For those reasons, the bypass lock contention mitigation isn't needed
and is even wrong. Remove it but keep the warning reporting a contended
bypass lock on a remote CPU, to keep unexpected contention awareness.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.h      |  1 -
 kernel/rcu/tree_nocb.h | 32 ++++++--------------------------
 2 files changed, 6 insertions(+), 27 deletions(-)

diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 2da96d8b894a..f27d3e3fe4ed 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -205,7 +205,6 @@ struct rcu_data {
 	struct swait_queue_head nocb_state_wq; /* For offloading state changes */
 	struct task_struct *nocb_gp_kthread;
 	raw_spinlock_t nocb_lock;	/* Guard following pair of fields. */
-	atomic_t nocb_lock_contended;	/* Contention experienced. */
 	int nocb_defer_wakeup;		/* Defer wakeup of nocb_kthread. */
 	struct timer_list nocb_timer;	/* Enforce finite deferral. */
 	unsigned long nocb_gp_adv_time;	/* Last call_rcu() CB adv (jiffies). */
diff --git a/kernel/rcu/tree_nocb.h b/kernel/rcu/tree_nocb.h
index 8fdf44f8523f..d170dc1f3719 100644
--- a/kernel/rcu/tree_nocb.h
+++ b/kernel/rcu/tree_nocb.h
@@ -88,8 +88,7 @@ module_param(nocb_nobypass_lim_per_jiffy, int, 0);
 
 /*
  * Acquire the specified rcu_data structure's ->nocb_bypass_lock.  If the
- * lock isn't immediately available, increment ->nocb_lock_contended to
- * flag the contention.
+ * lock isn't immediately available, perform minimal sanity check.
  */
 static void rcu_nocb_bypass_lock(struct rcu_data *rdp)
 	__acquires(&rdp->nocb_bypass_lock)
@@ -97,29 +96,12 @@ static void rcu_nocb_bypass_lock(struct rcu_data *rdp)
 	lockdep_assert_irqs_disabled();
 	if (raw_spin_trylock(&rdp->nocb_bypass_lock))
 		return;
-	atomic_inc(&rdp->nocb_lock_contended);
+	/*
+	 * Contention expected only when local enqueue collide with
+	 * remote flush from kthreads.
+	 */
 	WARN_ON_ONCE(smp_processor_id() != rdp->cpu);
-	smp_mb__after_atomic(); /* atomic_inc() before lock. */
 	raw_spin_lock(&rdp->nocb_bypass_lock);
-	smp_mb__before_atomic(); /* atomic_dec() after lock. */
-	atomic_dec(&rdp->nocb_lock_contended);
-}
-
-/*
- * Spinwait until the specified rcu_data structure's ->nocb_lock is
- * not contended.  Please note that this is extremely special-purpose,
- * relying on the fact that at most two kthreads and one CPU contend for
- * this lock, and also that the two kthreads are guaranteed to have frequent
- * grace-period-duration time intervals between successive acquisitions
- * of the lock.  This allows us to use an extremely simple throttling
- * mechanism, and further to apply it only to the CPU doing floods of
- * call_rcu() invocations.  Don't try this at home!
- */
-static void rcu_nocb_wait_contended(struct rcu_data *rdp)
-{
-	WARN_ON_ONCE(smp_processor_id() != rdp->cpu);
-	while (WARN_ON_ONCE(atomic_read(&rdp->nocb_lock_contended)))
-		cpu_relax();
 }
 
 /*
@@ -457,7 +439,6 @@ static bool rcu_nocb_try_bypass(struct rcu_data *rdp, struct rcu_head *rhp,
 	}
 
 	// We need to use the bypass.
-	rcu_nocb_wait_contended(rdp);
 	rcu_nocb_bypass_lock(rdp);
 	ncbs = rcu_cblist_n_cbs(&rdp->nocb_bypass);
 	rcu_segcblist_inc_len(&rdp->cblist); /* Must precede enqueue. */
@@ -1361,12 +1342,11 @@ static void show_rcu_nocb_state(struct rcu_data *rdp)
 
 	sprintf(bufw, "%ld", rsclp->gp_seq[RCU_WAIT_TAIL]);
 	sprintf(bufr, "%ld", rsclp->gp_seq[RCU_NEXT_READY_TAIL]);
-	pr_info("   CB %d^%d->%d %c%c%c%c%c%c F%ld L%ld C%d %c%c%s%c%s%c%c q%ld %c CPU %d%s\n",
+	pr_info("   CB %d^%d->%d %c%c%c%c%c F%ld L%ld C%d %c%c%s%c%s%c%c q%ld %c CPU %d%s\n",
 		rdp->cpu, rdp->nocb_gp_rdp->cpu,
 		rdp->nocb_next_cb_rdp ? rdp->nocb_next_cb_rdp->cpu : -1,
 		"kK"[!!rdp->nocb_cb_kthread],
 		"bB"[raw_spin_is_locked(&rdp->nocb_bypass_lock)],
-		"cC"[!!atomic_read(&rdp->nocb_lock_contended)],
 		"lL"[raw_spin_is_locked(&rdp->nocb_lock)],
 		"sS"[!!rdp->nocb_cb_sleep],
 		".W"[swait_active(&rdp->nocb_cb_wq)],
-- 
2.43.0



