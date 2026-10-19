Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A111C56761C;
	Mon, 19 Oct 2026 13:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418261; cv=none; b=fH/Tv5oI/7CDtqaw0h0F0e5dXyvJKs2ns8OT4Fj4PfC0c6Ymc+AIhIJkdDzLAN6MQ03mxMw97DotbEvPgrPhq5m4ky3dKTYVLooGv4mogsJXxRP2gOdaqEKikw3MBtu/uO59PA+QFCpucHQv/8ymiRTd7KK/HPv2UPupwv+Sv7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418261; c=relaxed/simple;
	bh=mVu/VZ5070a8W1qqcSIftbIH/POy+fY8wJoWqo21vOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bTJ+Dd6yg3rbxDVNNO+1NShB5F2jvIS2vOKnQF3NZMXUuT1DAjlIWD6e7NT3djSqGCngRWMgTQUyNgHDTgqat+SBcVQF6HscD1OOvqgebCMmFKTiWynQlbIi2TPPFCR70auxaKnhS8PTDQKWU8iYMOuz+dPV2ia0oTPwjD0hv88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YHl5R+GI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YHl5R+GI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB7E1F000C9;
	Mon, 19 Oct 2026 13:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418259;
	bh=7tglQ4SuEKiErpdWAuNWDMl5ZXFyXLnC3VVhBZBHVVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YHl5R+GIUox6T9jGfx6o40DLZf8BBP/rkbYxSa6piueEkRm2OY5KQ6LhCKl/Cw9rk
	 9TGaTB9vKZ6UOnkJz1/a/Sfs62ZuNtj3CZwt36q67ncoNZTUJVbHoXuWzJk8OT05WE
	 4ssjLY4VcCpYMCEYiZsVr8e08gy36sLLZs4lCEia18glhpav7aacnP4eyuB1mSOUu/
	 qLpzzGKnUdQYZt54lqC/edKbDkTWXvuP7SIEQ4kUu8tYfnAjw1uxPmQk76dNEWsdOB
	 Fgf+RtC/MCkXE0xYaNQRg/ZrkeQPG+5XGK4ipuQwO7NhKh6tWX0MuqW3URxH4KRcor
	 tjlrTddPJMINg==
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
Subject: [PATCH AUTOSEL 6.18-5.10] riscv, bpf: Add support for BPF_SDIV and BPF_SMOD in RV32 JIT
Date: Mon, 19 Oct 2026 09:46:56 -0400
Message-ID: <20261019135441.1420968-125-sashal@kernel.org>
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

[ Upstream commit 2e0fa2389c50fd3a69bb738efa74e127b7516938 ]

The current rv32 bpf jit compiler incorrectly treats BPF_SDIV and
BPF_SMOD as unsigned operations. The BPF instruction set allows
signed division and modulo by reusing the BPF_DIV and BPF_MOD opcodes
with the instruction offset set to 1.

Update the emit_alu_r32() function to accept an 'is_sdiv' variable and
emit the correct div and rem instructions when the offset is 1.

Before this patch:
[   44.161771] test_bpf: #165 ALU_SDIV_X: -6 / 2 = -3 jited:1 ret 2147483645 != -3 (0x7ffffffd != 0xfffffffd)FAIL (1 times)
[   44.167385] test_bpf: #166 ALU_SDIV_K: -6 / 2 = -3 jited:1 ret 2147483645 != -3 (0x7ffffffd != 0xfffffffd)FAIL (1 times)
[   44.171053] test_bpf: #169 ALU_SMOD_X: -7 % 2 = -1 jited:1 ret 1 != -1 (0x1 != 0xffffffff)FAIL (1 times)
[   44.172081] test_bpf: #170 ALU_SMOD_K: -7 % 2 = -1 jited:1 ret 1 != -1 (0x1 != 0xffffffff)FAIL (1 times)

After this patch:
[   16.002192] test_bpf: #165 ALU_SDIV_X: -6 / 2 = -3 jited:1 95 PASS
[   16.002983] test_bpf: #166 ALU_SDIV_K: -6 / 2 = -3 jited:1 1059 PASS
[   16.017167] test_bpf: #169 ALU_SMOD_X: -7 % 2 = -1 jited:1 136 PASS
[   16.023002] test_bpf: #170 ALU_SMOD_K: -7 % 2 = -1 jited:1 109 PASS

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Pu Lehui <pulehui@huawei.com>
Link: https://lore.kernel.org/bpf/20260714002451.4091139-2-visitorckw@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
Record: `[riscv, bpf] [Add support] Treat BPF_SDIV/BPF_SMOD as signed in
the RV32 JIT, not as unsigned DIV/MOD.`

