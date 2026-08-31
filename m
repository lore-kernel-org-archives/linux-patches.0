Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981A247ECFE;
	Mon, 31 Aug 2026 13:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183460; cv=none; b=L+fY9Oieq+pnjIBg01lED7uTQPeWGFGK+3M5UGKzNZuJOPgiT0gTP0okD+QOaZ0gbtlfuMtZAxyJ249ssfIixE8vY/cUQMa7FFLQLxuzOwg8K1xP7S8vOiRAcSalZ7P32TI9CucsoK+0aKhRpV9QvSfEhtVTovfKBRnSYbx500M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183460; c=relaxed/simple;
	bh=B+L8thju9wU+r8u6ipoag1HmMC/oYkI2acABse7f66M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KblTAv9QTp0Jgf9qxETk/L3ZbFXNCo56tw73SMH/sPVWs4r93aUHxvWbg/IsB7idCIpGsfUgm2gM/pC/cRr1oq1cXq9xZPy9/HOW/vBs4xEfVKsz9kmt154nVVBhtEKACfvLybM/Lpu4+fRAouxke/JW6abVPwuDRbpSXVMyN4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UXnV7LZ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UXnV7LZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB62B1F00A3D;
	Mon, 31 Aug 2026 13:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183458;
	bh=ZjJY1vX9s+jaimzcKtacl9O7Y1PhJM7bV1ZBdpqFekQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UXnV7LZ7w1rb+IA2AfhAuIj0vhGqSPTHjLTP3anB697m7fU50iT2n0w6Z3u1oOL0b
	 2ON/595V5Lmn+LDpVbzrR0zqcYpXpO8UGN9xMC4zpFRqNsexANV3haYSZsfoTDOQgW
	 KUq0qtwaeWT1RV8SbI5FX58Oo4JYL/Ov1vkFLa35t8o5NqXmTUp49RyICojLa31MsP
	 qJj0uBCGbFxueJCU4e0bQwOqoBZV8T+WeDWAegfKDVTIIsSdbXrMZ1beWoMWSPJ/96
	 z7MCvmR+R6WJmikBuJYkRa6KqgCrgG7z6cCVqt8hHDH+b1iy5qaDeHEQKwvbvpNCsZ
	 gHbvRRqxwRAKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Gustavo=20Kenji=20Mendon=C3=A7a=20Kaneko?= <kaneko.dev@pm.me>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] drm/arm/malidp: use clk_bulk API in runtime PM resume and suspend
Date: Mon, 31 Aug 2026 09:22:16 -0400
Message-ID: <20260831133314.4125787-108-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Gustavo Kenji Mendonça Kaneko <kaneko.dev@pm.me>

[ Upstream commit 46f715a16989f4e7bbbc2eb41447051874b027f3 ]

malidp_runtime_pm_resume() calls clk_prepare_enable() three times
without checking the return value. If any clock fails to enable, the
driver silently proceeds with unclocked hardware, leading to undefined
behavior.

Convert both the resume and suspend paths to use the clk_bulk API:
clk_bulk_prepare_enable() in resume checks the return value and rolls
back any successfully enabled clocks on failure;
clk_bulk_disable_unprepare() in suspend keeps the two paths symmetric.

This issue was found by code review without access to Mali DP hardware.

Signed-off-by: Gustavo Kenji Mendonça Kaneko <kaneko.dev@pm.me>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260609130812.1065699-1-kaneko.dev@pm.me
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: `[drm/arm/malidp]` `[use]` — Convert runtime PM resume/suspend
clock handling to `clk_bulk` API with proper error checking.

**Step 1.2 — Tags**
Record:
- **Fixes:** none
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** Liviu Dudau `<liviu.dudau@arm.com>` (Mali DP driver
  maintainer/original author)
- **Acked-by:** none
- **Link:**
  https://patch.msgid.link/20260609130812.1065699-1-kaneko.dev@pm.me
- **Cc: stable:** none (expected for manual review)
- **Signed-off-by:** Gustavo Kenji Mendonça Kaneko, Liviu Dudau (ignore
  pipeline-added SOBs)

