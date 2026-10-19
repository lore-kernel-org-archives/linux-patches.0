Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF0A50EC0D;
	Mon, 19 Oct 2026 13:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418113; cv=none; b=GHY62tp9rDYPULZGa3lRraPr1erEStziZqMw/dGN0iQ7WQJmBEOXbL059fWuDp1OHuwgyM7eRTae2LNge9YJszf37T6vtj9j3qJ7g8Ubge57DeliziRbi7lzSVk4IKUtknrE/c2hYF7fQe4yJYnY2ypTKvPYZRIRAb28FuDfFfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418113; c=relaxed/simple;
	bh=ob6SbSxU6KL0J9LUBotDK+ahtRmLaWxphDpFbG+VLI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gGWXoh7mIVxGoZQfXiNy6F9mvFoUVugygls9W88CTEC9/a7Fd3eDYU92z0B5U4qGwf0tPFYMxybLNgXSGl177wNxukgGFzBtEaMe+MX62j5eTNKLIxP72H3qwWmUNlb/EvtEKjMRZvICm9ZOgsdR4NJCOhgxsAnC/mvyjdNVOCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jYEmRCMW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jYEmRCMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F411F000C7;
	Mon, 19 Oct 2026 13:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418111;
	bh=Qq0Sy4dDbS/+hJNRzm9nfc0E5/mBfh7kyOCGmA57em8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jYEmRCMWJJWo+Exu7ri6WyQT4YF+Xlvb8KHA7L9skMw4fcJ+ZAKM9djxnrombNjVI
	 ytSs52coqAZ+ALwbFW30z+v4Diw5ZUqzqWAurSwQRU/uePUXi1cVkAx4xSdtT+OuvG
	 42h138CeES7TXPA0vUWAMHndjfqzlBXLuPIPIm6Y7q6z2Yd/g/dhbVGT4qXYlQdsaT
	 Qy3BHMRgzMABCuPoPRwvKhoCEP+pIrSbUrkM+8gRb4r+gsWkcvHZyMfDpCUzcDmwiR
	 orlidJxQtp5iHH8NJcxqdBvVRZX8v0boXYkxM95hheC4a+lByJURil3wqwmmB2JdTY
	 N5XrP0OdEgwGw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
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
Subject: [PATCH AUTOSEL 6.18-5.15] perf/x86/intel/uncore: Fix PCI PMU cleanup on setup failure
Date: Mon, 19 Oct 2026 09:45:10 -0400
Message-ID: <20261019135441.1420968-19-sashal@kernel.org>
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

From: Zide Chen <zide.chen@intel.com>

[ Upstream commit 003267cb94e21d762eb72d6977d84f44f1705bb7 ]

When uncore_pci_pmu_register() fails, pmu->boxes[die] is set to NULL
before returning.  In the uncore_pci_remove() path, this causes
uncore_pci_pmu_unregister() to be skipped entirely, leaking
pmu->activeboxes.  In the uncore_bus_notify() path,
uncore_pci_pmu_unregister() may still be called and must exit early
when pmu->boxes[die] is NULL to avoid a NULL pointer dereference, and
to ensure activeboxes is only decremented for a previously active box.

Additionally, since pci_get_drvdata() returns NULL on registration
failure, uncore_pci_remove() can no longer treat NULL drvdata as an
indicator of an auxiliary PCI device.  Remove the associated
WARN_ON_ONCE().

Signed-off-by: Zide Chen <zide.chen@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://sashiko.dev/#/patchset/20260512233048.9577-1-zide.chen@intel.com?part=1
Link: https://patch.msgid.link/20260611160033.66760-2-zide.chen@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The 6.18.53 file matches the pre-fix code exactly, so this is a clean,
self-contained error-path leak and NULL-deref fix. Full phase
walkthrough follows.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [perf/x86/intel/uncore] [fix] [PCI PMU cleanup on setup failure]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Zide Chen (author)
- Signed-off-by: Peter Zijlstra (Intel) (perf/x86 maintainer)
- Reviewed-by: Dapeng Mi (Intel uncore reviewer)
- Link: https://sashiko.dev/#/patchset/20260512233048.9577-1-
  zide.chen@intel.com?part=1
- Link:
  https://patch.msgid.link/20260611160033.66760-2-zide.chen@intel.com
