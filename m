Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93B3B676;
	Mon, 23 Jun 2025 22:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716948; cv=none; b=h9UqNtDw4vJtZalnbG9hTezGklp0NkSdIV4m/pzM+zHH6E/KxFGgtU39IkCikGyjTnqHXd1cscEnYrQpYaW8L4YYjVf/AVm8cfZOX9H91XVq0kANBF3Hd2c8Bb8WB2Gy778AjH/yvGHfUV3XC+g4bqJnChpbmKcDGNVdfIWxj98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716948; c=relaxed/simple;
	bh=68TG0JlPYAzZQ9ZaIFw6vnIvNKgsqqm6zFOwlq0L+W0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnfpl2AlmAS71pq+ej5RhbZirkV5Ej8inAZvx3s5mfe9gbna1rdor5dU7LtcRDgM2CYLPywQGNf2Xh1dC9BcSiu9lGxK2MU2W7METpOyuxgLFIxCxvZitjyvieCSF/U7+acVBHTjo46D2SY+PShV2Ge0O8idM14iSYr1Us6Z7KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5dIvLDp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5dIvLDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A48C4CEEA;
	Mon, 23 Jun 2025 22:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716947;
	bh=68TG0JlPYAzZQ9ZaIFw6vnIvNKgsqqm6zFOwlq0L+W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D5dIvLDpniqUONPtcHT5yeXwzvFs+9gxC60/q/bWD9mo7wdKDjs6x3mNvn6EnBiVh
	 S3FevYGhAyfex+/dXFjJtUfpr/37Mqr20mlVHs1m4IhUpNiwyhv/Ns0Seea48+Bstl
	 Nn3JuKGAH2mcJWnNt99zIWjzs4H9uUepPGTyIME0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baisheng Gao <baisheng.gao@unisoc.com>,
	Mark Rutland <mark.rutland@arm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 571/592] perf: Fix sample vs do_exit()
Date: Mon, 23 Jun 2025 15:08:49 +0200
Message-ID: <20250623130714.022935989@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 4f6fc782128355931527cefe3eb45338abd8ab39 ]

Baisheng Gao reported an ARM64 crash, which Mark decoded as being a
synchronous external abort -- most likely due to trying to access
MMIO in bad ways.

The crash further shows perf trying to do a user stack sample while in
exit_mmap()'s tlb_finish_mmu() -- i.e. while tearing down the address
space it is trying to access.

It turns out that we stop perf after we tear down the userspace mm; a
receipie for disaster, since perf likes to access userspace for
various reasons.

Flip this order by moving up where we stop perf in do_exit().

Additionally, harden PERF_SAMPLE_CALLCHAIN and PERF_SAMPLE_STACK_USER
to abort when the current task does not have an mm (exit_mm() makes
sure to set current->mm = NULL; before commencing with the actual
teardown). Such that CPU wide events don't trip on this same problem.

Fixes: c5ebcedb566e ("perf: Add ability to attach user stack dump to sample")
Reported-by: Baisheng Gao <baisheng.gao@unisoc.com>
Suggested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20250605110815.GQ39944@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c |  7 +++++++
 kernel/exit.c        | 17 +++++++++--------
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index e97bc9220fd1a..ec77f641089a2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7363,6 +7363,10 @@ perf_sample_ustack_size(u16 stack_size, u16 header_size,
 	if (!regs)
 		return 0;
 
+	/* No mm, no stack, no dump. */
+	if (!current->mm)
+		return 0;
+
 	/*
 	 * Check if we fit in with the requested stack size into the:
 	 * - TASK_SIZE
@@ -8074,6 +8078,9 @@ perf_callchain(struct perf_event *event, struct pt_regs *regs)
 	const u32 max_stack = event->attr.sample_max_stack;
 	struct perf_callchain_entry *callchain;
 
+	if (!current->mm)
+		user = false;
+
 	if (!kernel && !user)
 		return &__empty_callchain;
 
diff --git a/kernel/exit.c b/kernel/exit.c
index 1b51dc099f1e0..771dd7b226c18 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -937,6 +937,15 @@ void __noreturn do_exit(long code)
 	tsk->exit_code = code;
 	taskstats_exit(tsk, group_dead);
 
+	/*
+	 * Since sampling can touch ->mm, make sure to stop everything before we
+	 * tear it down.
+	 *
+	 * Also flushes inherited counters to the parent - before the parent
+	 * gets woken up by child-exit notifications.
+	 */
+	perf_event_exit_task(tsk);
+
 	exit_mm();
 
 	if (group_dead)
@@ -953,14 +962,6 @@ void __noreturn do_exit(long code)
 	exit_task_work(tsk);
 	exit_thread(tsk);
 
-	/*
-	 * Flush inherited counters to the parent - before the parent
-	 * gets woken up by child-exit notifications.
-	 *
-	 * because of cgroup mode, must be called before cgroup_exit()
-	 */
-	perf_event_exit_task(tsk);
-
 	sched_autogroup_exit_task(tsk);
 	cgroup_exit(tsk);
 
-- 
2.39.5