Notable: maintainer Reviewed-by; no user/fuzzer reports.

**Step 1.3 — Body analysis**
Record:
- **Bug:** `malidp_runtime_pm_resume()` calls `clk_prepare_enable()`
  three times without checking return values.
- **Symptom/failure mode:** On clock-enable failure, driver continues
  with unclocked or partially clocked hardware → undefined behavior;
  then sets `pm_suspended = false` and runs IRQ hardware init.
- **Version info:** none stated.
- **Root cause:** Missing error handling on runtime PM resume clock
  enables; partial enable not rolled back.

**Step 1.4 — Hidden bug fix?**
Record: **Yes.** Subject says "use clk_bulk API," but the substantive
fix is ignored `clk_prepare_enable()` errors on the PM resume path — a
real correctness/robustness bug, not mere style.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record:
- **File:** `drivers/gpu/drm/arm/malidp_drv.c` (+16 / −6)
- **Functions:** `malidp_runtime_pm_suspend()`,
  `malidp_runtime_pm_resume()`
- **Scope:** Single-file surgical fix

**Step 2.2 — Code flow per hunk**

| Hunk | Before | After |
|------|--------|-------|
| Suspend | Three individual `clk_disable_unprepare()` calls
(mclk→aclk→pclk) | `clk_bulk_disable_unprepare()` on `[pclk, aclk,
mclk]` array |
| Resume | Three `clk_prepare_enable()` calls, return values ignored |
`clk_bulk_prepare_enable()` with error check; return error on failure |

Record: Suspend path is symmetric refactor only (bulk disable runs in
reverse order, matching old behavior). Resume path adds error
propagation and rollback on partial failure.

**Step 2.3 — Bug mechanism**
Record: **Error-path / logic correctness fix.** Category: ignored return
values + partial resource state on failure. If `aclk` fails after `pclk`
succeeds, old code leaves `pclk` enabled, ignores failure, and proceeds
to `malidp_de_irq_hw_init()` / `malidp_se_irq_hw_init()` on mis-clocked
hardware.

**Step 2.4 — Fix quality**
Record: Fix is minimal and idiomatic. `clk_bulk_disable()` /
`clk_bulk_unprepare()` iterate in reverse order, so suspend behavior
matches the old manual sequence. Resume rollback via
`clk_bulk_prepare_enable()` is standard. Low regression risk; maintainer
requested v2 suspend symmetry change.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record: Buggy `clk_prepare_enable()` calls introduced in
`85f6421889eca6` ("drm: mali-dp: Enable power management for the
device.", 2017-03-22, Liviu Dudau). Present in this tree since driver PM
was added.

**Step 3.2 — Fixes: tag**
Record: N/A — no Fixes: tag.

**Step 3.3 — Related file history**
Record: Recent `malidp_drv.c` changes are unrelated DRM API cleanups.
Standalone patch; v2 incorporated maintainer feedback (suspend
symmetry). No prerequisite commits required.

**Step 3.4 — Author context**
Record: Gustavo Kenji Mendonça Kaneko is a contributor; Liviu Dudau is
the Mali DP maintainer and original driver author. Maintainer reviewed
and merged to `drm-misc-fixes`.

**Step 3.5 — Dependencies**
Record: No dependencies. `clk_bulk_prepare_enable()` /
`clk_bulk_disable_unprepare()` exist in `include/linux/clk.h` in this
tree. Patch is self-contained.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
Record:
- **URL:**
  https://patch.msgid.link/20260609130812.1065699-1-kaneko.dev@pm.me
- **Series:** v1 (resume only) → v2 (resume + suspend symmetry, per
  Liviu Dudau)
- **Reviewer feedback:** Liviu Dudau requested suspend conversion and
  commit-message correction in v2
- **Stable nomination:** none found in thread
- **NAKs:** none

**Step 4.2 — Reviewers (b4 dig -w)**
Record: CC'd dri-devel, Liviu Dudau, DRM maintainers (Lankhorst, Ripard,
Zimmermann, Airlie, Vetter), linux-kernel.

