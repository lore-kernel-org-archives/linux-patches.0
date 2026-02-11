Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD40C1A5B9E;
	Wed, 11 Feb 2026 12:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770813117; cv=none; b=Y3fn2A9JSsd54qV1vZJtdx7ql0TG9smW+nIeEohFXZ+CcjxtAQWRblBsx/P5gi99ulDnhvKUqLBsb/Dv8wOQ+JAlK6qvDyR0T0v3N4/dnZl4VG07ahu4BOk00va2E4KOmpVyG0OJhmQE4Xvh68K3gIdO/qPIzvrnxt+N1xBUbH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770813117; c=relaxed/simple;
	bh=A+twjAPNsaUwA1498ssy6g6cPzfKbdvv4NZSTnfMYtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cnZDxCw9xin5FsqoWS8+6K5xGn/Wzl4tGv5DouAgLrxquUp3Peqi4WCszBwO++/D1GCHugTgskU/Y+2j2u3IVf3OAMrDLNLR5JkOHmoIdZSNC/PnTQl/sI65pioF3GaN8plEdFJkdPDBXPxUYbgzBA7pP4tzQN0V3uW9udg7bbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k1ARDeyi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k1ARDeyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B23C4CEF7;
	Wed, 11 Feb 2026 12:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770813117;
	bh=A+twjAPNsaUwA1498ssy6g6cPzfKbdvv4NZSTnfMYtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k1ARDeyiDFBd4OX9oKK7iu2BFZZHiY685/Kltx7tO+CCUfP1Or2zbZqsm45hWxuA9
	 h7QnUcD4OJWWr4AmFQF0KOVF0VZYXLEvG1L1tO4V55s0hsWRY1MWLyfKmrvmCD0d3W
	 zUK6q4TqsaM60ab4TZA4V/w2fkBhsZr4GzeBFC1tMEvufR2LNMxvmSz8ahMzOPO19/
	 zuLr5Tj/ZjmubdJdu/RQasK8ZVx5FULHUCeD3Y5X5/DCybN0TItIHx7wAwT5SgbUY4
	 c5vCFnYVBwaML/UKvXJc4BoBxCJ6ObjOP0C5vZRhcDZv8Sqzqa6W4nq/JhYJQK9SgF
	 yq6SDXr9zhZdQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Andreas Larsson <andreas@gaisler.com>,
	Ludwig Rydberg <ludwig.rydberg@gaisler.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>,
	arnd@arndb.de,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] sparc: Synchronize user stack on fork and clone
Date: Wed, 11 Feb 2026 07:30:32 -0500
Message-ID: <20260211123112.1330287-22-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260211123112.1330287-1-sashal@kernel.org>
References: <20260211123112.1330287-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andreas Larsson <andreas@gaisler.com>

[ Upstream commit e38eba3b77878ada327a572a41596a3b0b44e522 ]

Flush all uncommitted user windows before calling the generic syscall
handlers for clone, fork, and vfork.

Prior to entering the arch common handlers sparc_{clone|fork|vfork}, the
arch-specific syscall wrappers for these syscalls will attempt to flush
all windows (including user windows).

In the window overflow trap handlers on both SPARC{32|64},
if the window can't be stored (i.e due to MMU related faults) the routine
backups the user window and increments a thread counter (wsaved).

By adding a synchronization point after the flush attempt, when fault
handling is enabled, any uncommitted user windows will be flushed.

Link: https://sourceware.org/bugzilla/show_bug.cgi?id=31394
Closes: https://lore.kernel.org/sparclinux/fe5cc47167430007560501aabb28ba154985b661.camel@physik.fu-berlin.de/
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Ludwig Rydberg <ludwig.rydberg@gaisler.com>
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Link: https://lore.kernel.org/r/20260119144753.27945-2-ludwig.rydberg@gaisler.com
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a thorough understanding of the issue. Let me compile my
comprehensive analysis.

---

## Comprehensive Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit adds `synchronize_user_stack()` calls to `sparc_fork()`,
`sparc_vfork()`, and `sparc_clone()` in `arch/sparc/kernel/process.c`.
The commit message explains the SPARC register window mechanism:

- Before entering the C-level syscall handlers, assembly wrappers call
  `FLUSH_ALL_KERNEL_WINDOWS` (SPARC32, `entry.S` line 868/884/899) or
  `flushw` (SPARC64, `syscalls.S` line 90/96/102) to flush register
  windows.
- However, if a user window **cannot** be stored to user stack memory
  (e.g., due to MMU faults like unmapped pages, COW pages not yet
  faulted), the trap handler **buffers** the window in the thread's
  kernel-side `reg_window[]` array and increments `w_saved`/`wsaved`.
