Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8367C47F2EA;
	Mon, 20 Apr 2026 13:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691880; cv=none; b=X/6WYVOfmSmftgAyG4Tkj9UBkaSWAHtS03YuD8D7AHJWjM9x5T7U9fMrQjaX8GTYdAt7MbaB1KdPlz+wIlkbdugBICHyBgW3Kc6/jQFBU541jac7U2VPsmGNysbswhXdwS5t/IibSTPuWrERKfUSpU8y6jIirYAymVqPywtu52o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691880; c=relaxed/simple;
	bh=dsaQHQrVlJQr4tmA2idLn2ZOrKmGp++3PWz7AjvgeEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qy95tKIY2w3qQMfrR8StrulXHOPhHtrMMfU8ZuclqunH/tq50sICnRkvNqbkr/U7GIy32FemZTHAYQdhMUzCNVqJnUlwtphWy3IRmtL8cxK/YOSdnFZ1lL+dSYM9kNG3UBPH21Kg/6tgSsna515eLoRDD8pa2KZJ/RuPYFfrqP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qhEfndbm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qhEfndbm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D75C2BCB7;
	Mon, 20 Apr 2026 13:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691880;
	bh=dsaQHQrVlJQr4tmA2idLn2ZOrKmGp++3PWz7AjvgeEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qhEfndbmI9nV1Sh3Tqna/f5Tiznoj4wWVRGU6q6HTC4SqM9lndyIgdwLC9joyarcx
	 q/REi2PbKGUMP0PUKeKVljwni8Hk2D2CrQ243yF+nhSgUr4SeagS6wWIeSwMShKbxr
	 oRIYYe56wkJnxvpflzBY0HZt/FNfes7B6TsvP+CTAfRz8wH8M1d3FL2sRsbDtoEpub
	 CsRVn6ARozefjhXGmfjZfHJi98RFLX9Cv9hDG428BPnZVVfmML9ROBhcYm0/OnQaA+
	 Xz33N9URQwX1axPHZFFBTLNV3zYnazal3Cuq/GOEjjhk9ggtJ/nOJsZ2I/71BeUXLZ
	 t7coh5ZhfY6OQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ilya Leoshkevich <iii@linux.ibm.com>,
	Hari Bathini <hbathini@linux.ibm.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	bpf@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.6] s390/bpf: Do not increment tailcall count when prog is NULL
Date: Mon, 20 Apr 2026 09:20:42 -0400
Message-ID: <20260420132314.1023554-248-sashal@kernel.org>
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

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit e4094d56c5592dd90aa619f9480265b0689ed3d9 ]

Currently tail calling a non-existent prog results in tailcall count
increment. This is what the interpreter is doing, but this is clearly
wrong, so replace load-and-increment and compare-and-jump with load
and compare-and-jump, conditionally followed by increment and store.

Reported-by: Hari Bathini <hbathini@linux.ibm.com>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Link: https://lore.kernel.org/r/20260217161058.101346-1-iii@linux.ibm.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information I need. Let me compile my comprehensive
analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: s390/bpf (s390 architecture BPF JIT compiler)
- **Action verb**: "Do not increment" (correction of incorrect behavior)
- **Summary**: Stop incrementing the tail call counter when the target
  program is NULL (non-existent)

Record: [s390/bpf] [Do not / correct] [Stop incorrect tail call counter
increment for NULL programs]

### Step 1.2: Tags
- **Reported-by**: Hari Bathini <hbathini@linux.ibm.com> - this is the
  same person who wrote the powerpc equivalent fix with `Cc: stable` and
  `Fixes:` tags
- **Signed-off-by**: Ilya Leoshkevich <iii@linux.ibm.com> (author, s390
  BPF JIT maintainer)
- **Link**:
  https://lore.kernel.org/r/20260217161058.101346-1-iii@linux.ibm.com
- **Signed-off-by**: Alexei Starovoitov <ast@kernel.org> (BPF maintainer
  applied the patch)
