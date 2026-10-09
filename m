Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524F23B19DE;
	Fri,  9 Oct 2026 14:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556355; cv=none; b=mMPr9aKAJzlT0U0jLxdqakhrE5j7ECtIKW+NmgyYreBULJuKyNcsA9vSBS3e5+EgX5rBycHlpQ7EYA925cX5ZlN8LBq13KtLM+KVS9tlgZrr77B5nZYtyrHBM5yUbpE8duAXlvedfDt4yo1fhsbhLIYuFD4sw0VnGC7tVnTBsks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556355; c=relaxed/simple;
	bh=WhTxOfZ+AP5wl6sw/ktVmSC4fDhBJ8BA9fMlpXFQXUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlhjU4xfet5nLq/hLT1q0i/Y1+EOgq6IgtbhaYQ7ghkPl3tAASmLV4b6UsRgWU8+4dSrHlZ1kmqwUuWG7GoMS4i2ddFdtaZYpOsUIFVWMAeuP7cleCnbKQommJqzaY/e4Z0qV1MDa17BiwP3kHupLR7Fy35Qm+hWrOWnW1SlpUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NbTUJXH8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NbTUJXH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11571F00893;
	Fri,  9 Oct 2026 14:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556354;
	bh=bQnwv5LfLxBd+H+nC3/usSV2cABdcMS/7/ooQlMBgd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NbTUJXH8DOoEOmTMXL1CW7ejU5/X4BuxSwfe9MskzW57XlSLbVrnUeYFpg3FfTgOX
	 Ud68xL6fJ2aYGUJGyCx0rDGPRn51Gq3oH5xpbk9pQAtmQgofyL0RlYEz06r4jtMrKI
	 H9sf6sEcrRWlQJirfVJeuLHk+mHKJYb+M6O7c/h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 163/428] bpf: Fix objects stuck in free_by_rcu_ttrace
Date: Fri,  9 Oct 2026 16:08:20 +0200
Message-ID: <20261009140949.739837791@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit fbd97dd1d3ce32d32fb7be86acc3fdb7c04fa043 ]

do_call_rcu_ttrace() returns early when call_rcu_ttrace_in_progress is set
and leaves the objects in free_by_rcu_ttrace. __free_rcu() frees
waiting_for_gp_ttrace only and clears the flag. Hence the objects that
free_bulk() or __free_by_rcu() added while RCU tasks trace GP was in flight
stay in free_by_rcu_ttrace until free_bulk() or alloc_bulk() is called for
the same bpf_mem_cache again, which may never happen. The number of such
objects is not bounded.

Turn call_rcu_ttrace_in_progress into three states:
0 - idle
1 - __free_rcu() is queued
2 - __free_rcu() is queued and free_by_rcu_ttrace got more objects since

do_call_rcu_ttrace() sets 2. __free_rcu() does cmpxchg(1 -> 0) and starts
the next GP when it fails. It cannot clear the flag first and check
free_by_rcu_ttrace later, since bpf_mem_alloc_destroy() frees bpf_mem_cache
without waiting for RCU callbacks when the flag is zero.

Now __free_rcu() queues itself, so the one that didn't see 'draining' may
do call_rcu_tasks_trace() after rcu_barrier_tasks_trace() in
free_mem_alloc(). Queue it under rcu_read_lock() and do synchronize_rcu()
before the barriers. Calling rcu_barrier_tasks_trace() twice works too, but
creating and destroying hash maps in a loop on many cpus slows down to one
free_mem_alloc() per GP and kworkers pile up.

Fixes: 8d5a8011b35d ("bpf: Batch call_rcu callbacks instead of SLAB_TYPESAFE_BY_RCU.")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20260930095920.601738-3-alexei.starovoitov@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/memalloc.c | 34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/memalloc.c b/kernel/bpf/memalloc.c
index 08e4dde66cd52..15684d0fc883b 100644
--- a/kernel/bpf/memalloc.c
+++ b/kernel/bpf/memalloc.c
@@ -118,6 +118,11 @@ struct bpf_mem_cache {
 	struct llist_head free_by_rcu_ttrace;
 	struct llist_head waiting_for_gp_ttrace;
 	struct rcu_head rcu_ttrace;
+	/*
+	 * 0 - idle
+	 * 1 - __free_rcu() is queued
+	 * 2 - __free_rcu() is queued and free_by_rcu_ttrace got more objects since
+	 */
 	atomic_t call_rcu_ttrace_in_progress;
 	raw_spinlock_t lock;
 };