**Step 1.2 — Tags**
Record:
- Reviewed-by: Pu Lehui `<pulehui@huawei.com>` (RISC-V BPF JIT reviewer;
  author of the RV64 signed-div JIT)
- Link: `https://lore.kernel.org/bpf/20260714002451.4091139-2-
  visitorckw@gmail.com`
- Signed-off-by: Kuan-Wei Chiu (author)
- Signed-off-by: Kumar Kartikeya Dwivedi (BPF maintainer, applied to
  bpf-next)
- No Fixes:, no Cc: stable, no Reported-by, no Tested-by on the commit
  itself (Tested-by: Pu Lehui is on the series cover)
- Absence of Fixes/Cc: stable is expected for this review and is not a
  negative signal

**Step 1.3 — Body**
Record: The RV32 JIT emits `divu`/`remu` for `BPF_DIV`/`BPF_MOD` even
when `insn->off == 1` (the BPF encoding for signed div/mod). Symptom is
silent wrong results with the program still marked JIT’d (`jited:1`):
`-6 / 2` → `2147483645` instead of `-3`; `-7 % 2` → `1` instead of `-1`.
Root cause: offset field ignored. After: those `test_bpf` cases PASS.

**Step 1.4 — Hidden bug fix?**
Record: Yes. Title says “Add support”, but this is a JIT miscompilation
fix. The JIT already handles DIV/MOD; it just uses the unsigned RISC-V
ops. Cover-letter v3 dropped a Fixes: tag and retitled the series as
enablement; that is framing, not a lack of a bug.

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record: One file, `arch/riscv/net/bpf_jit_comp32.c`, +10/−5. Functions:
`emit_alu_r32()` (signature + DIV/MOD cases), `bpf_jit_emit_insn()` (two
call sites). Surgical, single-file.

**Step 2.2 — Flow**
Record:
- Before: `emit_alu_r32(..., u8 op)` always emits `rv_divu` / `rv_remu`.
- After: it takes `const struct bpf_insn *insn`, sets `is_signed =
  insn->off == 1`, and emits `rv_div`/`rv_rem` vs `rv_divu`/`rv_remu`.
- Callers pass `insn` instead of `BPF_OP(code)`. Both register (`BPF_X`)
  and immediate (`BPF_K`) 32-bit DIV/MOD already go through this path
  (no RISC-V I-type div).
- 64-bit DIV/MOD on RV32 still `goto notsupported` (interpreter
  fallback). This patch does not touch that path.

**Step 2.3 — Bug mechanism**
Record: Logic/correctness. Signed vs unsigned opcode selected by
`insn->off`. Not a leak, race, or UAF.

**Step 2.4 — Fix quality**
Record: Obviously correct and minimal. Regression risk is low: unsigned
path is unchanged when `off == 0`; signed ops are the matching RISC-V
M-extension instructions. No API or data-structure change. Minor nit:
commit text says an `is_sdiv` argument; the code uses `is_signed` from
`insn->off`. Harmless.

## Phase 3: Git history

**Step 3.1 — Blame**
Record: Unsigned `rv_divu`/`rv_remu` in `emit_alu_r32` come from
`5f316b65e99f` (“riscv, bpf: Add RV32G eBPF JIT”, 2020-03,
**v5.7-rc1**). At that time BPF had no signed div. The encoding (`off ==
1`) landed in `ec0e2da95f72d` (“bpf: Support new signed div/mod
instructions.”, 2023-07, **v6.6-rc1**), which updated the interpreter
and x86 JIT only. RV64 JIT followed in `3e18ff4bce9b5` (**v6.6-rc1**).
RV32 stayed on unsigned emit until this commit.

**Step 3.2 — Fixes: tag**
Record: None on the landed commit. v1/v2 had a Fixes: tag; v3 removed
it. CI bot later suggested `Fixes: 5f316b65e99f`; Pu Lehui replied that
a Fixes tag was not needed. That objection is about blaming the 2020 JIT
(which was correct then), not about whether today’s unsigned emit is
wrong.

**Step 3.3 — File history / series**
Record: bpf-next v4 1/3 of “signed operations and 32-bit atomics”:
1. this SDIV/SMOD patch (`2e0fa2389c50f`)
2. BPF_MOVSX (`c6a08afdfe3a8`)
3. 32-bit atomics (`a1b37972efc0b`)

This patch does not depend on 2 or 3. Merge: `426a6befd01f9`.

