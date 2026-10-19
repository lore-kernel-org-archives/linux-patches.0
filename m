Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E698646984;
	Mon, 19 Oct 2026 14:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418794; cv=none; b=ttCE70n2qAnK9GoqD5MSpkLvo3vqnsOk2sTHNLX3pPUFnpPS8j8gOXQshKZppf4z+3ClKXHzJPWFTOrzjmJjcjxv1iUSjgQ6YxEAqC/zdNMFTuO/w8nJ8+8RcmgXXZQMYSuH9Neervh0We3sVIwOz3mk9l7HJEFA5Rr4P9YX0gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418794; c=relaxed/simple;
	bh=DIjaZS84LAc19WXPq5YOGaiFUOcay9QyGAgedbAcO9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bXfISiFUDVZa7k6Zfc9aK9bcb4MizNdcr+/7glc8AlPkEnHQ2/cK0cG1NWgZEQVv1cmG4hxnP9v+1RXb4B0Qka98zEj/0snLaYmVGXFbECWJNMgoR9gHyfMsG/XAMP3P0zHp/8GSEEovMNcanzGx5Obb5N5BD4DK/R85CT7vLEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NUA3H4Za; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NUA3H4Za"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF371F000C4;
	Mon, 19 Oct 2026 14:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418791;
	bh=zjAjO0BSBACDj5Kt6V/l7hCPxN8HOcQsmHMRubHsGJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NUA3H4Zalv5BEjYKOw13yIS1g6S3vGN7u2RzTV0c+k6iG3NpRLAP+mx+k0FAN4EkQ
	 0x9Kjdecay3BzK99Vuy7TKt35jujhKl/r3/q0lEChCGXZ+fy2jQT8bZvOYCyBEOdOm
	 qzCGaJ3VJYtDIBJDKOWk2JxjRVmw1b6UuZcU3FZzCxah46n2wAHVmM6PZGvO69Zep2
	 ObHX2pvpLfB8+33d08Ow+e+lPVYucqPU3ZAfeflumS4IDe91tg043w2cRRRCe7hRQb
	 X23q45UmLcq9wTrSnUTqze76voIb52e/cbwdgC5Mbmaz8+bLMWh3TmNKmQo/5xLKdb
	 ub6H4IwJN2H0A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ruoyu Wang <ruoyuw560@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] drm/radeon: avoid double free in r600 DPM cleanup
Date: Mon, 19 Oct 2026 09:53:10 -0400
Message-ID: <20261019135441.1420968-499-sashal@kernel.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit d3f30034f861a585f8e487ae1555d9f288a96f87 ]

r600_parse_extended_power_table() uses manual kfree() calls for some
early allocation failures, but the freed pointers are left in the
dynamic power-management state. If device teardown later calls
r600_free_extended_power_table(), those stale pointers can be freed
again.

Use the common extended power table cleanup helper for those early
failure paths as well, and clear each pointer after freeing it so
repeated cleanup stays safe.

Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable backport analysis: `drm/radeon: avoid double free in r600 DPM
cleanup`

Local tree: **6.18.53** (`v6.18.53-5049-g0f0bdc2b0dffb`, branch
`autosel`). Verdict is for this tree only.

Upstream commit: `d3f30034f861a585f8e487ae1555d9f288a96f87` (Alex
Deucher, 2026-06-17).

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
Record: **[drm/radeon] [avoid] [double free in r600 DPM cleanup]**

Subsystem prefix `drm/radeon`. Verb **avoid** is a bug-fix verb. Claimed
intent: prevent a double-free in R600 dynamic power-management cleanup.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Fixes:** none (expected for this review queue)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** none
- **Acked-by:** none
- **Link:** none in the commit; lore found later via `b4 dig`
- **Cc: stable:** none (expected)
- **Signed-off-by:** Ruoyu Wang (author); Alex Deucher (AMD/radeon
  maintainer)

