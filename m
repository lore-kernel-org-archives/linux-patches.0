Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4D0146A63;
	Mon, 24 Feb 2025 14:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408385; cv=none; b=NP70Z9g1sD7siLuHIg0cH4YcGlWtjCar/kfrPJdZPOUR7NXtpqd37FHuWqhK4iDMKu4LUmLHwwMapLwE9SzdI4/avlTMK+cLCPGoOPeSu2MGOMEbuoy2nht9LC+re7r8Br13LUhMF+M//ETWRy5uFIGJk7rS7ZwVWrW9+BWS96Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408385; c=relaxed/simple;
	bh=Wg5JRoFL6PMNVOzECvr11NfeZBNrZp7P+AscyDkPMwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKmKHSXKVJ/R7Gb9yV1EH6X3h8m3nnKjEGtdInBPvE30PNB/YY1bB/IZcQlCTjCfsiukvhVANntWsS2IzJ1rYkv+Ebml6Z9I1FsVcIXRXg9Y2m1oTvxCtEi9AdlU5j1YSU1h86hcu2V0HXuPPKLiKBd+oacwxLfeQWMHKHkH5Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cv8+Cu2j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cv8+Cu2j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234BCC4CEE6;
	Mon, 24 Feb 2025 14:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408384;
	bh=Wg5JRoFL6PMNVOzECvr11NfeZBNrZp7P+AscyDkPMwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cv8+Cu2j1Ymx1S0Uudwtwxg9JgSN13XSEUvdLCWv072j7uUl7bUvrEjNkRdwM5LAB
	 10rCjYxGTBQjOOrJO57hZOO1St7ukqNdORdN0M1i64WpGjsJdBloYQkBlpQapXF+m/
	 //uf4q6YYCcTt3q4zC4J5/n0PwgiLI4APcJO46xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/154] sched_ext: Factor out move_task_between_dsqs() from scx_dispatch_from_dsq()
Date: Mon, 24 Feb 2025 15:34:01 +0100
Message-ID: <20250224142608.740888219@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 8427acb6b5861d205abca7afa656a897bbae34b7 ]