- `synchronize_user_stack()` must then be called to push these buffered
  windows to user stack via `copy_to_user()`, which uses the normal page
  fault handler that can handle demand paging, COW, etc.

The commit has strong bug report backing:
- **Link:** glibc bug 31394
  (https://sourceware.org/bugzilla/show_bug.cgi?id=31394)
- **Closes:** lore discussion from John Paul Adrian Glaubitz (Debian
  SPARC maintainer)
- **Tested-by:** John Paul Adrian Glaubitz
- **Signed-off-by:** Andreas Larsson (SPARC co-maintainer) and Ludwig
  Rydberg (Gaisler, SPARC hardware vendor)

### 2. CODE CHANGE ANALYSIS

The diff modifies only `arch/sparc/kernel/process.c`. The pattern is
identical in all three functions. Taking `sparc_fork()` as example:

**Before:**

```18:39:arch/sparc/kernel/process.c
asmlinkage long sparc_fork(struct pt_regs *regs)
{
        unsigned long orig_i1 = regs->u_regs[UREG_I1];
        long ret;
        struct kernel_clone_args args = {
                .exit_signal    = SIGCHLD,
                /* Reuse the parent's stack for the child. */
                .stack          = regs->u_regs[UREG_FP],
        };

        ret = kernel_clone(&args);
        // ...
}
```

**After (with fix):** `synchronize_user_stack()` is called before
reading register values and before `kernel_clone()`. Variable
initializations are moved after the sync point.

The mechanism of the bug:
1. Assembly wrapper flushes all register windows (via trap mechanism)
2. If user stack pages aren't accessible, windows are buffered in
   `thread_info->reg_window[]` with `w_saved > 0`
3. `kernel_clone()` → `copy_process()` → `dup_task_struct()` creates the
   child with a **new** `thread_info` — the parent's buffered windows
   (`reg_window[]`, `rwbuf_stkptrs[]`, `w_saved`) are **not** inherited
   by the child
4. The child's user stack is missing the register window data that was
   buffered in the parent's kernel memory
5. When the child unwinds function calls through those window frames, it
   reads **garbage or stale data** from the user stack

This is the exact same reason `synchronize_user_stack()` is called in
every signal handling path:

```86:86:arch/sparc/kernel/signal_32.c
        synchronize_user_stack();
```

```233:233:arch/sparc/kernel/signal_32.c
        synchronize_user_stack();
```

```52:52:arch/sparc/kernel/signal_64.c
        synchronize_user_stack();
```

```358:358:arch/sparc/kernel/signal_64.c
        synchronize_user_stack();
```

The `synchronize_user_stack()` implementation for SPARC32 (`windows.c`
line 61-82) calls `flush_user_windows()` then uses `copy_to_user()` for
any remaining buffered windows. The SPARC64 version (`process_64.c` line
479-505) does the same with 64-bit aware stack handling.

### 3. CLASSIFICATION

This is a **correctness bug fix** — not a new feature, not cleanup, not
optimization:
- Fixes **user stack corruption** in child processes after
  fork/clone/vfork on SPARC
- The missing `synchronize_user_stack()` call has existed since the
  original SPARC fork code (before the 2020 unification in commit
  `a4261d4bb450`)
- The bug is **architecture-specific** (SPARC register windows are
  unique)

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed:** ~30 lines in a single file (small)
- **Files touched:** 1 (`arch/sparc/kernel/process.c`)
- **Complexity:** Trivial — adds 3 calls to an existing, well-tested
  function
- **Risk:** Very low:
  - `synchronize_user_stack()` is a no-op when `w_saved == 0` (common
    case)
  - The function is battle-tested in signal handling since the beginning
    of Linux/SPARC
  - Only affects SPARC architecture (zero risk to other platforms)
  - Worst case: negligible performance overhead for one extra function
    call

### 5. USER IMPACT

- **Affected users:** All SPARC Linux users (Debian SPARC, embedded
  SPARC via Gaisler/LEON, legacy Sun machines)
- **Affected code paths:** fork(), vfork(), clone() — fundamental
  process creation syscalls used by virtually every program
- **Severity if triggered:** Stack corruption in child processes —
  leading to incorrect program behavior, crashes, data corruption
- **Trigger condition:** Window overflow trap failing to write to user
  stack during fork — depends on memory pressure, COW state, and call
  stack depth. The glibc bug report confirms real users hit this.

### 6. STABILITY INDICATORS

- **Tested-by:** John Paul Adrian Glaubitz (Debian SPARC port maintainer
  — a key SPARC platform user)
- **Signed-off-by:** Andreas Larsson (official SPARC co-maintainer per
  MAINTAINERS)
- **Pattern established:** Same `synchronize_user_stack()` call is used
  in signal handling, `sparc64_set_context()` (commit `397d1533b6cc`),
  and `arch_ptrace_stop()`

### 7. DEPENDENCY CHECK

- **Self-contained:** YES — `synchronize_user_stack()` is declared in
  `switch_to_32.h` and `switch_to_64.h`, implemented in `windows.c`
  (32-bit) and `process_64.c` (64-bit), all of which exist in all stable
  trees
- **No prerequisites:** The patch only adds calls to existing functions
- **Applies to:** All stable trees from 5.10.y onwards (where
  `arch/sparc/kernel/process.c` exists after the 2020 unification commit
  `a4261d4bb450` which went into v5.9)
- **The URL "27945-2"** suggests this may be patch 2 of a series, but
  the change itself is completely standalone with no dependencies

### Summary

This commit fixes a real, user-reported bug where fork/clone/vfork on
SPARC can produce child processes with corrupted user stacks due to
unflushed register windows. The fix follows an established pattern
already used throughout SPARC signal handling. It is small (3 function
call additions), contained to a single arch-specific file, obviously
correct, tested by the Debian SPARC maintainer, and carries minimal
risk. It meets every criterion for stable backporting.

**YES**

 arch/sparc/kernel/process.c | 38 +++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/arch/sparc/kernel/process.c b/arch/sparc/kernel/process.c
index 0442ab00518d3..7d69877511fac 100644
--- a/arch/sparc/kernel/process.c
+++ b/arch/sparc/kernel/process.c
@@ -17,14 +17,18 @@
 
 asmlinkage long sparc_fork(struct pt_regs *regs)
 {
-	unsigned long orig_i1 = regs->u_regs[UREG_I1];
+	unsigned long orig_i1;
 	long ret;
 	struct kernel_clone_args args = {
 		.exit_signal	= SIGCHLD,
-		/* Reuse the parent's stack for the child. */
-		.stack		= regs->u_regs[UREG_FP],
 	};
 
+	synchronize_user_stack();
+
+	orig_i1 = regs->u_regs[UREG_I1];
+	/* Reuse the parent's stack for the child. */
+	args.stack = regs->u_regs[UREG_FP];
+
 	ret = kernel_clone(&args);
 
 	/* If we get an error and potentially restart the system
@@ -40,16 +44,19 @@ asmlinkage long sparc_fork(struct pt_regs *regs)
 
 asmlinkage long sparc_vfork(struct pt_regs *regs)
 {
-	unsigned long orig_i1 = regs->u_regs[UREG_I1];
+	unsigned long orig_i1;
 	long ret;
-
 	struct kernel_clone_args args = {
 		.flags		= CLONE_VFORK | CLONE_VM,
 		.exit_signal	= SIGCHLD,
-		/* Reuse the parent's stack for the child. */
-		.stack		= regs->u_regs[UREG_FP],
 	};
 
+	synchronize_user_stack();
+
+	orig_i1 = regs->u_regs[UREG_I1];
+	/* Reuse the parent's stack for the child. */
+	args.stack = regs->u_regs[UREG_FP];
+
 	ret = kernel_clone(&args);
 
 	/* If we get an error and potentially restart the system
@@ -65,15 +72,18 @@ asmlinkage long sparc_vfork(struct pt_regs *regs)
 
 asmlinkage long sparc_clone(struct pt_regs *regs)
 {
-	unsigned long orig_i1 = regs->u_regs[UREG_I1];
-	unsigned int flags = lower_32_bits(regs->u_regs[UREG_I0]);
+	unsigned long orig_i1;
+	unsigned int flags;
 	long ret;
+	struct kernel_clone_args args = {0};
 
-	struct kernel_clone_args args = {
-		.flags		= (flags & ~CSIGNAL),
-		.exit_signal	= (flags & CSIGNAL),
-		.tls		= regs->u_regs[UREG_I3],
-	};
+	synchronize_user_stack();
+
+	orig_i1 = regs->u_regs[UREG_I1];
+	flags = lower_32_bits(regs->u_regs[UREG_I0]);
+	args.flags		= (flags & ~CSIGNAL);
+	args.exit_signal	= (flags & CSIGNAL);
+	args.tls		= regs->u_regs[UREG_I3];
 
 #ifdef CONFIG_COMPAT
 	if (test_thread_flag(TIF_32BIT)) {
-- 
2.51.0

