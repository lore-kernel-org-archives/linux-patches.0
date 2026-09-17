Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C1A4CDDEC;
	Thu, 17 Sep 2026 15:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658756; cv=none; b=vExmx3fUhnDXIEVmDvZB3shVjDWd6fT59UB9QkXB0+P+kGgpkOfLU46AtZiGVdgpDGyGYL+idgyNQAZeXtWuSy90MdFXc3FWtpvh5jrJAeUkAtVUlh1/378s2dLRKtGNcfw6ZJaQdmA+r/fSJzko/ZTQAslH+gnxfQXoP9ZjgVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658756; c=relaxed/simple;
	bh=eP30ImTaT/S30Xq45FPn38f+I7YeKRtuSHPEss3iFrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPZqqv1dhPwEph3ktG1FJaaTN/CLlMSOIu+XcFcuD/KPMLyo23lI4SQlohyyV1+k4eWG1aiSA5aiUgZu/ZAkrvZ8wOATJf7A6V7/TGbjPdTLqemyqsANwIfwS8NN8QqZDAp22SMUOgnH7mUaLNOPftJmbYfeFz5D5OvBg8GKjxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJWbrEa1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJWbrEa1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB3A81F00899;
	Thu, 17 Sep 2026 15:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658749;
	bh=NBpho3uncKrkiaz2BbrDQ+ZSZa1mBR9cZBkK++Q0NyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sJWbrEa1o/wKF3MibSwP3zhkuuAH/H8JXEBtJLMwtcbY3ygGhUwHES6Lx8bMWXBX1
	 bWrpipGysbcRrweoLgjScxD2yl21dnDC0xPWZS6yiXY8IC/kTY0JkOe/Zga2P29pVh
	 myi3S9j1RQrtKXQuN+SQF5c/OePp8P4zEN3jLMjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 026/733] sched_ext: Fix spurious aborts in scx_bpf_dsq_move() on ownership change races
Date: Thu, 17 Sep 2026 16:05:34 +0100
Message-ID: <20260917151351.361753441@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

[ Upstream commit cca061dccf563907061766191b2ce3f66b7c285a ]

scx_dsq_move() verifies that the task belongs to the calling scheduler
before taking any locks and aborts the scheduler on mismatch. The task can
lose the sched association at any point: It can run and fully exit, which
clears the association, or get rehomed to a different sub-sched. Both are
benign races, but the early ownership check escalates them into scheduler
aborts.

Move the ownership check below the cursor-lost check. Every ownership change
dequeues the task first, so a task that is still on the iterated DSQ under
the lock while owned elsewhere indicates a genuine violation and should
abort.

Also fix two stale comments still referencing sched_ext_free(), which has
been renamed to sched_ext_dead().

Fixes: bb4d9fd55158 ("sched_ext: scx_dsq_move() should validate the task belongs to the right scheduler")
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/ext.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index 558be0cdebef8..548f46a427883 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -7435,7 +7435,7 @@ static void scx_root_enable_workfn(struct kthread_work *work)
 	/*
 	 * Enable ops for every task. Fork is excluded by scx_fork_rwsem
 	 * preventing new tasks from being added. No need to exclude tasks
-	 * leaving as sched_ext_free() can handle both prepped and enabled
+	 * leaving as sched_ext_dead() can handle both prepped and enabled
 	 * tasks. Prep all tasks first and then enable them with preemption
 	 * disabled.
 	 *
@@ -7524,7 +7524,7 @@ static void scx_root_enable_workfn(struct kthread_work *work)
 
 	/*
 	 * We're fully committed and can't fail. The task READY -> ENABLED
-	 * transitions here are synchronized against sched_ext_free() through
+	 * transitions here are synchronized against sched_ext_dead() through
 	 * scx_tasks_lock.
 	 */
 	percpu_down_write(&scx_fork_rwsem);
@@ -9019,12 +9019,6 @@ static bool scx_dsq_move(struct bpf_iter_scx_dsq_kern *kit,
 	if (unlikely(READ_ONCE(sch->aborting)))
 		return false;
 
-	if (unlikely(!scx_task_on_sched(sch, p))) {
-		scx_error(sch, "scx_bpf_dsq_move[_vtime]() on %s[%d] but the task belongs to a different scheduler",
-			  p->comm, p->pid);
-		return false;
-	}
-
 	/*
 	 * Can be called from either ops.dispatch() holding the dispatched rq's
 	 * lock or any context where no rq lock is held. If latter, lock @p's
@@ -9056,6 +9050,17 @@ static bool scx_dsq_move(struct bpf_iter_scx_dsq_kern *kit,
 		goto out;
 	}
 
+	/*
+	 * @p has been on $src_dsq and can't move anymore. If @p is not on @sch,
+	 * the caller didn't have authority over @p at the time of the call.
+	 */
+	if (unlikely(!scx_task_on_sched(sch, p))) {
+		scx_error(sch, "scx_bpf_dsq_move[_vtime]() on %s[%d] but the task belongs to a different scheduler",
+			  p->comm, p->pid);
+		raw_spin_unlock(&src_dsq->lock);
+		goto out;
+	}
+
 	/* @p is still on $src_dsq and stable, determine the destination */
 	dst_dsq = find_dsq_for_dispatch(sch, locked_rq ?: this_rq(), dsq_id, task_cpu(p));
 
-- 
2.53.0



