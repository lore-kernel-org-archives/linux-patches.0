Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F9847ECD9;
	Mon, 20 Apr 2026 13:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691873; cv=none; b=AQs1nSCcXSGObig8094ofTIZ1Il4MtzMYX1+7NxoVS5pwTWN2LMciBbjgkXQOGIlQlIUbLuCRjvasqMiId6DZ4tddcoyVeqyuFUgZ/PIFi3QWr6KHYEmNPxkDZoli/d6F3wWyDaWLT9BaCwmdxCA1NU2A+KW36PKu/F7hOozsC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691873; c=relaxed/simple;
	bh=Cgg0XfGmdunhBU3i6RDEiNjzSLUimxl+nyzgB/Gf+eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mvcan/f2+N9UD3H+oOgh2EHt7YaJlWru2d08C/ZBjpZ4yD+UtVErHRai2kBU5vX0X/UW5qeQXBjlK6rW5wzrApAZI2zKtO0EofYb07a3yi0hHsh1WWx8xQGixuGTvDGCscHoq81EKZj9EOJwwfkv3Bdv9pjni/or3yn/Qplo/ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DoT/Orn5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DoT/Orn5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D4DC2BCB6;
	Mon, 20 Apr 2026 13:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691873;
	bh=Cgg0XfGmdunhBU3i6RDEiNjzSLUimxl+nyzgB/Gf+eY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DoT/Orn5kD/Sv945vr8pHtFOSZIMIGA3wmKCO/LzdrlYthWbZUDY9IFUCj0Nq6aNj
	 PKbST6K7cnMEZNPikiojmVa97hiwHOJNsPiPCdsfu/fwXNAHpkh+amjJlmYjzB69PZ
	 3H8FIlzznHZLGOwB+GyLKNENFQKgDsyhqatQCVdPW4nZQUQPH+3Do7Qq3LiNo615bL
	 g9B177CWrDRRklV3EM5/dGmWpWk9A6yZwkEwfAskqBIoTi2r5V9Rd+ERKb7VrIQs3O
	 Sf6ZWRZIzeYjE5rITeCSU988a0dU3QR0HiQK6IgQBz1R5QzKmckbqf5SIC9zq2Puxn
	 lK71AR0BQY1KA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniel Palmer <daniel@0x0f.com>,
	Christoph Plattner <christoph.plattner@gmx.at>,
	Greg Ungerer <gerg@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	gerg@linux-m68k.org,
	geert@linux-m68k.org,
	linux-m68k@lists.linux-m68k.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] m68k: Fix task info flags handling for 68000
Date: Mon, 20 Apr 2026 09:20:38 -0400
Message-ID: <20260420132314.1023554-244-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Palmer <daniel@0x0f.com>

[ Upstream commit 2c6805145e1605cef39459f78979f7edee251b41 ]

The logic for deciding what to do after a syscall should be checking
if any of the lower byte bits are set and then checking if the reschedule
bit is set.

Currently we are loading the top word, checking if any bits are set
(which never seems to be true) and thus jumping over loading the
whole long and checking if the reschedule bit is set.

We get the thread info in two places so split that logic out in
a macro and then fix the code so that it loads the byte of the flags
we need to check, checks if anything is set and then checks if
the reschedule bit in particular is set.

Reported-by: Christoph Plattner <christoph.plattner@gmx.at>
Signed-off-by: Daniel Palmer <daniel@0x0f.com>
Signed-off-by: Greg Ungerer <gerg@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a comprehensive analysis. Let
me compile the full report.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem:** m68k (68000 variant, non-MMU)
- **Action verb:** "Fix"
- **Summary:** Fix incorrect task info flags checking on the 68000
  return-to-userspace path

### Step 1.2: Tags
- **Reported-by:** Christoph Plattner <christoph.plattner@gmx.at> — real
  user report
- **Signed-off-by:** Daniel Palmer (author), Greg Ungerer (m68k
  maintainer)
- No Fixes: tag, no Cc: stable (expected for manual review candidates)
- Signed by the m68k maintainer (Greg Ungerer), strong trust signal