**Step 4.3 — Bug report**
Record: No external bug report. Author states issue found by code review
without Mali DP hardware access.

**Step 4.4 — Related patches**
Record: v1 was `[PATCH 1/2] drm/arm/malidp: fix ignored
clk_prepare_enable() in runtime PM resume`; v2 is the committed version.

**Step 4.5 — Stable list**
Record: No stable-specific discussion found.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: `malidp_runtime_pm_resume()`, `malidp_runtime_pm_suspend()`

**Step 5.2 — Callers**

| Caller | Context |
|--------|---------|
| `SET_RUNTIME_PM_OPS` | PM core runtime suspend/resume |
| `pm_runtime_get_sync()` in `malidp_bind()`, atomic commit, unbind |
Hot display paths |
| `malidp_pm_resume_early()` | System sleep early resume — **still
ignores return value** (pre-existing) |
| Direct call when PM runtime disabled | Probe fallback |

Record: Reachable on every runtime PM resume and system sleep resume on
Mali DP hardware.

**Step 5.3 — Callees**
Record: `clk_bulk_prepare_enable()`, `clk_bulk_disable_unprepare()`,
`malidp_de_irq_hw_init()`, `malidp_se_irq_hw_init()`

**Step 5.4 — Reachability**
Record: Triggered during device probe, display atomic commits
(`pm_runtime_get_sync` in `malidp_atomic_commit_tail`), system
suspend/resume, and module teardown. Users with
`CONFIG_DRM_MALI_DISPLAY` on ARM/ARM64 platforms (e.g. NXP LS1028A) are
affected.

**Step 5.5 — Similar patterns**
Record: Komeda driver in the same tree also has unchecked
`clk_prepare_enable()` calls — separate issue; this fix is Mali-DP-
specific.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code in tree?**
Record: **Yes.** Local tree is **v6.18.44** (`make kernelversion` =
6.18.44). Buggy code at lines 679–694 of `malidp_drv.c`. Present since
2017. Mainline fix commit `46f715a16989f4e7bbbc2eb41447051874b027f3` is
**not** an ancestor of HEAD.

**Step 6.2 — Backport complications**
Record: Expected clean apply — structure matches mainline diff context.
No conflicting recent PM changes in this file.

**Step 6.3 — Related fixes already present?**
Record: None. `git log -S 'clk_bulk_prepare_enable' --
drivers/gpu/drm/arm/malidp_drv.c` returns empty.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**
Record: `drivers/gpu/drm/arm/` — DRM display driver for ARM Mali
DP500/550/650. **Criticality: PERIPHERAL** (platform-specific
embedded/display hardware via `CONFIG_DRM_MALI_DISPLAY`).

**Step 7.2 — Activity**
Record: Driver is mature with infrequent changes; PM code largely
unchanged since 2017.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
Record: Users with Mali Display Processor hardware on ARM/ARM64
(DP500/550/650), typically embedded (NXP LS1028A, ARM Juno, etc.).
Config-specific: `CONFIG_DRM_MALI_DISPLAY=m/y`.

**Step 8.2 — Trigger conditions**
Record: Any `clk_prepare_enable()` failure during runtime PM resume —
most plausible after system suspend/resume or power-domain transitions
when clock framework state changes. Rare in practice (clocks succeed at
probe), but realistic on resume paths. Not a direct userspace attack
vector.

**Step 8.3 — Failure mode severity**
Record: Undefined hardware behavior — possible bus hang, kernel oops, or
corrupted display state when IRQ/block init runs without clocks.
**Severity: HIGH** (potential crash/hang), though **unreported in the
field**.

**Step 8.4 — Risk-benefit**
Record:
- **Benefit:** Prevents proceeding with broken clock state; propagates
  errors to `pm_runtime_get_sync()` callers; rolls back partial enables.
- **Risk:** Very low — 22-line change, maintainer-reviewed, suspend
  order preserved by bulk API semantics.