No syzbot, no CVE, no multi-reporter pattern. Maintainer SOB is a
positive quality signal.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** `r600_parse_extended_power_table()` does manual `kfree()` on
  some early allocation-failure paths and leaves the pointers in
  `rdev->pm.dpm.dyn_state`.
- **Symptom:** later `r600_free_extended_power_table()` can free those
  stale pointers again → **double-free**.
- **Root cause:** incomplete error-path cleanup plus non-idempotent free
  helper.
- **Fix:** use `r600_free_extended_power_table()` on those early paths,
  and NULL each pointer after `kfree()` so repeated cleanup is safe.
- **Version info:** none in the message.

### Step 1.4: DETECT HIDDEN BUG FIXES
Record: **Not hidden.** This is an explicit double-free fix. The “use
the common helper” wording is cleanup-shaped, but it is fixing real
dangling pointers.

---

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

### Step 2.1: INVENTORY THE CHANGES
Record:
- **File:** `drivers/gpu/drm/radeon/r600_dpm.c` (**+15 / −6**)
- **Functions:** `r600_parse_extended_power_table()`,
  `r600_free_extended_power_table()`
- **Scope:** single-file surgical fix

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:

**Hunk 1 (three early error returns in parse):**
- Before: on `r600_parse_clk_voltage_dep_table()` failure for VDDCI-on-
  MCLK / VDDC-on-MCLK / MVDD-on-MCLK, manually `kfree()` previously
  allocated `*.entries` and return, **without clearing the pointers**.
- After: call `r600_free_extended_power_table(rdev)` then return.

**Hunk 2 (free helper):**
- Before: twelve `kfree()`s, pointers left non-NULL.
- After: same `kfree()`s, each pointer set to NULL.

The first parse failure (`vddc_dependency_on_sclk`) still does a bare
`return ret`. That is correct: `r600_parse_clk_voltage_dep_table()` only
fails after `kcalloc` returns NULL, so there is nothing allocated yet.

### Step 2.3: IDENTIFY THE BUG MECHANISM
Record: **[DOUBLE-FREE] [error-path resource cleanup]**

Mechanism:
1. Early parse error: `kfree(ptr)` but `ptr` remains in `dyn_state`.
2. Later error paths in the same function already called
   `r600_free_extended_power_table()` without NULLing.
3. Teardown (`*_dpm_fini` → `r600_free_extended_power_table`) `kfree()`s
   the same pointers again.

NULLing also makes the helper idempotent for callers that free on their
own error path and then free again in `fini` (e.g. `si_dpm_init` /
`ci_dpm_init` / `btc_dpm_init`).

### Step 2.4: ASSESS THE FIX QUALITY
Record:
- **Quality:** obviously correct. `kfree(NULL)` is a no-op; NULLing
  after free is the standard idempotent-cleanup pattern.
- **Minimal:** only the three incomplete early paths plus NULL stores in
  the existing helper. No API/struct changes.
- **Regression risk:** low. Success-path `fini` still frees once;
  NULLing after free cannot change live DPM behavior. A pre-existing
  issue remains: `radeon_pm_init_dpm()` ignores `radeon_dpm_init()`’s
  return, so a NULL deref is possible if code continues with `count > 0`
  and `entries == NULL`. That is **not introduced** by this patch (old
  code was UAF/double-free on the same path). Sashiko flagged it; Alex
  Deucher applied the patch anyway.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
Record:
- Buggy manual `kfree()`s introduced in **`61b7d6011054eb`**
  (“drm/radeon/dpm: add helpers for extended power tables (v2)”, Alex
  Deucher, 2012-11-14) → first in **v3.11-rc1**.
- MVDD path: **`dd621a22cf43bb`** (2013-05-06).
- Free helper body: **`41cd0b3b78d83a`** (“drm/radeon: clean up
  r600_free_extended_power_table()”, Dan Carpenter, 2013-09-04) →
  **v3.12-rc2**.

This has been in the tree for more than a decade, including 6.18.y.