### Step 1.3: Commit Body
The message clearly explains the bug mechanism: the code loads the wrong
portion of `thread_info->flags` (the top word instead of the low byte),
causing the return-to-userspace check for pending work (rescheduling,
signals) to **never fire**. The description is detailed and technically
precise.

### Step 1.4: Hidden Bug Fix?
No — this is explicitly described as a fix with clear symptoms.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **One file changed:** `arch/m68k/68000/entry.S`
- ~15 effective lines changed (excluding blank/comment lines)
- **Functions affected:** `system_call` (macro extraction),
  `Luser_return` / `Lwork_to_do` (the fix itself)
- **Scope:** Single-file surgical fix

### Step 2.2: Code Flow Change

The fix has two parts:

**Part 1: Macro extraction** — The thread_info pointer computation (3
instructions) is deduplicated into a `getthreadinfo` macro. This is pure
cleanup with zero semantic change.

**Part 2: The actual bug fix** at `Luser_return`:

BEFORE (buggy):

```103:103:arch/m68k/68000/entry.S
        move    %a2@(TINFO_FLAGS),%d1   /* thread_info->flags */
```

On the MC68000, `move` (no size suffix) is a word (16-bit) operation. On
big-endian m68k, this loads the **upper 16 bits** (bits 31-16) of the
32-bit `flags` field. The important flags (TIF_NEED_RESCHED=7,
TIF_SIGPENDING=6, etc.) are all in bits 0-7, so they are **never
detected**.

AFTER (fixed):

```diff
moveb   %a2@(TINFO_FLAGS + 3),%d1       /* thread_info->flags (low 8
bits) */
```

Loads byte offset +3 (the least significant byte on big-endian), which
contains the actual important flags.

Also removes the redundant `movel` reload at `Lwork_to_do:` since `d1`
already has the flags.

### Step 2.3: Bug Mechanism
**Logic/correctness bug** — Wrong memory access size and offset, causing
the kernel to read bits 31-16 of the flags (always zero) instead of bits
7-0 (where the important flags live).

### Step 2.4: Fix Quality
- **Obviously correct:** YES. The fix makes the 68000 code identical in
  pattern to the ColdFire entry.S (fixed in 2012) and the MMU
  kernel/entry.S, both of which use `moveb %aX@(TINFO_FLAGS+3)`.
- **Minimal/surgical:** YES.
- **Regression risk:** Essentially none — the current code is completely
  broken, and the fix is a proven pattern.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The buggy `move` instruction traces back to commit `aa4d1f897f6a7f`
(2011, Greg Ungerer — symbol rename only). The actual instruction was
present since `^1da177e4c3f41` (Linux 2.6.12, 2005). The bug has existed
since the code was first written.

### Step 3.2: Related Fix
Commit `8b3262c00d6fec` ("m68knommu: fix syscall tracing stuck process",
Greg Ungerer, 2012) fixed the **exact same bug** for ColdFire:

```diff
- movel   %a0@(TINFO_FLAGS),%d1   /* get thread_info->flags */
+       moveb   %a0@(TINFO_FLAGS+3),%d1 /* thread_info->flags (low 8
bits) */
```

That 2012 fix missed the 68000 entry.S. This commit fixes the 68000
variant 13+ years later.

### Step 3.3: File History
Only cosmetic changes to `arch/m68k/68000/entry.S` since v5.15 (one SPDX
header cleanup). The file is extremely stable — the fix will apply
cleanly to all stable trees.

### Step 3.4: Author Context
Daniel Palmer is a known m68k contributor. Greg Ungerer (who signed off)
is the m68k subsystem maintainer.

### Step 3.5: Dependencies
None. This is a completely standalone fix.

---

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1-4.2
b4 dig could not find the original submission. Web searches did not
locate the specific mailing list discussion. However, the patch was
signed off by the m68k maintainer (Greg Ungerer), confirming proper
review.

