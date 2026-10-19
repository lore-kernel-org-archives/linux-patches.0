Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411E94FC330;
	Mon, 19 Oct 2026 14:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418745; cv=none; b=s5CqgDxMn6aTB1A9eYt7aBFqWoaBv4EBdrKEEtmUsU/FZHelg1lzASl48xG/GrcHrplwWmqmEcyECcHVhJYTyf9CwSOcLvoqycZvzARAn0pToo9SEdnbb3jFLVsl3H/fxIvg+zz5xtARwDgCFaEA+mQajzljDPkpSifD2eotglY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418745; c=relaxed/simple;
	bh=/jn0gULFWbMrwJjmayeNpkDr63HxLyEcKNnDZCIm2Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PrwiLz391RuQA6ikUOb6TLr/LF+X1zRqhtYvlhR5hwN9LapiDPUjaKJ6XyqI29ZFJ+xTwkF0hpNjplDZ3ms9AWM3JhYROfcuZtiKumsPigMMjNlKXGUdeNUU4NylZ58o7545EikiKdV0r1r5QqqHCGaTd3JiGRr26bRAoXS1apc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eRZ3wlGL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eRZ3wlGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E901F000C5;
	Mon, 19 Oct 2026 14:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418742;
	bh=vAjPh0K/1xcc1UTcvd4vlu2Zj2eAFfcETHWsmqpxz3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eRZ3wlGLO3BU1O0vvlpNY8ddCzRqkBWvP/1jPaQHXSe8m8rs9pxaHRGyWskr7eIxn
	 bQUbqeQLse0wDzV2lvnMe6vosEl+WtrMdxy9m/5JVVfRaXhjyw88qOMeT6iFGwxeTO
	 6UM/Rg2aruyoIWGsWnmr8wa10bXaSbDFO5iXsDbDyRPvXey2JOm+zeYTTtVWzFXfcV
	 QQ7KBMIBrlqVVSFSTI9c8v8BWrNQzbLNabyccFx2bV1NqfJ6KlKJMmgkHLI467vjX5
	 NRd3TFCDliv7OjBlC3MKWD+LuuaqxkMzOFi9JhHA9eH0Yw+7j0AoFONpitaJgozpvB
	 S+cRidOtSd90Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	tglx@kernel.org,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] perf/x86/intel: Fallback to sw branch type decoding if no hw decoding
Date: Mon, 19 Oct 2026 09:52:34 -0400
Message-ID: <20261019135441.1420968-463-sashal@kernel.org>
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

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

[ Upstream commit 170cc6b02e3d5203ccaa49ffea1ee5a7ab08c885 ]

intel_pmu_lbr_filter() currently assumes arch-LBR provides hardware
branch-type decoding and skips software decoding on that path.

However, arch-LBR may not always expose branch-type information. In
that case, treating entries as hardware-decoded can misclassify sampled
branches (for example, defaulting to JCC), which breaks branch-type
filtering results.

Fix this by using software branch-type decoding when hardware
branch-type decoding is unavailable (that is, when x86_lbr_type is not
enabled). This keeps branch classification and filtering behavior
correct across arch-LBR configurations.

Since x86_lbr_type is only set to true when arch-LBR is supported,
it's unnecessary to check if the CPU has the arch-LBR feature.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260616044654.3468742-4-dapeng1.mi@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: the 6.18.53 tree still has the JCC
misclassification, and this is a one-line, already-reviewed correction
of that path.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [perf/x86/intel] [Fallback] [Use software branch-type decoding
when Arch LBR does not provide hardware type]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com> (author, Intel)
- Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org> (perf/x86
  maintainer; applied to tip)
- Link: https://patch.msgid.link/20260616044654.3468742-4-
  dapeng1.mi@linux.intel.com
- No Fixes: tag (expected)
- No Reported-by / Tested-by / Reviewed-by / Acked-by / Cc: stable
- Ignore pipeline tags: [Upstream commit
  170cc6b02e3d5203ccaa49ffea1ee5a7ab08c885], Signed-off-by: Sasha Levin

