Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75117222581;
	Mon, 23 Jun 2025 22:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717688; cv=none; b=Q1ITWOM05ryBMUFPm3J812K5wOYEkrKGjYa7094mmSjhi0cfrkRdszW/eFLMbs9eJmsnes+l1Tn/pciTECiU7lOWhrbIbraQtJ7OrvX77RXQTnA+Ed3gEtjjxnvu+Nu9w2TwajMiduxQnFUGtTFPKupL/Fo5fSYUO5n4nG+/amc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717688; c=relaxed/simple;
	bh=HJz0v9++paOruyBaCIh7GIqksMoDO4OWDoLXrdR5kDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMXOAB6bSHzSgTj0O8FAKspOakVR6c0zWzdls+7sqvA/WdUJXAlNk3hYGF6/hDoJ+9lRC+o2iP7BvyjBZ0ESh/TNmPNCT+xPsWQKp9V8b+Og2Ctxv27E+uPWA6sfMyb5O1+QJ4zykKBDMC8olLBU6g1lcwoAytBYkpW/DNxT9Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pSQgntyU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pSQgntyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D033C4CEEA;
	Mon, 23 Jun 2025 22:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717688;
	bh=HJz0v9++paOruyBaCIh7GIqksMoDO4OWDoLXrdR5kDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pSQgntyUF8LDqWFardv9QXtk7Fjl2Uxr/B8r+UDYS0zh9fdsDtwG4GcPuZZskyYRF
	 CVk1DPUglT46muOeGmZdzBr9tJQs5pwmeJd1c0p2QEiKMQqotmLGAXhTMz8hrY4prH
	 UQBWn8psF+TbHf48/aNuwq1h6I+OscGPs4SkcqXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baisheng Gao <baisheng.gao@unisoc.com>,
	Mark Rutland <mark.rutland@arm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 504/508] perf: Fix sample vs do_exit()
Date: Mon, 23 Jun 2025 15:09:09 +0200
Message-ID: <20250623130657.402867158@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 25df8971a56ed..2761db0365ddc 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6800,6 +6800,10 @@ perf_sample_ustack_size(u16 stack_size, u16 header_size,
 	if (!regs)
 		return 0;
 
+	/* No mm, no stack, no dump. */
+	if (!current->mm)
+		return 0;
+
 	/*
 	 * Check if we fit in with the requested stack size into the:
 	 * - TASK_SIZE
@@ -7485,6 +7489,9 @@ perf_callchain(struct perf_event *event, struct pt_regs *regs)
 	const u32 max_stack = event->attr.sample_max_stack;
 	struct perf_callchain_entry *callchain;
 
+	if (!current->mm)
+		user = false;
+
 	if (!kernel && !user)
 		return &__empty_callchain;
 
diff --git a/kernel/exit.c b/kernel/exit.c
index 156283b3c1bf6..10af26a4ab010 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -855,6 +855,15 @@ void __noreturn do_exit(long code)
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
@@ -871,14 +880,6 @@ void __noreturn do_exit(long code)
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