- **Ratio:** Favorable for affected hardware users.

---

## Phase 9: Final Synthesis

**Evidence FOR backport:**
- Real, verifiable bug (ignored error returns) present since 2017 in
  this tree
- Serious failure mode if triggered (unclocked HW + IRQ init)
- Small, self-contained, maintainer-reviewed fix
- Uses existing `clk_bulk` API already in 6.18
- Improves error propagation to `pm_runtime_get_sync()` paths used
  during display commits

**Evidence AGAINST backport:**
- No user reports, syzbot, or hardware testing
- Niche driver affecting limited embedded platforms
- `malidp_pm_resume_early()` still ignores resume errors (incomplete for
  system-sleep path; pre-existing call-site issue)
- Clock failures after successful probe are uncommon

**Unresolved questions:**
- No confirmed production crash from this bug
- No runtime test on actual Mali DP hardware

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** — standard API, maintainer
   Reviewed-by; no hardware Tested-by
2. Fixes a real bug? **PASS** — objectively ignores
   `clk_prepare_enable()` errors
3. Important issue? **PASS** — undefined behavior / potential crash on
   PM resume (HIGH if triggered, rare trigger)
4. Small and contained? **PASS** — 1 file, ~22 lines
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — buggy code present, APIs
   available

**Exception category:** None (not device ID, quirk, DT, build, or docs
fix — straight driver bug fix).

---

## Problem Summary for Stable Users

On Linux **6.18.44**, the Mali DP driver's runtime PM resume enables
three clocks (`pclk`, `aclk`, `mclk`) without checking for failure. If
any enable fails (e.g. during resume from suspend), the driver
continues, marks the device active, and initializes display IRQ hardware
on potentially unclocked silicon. The fix uses
`clk_bulk_prepare_enable()` to check errors and roll back partial
enables, and makes suspend symmetric via `clk_bulk_disable_unprepare()`.

For stable trees carrying Mali DP since 2017, this closes a long-
standing PM robustness hole. Impact is limited to
`CONFIG_DRM_MALI_DISPLAY` users, but the consequence of triggering is
severe enough to warrant backport: small fix, low risk, prevents
potential hangs/crashes on resume.

**Concern:** Fix does not address `malidp_pm_resume_early()` ignoring
the return value — a follow-up could improve system-sleep resume, but
that does not diminish the value of fixing the runtime PM callback
itself.

---

## Verification

- [Phase 1] Parsed commit message and tags from user-provided content
  and mainline commit `46f715a`
- [Phase 1] Confirmed no Reported-by/syzbot; found Reviewed-by: Liviu
  Dudau
- [Phase 2] Verified diff: +16/−6 in `malidp_drv.c`, two functions
  modified
- [Phase 2] Read `clk_bulk_disable()` in `drivers/clk/clk-bulk.c`:
  disables in reverse order (lines 214–215), matching old suspend
  sequence
- [Phase 2] Read `clk_bulk_prepare_enable()` in `include/linux/clk.h`
  (lines 1164–1175): prepare+enable with rollback
- [Phase 3] `git blame -L 686,700`: buggy code from `85f6421889eca6`
  (2017-03-22)
- [Phase 3] `git log -S 'clk_prepare_enable(hwdev->pclk)'`: introduced
  in `ad49f8602fe88` (initial driver)
- [Phase 3] `git merge-base --is-ancestor 46f715a HEAD`: commit NOT in
  current tree
- [Phase 4] `b4 dig -c 46f715a`: found thread at
  https://patch.msgid.link/20260609130812.1065699-1-kaneko.dev@pm.me
- [Phase 4] `b4 dig -a`: v2 is latest revision
- [Phase 4] `b4 dig -w`: dri-devel + DRM maintainers CC'd
- [Phase 4] Saved mbox; Liviu Dudau Reviewed-by + merge confirmation; no
  stable nomination
- [Phase 4] Fetched lkml.iu.edu mirror of patch thread
- [Phase 5] Grep callers: `pm_runtime_get_sync` at lines 242, 761, 862,
  892; `SET_RUNTIME_PM_OPS` at line 985
