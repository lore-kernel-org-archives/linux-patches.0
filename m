Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88545293F8;
	Mon, 31 Aug 2026 13:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183877; cv=none; b=detrywcBmCQ8sYQ7xHSEEZQDgM5JwVqmxSTG7Sya/FADIUm/oVGRNYUtwTSXxHVmiQfSrazttEU31zV9k4plIwg4Dv+SZQxDmfu3TqhvGspcXhfwZLkJvpDRlo//GGEBvN6TPbM62jIDyOKlSY/jnnDPMwqEBmG0fUPVBNmzL8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183877; c=relaxed/simple;
	bh=qpWI73L8vgTIHGSXios1j7XIvTyywj6zMvBzUjPcgew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L3SzgYKMKmGmJ8yZwxXQecUiQ33BanFKY3lIJxxXcibYQneVfBrlqPt3hXX4T4okFvQ8X/oTtXb8R6qiJ6Gzs4pojjaInudkAZ3faJH0gFsxcvlEAGLcHBTixfA5coa4upERepVKihvCKd804guqQHG+pGW/v9Xzmbpkuq9dgaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ecSZE4T0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ecSZE4T0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D276A1F000E9;
	Mon, 31 Aug 2026 13:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183874;
	bh=uzD/bvx2wfiQnNSbs6W6Vc/o8YOP6CDwTRIrMxm6Vvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ecSZE4T0yIA/+uiMUq6s6uxwjnorPNhbFnOPsQkGCD0zziM3szpjruvDWTvgswSuI
	 /4TtVGeMfPneUSOF0VC6GnQ45itXuWGpzpECWeg/y2P3xbN4z0U5KLU3kkm8/MCkRZ
	 qPiE+B7Js6trrYd3YX7hw+NATysSRf/OwpYExs3ti5MHfIs+mz49bwyKoPyuVFWGQz
	 /S2tMo7AghYxpx47Dc8emV1qPburTR5CBdgue88ErBfGQ11QLyY5U1QIS6vbP7KxYd
	 jDm93LUJbB+Tqf0ds5ozOWtsa+9wJJVN11nbhMhr37CD9Fp8j/PmR4JltrOjINLdB3
	 i6FSKMvIU0uZQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rosen Penev <rosenp@gmail.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>,
	linux-mips@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] mips: cps: Assemble jr.hb with an R2 ISA level
Date: Mon, 31 Aug 2026 09:26:23 -0400
Message-ID: <20260831133314.4125787-355-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit e5d64f868e484da06f5c141c18c32c01c269625e ]

A MIPS allmodconfig built with LLVM can select CPU_MIPS32_R1 together
with MIPS_MT_SMP. In that configuration clang invokes the integrated
assembler with -march=mips32, and the MIPS MT path in cps-vec.S fails
to assemble two jr.hb instructions:

  arch/mips/kernel/cps-vec.S:376:2: error: instruction requires
  a CPU feature not currently enabled

  arch/mips/kernel/cps-vec.S:490:4: error: instruction requires
  a CPU feature not currently enabled

The earlier jr.hb in the same file is already assembled inside a .set
MIPS_ISA_LEVEL_RAW scope. The two failing sites are reached after
popping back to the file's base ISA level, so LLVM correctly rejects
them for an R1 target.

Wrap those jr.hb instructions in the same ISA-level push/pop used by
the working site. This keeps the MT code unchanged while making the
required R2 hazard-branch encoding explicit to the assembler.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Tree context

**Local tree:** Linux **6.18.44** (`git describe HEAD` → `v6.18.44`,
`make kernelversion` → `6.18.44`)

**Commit under review:** `e5d64f868e484` — *mips: cps: Assemble jr.hb
with an R2 ISA level* (mainline, 2026-05-26). **Not** an ancestor of
this tree (`git merge-base --is-ancestor` → exit 1). The unfixed code is
still present at lines 376 and 490 of `arch/mips/kernel/cps-vec.S`.

