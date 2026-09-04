Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304064195A3;
	Fri,  4 Sep 2026 05:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499430; cv=none; b=g4QFQoG0iUSuk9hju7neJZxmCzFnNga0pcGFHAlL/bqFzxL0Cv/grzlFwSRsUWT883RofmGN7uSHcdKcHC1zKy+xpWoI3GZ7hsw2pXAyoFsnUue8GuEftqU4UgF9LN5uy4vv3U9w8fLMTkIdlAbGOT8lmg/Wl4FSqN0RwbBCZtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499430; c=relaxed/simple;
	bh=jpmZ8/By24jzAP8Wnvy6hGFcRHnEqKdVAdw+GO6xY8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mzD4zhDKKaoJZfDpkJXGdy694Z1u47zqn55ccch25cM43uys3OCR4KxdE7tQT7xE+m8G+va/2Oqk5oKqHyP+e2YJ0Sx1vqKL8aJp4pOMG9ZiMj85nV1ed4w5B+H6Oszxe6BsYHpAnu6sq1DeJynTZM7y2hoxAQIwGAtSInlwQ7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xruMKRuV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xruMKRuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A9C1F00A3E;
	Fri,  4 Sep 2026 05:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499429;
	bh=JWNGDU5dRVAsbF3wsH1HZVgPNg+k3V909R4J79mJPy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xruMKRuV8dIJ8C6oJnP2Tq+0pvOdnurd2V4xZWNBkJ5OYmScmMpakcGGT+TcYXxPg
	 4gsonK2oLDWJjmH4C1y4Z3XKvvOUpOgdVS1jJqNQ+9LbVWjAqdFHTqjhGKy0BAehcs
	 lfhaPZ2a1qIQO8NQ1WYiMSmI9HPsZR3A6F0oGDig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 7.2 415/713] sched_ext: Fix inverted ops.core_sched_before() invocation
Date: Fri,  4 Sep 2026 06:56:23 +0200
Message-ID: <20260904045813.132871005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Tejun Heo <tj@kernel.org>

commit f7b6d128dd49a6eec09066ecfd29095f12588786 upstream.

scx_prio_less() implements prio_less() semantics - %true means that @a is
the lower priority and should run after @b. ops.core_sched_before() is
documented to return %true when @a should run before @b. scx_prio_less()
returns the op's value as-is, inverting the documented semantics at runtime.

Call the op with the arguments swapped.

scx_qmap followed the wiring instead of the documentation and returned %true
for the younger task, so the two inversions canceled out and it behaved as
intended. Flip its comparison to match. scx_qmap is likely the only current
user in or out of the kernel tree. Any scheduler written the same way needs
the same flip, while schedulers following the documentation are fixed by
this change.

Fixes: 7b0888b7cc19 ("sched_ext: Implement core-sched support")
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext/ext.c         |   10 ++++++++--
 tools/sched_ext/scx_qmap.bpf.c |    2 +-
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -3416,6 +3416,8 @@ void ext_server_init(struct rq *rq)
  *
  * When ops.core_sched_before() is enabled, @p->scx.core_sched_at is used to
  * implement FIFO ordering within each local DSQ. See pick_task_scx().
+ *
+ * Return: %true if @a should run after @b.
  */
 bool scx_prio_less(const struct task_struct *a, const struct task_struct *b,
 		   bool in_fi)
@@ -3424,6 +3426,10 @@ bool scx_prio_less(const struct task_str
 	struct scx_sched *sch_b = scx_task_sched(b);
 
 	/*
+	 * scx_prio_less() returns whether @a should run after @b while
+	 * ops.core_sched_before() returns whether its first argument should run
+	 * before the second. Swap the arguments.
+	 *
 	 * The const qualifiers are dropped from task_struct pointers when
 	 * calling ops.core_sched_before(). Accesses are controlled by the
 	 * verifier.
@@ -3432,8 +3438,8 @@ bool scx_prio_less(const struct task_str
 	    !scx_bypassing(sch_a, task_cpu(a)))
 		return SCX_CALL_OP_2TASKS_RET(sch_a, core_sched_before,
 					      task_rq(a),
-					      (struct task_struct *)a,
-					      (struct task_struct *)b);
+					      (struct task_struct *)b,
+					      (struct task_struct *)a);
 	else
 		return time_after64(a->scx.core_sched_at, b->scx.core_sched_at);
 }
--- a/tools/sched_ext/scx_qmap.bpf.c
+++ b/tools/sched_ext/scx_qmap.bpf.c
@@ -749,7 +749,7 @@ static s64 task_qdist(struct task_struct
 bool BPF_STRUCT_OPS(qmap_core_sched_before,
 		    struct task_struct *a, struct task_struct *b)
 {
-	return task_qdist(a) > task_qdist(b);
+	return task_qdist(a) < task_qdist(b);
 }
 
 /*


