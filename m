Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DDC5432ED;
	Mon, 19 Oct 2026 14:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418766; cv=none; b=VvgQvnbxPeQXfQjhtme8GRh+NYZxNiCj/VXRCsoW7xnBgswU+E+yH8CG8ORgMkewPL11HfptoiF5xa2NjSZL6kG0H22rMmjceDJMAhlXt31IPWuLt+1dx4Ff7vE2Z2/z2XwKuSSfFbkO84+UufQKgWtX7zdK88Ehmgh89ofj3ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418766; c=relaxed/simple;
	bh=yu2MuGHm1FaRE8vsG0Ysv/5p86UK3dzAw/ie4BXiA0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b+jMz2ghyVL2vzygT7QW33Y2ad2kf535Cp4703HIOYql4hooguKuJn6V1yFam6P+/IEpEOoxRz9pd4LvUFN7cOgXC6/XWGJiHzsM315hKYtepSpBNVnolZG64OjsRcgbFOh22ezlA83/p5/pIS0BL3hS0oeDaUtJxB9ha12JtxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K/xu3MXy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K/xu3MXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC1A1F000D0;
	Mon, 19 Oct 2026 14:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418763;
	bh=j0uQS4vSaxc/yio3qUhmLXjUkn3ACaDPz7vnrn8DEOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K/xu3MXyRtVWD5MRzDNO3aY83t6umkUoVjiVCO9dqGSd65uWSKG5K0bRZ1QpOpQBX
	 c7fbT1Bb/zE5/cIjzfd+5GD6yyPrjQuiqKz2+zPGyFB7Z3M9bkcWJNg6RTwkbXoNdD
	 I+cUBpVYxT0B37sJiHmQAfnAdBRQ6eD/ycVI9a9k2yG7yOyHHHZ3KWIvl8M6SMXNZ1
	 gTuBPu8nqY07zEU5Fij8//c5e1TfRbWKz49+YeXTv7Ttvv0Ztkw4YnXlZ6dytTJWp4
	 pSEsrD4WdkjYTa5kAew1DYaVZde6ez2xOwPhmBZUDtaVQ+OKP4OwOfwCXirNvQXPQ1
	 brTc0u+xmvNtg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>,
	Pu Lehui <pulehui@huawei.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	luke.r.nels@gmail.com,
	xi.wang@gmail.com,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	bpf@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] riscv, bpf: Add support for BPF_MOVSX in RV32 JIT
Date: Mon, 19 Oct 2026 09:52:49 -0400
Message-ID: <20261019135441.1420968-478-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kuan-Wei Chiu <visitorckw@gmail.com>

[ Upstream commit c6a08afdfe3a81b1a54e921921e9481dd6c78f8a ]

The current rv32 bpf jit compiler incorrectly treats BPF_MOVSX as a
standard zero-extended move operation. The bpf instruction set allows
sign-extension moves by reusing the BPF_MOV opcode with the instruction
offset set to 8, 16, or 32.

Update the bpf_jit_emit_insn() function to check the offset field for
both ALU and ALU64 MOV operations. If the offset is non-zero, emit the
correct slli and srai instructions to perform the sign extension.

Before this patch:
[   19.549705] test_bpf: #82 ALU_MOVSX | BPF_B jited:1 ret 2 != 1 (0x2 != 0x1)FAIL (1 times)
[   19.551354] test_bpf: #83 ALU_MOVSX | BPF_H jited:1 ret 2 != 1 (0x2 != 0x1)FAIL (1 times)
[   19.552576] test_bpf: #84 ALU64_MOVSX | BPF_B jited:1 ret 2 != 1 (0x2 != 0x1)FAIL (1 times)
[   19.553542] test_bpf: #85 ALU64_MOVSX | BPF_H jited:1 ret 2 != 1 (0x2 != 0x1)FAIL (1 times)
[   19.554807] test_bpf: #86 ALU64_MOVSX | BPF_W jited:1 ret 2 != 1 (0x2 != 0x1)FAIL (1 times)