Notable: msgid `-4` is patch 3/8 of “perf/x86: Miscellaneous PMU bug
fixes” (cover letter is `-1`). Independent patches grouped for
review/backport, not a tightly coupled series.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: `intel_pmu_lbr_filter()` treats Arch LBR as always having
  hardware branch-type decode and skips software decode.
- Reality: Arch LBR CPUID leaf 28H ECX bit 2 (`lbr_br_type`) is
  optional. If it is clear, `get_lbr_br_type()` returns 0.
- Symptom: type 0 is `ARCH_LBR_BR_TYPE_JCC`, so sampled branches are
  classified as JCC. Branch-type filters (`PERF_SAMPLE_BRANCH_*`) and
  saved types are wrong (calls/returns dropped or shown as
  conditionals).
- Root cause: gate is `static_cpu_has(X86_FEATURE_ARCH_LBR)` instead of
  “hardware type actually present”.
- Fix: gate on `static_branch_likely(&x86_lbr_type)`, which is enabled
  only when `x86_pmu.lbr_br_type` is set in `intel_pmu_arch_lbr_init()`.
- Version info in message: none.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not hidden. Explicit correctness fix for misclassification. Not
style/cleanup.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `arch/x86/events/intel/lbr.c` — 1 insertion, 1 deletion
- Function: `intel_pmu_lbr_filter()`
- Scope: single-file, one-line surgical change

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: if CPU has Arch LBR and `type <= ARCH_LBR_BR_TYPE_KNOWN_MAX`
  (0–5), map via `arch_lbr_br_type_map[]`. Else `branch_type()` software
  decode.
- After: same hardware map only if `x86_lbr_type` is enabled (HW type
  field present). Otherwise software decode.
- Path: LBR sample filtering after PMI / branch-stack snapshot, not
  probe/init-only.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: logic/correctness (wrong classifier when optional HW field
  is absent)
- Mechanism: `get_lbr_br_type()` is:

```866:873:arch/x86/events/intel/lbr.c
static __always_inline int get_lbr_br_type(u64 info)
{
        int type = 0;

        if (static_branch_likely(&x86_lbr_type))
                type = (info & LBR_INFO_BR_TYPE) >>
LBR_INFO_BR_TYPE_OFFSET;

        return type;
}
```

When `x86_lbr_type` is off, stored type is 0. Old filter still took the
Arch LBR map because `0 <= ARCH_LBR_BR_TYPE_KNOWN_MAX`, so every entry
became JCC. Fix uses the same static key as the reader.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: one condition aligned with how type is populated.
- Minimal; no unrelated edits.
- Regression risk: low on CPUs with `lbr_br_type` (common Arch LBR) —
  same HW path.
- On Arch LBR without HW type: software decode in NMI (existing
  `branch_type()` path). Sashiko flagged extra NMI cost because
  `intel_pmu_setup_hw_lbr_filter()` always sets `X86_BR_TYPE_SAVE` for
  Arch LBR, so the filter never early-returns. That is the cost of
  correct types, not a change to already-correct behavior. Peter merged
  this form anyway.
- No public API / data-structure change.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Buggy `if (static_cpu_has(X86_FEATURE_ARCH_LBR) &&` introduced in
  `47125db27e47e9` (“perf/x86/intel/lbr: Support Architectural LBR”, Kan
  Liang, 2020-07-08). Contained in `perf-core-2020-08-03` (~v5.9).
  Present in this tree.
- `x86_lbr_type` added in `6b19788ddc593` (“perf/x86/intel/lbr: Add
  static_branch for LBR INFO flags”, 2022-01-18, ~v5.17). Present here.
- `X86_BR_TYPE_SAVE` forced for Arch LBR in `32ba156df1b1c` (2022, Cc:
  stable). Present here.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Functionally this is a late correction of