---

## Phase 1: Commit message forensics

**Step 1.1 — Subject parse**
Record: `[mips: cps]` `[assemble/wrap]` — Wrap two `jr.hb` instructions
in R2 ISA-level `.set push`/`.set pop` blocks so LLVM's integrated
assembler accepts them.

**Step 1.2 — Tags**
Record:
- `Assisted-by: Codex:GPT-5.5`
- `Signed-off-by: Rosen Penev <rosenp@gmail.com>`
- `Reviewed-by: Maciej W. Rozycki <macro@orcam.me.uk>`
- `Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>`
- No `Fixes:`, `Reported-by:`, `Link:`, `Cc: stable@vger.kernel.org`,
  `Tested-by:`

Notable: reviewed by a MIPS maintainer; merged by Thomas Bogendoerfer
(MIPS maintainer). LLVM toolchain folks were CC'd on the mailing list
thread.

**Step 1.3 — Body analysis**
Record:
- **Bug:** With `CPU_MIPS32_R1` + `MIPS_MT_SMP` (reachable via MIPS
  `allmodconfig`) and **LLVM/clang**, integrated assembler runs with
  `-march=mips32` (R1). Two `jr.hb` sites in `mips_cps_boot_vpes` fail
  assembly with *"instruction requires a CPU feature not currently
  enabled"* at lines 376 and 490.
- **Symptom:** Kernel **build failure** (assembler error), not a runtime
  crash.
- **Root cause:** Those `jr.hb` instructions sit outside `.set
  MIPS_ISA_LEVEL_RAW` scope after a `.set pop`; an earlier `jr.hb` in
  the same file (line 212) is correctly inside such a scope.
- **Fix approach:** Wrap each failing `jr.hb` in `.set push` / `.set
  MIPS_ISA_LEVEL_RAW` / `.set pop`, matching the working site.

**Step 1.4 — Hidden bug fix?**
Record: **Yes** — described as an assembly fix, but it is a real
**build-breaking bug** for a valid Kconfig combination with LLVM. Not
cosmetic.

---

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record:
- **File:** `arch/mips/kernel/cps-vec.S` (+6 lines, 0 removed)
- **Function:** `mips_cps_boot_vpes` (inside `#elif
  defined(CONFIG_MIPS_MT)` path)
- **Scope:** Single-file, surgical (2 hunks, 3 lines each)

**Step 2.2 — Code flow per hunk**

| Hunk | Before | After |
|------|--------|-------|
| Site 1 (~line 375) | After `dvpe` block's `.set pop`, `jr.hb t1`
assembled at file base ISA (R1 under LLVM) | `jr.hb` wrapped in
temporary R2 ISA scope |
| Site 2 (~line 489) | After VPE-exit `.set pop`, `jr.hb t0` at base ISA
| Same R2 scope wrapper |

Record: Both hunks affect the `CONFIG_MIPS_MT` boot-VPE path in
`mips_cps_boot_vpes`, reached during CPS SMP boot when MT is enabled.

**Step 2.3 — Bug mechanism**
Record: **Build / assembler ISA-level mismatch.** `jr.hb` is a Release 2
instruction. With `CPU_MIPS32_R1`, clang passes `-march=mips32` to the
integrated assembler. Without `.set MIPS_ISA_LEVEL_RAW`, LLVM rejects
`jr.hb`. This is not a runtime logic bug; emitted instructions are
unchanged for hardware that already supports MT (which implies R2).

**Step 2.4 — Fix quality**
Record:
- **Obviously correct:** Mirrors the existing working pattern at lines
  202–212 in `mips_cps_core_init`.
- **Minimal:** Only assembler directives added; no instruction sequence
  changes.
- **Regression risk:** Very low — scoped `.set push`/`.set pop` with no
  lock or control-flow changes.

---

## Phase 3: Git history investigation