**Step 3.4 — Author**
Record: Kuan-Wei Chiu; not the RV32 JIT original author. Nearby work is
this series only. Reviewer Pu Lehui is the established RISC-V BPF JIT
contributor.

**Step 3.5 — Prerequisites**
Record: Needs `rv_div()` / `rv_rem()` in `arch/riscv/net/bpf_jit.h`
(added by `3e18ff4bce9b5`, present here). Needs `emit_alu_r32` and
32-bit DIV/MOD cases (present since v5.7). Standalone on this tree.

## Phase 4: Mailing list

**Step 4.1 — Original discussion**
Record: Lore from `b4 dig`:
`https://patch.msgid.link/20260714002451.4091139-2-visitorckw@gmail.com`
Revisions: v3 (2026-07-06) and v4 (2026-07-14). v3 changelog: pass
`insn` into `emit_alu_r32`; **remove Fixes: tag and update title**.
Applied version is v4 (latest). No NAK on this patch. No Cc: stable in
the thread.

**Step 4.2 — Recipients**
Record: bpf@vger, linux-riscv, ast, daniel, andrii, eddyz87, memxor,
palmer, aou, pulehui, martin.lau, yonghong.song, alex@ghiti.fr. Right
lists and maintainers. Reviewed-by Pu Lehui; applied by Kumar Kartikeya
Dwivedi.

**Step 4.3 — Bug report**
Record: No syzbot/bugzilla. Evidence is in-tree `test_bpf` (#165, #166,
#169, #170) plus Pu Lehui Tested-by on the cover. Cover also notes
`test_bpf.ko` going to 0 failures on the author’s setup.

**Step 4.4 — Series**
Record: 1/3 is this fix. 2/3 (MOVSX) and 3/3 (atomics) are separate ISA-
coverage patches. 3/3 is closer to a feature (more JIT’d atomics;
interpreter already worked). This patch is self-contained.

**Step 4.5 — stable@**
Record: UNVERIFIED. lore.kernel.org returned 403 to HTTP fetch; the
saved mboxes have no stable@ nomination.

## Phase 5: Semantic analysis

**Step 5.1 — Functions**
Record: `emit_alu_r32`, `bpf_jit_emit_insn`.

**Step 5.2 — Callers**
Record: `emit_alu_r32` is only called from `bpf_jit_emit_insn` (ALU
32-bit X/K DIV/MOD/MUL/shifts, and NEG). `bpf_jit_emit_insn` is called
from `arch/riscv/net/bpf_jit_core.c` during JIT of a loaded BPF program.

**Step 5.3 — Callees**
Record: `bpf_get_reg32` / `bpf_put_reg32`,
`rv_div`/`rv_divu`/`rv_rem`/`rv_remu`. No new locks or allocations.

**Step 5.4 — Reachability**
Record: Yes, from BPF program load on RV32 with `CONFIG_BPF_JIT`
(`HAVE_EBPF_JIT if MMU`). Userspace that can load BPF (privileged; or
unprivileged if enabled) can hit it. `lib/test_bpf.c` exercises it
directly. With `BPF_JIT_ALWAYS_ON`, interpreter fallback is gone and a
wrong JIT is the only path.

**Step 5.5 — Similar patterns**
Record: RV64 already branched on signed vs unsigned in
`bpf_jit_comp64.c`. Interpreter in `kernel/bpf/fixups.c` uses `insn->off
== 1` the same way. ARM32 added 32-bit signed div in `5097faa559a60`
(v6.7-rc1). RV32 64-bit SDIV is still not JIT’d (`notsupported`) —
different, safe fallback.

## Phase 6: Local tree (this checkout)

**Step 6.1 — Does the buggy code exist here?**
Record: Local tree is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). RV32
JIT, signed-div ISA, and `rv_div`/`rv_rem` are all present. The
unsigned-only emit existed in this lineage from v6.6 until
`2e0fa2389c50f` (contained in **v7.3-rc1**). Current `emit_alu_r32`
already has `is_signed = insn->off == 1`. The bug class is in this
tree’s history; the file this patch touches is here.

**Step 6.2 — Backport difficulty**
Record: Clean apply on this code. Pre-image matches the parent of
`2e0fa2389c50f`. Helpers already exist.

**Step 6.3 — Related fixes already here**
Record: This commit is already an ancestor of HEAD (landed in 7.3-rc1).
That is origin-tree presence, not a reason to treat it as “already
selected for stable.” No alternate RV32 SDIV fix. Later series patches
(MOVSX, atomics) are independent.