`47125db27e47e9`, which is in v6.18.53.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- `3c492c8eba026` “Fix kernel address leakages in LBR stack” is already
  in v6.18.53 (same series, patch 4/8). Surrounding filter already has
  `from_plm` kernel-from dropping.
- Candidate `906dbeecfa0ff` is this patch on autosel; **not** in
  `v6.18.53` (`git merge-base --is-ancestor 906dbeecfa0ff v6.18.53`
  failed).
- v6.18.53 still has `static_cpu_has(X86_FEATURE_ARCH_LBR)` at the
  filter. Bug is live on the baseline.
- Standalone vs series: cover letter: “several independent PMU fixes to
  simplify review and backporting.” This hunk does not need 1/8, 2/8,
  5–8. 4/8 is already here.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Dapeng Mi is a regular Intel perf/x86 contributor. Peter
Zijlstra applied it. Nearby same-series work: leakage fix already in
this stable tree.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record:
- Needs `x86_lbr_type` — in this tree since ~v5.17.
- Does not need other v4 patches.
- Applies standalone: v6.18.53 already has the exact one-line context
  (candidate applied as 1 line).

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 170cc6b02e3d5203ccaa49ffea1ee5a7ab08c885` → https://patch.m
  sgid.link/20260616044654.3468742-4-dapeng1.mi@linux.intel.com
- Subject: `[Patch v4 3/8] perf/x86/intel: Fallback to sw branch type
  decoding if no hw decoding`
- Series: v1 2026-06-05, v2 2026-06-09, v3 2026-06-12, v4 2026-06-16;
  tip-bot2 applied 2026-06-30.
- v3→v4: unrelated patches; Peter asked to drop markdown in changelogs.
- v2→v3: “Patch 3/8: Only keep x86_lbr_type check … (Peter).” Committed
  form is what the maintainer asked for.
- v1→v2: software fallback added after Sashiko review of v1.
- Cover: “independent PMU fixes to simplify review and backporting.”
- Human NAKs: none in the saved thread.
- Sashiko AI on v4: High — always-on `X86_BR_TYPE_SAVE` plus software
  decode can add NMI cost if HW type is missing. Not addressed in the
  merged patch; maintainer still took it.
- WebFetch to lore.kernel.org: 403. Thread recovered via `b4 dig -m`.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): To/Cc included Peter Zijlstra, Ingo Molnar,
Arnaldo Carvalho de Melo, Namhyung Kim, Ian Rogers, Adrian Hunter,
Alexander Shishkin, Andi Kleen, Stephane Eranian, linux-perf-users, Zide
Chen, Thomas Falcon, Xudong Hao. Peter signed off. No extra Reviewed-by
on the commit.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No Reported-by, bugzilla, or syzbot. Looks Intel-internal / code
review. Unverified which SKU has Arch LBR without `lbr_br_type`; CPUID
documents it as optional (`union cpuid28_ecx.lbr_br_type`).

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: v4 8 independent fixes. 4/8 (kernel LBR address leak) already in
this tree. This 3/8 is self-contained.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable search returned 403. Cover letter still
states the series was meant to be easy to backport. UNVERIFIED: no
stable-list NAK found (could not query the list).

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `intel_pmu_lbr_filter()` only. Uses `x86_lbr_type`,
`arch_lbr_br_type_map`, `branch_type()`, `common_branch_type()`.

Step 5.2: TRACE CALLERS
Record:
- `intel_pmu_lbr_read()` → `intel_pmu_lbr_filter()`
  - `__intel_pmu_snapshot_branch_stack()` (irq-off snapshot)
  - Intel PMI handler in `intel/core.c` (~line 3375, NMI)
- `intel_pmu_store_pebs_lbrs()` → store then filter (PEBS LBR)

Step 5.3: TRACE CALLEES
Record: `kernel_ip()`, `arch_lbr_br_type_map[]`, `branch_type()` (insn
decode in `arch/x86/events/utils.c`), `common_branch_type()`.
`branch_type()` already used for non-Arch LBR and OTHER_BRANCH.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace `perf_event_open` with `PERF_SAMPLE_BRANCH_STACK` →
PMI/PEBS → LBR read → filter. Reachable from perf. Needs Intel PMU +
Arch LBR without HW type to hit the bug; with HW type the new check
matches old behavior.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: AMD `arch/x86/events/amd/lbr.c` has its own filter; not this
bug. Same file already uses `x86_lbr_type` in `get_lbr_br_type()`; the
filter was the inconsistent check.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- `git describe HEAD` → `v6.18.53-5049-g0f0bdc2b0dffb`; `make
  kernelversion` → 6.18.53; branch `autosel`.
- v6.18.53 `intel_pmu_lbr_filter()` still uses
  `static_cpu_has(X86_FEATURE_ARCH_LBR)`.
- Bug introduced ~v5.9; still present on this 6.18 baseline.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply. Candidate is a 1-line replace on the v6.18.53 line.
Leakage extra checks around it do not conflict.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No other fallback to `x86_lbr_type` in the filter on v6.18.53.
Leakage fix is separate and already present.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: perf/x86 Intel LBR (`arch/x86/events/intel/lbr.c`). IMPORTANT:
Intel PMU branch recording, not core mm/VFS. Widely used on x86 via
perf.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Actively maintained (Kan Liang, Dapeng Mi, Peter Zijlstra). Arch
LBR path is mature (since 2020), not brand-new.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Intel x86 with Arch LBR (Ice Lake+) when CPUID leaf 28H does not
set branch-type. Users of `perf record -j` / `PERF_SAMPLE_BRANCH_STACK`
with type filters or type save. Not universal; driver/PMU-specific.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Normal LBR sampling when HW type is absent. Unprivileged users
can open perf events if `perf_event_paranoid` allows; typically needs
profiling access. Not a rare error-path-only bug.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- Failure: wrong branch types; type filters drop real calls/returns or
  keep everything as JCC; saved types lie.
- Not oops, deadlock, or filesystem corruption.
- Severity: MEDIUM (silent wrong samples). Important for perf
  correctness; same class as other LBR type fixes that already went to
  stable (e.g. `32ba156df1b1c`).

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: correct LBR classification/filtering on Arch LBR without HW
  type; no-op where HW type exists.
- Risk: very low (1 line). Extra software decode only on the previously
  wrong config; `branch_type()` is already used in NMI.
- Ratio: favorable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real misclassification (all branches as JCC) when Arch LBR lacks HW
  type.
- Bug exists on this 6.18.53 baseline.
- One-line, obviously correct, matches `get_lbr_br_type()`.
- Maintainer (Peter Zijlstra) requested this check and signed off.
- Independent of the rest of the series; cover letter aimed at
  backporting.
- Prerequisites (`x86_lbr_type`, Arch LBR filter) are in this tree.
- Applies cleanly; sibling 4/8 already in 6.18.53.

AGAINST:
- Not a crash, UAF, or security hole (leak is a different commit already
  here).
- No user Reported-by / syzbot.
- Sashiko NMI-overhead note not addressed; only matters if HW type is
  missing.
- Which production SKUs omit `lbr_br_type` is unverified.

UNRESOLVED:
- Exact CPU/VMM configs with Arch LBR and `lbr_br_type=0`.
- Stable-list discussion (lore 403).

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — one-line, maintainer-shaped, in
   tip/mainline.
2. Fixes a real bug that affects users? PASS — wrong LBR types/filters.
3. Important issue? PASS (MEDIUM) — silent wrong branch samples on Intel
   LBR; not a panic, but user-visible PMU corruption.
4. Small and contained? PASS — 1 line, one function.
5. No new features or APIs? PASS.
6. Can apply to the local tree? PASS — v6.18.53 has the buggy line and
   `x86_lbr_type`.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: None (not a device ID, quirk, DT, build, or doc fix). Qualifies
as a normal small correctness fix.

Step 9.4: MAKE YOUR DECISION
This 6.18.53 tree still has the Arch LBR filter assuming hardware types
whenever `X86_FEATURE_ARCH_LBR` is set. That is wrong when CPUID does
not advertise the type field: types collapse to JCC and filters lie. The
fix is the same static key already used to read the field, applies
cleanly, and does not change the common HW-type path. That is
appropriate for this stable tree.

What it solves for stable users: Intel perf LBR branch-type
filtering/classification on Arch LBR configs without hardware type,
instead of silently tagging everything as conditional jumps.

Risk vs benefit: one line vs wrong samples; remaining risk is extra
software decode only on the previously broken config.

Verification:
- [Phase 1] Parsed tags: SOB Dapeng Mi + Peter Zijlstra; Link msgid
  3468742-4; no Fixes/Reported-by/Cc stable
- [Phase 1] Cover letter (mbox): independent PMU fixes “to simplify
  review and backporting”; this is v4 3/8
- [Phase 2] Diff: 1 line in `intel_pmu_lbr_filter()`,
  `static_cpu_has(X86_FEATURE_ARCH_LBR)` →
  `static_branch_likely(&x86_lbr_type)`
- [Phase 2] Confirmed `get_lbr_br_type()` returns 0 when `x86_lbr_type`
  is off; 0 maps to JCC
- [Phase 3] `git blame` on parent: buggy check from `47125db27e47e9`
  (2020 Arch LBR)
- [Phase 3] `git merge-base --is-ancestor 47125db27e47e9 v6.18.53` →
  yes; `6b19788ddc593` (x86_lbr_type) → yes
- [Phase 3] `git merge-base --is-ancestor 906dbeecfa0ff v6.18.53` → no
  (not in baseline)
- [Phase 3] `git show v6.18.53:arch/x86/events/intel/lbr.c` still has
  `static_cpu_has(X86_FEATURE_ARCH_LBR)` in the filter
- [Phase 3] Leakage fix `3c492c8eba026` is already in v6.18.53
- [Phase 4] `b4 dig -c 170cc6b02e3d5`: lore thread
  20260616044654.3468742-4; v1–v4; Peter asked for x86_lbr_type-only
  check in v3
- [Phase 4] `b4 dig -w`: Peter, Ingo, acme, Namhyung, Eranian, linux-
  perf-users CC’d
- [Phase 4] Sashiko v4: NMI software-decode cost if TYPE_SAVE always
  set; unverified product impact
- [Phase 4] WebFetch lore/stable: 403; UNVERIFIED stable-list discussion
- [Phase 5] Callers: `intel_pmu_lbr_read()` from PMI and snapshot;
  `intel_pmu_store_pebs_lbrs()` from PEBS
- [Phase 6] `git describe HEAD`: v6.18.53-5049-g0f0bdc2b0dffb; `make
  kernelversion`: 6.18.53
- [Phase 8] Failure: misclassified LBR samples, severity MEDIUM
- UNVERIFIED: concrete CPUID dumps with Arch LBR and `lbr_br_type=0`

**YES**

 arch/x86/events/intel/lbr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 44f5556440223..bbfd6ffbdd68a 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1230,7 +1230,7 @@ intel_pmu_lbr_filter(struct cpu_hw_events *cpuc)
 		 * Doesn't support OTHER_BRANCH decoding for now.
 		 * OTHER_BRANCH branch type still rely on software decoding.
 		 */
-		if (static_cpu_has(X86_FEATURE_ARCH_LBR) &&
+		if (static_branch_likely(&x86_lbr_type) &&
 		    type <= ARCH_LBR_BR_TYPE_KNOWN_MAX) {
 			to_plm = kernel_ip(to) ? X86_BR_KERNEL : X86_BR_USER;
 			type = arch_lbr_br_type_map[type] | to_plm;
-- 
2.53.0

