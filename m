Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDFD4E324C;
	Wed, 30 Sep 2026 16:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786859; cv=none; b=KJdfcaEykpfKCHjohKXcjJ1BGMoWZGYvmWUuyhUTr5rs3DnLvKj5PlB6GBYKuhVqebk9Wsk3m5ZDdsPYdsxzxuX7Ilun8hMItEEgQMeIqwvwKi8exwqXJLnoLQmT87BL9eDHkPtsuOT1wpur8jno/PVNbV7sx+n9OR8Iqskqz2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786859; c=relaxed/simple;
	bh=xbN4TeL4WtQwEi+uXfXSnE0MhoE5XQ+8NoeYOkisN38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwskbWbnceUVtyvZQEAl8XuGkgmgFbZUr8A60yjQRkbdLi1nnF2gMXVs1cXOsIqr7YKcGr5wVS/nCpd9+ZKBBp1J+9I4cBWexpeJkm4+WiT7werl5E+W9Z675H9MVxp4AS5VYJhoGkAbI5NUs8ahW9VwTaRbXngmBKFVfiUULew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1lFjbOjN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1lFjbOjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062841F00893;
	Wed, 30 Sep 2026 16:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786858;
	bh=rMpyWKWRRxkHXBn6I9zaEFJ50nf1LADRc7bl2oUy08M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1lFjbOjN1wChPw0UJeADiPinywCOr3Zf/6EhF1izVvkQxrLEr8wYN0pIXo3gEonNj
	 F+eYeqKNNpwZKxbZRwkOTpmjiLCy4Hi/xm0wmX5pU39RxRSobBRzc/QKpza2zBXhfa
	 Y3EpBZntJVPqBBI78uYW9pSqgUbzfuW5E2V3PUT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Hou Tao <houtao1@huawei.com>,
	Pu Lehui <pulehui@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 028/457] bpf: Fix UAF due to concurrent consumption of ttrace lists in alloc_bulk
Date: Wed, 30 Sep 2026 17:22:13 +0200
Message-ID: <20260930152346.639460620@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 1c21452d02eec2f008e2c5535820f85adbd7587a ]

Syzkaller repeatedly triggered UAF splats related to nodes in
waiting_for_gp_ttrace within the bpf memalloc:

BUG: KASAN: slab-use-after-free in llist_del_first+0x85/0x110 lib/llist.c:61
Read of size 8 at addr ffff8881572cd080 by task syz.4.470/5112
 ...
 llist_del_first+0x85/0x110 lib/llist.c:61
 alloc_bulk+0x193/0x460 kernel/bpf/memalloc.c:229
 bpf_mem_refill+0x386/0x560 kernel/bpf/memalloc.c:436

Freed by task 14:
 ...
 __free_rcu kernel/bpf/memalloc.c:281 [inline]
 __free_rcu_tasks_trace+0x48/0xd0 kernel/bpf/memalloc.c:291
 rcu_tasks_invoke_cbs+0x1ec/0x3e0 kernel/rcu/tasks.h:571
 rcu_tasks_one_gp+0x13d/0x220 kernel/rcu/tasks.h:621
 rcu_tasks_kthread+0xf3/0x120 kernel/rcu/tasks.h:651

The reason is that the UAF occurs after the RCU Tasks Trace GP expires:
when the __free_rcu() callback runs, there is no synchronization
protecting llist_del_all() against concurrent alloc_bulk() operating on
waiting_for_gp_ttrace, leading to the race condition below:

CPU0                                           CPU1
                                               __free_rcu (RCU Tasks Trace callback)
alloc_bulk
  llist_del_first(&c->waiting_for_gp_ttrace)
    entry = smp_load_acquire(&head->first);
    do {
      if (entry == NULL)
        return NULL;
                                               free_all(llist_del_all(&c->waiting_for_gp_ttrace))
                                                 llist_for_each_safe(pos, t, llnode)
                                                   free_one(pos);
      next = READ_ONCE(entry->next); <-- trigger UAF
    } while (!try_cmpxchg(&head->first, &entry, next));

In addition, there is also a theoretical race condition on the
free_by_rcu_ttrace list. This race requires two preconditions: an
in-flight Tasks Trace GP keeping c->call_rcu_ttrace_in_progress == 1,
and concurrent cross-CPU frees repopulating c->free_by_rcu_ttrace with
new nodes. Under these conditions, the following scenario triggers UAF:

// CPU0
// irq work is still busy (on PREEMPT_RT)
alloc_bulk()
  llist_del_first(&c->free_by_rcu_ttrace)
    entry = smp_load_acquire(&head->first);
    do {
      if (entry == NULL)
        return NULL;

        // CPU1
        bpf_mem_alloc_destroy()
          WRITE_ONCE(c->draining, true)
          // wait for CPU0
          irq_work_sync()

                // CPU2
                do_call_rcu_ttrace(tgt(CPU0))
                  if (c->draining) {
                    llist_del_all(&c->free_by_rcu_ttrace)
                    free_all()
                  }

// CPU0 continue
      next = READ_ONCE(entry->next); <-- trigger UAF
    while (!try_cmpxchg(&head->first, &entry, next));

Fix this by introducing a raw spinlock to synchronize the concurrent
consumption on waiting_for_gp_ttrace and free_by_rcu_ttrace.

Fixes: 04fabf00b4d3 ("bpf: Allow reuse from waiting_for_gp_ttrace list.")
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Suggested-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Acked-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20260905021139.4116529-1-pulehui@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/memalloc.c | 50 ++++++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 22 deletions(-)

diff --git a/kernel/bpf/memalloc.c b/kernel/bpf/memalloc.c
index e9662db7198fe..8a8f088e83e6f 100644
--- a/kernel/bpf/memalloc.c
+++ b/kernel/bpf/memalloc.c
@@ -119,6 +119,7 @@ struct bpf_mem_cache {
 	struct llist_head waiting_for_gp_ttrace;
 	struct rcu_head rcu_ttrace;
 	atomic_t call_rcu_ttrace_in_progress;
+	raw_spinlock_t lock;
 };
 
 struct bpf_mem_caches {
@@ -214,25 +215,24 @@ static void alloc_bulk(struct bpf_mem_cache *c, int cnt, int node, bool atomic)
 	gfp = __GFP_NOWARN | __GFP_ACCOUNT;
 	gfp |= atomic ? GFP_NOWAIT : GFP_KERNEL;
 
-	for (i = 0; i < cnt; i++) {
-		/*
-		 * For every 'c' llist_del_first(&c->free_by_rcu_ttrace); is
-		 * done only by one CPU == current CPU. Other CPUs might
-		 * llist_add() and llist_del_all() in parallel.
-		 */
-		obj = llist_del_first(&c->free_by_rcu_ttrace);
-		if (!obj)
-			break;
-		add_obj_to_free_list(c, obj);
-	}
-	if (i >= cnt)
-		return;
+	/*
+	 * c->lock serializes concurrent llist_del_first() against
+	 * llist_del_all() in __free_rcu() and do_call_rcu_ttrace().
+	 */
+	scoped_guard(raw_spinlock_irqsave, &c->lock) {
+		for (i = 0; i < cnt; i++) {
+			obj = llist_del_first(&c->free_by_rcu_ttrace);
+			if (!obj)
+				break;
+			add_obj_to_free_list(c, obj);
+		}
 
-	for (; i < cnt; i++) {
-		obj = llist_del_first(&c->waiting_for_gp_ttrace);
-		if (!obj)
-			break;
-		add_obj_to_free_list(c, obj);
+		for (; i < cnt; i++) {
+			obj = llist_del_first(&c->waiting_for_gp_ttrace);
+			if (!obj)
+				break;
+			add_obj_to_free_list(c, obj);
+		}
 	}
 	if (i >= cnt)
 		return;
@@ -279,8 +279,12 @@ static int free_all(struct bpf_mem_cache *c, struct llist_node *llnode, bool per
 static void __free_rcu(struct rcu_head *head)
 {
 	struct bpf_mem_cache *c = container_of(head, struct bpf_mem_cache, rcu_ttrace);
+	struct llist_node *llnode;
+
+	scoped_guard(raw_spinlock_irqsave, &c->lock)
+		llnode = llist_del_all(&c->waiting_for_gp_ttrace);
 
-	free_all(c, llist_del_all(&c->waiting_for_gp_ttrace), !!c->percpu_size);
+	free_all(c, llnode, !!c->percpu_size);
 	atomic_set(&c->call_rcu_ttrace_in_progress, 0);
 }
 
@@ -300,7 +304,8 @@ static void do_call_rcu_ttrace(struct bpf_mem_cache *c)
 
 	if (atomic_xchg(&c->call_rcu_ttrace_in_progress, 1)) {
 		if (unlikely(READ_ONCE(c->draining))) {
-			llnode = llist_del_all(&c->free_by_rcu_ttrace);
+			scoped_guard(raw_spinlock_irqsave, &c->lock)
+				llnode = llist_del_all(&c->free_by_rcu_ttrace);
 			free_all(c, llnode, !!c->percpu_size);
 		}
 		return;
@@ -535,6 +540,7 @@ int bpf_mem_alloc_init(struct bpf_mem_alloc *ma, int size, bool percpu)
 			c->objcg = objcg;
 			c->percpu_size = percpu_size;
 			c->tgt = c;
+			raw_spin_lock_init(&c->lock);
 			init_refill_work(c);
 			prefill_mem_cache(c, cpu);
 		}
@@ -557,7 +563,7 @@ int bpf_mem_alloc_init(struct bpf_mem_alloc *ma, int size, bool percpu)
 			c->objcg = objcg;
 			c->percpu_size = percpu_size;
 			c->tgt = c;
-
+			raw_spin_lock_init(&c->lock);
 			init_refill_work(c);
 			prefill_mem_cache(c, cpu);
 		}
@@ -609,7 +615,7 @@ int bpf_mem_alloc_percpu_unit_init(struct bpf_mem_alloc *ma, int size)
 		c->objcg = objcg;
 		c->percpu_size = percpu_size;
 		c->tgt = c;
-
+		raw_spin_lock_init(&c->lock);
 		init_refill_work(c);
 		prefill_mem_cache(c, cpu);
 	}
-- 
2.53.0