### Step 3.2: FOLLOW THE FIXES: TAG
Record: **No Fixes: tag.** Not applicable. The introducing commit is in
this tree (v3.11).

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Related: **`20c3dffdccbd4`** “radeon: avoid double free in
  ci_dpm_init()” (v6.5-rc1). Same class of bug: parse error already
  calls `r600_free_extended_power_table()`, then `ci_dpm_fini()` calls
  it again.
- File is mature; recent commits are drive-by cleanups, not DPM-table
  refactors.
- **Standalone**, not patch X/Y.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Ruoyu Wang is not the radeon maintainer; nearby DRM work is
similar cleanup-safety (`drm/msm`, `drm/mediatek`). Weight comes from
**Alex Deucher’s SOB and “Applied”**.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: **No prerequisites.** The helper and the three `kfree` sites
exist in this tree. Applies standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- **Lore:**
  https://patch.msgid.link/20260608063638.24-1-ruoyuw560@gmail.com
- **Revisions:** v1 only (`b4 dig -a`)
- Direct lore.kernel.org fetch returned 403; thread recovered via `b4
  dig -m`.
- Sashiko bot: pre-existing ignored `radeon_dpm_init()` return and stale
  `count` fields. Not NAKs of this patch.
- **Alex Deucher (2026-06-15): “Applied. Thanks!”** No request for v2.
- No reviewer `Cc: stable`.

### Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): To/Cc included Alex Deucher, Christian König,
David Airlie, Simona Vetter, amd-gfx, dri-devel, linux-kernel. Applied
by the radeon maintainer.

### Step 4.3: SEARCH FOR THE BUG REPORT
Record: no Reported-by / syzbot / bugzilla. Static/code analysis style
fix, same family as `20c3dffdccbd4` (SVACE) and amdgpu `a6582701178a4`.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: standalone v1. Sibling in amdgpu: **`a6582701178a4`**
“drm/amd/pm: fix a double-free in amdgpu_parse_extended_power_table”
(already in this tree). Same parse-then-fini double-free shape.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: **UNVERIFIED.** `lore.kernel.org/stable/` returned 403. No
evidence in the dri-devel thread of a stable NAK.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `r600_parse_extended_power_table()`,
`r600_free_extended_power_table()`. Helper used internally:
`r600_parse_clk_voltage_dep_table()` (ENOMEM-only failure).

### Step 5.2: TRACE CALLERS
Record (parse): `btc_dpm_init`, `ni_dpm_init`, `si_dpm_init`,
`ci_dpm_init`, `trinity_dpm_init`, `kv_dpm_init`.

Record (free): those chips’ `*_dpm_fini`, plus error paths inside parse
and some init functions (`si_dpm_init`, `ni_dpm_init`, `btc_dpm_init`,
`ci_dpm_init`).

Context: driver probe (`radeon_pm_init` → `radeon_dpm_init`) and
teardown (`radeon_pm_fini` → `radeon_dpm_fini`). Not interrupt/hot-path.

### Step 5.3: TRACE CALLEES
Record: `kcalloc`/`kzalloc` for VBIOS power-play tables, `kfree` in the
helper. No locking, no new allocations in the patch.

### Step 5.4: FOLLOW THE CALL CHAIN
Record (verified in this tree):

```
radeon_pm_init_dpm()
  radeon_dpm_init(rdev);          /* return IGNORED, radeon_pm.c:1442 */
  radeon_dpm_enable(...)
cik/si/ni/..._init()
  radeon_pm_init(rdev);           /* return also ignored, e.g.
cik.c:8620 */

radeon_pm_fini_dpm()
  radeon_dpm_fini(rdev);          /* ALWAYS, radeon_pm.c:1678 */
    -> r600_free_extended_power_table()
```

On unload, `radeon_driver_unload_kms()` → `radeon_device_fini()` → asic
`fini` → `radeon_pm_fini()`.

