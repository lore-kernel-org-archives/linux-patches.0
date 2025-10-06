Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E01264F9C;
	Mon,  6 Oct 2025 18:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759774758; cv=none; b=uJK/XIWIDac1oOJc5x3hddiE0CTWaZBBHNKG8ovdzS/mH6Tiv033FxelYBHR4toNZVL2aVCQwA6YImq2/Eo6CscaBCNVprRP6nyHKN7ueXRIhR5RcHla7HtB6dUjl8IIOGDGsDzzt2S5JOO5QFi57GPdNzZmBo0Q7IXP4YOSm2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759774758; c=relaxed/simple;
	bh=waRgeUS3QANh/fxuw5xZSFLxRxTMWO6r7Zp4Sj5GxFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DRkPavf3xFGYkIBeEJNdVtnSliTp/LGSXxVwJqTCRVS0wCPoU4ftX12S0ntvHWuCHTWLVX2tO3j3z0FFTRvdFyIZi8A5yA6NR+HFZl/ftPzettRnnCcfZB96ITKc3dltko5jho9DAMck3ZbUHzUgebBrZ80PSsQOfcxJmBvEnZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i9wbpKpD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i9wbpKpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90B3C4CEFE;
	Mon,  6 Oct 2025 18:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759774757;
	bh=waRgeUS3QANh/fxuw5xZSFLxRxTMWO6r7Zp4Sj5GxFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i9wbpKpD5/OuCVE8P5vlZo7maiG/dCTm+4QIe0oLkhaFRu9pTtafYrRhyr/Xi6dMK
	 8fI0E+61LTiO1o7BvxwpMlMjevteyL/KIVzvb/rXge/HhHOrFyHseAj6tVm/EZML6H
	 YMbyQkZz/By7EpwsUINpKse9WL9TAlOTlxfdceYRQ3u5FRFROyD9Bh7gKgZTGw3rF/
	 RIoVejBl1friL7J2Jxy6HY2vBeO5vOOylMeDJkDWPCFV48WggdqONPeMEt4zQV4iBs
	 OU7Y6eFWuzZA440zbljtSUe1+0Nznwib+3JkIrMuaEA4PwdeheRyGYRzPv0IUwsOmP
	 Mjis3GmlmNj4w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.6] perf: Skip user unwind if the task is a kernel thread
Date: Mon,  6 Oct 2025 14:17:45 -0400
Message-ID: <20251006181835.1919496-13-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251006181835.1919496-1-sashal@kernel.org>
References: <20251006181835.1919496-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 16ed389227651330879e17bd83d43bd234006722 ]

If the task is not a user thread, there's no user stack to unwind.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250820180428.930791978@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Backport Recommendation: **YES**

### Comprehensive Analysis

#### What the Bug Fixes

This commit addresses a **correctness and robustness bug** in the perf
subsystem's callchain unwinding logic. The issue is that
`perf_callchain()` incorrectly attempts to unwind user stacks for kernel
threads that have a memory descriptor (mm) field, specifically io_uring
helpers and other `PF_USER_WORKER` tasks.

**The Core Problem:**
- Line 8195 in kernel/events/core.c:8195: `bool user =
  !event->attr.exclude_callchain_user;`
- Line 8201-8202: Only checks `if (!current->mm) user = false;`
- **However**, io_uring helpers (marked with `PF_USER_WORKER`) are
  kernel threads that **do have** `current->mm` set
- This causes the code to incorrectly attempt user stack unwinding for
  these kernel threads

**The Fix:**
The commit adds an explicit check for kernel thread flags when
determining whether to unwind user stacks:
```c
bool user = !event->attr.exclude_callchain_user &&
    !(current->flags & (PF_KTHREAD | PF_USER_WORKER));
```

This provides defense-in-depth alongside the later `!current->mm` check
at line 8201.

#### Context from Related Commits

This is part of a coordinated patch series (commits e649bcda25b5a →
16ed389227651) that improves perf's handling of kernel threads:

