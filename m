Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBDD383C6A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302036; cv=none; b=SlWbXXTSZHVucMmC+Mtg5LAXhnBR3TUsVOuOI0OxGsu3YwnzoL4H3GreVYyI/AFB27YUW3+JlsCITO6bWOmzg9evglgT0dsMtQKlh2QeqxJ/nsJeZTvbGtlUPj1L+SWp11Av9g1rAyZFgnwJIBaeJVxsH5pS0GSN4HL3ifX2hNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302036; c=relaxed/simple;
	bh=fyDbj+hMQvcO4MmlEdqqqTIX7A62hXJPguHEJpFgJXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bslAB+GRuaECj4Rlayc0eTg7dJo9VeoGwyaBK1hrkRjcxILwg2Bcq1KJK1Qg9TDzCXkpE8gWsL7V6W+ohrli6uMZxrsZPkPdkCCcCk5qh9M4J62jNoedbv+yJodRO56HgFwEiX7ayvk7FipMnmd7P1CiaTBV2aFLIHIIPV1GMq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F8kgJxce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F8kgJxce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9980AC116D0;
	Sat, 28 Feb 2026 18:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302036;
	bh=fyDbj+hMQvcO4MmlEdqqqTIX7A62hXJPguHEJpFgJXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8kgJxceL4bRAJWjFasnd5P3OZ1k+4VmbSUExxymEfOYY8sVVXkoztpWnOXzoua2a
	 weOKCrJS+NKIkc5o0hRJ5gdceIZrR4J5zIGtgfq95XHDqWqSg3DDRFoOZKsNGEGPI9
	 Ex71E8I9Vt6IBejKX78To0P5P3n1MpMuuWXr2coEV2FFS/QQhj3uuqfx0xJMU8DtGu
	 ZXxcrHx/z0RfZhVMvnNTvZNtGywHrcU88DMQSl6CcA+GFX6zUQ5fEstD660UIVRQf9
	 54Szf74mMvnhiL67PNOIvYNJz3Ao8KlAgebgDlaw1bYKAGeVYEeYUZ8xJrrmC/lZ/8
	 wGaDEkD8HPkzw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Joel Fernandes <joelagnelf@nvidia.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Neeraj Upadhyay (AMD)" <neeraj.upadhyay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/283] rcu: Refactor expedited handling check in rcu_read_unlock_special()
Date: Sat, 28 Feb 2026 13:02:29 -0500
Message-ID: <20260228180709.1583486-7-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Joel Fernandes <joelagnelf@nvidia.com>

[ Upstream commit 908a97eba8c8b510996bf5d77d1e3070d59caa6d ]

Extract the complex expedited handling condition in rcu_read_unlock_special()
into a separate function rcu_unlock_needs_exp_handling() with detailed
comments explaining each condition.

This improves code readability. No functional change intended.

Reviewed-by: "Paul E. McKenney" <paulmck@kernel.org>
Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>
Signed-off-by: Neeraj Upadhyay (AMD) <neeraj.upadhyay@kernel.org>
Stable-dep-of: d41e37f26b31 ("rcu: Fix rcu_read_unlock() deadloop due to softirq")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_plugin.h | 83 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 74 insertions(+), 9 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index f178a8bb83650..18a8fd116fdff 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -640,6 +640,75 @@ static void rcu_preempt_deferred_qs_handler(struct irq_work *iwp)
 	local_irq_restore(flags);
 }
 