Because DPM init failure is ignored, a failed parse still reaches `fini`
on unbind/unload. **Reachable from normal driver lifetime**, not a
theoretical path. Trigger is allocation failure while parsing ATOM
power-play tables (ENOMEM during probe). Unprivileged userspace cannot
force it except by load/unload under memory pressure.

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: same bug already fixed in amdgpu (`a6582701178a4`) and partially
in `ci_dpm_init` (`20c3dffdccbd4`). Remaining hole was exactly these
radeon helper paths.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: **Yes.** Parent of the candidate (`d3276745c87d1^`) still has
the manual `kfree()`s at the three early returns and the free helper
without NULL stores. Introduced in v3.11; present throughout 6.18.y.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **clean apply.** Surrounding `r600_dpm.c` DPM-table code matches
the patch context. No conflicting refactor in this series.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: `20c3dffdccbd4` is already in this tree and only hardens
`ci_dpm_init`; it does **not** NULL the r600 helper pointers or convert
the early parse `kfree()`s. This commit is still needed.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **[drm/radeon DPM] [IMPORTANT]** — pre-GCN AMD GPUs (R600–CIK:
HD 2000 through Hawaii/Kaveri). Not core mm/net, but a long-lived
production driver (`CONFIG_DRM_RADEON`).

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: mature/low churn. `r600_dpm.c` last real DPM logic is from
~2013; later commits are mechanical. Long-present bugs in this code are
the ones stable still cares about.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
Record: **driver-specific / config-specific** (`CONFIG_DRM_RADEON`, DPM
method, chips that call `r600_parse_extended_power_table`:
BTC/NI/SI/CI/Trinity/KV).

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record:
- Trigger: ENOMEM (or parse failure) while building extended power
  tables during DPM init, then device teardown.
- Not every boot; needs allocation failure in that path.
- Unprivileged users cannot craft a VBIOS, but module unload after a
  failed/partial DPM init is a normal admin path.
- **r600_parse_clk_voltage_dep_table() only returns -ENOMEM**, so the
  three converted sites are memory-pressure probe errors. The NULL
  stores also close double-frees on later parse/init error paths that
  already called the helper.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: **double-free / invalid `kfree` → kernel oops/BUG in SLUB,
possible further corruption.** Severity: **HIGH** (crash on GPU probe-
failure teardown). Not a guaranteed panic on every radeon boot.

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** medium-high for radeon DPM users — prevents a real
  double-free that `fini` will hit after a failed parse, including
  because init errors are ignored.
- **Risk:** very low — 15 insertions, NULL-after-free, no locking/API
  change.
- **Ratio:** favorable.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Real double-free, not style cleanup.
- Buggy code exists in this 6.18.y tree (since v3.11).
- Small, obviously correct, single file.
- No new APIs/features; no prerequisites.
- Maintainer applied it.
- Same pattern already treated as a real bug in-tree (`20c3dffdccbd4`,
  amdgpu `a6582701178a4`).
- Teardown always calls `radeon_dpm_fini()`; DPM init return is ignored,
  so the second free is actually reached.

**AGAINST:**
- No user report / syzbot / Fixes tag (absence is expected here).
- Trigger is ENOMEM during probe, not a hot path.
- Sashiko noted pre-existing ignored-init-return / stale-count issues
  this patch does not fully solve.

**UNRESOLVED:**
- Stable-list discussion (lore.kernel.org/stable 403).

None of the against items outweigh a contained double-free fix that
applies cleanly.

### Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — NULLing after `kfree` is
   standard; maintainer applied v1.
2. Fixes a real bug that affects users? **PASS** — double-free on DPM
   parse-failure teardown.
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   double-free → oops/memory corruption. Severity HIGH.
4. Small and contained? **PASS** — +15/−6, one file.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — buggy sites present; context
   matches.

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: none needed; this is a normal memory-safety bug fix.

### Step 9.4: MAKE YOUR DECISION