## Phase 7: Subsystem context

**Step 7.1**
Record: `arch/riscv/net` BPF JIT. Criticality: **PERIPHERAL** for
hardware (RV32 Linux with MMU), **IMPORTANT** for correctness of JIT’d
BPF on that platform. Makefile: `bpf_jit_comp32.o` only when not
`CONFIG_ARCH_RV64I`.

**Step 7.2**
Record: File is mature (since v5.7) with occasional ISA catch-up. Not a
staging driver.

## Phase 8: Impact and risk

**Step 8.1 — Who**
Record: RV32 + BPF JIT users (embedded RISC-V with MMU). Not RV64. Not
no-MMU (no eBPF JIT).

**Step 8.2 — Trigger**
Record: Loading/running a BPF program that uses 32-bit signed DIV or MOD
(`off == 1`). Common in `test_bpf`; less common in production filters,
but a valid ISA op since v6.6. Typically requires BPF-load privilege.

**Step 8.3 — Failure mode**
Record: Silent wrong ALU result while still reporting `jited:1`. Not a
panic. Wrong packet/cgroup/seccomp decisions are possible if a program
uses signed div. Severity: **HIGH** for correctness, not CRITICAL
crash/corruption of kernel memory.

**Step 8.4 — Risk/benefit**
Record: Benefit: correct 32-bit signed div/mod on RV32 JIT; `test_bpf`
failures gone. Risk: very low (~10 lines, ALU emit only, unsigned path
unchanged). Ratio: favorable.

## Phase 9: Synthesis

**Evidence FOR**
- JIT emits unsigned ops for a signed encoding; programs get wrong
  answers and still count as JIT’d.
- Reproduced by `test_bpf`; reviewed and tested by Pu Lehui.
- Small, obviously correct, no new UAPI.
- Independent of the rest of the series.
- All helpers and call sites exist in this tree.
- Same class of ISA handling RV64 and the interpreter already do.

**Evidence AGAINST**
- Subject/cover are “Add support”; sent to bpf-next, not bpf.
- Maintainer said a Fixes tag was not needed (“not a bugfix”) — aimed at
  the 2020 JIT commit, which predates signed div.
- RV32 is a small user base; 64-bit SDIV still not JIT’d (safe
  fallback).
- Not a crash, deadlock, or kernel memory-safety bug.

**Unresolved**
- UNVERIFIED: whether stable@ ever discussed this (lore HTTP 403).
- UNVERIFIED: exact v1/v2 subject/Fixes SHA (v3 changelog confirms a
  Fixes tag was removed).

**Stable rules**
1. Obviously correct and tested? **PASS** — review + `test_bpf`
   before/after + Tested-by.
2. Real bug affecting users? **PASS** — wrong JIT output for a valid
   insn, not a new opcode.
3. Important? **PASS** — silent miscompilation of ALU; high correctness
   impact, not a panic.
4. Small and contained? **PASS** — one file, ~10 lines.
5. No new features/APIs? **PASS** — selects existing RISC-V `div`/`rem`
   when `off==1`; BPF ISA already has this encoding.
6. Applies to this tree? **PASS** — file, helpers, and DIV/MOD path are
   here.

**Exception category:** none (not an ID/quirk/DT/build/doc patch).

The “add support” wording is leftover from a feature series. Behavior is
a JIT bug: the compiler accepts SDIV/SMOD and emits the wrong RISC-V
instruction. That is appropriate for this tree.

Verification:
- [Phase 1] Parsed tags: Reviewed-by Pu Lehui; Link to bpf lore; no
  Fixes/Cc: stable/Reported-by
- [Phase 1] Body documents `test_bpf` #165/#166/#169/#170 wrong results
  with `jited:1`
- [Phase 2] Diff: `emit_alu_r32` takes `insn`; `is_signed = insn->off ==
  1`; `rv_div`/`rv_rem` vs `divu`/`remu`; two call-site updates
- [Phase 2] Confirmed 64-bit DIV/MOD still `goto notsupported` (no
  incomplete 64-bit signed path)
- [Phase 3] `git blame` on parent: unsigned emit from `5f316b65e99f`
  (v5.7-rc1)
- [Phase 3] `ec0e2da95f72d` added signed div ISA in v6.6-rc1; RV64 JIT
  `3e18ff4bce9b5` same cycle
- [Phase 3] `git describe --contains 2e0fa2389c50f` → `v7.3-rc1~...`;
  `git merge-base --is-ancestor` confirms it is in HEAD
