Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7701DFE38;
	Wed,  6 Nov 2024 13:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898742; cv=none; b=K7mcxzkR5ascnIhHsEERdrsI6Hyi1GRJgzs0cWvMwCRPqKokCsVcm+EZmwO6SvEgHXtfBV2D/lJOLfMft2yFQ9pQffbulH7vy3RGPIKVhfTk81ypwAoSH24tLR3uEI4luUVMH1W7jGP36IMH+z9TFRAgG2KtaZRRwPHEVjGHU2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898742; c=relaxed/simple;
	bh=swvfstVfQBTRd2KZ/2MPWHcwI7LAIJWmL5GzBAGzJ78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xh/GH6vhdYsbvsDlAKQz3E5HqA6ziC+7ZPx2wqEHb6lqw192ay2aWvteU7r1rqGYg0CkxZ+xWy7wtN6TC/S7owIM2j5RBLfm2saXq3hwoMpR4BU3aZLG1X+ZtP4hxbnRiXImtVRWAZjU4nXHbpNl9HOog0OdeGA9mSIPYDBcQLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUWqeEZo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUWqeEZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366EDC4CECD;
	Wed,  6 Nov 2024 13:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898742;
	bh=swvfstVfQBTRd2KZ/2MPWHcwI7LAIJWmL5GzBAGzJ78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hUWqeEZoikEQC+67eFo9wr2uBP/uDRSjUH2Pq9wsjzAZN0OJwVXEdD0RKndeSffwz
	 oga0YpzWGdKFuQ7rsygi6eMPf+vpdYm+Tzz73r44iB5l96F5BgzYDOKylcZLh/AUk/
	 WOjJu7P0P7SzlJTKdvTE7gvOL1s58yW7Pr+762KI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Carlos Llamas <cmllamas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 339/462] locking/lockdep: Rework lockdep_lock
Date: Wed,  6 Nov 2024 13:03:52 +0100
Message-ID: <20241106120339.898488812@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit 248efb2158f1e23750728e92ad9db3ab60c14485 upstream.

A few sites want to assert we own the graph_lock/lockdep_lock, provide
a more conventional lock interface for it with a number of trivial
debug checks.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20200313102107.GX12561@hirez.programming.kicks-ass.net
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep.c | 89 ++++++++++++++++++++++------------------
 1 file changed, 48 insertions(+), 41 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 0a2be60e4aa7b..b9fabbab39183 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -84,12 +84,39 @@ module_param(lock_stat, int, 0644);
  * to use a raw spinlock - we really dont want the spinlock
  * code to recurse back into the lockdep code...
  */
-static arch_spinlock_t lockdep_lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
+static arch_spinlock_t __lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
+static struct task_struct *__owner;
+
+static inline void lockdep_lock(void)
+{
+	DEBUG_LOCKS_WARN_ON(!irqs_disabled());
+
+	arch_spin_lock(&__lock);
+	__owner = current;
+	current->lockdep_recursion++;
+}
+
+static inline void lockdep_unlock(void)
+{
+	if (debug_locks && DEBUG_LOCKS_WARN_ON(__owner != current))
+		return;
+
+	current->lockdep_recursion--;
+	__owner = NULL;
+	arch_spin_unlock(&__lock);
+}
+
+static inline bool lockdep_assert_locked(void)
+{
+	return DEBUG_LOCKS_WARN_ON(__owner != current);
+}
+
 static struct task_struct *lockdep_selftest_task_struct;
 
+
 static int graph_lock(void)
 {
-	arch_spin_lock(&lockdep_lock);
+	lockdep_lock();
 	/*
 	 * Make sure that if another CPU detected a bug while
 	 * walking the graph we dont change it (while the other
@@ -97,27 +124,15 @@ static int graph_lock(void)
 	 * dropped already)
 	 */
 	if (!debug_locks) {
-		arch_spin_unlock(&lockdep_lock);
+		lockdep_unlock();
 		return 0;
 	}
-	/* prevent any recursions within lockdep from causing deadlocks */
-	current->lockdep_recursion++;
 	return 1;
 }
 