After this patch:
[   17.931172] test_bpf: #82 ALU_MOVSX | BPF_B jited:1 125 PASS
[   17.932198] test_bpf: #83 ALU_MOVSX | BPF_H jited:1 124 PASS
[   17.933039] test_bpf: #84 ALU64_MOVSX | BPF_B jited:1 124 PASS
[   17.933918] test_bpf: #85 ALU64_MOVSX | BPF_H jited:1 124 PASS
[   17.934751] test_bpf: #86 ALU64_MOVSX | BPF_W jited:1 122 PASS

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Pu Lehui <pulehui@huawei.com>
Link: https://lore.kernel.org/bpf/20260714002451.4091139-3-visitorckw@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a real RV32 eBPF JIT miscompilation of an existing CPU-v4
instruction, not a new userspace API. On this 7.3-rc4 tree the RV32 JIT
and BPF_MOVSX ISA are both present, the patch is small and tested, and
it should be included.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: [riscv, bpf] [Add support] [RV32 JIT was compiling BPF_MOVSX as
a plain zero-extending MOV; emit slli/srai sign-extend when insn->off is
8/16/32]

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Reviewed-by: Pu Lehui <pulehui@huawei.com> (RISC-V BPF JIT reviewer;
  also authored RV64 MOVSX in 694896ad3ca79)
- Link: https://lore.kernel.org/bpf/20260714002451.4091139-3-
  visitorckw@gmail.com
- Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com> (author)
- Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com> (BPF
  maintainer, applied to bpf-next)
- No Fixes:, no Reported-by, no Cc: stable, no syzbot (absence expected)
- Ignore pipeline SOBs/Upstream markers: none present on the real commit
  c6a08afdfe3a8

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: RV32 JIT treats BPF_MOVSX as a normal zero-extended move. BPF
  reuses BPF_MOV with off=8/16/32 for sign-extending moves.
- Symptom: test_bpf cases #82–#86 fail with `jited:1 ret 2 != 1` (JIT
  ran, produced the wrong return).
- After: those five tests PASS.
- Root cause: `bpf_jit_emit_insn()` did not inspect `insn->off` on
  ALU/ALU64 MOV|X, so it fell through into `emit_alu_r64`/`emit_alu_r32`
  BPF_MOV (plain copy).
- No version range in the message. ISA support dates to v6.6-era
  (8100928c88148, 2023).

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Yes. The subject says “Add support”, but the body is explicit
miscompilation. Cover letter for the series: the JIT “ignor[es] the
instruction offset field and treat[s] them as unsigned or zero-
extended.” v1 was titled “Fix support…”. v2 added Fixes: tags; v3
“Remove the Fixes: tag and update title” for bpf-next process, not
because it stopped being a bug. Unlike patch 3/3 (atomics), which *does*
fall back to the interpreter, MOVSX is a supported opcode that emits the
wrong code.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `arch/riscv/net/bpf_jit_comp32.c` (+32 / −0)
- Function: `bpf_jit_emit_insn()` only
- Scope: single-file surgical JIT codegen

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Hunk 1 (`BPF_ALU64 | BPF_MOV | BPF_X`): before, always fell through to
  `emit_alu_r64()` which copies lo/hi. After, if `off != 0`, sign-extend
  lo (slli/srai 24 for byte, 16 for half, or copy lo for word) then
  `srai hi, lo, 31` to fill the upper 32 bits of the RV32 register pair.
- Hunk 2 (`BPF_ALU | BPF_MOV | BPF_X`): after the existing `imm == 1`
  zext special case, if `off != 0` sign-extend lo for off 8 or 16, then
  `bpf_put_reg32()` (which still zero-extends hi unless
  `verifier_zext`).
- Normal `off == 0` MOV is unchanged (`fallthrough`).

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: [Logic / correctness — JIT miscompilation]
- Broken: BPF_MOVSX shares the MOV opcode; offset was ignored, so sign-
  extend became a full register copy. test_bpf then compares against the
  sign-extended expected value and fails (`ret 2`).
- Fix: emit the same slli/srai pattern other 32-bit JITs use (see arm32
  `emit_a32_movsx_r64`).

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct relative to the ISA and to RV64 (`switch
(insn->off)` at bpf_jit_comp64.c:1408). Minimal. Regression risk is low:
only the previously-wrong `off != 0` path changes. ALU32 does not handle
off==32, which matches the ISA (MOVSX32 is 8 or 16 only). ALU64’s `else`
treats any other non-zero off as word sign-extend (off==32); the
verifier should not emit other values. No API/data-structure change.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record: The MOV|X fallthrough and `emit_alu_r64` BPF_MOV copy were
introduced in 5f316b65e99f1 (“riscv, bpf: Add RV32G eBPF JIT”, 2020,
v5.6). That was correct until BPF_MOVSX existed. ISA commit
8100928c88148 (“bpf: Support new sign-extension mov insns”,
v6.5-rc2-583, in 6.6). RV64 JIT got MOVSX in 694896ad3ca79 (2023). RV32
was left emitting the old MOV path until this commit.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: on the landed commit. v2 of the series had Fixes:
tags; they were dropped in v3 when the series was retitled for bpf-next.
The semantically “buggy” point is 8100928c88148 (MOVSX added, RV32 JIT
not updated). That commit is an ancestor of this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Same-day series on the same file:
- 2e0fa2389c50f — BPF_SDIV/SMOD (patch 1/3)
- c6a08afdfe3a8 — this commit (patch 2/3)
- a1b37972efc0b — 32-bit atomics (patch 3/3)
MOVSX does not use the SDIV `emit_alu_r32()` signature change and does
not use the atomic helper. Standalone.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Kuan-Wei Chiu’s only RV32 JIT work in this tree is this 3-patch
series. Reviewer Pu Lehui maintains RISC-V BPF JIT (RV64 MOVSX, later
kfunc sign-extend fix f2aaa62159109). Applied by Kartikeya. Strong
maintainer path.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Uses `bpf_get_reg64`/`bpf_put_reg64`/`bpf_get_reg32`/`bpf_put_re
g32`/`rv_slli`/`rv_srai`/`rv_addi` — all from the original 2020 JIT. No
new helpers. Can apply standalone.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- b4 dig:
  https://patch.msgid.link/20260714002451.4091139-3-visitorckw@gmail.com
