Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771F450A3E9;
	Mon, 19 Oct 2026 14:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418695; cv=none; b=WIVQoSixFQ9/rgEcWG+1Kk6XRiXsQKzq02h4cOQLM+QiM8b1TJoAy0he/qRXoUtiZoTbdy5GJPt3O3c8TAyE5y2DZsq6yKI9MNfT5VBJp4emN1XqQ3iEKBKn7tgsaW90Vfz/wtHwqSIkEmjdKSb/pgQHtPib3A/GaqUQ6kQ9mhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418695; c=relaxed/simple;
	bh=FIOIwoP2afiERcg4/1WmwkN28yCxbEtJtBPVgPdHRHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q2HwB9UA4RdCUDmygHO++992aN+dg+2H0pEZjeFHShJ60QaqlicjJhaSuYYVs78ByTzS81rpNR/2sxMjEEqt1OKsbSKOR7DS3jbiPBQKYXklOt/I4v2WzrR+MjxznzEPUfij6Km9uW47A4/R2v9IpU4k53CdswnglJRIPFAIjvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EfGffzrL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EfGffzrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDB61F000C7;
	Mon, 19 Oct 2026 14:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418692;
	bh=4nlAkPNRvRnVtsAxzYTceA/wS9G1utQMbrHPnjSJf7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EfGffzrLYuX7fpzUtELS2FJZeGP5cDw77QtzBRCfhzwNAQM3zrSXMsQ0VTlNy5oJY
	 K5JmfFWb7WAotDOe6lE2eAgctSB6MPUzc6XaMHQD7i3lZlQEhnh2fXLixij/cqEygG
	 s9NJ8zcVAGF/s4xrhH6wysrpQZ4ModkcvLwwjIYcpH1E/gBmXkUPZz60f/wqyd9B9v
	 ri52zaa8PhKT5SGX9idocYaKCSskIeG3F2LbETClSNadfvFIywAhS6mtySSMktrYf/
	 xB/bONmQQxFhiyNWWG/fK7067Cz//5Vnvu5STskl2tFibWf6WbbYOH46ZzjCMUn4zo
	 U2S9zDbuvC5qQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Zide Chen <zide.chen@intel.com>,
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
Subject: [PATCH AUTOSEL 6.18-6.1] perf/x86: Unregister PMI handler on PMU init failure
Date: Mon, 19 Oct 2026 09:51:59 -0400
Message-ID: <20261019135441.1420968-428-sashal@kernel.org>
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

[ Upstream commit 91787047b1dc52b1fee68b07f79af70aae5fce47 ]

Fix an NMI handler leak in init_hw_perf_events(). When PMU
initialization fails after register_nmi_handler(), the error path
exits without calling unregister_nmi_handler(), leaving a stale
NMI_LOCAL "PMI" handler registered. Add the missing call before
clearing x86_pmu state.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Thomas Falcon <thomas.falcon@intel.com>
Reviewed-by: Zide Chen <zide.chen@intel.com>
Link: https://patch.msgid.link/20260717080342.1879573-2-dapeng1.mi@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). The NMI-handler leak is
in this checkout, and the four-line cleanup applies cleanly.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[perf/x86] [Unregister] Unregister PMI NMI handler when PMU
init fails after `register_nmi_handler()`**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Signed-off-by: Dapeng Mi (author)
- Signed-off-by: Peter Zijlstra (Intel) (perf/x86 maintainer; merged to
  tip/perf/core)
- Reviewed-by: Thomas Falcon (Intel)
- Reviewed-by: Zide Chen (Intel)
- Link: https://patch.msgid.link/20260717080342.1879573-2-
  dapeng1.mi@linux.intel.com
- No Fixes:, Reported-by:, Tested-by:, Cc: stable, or syzbot tags
  (absence is expected)
- Pipeline markers ignored per instructions
- Tip merge SHA: `91787047b1dc52b1fee68b07f79af70aae5fce47` (not an
  ancestor of this tree)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `init_hw_perf_events()` registers NMI_LOCAL handler `"PMI"`
  then can fail in cpuhp / `perf_pmu_register` without unregistering it.
- **Symptom:** stale NMI handler remains for the life of the kernel;
  first cpuhp failure also skips `memset(&x86_pmu)`.
- **Version info:** none in the message. Code has been this way since
  the 2016 cpuhp conversion.
- **Root cause:** missing `unregister_nmi_handler(NMI_LOCAL, "PMI")` on
  post-register error paths.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. Explicit error-path resource-leak fix (NMI
handler leak). Also completes the incomplete `memset(&x86_pmu)` on the
first `cpuhp_setup_state()` failure, which today still `return err`.