### Step 4.3: Bug Report
The Reported-by tag indicates Christoph Plattner hit this in practice.
The symptoms would be processes never being preempted and never
receiving signals — the system would be fundamentally broken for any
real use.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
The fix is in the assembly return-to-userspace path (`Luser_return`),
which is hit on **every syscall exit and every exception return** to
userspace.

### Step 5.2-5.4: Callers and Reachability
`ret_from_exception` is the universal exception return path for the
68000 platform. It is called from:
- `system_call` (every syscall)
- `inthandler1` through `inthandler7` (all hardware interrupts)

This code path is hit **constantly** — every syscall and every interrupt
that returns to userspace.

### Step 5.5: Similar Patterns
Both `arch/m68k/kernel/entry.S` (line 252) and
`arch/m68k/coldfire/entry.S` (line 134) already use the correct `moveb
%aX@(TINFO_FLAGS+3)` pattern. The `thread_info.h` header confirms at
lines 57-59:

```57:60:arch/m68k/include/asm/thread_info.h
/* entry.S relies on these definitions!
 - bits 0-7 are tested at every exception exit
 - bits 8-15 are also tested at syscall exit
```

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable Trees
The buggy code has been present since Linux 2.6.12 (2005). It exists in
ALL stable trees. Between v5.15 and HEAD, only one cosmetic change (SPDX
header) touched this file.

### Step 6.2: Backport Complications
**None.** The file is extremely stable. The patch will apply cleanly to
all stable trees.

### Step 6.3: Related Fixes Already in Stable
No prior fix for the 68000 variant exists in any stable tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**arch/m68k** — architecture-specific, affects 68000 platform users.
While m68k is not mainstream, the 68000 platform is used in embedded
systems and retro-computing.

### Step 7.2: Activity
Low activity subsystem (very mature), which means the bug has persisted
unnoticed for a long time.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is Affected
All users of the 68000 non-MMU m68k platform.

### Step 8.2: Trigger Conditions
**Every syscall and every interrupt that returns to userspace triggers
the bug.** The bug is 100% reproducible — it fires on every single
return to userspace.

### Step 8.3: Failure Mode Severity
**CRITICAL:**
- Tasks are **never rescheduled** when returning to userspace
  (TIF_NEED_RESCHED never detected)
- **Signals are never delivered** to userspace processes (TIF_SIGPENDING
  never detected)
- This means cooperative/preemptive scheduling is broken and signals
  (including SIGKILL) don't work

### Step 8.4: Risk-Benefit
- **Benefit:** VERY HIGH — fixes fundamental kernel functionality
  (scheduling + signals)
- **Risk:** VERY LOW — ~5 effective lines changed, pattern proven by
  identical ColdFire fix from 2012, consistent with MMU entry.S
- **Ratio:** Overwhelmingly positive

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Compilation

**FOR backporting:**
- Fixes a **CRITICAL** bug: scheduling and signal delivery completely
  broken on 68000
- Bug present since 2005, affects ALL stable trees
- Small, surgical fix (~5 effective lines)
- Pattern proven: identical fix applied to ColdFire in 2012 (commit
  `8b3262c00d6fec`)
- Consistent with MMU kernel/entry.S which already uses `moveb ...
  TINFO_FLAGS+3`
- Signed off by m68k maintainer
- Has a Reported-by (real user hit this)
- No dependencies, applies cleanly
- No new features or APIs

**AGAINST backporting:**
- m68k 68000 is a niche platform (limited user base)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** — proven pattern, maintainer
   sign-off, reported-by
2. Fixes a real bug? **YES** — scheduling and signals completely broken
3. Important issue? **YES** — CRITICAL (system fundamentally non-
   functional)
4. Small and contained? **YES** — one file, ~5 effective lines
5. No new features or APIs? **YES**
6. Can apply to stable? **YES** — file barely changed across stable
   trees

### Step 9.3: Exception Categories
Not an exception category — this is a straightforward, serious bug fix.

---

## Verification

- [Phase 1] Parsed tags: Found Reported-by: Christoph Plattner, Signed-
  off-by: Greg Ungerer (m68k maintainer)