- [Phase 3] Series 2/3 and 3/3 are independent; no prerequisite besides
  `rv_div`/`rv_rem` (present)
- [Phase 4] `b4 dig -c 2e0fa2389c50f`: patch-id match; v3 and v4;
  applied v4 1/3
- [Phase 4] `b4 dig -w`: bpf + linux-riscv + BPF/RISC-V maintainers
- [Phase 4] v3 mbox: CI suggested Fixes: 5f316b65e99f; Pu Lehui: “not
  need to add fixes tag, as this not a bugfix”; Pu Reviewed-by on the
  code
- [Phase 4] Cover: “Remove the Fixes: tag and update title”; Tested-by
  Pu Lehui
- [Phase 4] WebFetch lore: 403 Forbidden — discussion taken from b4
  mboxes instead
- [Phase 5] Callers: only `bpf_jit_emit_insn`; JIT compile path from
  `bpf_jit_core.c`
- [Phase 5] `lib/test_bpf.c` has ALU_SDIV_* / ALU_SMOD_* cases matching
  the commit
- [Phase 6] `make kernelversion` / `git describe HEAD`: 7.3.0-rc4 /
  v7.3-rc4-27-gf0100363d8c37
- [Phase 6] `arch/riscv/net/Makefile`: comp32 used when not RV64I;
  `HAVE_EBPF_JIT if MMU`
- [Phase 6] Current file already has the signed emit (commit ancestor of
  HEAD)
- [Phase 8] Failure mode: wrong 32-bit signed div/mod in JIT’d BPF;
  severity HIGH correctness
- UNVERIFIED: stable@ mailing list history (lore 403)

The patch is a small, tested JIT correctness fix for a real miscompile
on RV32. It meets stable rules for this tree.

**YES**

 arch/riscv/net/bpf_jit_comp32.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp32.c b/arch/riscv/net/bpf_jit_comp32.c
index 592dd86fbf811..89153946a4e46 100644
--- a/arch/riscv/net/bpf_jit_comp32.c
+++ b/arch/riscv/net/bpf_jit_comp32.c
@@ -509,12 +509,15 @@ static void emit_alu_r64(const s8 *dst, const s8 *src,
 }
 
 static void emit_alu_r32(const s8 *dst, const s8 *src,
-			 struct rv_jit_context *ctx, const u8 op)
+			 struct rv_jit_context *ctx,
+			 const struct bpf_insn *insn)
 {
 	const s8 *tmp1 = bpf2rv32[TMP_REG_1];
 	const s8 *tmp2 = bpf2rv32[TMP_REG_2];
 	const s8 *rd = bpf_get_reg32(dst, tmp1, ctx);
 	const s8 *rs = bpf_get_reg32(src, tmp2, ctx);
+	u8 op = BPF_OP(insn->code);
+	bool is_signed = insn->off == 1;
 
 	switch (op) {
 	case BPF_MOV:
@@ -539,10 +542,12 @@ static void emit_alu_r32(const s8 *dst, const s8 *src,
 		emit(rv_mul(lo(rd), lo(rd), lo(rs)), ctx);
 		break;
 	case BPF_DIV:
-		emit(rv_divu(lo(rd), lo(rd), lo(rs)), ctx);
+		emit(is_signed ? rv_div(lo(rd), lo(rd), lo(rs)) :
+				 rv_divu(lo(rd), lo(rd), lo(rs)), ctx);
 		break;
 	case BPF_MOD:
-		emit(rv_remu(lo(rd), lo(rd), lo(rs)), ctx);
+		emit(is_signed ? rv_rem(lo(rd), lo(rd), lo(rs)) :
+				 rv_remu(lo(rd), lo(rd), lo(rs)), ctx);
 		break;
 	case BPF_LSH:
 		emit(rv_sll(lo(rd), lo(rd), lo(rs)), ctx);
@@ -1041,7 +1046,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 			emit_imm32(tmp2, imm, ctx);
 			src = tmp2;
 		}
-		emit_alu_r32(dst, src, ctx, BPF_OP(code));
+		emit_alu_r32(dst, src, ctx, insn);
 		break;
 
 	case BPF_ALU | BPF_MOV | BPF_K:
@@ -1065,7 +1070,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		 * src is ignored---choose tmp2 as a dummy register since it
 		 * is not on the stack.
 		 */
-		emit_alu_r32(dst, tmp2, ctx, BPF_OP(code));
+		emit_alu_r32(dst, tmp2, ctx, insn);
 		break;
 
 	case BPF_ALU | BPF_END | BPF_FROM_LE:
-- 
2.53.0