@@ -276,6 +281,8 @@ static int free_all(struct bpf_mem_cache *c, struct llist_node *llnode, bool per
 	return cnt;
 }
 
+static void __do_call_rcu_ttrace(struct bpf_mem_cache *c);
+
 static void __free_rcu(struct rcu_head *head)
 {
 	struct bpf_mem_cache *c = container_of(head, struct bpf_mem_cache, rcu_ttrace);
@@ -285,7 +292,19 @@ static void __free_rcu(struct rcu_head *head)
 		llnode = llist_del_all(&c->waiting_for_gp_ttrace);
 
 	free_all(c, llnode, !!c->percpu_size);
-	atomic_set(&c->call_rcu_ttrace_in_progress, 0);
+
+	/*
+	 * do_call_rcu_ttrace() that ran while GP was in flight left its objects
+	 * in free_by_rcu_ttrace. This cache may never free or alloc in bulk
+	 * again, so start the next GP from here.
+	 * 'c' can be freed as soon as call_rcu_ttrace_in_progress is zero.
+	 */
+	if (atomic_cmpxchg(&c->call_rcu_ttrace_in_progress, 1, 0) == 1)
+		return;
+
+	/* Pairs with synchronize_rcu() in free_mem_alloc() */
+	guard(rcu)();
+	__do_call_rcu_ttrace(c);
 }
 
 static void enque_to_free(struct bpf_mem_cache *c, void *obj)
@@ -302,6 +321,12 @@ static void __do_call_rcu_ttrace(struct bpf_mem_cache *c)
 {
 	struct llist_node *llnode, *t;
 
+	/*
+	 * Must be done before llist_del_all(). Objects that it misses were
+	 * added by do_call_rcu_ttrace() that will set 2 after this store.
+	 */
+	atomic_set(&c->call_rcu_ttrace_in_progress, 1);
+
 	WARN_ON_ONCE(!llist_empty(&c->waiting_for_gp_ttrace));
 	llist_for_each_safe(llnode, t, llist_del_all(&c->free_by_rcu_ttrace))
 		llist_add(llnode, &c->waiting_for_gp_ttrace);
@@ -323,7 +348,7 @@ static void do_call_rcu_ttrace(struct bpf_mem_cache *c)
 {
 	struct llist_node *llnode;
 
-	if (atomic_xchg(&c->call_rcu_ttrace_in_progress, 1)) {
+	if (atomic_xchg(&c->call_rcu_ttrace_in_progress, 2)) {
 		if (unlikely(READ_ONCE(c->draining))) {
 			scoped_guard(raw_spinlock_irqsave, &c->lock)
 				llnode = llist_del_all(&c->free_by_rcu_ttrace);
@@ -707,7 +732,12 @@ static void free_mem_alloc(struct bpf_mem_alloc *ma)
 	 * to wait for the pending __free_by_rcu(), and __free_rcu(). RCU Tasks
 	 * Trace grace period implies RCU grace period, so all __free_rcu don't
 	 * need extra call_rcu() (and thus extra rcu_barrier() here).
+	 *
+	 * __free_rcu() queues itself again unless it sees 'draining'. After
+	 * synchronize_rcu() it either did that already or will not do it, so
+	 * rcu_barrier_tasks_trace() cannot miss it.
 	 */
+	synchronize_rcu();
 	rcu_barrier(); /* wait for __free_by_rcu */
 	rcu_barrier_tasks_trace(); /* wait for __free_rcu */
 	free_mem_alloc_no_barrier(ma);
-- 
2.53.0



