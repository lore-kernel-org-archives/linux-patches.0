Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BB75208B6;
	Mon, 19 Oct 2026 13:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418115; cv=none; b=gNTZ9yu4n6yIKJqr6/fCUVTDop9I1R4P4hfvnyvAyjXAzZNet0R4J47AvNgFSBvyG5FVGLiNYzfEilbHNyEo2Q27WBT8rI7AST2oPjNif5tF2VHClYPn8BiJAceN2d8eFDceZxr3NozzoUpUuWONPoPJKfEO6vcKm5f8Ze6Nj4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418115; c=relaxed/simple;
	bh=U4koSAER90SeyEy0tNlP4fPNMDTpolOLeef99Vb0ERc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gr9JUOMQkAGTV4XlYXt0uL2gHbl916nA4cWQk0ZXg6/C78A2n8T+JWlm57ZMl9iQkeajqHhIS3IxJR79wC4KETA5XrHosjhJccBT2D02y25iyfvVMzwYbqKqaE6Xnnd/lnkkxaUKoPAH2Hl+MpmK8IYYEK3oCVLvZx1MgUckXLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nk2HhtdZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nk2HhtdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFB51F000C9;
	Mon, 19 Oct 2026 13:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418113;
	bh=l0Uk1/DpNZ6w/8m/csQtHlUf7Na9Gh7XbL1dzLVVlGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nk2HhtdZdyOcTnpPsWePcb/BYZjhgMdipMmeb3D7WEYggkLrA+coTSRRAlkiOUbYE
	 efSrkIeqCzLoXFw0Sbw7AXAOSbLbpCidk/jQaxAO5c4XYzqEVZLSeewSCM9jkr88nW
	 dtNOsgzBbcOnmF5ooQhWOF/u9b9wf52nCaJYPYyxPOLrGiIUTtOde07BxHO+uN/zR5
	 L478eNskSnAoo3o2GT5RgL8VJi3taQRfpjp863yv6lZ7nUYw0h+PTjNgikSUIjakGO
	 vztRYkK6KsnG2jVfPhgl5lT/6pnPufRr/RPApyEEt52TnMBvTcy4ZxpLI9v4g+BrQh
	 aK72/TpFDFFYw==
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
Subject: [PATCH AUTOSEL 6.18-6.1] perf/x86: Free hybrid state on PMU init failure
Date: Mon, 19 Oct 2026 09:45:11 -0400
Message-ID: <20261019135441.1420968-20-sashal@kernel.org>
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

[ Upstream commit 96746e731e1626545e343974ca4673739dceb31b ]

If PMU initialization fails, for example in check_hw_exists(), hybrid
state can be left partially initialized: x86_pmu.hybrid_pmu is not freed
and perf_is_hybrid remains set. This can leak memory and leave stale
hybrid state reachable after a failed init path.

Add x86_pmu_free_hybrid() and use it on PMU init failure paths so all
hybrid-related state is consistently reset.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Thomas Falcon <thomas.falcon@intel.com>
Reviewed-by: Zide Chen <zide.chen@intel.com>
Link: https://patch.msgid.link/20260717080342.1879573-3-dapeng1.mi@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). The hybrid PMU
init/error path exists here, and this commit is a real error-path
UAF/leak fix that belongs in this tree.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[perf/x86] [Free] [release hybrid PMU state when PMU init
fails]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- No `Fixes:` tag (expected for this review pipeline)
- No `Reported-by:` / syzbot
- No `Tested-by:`
- `Reviewed-by: Thomas Falcon <thomas.falcon@intel.com>`
- `Reviewed-by: Zide Chen <zide.chen@intel.com>`
- `Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>` (author)
- `Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>` (perf
  maintainer)
- `Link: https://patch.msgid.link/20260717080342.1879573-3-
  dapeng1.mi@linux.intel.com`
- No `Cc: stable` (not a negative signal)

SHA on `origin/master`: `96746e731e1626545e343974ca4673739dceb31b` (not
an ancestor of HEAD).

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** On hybrid Intel PMU init failure (example:
  `check_hw_exists()`), `x86_pmu.hybrid_pmu` is not freed and
  `perf_is_hybrid` stays enabled.