1. **Commit 90942f9fac057** (Steven Rostedt): Fixed
   `get_perf_callchain()` and other locations in
   kernel/events/callchain.c and kernel/events/core.c with the same
   PF_KTHREAD|PF_USER_WORKER check
2. **Commit 16ed389227651** (this commit, Josh Poimboeuf): Completes the
   fix by applying the same logic to `perf_callchain()`

The commit message from 90942f9fac057 explains the rationale clearly:
> "To determine if a task is a kernel thread or not, it is more reliable
to use (current->flags & (PF_KTHREAD|PF_USER_WORKER)) than to rely on
current->mm being NULL. That is because some kernel tasks (io_uring
helpers) may have a mm field."

#### Historical Context

- **PF_USER_WORKER** was introduced in v6.4 (commit 54e6842d0775, March
  2023) as part of moving common PF_IO_WORKER behavior
- The bug has existed since v6.4 when io_uring helpers started having mm
  fields set
- This fix is from **August 2025** (very recent)

#### Impact Assessment

**1. Correctness Issues:**
- Perf events collecting callchains will have **incorrect/garbage data**
  when profiling workloads using io_uring
- This affects production systems using io_uring with performance
  profiling

**2. Performance Impact:**
- Unnecessary CPU cycles wasted attempting to unwind non-existent user
  stacks
- Could be significant in workloads with heavy io_uring usage and perf
  sampling

**3. Potential Stability Issues:**
- Attempting to walk a non-existent user stack could access invalid
  memory
- Architecture-specific `perf_callchain_user()` implementations may not
  handle this gracefully
- While no explicit crash reports are in the commit, the potential
  exists

**4. Affected Systems:**
- Any system using io_uring + perf profiling (common in modern high-
  performance applications)
- Affects all architectures that support perf callchain unwinding

#### Why This Should Be Backported

✅ **Fixes important bug**: Corrects fundamental logic error in
determining user vs kernel threads

✅ **Small and contained**: Only adds a single condition check - 2 lines
changed in kernel/events/core.c:8195-8196

✅ **Minimal regression risk**: The check is conservative - it only
prevents incorrect behavior, doesn't change valid cases

✅ **Affects real workloads**: io_uring is widely used in databases, web
servers, and high-performance applications

✅ **Part of coordinated fix series**: Works together with commit
90942f9fac057 that's likely already being backported

✅ **Follows stable rules**:
- Important correctness fix
- No architectural changes
- Confined to perf subsystem
- Low risk

✅ **No dependencies**: Clean application on top of existing code

#### Evidence from Code Analysis

Looking at kernel/events/core.c:8191-8209, the current code flow for a
`PF_USER_WORKER` task:
1. `user = !event->attr.exclude_callchain_user` → likely true
2. `if (!current->mm)` → **false** for io_uring helpers (they have mm)
3. `user` remains true
4. Calls `get_perf_callchain(..., user=true, ...)` → **INCORRECT**

After the fix:
1. `user = !event->attr.exclude_callchain_user && !(current->flags &
   PF_USER_WORKER)` → **correctly false**
2. Returns empty callchain or kernel-only callchain → **CORRECT**

This is clearly a bug that needs fixing in stable kernels.

 kernel/events/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index ea9ff856770be..6f01304a73f63 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8192,7 +8192,8 @@ struct perf_callchain_entry *
 perf_callchain(struct perf_event *event, struct pt_regs *regs)
 {
 	bool kernel = !event->attr.exclude_callchain_kernel;
-	bool user   = !event->attr.exclude_callchain_user;
+	bool user   = !event->attr.exclude_callchain_user &&
+		!(current->flags & (PF_KTHREAD | PF_USER_WORKER));
 	/* Disallow cross-task user callchains. */
 	bool crosstask = event->ctx->task && event->ctx->task != current;
 	const u32 max_stack = event->attr.sample_max_stack;
-- 
2.51.0

