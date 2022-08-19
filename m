Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF3D46AA
	for <patches@lists.linux.dev>; Fri, 19 Aug 2022 18:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C221DC433C1
	for <patches@lists.linux.dev>; Fri, 19 Aug 2022 18:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1660933039;
	bh=wzu+Kt0b9/2o1WMO67l9qOM/dVjhTLvXnknLEIZREmA=;
	h=From:Date:Subject:References:In-Reply-To:To:Reply-To:From;
	b=S58MyLfVzFWhuM5UU+rZJm9I0XgI2HWLNMW5PtTDpiCcHWeKCa+qkmM9sptO93etx
	 VDuX8fGg/iAF1oLCjsvHTzCN6vnufkUH2B8HNBwpkfoXv/FPO7c8ycM26ckUj/cgAl
	 iGvvoIRe3P/OxWozrCi0w2g/EEc+mKK+otXffUS+Fjm1Q4RIAHNEBFUR3Pa2UVWDr8
	 wkmJwZ8Wv8kgx4Jp2AyRymjgLabBc7ZKsV0o+34AvFIIyIVxRqLTSCSQvivnt1nD4M
	 mGKe46oTCIhhEdY9EtUTh1sTK+rrF1whuCJk/xbypd5/xwsqpv5sL5gIgwHD755LxU
	 nmjkQdIoyzdVQ==
From: Konstantin Ryabitsev via B4 Web Endpoint <devnull@kernel.org>
Date: Fri, 19 Aug 2022 14:17:15 -0400
Subject: [PATCH v1 1/9] slub: Make PREEMPT_RT support less convoluted
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20220819-test-endpoint-send-v1-1-2d7c68bdbbdc@linuxfoundation.org>
References: <20220819-test-endpoint-send-v1-0-2d7c68bdbbdc@linuxfoundation.org>
In-Reply-To: <20220819-test-endpoint-send-v1-0-2d7c68bdbbdc@linuxfoundation.org>
To: patches@lists.linux.dev
X-Mailer: b4 0.10.0-dev-c53d8
X-Developer-Signature: v=1; a=openpgp-sha256; l=5932;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=CaoP4ym0aPyViBlsTaEw4lgwUU6a+mqFpoxz97vJ5mI=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJL+X16bNjme9bHNzOfpudyVJw1OJyYklZ52rFYtEQquz0tW
 FxXoKGVhEONikBVTZCnbF7spqPChh1x6jynMHFYmkCEMXJwCMJFKJ0aGc2+rvzHXNbMpt4YGXJx6UL
 n+cVDukZMtbwRfrxaY5aTKwfBXmumXaXV95d+8bRc//FKJst95jlGl47fZx+2c2XW/y5k4AA==
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E
X-Original-From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Reply-To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

From: Thomas Gleixner <tglx@linutronix.de>

The slub code already has a few helpers depending on PREEMPT_RT. Add a few
more and get rid of the CONFIG_PREEMPT_RT conditionals all over the place.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

diff --git a/mm/slub.c b/mm/slub.c
index 862dbd9af4f5..5f7c5b5bd49f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -100,9 +100,11 @@
  *   except the stat counters. This is a percpu structure manipulated only by
  *   the local cpu, so the lock protects against being preempted or interrupted
  *   by an irq. Fast path operations rely on lockless operations instead.
- *   On PREEMPT_RT, the local lock does not actually disable irqs (and thus
- *   prevent the lockless operations), so fastpath operations also need to take
- *   the lock and are no longer lockless.
+ *
+ *   On PREEMPT_RT, the local lock neither disables interrupts nor preemption
+ *   which means the lockless fastpath cannot be used as it might interfere with
+ *   an in-progress slow path operations. In this case the local lock is always
+ *   taken but it still utilizes the freelist for the common operations.
  *
  *   lockless fastpaths
  *
@@ -163,8 +165,11 @@
  * function call even on !PREEMPT_RT, use inline preempt_disable() there.
  */
 #ifndef CONFIG_PREEMPT_RT