- No Fixes: tag (expected)
- No Reported-by / Tested-by / syzbot
- No Cc: stable (expected)
- Ignore: [Upstream commit 003267cb94e21d762eb72d6977d84f44f1705bb7] and
  Sasha Levin SOB (pipeline)

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: when `uncore_pci_pmu_register()` fails, `pmu->boxes[die]` is
  NULLed and the box is freed, but `pmu->activeboxes` stays incremented.
- Symptoms: (1) `uncore_pci_remove()` skips unregister because drvdata
  is NULL → `activeboxes` leak; (2) `uncore_bus_notify()` still calls
  unregister → NULL deref of `box`; (3) false `WARN_ON_ONCE()` because
  NULL drvdata is no longer uniquely “extra PCI device”.
- Version info: none in the message. Code dates to 2020.
- Root cause: incomplete error-path rollback in
  `uncore_pci_pmu_register()`, and unregister not tolerating a NULL box.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not hidden. Explicit leak + NULL-deref + false-WARN fix. The
“remove WARN_ON” piece is diagnostic, not a new feature.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `arch/x86/events/intel/uncore.c` (+4 / −1)
- Functions: `uncore_pci_pmu_register()`, `uncore_pci_pmu_unregister()`,
  `uncore_pci_remove()`
- Scope: single-file surgical fix (5 lines)

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Hunk 1 (`uncore_pci_pmu_register`): first-box `uncore_pmu_register()`
  failure already NULLed `boxes[die]`, exited and freed the box, but
  left `activeboxes` incremented. After: `atomic_dec(&pmu->activeboxes)`
  on that path.
- Hunk 2 (`uncore_pci_pmu_unregister`): previously always used `box` and
  decremented `activeboxes`. After: return immediately if `box` is NULL
  (no deref, no bogus decrement).
- Hunk 3 (`uncore_pci_remove`): drop `WARN_ON_ONCE(i >=
  UNCORE_EXTRA_PCI_DEV_MAX)` when drvdata is NULL.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: error-path resource leak + NULL pointer dereference (and a
  false WARN).
- Mechanism: `atomic_inc_return(&pmu->activeboxes)` runs before
  `uncore_pmu_register()`. On failure the box is torn down but the
  counter is not. Discovery/`bus_notify` still looks up the PMU by PCI
  identity and calls unregister, which does `uncore_box_exit(box)` on
  NULL (`box->flags`).
- Leak consequence: the next box of the same PMU sees `activeboxes > 1`
  and skips `uncore_pmu_register()`, so the PMU never appears in perf.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Quality: obviously correct. Decrement matches the increment; NULL
  guard is the standard pattern; no API/data-structure change.
- Regression risk: very low. Sashiko noted that PCI probe failure does
  not call `remove()`, so the WARN removal is not strictly required for
  that path. That only drops a diagnostic; it does not create a crash.
  The NULL check is required for `uncore_bus_notify()`, which is
  independent of `remove()`.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Buggy register error path: `16fa64315c1bd` (“Factor out
  uncore_pci_pmu_register()”), Kan Liang, 2020-09-14. First mainline:
  v5.10-rc1.
- Unregister without NULL check: `cdcce92a3a03bc` (2020).
- WARN_ON_ONCE: `899396cf7b4b31` (Yan Zheng, 2013).
- Long-lived code, present in this 6.18 tree.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Introducer is `16fa64315c1bd`, which **is** an
ancestor of v6.18.53.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- This is v3 1/8 of “PMU setup robustness fixes”.
- Series: 1/8 this fix; 2/8 refcnt cleanup; 3/8 init_box errors; 4/8
  keep PCI PMUs if MMIO/MSR alloc fails; 5/8 factor box setup; 6–8
  flags/lazy setup.
- 4/8 (`d623e292c6a4c`) is already in v6.18.53. 2/8 and 5/8 are not.
- This patch does not depend on 2/8+; later patches build on it.
  Standalone.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Zide Chen is an active Intel uncore contributor on this tree