- Series: bpf-next v1→v4, “signed operations and 32-bit atomics”
- v1 (2026-04-29): “Fix support for BPF_SDIV and BPF_SMOD”
- v2: “Add missing Fixes tags”
- v3: “Remove the Fixes: tag and update title”
- v4 (applied): this version
- No NAKs. Pu Lehui Reviewed-by on this patch; Tested-by on the series
  (test_bpf failures drop).
- No reviewer asked for Cc: stable.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: To/Cc included bpf@vger, linux-riscv, ast, daniel, andrii,
eddyz87, memxor, palmer, aou, pulehui, yonghong.song (original MOVSX ISA
author), alex@ghiti.fr. Appropriate lists. Applied by Kartikeya to bpf-
next.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No external bugzilla/syzbot. Evidence is in-tree
`lib/test_bpf.c` ALU_MOVSX tests (from daabb2b098e04, cpuv4 tests).
Failure is `jited:1` with wrong R0.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 3/3 series. 1/3 is the same class of bug (SDIV/SMOD as
unsigned). 3/3 is a feature (atomics already interpreter-fallback). This
patch does not depend on either.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org returned 403 to WebFetch. b4 mbox of the matched
thread has no stable@ discussion. UNVERIFIED: no independent
confirmation from lore.kernel.org/stable/.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**
Record: `bpf_jit_emit_insn()` (modified). Helpers used, not modified:
`bpf_get_reg64`, `bpf_put_reg64`, `bpf_get_reg32`, `bpf_put_reg32`,
`emit`.

**Step 5.2: TRACE CALLERS**
Record: `build_body()` in `arch/riscv/net/bpf_jit_core.c` calls
`bpf_jit_emit_insn()` for every instruction when a program is JIT-
compiled. That is the eBPF load/attach path (tracing, networking,
cgroup, seccomp, etc.), not init-only.

**Step 5.3: TRACE CALLEES**
Record: Emits RISC-V ALU (slli/srai/addi) and the existing stacked-
register get/put. No allocation, no locking.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: userspace bpf(2) / `BPF_PROG_LOAD` → verifier (accepts MOVSX
since 8100928c88148) → `bpf_int_jit_compile` → `build_body` →
`bpf_jit_emit_insn`. RISC-V selects `HAVE_EBPF_JIT if MMU`. JIT is used
when enabled; tests ran with `jited:1`. Reachable from program load.
Typically CAP_BPF/CAP_SYS_ADMIN; not a syzbot-style unprivileged UAF,
but verifier/JIT mismatch is still a sandbox correctness issue.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: RV64 already handled off 8/16/32 (694896ad3ca79). arm32:
fc832653fa0db then c6f48506ba30c. LoongArch had a later “Fix sign-
extension mov” (772cbe948fb07). Same bug class: MOV|X with nonzero off
must sign-extend.

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- Local tree: v7.3-rc4-27-gf0100363d8c37, `VERSION=7 PATCHLEVEL=3
  SUBLEVEL=0 EXTRAVERSION=-rc4`.
- RV32 JIT file exists; MOVSX macros exist in `include/linux/filter.h`;
  tests exist in `lib/test_bpf.c`.
- Commit c6a08afdfe3a8 *is* an ancestor of HEAD (landed in 7.3 via `bpf-
  next-7.3`, merge 5a8cd539ac19f). Not in v7.2.