**Step 3.1 — Blame**
Record: `git blame` in this stable checkout attributes all lines to an
unrelated amdgpu cherry-pick root (`7e22de67e545d`), so per-line
introduction dates are unreliable here. File header shows `cps-vec.S`
dates to 2013 (Paul Burton). The unwrapped `jr.hb` sites are long-
standing; the failure is exposed by LLVM's stricter ISA enforcement, not
by a recent regression in this tree.

**Step 3.2 — Fixes: tag**
Record: N/A — no `Fixes:` tag present.

**Step 3.3 — File history**
Record: `git log --oneline -20 -- arch/mips/kernel/cps-vec.S` shows only
the amdgpu commit (stable-tree history artifact). No prior fix for this
issue in this tree.

**Step 3.4 — Author context**
Record: Rosen Penev (regular contributor, often build/toolchain fixes).
Reviewed/merged by MIPS maintainers.

**Step 3.5 — Dependencies**
Record: **Standalone.** Single-patch series (v1 only). No prerequisite
commits. Patch context matches current file (verified programmatically —
both sites match).

---

## Phase 4: Mailing list and external research

**Step 4.1 — Original discussion**
Record:
- `b4 dig -c e5d64f868e484` →
  https://patch.msgid.link/20260507232323.489383-1-rosenp@gmail.com
- **Series:** v1 only (no later revisions)
- Thomas Bogendoerfer: *"applied to mips-next"*
- Maciej W. Rozycki: called the approach *"exceedingly pedantic"* but
  concluded *"your patch is not incorrect and fixes a real problem"* →
  `Reviewed-by:`
- **No explicit `Cc: stable` nomination** in thread
- **No NAKs**

**Step 4.2 — Reviewers**
Record: `b4 dig -w` — CC'd: `linux-mips@vger.kernel.org`, Thomas
Bogendoerfer, Nathan Chancellor, Nick Desaulniers, LLVM list, LKML.

**Step 4.3 — Bug report**
Record: N/A — no external bug tracker link. Failure described concretely
in commit message with assembler error text and line numbers.

**Step 4.4 — Related patches**
Record: Maciej noted a broader cleanup (wrap entire `CONFIG_MIPS_MT`
block, redefine `MIPS_ISA_LEVEL_RAW` per word size) as future work —
**not required** for this fix.

**Step 4.5 — Stable list**
Record: Not searched on lore stable list (no indication of prior stable
discussion). Absence of stable nomination is not a negative signal per
review instructions.

---

## Phase 5: Code semantic analysis

**Step 5.1 — Key functions**
Record: `mips_cps_boot_vpes` (assembly leaf in `cps-vec.o`)

**Step 5.2 — Callers**
Record: `cps-vec.o` is linked when `CONFIG_MIPS_CPS=y`
(`arch/mips/kernel/Makefile:61`). `mips_cps_boot_vpes` is part of CPS
secondary-core/VPE boot vector code — early boot, not userspace-
reachable, but required for SMP bring-up on CPS platforms.

**Step 5.3 — Callees**
Record: MT ASE coprocessor ops (`dvpe`, `evpe`, `mfc0`/`mtc0` on
MVPCONTROL/VPECONTROL/TCHALT). Fix only changes assembler ISA scope
around `jr.hb`.

**Step 5.4 — Reachability**
Record: Code is compiled when `CONFIG_MIPS_CPS` and `CONFIG_MIPS_MT`
(selected by `CONFIG_MIPS_MT_SMP`) are both enabled. Trigger for the
**bug** is at **compile time** with LLVM + `CPU_MIPS32_R1`, not at
runtime.

**Step 5.5 — Similar patterns**
Record: Same file line 212 (`mips_cps_core_init`) already wraps `jr.hb`
inside `.set MIPS_ISA_LEVEL_RAW`. `arch/mips/kernel/entry.S`
(`mips_ihb`) uses the same pattern. The two failing sites were
inconsistent with established local convention.

---

## Phase 6: Cross-reference against local tree (6.18.44)