-#define slub_get_cpu_ptr(var)	get_cpu_ptr(var)
-#define slub_put_cpu_ptr(var)	put_cpu_ptr(var)
+#define slub_get_cpu_ptr(var)		get_cpu_ptr(var)
+#define slub_put_cpu_ptr(var)		put_cpu_ptr(var)
+#define use_lockless_fast_path()	(true)
+#define slub_local_irq_save(flags)	local_irq_save(flags)
+#define slub_local_irq_restore(flags)	local_irq_restore(flags)
 #else
 #define slub_get_cpu_ptr(var)		\
 ({					\
@@ -176,6 +181,9 @@ do {					\
 	(void)(var);			\
 	migrate_enable();		\
 } while (0)
+#define use_lockless_fast_path()	(false)
+#define slub_local_irq_save(flags)	do { } while (0)
+#define slub_local_irq_restore(flags)	do { } while (0)
 #endif
 
 #ifdef CONFIG_SLUB_DEBUG
@@ -460,16 +468,14 @@ static __always_inline void __slab_unlock(struct slab *slab)
 
 static __always_inline void slab_lock(struct slab *slab, unsigned long *flags)
 {
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		local_irq_save(*flags);
+	slub_local_irq_save(*flags);
 	__slab_lock(slab);
 }
 
 static __always_inline void slab_unlock(struct slab *slab, unsigned long *flags)
 {
 	__slab_unlock(slab);
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		local_irq_restore(*flags);
+	slub_local_irq_restore(*flags);
 }
 
 /*
@@ -482,7 +488,7 @@ static inline bool __cmpxchg_double_slab(struct kmem_cache *s, struct slab *slab
 		void *freelist_new, unsigned long counters_new,
 		const char *n)
 {
-	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+	if (use_lockless_fast_path())
 		lockdep_assert_irqs_disabled();
 #if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
     defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
@@ -3197,14 +3203,8 @@ static __always_inline void *slab_alloc_node(struct kmem_cache *s, struct list_l
 
 	object = c->freelist;
 	slab = c->slab;
-	/*
-	 * We cannot use the lockless fastpath on PREEMPT_RT because if a
-	 * slowpath has taken the local_lock_irqsave(), it is not protected
-	 * against a fast path operation in an irq handler. So we need to take
-	 * the slow path which uses local_lock. It is still relatively fast if
-	 * there is a suitable cpu freelist.
-	 */
-	if (IS_ENABLED(CONFIG_PREEMPT_RT) ||
+
+	if (!use_lockless_fast_path() ||
 	    unlikely(!object || !slab || !node_match(slab, node))) {
 		object = __slab_alloc(s, gfpflags, node, addr, c);
 	} else {
@@ -3463,6 +3463,7 @@ static __always_inline void do_slab_free(struct kmem_cache *s,
 	void *tail_obj = tail ? : head;
 	struct kmem_cache_cpu *c;
 	unsigned long tid;
+	void **freelist;
 
 redo:
 	/*
@@ -3477,9 +3478,13 @@ static __always_inline void do_slab_free(struct kmem_cache *s,
 	/* Same with comment on barrier() in slab_alloc_node() */
 	barrier();
 
-	if (likely(slab == c->slab)) {
-#ifndef CONFIG_PREEMPT_RT
-		void **freelist = READ_ONCE(c->freelist);
+	if (unlikely(slab != c->slab)) {
+		__slab_free(s, slab, head, tail_obj, cnt, addr);
+		return;
+	}
+
+	if (use_lockless_fast_path()) {
+		freelist = READ_ONCE(c->freelist);
 
 		set_freepointer(s, tail_obj, freelist);
 
@@ -3491,16 +3496,8 @@ static __always_inline void do_slab_free(struct kmem_cache *s,
 			note_cmpxchg_failure("slab_free", s, tid);
 			goto redo;
 		}
-#else /* CONFIG_PREEMPT_RT */
-		/*
-		 * We cannot use the lockless fastpath on PREEMPT_RT because if
-		 * a slowpath has taken the local_lock_irqsave(), it is not
-		 * protected against a fast path operation in an irq handler. So
-		 * we need to take the local_lock. We shouldn't simply defer to
-		 * __slab_free() as that wouldn't use the cpu freelist at all.
-		 */
-		void **freelist;
-
+	} else {
+		/* Update the free list under the local lock */
 		local_lock(&s->cpu_slab->lock);
 		c = this_cpu_ptr(s->cpu_slab);
 		if (unlikely(slab != c->slab)) {
@@ -3515,11 +3512,8 @@ static __always_inline void do_slab_free(struct kmem_cache *s,
 		c->tid = next_tid(tid);
 
 		local_unlock(&s->cpu_slab->lock);
-#endif
-		stat(s, FREE_FASTPATH);
-	} else
-		__slab_free(s, slab, head, tail_obj, cnt, addr);
-
+	}
+	stat(s, FREE_FASTPATH);
 }
 
 static __always_inline void slab_free(struct kmem_cache *s, struct slab *slab,

-- 
b4 0.10.0-dev-c53d8

