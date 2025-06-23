Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10352192EC;
	Mon, 23 Jun 2025 22:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717507; cv=none; b=Ka/ewfDmRppzOlgM7k3F83rXBrmdzcjWa6s1YMO+wjWW7GnywFTHJW3yHaabV9iEDi/33O7xxau1CbA9xHeb0AlthDp3uFE8uwEk/ANte0S3sCVwG+8quE3BsCfgw91PZL3qeeXcrSw7t37kvq/xg+jA1D+uTCOaTINPcYg5/eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717507; c=relaxed/simple;
	bh=trchWf5yb7xeXi1FMsV8k0opzSOVlFP63+7o20dmV/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QpUumeMMqHHrYIaSV2MY1DRgccujiMrSlePftAaf7Md5pU/wvTzr8bff8E3kWfN85GkDH0VsQpqGNYQBsP4oFzUwEyEDy1VctOvTlblcLyZJ0FRj7Ixa4pqSxvxbnfbIbtf+IdIoiLeATbOmuehDB4IwxbPbvPq1sEYTIsa4XkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AtgRKPn7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AtgRKPn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BEA8C4CEEA;
	Mon, 23 Jun 2025 22:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717506;
	bh=trchWf5yb7xeXi1FMsV8k0opzSOVlFP63+7o20dmV/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AtgRKPn71+RL4ts/20LNRtXcSNnhF940xiWmXljobRevLGeUnffhL2HMvMvsTsiSO
	 bMjHtOjoELR93b7tUYtsXZy5lRV1540riSQB4nwmXCNsR8OhLmlkWDm3qn+UttdmwQ
	 fYSJ2GMjKrexBk9nj6KIb5YVfxzixm4PZXW3aaQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baisheng Gao <baisheng.gao@unisoc.com>,
	Mark Rutland <mark.rutland@arm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 403/414] perf: Fix sample vs do_exit()
Date: Mon, 23 Jun 2025 15:09:00 +0200
Message-ID: <20250623130652.015423381@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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
index 9ce82904f761d..ed3bc2e390511 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7097,6 +7097,10 @@ perf_sample_ustack_size(u16 stack_size, u16 header_size,
 	if (!regs)
 		return 0;
 
+	/* No mm, no stack, no dump. */
+	if (!current->mm)
+		return 0;
+
 	/*
 	 * Check if we fit in with the requested stack size into the:
 	 * - TASK_SIZE
@@ -7808,6 +7812,9 @@ perf_callchain(struct perf_event *event, struct pt_regs *regs)
 	const u32 max_stack = event->attr.sample_max_stack;
 	struct perf_callchain_entry *callchain;
 
+	if (!current->mm)
+		user = false;
+
 	if (!kernel && !user)
 		return &__empty_callchain;
 
diff --git a/kernel/exit.c b/kernel/exit.c
index 56b8bd9487b4b..d465b36bcc869 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -923,6 +923,15 @@ void __noreturn do_exit(long code)
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
@@ -939,14 +948,6 @@ void __noreturn do_exit(long code)
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