- Without this change, the 2020 MOV fallthrough is still the codegen for
  MOVSX. The bug is in this lineage from 6.6 through 7.2.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply on this tree. Surrounding MOV cases and get/put
helpers match the patch. Expected difficulty: clean apply.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This is the RV32 MOVSX fix. No earlier substitute on
bpf_jit_comp32.c. RV64 already had support. No competing fix.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM**
Record: [arch/riscv BPF JIT] [IMPORTANT for RV32 + BPF users; PERIPHERAL
vs core mm/net — 32-bit RISC-V is a real but smaller population]

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Active enough (atomics, arena, CFI, kfunc sign-extend) but the
MOV path itself was untouched since 2020. Long-standing gap, not a
brand-new subsystem.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**
Record: RV32 kernels with eBPF JIT (HAVE_EBPF_JIT && MMU) running
programs that use CPU-v4 sign-extending moves (clang casts to
s8/s16/s32). Not universal; not staging.

**Step 8.2: TRIGGER CONDITIONS**
Record: Loading/attaching a BPF program that contains MOVSX, with JIT
on. Common for cpu v4 compiles. Privileged load in default configs. Not
a timing race. test_bpf reproduces it every run.

**Step 8.3: FAILURE MODE SEVERITY**
Record: [Wrong JIT results / verifier-vs-JIT mismatch] [HIGH]
- Not an oops/deadlock.
- JIT returns different register values than the interpreter and than
  the verifier’s sign-extended ranges (test: expected 1, got 2).
- If the verifier pruned a bounds check on the assumption that MOVSX
  ran, runtime can see a non-sign-extended value. That is BPF sandbox
  incorrectness, not a cosmetic test fail.

**Step 8.4: RISK-BENEFIT RATIO**
Record: Benefit high for RV32+BPF (correct JIT, closes verifier
mismatch). Risk very low (32 lines, one switch, existing emit helpers,
test_bpf before/after in the message, RISC-V BPF reviewer Tested-by).
Ratio favors taking it.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Concrete miscompilation: JIT runs and produces the wrong value
  (`jited:1 ret 2 != 1`).
- BPF_MOVSX has been in the ISA/verifier/interpreter since ~6.6; RV32
  JIT never honored `insn->off`.
- Interpreter is correct; only the JIT is wrong — classic “supported
  opcode, wrong codegen.”
- 32-line, single-function, no new APIs.
- Reviewed and tested by Pu Lehui; applied by BPF maintainer.
- Independent of the other two series patches.
- Helpers and MOV cases exist in this tree since 5.6.

AGAINST:
- Subject/process treated it as bpf-next “Add support”; Fixes: tags were
  deliberately removed in v3.
- RV32 is a smaller user base than RV64.
- Failure is wrong results, not a panic.
- Series patch 3/3 is a genuine feature (do not bundle it).

UNRESOLVED:
- Could not fetch lore.kernel.org/stable/ (HTTP 403). Thread mbox had no
  stable discussion.

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — slli/srai matches the ISA;
   test_bpf #82–#86; reviewer Tested-by.
2. Fixes a real bug that affects users? **PASS** — JIT’d MOVSX is wrong
   on RV32; userspace can load such programs.
3. Important issue? **PASS** — verifier/JIT mismatch on sign extension
   is sandbox/correctness, not a style issue. Severity HIGH, not a dead-
   code WARN.
4. Small and contained? **PASS** — +32 lines, one file, one function.
5. No new features or APIs? **PASS** — does not add a new opcode to BPF;
   it compiles an opcode the verifier already accepts. (Title is “Add
   support”; semantically it is fixing ignored `off`.)
6. Can apply to the local tree? **PASS** — file, helpers, and MOV cases
   are here.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary
correctness fix.

**Step 9.4: DECISION**
This tree is 7.3-rc4: it has the RV32 JIT and BPF_MOVSX. The bug is
“MOV|X ignores off,” which is user-visible wrong BPF execution and a
verifier/JIT disagreement. The patch is small, obviously correct,
tested, and self-contained. bpf-next dropping Fixes: is process, not a
finding that the codegen was fine. It should be backported to this tree.

### What it solves for stable users
RV32 eBPF JIT compiled sign-extending moves as ordinary copies. Any
JIT’d program using BPF_MOVSX (cpu v4 / compiler casts) gets wrong
register values. That breaks test_bpf and can disagree with verifier
range tracking.

### Risk vs benefit
Benefit: correct JIT and closed verifier mismatch on a real ISA
instruction. Risk: very low, localized ALU emit.

### Concerns
Do not pull series 3/3 (atomics feature). 1/3 (SDIV/SMOD) is the same
miscompilation class but is not required for this patch. No backport
rework needed on this tree.