- No `Fixes:` tag or `Cc: stable` tag on this s390 variant (expected -
  that's why it needs review)
- The **powerpc equivalent** (521bd39d9d28c) has both `Fixes:
  ce0761419fae` and `Cc: stable@vger.kernel.org`

Record: Reported by Hari Bathini, authored by s390 BPF maintainer,
applied by BPF maintainer. Powerpc equivalent explicitly tagged for
stable.

### Step 1.3: Commit Body Analysis
- **Bug described**: Tail calling a non-existent program results in tail
  call count increment
- **Symptom**: Failed tail calls (target NULL) consume the tail call
  budget (MAX_TAIL_CALL_CNT=33), potentially preventing legitimate tail
  calls from succeeding
- **Root cause**: The `laal` (atomic load-and-add) instruction
  increments the counter before the NULL program check; the counter is
  incremented even when the tail call path branches out due to NULL prog
- **Author's explanation**: "replace load-and-increment and compare-and-
  jump with load and compare-and-jump, conditionally followed by
  increment and store"

Record: The bug causes incorrect accounting of tail calls - failed
attempts count against the limit.

### Step 1.4: Hidden Bug Fix Detection
This is NOT hidden - it's an explicit correctness fix. The commit
message says "this is clearly wrong."

Record: Explicit correctness bug fix, not disguised.

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed**: 1 file (`arch/s390/net/bpf_jit_comp.c`)
- **Lines changed**: ~20 lines modified (net delta: +7 lines)
- **Functions modified**: `bpf_jit_insn()` in the `BPF_JMP |
  BPF_TAIL_CALL` case
- **Scope**: Single-file surgical fix in one function, one case label

Record: [1 file, ~20 lines, single function, surgical scope]

### Step 2.2: Code Flow Change

**Before**:
1. Load 1 into %w0
2. `laal %w1,%w0,off(%r15)` — atomically loads the counter into %w1 and
   adds 1 (counter is now incremented)
3. Compare %w1 (old value) against `MAX_TAIL_CALL_CNT-1`, jump out if
   exceeded
4. Load program pointer from array
5. Check if prog is NULL, branch out if so
6. (Counter is already incremented, even if prog was NULL and we
   branched out)

**After**:
1. `ly %w0,off(%r15)` — load the counter (non-atomic, no increment)
2. `clij %w0,MAX_TAIL_CALL_CNT,0xa,out` — compare against
   MAX_TAIL_CALL_CNT, jump out if >=
3. Load program pointer from array
4. Check if prog is NULL, branch out if so
5. `ahi %w0,1` — increment counter
6. `sty %w0,off(%r15)` — store incremented counter back

The increment now happens ONLY after confirming the program is non-NULL.

### Step 2.3: Bug Mechanism
**Category**: Logic/correctness fix
**Mechanism**: The counter was incremented unconditionally before
checking if the tail call target exists. This matches what x86 JIT
already does correctly (confirmed: x86 `emit_bpf_tail_call_indirect()`
line 775-776 increments after NULL check with comment "Inc tail_call_cnt
if the slot is populated").

### Step 2.4: Fix Quality
- **Obviously correct**: Yes - it matches x86 behavior and the comment
  in the code explains the intent
- **Minimal/surgical**: Yes - only reorders the JIT emissions for the
  tail call sequence
- **Regression risk**: Very low. The change from atomic `laal` to non-
  atomic `ly`/`ahi`/`sty` is safe because `tail_call_cnt` is on the
  stack frame, which is per-CPU/per-thread
- **Red flags**: None

Record: High quality fix, obviously correct, minimal regression risk.

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
- The buggy atomic-increment-before-NULL-check pattern was introduced in
  6651ee070b3124 ("s390/bpf: implement bpf_tail_call() helper",
  2015-06-08, v4.2)
- The code has been present for ~11 years across all stable trees
- The `struct prog_frame` refactoring (e26d523edf2a6) changed how
  offsets are computed but didn't change the logic

Record: Bug introduced in v4.2 (2015), present in ALL stable trees.

### Step 3.2: Fixes Tag
No Fixes tag on this commit. The powerpc equivalent fixes ce0761419fae.

### Step 3.3: Related Changes
Key related commits, all in v7.0:
- eada40e057fc1: "Do not write tail call counter into helper/kfunc
  frames" (Fixes: dd691e847d28)
- c861a6b147137: "Write back tail call counter for BPF_PSEUDO_CALL"
  (Fixes: dd691e847d28)
- bc3905a71f025: "Write back tail call counter for
  BPF_TRAMP_F_CALL_ORIG" (Fixes: 528eb2cb87bc)
- e26d523edf2a6: "Describe the frame using a struct instead of
  constants"

These show active work on s390 tail call counter correctness.

Record: This is standalone - no other patches needed.

### Step 3.4: Author
Ilya Leoshkevich is the primary s390 BPF JIT developer/maintainer with
20+ commits to `arch/s390/net/`.

Record: Author is the subsystem maintainer.

### Step 3.5: Dependencies
- Requires `struct prog_frame` from e26d523edf2a6 (IN v7.0)
- For older trees (6.6 and earlier), the patch would need adaptation to
  use `STK_OFF_TCCNT` offsets instead

Record: Applies cleanly to v7.0; needs rework for 6.6 and older.

## PHASE 4: MAILING LIST

Lore was inaccessible due to bot protection. However, key facts
established:
- The powerpc equivalent (521bd39d9d28c) by the same reporter has `Cc:
  stable@vger.kernel.org`
- b4 dig found the related series at
  https://patch.msgid.link/20250813121016.163375-2-iii@linux.ibm.com

Record: Could not fetch lore discussion. Powerpc equivalent explicitly
CC'd stable.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
- `bpf_jit_insn()` - the main JIT emission function, `BPF_JMP |
  BPF_TAIL_CALL` case

### Step 5.2-5.4: Impact Surface
- Every BPF program that uses tail calls on s390 is affected
- The tail call mechanism is a core BPF feature used in XDP, networking,
  and tracing
- s390 is used in enterprise environments (mainframes) where BPF is
  increasingly deployed

Record: Affects all BPF tail call users on s390.

### Step 5.5: Similar Patterns
- The **same bug** was fixed on powerpc in 521bd39d9d28c
- x86 already has the correct ordering (verified in
  `emit_bpf_tail_call_indirect()`)
- The BPF interpreter in `kernel/bpf/core.c` lines 2087-2094 actually
  has the same ordering issue (increments before NULL check), but the
  commit message acknowledges this and calls it "clearly wrong"

Record: Cross-architecture issue, x86 already fixed, powerpc fix
explicitly for stable.

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code Existence
- Bug exists since v4.2 (6651ee070b3124) - present in ALL active stable
  trees
- However, the patch as-is only applies cleanly to trees with `struct
  prog_frame` (v7.0)

### Step 6.2: Backport Complications
- v7.0: Should apply cleanly (confirmed code matches the "before" side
  of diff)
- v6.6 and older: Would need rework due to different frame offset
  calculations (`STK_OFF_TCCNT` vs `struct prog_frame`)

Record: Clean apply for v7.0. Older trees need rework.

### Step 6.3: Related Fixes in Stable
No equivalent fix found in stable trees for s390.

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
- **Subsystem**: BPF JIT compiler (arch-specific, s390)
- **Criticality**: IMPORTANT - s390 is used in enterprise mainframe
  environments; BPF is critical for networking, security, and
  observability

### Step 7.2: Activity
The s390/bpf JIT has been actively developed with 20+ commits in v7.0.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is Affected
- s390 users running BPF programs with tail calls
- Enterprise mainframe users using eBPF for networking, tracing, or
  security

### Step 8.2: Trigger Conditions
- Triggered when a BPF program does a tail call to an array index that
  has no program (NULL)
- This is a common scenario: BPF prog arrays are often sparse with some
  NULL slots
- Can be triggered from userspace (BPF programs are loaded by
  unprivileged users in some configs)

### Step 8.3: Failure Mode Severity
- **Functional failure**: Legitimate tail calls fail prematurely because
  the counter hits MAX_TAIL_CALL_CNT sooner than expected
- **Result**: BPF program behavior is incorrect; tail call chains are
  cut short
- **Severity**: MEDIUM-HIGH (incorrect behavior, program logic failure,
  potential security implications if BPF programs relied on tail call
  guarantees)

### Step 8.4: Risk-Benefit Ratio
- **Benefit**: HIGH - fixes incorrect BPF behavior affecting tail call
  chains
- **Risk**: LOW - ~20 lines, single function, obviously correct, matches
  x86 behavior, from subsystem maintainer
- **Ratio**: Favorable for backporting

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting:**
- Fixes a real correctness bug (tail call counter incorrectly
  incremented for NULL programs)
- Bug has existed since v4.2 (2015) - all stable trees affected
- Powerpc equivalent (521bd39d9d28c) has `Cc: stable@vger.kernel.org`
  and `Fixes:` tag
- x86 JIT already has the correct behavior
- Small, surgical, single-file fix (~20 lines)
- Author is the s390 BPF maintainer; applied by BPF maintainer
- Reported by someone who also fixed it on powerpc and tagged for stable

**AGAINST backporting:**
- No explicit `Fixes:` or `Cc: stable` on the s390 variant itself
- Needs rework for older stable trees (6.6 and earlier)

### Step 9.2: Stable Rules Checklist
1. **Obviously correct and tested?** YES - matches x86 behavior, from
   subsystem maintainer, applied by BPF maintainer
2. **Fixes a real bug?** YES - incorrect tail call counting causing
   premature tail call limit
3. **Important issue?** YES - program correctness (can make BPF programs
   fail)
4. **Small and contained?** YES - ~20 lines in one function in one file
5. **No new features/APIs?** CORRECT - pure bugfix
6. **Can apply to stable?** YES for v7.0 (verified code matches)

### Step 9.3: Exception Categories
Not an exception category - this is a standard bug fix.

### Step 9.4: Decision
This is a clear correctness fix for a long-standing bug in the s390 BPF
JIT. The equivalent powerpc fix was explicitly tagged for stable. The
fix is small, from the maintainer, and brings s390 in line with x86's
already-correct behavior.

## Verification

- [Phase 1] Parsed tags: Reported-by: Hari Bathini (also powerpc fix
  author), SOBs from s390/bpf and BPF maintainers
- [Phase 2] Diff analysis: ~20 lines changed, reorders JIT emissions to
  increment after NULL check
- [Phase 2] Verified x86 JIT (`emit_bpf_tail_call_indirect()` lines
  775-776) already increments after NULL check
- [Phase 2] Verified BPF interpreter (`kernel/bpf/core.c` lines
  2087-2094) has same buggy ordering
- [Phase 3] git blame: buggy code from 6651ee070b3124 (v4.2, 2015),
  present in all stable trees
- [Phase 3] git show 521bd39d9d28c: powerpc equivalent has `Fixes:` and
  `Cc: stable@vger.kernel.org`
- [Phase 3] git merge-base: all dependencies (e26d523edf2a6,
  eada40e057fc1, bc3905a71f025, c861a6b147137) are in v7.0
- [Phase 3] Author (Ilya Leoshkevich) confirmed as s390 BPF JIT
  maintainer via 20+ commits
- [Phase 4] Lore inaccessible (bot protection); b4 dig found related
  series URL
- [Phase 5] Verified callers: `bpf_jit_insn()` handles all BPF JIT
  emission, core function
- [Phase 6] Verified current v7.0 code (lines 1864-1895) matches
  "before" side of diff exactly
- [Phase 6] v6.6 confirmed to have same bug pattern but uses different
  frame offset calculations
- [Phase 8] Impact: all s390 BPF tail call users; trigger: tail call to
  sparse array; severity: MEDIUM-HIGH

**YES**

 arch/s390/net/bpf_jit_comp.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index bf92964246eb1..2112267486623 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -1862,20 +1862,21 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
 				 jit->prg);
 
 		/*
-		 * if (tail_call_cnt++ >= MAX_TAIL_CALL_CNT)
+		 * if (tail_call_cnt >= MAX_TAIL_CALL_CNT)
 		 *         goto out;
+		 *
+		 * tail_call_cnt is read into %w0, which needs to be preserved
+		 * until it's incremented and flushed.
 		 */
 
 		off = jit->frame_off +
 		      offsetof(struct prog_frame, tail_call_cnt);
-		/* lhi %w0,1 */
-		EMIT4_IMM(0xa7080000, REG_W0, 1);
-		/* laal %w1,%w0,off(%r15) */
-		EMIT6_DISP_LH(0xeb000000, 0x00fa, REG_W1, REG_W0, REG_15, off);
-		/* clij %w1,MAX_TAIL_CALL_CNT-1,0x2,out */
+		/* ly %w0,off(%r15) */
+		EMIT6_DISP_LH(0xe3000000, 0x0058, REG_W0, REG_0, REG_15, off);
+		/* clij %w0,MAX_TAIL_CALL_CNT,0xa,out */
 		patch_2_clij = jit->prg;
-		EMIT6_PCREL_RIEC(0xec000000, 0x007f, REG_W1, MAX_TAIL_CALL_CNT - 1,
-				 2, jit->prg);
+		EMIT6_PCREL_RIEC(0xec000000, 0x007f, REG_W0, MAX_TAIL_CALL_CNT,
+				 0xa, jit->prg);
 
 		/*
 		 * prog = array->ptrs[index];
@@ -1894,6 +1895,12 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
 		patch_3_brc = jit->prg;
 		EMIT4_PCREL_RIC(0xa7040000, 8, jit->prg);
 
+		/* tail_call_cnt++; */
+		/* ahi %w0,1 */
+		EMIT4_IMM(0xa70a0000, REG_W0, 1);
+		/* sty %w0,off(%r15) */
+		EMIT6_DISP_LH(0xe3000000, 0x0050, REG_W0, REG_0, REG_15, off);
+
 		/*
 		 * Restore registers before calling function
 		 */
-- 
2.53.0