This belongs in 6.18.y. The early `kfree()`s leave dangling `dyn_state`
pointers; `radeon_pm_fini_dpm()` always calls
`r600_free_extended_power_table()`. NULLing makes that helper safe to
call twice, which this driver already does on several error paths. Risk
is negligible relative to the crash it prevents.

---

## What the commit solves for stable users

On Radeon chips that parse ATOM extended power tables, an allocation
failure during DPM init frees some tables but leaves the pointers set.
Driver unload then frees them again. That is a kernel double-free. The
patch uses the existing cleanup helper on those paths and clears every
pointer so a second cleanup is harmless.

## Stable rules / risk vs benefit

Meets all six stable criteria. Benefit is preventing an oops/corruption
on GPU init-failure teardown; risk is a 21-line, no-lock, no-API change.
No backport rework needed in this tree.

## Concerns

- Does not fix ignored `radeon_dpm_init()` return (pre-existing; out of
  scope).
- Count fields are not zeroed (pre-existing; Sashiko note). That is not
  a reason to withhold the double-free fix.
- Trigger needs ENOMEM during table parse, so it is not every-boot, but
  stable regularly takes this class of error-path double-free.

## Verification
- [Phase 1] Tags: author + Alex Deucher SOB only; no Fixes/Reported-
  by/Cc-stable.
- [Phase 2] Diff: +15/−6 in `r600_dpm.c`; three `kfree` → helper; twelve
  NULL stores in `r600_free_extended_power_table()`.
- [Phase 2] Parent still has
  `kfree(rdev->pm.dpm.dyn_state.vddc_dependency_on_sclk.entries)` at the
  three early returns.
- [Phase 2] `r600_parse_clk_voltage_dep_table()` only fails with
  `-ENOMEM` after assigning NULL.
- [Phase 3] Blame: `61b7d6011054eb` (v3.11-rc1) introduced the kfrees;
  `41cd0b3b78d83a` (v3.12) wrote the free helper without NULLs.
- [Phase 3] Related in-tree: `20c3dffdccbd4` (ci_dpm_init only); does
  not replace this patch.
- [Phase 4] `b4 dig -c d3f30034f861`:
  https://patch.msgid.link/20260608063638.24-1-ruoyuw560@gmail.com
- [Phase 4] `b4 dig -a`: v1 only.
- [Phase 4] `b4 dig -w`: Deucher/König/Airlie/Vetter + amd-gfx/dri-
  devel.
- [Phase 4] mbox: Alex Deucher “Applied. Thanks!”; Sashiko pre-existing
  notes, no NAK.
- [Phase 4] UNVERIFIED: lore.kernel.org and lore.kernel.org/stable HTTP
  403.
- [Phase 5] Callers: btc/ni/si/ci/trinity/kv `dpm_init`/`dpm_fini`.
- [Phase 5] `radeon_pm.c:1442` ignores `radeon_dpm_init()`;
  `radeon_pm.c:1678` always `radeon_dpm_fini()`.
- [Phase 5] `cik.c:8620` ignores `radeon_pm_init()`; `cik.c:8712`
  `radeon_pm_fini()` on asic fini.
- [Phase 6] `git describe HEAD` → `v6.18.53-5049-g0f0bdc2b0dffb`; `make
  kernelversion` → 6.18.53.
- [Phase 6] Buggy kfrees present in
  `d3276745c87d1^:drivers/gpu/drm/radeon/r600_dpm.c`.
- [Phase 7] `CONFIG_DRM_RADEON` still present.
- [Phase 8] Failure mode: double-free → SLUB BUG/oops; severity HIGH.
- UNVERIFIED: whether any user hit this in production (no Reported-by).
  Decision does not rely on that.

The fix is small, surgical, present in the local 6.18 code, and closes a
real double-free on DPM teardown.

**YES**

 drivers/gpu/drm/radeon/r600_dpm.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600_dpm.c b/drivers/gpu/drm/radeon/r600_dpm.c
