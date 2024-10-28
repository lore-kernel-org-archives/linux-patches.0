Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944BC18E74D;
	Mon, 28 Oct 2024 06:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097989; cv=none; b=rzQ8JXP5vAuw6uWr9s/j/kzcvHJV0rMph9IXHR12AB5PhKY8hvNDtAf6Lse829NMnrW1K+AZKO0EmDU/Z7RhYHLooUZ4cTUNV8jHV7896Su6QWbRru885ZaFDhsrmnKTtb3SwLGuu/JxooyPqMywrgv53odJ5vtezJHxYhbURwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097989; c=relaxed/simple;
	bh=kiilmmUKSEpDzZPXGCQEAVZ26cuXU5KTPLzoxFNWuKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcB/yT27F4rDytDQZdOV/IxZjh+yGjRg9gNT7U4eEpbAMBnvKMZWJwmB7Qa6NIrRSpSJJO5OyAeHPmuftNqRn8jBB4wK6y0a308tto48eSh7bNBN9JUqSxO4c+TIq3MNAoKYaY40VwPO6IHGCbB//wJN7NMBxKLNej6fsk+pihY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGaQvK7Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGaQvK7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377CCC4CEC3;
	Mon, 28 Oct 2024 06:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097989;
	bh=kiilmmUKSEpDzZPXGCQEAVZ26cuXU5KTPLzoxFNWuKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NGaQvK7YfrWKimVne3Y0pU+dQQqiQFQ2+/BsV6XXlpqDiTSm9Uu7CsM6+qclhqj7v
	 OKR52i5nsC/nozCitASx/6YHJOCQ0GuZRQzsEoHCGQnqChvjl1lbpQjfYnQUiYpMhx
	 hrRFs+5nKKwUPkvGiB7NV9t1nT1klrK7lAdN6PwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 029/261] sched/core: Disable page allocation in task_tick_mm_cid()
Date: Mon, 28 Oct 2024 07:22:51 +0100
Message-ID: <20241028062312.746121343@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 73ab05aa46b02d96509cb029a8d04fca7bbde8c7 ]

With KASAN and PREEMPT_RT enabled, calling task_work_add() in
task_tick_mm_cid() may cause the following splat.

[   63.696416] BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
[   63.696416] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 610, name: modprobe
[   63.696416] preempt_count: 10001, expected: 0
[   63.696416] RCU nest depth: 1, expected: 1

This problem is caused by the following call trace.

  sched_tick() [ acquire rq->__lock ]
   -> task_tick_mm_cid()
    -> task_work_add()
     -> __kasan_record_aux_stack()
      -> kasan_save_stack()
       -> stack_depot_save_flags()
        -> alloc_pages_mpol_noprof()
         -> __alloc_pages_noprof()
	  -> get_page_from_freelist()
	   -> rmqueue()
	    -> rmqueue_pcplist()
	     -> __rmqueue_pcplist()
	      -> rmqueue_bulk()
	       -> rt_spin_lock()

The rq lock is a raw_spinlock_t. We can't sleep while holding
it. IOW, we can't call alloc_pages() in stack_depot_save_flags().

The task_tick_mm_cid() function with its task_work_add() call was
introduced by commit 223baf9d17f2 ("sched: Fix performance regression
introduced by mm_cid") in v6.4 kernel.

Fortunately, there is a kasan_record_aux_stack_noalloc() variant that
calls stack_depot_save_flags() while not allowing it to allocate
new pages.  To allow task_tick_mm_cid() to use task_work without
page allocation, a new TWAF_NO_ALLOC flag is added to enable calling
kasan_record_aux_stack_noalloc() instead of kasan_record_aux_stack()
if set. The task_tick_mm_cid() function is modified to add this new flag.

The possible downside is the missing stack trace in a KASAN report due
to new page allocation required when task_work_add_noallloc() is called
which should be rare.

Fixes: 223baf9d17f2 ("sched: Fix performance regression introduced by mm_cid")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20241010014432.194742-1-longman@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/task_work.h |  5 ++++-
 kernel/sched/core.c       |  4 +++-
 kernel/task_work.c        | 15 +++++++++++++--
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/include/linux/task_work.h b/include/linux/task_work.h
index cf5e7e891a776..2964171856e00 100644
--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -14,11 +14,14 @@ init_task_work(struct callback_head *twork, task_work_func_t func)
 }
 
 enum task_work_notify_mode {
-	TWA_NONE,
+	TWA_NONE = 0,
 	TWA_RESUME,
 	TWA_SIGNAL,
 	TWA_SIGNAL_NO_IPI,
 	TWA_NMI_CURRENT,
+
+	TWA_FLAGS = 0xff00,
+	TWAF_NO_ALLOC = 0x0100,
 };
 
 static inline bool task_work_pending(struct task_struct *task)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1af59cf714cd3..3713341c2e720 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -10262,7 +10262,9 @@ void task_tick_mm_cid(struct rq *rq, struct task_struct *curr)
 		return;
 	if (time_before(now, READ_ONCE(curr->mm->mm_cid_next_scan)))
 		return;
-	task_work_add(curr, work, TWA_RESUME);
+
+	/* No page allocation under rq lock */
+	task_work_add(curr, work, TWA_RESUME | TWAF_NO_ALLOC);
 }
 
 void sched_mm_cid_exit_signals(struct task_struct *t)
diff --git a/kernel/task_work.c b/kernel/task_work.c
index 5d14d639ac71b..c969f1f26be58 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -55,15 +55,26 @@ int task_work_add(struct task_struct *task, struct callback_head *work,
 		  enum task_work_notify_mode notify)
 {
 	struct callback_head *head;
+	int flags = notify & TWA_FLAGS;
 
+	notify &= ~TWA_FLAGS;
 	if (notify == TWA_NMI_CURRENT) {
 		if (WARN_ON_ONCE(task != current))
 			return -EINVAL;
 		if (!IS_ENABLED(CONFIG_IRQ_WORK))
 			return -EINVAL;
 	} else {
-		/* record the work call stack in order to print it in KASAN reports */
-		kasan_record_aux_stack(work);
+		/*
+		 * Record the work call stack in order to print it in KASAN
+		 * reports.
+		 *
+		 * Note that stack allocation can fail if TWAF_NO_ALLOC flag
+		 * is set and new page is needed to expand the stack buffer.
+		 */
+		if (flags & TWAF_NO_ALLOC)
+			kasan_record_aux_stack_noalloc(work);
+		else
+			kasan_record_aux_stack(work);
 	}
 
 	head = READ_ONCE(task->task_works);
-- 
2.43.0