Verification:
- [Phase 1] Tags: Reviewed-by Pu Lehui, Link lore/bpf, SOB author +
  Kartikeya; no Fixes/syzbot/Cc:stable
- [Phase 1] Body: test_bpf #82–#86 `jited:1 ret 2 != 1` before, PASS
  after
- [Phase 2] Diff: +32 in `bpf_jit_emit_insn()`, two MOV|X cases,
  slli/srai sign-extend
- [Phase 2] Confirmed `emit_alu_r64` BPF_MOV is lo/hi copy;
  `emit_alu_r32` BPF_MOV is lo copy (pre-fix path)
- [Phase 3] blame: MOV fallthrough from 5f316b65e99f1 (v5.6); ISA
  8100928c88148 (~6.6); RV64 694896ad3ca79
- [Phase 3] `git merge-base --is-ancestor c6a08afdfe3a8 HEAD` yes; not
  ancestor of v7.2; is ancestor of v7.3-rc1
- [Phase 3] Series patches 2e0fa2389c50f / c6a08afdfe3a8 /
  a1b37972efc0b; this one independent
- [Phase 4] `b4 dig -c c6a08afdfe3a8`: v4 2/3, msgid
  20260714002451.4091139-3
- [Phase 4] `b4 dig -a`: v1–v4; v3 removed Fixes: and retitled
- [Phase 4] `b4 dig -m`: 7 messages; Pu Lehui R-b/T-b; no NAK; no stable
  Cc
- [Phase 4] WebFetch lore: 403 — UNVERIFIED via HTTP; thread recovered
  via b4 mbox
- [Phase 5] Caller: `build_body()` → every JIT’d insn; `HAVE_EBPF_JIT if
  MMU`
- [Phase 5] Tests in lib/test_bpf.c ALU_MOVSX / ALU64_MOVSX
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4
- [Phase 6] bpf_jit_comp32.c and BPF_MOVSX64_REG present; helpers from
  original JIT
- [Phase 8] Failure: wrong JIT output / verifier mismatch, HIGH; not a
  panic
- UNVERIFIED: stable@ mailing list archive (HTTP 403)

**YES**

 arch/riscv/net/bpf_jit_comp32.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/riscv/net/bpf_jit_comp32.c b/arch/riscv/net/bpf_jit_comp32.c
index 89153946a4e46..39e2b0b907dc3 100644
--- a/arch/riscv/net/bpf_jit_comp32.c
+++ b/arch/riscv/net/bpf_jit_comp32.c
@@ -972,6 +972,24 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 
 	switch (code) {
 	case BPF_ALU64 | BPF_MOV | BPF_X:
+		if (insn->off != 0) {
+			const s8 *rd = bpf_get_reg64(dst, tmp1, ctx);
+			const s8 *rs = bpf_get_reg64(src, tmp2, ctx);
+
+			if (insn->off == 8) {
+				emit(rv_slli(lo(rd), lo(rs), 24), ctx);
+				emit(rv_srai(lo(rd), lo(rd), 24), ctx);
+			} else if (insn->off == 16) {
+				emit(rv_slli(lo(rd), lo(rs), 16), ctx);
+				emit(rv_srai(lo(rd), lo(rd), 16), ctx);
+			} else {
+				emit(rv_addi(lo(rd), lo(rs), 0), ctx);
+			}
+			emit(rv_srai(hi(rd), lo(rd), 31), ctx);
+			bpf_put_reg64(dst, rd, ctx);
+			break;
+		}
+		fallthrough;
 
 	case BPF_ALU64 | BPF_ADD | BPF_X:
 	case BPF_ALU64 | BPF_ADD | BPF_K:
@@ -1022,6 +1040,20 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 			emit_zext64(dst, ctx);
 			break;
 		}
+		if (insn->off != 0) {
+			const s8 *rd = bpf_get_reg32(dst, tmp1, ctx);
+			const s8 *rs = bpf_get_reg32(src, tmp2, ctx);
+
+			if (insn->off == 8) {
+				emit(rv_slli(lo(rd), lo(rs), 24), ctx);
+				emit(rv_srai(lo(rd), lo(rd), 24), ctx);
+			} else if (insn->off == 16) {
+				emit(rv_slli(lo(rd), lo(rs), 16), ctx);
+				emit(rv_srai(lo(rd), lo(rd), 16), ctx);
+			}
+			bpf_put_reg32(dst, rd, ctx);
+			break;
+		}
 		fallthrough;
 
 	case BPF_ALU | BPF_ADD | BPF_X:
-- 
2.53.0