- **Symptom:** Memory leak plus leftover hybrid state after a failed
  init.
- **Root cause:** `intel_pmu_init_hybrid()` allocates `hybrid_pmu` and
  enables the static key; `init_hw_perf_events()` error paths
  `memset(&x86_pmu, 0, ...)` without freeing or disabling that key. The
  hybrid `perf_pmu_register` fail path kfree's too early and still
  leaves the static key set.
- **Version:** Hybrid PMUs exist since 2021; this tree has them.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. It is an explicit error-path leak/stale-state
fix. The delayed `kfree` also removes a use-after-free on the hybrid
register-fail path (see Phase 2/5).

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `arch/x86/events/core.c` (+12 / −3)
- New helper: `x86_pmu_free_hybrid()`
- Modified: `init_hw_perf_events()` (hybrid register-fail block and
  `out_bad_pmu`)
- Scope: single-file surgical error-path fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Hunk 1:** Add `x86_pmu_free_hybrid()`: if `hybrid_pmu` is set,
  disable `perf_is_hybrid`, `kfree` the array, NULL it, set
  `num_hybrid_pmus = 0`.
- **Hunk 2 (before):** Hybrid `perf_pmu_register` failure kfree's the
  array, NULLs it, zeros the count, then `goto out2` (cpuhp teardown,
  then `memset`).
- **Hunk 2 (after):** Only unregister already-registered PMUs and `goto
  out2`; free/reset happens later in `out_bad_pmu`.
- **Hunk 3:** `out_bad_pmu` calls `x86_pmu_free_hybrid()` **before**
  `memset(&x86_pmu, 0, ...)`.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Error-path resource leak + UAF + stale static key**

Verified in this tree (`init_hw_perf_events`, `intel_pmu_init_hybrid`,
`intel_pmu_cpu_dead`):

1. **Leak on early failure:** `intel_pmu_init_hybrid()` does `kcalloc` +
   `static_branch_enable(&perf_is_hybrid)`. If `check_hw_exists()` then
   fails, 6.12 jumps to `out_bad_pmu` and only `memset`s `x86_pmu`,
   dropping the pointer without `kfree`. `perf_is_hybrid` stays enabled.

2. **UAF on hybrid register failure:** By the time `perf_pmu_register`
   runs, `CPUHP_AP_PERF_X86_STARTING` has already run
   `intel_pmu_cpu_starting()` → `init_hybrid_pmu()`, which sets
   `cpuc->pmu` into the `hybrid_pmu` array. Current 6.12 code `kfree`s
   that array **then** `goto out2` →
   `cpuhp_remove_state(CPUHP_PERF_X86_PREPARE)` → `x86_pmu_dead_cpu()` →
   `intel_pmu_cpu_dead()`:

```5209:5210:arch/x86/events/intel/core.c
        if (is_hybrid() && cpuc->pmu)
                cpumask_clear_cpu(cpu,
&hybrid_pmu(cpuc->pmu)->supported_cpus);
```

`is_hybrid()` is still true and `cpuc->pmu` still points at freed
memory. That is a use-after-free. Moving the free to after cpuhp
teardown fixes it.

3. **Stale static key:** The old register-fail path never called
   `static_branch_disable(&perf_is_hybrid)`.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct and minimal. `static_branch_disable` + `kfree`
+ NULL during `__init` teardown is low risk. Free-after-cpuhp is the
right order. No API change. Regression risk is low.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Hybrid register/kfree block: `d9977c43bff89` (“perf/x86: Register
  hybrid PMUs”, 2021-04-19) — present in 6.12.
- `intel_pmu_init_hybrid()` alloc/static key: `97588df87b56e2` (Kan
  Liang, 2023-08-29) — present in 6.12.
- `out_bad_pmu` memset: `916e3a4f950eac` (Paolo Bonzini, 2022) — present
  in 6.12.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Bug was introduced with hybrid PMU support
(2021/2023), well before 6.12.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: This is v3 **2/8** of Dapeng Mi’s “Miscellaneous PMU bug fixes
and optimizations”.
- Parent: `91787047b1dc5` “Unregister PMI handler on PMU init failure”
  (adds `pmi_unregister:`) — **not** in this tree.
