Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E4522DFA7;
	Tue, 26 Aug 2025 14:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217596; cv=none; b=qD6NZ629yfwy0M5Y7/KUhPrSaFv+UUK1Iaw/07D72uciDPQ6HGceaEk4wJX8ms2aRk4BBF73LgLGss5WVYM7ilMqo8gFVOaPMEkjzvoaiEdTp3eQeix9blAIjtVSHk9BgYbK+462/mak4fZT9HqZLsQO5bM5qo8VSUJrDYdARvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217596; c=relaxed/simple;
	bh=A0TA37oXBdZgOmzLSqclSDo6ox6CQ6OxEHXAsslK8Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WBeQaNusSTVQ1JeKgNSRlkVqSmrmq02EcTQy4xE9vAz01K8ftQk4FrhHNCPJ/YgiFW60F4+VYyDW8ap158CnQfPKLp8aALeO6wnoi3stDU1lWAULQTOHNA14/eyuEDRBj43WbpqDBB2lryqj6LQLOSrrnN/FAasGvfJKOxlfXfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZwtU4V9k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZwtU4V9k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944AFC4CEF1;
	Tue, 26 Aug 2025 14:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217596;
	bh=A0TA37oXBdZgOmzLSqclSDo6ox6CQ6OxEHXAsslK8Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZwtU4V9kk1krWo0c43QpKiFl+pxjG6l5j3UStQVRABI10zsVWIxMH7YS2qMNmj393
	 LbY23lSFWXPBB04iumqPn4yUh25SQNtPf11VMtQghj/iLdDVGPUs/E87SuSCSVEDFd
	 tK+hTpqRDhq/G6Y/bEwElpC1hhnRQeLpQWIAep8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vetter <daniel.vetter@intel.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Michel Lespinasse <walken@google.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Waiman Long <longman@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Dave Chinner <david@fromorbit.com>,
	Qian Cai <cai@lca.pw>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jason Gunthorpe <jgg@mellanox.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m=20 ?= <thomas_os@shipmail.org>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 171/523] mm: extract might_alloc() debug check
Date: Tue, 26 Aug 2025 13:06:21 +0200
Message-ID: <20250826110928.684509470@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

[ Upstream commit 95d6c701f4ca7c44dc148d664f604541266a2333 ]

Extracted from slab.h, which seems to have the most complete version
including the correct might_sleep() check.  Roll it out to slob.c.

Motivated by a discussion with Paul about possibly changing call_rcu
behaviour to allocate memory, but only roughly every 500th call.

There are a lot fewer places in the kernel that care about whether
allocating memory is allowed or not (due to deadlocks with reclaim code)
than places that care whether sleeping is allowed.  But debugging these
also tends to be a lot harder, so nice descriptive checks could come in
handy.  I might have some use eventually for annotations in drivers/gpu.

Note that unlike fs_reclaim_acquire/release gfpflags_allow_blocking does
not consult the PF_MEMALLOC flags.  But there is no flag equivalent for
GFP_NOWAIT, hence this check can't go wrong due to
memalloc_no*_save/restore contexts.  Willy is working on a patch series
which might change this:

https://lore.kernel.org/linux-mm/20200625113122.7540-7-willy@infradead.org/

I think best would be if that updates gfpflags_allow_blocking(), since
there's a ton of callers all over the place for that already.

Link: https://lkml.kernel.org/r/20201125162532.1299794-3-daniel.vetter@ffwll.ch
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Michel Lespinasse <walken@google.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Waiman Long <longman@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Qian Cai <cai@lca.pw>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian König <christian.koenig@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Thomas Hellström (Intel) <thomas_os@shipmail.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 99765233ab42 ("NFS: Fixup allocation flags for nfsiod's __GFP_NORETRY")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/mm.h | 16 ++++++++++++++++
 mm/slab.h                |  5 +----
 mm/slob.c                |  6 ++----
 3 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index e3e5e149b00e..a856c4478d8c 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -189,6 +189,22 @@ static inline void fs_reclaim_acquire(gfp_t gfp_mask) { }
 static inline void fs_reclaim_release(gfp_t gfp_mask) { }
 #endif
 
+/**
+ * might_alloc - Mark possible allocation sites
+ * @gfp_mask: gfp_t flags that would be used to allocate
+ *
+ * Similar to might_sleep() and other annotations, this can be used in functions
+ * that might allocate, but often don't. Compiles to nothing without
+ * CONFIG_LOCKDEP. Includes a conditional might_sleep() if @gfp allows blocking.
+ */
+static inline void might_alloc(gfp_t gfp_mask)
+{
+	fs_reclaim_acquire(gfp_mask);
+	fs_reclaim_release(gfp_mask);
+
+	might_sleep_if(gfpflags_allow_blocking(gfp_mask));
+}
+
 /**
  * memalloc_noio_save - Marks implicit GFP_NOIO allocation scope.
  *
diff --git a/mm/slab.h b/mm/slab.h
index 6952e10cf33b..4b70cf4493e6 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -507,10 +507,7 @@ static inline struct kmem_cache *slab_pre_alloc_hook(struct kmem_cache *s,
 {
 	flags &= gfp_allowed_mask;
 
-	fs_reclaim_acquire(flags);
-	fs_reclaim_release(flags);
-
-	might_sleep_if(gfpflags_allow_blocking(flags));
+	might_alloc(flags);
 
 	if (should_failslab(s, flags))
 		return NULL;
diff --git a/mm/slob.c b/mm/slob.c
index 7cc9805c8091..8d4bfa46247f 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -474,8 +474,7 @@ __do_kmalloc_node(size_t size, gfp_t gfp, int node, unsigned long caller)
 
 	gfp &= gfp_allowed_mask;
 
-	fs_reclaim_acquire(gfp);
-	fs_reclaim_release(gfp);
+	might_alloc(gfp);
 
 	if (size < PAGE_SIZE - minalign) {
 		int align = minalign;
@@ -597,8 +596,7 @@ static void *slob_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
 
 	flags &= gfp_allowed_mask;
 
-	fs_reclaim_acquire(flags);
-	fs_reclaim_release(flags);
+	might_alloc(flags);
 
 	if (c->size < PAGE_SIZE) {
 		b = slob_alloc(c->size, flags, c->align, node, 0);
-- 
2.39.5