+/*
+ * Check if expedited grace period processing during unlock is needed.
+ *
+ * This function determines whether expedited handling is required based on:
+ * 1. Task blocking an expedited grace period (based on a heuristic, could be
+ *    false-positive, see below.)
+ * 2. CPU participating in an expedited grace period
+ * 3. Strict grace period mode requiring expedited handling
+ * 4. RCU priority deboosting needs when interrupts were disabled
+ *
+ * @t: The task being checked
+ * @rdp: The per-CPU RCU data
+ * @rnp: The RCU node for this CPU
+ * @irqs_were_disabled: Whether interrupts were disabled before rcu_read_unlock()
+ *
+ * Returns true if expedited processing of the rcu_read_unlock() is needed.
+ */
+static bool rcu_unlock_needs_exp_handling(struct task_struct *t,
+				      struct rcu_data *rdp,
+				      struct rcu_node *rnp,
+				      bool irqs_were_disabled)
+{
+	/*
+	 * Check if this task is blocking an expedited grace period. If the
+	 * task was preempted within an RCU read-side critical section and is
+	 * on the expedited grace period blockers list (exp_tasks), we need
+	 * expedited handling to unblock the expedited GP. This is not an exact
+	 * check because 't' might not be on the exp_tasks list at all - its
+	 * just a fast heuristic that can be false-positive sometimes.
+	 */
+	if (t->rcu_blocked_node && READ_ONCE(t->rcu_blocked_node->exp_tasks))
+		return true;
+
+	/*
+	 * Check if this CPU is participating in an expedited grace period.
+	 * The expmask bitmap tracks which CPUs need to check in for the
+	 * current expedited GP. If our CPU's bit is set, we need expedited
+	 * handling to help complete the expedited GP.
+	 */
+	if (rdp->grpmask & READ_ONCE(rnp->expmask))
+		return true;
+
+	/*
+	 * In CONFIG_RCU_STRICT_GRACE_PERIOD=y kernels, all grace periods
+	 * are treated as short for testing purposes even if that means
+	 * disturbing the system more. Check if either:
+	 * - This CPU has not yet reported a quiescent state, or
+	 * - This task was preempted within an RCU critical section
+	 * In either case, require expedited handling for strict GP mode.
+	 */
+	if (IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD) &&
+	    ((rdp->grpmask & READ_ONCE(rnp->qsmask)) || t->rcu_blocked_node))
+		return true;
+
+	/*
+	 * RCU priority boosting case: If a task is subject to RCU priority
+	 * boosting and exits an RCU read-side critical section with interrupts
+	 * disabled, we need expedited handling to ensure timely deboosting.
+	 * Without this, a low-priority task could incorrectly run at high
+	 * real-time priority for an extended period degrading real-time
+	 * responsiveness. This applies to all CONFIG_RCU_BOOST=y kernels,
+	 * not just to PREEMPT_RT.
+	 */
+	if (IS_ENABLED(CONFIG_RCU_BOOST) && irqs_were_disabled && t->rcu_blocked_node)
+		return true;
+
+	return false;
+}
+
 /*
  * Handle special cases during rcu_read_unlock(), such as needing to
  * notify RCU core processing or task having blocked during the RCU
@@ -659,18 +728,14 @@ static void rcu_read_unlock_special(struct task_struct *t)
 	local_irq_save(flags);
 	irqs_were_disabled = irqs_disabled_flags(flags);
 	if (preempt_bh_were_disabled || irqs_were_disabled) {
-		bool expboost; // Expedited GP in flight or possible boosting.
+		bool needs_exp; // Expedited handling needed.
 		struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
 		struct rcu_node *rnp = rdp->mynode;
 
-		expboost = (t->rcu_blocked_node && READ_ONCE(t->rcu_blocked_node->exp_tasks)) ||
-			   (rdp->grpmask & READ_ONCE(rnp->expmask)) ||
-			   (IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD) &&
-			   ((rdp->grpmask & READ_ONCE(rnp->qsmask)) || t->rcu_blocked_node)) ||
-			   (IS_ENABLED(CONFIG_RCU_BOOST) && irqs_were_disabled &&
-			    t->rcu_blocked_node);
+		needs_exp = rcu_unlock_needs_exp_handling(t, rdp, rnp, irqs_were_disabled);
+
 		// Need to defer quiescent state until everything is enabled.
-		if (use_softirq && (in_hardirq() || (expboost && !irqs_were_disabled))) {
+		if (use_softirq && (in_hardirq() || (needs_exp && !irqs_were_disabled))) {
 			// Using softirq, safe to awaken, and either the
 			// wakeup is free or there is either an expedited
 			// GP in flight or a potential need to deboost.
@@ -683,7 +748,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
 			set_tsk_need_resched(current);
 			set_preempt_need_resched();
 			if (IS_ENABLED(CONFIG_IRQ_WORK) && irqs_were_disabled &&
-			    expboost && rdp->defer_qs_iw_pending != DEFER_QS_PENDING &&
+			    needs_exp && rdp->defer_qs_iw_pending != DEFER_QS_PENDING &&
 			    cpu_online(rdp->cpu)) {
 				// Get scheduler to re-evaluate and call hooks.
 				// If !IRQ_WORK, FQS scan will eventually IPI.
-- 
2.51.0