===============================================================
PHASE 2: DIFF ANALYSIS
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `arch/x86/events/core.c` only (+3 / −1; net +2)
- Function: `init_hw_perf_events()`
- Scope: single-file surgical error-path fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Hunk 1: `cpuhp_setup_state(CPUHP_PERF_X86_PREPARE)` failure currently
  `return err` (no NMI unregister, no `memset`). After: `goto
  pmi_unregister`.
- Hunk 2: new `pmi_unregister:` label after cpuhp teardown, before
  `out_bad_pmu:`. All later error paths (`out`/`out1`/`out2`) now
  unregister the PMI handler, then still `memset(&x86_pmu, 0, ...)`.
- Early `goto out_bad_pmu` (no PMU driver / `check_hw_exists()` fail)
  stays before `register_nmi_handler()` and still skips unregister —
  correct.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Error-path resource leak.** `register_nmi_handler()` has no
matching `unregister_nmi_handler()` if later init fails. Category (a)
error-path leak; also incomplete cleanup of `x86_pmu` on the first cpuhp
failure.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct. Success path still `return 0` before the
labels. First cpuhp failure still skips `cpuhp_remove_state()` (setup
rolls back on failure). Early `out_bad_pmu` still does not unregister.
Regression risk is very low; no API/locking/hot-path change.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- `register_nmi_handler(..., "PMI")`: `9c48f1c629ecfa` (Don Zickus,
  2011)
- cpuhp error paths including `return err`: `95ca792c7582fd` (Thomas
  Gleixner, 2016; in v4.8-rc1)
- `out_bad_pmu` / `memset(&x86_pmu)`: `916e3a4f950eac` (Paolo Bonzini,
  2022) — in this tree; message said hotplug install failure should
  clear `x86_pmu`, but the first `return err` was left uncleared

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. Introducer of the leaky error path is
`95ca792c7582fd`, present in this tree (`git merge-base --is-ancestor`
exit 0).