-static inline int graph_unlock(void)
+static inline void graph_unlock(void)
 {
-	if (debug_locks && !arch_spin_is_locked(&lockdep_lock)) {
-		/*
-		 * The lockdep graph lock isn't locked while we expect it to
-		 * be, we're confused now, bye!
-		 */
-		return DEBUG_LOCKS_WARN_ON(1);
-	}
-
-	current->lockdep_recursion--;
-	arch_spin_unlock(&lockdep_lock);
-	return 0;
+	lockdep_unlock();
 }
 
 /*
@@ -128,7 +143,7 @@ static inline int debug_locks_off_graph_unlock(void)
 {
 	int ret = debug_locks_off();
 
-	arch_spin_unlock(&lockdep_lock);
+	lockdep_unlock();
 
 	return ret;
 }
@@ -1476,6 +1491,8 @@ static int __bfs(struct lock_list *source_entry,
 	struct circular_queue *cq = &lock_cq;
 	int ret = 1;
 
+	lockdep_assert_locked();
+
 	if (match(source_entry, data)) {
 		*target_entry = source_entry;
 		ret = 0;
@@ -1498,8 +1515,6 @@ static int __bfs(struct lock_list *source_entry,
 
 		head = get_dep_list(lock, offset);
 
-		DEBUG_LOCKS_WARN_ON(!irqs_disabled());
-
 		list_for_each_entry_rcu(entry, head, entry) {
 			if (!lock_accessed(entry)) {
 				unsigned int cq_depth;
@@ -1726,11 +1741,9 @@ unsigned long lockdep_count_forward_deps(struct lock_class *class)
 	this.class = class;
 
 	raw_local_irq_save(flags);
-	current->lockdep_recursion++;
-	arch_spin_lock(&lockdep_lock);
+	lockdep_lock();
 	ret = __lockdep_count_forward_deps(&this);
-	arch_spin_unlock(&lockdep_lock);
-	current->lockdep_recursion--;
+	lockdep_unlock();
 	raw_local_irq_restore(flags);
 
 	return ret;
@@ -1755,11 +1768,9 @@ unsigned long lockdep_count_backward_deps(struct lock_class *class)
 	this.class = class;
 
 	raw_local_irq_save(flags);
-	current->lockdep_recursion++;
-	arch_spin_lock(&lockdep_lock);
+	lockdep_lock();
 	ret = __lockdep_count_backward_deps(&this);
-	arch_spin_unlock(&lockdep_lock);
-	current->lockdep_recursion--;
+	lockdep_unlock();
 	raw_local_irq_restore(flags);
 
 	return ret;
@@ -2930,7 +2941,7 @@ static inline int add_chain_cache(struct task_struct *curr,
 	 * disabled to make this an IRQ-safe lock.. for recursion reasons
 	 * lockdep won't complain about its own locking errors.
 	 */
-	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
+	if (lockdep_assert_locked())
 		return 0;
 
 	chain = alloc_lock_chain();
@@ -5092,8 +5103,7 @@ static void free_zapped_rcu(struct rcu_head *ch)
 		return;
 
 	raw_local_irq_save(flags);
-	arch_spin_lock(&lockdep_lock);
-	current->lockdep_recursion++;
+	lockdep_lock();
 
 	/* closed head */
 	pf = delayed_free.pf + (delayed_free.index ^ 1);
@@ -5105,8 +5115,7 @@ static void free_zapped_rcu(struct rcu_head *ch)
 	 */
 	call_rcu_zapped(delayed_free.pf + delayed_free.index);
 
-	current->lockdep_recursion--;
-	arch_spin_unlock(&lockdep_lock);
+	lockdep_unlock();
 	raw_local_irq_restore(flags);
 }
 
@@ -5151,13 +5160,11 @@ static void lockdep_free_key_range_reg(void *start, unsigned long size)
 	init_data_structures_once();
 
 	raw_local_irq_save(flags);
-	arch_spin_lock(&lockdep_lock);
-	current->lockdep_recursion++;
+	lockdep_lock();
 	pf = get_pending_free();
 	__lockdep_free_key_range(pf, start, size);
 	call_rcu_zapped(pf);
-	current->lockdep_recursion--;
-	arch_spin_unlock(&lockdep_lock);
+	lockdep_unlock();
 	raw_local_irq_restore(flags);
 
 	/*
@@ -5179,10 +5186,10 @@ static void lockdep_free_key_range_imm(void *start, unsigned long size)
 	init_data_structures_once();
 
 	raw_local_irq_save(flags);
-	arch_spin_lock(&lockdep_lock);
+	lockdep_lock();
 	__lockdep_free_key_range(pf, start, size);
 	__free_zapped_classes(pf);
-	arch_spin_unlock(&lockdep_lock);
+	lockdep_unlock();
 	raw_local_irq_restore(flags);
 }
 
@@ -5278,10 +5285,10 @@ static void lockdep_reset_lock_imm(struct lockdep_map *lock)
 	unsigned long flags;
 
 	raw_local_irq_save(flags);
-	arch_spin_lock(&lockdep_lock);
+	lockdep_lock();
 	__lockdep_reset_lock(pf, lock);
 	__free_zapped_classes(pf);
-	arch_spin_unlock(&lockdep_lock);
+	lockdep_unlock();
 	raw_local_irq_restore(flags);
 }
 
-- 
2.43.0