- [Phase 2] Diff analysis: `move` (16-bit) loads wrong half of 32-bit
  flags on big-endian; fix uses `moveb` at offset +3 for correct byte
- [Phase 3] git blame: Buggy instruction from `^1da177e4c3f41` (Linux
  2.6.12, 2005), symbol renamed in `aa4d1f897f6a7f` (2011)
- [Phase 3] git show `8b3262c00d6fec`: Confirmed identical fix for
  ColdFire from 2012 — changes `movel %a0@(TINFO_FLAGS)` to `moveb
  %a0@(TINFO_FLAGS+3)` with same comment
- [Phase 3] git log: File only had cosmetic changes since v5.15
- [Phase 4] b4 dig: Could not find original submission
- [Phase 4] Web search: Found Daniel Palmer is active m68k contributor
- [Phase 5] Verified `thread_info.h` lines 57-60: Comments explicitly
  state "bits 0-7 are tested at every exception exit"
- [Phase 5] Verified TIF_NEED_RESCHED=7, TIF_SIGPENDING=6 — both in low
  byte (offset +3 on big-endian)
- [Phase 5] Verified ColdFire entry.S line 134 and kernel/entry.S line
  252 both use correct `moveb ... TINFO_FLAGS+3`
- [Phase 6] File identical across stable trees except one SPDX header
  change — clean apply expected
- [Phase 8] Trigger: Every syscall/interrupt return to userspace.
  Severity: CRITICAL (no scheduling, no signals)
- UNVERIFIED: Could not find the specific mailing list discussion or bug
  report details from Christoph Plattner

The fix is small, surgical, obviously correct (proven pattern from 2012
ColdFire fix), and fixes a critical bug that makes the 68000 kernel
fundamentally non-functional. It meets all stable kernel criteria.

**YES**

 arch/m68k/68000/entry.S | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/m68k/68000/entry.S b/arch/m68k/68000/entry.S
index 72e95663b62ff..c257cc415c478 100644
--- a/arch/m68k/68000/entry.S
+++ b/arch/m68k/68000/entry.S
@@ -18,6 +18,13 @@
 
 .text
 
+/* get thread_info pointer into a2 */
+ .macro getthreadinfo
+	movel	%sp,%d1
+	andl	#-THREAD_SIZE,%d1
+	movel	%d1,%a2
+ .endm
+
 .globl system_call
 .globl resume
 .globl ret_from_exception
@@ -70,9 +77,8 @@ ENTRY(system_call)
 
 	movel	%sp@(PT_OFF_ORIG_D0),%d0
 
-	movel	%sp,%d1			/* get thread_info pointer */
-	andl	#-THREAD_SIZE,%d1
-	movel	%d1,%a2
+	/* Doing a trace ? */
+	getthreadinfo
 	btst	#(TIF_SYSCALL_TRACE%8),%a2@(TINFO_FLAGS+(31-TIF_SYSCALL_TRACE)/8)
 	jne	do_trace
 	cmpl	#NR_syscalls,%d0
@@ -96,16 +102,15 @@ Luser_return:
 	/* heavy interrupt load*/
 	andw	#ALLOWINT,%sr
 
-	movel	%sp,%d1			/* get thread_info pointer */
-	andl	#-THREAD_SIZE,%d1
-	movel	%d1,%a2
+	getthreadinfo
 1:
-	move	%a2@(TINFO_FLAGS),%d1	/* thread_info->flags */
+	/* check if any of the flags are set */
+	moveb	%a2@(TINFO_FLAGS + 3),%d1	/* thread_info->flags (low 8 bits) */
 	jne	Lwork_to_do
 	RESTORE_ALL
 
 Lwork_to_do:
-	movel	%a2@(TINFO_FLAGS),%d1	/* thread_info->flags */
+	/* check if reschedule needs to be called */
 	btst	#TIF_NEED_RESCHED,%d1
 	jne	reschedule
 
-- 
2.53.0

