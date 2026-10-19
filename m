Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C67D5A463C;
	Mon, 19 Oct 2026 13:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418384; cv=none; b=Hx8N8mypoQfQMbZ9hq2rauQnkcs7oLmIayDEQ5UgCybpFnkX3FU3EXSzFwk4etqDdRiWPbMVsBURPaTPFFclyqKjfNUSSLC0VM4crQaQ3hLMZgRJ2b3O71tWEQFTJB2EWJhy2MiWUbo8WYivvbUNjSnZqyEDVkXLUsBpRXp2mrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418384; c=relaxed/simple;
	bh=N64ofjkUpTGPkSvl3GDa1BCGYS9Nq0epO3Thd5wJkRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cwAIQcOQ3PIOiOi5EV8Pgy8EsC+iCHcD9EJfzJO4V1+P2Ss7NEpVApLcWCaeGnBzbPjwyID+HDcXU746rySFQDtvFxOpgReLzlsyTQ1vfXJ5EmDsWzgQZiNzD8I+a5Ki0ZD+wbBdJgrSY2nR0zOV9aDYZXT47EU4QTxKD3LoeH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q4gOCc79; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q4gOCc79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9731F000C6;
	Mon, 19 Oct 2026 13:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418381;
	bh=u1Tf6MsgB65J8rRmT2HY3mDOWGviM+UbICT+94mEk8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q4gOCc79QGcIY4EuWyLMDQDpSqvLa3rRhu5hw0Dq+1bkuBOfTu3yxHDUco9lbLZv7
	 WDdxB2uPRz5tOQ4zWaFyeLWDwTaQn8gM/BC9rfhJZMVpXXgHoA5ZR45xBgreZkDqs/
	 CuLnEhMRhpR0+8+cdb79UtWJTE+CrkvVrdC756SibJlz0+p6zui5VFgLx8NIolowyy
	 mEEUeGShxVsIynxbqrYOo31MzJjcH1EcNM8CKoLmqU3n+QXgARE9o8jzBWy486tYzM
	 HlC5UZjzqwZGxAO9L1a2ff8TzRd+EbYE5clc7gc1Y2WehBZQ7dqY/zZA2JqazytstN
	 HmvjPHUlfOLbA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] perf/core: Fix kernel register info leak via hardware skid
Date: Mon, 19 Oct 2026 09:48:19 -0400
Message-ID: <20261019135441.1420968-208-sashal@kernel.org>
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

[ Upstream commit 166f10836a653dfa280d4335603b52f685b8b1ef ]

An unprivileged hardware perf event using exclude_kernel=1 can leak kernel
register data to user space via PERF_SAMPLE_REGS_INTR or PERF_SAMPLE_IP.
Due to hardware skid, a PMI may trigger after the CPU has already entered
kernel space (Ring 0), bypassing the perf_allow_kernel() privilege
barrier.

This security vulnerability is severely exacerbated by upcoming support
for SIMD register sampling via XSAVES, which could expose sensitive kernel
FPU states (such as active cryptographic keys).

Fix this by ensuring that sampled register data is dropped if the event's
exclude_kernel attribute is set but the PMI catches the CPU in kernel mode.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/all/20260529085613.CCAFB1F00893@smtp.kernel.org/
Link: https://patch.msgid.link/20260616044654.3468742-8-dapeng1.mi@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: this is a real unprivileged kernel-register
leak on 6.18.53, and the fix is small enough to backport.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [perf/core] [Fix] [Stop unprivileged hardware sampling from
leaking kernel IP/register state when PMI skid lands in Ring 0]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com> (author)
- Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
  (perf/core maintainer; merged into tip perf/core)
- Link: https://lore.kernel.org/all/20260529085613.CCAFB1F00893@smtp.ker
  nel.org/ (earlier discussion; lore fetch returned 403)
- Link: https://patch.msgid.link/20260616044654.3468742-8-
  dapeng1.mi@linux.intel.com (v4 series, this patch)
- No Fixes: tag (expected)
- No Cc: stable (expected)
- No Reported-by / Tested-by / Reviewed-by / Acked-by besides SOBs
- Ignore: Signed-off-by: Sasha Levin and "[Upstream commit
  166f10836a653dfa280d4335603b52f685b8b1ef]" (pipeline markers)

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: An unprivileged hardware perf event with `exclude_kernel=1` can
  still observe kernel register data through `PERF_SAMPLE_REGS_INTR` or
  `PERF_SAMPLE_IP`.