**Step 3.3: CHECK FILE HISTORY**
Record: Recent `arch/x86/events/core.c` changes are unrelated
(callchain, hybrid, counters). No equivalent `pmi_unregister` commit.
`git log -S pmi_unregister -- arch/x86/events/core.c` is empty here.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Dapeng Mi is a regular Intel perf/x86 contributor in this tree
(PEBS, LBR, KASAN). Patch signed off by Peter Zijlstra.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Standalone. It is v3 1/8 of “Miscellaneous PMU bug fixes and
optimizations”. Patch 2 (`Free hybrid state on PMU init failure`) *uses*
the new `pmi_unregister` label but is a follow-up, not a prerequisite.
`unregister_nmi_handler()` already exists (`arch/x86/kernel/nmi.c`). No
new helpers required.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 91787047b1dc52b1fee68b07f79af70aae5fce47` matched the
  series (patch-id 48e634d2936fd149d8d36fbf100fd51c3fa0e39b)
- Lore/msgid: https://patch.msgid.link/20260717080342.1879573-2-
  dapeng1.mi@linux.intel.com
- v1→v3: this hunk is unchanged across revisions; later-series comments
  (hybrid cast, drain_pebs) do not affect this patch
- Merged to tip/perf/core 2026-08-10; no NAK found
- Cover letter: bugs found by Sashiko review of another series; tested
  on Diamonds/Novalake (`perf test` 119/155/156)

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: `b4 dig -w` recipients included Peter Zijlstra, Ingo Molnar,
Arnaldo Carvalho de Melo, Namhyung Kim, linux-kernel, linux-perf-users,
plus Intel reviewers. Reviewed-by Thomas Falcon and Zide Chen;
maintainer SOB from Peter Zijlstra.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla/user crash report. Found by static review
(Sashiko), then coded as an explicit leak fix.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Series of 8; this patch is independent. Patch 2 is a related
hybrid-state leak on the same function and can land later.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: No useful stable-list hit that this was rejected or already
queued. UNVERIFIED beyond search noise: lore.kernel.org returned 403 for
direct thread fetch.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `init_hw_perf_events` (modified). Related:
`perf_event_nmi_handler`, `unregister_nmi_handler`,
`x86_pmu_prepare_cpu`.

**Step 5.2: TRACE CALLERS**
Record: `init_hw_perf_events` is `early_initcall` — once at boot.
`x86_pmu_prepare_cpu` is the PREPARE cpuhp callback; Intel/AMD
`cpu_prepare` can return `-ENOMEM` (`intel_cpuc_prepare` kzallocs;
`amd_pmu_cpu_prepare` kzallocs `lbr_sel` / `amd_nb`).

**Step 5.3: TRACE CALLEES**
Record: After register: cpuhp setup, `perf_pmu_register`. Handler
`perf_event_nmi_handler` returns `NMI_DONE` if `active_events==0`, else
`static_call(x86_pmu_handle_irq)`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Not a syscall hot path. Reachable at boot if hardware PMU exists
and later setup fails (ENOMEM in prepare, cpuhp failure,
`perf_pmu_register` / hybrid register failure). Unprivileged users do
not trigger it directly. If the handler is left registered after
`memset(&x86_pmu)`, a later NMI still walks it.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Other x86 NMI users (kgdb, IBS, nmi_selftest) pair
register/unregister. This init path did not.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. `arch/x86/events/core.c`: `register_nmi_handler` at 2108;
`if (err) return err;` at 2144–2145; `out`/`out1`/`out2` then
`out_bad_pmu` memset with no unregister.
`91787047b1dc52b1fee68b07f79af70aae5fce47` is **not** an ancestor
(`merge-base --is-ancestor` exit 1). Bug introduced with cpuhp
conversion in v4.8 era.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: `git apply --check` of the two hunks against this tree: **clean
apply** (rc 0). Surrounding `init_hw_perf_events` matches the patch.
Difficulty: clean apply.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: `916e3a4f950eac` is present (clears `x86_pmu` on some fail
paths) but still misses NMI unregister and the first `return err`. No
later equivalent fix.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **perf/x86** (`arch/x86/events/`). **IMPORTANT** — x86 hardware
performance monitoring, used by `perf`, KVM PMU
(`perf_get_x86_pmu_capability`), and profiling. Not core mm/scheduler,
not staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained (frequent intel/amd PMU commits). This leak
is old (2016), not a brand-new subsystem.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: x86 systems with a hardware PMU whose **init fails after** NMI
registration (ENOMEM in prepare, cpuhp setup fail, PMU register fail).
Not every boot; not non-x86.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Boot-time only. Common “no/broken PMU” path (`intel_pmu_init`
fail / `check_hw_exists` false) is **before** register, so it does not
leak. The leak needs a later failure. `intel_cpuc_prepare` /
`amd_pmu_cpu_prepare` returning `-ENOMEM` is a concrete trigger. Not
unprivileged-triggerable.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Stale NMI_LOCAL handler remains; extra NMI-chain walk for the
life of the system. If later paths `memset` `x86_pmu` while the handler
is still registered, `perf_event_nmi_handler` can still run. If
`active_events==0` it returns `NMI_DONE` (typical after failed
register). First cpuhp failure today also leaves `x86_pmu` populated, so
`perf_get_x86_pmu_capability()` can report a live PMU after failed init
— the case `916e3a4f950eac` tried to close. Severity: **MEDIUM**
(resource leak in NMI context; rare trigger; latent inconsistency more
than a guaranteed oops).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: medium for affected boots (correct NMI teardown + complete
  `x86_pmu` clear); modest globally because the path is rare
- Risk: very low (4-line error-path-only change, applies cleanly)
- Ratio: favorable — cheap correctness fix for a real leak

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real NMI handler leak on verified error paths in this 6.12 tree
- Also closes the leftover `return err` that skips `memset(&x86_pmu)`
  after PREPARE cpuhp failure
- Tiny, obviously correct, maintainer-acked, applies cleanly
- `unregister_nmi_handler` already exists; no new API
- Concrete `-ENOMEM` failure in Intel/AMD `cpu_prepare`
- Error-path leak cleanup is standard stable material

AGAINST:
- Rare one-time init path, not a hot-path leak
- No user/syzbot report; found by review
- Not a guaranteed panic/corruption on typical boots (`active_events`
  usually 0)

UNRESOLVED:
- Direct lore.kernel.org fetch returned 403; discussion reconstructed
  via b4, patchew, lkml.iu.edu
- No evidence this was rejected for stable

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — mechanical unregister;
   series tested; Peter Zijlstra merged it
2. Fixes a real bug that affects users? **PASS** — leaked NMI handler
   after failed x86 PMU init
3. Important issue? **PASS** — NMI-context resource leak plus incomplete
   PMU-state teardown; not a guaranteed panic, but more than cosmetic
4. Small and contained? **PASS** — +3/−1, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — `git apply --check` clean;
   buggy code present; fix not already here

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/docs exception. Ordinary small bugfix.

**Step 9.4: MAKE YOUR DECISION**
The leak exists in 6.12.111, the fix is surgical, and leaving an NMI
handler registered after tearing down `x86_pmu` is a real stability
defect even if the trigger is uncommon. Benefit/risk supports backport.

===============================================================
What the commit solves and why it matters here
===============================================================

On this tree, `init_hw_perf_events()` registers the `"PMI"` NMI handler,
then sets up cpuhp states and registers the PMU. If any of those later
steps fail, cpuhp is unwound (except the first PREPARE failure, which
just returns) and `x86_pmu` is zeroed — but the NMI handler is left
installed. That handler stays on the NMI_LOCAL list for the rest of the
boot. The patch adds the missing `unregister_nmi_handler()` on those
paths and routes the PREPARE failure through the same cleanup so
`x86_pmu` is cleared consistently.

That matches stable rules: real bug, small, no new API, applies here
without dependencies.

===============================================================
Verification
===============================================================
- [Phase 1] Parsed subject/tags: unregister PMI on init failure; SOB
  Dapeng Mi + Peter Zijlstra; R-b Falcon/Chen; Link msgid
  20260717080342.1879573-2; no Fixes/syzbot
- [Phase 2] Diff: +3/−1 in `init_hw_perf_events`; `return err` → `goto
  pmi_unregister`; add `unregister_nmi_handler(NMI_LOCAL, "PMI")` before
  `out_bad_pmu`
- [Phase 3] Blame: leaky cpuhp errors from `95ca792c7582fd` (v4.8); NMI
  register from `9c48f1c629ecfa` (2011); memset from `916e3a4f950eac`
  (2022), in this tree
- [Phase 3] `git merge-base --is-ancestor
  91787047b1dc52b1fee68b07f79af70aae5fce47 HEAD` → not ancestor (fix
  absent)
- [Phase 3] `git log -S pmi_unregister -- arch/x86/events/core.c` →
  empty
- [Phase 4] `b4 dig -c 91787047...`: matched series; v1–v3 hunk
  unchanged; merged tip/perf/core 2026-08-10
- [Phase 4] Cover letter (lkml.iu.edu / patchew): Sashiko-found PMU
  bugs; this patch is 1/8 and standalone
- [Phase 4] `b4 dig -w`: Peter Zijlstra, Ingo, linux-perf-users CC’d; no
  NAK found
- [Phase 4] lore.kernel.org WebFetch 403; stable-list search did not
  show a rejection
- [Phase 5] `intel_cpuc_prepare` / `amd_pmu_cpu_prepare` return
  `-ENOMEM` — verified trigger for PREPARE cpuhp failure
- [Phase 5] `perf_event_nmi_handler` still callable if handler leaked;
  early-out if `!active_events`
- [Phase 6] `git describe HEAD` → `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion` → 6.12.111
- [Phase 6] Local code at `arch/x86/events/core.c:2108` and `:2144-2201`
  matches the buggy pattern
- [Phase 6] `git apply --check` of the two hunks → rc 0 (clean apply)
- [Phase 8] Failure mode: leaked NMI handler + incomplete `x86_pmu`
  clear; severity MEDIUM; trigger rare (init error)
- UNVERIFIED: full lore mbox body (403); whether linus.git mainline SHA
  differs from tip SHA 91787047 (tip merge confirmed)

The fix is small, surgical, present as a real bug in this 6.12 tree, and
meets the stable criteria.

**YES**

 arch/x86/events/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 330c2ba41f076..2aa9270446634 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2175,7 +2175,7 @@ static int __init init_hw_perf_events(void)
 	err = cpuhp_setup_state(CPUHP_PERF_X86_PREPARE, "perf/x86:prepare",
 				x86_pmu_prepare_cpu, x86_pmu_dead_cpu);
 	if (err)
-		return err;
+		goto pmi_unregister;
 
 	err = cpuhp_setup_state(CPUHP_AP_PERF_X86_STARTING,
 				"perf/x86:starting", x86_pmu_starting_cpu,
@@ -2229,6 +2229,8 @@ static int __init init_hw_perf_events(void)
 	cpuhp_remove_state(CPUHP_AP_PERF_X86_STARTING);
 out:
 	cpuhp_remove_state(CPUHP_PERF_X86_PREPARE);
+pmi_unregister:
+	unregister_nmi_handler(NMI_LOCAL, "PMI");
 out_bad_pmu:
 	memset(&x86_pmu, 0, sizeof(x86_pmu));
 	return err;
-- 
2.53.0