**Step 6.1 — Buggy code present?**
Record: **YES.** Lines 376 and 490 have bare `jr.hb` outside `.set
MIPS_ISA_LEVEL_RAW` scope. Fix commit is **not** in this tree.

**Step 6.2 — Backport complications**
Record: **Clean apply expected.** Both patch contexts match current file
content exactly. No conflicting changes detected.

**Step 6.3 — Related fixes already present?**
Record: **None found** in this tree for this issue.

---

## Phase 7: Subsystem and maintainer context

**Step 7.1 — Subsystem**
Record: **arch/mips** — platform-specific boot/SMP assembly.
Criticality: **IMPORTANT** for MIPS CPS+MT SMP platforms and for anyone
building MIPS kernels; not universal like mm/net, but affects real
builders and CI.

**Step 7.2 — Activity**
Record: MIPS CPS/MT code is mature; this is a toolchain compatibility
fix on existing code.

---

## Phase 8: Impact and risk assessment

**Step 8.1 — Who is affected**
Record: **Config-specific builders** — MIPS kernels with
`CONFIG_MIPS_CPS` + `CONFIG_MIPS_MT_SMP` + `CPU_MIPS32_R1`, built with
**LLVM/clang**. Typical trigger: `allmodconfig` CI builds; also any
distro/toolchain vendor using clang for MIPS.

**Step 8.2 — Trigger conditions**
Record:
- **When:** At kernel **build** time (assembler phase)
- **How common:** Uncommon for production defconfigs (most CPS platforms
  use R2+), but **common in kernel CI** (`allmodconfig`) and
  increasingly relevant as LLVM MIPS support grows
- **Userspace trigger:** No — not a runtime/security issue

**Step 8.3 — Failure mode severity**
Record: **Build failure** (hard assembler error) — severity **MEDIUM**
for stable (blocks compilation; no runtime crash, no data corruption, no
security exposure).

**Step 8.4 — Risk/benefit**
Record:
- **Benefit:** Unblocks LLVM MIPS builds for valid configurations;
  aligns with growing clang/LLVM kernel build support
- **Risk:** Very low (6 assembler-directive lines, no logic change)
- **Ratio:** Favorable — classic low-risk build fix

---

## Phase 9: Final synthesis

**Evidence FOR backport:**
- Fixes a **real, reproducible build failure** (documented assembler
  errors)
- Falls under stable **BUILD FIX** exception category
- Small, surgical, maintainer-reviewed
- Buggy code exists in 6.18.44; patch applies cleanly
- Standalone, no dependencies
- Matches established pattern already used in the same file

**Evidence AGAINST backport:**
- Only affects a **niche Kconfig** (`allmodconfig` + R1 + MT_SMP + CPS +
  LLVM)
- **No runtime user impact** on already-built/deployed kernels
- Reviewer noted a cleaner long-term approach exists (not blocking)

**Stable rules checklist:**
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — mirrors working site;
Reviewed-by maintainer |
| 2. Fixes real bug affecting users? | **PASS** — blocks kernel
compilation for valid config |
| 3. Important issue? | **PASS** (moderate) — build fix, not
crash/corruption |
| 4. Small and contained? | **PASS** — 6 lines, 1 file |
| 5. No new features/APIs? | **PASS** — assembler directives only |
| 6. Can apply to local tree? | **PASS** — context verified |

