Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4106D1FE44A;
	Thu, 30 Jul 2026 14:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423317; cv=none; b=d9jVnHTbKKJuljkbfZsOEhuJ80f0MoTO/73qDEJeVLaLFElmDanryl2jbV83dbHAeGKBf2pmkwta/OoFZv0kaE91Vuakyj/Q9tBtpf2WKkul28kv9NfDjqLRoFH/ibrF4x8xOlAX2juML0Uaqe4ws87JoXCryL3RnfaPIOa9beo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423317; c=relaxed/simple;
	bh=0mak4o/RkBzCqQnQY0eQ7fJ1hgjZEnZ+iUIOsYsXb64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQqhSWE8e1HPFMxdLH9sRyrSs6VJe/CofC14nlSAKKJE0UiKa7PutlUQZYDfNUZ3u0kPsXt3fF1obCYhYlyCFc6ZxK3vZJI3O68F+2PJzZX6n8qIFb2TiuQ2CRxxUhb01DawxGWmB8Lu2dEMYuDFJFMgiWbqn+GrmqdldbY3XNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OK4z0bFi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OK4z0bFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9684A1F000E9;
	Thu, 30 Jul 2026 14:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423316;
	bh=/LrXE6Nn4rdXPZ3q7G8WYJZbSxIrfq/X2R2wbhiqS4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OK4z0bFiOuHQN46wA287EVkasb2K9DPttMzhVsEh7klsh7Ok0P9mdrHamYAy8O1kq
	 1fIYKa/4Vmu0SIiDiqucBKflaQw7Xif68cE54x6HzYDaBcB1h1weehfIdKRvtqSJj6
	 QhYUuk6qS9EWeTUHHFqtx0lbtU4n25OOE3KxDIeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 740/744] sched_ext: Move shared helpers from ext.c into internal.h and cid.h
Date: Thu, 30 Jul 2026 16:16:53 +0200
Message-ID: <20260730141500.042806055@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 4437ad129cf5b37c00a5bc9fa5989d1da4d64d07 ]

idle.c and cid.c are included into build_policy.c together with ext.c and
use helpers that ext.c defines. Because the helpers live in ext.c, the two
files can not parse as standalone units and clangd reports errors in them.

Move the helpers to the headers they belong to. The op-dispatch macros and
helpers plus scx_parent() to internal.h, and scx_cpu_arg()/scx_cpu_ret() to
cid.h. No functional change. idle.c and cid.c now parse clean standalone.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Stable-dep-of: 18d62044cda7 ("sched_ext: Preserve rq tracking across local DSQ dispatch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c          |   29 -----------------------------
 kernel/sched/ext_internal.h |   30 ++++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 29 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -218,8 +218,6 @@ static __printf(4, 5) bool scx_exit(stru
 #define scx_error(sch, fmt, args...)	scx_exit((sch), SCX_EXIT_ERROR, 0, fmt, ##args)
 #define scx_verror(sch, fmt, args)	scx_vexit((sch), SCX_EXIT_ERROR, 0, fmt, args)
 
-#define SCX_HAS_OP(sch, op)	test_bit(SCX_OP_IDX(op), (sch)->has_op)
-
 static long jiffies_delta_msecs(unsigned long at, unsigned long now)
 {
 	if (time_after(at, now))
@@ -235,20 +233,6 @@ static bool u32_before(u32 a, u32 b)
 
 #ifdef CONFIG_EXT_SUB_SCHED
 /**
- * scx_parent - Find the parent sched
- * @sch: sched to find the parent of
- *
- * Returns the parent scheduler or %NULL if @sch is root.
- */
-static struct scx_sched *scx_parent(struct scx_sched *sch)
-{
-	if (sch->level)
-		return sch->ancestors[sch->level - 1];
-	else
-		return NULL;
-}
-
-/**
  * scx_next_descendant_pre - find the next descendant for pre-order walk
  * @pos: the current position (%NULL to initiate traversal)
  * @root: sched whose descendants to walk
@@ -295,7 +279,6 @@ static void scx_set_task_sched(struct ta
 	rcu_assign_pointer(p->scx.sched, sch);
 }
 #else	/* CONFIG_EXT_SUB_SCHED */
-static struct scx_sched *scx_parent(struct scx_sched *sch) { return NULL; }
 static struct scx_sched *scx_next_descendant_pre(struct scx_sched *pos, struct scx_sched *root) { return pos ? NULL : root; }
 static void scx_set_task_sched(struct task_struct *p, struct scx_sched *sch) {}
 #endif	/* CONFIG_EXT_SUB_SCHED */
@@ -455,18 +438,6 @@ static bool rq_is_open(struct rq *rq, u6
  */
 DEFINE_PER_CPU(struct rq *, scx_locked_rq_state);
 
-static inline void update_locked_rq(struct rq *rq)
-{
-	/*
-	 * Check whether @rq is actually locked. This can help expose bugs
-	 * or incorrect assumptions about the context in which a kfunc or
-	 * callback is executed.
-	 */
-	if (rq)
-		lockdep_assert_rq_held(rq);
-	__this_cpu_write(scx_locked_rq_state, rq);
-}
-
 /*
  * SCX ops can recurse via scx_bpf_sub_dispatch() - the inner call must not
  * clobber the outer's scx_locked_rq_state. Save it on entry, restore on exit.
--- a/kernel/sched/ext_internal.h
+++ b/kernel/sched/ext_internal.h
@@ -1377,6 +1377,20 @@ static inline struct rq *scx_locked_rq(v
 	return __this_cpu_read(scx_locked_rq_state);
 }
 
+static inline void update_locked_rq(struct rq *rq)
+{
+	/*
+	 * Check whether @rq is actually locked. This can help expose bugs
+	 * or incorrect assumptions about the context in which a kfunc or
+	 * callback is executed.
+	 */
+	if (rq)
+		lockdep_assert_rq_held(rq);
+	__this_cpu_write(scx_locked_rq_state, rq);
+}
+
+#define SCX_HAS_OP(sch, op)	test_bit(SCX_OP_IDX(op), (sch)->has_op)
+
 static inline bool scx_bypassing(struct scx_sched *sch, s32 cpu)
 {
 	return unlikely(per_cpu_ptr(sch->pcpu, cpu)->flags &
@@ -1457,6 +1471,20 @@ static inline struct scx_sched *scx_prog
 
 	return NULL;
 }
+
+/**
+ * scx_parent - Find the parent sched
+ * @sch: sched to find the parent of
+ *
+ * Returns the parent scheduler or %NULL if @sch is root.
+ */
+static inline struct scx_sched *scx_parent(struct scx_sched *sch)
+{
+	if (sch->level)
+		return sch->ancestors[sch->level - 1];
+	else
+		return NULL;
+}
 #else	/* CONFIG_EXT_SUB_SCHED */
 static inline struct scx_sched *scx_task_sched(const struct task_struct *p)
 {
@@ -1480,4 +1508,6 @@ static struct scx_sched *scx_prog_sched(
 {
 	return rcu_dereference_all(scx_root);
 }
+
+static inline struct scx_sched *scx_parent(struct scx_sched *sch) { return NULL; }
 #endif	/* CONFIG_EXT_SUB_SCHED */


