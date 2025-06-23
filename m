Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2364F1E51FA;
	Mon, 23 Jun 2025 21:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714011; cv=none; b=GZik8uV3wrMG/ivj4B1b+eP1obj9lQbBP5eJ0jYqYiuxNuvpGXpJpHewVXCujLcDkfiWmiA44z3DvlqJTL4o0cDp9gdT83wKhtVxDZJ/zES1IZOJrB5WPDQpqN304OkGixnQdcyeBKeAPXCcBrUFODyvdPvZ6woFXw1S4BRvYls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714011; c=relaxed/simple;
	bh=ExKvlXsFYSNzImVJQwaBpTtiCVzbNJzZRMWf9OV2ylQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDUlG4KRQUsDBY7xw4MI3Wobjc6L4Qhgr+fdfWmC4QGH7mdajlIyfK4v1vXQKrsqtXZubFZaETVTvrt1qNRxeSL+LJccNeqHmP69aKYiFEA/C9TxRu2jT8d5inK+hs1fqeKEo/9oNkovgoNc/1wpBjh27P4179owjlvEN18VlQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LhOrdwlR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LhOrdwlR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16ECC4CEEA;
	Mon, 23 Jun 2025 21:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714011;
	bh=ExKvlXsFYSNzImVJQwaBpTtiCVzbNJzZRMWf9OV2ylQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LhOrdwlRF08HkUxN4Krnal8dmCJ07OGqgjbAhijlPB+FRkaVfRUqRPEeQN+ssDyOb
	 koz9q9t+wMzAXPDFOI7takaNUT0Mq5Sk7zkA2PAmFm7MxzV9dvJnGadkvrMnljJtS9
	 zbb/3YR4vHRT8jxjUN+l/oB8c/3GX8xgQUm2cljk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baisheng Gao <baisheng.gao@unisoc.com>,
	Mark Rutland <mark.rutland@arm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 221/222] perf: Fix sample vs do_exit()
Date: Mon, 23 Jun 2025 15:09:16 +0200
Message-ID: <20250623130618.944346736@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 7b97be4ed9d00..ecae7c7f895b9 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6219,6 +6219,10 @@ perf_sample_ustack_size(u16 stack_size, u16 header_size,
 	if (!regs)
 		return 0;
 
+	/* No mm, no stack, no dump. */
+	if (!current->mm)
+		return 0;
+
 	/*
 	 * Check if we fit in with the requested stack size into the:
 	 * - TASK_SIZE
@@ -6687,6 +6691,9 @@ perf_callchain(struct perf_event *event, struct pt_regs *regs)
 	const u32 max_stack = event->attr.sample_max_stack;
 	struct perf_callchain_entry *callchain;
 
+	if (!current->mm)
+		user = false;
+
 	if (!kernel && !user)
 		return &__empty_callchain;
 
diff --git a/kernel/exit.c b/kernel/exit.c
index 56d3a099825fb..8cb4a82c4ed3a 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -844,6 +844,15 @@ void __noreturn do_exit(long code)
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
@@ -861,14 +870,6 @@ void __noreturn do_exit(long code)
 	exit_thread(tsk);
 	exit_umh(tsk);
 
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