- Symptom/failure mode: Kernel IP and interrupt-time register state
  (GPRs; on some Intel platforms PEBS XMM too) are copied into the
  userspace mmap buffer. That is a KASLR / kernel-state info leak. The
  message also warns that later XSAVES SIMD sampling would make this
  worse (crypto-key material in FPU/SIMD state).
- Trigger: Hardware PMI skid: the overflow interrupt is delivered after
  the CPU has already entered kernel mode, so `perf_allow_kernel()` at
  `perf_event_open()` time is bypassed.
- Root cause: Sample preparation always dumps `regs` / IP from the PMI
  frame, with no check that `exclude_kernel` is consistent with
  `user_mode(regs)`.
- Versions: No kernel-version range in the message. The REGS_INTR dump
  path dates to 2014; guest IP helper to 2024.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. Subject and body state a security leak
and a surgical filter. Not a hidden bug.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `kernel/events/core.c` (+30 / -7)
- Functions: `perf_instruction_pointer()`, `perf_sample_regs_intr()`,
  call site in `perf_prepare_sample()`
- Scope: single-file surgical fix

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Hunk 1 (`perf_instruction_pointer`): Before, guest and host always
  returned the captured IP. After, if `exclude_kernel` and the captured
  context is not userspace (host `!user_mode(regs)`, or guest without
  `PERF_GUEST_USER`), IP is replaced with 0.
- Hunk 2 (`perf_sample_regs_intr`): Before, always `regs_intr->regs =
  regs` and a real ABI. After, if `exclude_kernel && !user_mode(regs)`,
  ABI is `PERF_SAMPLE_REGS_ABI_NONE` and `regs` is NULL so
  `perf_output_sample()` writes a zero ABI and skips register payload.
- Hunk 3 (`perf_prepare_sample`): Passes `event->attr.exclude_kernel`
  into the new parameter. Sample header size already accounts for a NULL
  `regs` pointer (`if (data->regs_intr.regs)`), so dyn_size stays
  consistent.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: Memory-safety / info-leak (unprivileged kernel-state
disclosure), not UAF/leak-of-heap.
- Mechanism: PMI skid + `exclude_kernel=1` still presents kernel
  `pt_regs` to userspace.
- Fix: Drop register payload and zero IP when the sample is kernel-mode
  but the event asked to exclude the kernel.