- Next: `278a3731c9d08` “Guard intel_pmu_cpu_dead() against invalid
  hybrid PMU casts” — separate OOB/`container_of` bug; not required for
  this leak/UAF fix.
This patch is standalone: the helper only needs to run before `memset`
at `out_bad_pmu`.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Dapeng Mi is an Intel perf contributor. Same series has several
hybrid/error-path fixes. Applied by Peter Zijlstra.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Patch 1 is **not** a functional prerequisite. It only changes
nearby labels (`pmi_unregister`, `goto pmi_unregister` instead of
`return err`). `x86_pmu_free_hybrid()` can be added to 6.12’s existing
`out_bad_pmu`. No new helpers or structs.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 96746e731e162` → https://patch.msgid.link/20260717080342.18
  79573-3-dapeng1.mi@linux.intel.com
- Revisions: v1 (2026-07-10, 2/7), v2 (2026-07-13, 2/7), v3 (2026-07-17,
  2/8). This hunk did not change across revisions.
- Cover letter: bugs found in review (Sashiko) of a later SIMD/eGPR
  sampling series, not from a production crash.
- Zide Chen: `Reviewed-by` for the whole series. Author called the
  series “low risky”. No NAKs found.
- Merged to tip perf/core 2026-08-12, then Linus.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): Peter Zijlstra, Ingo Molnar, Arnaldo Carvalho de
Melo, Namhyung Kim, Ian Rogers, Adrian Hunter, Alexander Shishkin, Andi
Kleen, Stephane Eranian, linux-kernel, linux-perf-users, Zide Chen,
Thomas Falcon. Maintainer applied it.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla. Found by code review of hybrid init error
paths.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone among 8 patches. Patch 1 (NMI unregister) and patch 3
(cpu_dead hybrid cast) are related but independent.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: No stable-list discussion found for this subject. Not a reason
to skip it.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: KEY FUNCTIONS**
Record: `x86_pmu_free_hybrid()` (new), `init_hw_perf_events()`
(modified). Related existing: `intel_pmu_init_hybrid()`,
`intel_pmu_cpu_dead()`, `x86_pmu_dead_cpu()`.

**Step 5.2: TRACE CALLERS**
Record:
- `init_hw_perf_events()`: `early_initcall`, once at boot.
- `x86_pmu_free_hybrid()`: only `out_bad_pmu`.
- `intel_pmu_cpu_dead()`: `x86_pmu.cpu_dead` from `x86_pmu_dead_cpu` on
  CPUHP_PERF_X86_PREPARE teardown (init rollback and later CPU down).
- `is_hybrid()` used in `get_possible_counter_mask()`, `is_x86_event()`,
  `allocate_fake_cpuc()`, `x86_pmu_event_init()`,
  `intel_pmu_cpu_starting()`, `intel_pmu_cpu_dead()`, and `hybrid()`
  macros.

**Step 5.3: TRACE CALLEES**
Record: `static_branch_disable()`, `kfree()`. No locks, no I/O.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Boot-time hybrid Intel PMU init (Alder/Raptor/Meteor/Lunar/Arrow
Lake in this tree). Triggered by `check_hw_exists()` failure (broken
PMU, hypervisor without PMU) or `perf_pmu_register()` failure. Not a
normal syscall path; it is a boot/error path. Register-fail UAF runs in
cpuhp teardown while the array is already freed.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same series cleans other hybrid error paths (NMI leak, invalid
`hybrid_pmu()` cast). `01c153956b443` (“Validate the return value of
intel_pmu_init_hybrid()”) is a related NULL-deref fix and is **not** in
this tree; not required here.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.**
- Tree: `p-6.12-3-gc504cf0baa3d8`, `VERSION=6 PATCHLEVEL=12
  SUBLEVEL=111`
- `git merge-base --is-ancestor 96746e731e162 HEAD` → not an ancestor
- 6.12 `init_hw_perf_events()` still kfree's on register fail, then
  `memset`s at `out_bad_pmu` with no `x86_pmu_free_hybrid()` and no
  `static_branch_disable`
- `intel_pmu_init_hybrid()` still allocates and enables `perf_is_hybrid`

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Minor conflicts, easy backport.**
- `git apply --check` of the raw diff fails: `x86_pmu_show_pmu_cap()`
  log strings differ, and mainline has `pmi_unregister:` from patch 1.
- The real change is still: add the helper after
  `x86_pmu_show_pmu_cap()`, drop the three-line kfree in the register-
  fail block, call the helper just before `memset` at `out_bad_pmu`.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No `x86_pmu_free_hybrid`, no “Free hybrid state” commit.
Register-fail still does the early `kfree`.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: SUBSYSTEM AND CRITICALITY**
Record: **arch/x86/events (x86 perf PMU)** — **IMPORTANT**. Hybrid Intel
CPUs are common (ADL/RPL/MTL/LNL/ARL). Not core mm/VFS, but production
x86 hardware.

**Step 7.2: SUBSYSTEM ACTIVITY**
Record: Mature PMU core with ongoing hybrid work. Bug has been in hybrid
support since it landed, not a last-month feature.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: WHO IS AFFECTED**
Record: Intel hybrid x86 systems where PMU init fails (VMs without a
usable PMU, broken BIOS/MSRs, or `perf_pmu_register` failure). Not
universal; config `PERF_EVENTS` + hybrid CPU models.

**Step 8.2: TRIGGER CONDITIONS**
Record:
- `check_hw_exists()` false after `intel_pmu_init_hybrid()` — leak +
  leftover `perf_is_hybrid`. Common-ish in hypervisors; uncommon on
  healthy bare metal.
- Hybrid `perf_pmu_register` failure after cpuhp STARTING — **UAF** in
  `intel_pmu_cpu_dead()`. Rare (ENOMEM/name clash) but a real error
  path.
Not unprivileged-syscall triggered.

**Step 8.3: FAILURE MODE SEVERITY**
Record:
- Register-fail + early kfree: **UAF** → crash/KASAN — **HIGH**
- Early `check_hw_exists` fail: small one-time leak of `num_hybrid_pmus
  * sizeof(struct x86_hybrid_pmu)` plus leftover `is_hybrid()` —
  **MEDIUM** (leak) / **MEDIUM-HIGH** if later `hybrid()` users run with
  a NULL/zeroed `x86_pmu`
Overall: **HIGH** because of the UAF, not only the leak.

**Step 8.4: RISK-BENEFIT RATIO**
Record:
- Benefit: closes UAF + leak + stale static key on hybrid init failure.
  High for those systems, zero for others.
- Risk: ~12 lines, `__init` error path only, no locking/API change.
  **Low**.
- Ratio: **favor backport**.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Buggy code is in this 6.12 tree (hybrid since 2021).
- Fixes a real leak (`memset` drops `hybrid_pmu` without `kfree`).
- Fixes a real UAF: kfree of `hybrid_pmu` before `cpuhp_remove_state` →
  `intel_pmu_cpu_dead()` → `hybrid_pmu(cpuc->pmu)`.
- Also clears `perf_is_hybrid`, which the register-fail path never did.
- Small (12/−3), obviously correct, reviewed by Intel and applied by
  Peter Zijlstra.
- Standalone; patch 1 is only context.

AGAINST:
- No production/syzbot report; found in review.
- Register-fail UAF is a rare path.
- Raw mainline diff does not apply cleanly (log text +
  `pmi_unregister`).
- One-time init leak alone would be weak; the UAF is what makes it
  important.

UNRESOLVED:
- Could not fetch lore HTML (403); used `b4 dig` + Patchew instead.
  Reviews/NAKs still verified.
- Exact `sizeof(struct x86_hybrid_pmu)` not measured; leak is still a
  bounded boot-time allocation.

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — reviewed, tested (`perf
   test` on Diamond Rapids/Nova Lake), merged via tip.
2. Fixes a real bug that affects users? **PASS** — leak + UAF + stale
   hybrid key on hybrid init failure.
3. Important (crash/security/corruption/deadlock)? **PASS** — UAF on
   cpuhp rollback after hybrid register failure; leftover hybrid key
   after failed init.
4. Small and contained? **PASS** — one file, ~15 lines.
5. No new features or APIs? **PASS** — static helper on the existing
   error path.
6. Can apply to the local tree? **PASS** — needs a trivial backport
   (insert helper, drop 3 lines, call before `memset`); no missing APIs.

**Step 9.3: EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/docs exception. Ordinary error-path
memory-safety fix.

**Step 9.4: DECISION**
This tree has the hybrid init bug. The patch is small, correct, and
fixes UAF plus leak on failure. Context from later mainline
(`pmi_unregister`) is not required. It should be backported to this 6.12
tree.

Verification:
- [Phase 1] Tags: Reviewed-by Falcon/Chen; SOB Zijlstra; Link msgid
  `...-3-dapeng1.mi@linux.intel.com`; no Fixes/syzbot
- [Phase 1] SHA `96746e731e162` on origin/master; `merge-base --is-
  ancestor` vs HEAD = not present
- [Phase 2] Diff: +12/−3 in `arch/x86/events/core.c`; helper + delayed
  free + `out_bad_pmu` call
- [Phase 2] 6.12 `init_hw_perf_events` still early-kfrees at lines
  2184–2186, then memset at 2200 with no static-key disable
- [Phase 2/5] `intel_pmu_cpu_dead()` uses `hybrid_pmu(cpuc->pmu)` when
  `is_hybrid()`; `x86_pmu_dead_cpu` is the PREPARE teardown
- [Phase 3] Hybrid register path blamed to `d9977c43bff89` (2021);
  alloc/key to `97588df87b56e2` (2023)
- [Phase 3] Parent `91787047b1dc5` (NMI unregister) not in HEAD; not
  required
- [Phase 4] `b4 dig -c 96746e731e162` matched v3 2/8; v1→v3 hunk
  unchanged; no NAK
- [Phase 4] Cover letter: review-found bugs; Zide Chen Reviewed-by for
  series
- [Phase 4] lore.kernel.org HTTP 403; Patchew used instead
- [Phase 5] `intel_pmu_init_hybrid()` enables `perf_is_hybrid` after
  `kcalloc` (this tree, ~6360)
- [Phase 6] `git describe HEAD` = p-6.12-3-gc504cf0baa3d8; `make
  kernelversion` = 6.12.111
- [Phase 6] `git apply --check` of raw commit fails on
  `x86_pmu_show_pmu_cap` context; logic still maps onto 6.12
  `out_bad_pmu`
- [Phase 8] Failure mode: UAF in `intel_pmu_cpu_dead` after hybrid
  register fail; leak on `check_hw_exists` fail
- UNVERIFIED: live reproduction of `perf_pmu_register` failure; exact
  leaked byte count

The fix is small, matches this tree’s hybrid init code, and closes a
real UAF/leak on PMU init failure.

**YES**

 arch/x86/events/core.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 2aa9270446634..7c37c228a88a4 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2087,6 +2087,17 @@ void x86_pmu_show_pmu_cap(struct pmu *pmu)
 	pr_info("... global_ctrl mask:          %016llx\n", hybrid(pmu, intel_ctrl));
 }
 
+static void x86_pmu_free_hybrid(void)
+{
+	if (!x86_pmu.hybrid_pmu)
+		return;
+
+	static_branch_disable(&perf_is_hybrid);
+	kfree(x86_pmu.hybrid_pmu);
+	x86_pmu.hybrid_pmu = NULL;
+	x86_pmu.num_hybrid_pmus = 0;
+}
+
 static int __init init_hw_perf_events(void)
 {
 	struct x86_pmu_quirk *quirk;
@@ -2214,9 +2225,6 @@ static int __init init_hw_perf_events(void)
 			for (j = 0; j < i; j++)
 				perf_pmu_unregister(&x86_pmu.hybrid_pmu[j].pmu);
 			pr_warn("Failed to register hybrid PMUs\n");
-			kfree(x86_pmu.hybrid_pmu);
-			x86_pmu.hybrid_pmu = NULL;
-			x86_pmu.num_hybrid_pmus = 0;
 			goto out2;
 		}
 	}
@@ -2232,6 +2240,7 @@ static int __init init_hw_perf_events(void)
 pmi_unregister:
 	unregister_nmi_handler(NMI_LOCAL, "PMI");
 out_bad_pmu:
+	x86_pmu_free_hybrid();
 	memset(&x86_pmu, 0, sizeof(x86_pmu));
 	return err;
 }
-- 
2.53.0