(die-id, discovery, IMC events, etc.). Maintainer path: Peter Zijlstra
SOB. Dapeng Mi Reviewed-by.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: No missing helpers or types. Parent of the candidate and
`v6.18.53:arch/x86/events/intel/uncore.c` are byte-identical (same
sha256). Applies standalone. Dry-run `patch -p1` against the v6.18.53
file succeeded.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 540120722e9bf`: `[PATCH V3 1/8] perf/x86/intel/uncore: Fix
  PCI PMU cleanup on setup failure`
- URL:
  https://patch.msgid.link/20260611160033.66760-2-zide.chen@intel.com
- lore.kernel.org WebFetch returned 403; full thread saved via `b4 dig
  -m` (26 messages).
- V1/V2 existed; this patch was **new in v2** after Sashiko review of
  v1. v3 only added Reviewed-by. Applied version is latest.
- Cover letter: “PCI PMU cleanup on setup failure has activeboxes leaks
  and potential NULL pointer dereference in error paths.”
- No NAK. tip-bot applied it to perf/core (2026-06-30).
- Sashiko on v3: questioned WARN_ON removal (Medium); two High notes
  were pre-existing UAF/races, not introduced by this patch. No stable
  NAK.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: `b4 dig -w` recipients: Peter Zijlstra, Ingo Molnar, Arnaldo,
Namhyung Kim, Ian Rogers, Adrian Hunter, Alexander Shishkin, Andi Kleen,
Stephane Eranian, linux-kernel, linux-perf-users, Dapeng Mi. Dapeng
Reviewed-by on the committed patch; Peter Zijlstra SOB.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla. Found by code review (Sashiko on v1 → new
patch 1 in v2). Still a real, reachable error path, not a theoretical
rewrite.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: 8-patch robustness series. This 1/8 is self-contained. 4/8
already landed in this 6.18.53 tree. Later patches are larger (broken-
state, lazy MSR/MMIO) and are not required for this leak/NULL-deref fix.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable WebFetch returned 403. UNVERIFIED whether
stable@ discussed it. Not used as a NO signal (absence of Cc: stable is
expected).

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `uncore_pci_pmu_register`, `uncore_pci_pmu_unregister`,
`uncore_pci_remove`. Related: `uncore_pci_probe`, `uncore_bus_notify`,
`uncore_pci_pmus_register`, `uncore_pci_sub_driver_init`.

Step 5.2: TRACE CALLERS
Record:
- `uncore_pci_pmu_register`: `uncore_pci_probe` (legacy
  `uncore_pci_driver`), `uncore_pci_sub_driver_init` (PCI sub-devices),
  `uncore_pci_pmus_register` (discovery; return value ignored).
- `uncore_pci_pmu_unregister`: `uncore_pci_remove`, `uncore_bus_notify`.
- `uncore_bus_notify`: PCI `BUS_NOTIFY_DEL_DEVICE`. Discovery always
  registers this notifier.
- Context: driver init / PCI probe / PCI device deletion. Not a syscall
  hot path, but boot and hot-unplug on Intel systems with uncore
  (default `y`).

Step 5.3: TRACE CALLEES
Record:
- `uncore_pmu_register()` → `perf_pmu_register()` (can fail: ENOMEM,
  sysfs/device_add, name collision).
- `uncore_box_exit()` at v6.18.53: `test_and_clear_bit(...,
  &box->flags)` — NULL `box` is a hard oops.
- `kfree(NULL)` is safe; the crash is `uncore_box_exit`.

Step 5.4: FOLLOW THE CALL CHAIN
Record:
- Modern Intel (no `uncore_pci_driver`): `uncore_pci_init` →
  `uncore_pci_pmus_register` → register (retval ignored) →
  `bus_register_notifier`. Failed first-box `perf_pmu_register` + later
  `BUS_NOTIFY_DEL_DEVICE` → `uncore_pci_find_dev_pmu_from_types` still
  finds the PMU → unregister(NULL) → oops.
- Same PMU, later boxes: `activeboxes > 1` skips `uncore_pmu_register` →
  uncore PMU missing from perf.
- Reachable without a special debug option.
  `CONFIG_PERF_EVENTS_INTEL_UNCORE` defaults to y on Intel+PCI.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: MSR/MMIO setup is a different model; this series later factors
PCI lazy registration for those paths. No duplicate of this exact PCI
error-path bug in-tree. 2/8 adds refcnt decrement in unregister and is a
follow-up cleanup, not a prerequisite.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- Local tree: `v6.18.53-5049-g0f0bdc2b0dffb`, `make kernelversion`
  6.18.53.
- At v6.18.53, `uncore_pci_pmu_register` still omits `atomic_dec` on
  `uncore_pmu_register()` failure; unregister has no NULL check;
  `WARN_ON_ONCE` is present. Bug exists here.
- Introduced v5.10-rc1; not after 6.18 branched.
- `git merge-base --is-ancestor 16fa64315c1bd v6.18.53` → yes.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Expected apply: **clean**. Candidate parent `uncore.c` sha256
equals v6.18.53 `uncore.c`. Dry-run apply succeeded.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No other “PCI PMU cleanup” fix in v6.18.53. 4/8 of the same
series is already in 6.18.53 (`d623e292c6a4c`). That does not fix this
leak/NULL deref.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [arch/x86/events/intel uncore PMU] [IMPORTANT — default-on Intel
server/workstation perf, not core mm/sched, but widely enabled]

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature (2012+) with ongoing platform adds (PTL, WCL, etc.). This
bug is old incomplete error handling, not a brand-new driver.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Intel x86 with `CONFIG_PERF_EVENTS_INTEL_UNCORE` (default y).
Driver-specific / config-default-on. Discovery platforms (newer Xeon)
hit the bus-notify NULL deref path.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record:
- Trigger: first box of a PCI uncore PMU fails `perf_pmu_register()`
  (ENOMEM, sysfs failure, name clash).
- Not every boot, but a real error path. Discovery ignores register
  failure and still installs the notifier.
- Unprivileged users do not trigger it directly; PCI unbind/hotplug and
  boot setup do. Missing PMU is user-visible to perf.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- NULL deref in `uncore_box_exit(NULL)` on device delete → oops.
  **HIGH** (crash on error + unplug).
- `activeboxes` leak → later boxes skip PMU registration → uncore events
  absent. **MEDIUM–HIGH**.
- False WARN_ON. **LOW**.
- Overall: **HIGH** (crash on a reachable error path).

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: high — prevents oops and silently missing uncore PMUs after a
  failed first-box register.
- Risk: very low — 5 lines, no locking/API change, WARN removal is the
  only nit.
- Ratio: strongly favorable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

FOR backporting:
- Real leak of `pmu->activeboxes` on `uncore_pmu_register()` failure
  (code at v6.18.53 matches).
- Real NULL deref: discovery `uncore_pci_pmus_register()` ignores
  failure, `uncore_bus_notify` still unregisters,
  `uncore_box_exit(NULL)` oopses.
- Same leak causes later boxes to skip `uncore_pmu_register()`, so the
  PMU never shows up in perf.
- 5-line, obviously correct, no new API.
- Applies cleanly; file is identical to the pre-fix version.
- Bug present since v5.10; this 6.18 tree has it.
- Reviewed by Dapeng Mi; SOB Peter Zijlstra.
- Patch 1/8 is standalone; later series members not required.
- Same series 4/8 already in this 6.18.53 tree.

AGAINST:
- Trigger is an error path (`perf_pmu_register` failure), not a always-
  on boot crash.
- No user/syzbot report.
- Sashiko: WARN_ON removal is weakly justified for the `pci_driver`
  probe/remove model (probe failure does not call remove). Diagnostic-
  only concern.
- Later 2/8 refcnt cleanup is related but separate; not a blocker.

UNRESOLVED:
- Stable mailing list search via lore HTTP was 403 (mbox/review still
  obtained via b4).
- How often `perf_pmu_register` actually fails in production:
  unverified, but ENOMEM/sysfs failure is a standard, reachable errno
  path.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — counter rollback + NULL
   guard; maintainer SOB; Dapeng review; in mainline perf/core.
2. Fixes a real bug that affects users? **PASS** — leak, skipped PMU
   registration, oops on device delete.
3. Important issue? **PASS** — NULL deref oops; missing uncore PMU.
   Severity HIGH.
4. Small and contained? **PASS** — 5 lines, one file.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — clean apply to v6.18.53
   `uncore.c`.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary small
bugfix; does not need an exception.

Step 9.4: MAKE YOUR DECISION
This belongs in 6.18.y: the buggy rollback is in this tree, the fix is
surgical, and the failure mode is a kernel oops plus a stuck/missing PCI
uncore PMU. WARN_ON removal is a minor diagnostic tradeoff, not a reason
to reject the leak and NULL-deref fix.

What the commit solves for stable users: Intel uncore PCI PMU setup
failure currently leaks `activeboxes` and can oops in
`uncore_bus_notify` when the device goes away. Backporting restores
counter balance, skips unregister when there is no box, and avoids a
false WARN.

Risk vs benefit: benefit is crash/functional correctness on a default-on
Intel perf driver; risk is a 5-line error-path change that applies with
no prerequisites.

Verification:
- [Phase 1] Parsed tags: SOB Zide Chen, SOB Peter Zijlstra, Reviewed-by
  Dapeng Mi; Links to sashiko and patch.msgid.link; no Fixes/syzbot.
- [Phase 2] Diff: +`atomic_dec` on register failure; +`if (!box) return`
  in unregister; −`WARN_ON_ONCE` in remove. 4+/1− in `uncore.c`.
- [Phase 2] `uncore_box_exit` at v6.18.53 dereferences `box->flags` —
  NULL box is an oops.
- [Phase 3] blame: register failure path from `16fa64315c1bd`
  (v5.10-rc1); present in v6.18.53.
- [Phase 3] `git merge-base --is-ancestor 16fa64315c1bd v6.18.53` → yes.
  Candidate itself is not an ancestor of v6.18.53.
- [Phase 3] Parent `uncore.c` sha256 == v6.18.53 `uncore.c`; `patch -p1
  --dry-run` succeeded.
- [Phase 3] Series 1/8 standalone; 4/8 `d623e292c6a4c` already in
  v6.18.53; 2/8 and 5/8 not in v6.18.53 and not required.
- [Phase 4] `b4 dig -c 540120722e9bf`: V3 1/8,
  https://patch.msgid.link/20260611160033.66760-2-zide.chen@intel.com
- [Phase 4] `b4 dig -a`: v1→v3; this patch added in v2 after Sashiko; v3
  is what landed.
- [Phase 4] `b4 dig -w`: perf maintainers CC’d; Dapeng Reviewed-by; no
  NAK.
- [Phase 4] mbox cover letter explicitly calls out activeboxes leak and
  NULL deref.
- [Phase 4] lore HTTP 403; discussion recovered from b4 mbox. Stable-
  list search UNVERIFIED (403).
- [Phase 5] Callers: probe, sub-driver init, discovery
  `uncore_pci_pmus_register` (ignores retval, always registers bus
  notifier).
- [Phase 5] `uncore_pmu_register` → `perf_pmu_register` can fail.
- [Phase 6] `git describe HEAD` = v6.18.53-5049-g0f0bdc2b0dffb;
  `Makefile` 6.18.53; buggy code at v6.18.53 lines 1166–1172 / 1229–1238
  / 1257.
- [Phase 7] `CONFIG_PERF_EVENTS_INTEL_UNCORE` default y.
- [Phase 8] Failure mode: NULL deref oops + skipped PMU registration;
  severity HIGH.
- UNVERIFIED: production frequency of `perf_pmu_register` failure;
  stable@ lore thread (HTTP 403).

**YES**

 arch/x86/events/intel/uncore.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/uncore.c b/arch/x86/events/intel/uncore.c
index a5793847ed5a9..3d9973c416ecf 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -1165,6 +1165,7 @@ static int uncore_pci_pmu_register(struct pci_dev *pdev,
 	/* First active box registers the pmu */
 	ret = uncore_pmu_register(pmu);
 	if (ret) {
+		atomic_dec(&pmu->activeboxes);
 		pmu->boxes[die] = NULL;
 		uncore_box_exit(box);
 		kfree(box);
@@ -1230,6 +1231,9 @@ static void uncore_pci_pmu_unregister(struct intel_uncore_pmu *pmu, int die)
 {
 	struct intel_uncore_box *box = pmu->boxes[die];
 
+	if (!box)
+		return;
+
 	pmu->boxes[die] = NULL;
 	if (atomic_dec_return(&pmu->activeboxes) == 0)
 		uncore_pmu_unregister(pmu);
@@ -1254,7 +1258,6 @@ static void uncore_pci_remove(struct pci_dev *pdev)
 				break;
 			}
 		}
-		WARN_ON_ONCE(i >= UNCORE_EXTRA_PCI_DEV_MAX);
 		return;
 	}
 
-- 
2.53.0