Pure reorganization. No functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: 32966821574c ("sched_ext: Fix migration disabled handling in targeted dispatches")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 116 +++++++++++++++++++++++++++++----------------
 1 file changed, 75 insertions(+), 41 deletions(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 689f7e8f69f54..97076748dee0e 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -2397,6 +2397,73 @@ static inline bool task_can_run_on_remote_rq(struct task_struct *p, struct rq *r
 static inline bool consume_remote_task(struct rq *this_rq, struct task_struct *p, struct scx_dispatch_q *dsq, struct rq *task_rq) { return false; }
 #endif	/* CONFIG_SMP */
 
+/**
+ * move_task_between_dsqs() - Move a task from one DSQ to another
+ * @p: target task
+ * @enq_flags: %SCX_ENQ_*
+ * @src_dsq: DSQ @p is currently on, must not be a local DSQ
+ * @dst_dsq: DSQ @p is being moved to, can be any DSQ
+ *
+ * Must be called with @p's task_rq and @src_dsq locked. If @dst_dsq is a local
+ * DSQ and @p is on a different CPU, @p will be migrated and thus its task_rq
+ * will change. As @p's task_rq is locked, this function doesn't need to use the
+ * holding_cpu mechanism.
+ *
+ * On return, @src_dsq is unlocked and only @p's new task_rq, which is the
+ * return value, is locked.
+ */
+static struct rq *move_task_between_dsqs(struct task_struct *p, u64 enq_flags,
+					 struct scx_dispatch_q *src_dsq,
+					 struct scx_dispatch_q *dst_dsq)
+{
+	struct rq *src_rq = task_rq(p), *dst_rq;
+
+	BUG_ON(src_dsq->id == SCX_DSQ_LOCAL);
+	lockdep_assert_held(&src_dsq->lock);
+	lockdep_assert_rq_held(src_rq);
+
+	if (dst_dsq->id == SCX_DSQ_LOCAL) {
+		dst_rq = container_of(dst_dsq, struct rq, scx.local_dsq);
+		if (!task_can_run_on_remote_rq(p, dst_rq, true)) {
+			dst_dsq = find_global_dsq(p);
+			dst_rq = src_rq;
+		}
+	} else {
+		/* no need to migrate if destination is a non-local DSQ */
+		dst_rq = src_rq;
+	}
+
+	/*
+	 * Move @p into $dst_dsq. If $dst_dsq is the local DSQ of a different
+	 * CPU, @p will be migrated.
+	 */
+	if (dst_dsq->id == SCX_DSQ_LOCAL) {
+		/* @p is going from a non-local DSQ to a local DSQ */
+		if (src_rq == dst_rq) {
+			task_unlink_from_dsq(p, src_dsq);
+			move_local_task_to_local_dsq(p, enq_flags,
+						     src_dsq, dst_rq);
+			raw_spin_unlock(&src_dsq->lock);
+		} else {
+			raw_spin_unlock(&src_dsq->lock);
+			move_remote_task_to_local_dsq(p, enq_flags,
+						      src_rq, dst_rq);
+		}
+	} else {
+		/*
+		 * @p is going from a non-local DSQ to a non-local DSQ. As
+		 * $src_dsq is already locked, do an abbreviated dequeue.
+		 */
+		task_unlink_from_dsq(p, src_dsq);
+		p->scx.dsq = NULL;
+		raw_spin_unlock(&src_dsq->lock);
+
+		dispatch_enqueue(dst_dsq, p, enq_flags);
+	}
+
+	return dst_rq;
+}
+
 static bool consume_dispatch_q(struct rq *rq, struct scx_dispatch_q *dsq)
 {
 	struct task_struct *p;
@@ -6134,7 +6201,7 @@ static bool scx_dispatch_from_dsq(struct bpf_iter_scx_dsq_kern *kit,
 				  u64 enq_flags)
 {
 	struct scx_dispatch_q *src_dsq = kit->dsq, *dst_dsq;
-	struct rq *this_rq, *src_rq, *dst_rq, *locked_rq;
+	struct rq *this_rq, *src_rq, *locked_rq;
 	bool dispatched = false;
 	bool in_balance;
 	unsigned long flags;
@@ -6180,51 +6247,18 @@ static bool scx_dispatch_from_dsq(struct bpf_iter_scx_dsq_kern *kit,
 	/* @p is still on $src_dsq and stable, determine the destination */
 	dst_dsq = find_dsq_for_dispatch(this_rq, dsq_id, p);
 
-	if (dst_dsq->id == SCX_DSQ_LOCAL) {
-		dst_rq = container_of(dst_dsq, struct rq, scx.local_dsq);
-		if (!task_can_run_on_remote_rq(p, dst_rq, true)) {
-			dst_dsq = find_global_dsq(p);
-			dst_rq = src_rq;
-		}
-	} else {
-		/* no need to migrate if destination is a non-local DSQ */
-		dst_rq = src_rq;
-	}
-
 	/*
-	 * Move @p into $dst_dsq. If $dst_dsq is the local DSQ of a different
-	 * CPU, @p will be migrated.
+	 * Apply vtime and slice updates before moving so that the new time is
+	 * visible before inserting into $dst_dsq. @p is still on $src_dsq but
+	 * this is safe as we're locking it.
 	 */
-	if (dst_dsq->id == SCX_DSQ_LOCAL) {
-		/* @p is going from a non-local DSQ to a local DSQ */
-		if (src_rq == dst_rq) {
-			task_unlink_from_dsq(p, src_dsq);
-			move_local_task_to_local_dsq(p, enq_flags,
-						     src_dsq, dst_rq);
-			raw_spin_unlock(&src_dsq->lock);
-		} else {
-			raw_spin_unlock(&src_dsq->lock);
-			move_remote_task_to_local_dsq(p, enq_flags,
-						      src_rq, dst_rq);
-			locked_rq = dst_rq;
-		}
-	} else {
-		/*
-		 * @p is going from a non-local DSQ to a non-local DSQ. As
-		 * $src_dsq is already locked, do an abbreviated dequeue.
-		 */
-		task_unlink_from_dsq(p, src_dsq);
-		p->scx.dsq = NULL;
-		raw_spin_unlock(&src_dsq->lock);
-
-		if (kit->cursor.flags & __SCX_DSQ_ITER_HAS_VTIME)
-			p->scx.dsq_vtime = kit->vtime;
-		dispatch_enqueue(dst_dsq, p, enq_flags);
-	}
-
+	if (kit->cursor.flags & __SCX_DSQ_ITER_HAS_VTIME)
+		p->scx.dsq_vtime = kit->vtime;
 	if (kit->cursor.flags & __SCX_DSQ_ITER_HAS_SLICE)
 		p->scx.slice = kit->slice;
 
+	/* execute move */
+	locked_rq = move_task_between_dsqs(p, enq_flags, src_dsq, dst_dsq);
 	dispatched = true;
 out:
 	if (in_balance) {
-- 
2.39.5