- [Phase 5] Read `malidp_pm_resume_early()` (lines 975–979): ignores
  return value (not fixed by this patch)
- [Phase 6] `git describe HEAD` = v6.18.44-1-g2736c32da98b9; `make
  kernelversion` = 6.18.44
- [Phase 6] Read current `malidp_drv.c` lines 667–700: buggy code
  confirmed present
- [Phase 6] `git log -S 'clk_bulk_prepare_enable' -- malidp_drv.c`:
  empty (fix not present)
- [Phase 7] Read `drivers/gpu/drm/arm/Kconfig`:
  `CONFIG_DRM_MALI_DISPLAY` for DP500/550/650
- [Phase 8] Grep DTS: Mali DP references in `fsl-ls1028a.dtsi` (limited
  platform footprint)

**YES****Verdict: YES** — backport to this tree (Linux **6.18.44**).

The Mali DP driver’s runtime PM resume has ignored
`clk_prepare_enable()` failures since 2017. On failure it can still
bring up IRQs on unclocked hardware. The fix is small (one file, ~22
lines), uses the existing `clk_bulk` API, and was **Reviewed-by** Liviu
Dudau (driver maintainer). The buggy code is present here; mainline
commit `46f715a` is not in this tree yet.

**Caveat:** No field reports or hardware testing — found by code review
only. `malidp_pm_resume_early()` still ignores the resume return value;
that’s a separate follow-up, not a reason to skip this fix.

 drivers/gpu/drm/arm/malidp_drv.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/arm/malidp_drv.c b/drivers/gpu/drm/arm/malidp_drv.c
index bc5f5e9798c32..2bf4a647e4b28 100644
--- a/drivers/gpu/drm/arm/malidp_drv.c
+++ b/drivers/gpu/drm/arm/malidp_drv.c
@@ -669,6 +669,11 @@ static int malidp_runtime_pm_suspend(struct device *dev)
 	struct drm_device *drm = dev_get_drvdata(dev);
 	struct malidp_drm *malidp = drm_to_malidp(drm);
 	struct malidp_hw_device *hwdev = malidp->dev;
+	struct clk_bulk_data clks[] = {
+		{ .clk = hwdev->pclk },
+		{ .clk = hwdev->aclk },
+		{ .clk = hwdev->mclk },
+	};
 
 	/* we can only suspend if the hardware is in config mode */
 	WARN_ON(!hwdev->hw->in_config_mode(hwdev));
@@ -676,9 +681,7 @@ static int malidp_runtime_pm_suspend(struct device *dev)
 	malidp_se_irq_fini(hwdev);
 	malidp_de_irq_fini(hwdev);
 	hwdev->pm_suspended = true;
-	clk_disable_unprepare(hwdev->mclk);
-	clk_disable_unprepare(hwdev->aclk);
-	clk_disable_unprepare(hwdev->pclk);
+	clk_bulk_disable_unprepare(ARRAY_SIZE(clks), clks);
 
 	return 0;
 }
@@ -688,10 +691,17 @@ static int malidp_runtime_pm_resume(struct device *dev)
 	struct drm_device *drm = dev_get_drvdata(dev);
 	struct malidp_drm *malidp = drm_to_malidp(drm);
 	struct malidp_hw_device *hwdev = malidp->dev;
+	struct clk_bulk_data clks[] = {
+		{ .clk = hwdev->pclk },
+		{ .clk = hwdev->aclk },
+		{ .clk = hwdev->mclk },
+	};
+	int err;
+
+	err = clk_bulk_prepare_enable(ARRAY_SIZE(clks), clks);
+	if (err)
+		return err;
 
-	clk_prepare_enable(hwdev->pclk);
-	clk_prepare_enable(hwdev->aclk);
-	clk_prepare_enable(hwdev->mclk);
 	hwdev->pm_suspended = false;
 	malidp_de_irq_hw_init(hwdev);
 	malidp_se_irq_hw_init(hwdev);
-- 
2.53.0