**Exception category:** **BUILD FIX** (#4 in stable exceptions)

---

## Verification

- [Phase 1] `git show e5d64f868e484` — parsed full commit message and
  tags
- [Phase 1] Tags: Reviewed-by Maciej W. Rozycki; no Fixes/Reported-
  by/Cc:stable
- [Phase 2] Read `arch/mips/kernel/cps-vec.S` lines 198–495 — confirmed
  two bare `jr.hb` vs wrapped site at 212
- [Phase 2] Read `arch/mips/include/asm/compiler.h` —
  `MIPS_ISA_LEVEL_RAW` defined as mips64r2/r5/r6 per CPU config
- [Phase 3] `git blame` — unreliable in this stable tree (all lines →
  unrelated root commit)
- [Phase 3] `git merge-base --is-ancestor e5d64f868e484 HEAD` → exit 1
  (fix not in 6.18.44)
- [Phase 3] Python context match — both patch sites match current file
- [Phase 4] `b4 dig -c e5d64f868e484` — lore URL found
- [Phase 4] `b4 dig -a` — v1 only, no later revisions
- [Phase 4] `b4 dig -w` — MIPS maintainer and LLVM folks CC'd
- [Phase 4] `b4 dig -m /tmp/cps-jr-hb.mbx` — Thomas applied; Maciej
  Reviewed-by, noted "fixes a real problem"
- [Phase 5] `grep jr.hb arch/mips` — 3 sites in cps-vec.S; entry.S uses
  same `.set MIPS_ISA_LEVEL_RAW` pattern
- [Phase 5] `arch/mips/kernel/Makefile:61` — cps-vec.o built with
  CONFIG_MIPS_CPS
- [Phase 6] `git describe HEAD` / `make kernelversion` — tree is 6.18.44
- [Phase 6] Buggy code confirmed present at lines 376, 490
- [Phase 6] `arch/mips/Kconfig` — MIPS_MT_SMP and MIPS_CPS are
  independently selectable options
- [Phase 8] Failure mode: assembler error at build time, severity MEDIUM

---

## Conclusion

For **Linux 6.18.44**, this commit fixes a legitimate LLVM/clang build
breakage in MIPS CPS+MT SMP assembly code. It is small, maintainer-
reviewed, applies cleanly, and matches an established in-file pattern.
While the affected configuration is niche and the failure is at build
time rather than runtime, **build fixes are explicitly appropriate for
stable trees**, and LLVM support is increasingly important for kernel
builds.

**YES**The analysis is done for **Linux 6.18.44**.

**Commit:** `e5d64f868e484` — *mips: cps: Assemble jr.hb with an R2 ISA
level*

**Problem:** With LLVM/clang and `CPU_MIPS32_R1` + `MIPS_MT_SMP` (e.g.
MIPS `allmodconfig`), two `jr.hb` instructions in `arch/mips/kernel/cps-
vec.S` fail assembly because they sit outside a `.set
MIPS_ISA_LEVEL_RAW` scope.

**Fix:** Wrap those two sites in the same ISA-level push/pop used
elsewhere in the file (+6 lines, one file). Reviewed by Maciej W.
Rozycki; applies cleanly to this tree; the unfixed code is still present
in 6.18.44.

**Verdict:** **YES** — small, maintainer-reviewed build fix with very
low risk.

 arch/mips/kernel/cps-vec.S | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/mips/kernel/cps-vec.S b/arch/mips/kernel/cps-vec.S
index 2ae7034a3d5c4..70413c816eb03 100644
--- a/arch/mips/kernel/cps-vec.S
+++ b/arch/mips/kernel/cps-vec.S
@@ -373,8 +373,11 @@ LEAF(mips_cps_boot_vpes)
 	.set	pop
 
 	PTR_LA	t1, 1f
+	.set	push
+	.set	MIPS_ISA_LEVEL_RAW
 	jr.hb	t1
 	 nop
+	.set	pop
 1:	mfc0	t1, CP0_MVPCONTROL
 	ori	t1, t1, MVPCONTROL_VPC
 	mtc0	t1, CP0_MVPCONTROL
@@ -487,8 +490,11 @@ LEAF(mips_cps_boot_vpes)
 	li	t0, TCHALT_H
 	mtc0	t0, CP0_TCHALT
 	PTR_LA	t0, 1f
+	.set	push
+	.set	MIPS_ISA_LEVEL_RAW
 1:	jr.hb	t0
 	 nop
+	.set	pop
 
 2:
 
-- 
2.53.0