- Analogous to the 2017 attempt `cc1582c231ea0` ("Drop kernel samples
  even though :u is specified"), which was reverted in `6a8a75f323572`
  because dropping the whole sample broke rr overflow signals. This
  patch keeps the sample/signal and only redacts contents.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: the predicate matches the existing
  `sample_is_allowed()` / `perf_exclude_event()` tests (`exclude_kernel
  && !user_mode(regs)`).
- Minimal: three related sites, no API/UAPI change (ABI_NONE is the
  documented empty-regs encoding).
- Regression risk: low for kernel correctness. Userspace profilers can
  see IP=0 on skid samples; kernel test robot reported `perf-sanity-
  tests.Object_code_reading.fail` for that. Author said the kernel
  behavior is intended and the test should skip IP 0. rr is not broken
  because overflow still fires. Privileged `exclude_kernel=0` events are
  unchanged.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- `perf_sample_regs_intr()` introduced by `60e2364e60e86e` (Stephane
  Eranian, 2014-11-16) "perf: Add ability to sample machine state on
  interrupt".
- `perf_instruction_pointer(event, regs)` guest split from
  `2c47e7a74f4454` / `04782e63917dbc` (Colton Lewis, 2024-11-13)
  "perf/core: Correct perf sampling with guest VMs".
- The leak of kernel IP on `:u` sampling has been a known class since at
  least 2017.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Historical related commits:
- `cc1582c231ea0` (2017): dropped entire skid kernel samples; Cc:
  stable.
- `6a8a75f323572` (2017): reverted that because rr depends on overflow
  signals, not sample contents.
- `030a976efae83` (2022): reintroduced `sample_is_allowed()` only for
  sigtrap, not for sample output. In this tree it is used solely at
  `kernel/events/core.c:10445`.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Sibling security patches in the same Dapeng series (self-
contained, not prerequisites of this hunk):
- `perf/core: Check kernel access when kernel callchains are requested`
  (callchain permission hole)
- `perf/x86/intel: Fix kernel address leakages in LBR stack`
This patch does not need those to compile or to close the IP/REGS_INTR
hole.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Dapeng Mi is an Intel PMU/perf contributor. Peter Zijlstra
(subsystem maintainer) signed off and queued it on tip perf/core (commit
166f10836a653dfa280d4335603b52f685b8b1ef, 2026-06-30). Author's other
`kernel/events` work in this clone is unrelated cpu-clock fixes.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Standalone. All symbols used (`user_mode`,
`PERF_SAMPLE_REGS_ABI_NONE`, `should_sample_guest`, `perf_guest_state`,
`PERF_GUEST_USER`, `perf_guest_get_ip`) exist in v6.18.53. Signature
change of static `perf_sample_regs_intr()` has a single call site in
`core.c`.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- b4 dig matched patch-id to lore; msgid
  `20260616044654.3468742-8-dapeng1.mi@linux.intel.com`
- Evolved from the v8 SIMD/XSAVES sampling series (2026-05-29) into a
  standalone "miscellaneous PMU bug fixes" series:
  - v1 2026-06-05: only `perf_sample_regs_intr` (no IP redaction)
  - v2–v4: added `perf_instruction_pointer` host+guest IP redaction
    (committed form)
- Merged to tip perf/core 2026-06-30 by Peter Zijlstra; no NAK found.
- Later (2026-09-15) kernel test robot: userspace `Object code reading`
  test fails on IP 0. Dapeng: expected; test should filter IP 0. That is
  not a kernel functional/security regression.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: Recipients (b4 dig -w): Peter Zijlstra, Ingo Molnar, Arnaldo
Carvalho de Melo, Namhyung Kim, Ian Rogers, Adrian Hunter, Alexander
Shishkin, Andi Kleen, Stephane Eranian, Mark Rutland, linux-kernel,
linux-perf-users. Maintainer SOB is the strongest review signal found.
Lore HTML itself returned 403; discussion reconstructed from
openwall/lkml mirrors.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla. Motivated by analysis around SIMD register
sampling. The IP leak is independently real: unprivileged `perf record
-e cycles:u` is a common path, and 2017 already treated skid kernel
samples as a security issue.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Same series also has callchain permission and LBR address-leak
fixes. Those are separate holes. This commit does not depend on
SIMD/XSAVES patches; v6.18.53 has no XSAVES SIMD sampling (`git grep` of
XSAVES SIMD sample paths on v6.18.53 was empty). XMM-via-PEBS already
exists on Ice Lake+ (`PERF_REG_EXTENDED_MASK` in
`arch/x86/events/core.c`).

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable search returned 403. No evidence this was
rejected for stable. Absence of Cc: stable is expected for this review
pipeline.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `perf_instruction_pointer`, `perf_sample_regs_intr`,
`perf_prepare_sample`. Related existing helpers: `sample_is_allowed`,
`perf_allow_kernel`, `perf_output_sample`.

Step 5.2: TRACE CALLERS
Record:
- `perf_instruction_pointer()`: only used from `perf_prepare_sample()`
  (`data->ip = ...`) when `PERF_SAMPLE_IP` (or dependent
  `PERF_SAMPLE_CODE_PAGE_SIZE`) is set.
- `perf_sample_regs_intr()`: only called from `perf_prepare_sample()`
  for `PERF_SAMPLE_REGS_INTR`.
- `perf_prepare_sample()`: `__perf_event_output()` (normal mmap
  samples), `bpf_overflow_handler()`, PEBS/BTS/s390 sampling paths.
  Hardware PMI → `perf_event_overflow()` → overflow handler → output.
  Confirmed `__perf_event_overflow()` does **not** drop skid kernel
  samples today; `sample_is_allowed()` is sigtrap-only.

Step 5.3: TRACE CALLEES
Record: `user_mode(regs)`, `perf_arch_instruction_pointer()`,
`perf_guest_get_ip()`, `perf_guest_state()`, `perf_reg_abi()`. Output
path: `perf_output_sample()` already treats ABI 0 as "no regs".

Step 5.4: FOLLOW THE CALL CHAIN
Record: Reachable from unprivileged `perf_event_open()`:
- `sysctl_perf_event_paranoid > 1` requires `exclude_kernel=1`
  (`perf_allow_kernel()` at `kernel/events/core.c:13553`).
- `PERF_SAMPLE_IP` has no extra privilege check (default sample type).
- `PERF_SAMPLE_REGS_INTR` is gated only by
  `security_locked_down(LOCKDOWN_PERF)`, not paranoid. Without lockdown
  (typical without Secure Boot), unprivileged REGS_INTR is allowed.
Trigger is common: non-precise `cycles:u` around syscalls/page faults.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same `exclude_kernel && !user_mode(regs)` already used in
`sample_is_allowed()`, `perf_exclude_event()`, and tracepoint matching.
This patch extends that policy to sample payload. Remaining sibling
holes (callchain, LBR) are other commits.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. Local tree is **6.18.53** (`git describe HEAD` =
`v6.18.53-5049-g0f0bdc2b0dffb`, Makefile VERSION=6 PATCHLEVEL=18
SUBLEVEL=53). At tag `v6.18.53`:
- `perf_instruction_pointer` returns guest/host IP unconditionally.
- `perf_sample_regs_intr(regs)` always assigns `regs`.
- Call site is `perf_sample_regs_intr(&data->regs_intr, regs);`
- `git merge-base --is-ancestor 166f10836a653dfa280d4335603b52f685b8b1ef
  v6.18.53` is false.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply expected. Pre-image of both functions and the call
site on v6.18.53 matches the patch. `PERF_GUEST_USER` is in
`include/linux/perf_event.h`. No conflicting refactor of these functions
on 6.18.y.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: The 2017 full-sample drop is **not** present (reverted).
`sample_is_allowed()` does not redact IP/REGS_INTR. No other in-tree
substitute for this leak on 6.18.53.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [perf/core, `kernel/events/core.c`] [CORE for
observability/security: `perf_event_open` is a common unprivileged
syscall; leak is kernel-wide, not driver-specific]

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Actively maintained (Peter Zijlstra). File still receives
UAF/deadlock fixes on 6.18.y; these two functions have been stable for
years.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Any unprivileged user who can open a hardware sampling event
with `exclude_kernel=1` (default paranoid). Universal on systems with a
hardware PMU. REGS_INTR extra impact depends on lockdown; IP leak does
not.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Common. Non-precise userspace-only sampling (`cycles:u`) plus
kernel entry/exit. Unprivileged-triggerable. Timing-dependent (skid) but
well documented and previously reproduced in 2017.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: [Kernel address / register info leak, KASLR bypass; on PEBS XMM
also SIMD state] [Severity: HIGH / security. Not a panic. XSAVES full-
SIMD crypto-key leak is **not** in 6.18; XMM PEBS already is.]

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: HIGH — closes an unprivileged kernel-IP leak on a default
  sampling path; also covers REGS_INTR.
- Risk: LOW — ~30 lines, static helper, keeps overflow (rr-safe),
  existing ABI_NONE encoding.
- Residual: userspace tools may see IP=0 (test already did). That is the
  security behavior, not a kernel crash.
- Ratio: strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real unprivileged info leak via PMI skid; same class previously sent
  to stable in 2017.
- Current code on 6.18.53 still emits kernel IP/regs;
  `sample_is_allowed()` no longer drops samples.
- Surgical, obviously correct, maintainer-signed, applies cleanly.
- Avoids the rr regression by redacting payload instead of dropping the
  event.

AGAINST:
- Userspace perf "object code reading" test can fail on IP 0 (author:
  fix the test).
- No Fixes:/Cc:stable (not a negative per rules).
- XSAVES SIMD exacerbation is not in 6.18; the IP/GPR (and PEBS XMM)
  leak still is.

UNRESOLVED:
- Full lore HTML was 403; review reconstructed from mirrors and b4.
  Peter Zijlstra SOB still verified.
- Whether a userspace-only test fix later landed is unverified in this
  clone; it does not block the kernel fix.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — maintainer merged; robot only
   hit expected IP=0.
2. Fixes a real bug that affects users? PASS — unprivileged
   `perf_event_open` + hardware sampling.
3. Important issue (crash, security, corruption, deadlock)? PASS —
   security info leak / KASLR.
4. Small and contained? PASS — one file, +30/-7.
5. No new features or APIs? PASS.
6. Can apply to the local tree? PASS — v6.18.53 pre-image matches.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary security
bugfix.

Step 9.4: MAKE YOUR DECISION
This tree is 6.18.53. The buggy dump path is present. The patch is a
small, rr-safe security fix with no missing prerequisites. It should be
backported.

------------------------------------------------
What the commit solves for stable users
Unprivileged hardware sampling with `exclude_kernel=1` can still capture
kernel IP and interrupt registers when the PMI skids into Ring 0. On
6.18 that includes default `PERF_SAMPLE_IP` and, unless lockdown,
`PERF_SAMPLE_REGS_INTR` (including PEBS XMM on capable Intel CPUs). The
fix redacts that payload without dropping the sample, so overflow-based
tools keep working.

Risk vs benefit
Benefit is a real KASLR/register leak on a common syscall path. Risk is
low: tiny core.c change, existing empty-regs ABI, no locking/API change.
The only observed fallout is userspace seeing IP 0, which is intended.

Concerns
No series dependencies for this hunk. XSAVES SIMD is not in 6.18; that
does not reduce the IP leak. A follow-up is only needed for the perf
selftest, not for kernel correctness.

Verification:
- [Phase 1] Parsed tags: Dapeng Mi author, Peter Zijlstra SOB, two
  lore/msgid links; no Fixes/Reported-by
- [Phase 2] Diff: `perf_instruction_pointer` zeros IP;
  `perf_sample_regs_intr` uses ABI_NONE; `perf_prepare_sample` passes
  `exclude_kernel`
- [Phase 3] `git blame v6.18.53`: REGS_INTR dump from `60e2364e60e86e`
  (2014); guest IP from `2c47e7a74f4454` (2024)
- [Phase 3] `git log -S sample_is_allowed -- kernel/events/core.c`: 2017
  drop reverted; current use is sigtrap-only
- [Phase 3] `git show 6a8a75f323572`: revert because rr needs overflow
  signals
- [Phase 4] `b4 dig -c 7db4d13613f57`: matched v4 msgid
  20260616044654.3468742-8; recipients include Peter Zijlstra et al.
- [Phase 4] `b4 dig -a`: originated in SIMD series v8, then standalone
  bugfix series v1–v4; IP redaction added after v1
- [Phase 4] openwall 2026-09-15: author confirms IP=0 is the leak fix;
  test should skip it
- [Phase 5] grep: `perf_instruction_pointer` / `perf_sample_regs_intr`
  only used from `perf_prepare_sample`; overflow path does not drop skid
  samples
- [Phase 5] `perf_allow_kernel()` at open requires `exclude_kernel` for
  unprivileged users; REGS_INTR only checks lockdown
- [Phase 6] `git describe HEAD` / Makefile: 6.18.53; v6.18.53 still has
  the unfiltered dump; ancestor check of 166f10836a65 vs v6.18.53 is
  false
- [Phase 6] `PERF_GUEST_USER` present; function pre-image matches patch
- [Phase 6] no XSAVES SIMD sampling in v6.18.53; XMM PEBS already
  present
- [Phase 8] Failure mode: unprivileged kernel IP/register disclosure,
  HIGH security
- UNVERIFIED: full lore.kernel.org thread body (HTTP 403); stable@ list
  search (403)

**YES**

 kernel/events/core.c | 37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 018a1e4ef5b0d..3b01c2853d681 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7499,10 +7499,20 @@ unsigned long perf_misc_flags(struct perf_event *event,
 unsigned long perf_instruction_pointer(struct perf_event *event,
 				       struct pt_regs *regs)
 {
-	if (should_sample_guest(event))
-		return perf_guest_get_ip();
+	/*
+	 * Hardware skid can lead to a scenario where a PMI is
+	 * delivered after the CPU has already entered kernel mode.
+	 * In that case, user-space sampling must not expose kernel
+	 * register state.
+	 */
+	if (should_sample_guest(event)) {
+		return event->attr.exclude_kernel &&
+		       !(perf_guest_state() & PERF_GUEST_USER) ?
+			0 : perf_guest_get_ip();
+	}
 
-	return perf_arch_instruction_pointer(regs);
+	return event->attr.exclude_kernel && !user_mode(regs) ?
+		0 : perf_arch_instruction_pointer(regs);
 }
 
 static void
@@ -7536,10 +7546,22 @@ static void perf_sample_regs_user(struct perf_regs *regs_user,
 }
 
 static void perf_sample_regs_intr(struct perf_regs *regs_intr,
-				  struct pt_regs *regs)
+				  struct pt_regs *regs,
+				  bool exclude_kernel)
 {
-	regs_intr->regs = regs;
-	regs_intr->abi  = perf_reg_abi(current);
+	/*
+	 * Hardware skid can lead to a scenario where a PMI is
+	 * delivered after the CPU has already entered kernel mode.
+	 * In that case, user-space sampling must not expose kernel
+	 * register state.
+	 */
+	if (exclude_kernel && !user_mode(regs)) {
+		regs_intr->abi = PERF_SAMPLE_REGS_ABI_NONE;
+		regs_intr->regs = NULL;
+	} else {
+		regs_intr->regs = regs;
+		regs_intr->abi = perf_reg_abi(current);
+	}
 }
 
 
@@ -8427,7 +8449,8 @@ void perf_prepare_sample(struct perf_sample_data *data,
 		/* regs dump ABI info */
 		int size = sizeof(u64);
 
-		perf_sample_regs_intr(&data->regs_intr, regs);
+		perf_sample_regs_intr(&data->regs_intr, regs,
+				      event->attr.exclude_kernel);
 
 		if (data->regs_intr.regs) {
 			u64 mask = event->attr.sample_regs_intr;
-- 
2.53.0