index 81d58ef667dd4..2bc0bdfd11590 100644
--- a/drivers/gpu/drm/radeon/r600_dpm.c
+++ b/drivers/gpu/drm/radeon/r600_dpm.c
@@ -933,7 +933,7 @@ int r600_parse_extended_power_table(struct radeon_device *rdev)
 			ret = r600_parse_clk_voltage_dep_table(&rdev->pm.dpm.dyn_state.vddci_dependency_on_mclk,
 							       dep_table);
 			if (ret) {
-				kfree(rdev->pm.dpm.dyn_state.vddc_dependency_on_sclk.entries);
+				r600_free_extended_power_table(rdev);
 				return ret;
 			}
 		}
@@ -944,8 +944,7 @@ int r600_parse_extended_power_table(struct radeon_device *rdev)
 			ret = r600_parse_clk_voltage_dep_table(&rdev->pm.dpm.dyn_state.vddc_dependency_on_mclk,
 							       dep_table);
 			if (ret) {
-				kfree(rdev->pm.dpm.dyn_state.vddc_dependency_on_sclk.entries);
-				kfree(rdev->pm.dpm.dyn_state.vddci_dependency_on_mclk.entries);
+				r600_free_extended_power_table(rdev);
 				return ret;
 			}
 		}
@@ -956,9 +955,7 @@ int r600_parse_extended_power_table(struct radeon_device *rdev)
 			ret = r600_parse_clk_voltage_dep_table(&rdev->pm.dpm.dyn_state.mvdd_dependency_on_mclk,
 							       dep_table);
 			if (ret) {
-				kfree(rdev->pm.dpm.dyn_state.vddc_dependency_on_sclk.entries);
-				kfree(rdev->pm.dpm.dyn_state.vddci_dependency_on_mclk.entries);
-				kfree(rdev->pm.dpm.dyn_state.vddc_dependency_on_mclk.entries);
+				r600_free_extended_power_table(rdev);
 				return ret;
 			}
 		}
@@ -1298,17 +1295,29 @@ void r600_free_extended_power_table(struct radeon_device *rdev)
 	struct radeon_dpm_dynamic_state *dyn_state = &rdev->pm.dpm.dyn_state;
 
 	kfree(dyn_state->vddc_dependency_on_sclk.entries);
+	dyn_state->vddc_dependency_on_sclk.entries = NULL;
 	kfree(dyn_state->vddci_dependency_on_mclk.entries);
+	dyn_state->vddci_dependency_on_mclk.entries = NULL;
 	kfree(dyn_state->vddc_dependency_on_mclk.entries);
+	dyn_state->vddc_dependency_on_mclk.entries = NULL;
 	kfree(dyn_state->mvdd_dependency_on_mclk.entries);
+	dyn_state->mvdd_dependency_on_mclk.entries = NULL;
 	kfree(dyn_state->cac_leakage_table.entries);
+	dyn_state->cac_leakage_table.entries = NULL;
 	kfree(dyn_state->phase_shedding_limits_table.entries);
+	dyn_state->phase_shedding_limits_table.entries = NULL;
 	kfree(dyn_state->ppm_table);
+	dyn_state->ppm_table = NULL;
 	kfree(dyn_state->cac_tdp_table);
+	dyn_state->cac_tdp_table = NULL;
 	kfree(dyn_state->vce_clock_voltage_dependency_table.entries);
+	dyn_state->vce_clock_voltage_dependency_table.entries = NULL;
 	kfree(dyn_state->uvd_clock_voltage_dependency_table.entries);
+	dyn_state->uvd_clock_voltage_dependency_table.entries = NULL;
 	kfree(dyn_state->samu_clock_voltage_dependency_table.entries);
+	dyn_state->samu_clock_voltage_dependency_table.entries = NULL;
 	kfree(dyn_state->acp_clock_voltage_dependency_table.entries);
+	dyn_state->acp_clock_voltage_dependency_table.entries = NULL;
 }
 
 enum radeon_pcie_gen r600_get_pcie_gen_support(struct radeon_device *rdev,
-- 
2.53.0

