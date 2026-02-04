Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56ECB421EE3;
	Wed,  4 Feb 2026 15:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218539; cv=none; b=HUgBmHo415VL2hUBa7NIwk2i+2vIFOD2bdIbu59tO9UwJefd2iaEDeyRin+fDX8Q3t0z+jyzxtlQ1NapFhuMLdFXul1HnkEwzWHcT5ZxdBK8s1Fu4LPzJfqXJJFeonKqDy+lAhpCM+4Dr85u3t8mLZKsHUI54PT7UgnNj6BabxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218539; c=relaxed/simple;
	bh=zpNb8GM7KOxYLQcL8ZBW3R+fPavljUizfqlrgdyXCA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpOU9xL5Xdx0CkBsllsKLH3UEBJ0shKI04l72YD/42dvLEJCSStryd8WJPDHiulem1JwmttZ35WMVcbADo41SWT8ftI9qAVQioLhzStrHqkNW/hhgG7Cb8aOt1/sTXXWEZ3tA63Rz2DqnKx5RoTTtWABOuVmkBywCa8pK90v8LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XcsX+o3F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XcsX+o3F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD61FC19423;
	Wed,  4 Feb 2026 15:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218539;
	bh=zpNb8GM7KOxYLQcL8ZBW3R+fPavljUizfqlrgdyXCA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XcsX+o3Fv34CskTeTTh+WRSSjh1eYdbsuo2mXrD9FrnUdHth353JwhJgNBU4LBE9b
	 PKrO2KnTBR0J50FDFY9DaKzDtHTL/MOdeGtH2QtPz1zlP0yPwp+e5EK4NALxREzPIq
	 DhEodmZAr5L2lM7mleJdDcl6XdiC6eKstJjP+utM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 60/72] perf: sched: Fix perf crash with new is_user_task() helper
Date: Wed,  4 Feb 2026 15:41:03 +0100
Message-ID: <20260204143847.810154630@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 76ed27608f7dd235b727ebbb12163438c2fbb617 ]

In order to do a user space stacktrace the current task needs to be a user
task that has executed in user space. It use to be possible to test if a
task is a user task or not by simply checking the task_struct mm field. If
it was non NULL, it was a user task and if not it was a kernel task.

But things have changed over time, and some kernel tasks now have their
own mm field.

An idea was made to instead test PF_KTHREAD and two functions were used to
wrap this check in case it became more complex to test if a task was a
user task or not[1]. But this was rejected and the C code simply checked
the PF_KTHREAD directly.

It was later found that not all kernel threads set PF_KTHREAD. The io-uring
helpers instead set PF_USER_WORKER and this needed to be added as well.

But checking the flags is still not enough. There's a very small window
when a task exits that it frees its mm field and it is set back to NULL.
If perf were to trigger at this moment, the flags test would say its a
user space task but when perf would read the mm field it would crash with
at NULL pointer dereference.

Now there are flags that can be used to test if a task is exiting, but
they are set in areas that perf may still want to profile the user space
task (to see where it exited). The only real test is to check both the
flags and the mm field.

Instead of making this modification in every location, create a new
is_user_task() helper function that does all the tests needed to know if
it is safe to read the user space memory or not.

[1] https://lore.kernel.org/all/20250425204120.639530125@goodmis.org/

Fixes: 90942f9fac05 ("perf: Use current->flags & PF_KTHREAD|PF_USER_WORKER instead of current->mm == NULL")
Closes: https://lore.kernel.org/all/0d877e6f-41a7-4724-875d-0b0a27b8a545@roeck-us.net/
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260129102821.46484722@gandalf.local.home
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sched.h     |    5 +++++
 kernel/events/callchain.c |    2 +-
 kernel/events/core.c      |    6 +++---
 3 files changed, 9 insertions(+), 4 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1800,6 +1800,11 @@ static __always_inline bool is_percpu_th
 #endif
 }
 
+static __always_inline bool is_user_task(struct task_struct *task)
+{
+	return task->mm && !(task->flags & (PF_KTHREAD | PF_USER_WORKER));
+}
+
 /* Per-process atomic flags. */
 #define PFA_NO_NEW_PRIVS		0	/* May not gain new privileges. */
 #define PFA_SPREAD_PAGE			1	/* Spread page cache over cpuset */
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -206,7 +206,7 @@ get_perf_callchain(struct pt_regs *regs,
 
 	if (user && !crosstask) {
 		if (!user_mode(regs)) {
-			if (current->flags & (PF_KTHREAD | PF_USER_WORKER))
+			if (!is_user_task(current))
 				regs = NULL;
 			else
 				regs = task_pt_regs(current);
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6985,7 +6985,7 @@ static void perf_sample_regs_user(struct
 	if (user_mode(regs)) {
 		regs_user->abi = perf_reg_abi(current);
 		regs_user->regs = regs;
-	} else if (!(current->flags & (PF_KTHREAD | PF_USER_WORKER))) {
+	} else if (is_user_task(current)) {
 		perf_get_regs_user(regs_user, regs);
 	} else {
 		regs_user->abi = PERF_SAMPLE_REGS_ABI_NONE;
@@ -7612,7 +7612,7 @@ static u64 perf_virt_to_phys(u64 virt)
 		 * Try IRQ-safe get_user_page_fast_only first.
 		 * If failed, leave phys_addr as 0.
 		 */
-		if (!(current->flags & (PF_KTHREAD | PF_USER_WORKER))) {
+		if (is_user_task(current)) {
 			struct page *p;
 
 			pagefault_disable();
@@ -7725,7 +7725,7 @@ perf_callchain(struct perf_event *event,
 {
 	bool kernel = !event->attr.exclude_callchain_kernel;
 	bool user   = !event->attr.exclude_callchain_user &&
-		!(current->flags & (PF_KTHREAD | PF_USER_WORKER));
+		is_user_task(current);
 	/* Disallow cross-task user callchains. */
 	bool crosstask = event->ctx->task && event->ctx->task != current;
 	const u32 max_stack = event->attr.sample_max_stack;


