Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5892D5C91;
	Wed,  4 Feb 2026 15:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219202; cv=none; b=JeWEmF6DJgca7w2jof1lTFQ7glnWFKVGytUpoVZFrBkQlG+uauqHRqVDiY16Q0I/bHv6nJvA2xWrG0jAhSgpZwg4oNM2ysSZktJZ/SsT3lh+P1VsYXN2bbeHTvWouczmMYUMYTqnNdbEQzohM04gCOBhChLI40Fwhx+nll7l4KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219202; c=relaxed/simple;
	bh=u36yxXC+6N6eWr2jPSBR5kQWJuz4Av6a0cZ99zwuhlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SMUoduJZPNGhjwAsFzB9zn43iXsTlZNT2MzKYbBOZ3VcG5XhWXJQ4A3geDhE/m9MEYARod/5KTR/n/Lff5f2hc2jmnox8+aiHGEQPSs3oTvdaQA0J1mcrrfGjSXAwu4AbIsFMVnF2OcaU0pKn0gzhx65ZgaEzI6RwnfjnZYnnXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PjA1p2Mj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PjA1p2Mj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D85C4CEF7;
	Wed,  4 Feb 2026 15:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219202;
	bh=u36yxXC+6N6eWr2jPSBR5kQWJuz4Av6a0cZ99zwuhlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PjA1p2MjOjLPmLnlPOqlKa5EYfClHtB3n10t1HzCXpf3U1JKvKLIdZrIGsIKjlNCS
	 rScTfaefWZcu3W/ioFvpZX0A7kuYW+0YhGcNgC4UquUUbkGZkGPuXnT0JYDQk5rzNM
	 xsP8gsPXmVYMmW4f160zLNjauUqbU6uhI9hijY1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.18 063/122] perf: sched: Fix perf crash with new is_user_task() helper
Date: Wed,  4 Feb 2026 15:40:45 +0100
Message-ID: <20260204143854.122867500@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 76ed27608f7dd235b727ebbb12163438c2fbb617 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sched.h     |    5 +++++
 kernel/events/callchain.c |    2 +-
 kernel/events/core.c      |    6 +++---
 3 files changed, 9 insertions(+), 4 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1798,6 +1798,11 @@ static __always_inline bool is_percpu_th
 		(current->nr_cpus_allowed  == 1);
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
@@ -246,7 +246,7 @@ get_perf_callchain(struct pt_regs *regs,
 
 	if (user && !crosstask) {
 		if (!user_mode(regs)) {
-			if (current->flags & (PF_KTHREAD | PF_USER_WORKER))
+			if (!is_user_task(current))
 				goto exit_put;
 			regs = task_pt_regs(current);
 		}
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7459,7 +7459,7 @@ static void perf_sample_regs_user(struct
 	if (user_mode(regs)) {
 		regs_user->abi = perf_reg_abi(current);
 		regs_user->regs = regs;
-	} else if (!(current->flags & (PF_KTHREAD | PF_USER_WORKER))) {
+	} else if (is_user_task(current)) {
 		perf_get_regs_user(regs_user, regs);
 	} else {
 		regs_user->abi = PERF_SAMPLE_REGS_ABI_NONE;
@@ -8099,7 +8099,7 @@ static u64 perf_virt_to_phys(u64 virt)
 		 * Try IRQ-safe get_user_page_fast_only first.
 		 * If failed, leave phys_addr as 0.
 		 */
-		if (!(current->flags & (PF_KTHREAD | PF_USER_WORKER))) {
+		if (is_user_task(current)) {
 			struct page *p;
 
 			pagefault_disable();
@@ -8212,7 +8212,7 @@ perf_callchain(struct perf_event *event,
 {
 	bool kernel = !event->attr.exclude_callchain_kernel;
 	bool user   = !event->attr.exclude_callchain_user &&
-		!(current->flags & (PF_KTHREAD | PF_USER_WORKER));
+		is_user_task(current);
 	/* Disallow cross-task user callchains. */
 	bool crosstask = event->ctx->task && event->ctx->task != current;
 	const u32 max_stack = event->attr.sample_max_stack;


