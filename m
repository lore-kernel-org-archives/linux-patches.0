Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E44449B1EF;
	Mon, 31 Aug 2026 13:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183577; cv=none; b=d9xq5BkcXr8k8CTMSAhOBSuPh0Y7fB4N2P3x/nANFQWpbi/WXJBXCoreiFfnIRbBNSh3IPQNpK20nbcFF0QY4MkGJodFVRcfIXdDQpGAnFVFRY8vkyGKL8YGozI9Nb5eKA2qkH3QD3U2s8VsESrRGO5pkyYroc1VDiUobOdWMPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183577; c=relaxed/simple;
	bh=Xti2/zk76ezVooDxkmmRsMY28LzHnZ3+pZzJVk5uEMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PR1YpAP9lyCPG0DOoEc9qMjjlH773vOFMOAr+hohR2LGXy2ErdK9ntkqiGmsIkejjWpqaD8FglU8L3/dtcw3O4xwE5XuAsVCc6Df/y2HVOIgd/6stkjRv2BApsly3vuPGvRUlgawS/UaP43nn+JPaBMAc+X35NkpH4cS2QgHd7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TU0deoEd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TU0deoEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7C31F00A3E;
	Mon, 31 Aug 2026 13:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183574;
	bh=iZdEIvs0YPkL9TaMhVLdj8d4VxnHIDPlVGUIzvCCD40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TU0deoEd2dvSc2hhifpfCKSGESTA3qMsgZ3IC35yYtjxzAXDlcr73vzS0F5WBAmLo
	 OyJMsEJVvm+JLdrsFKBh66goz/MiP32Oqt08WiA9BUzmHwDhW+hn4tbqFXgeNx0FTP
	 /t+wpAjXeEio34Xi0wHmcCXEJRVquWVRHbZGmUlH30ExbelZtjq7jVZDP0373huXVZ
	 rAvgWMxVmIbSaUrfSkXRw28VH3we+YXHjpsIf8n4pcURKJstp64MyTc/8pFSi+pAra
	 xajD/cuoNSTqMTTZQ0mxAmDKtf/dUlep/D84QvkbNe446TC1UnperYEwdW0pCJhUtp
	 nParl5zl0KKyw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Biju Das <biju.das.jz@bp.renesas.com>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-renesas-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm: renesas: rzg2l_mipi_dsi: Fix deassert/assert of CMN_RSTB signal
Date: Mon, 31 Aug 2026 09:23:25 -0400
Message-ID: <20260831133314.4125787-177-sashal@kernel.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 8065890f5cda3f8a503f3b9d326aab0e9cca39e7 ]

The RZ/G2L hardware manual (Rev. 1.50, May 2025), Section 34.4.2.1,
requires deasserting the CMN_RSTB signal after setting the Link registers.
Move the reset_control_deassert() call from rzg2l_mipi_dsi_dphy_init() to
rzg2l_mipi_dsi_startup(), placing it after the Link register writes. This
reset signal is optional for RZ/V2H SoCs, so add a NULL check. Drop the
unused ret variable from rzg2l_mipi_dsi_dphy_init().

The CMN_RSTB signal is not required for reading PHY registers in the
probe. Move reset_control_assert() from rzg2l_mipi_dsi_dphy_exit() to
rzg2l_mipi_dsi_stop(), placing it before the dphy_exit() call. Since this
reset signal is optional for RZ/V2H, the call is a no-op on that SoC.

Tested-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Reviewed-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Link: https://patch.msgid.link/20260330104450.128512-4-biju.das.jz@bp.renesas.com
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `drm: renesas: rzg2l_mipi_dsi: Fix
deassert/assert of CMN_RSTB signal`

**Local tree:** Linux **6.18.43** (`v6.18.43`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
- **Record:** `[drm: renesas: rzg2l_mipi_dsi]` **`Fix`** — correct
  CMN_RSTB reset deassert/assert timing per RZ/G2L hardware manual.

### Step 1.2: Tags
- **Fixes:** — none
- **Reported-by:** — none
- **Tested-by:** Tommaso Merciai `<tommaso.merciai.xr@bp.renesas.com>`
- **Reviewed-by:** Tommaso Merciai `<tommaso.merciai.xr@bp.renesas.com>`
- **Link:** https://patch.msgid.link/20260330104450.128512-4-
  biju.das.jz@bp.renesas.com
- **Cc: stable:** — not in the committed message (patches 1–2 of the
  same series did include it)
- **Signed-off-by:** Biju Das (ignore pipeline SOB markers)

**Record:** Hardware-tested and reviewed by a Renesas engineer; part of
v3 series “Improvements on RZ/G2L MIPI DSI driver”. No syzbot/crash
tags.

### Step 1.3: Body analysis
- **Bug:** CMN_RSTB is deasserted in `rzg2l_mipi_dsi_dphy_init()` before
  Link-layer registers are programmed in `rzg2l_mipi_dsi_startup()`.
  RZ/G2L HW manual §34.4.2.1 requires deassert **after** Link register
  writes.
- **Symptom:** Incorrect DSI hardware bring-up sequence; display may
  fail or behave unreliably on RZ/G2L SoCs with the `rst` reset line.
- **Root cause:** Reset sequencing does not match hardware manual
  ordering.
- **Shutdown side:** `reset_control_assert()` moved from `dphy_exit()`
  to `stop()` (before PHY teardown), since CMN_RSTB is not needed for
  PHY register access during exit.

**Record:** Hardware-init correctness bug on Renesas RZ/G2L MIPI DSI;
optional on RZ/V2H (`rstc` may be NULL).

### Step 1.4: Hidden bug fix?
- **Record:** No — this is an explicit hardware-sequence fix, not
  disguised cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files:** `drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c` — 9
  insertions, 9 deletions
- **Functions:** `rzg2l_mipi_dsi_dphy_init()`,
  `rzg2l_mipi_dsi_dphy_exit()`, `rzg2l_mipi_dsi_startup()`,
  `rzg2l_mipi_dsi_stop()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow changes
| Hunk | Before | After |
|------|--------|-------|
| `dphy_init()` | Deassert CMN_RSTB + 1 ms sleep after PHY timing writes
| PHY timing only; no reset |
| `dphy_exit()` | Assert CMN_RSTB after PHY power-down | PHY power-down
only |
| `startup()` | Link register writes, then return | Link writes, then
deassert CMN_RSTB + 1 ms sleep (with NULL check) |
| `stop()` | Call `dphy_exit()` only | Assert CMN_RSTB, then
`dphy_exit()` |

**Record:** Normal display enable/disable path (`atomic_pre_enable` →
`startup`; `atomic_post_disable` → `stop`).

### Step 2.3: Bug mechanism
- **Category:** Hardware initialization sequence / workaround
- **Mechanism:** CMN_RSTB released before Link-layer configuration
  completes, violating required reset sequence.

### Step 2.4: Fix quality
- **Record:** Minimal, matches manual, uses existing `err_phy` path on
  deassert failure, NULL-safe for RZ/V2H. Low regression risk.

---

## PHASE 3: GIT HISTORY

### Step 3.1: Blame
- Buggy reset code introduced in `a4871e6201c46` (May 2025, Thomas
  Zimmermann) when driver was added.
- Delay tuning in `aa8ad3e0d1fe9` (already in 6.18.43).

**Record:** Bug present since driver introduction; long-standing on
RZ/G2L platforms.

### Step 3.2: Fixes: tag
- **Record:** N/A — no Fixes: tag in this commit.

### Step 3.3: Related commits
- `300a2d970a535` — Move `set_display_timing()` — **present in tree**
- `aa8ad3e0d1fe9` — Increase reset deassertion delay — **present in
  tree**
- `8065890f5cda3` — This CMN_RSTB fix — **NOT present in tree**
- `79f42487ed60d` — Kernel panic on reboot fix — **present in tree**

**Record:** Patch 3/3 of a v3 series; prerequisites 1/3 and 2/3 already
backported to 6.18.43.

### Step 3.4: Author context
- Biju Das is active Renesas maintainer for rz-du/MIPI DSI.
- **Record:** Subsystem maintainer fix with hardware validation.

### Step 3.5: Dependencies
- **Record:** Standalone relative to master-only RZ/V2H CPG work.
  Depends on patches 1–2 of the same series, which are already in this
  tree. Cherry-pick applies cleanly (verified).

---

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1: Discussion
- **b4 dig -c 8065890f5cda3:** https://patch.msgid.link/20260330104450.1
  28512-4-biju.das.jz@bp.renesas.com
- **Series:** v1 → v2 → v3; committed version is v3 3/3 (latest).
- **Review:** Tommaso Merciai — “Looks good to me”; Reviewed-by +
  Tested-by on RZ/G3E.
- **NAKs:** None found.
- **Stable:** Patches 1/3 and 2/3 submitted with `Cc:
  stable@vger.kernel.org`; patch 3/3 did not include it in the email,
  but cover letter describes HW-manual compliance series.

### Step 4.2: Reviewers
- CC'd: dri-devel, linux-renesas-soc, DRM maintainers (Lankhorst,
  Ripard, Zimmermann, Airlie, Vetter), Laurent Pinchart.
- **Record:** Appropriate subsystem review chain.

### Step 4.3: Bug report
- **Record:** No external bugzilla/syzbot report. Validation is hardware
  testing on RZ/G3E per lore thread.

### Step 4.4: Series context
- Cover letter (v3 0/3): manual requires PHY timing + Link register
  writes **before** CMN_RSTB deassert; v2→v3 merged patches 2+3 “to
  avoid breakage.”
- **Record:** Incomplete without this patch if delay fix (patch 2) is
  already applied.

### Step 4.5: Stable list
- Patches 1–2 explicitly CC'd stable and were backported to 6.18.y.
- **Record:** Strong implicit stable intent for the full series.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
- `rzg2l_mipi_dsi_dphy_init`, `rzg2l_mipi_dsi_startup`,
  `rzg2l_mipi_dsi_stop`, `rzg2l_mipi_dsi_dphy_exit`

### Step 5.2: Callers
- `rzg2l_mipi_dsi_startup()` ← `rzg2l_mipi_dsi_atomic_pre_enable()`
  (display enable)
- `rzg2l_mipi_dsi_stop()` ← `rzg2l_mipi_dsi_atomic_enable()` error path
  and `rzg2l_mipi_dsi_atomic_post_disable()` (display disable)

**Record:** Standard DRM atomic display enable/disable path on every
MIPI DSI panel attach.

### Step 5.3: Callees
- `reset_control_deassert/assert`, `rzg2l_mipi_dsi_link_write`,
  `rzg2l_mipi_dsi_phy_write`, `fsleep(1000)`

### Step 5.4: Reachability
- Triggered whenever a connected MIPI DSI panel is enabled on
  `renesas,rzg2l-mipi-dsi` hardware.
- **Record:** Reachable from normal display operations; not obscure
  debug path.

### Step 5.5: Similar patterns
- Same manual section addressed by already-backported delay fix
  (`aa8ad3e0d1fe9`).
- **Record:** This completes the reset-sequence work started in that
  commit.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE

### Step 6.1: Buggy code present?
- **Yes.** Lines 271–275 (`reset_control_deassert` in `dphy_init`) and
  line 289 (`reset_control_assert` in `dphy_exit`) confirmed in 6.18.43.

### Step 6.2: Backport difficulty
- **Clean apply.** `git cherry-pick --no-commit 8065890f5cda3` succeeded
  with auto-merge only.

### Step 6.3: Related fixes already present?
- Patches 1/3 and 2/3 of series present; this fix is the missing third
  piece.
- **Record:** Tree is in intermediate state — delay fixed but ordering
  still wrong.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
- **drivers/gpu/drm/renesas/rz-du** — Renesas embedded display (MIPI
  DSI)
- **Criticality:** PERIPHERAL (platform-specific), but display is
  primary output on affected boards.

### Step 7.2: Activity
- Active development: panic fix, runtime PM, reset timing, display
  timing ordering all landed recently in 6.18.y.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
- Users of Renesas RZ/G2L SoCs with MIPI DSI displays
  (`renesas,rzg2l-mipi-dsi`).
- RZ/V2H unaffected (optional `rst` line; `reset_control_*` is NULL-
  safe).

### Step 8.2: Trigger conditions
- Every display enable/disable on RZ/G2L with CMN_RSTB wired.
- **Likelihood:** Common on affected hardware.

### Step 8.3: Failure mode
- Incorrect DSI bring-up per hardware manual → display may not work or
  may be unreliable.
- **Severity:** HIGH for affected users (no display); not a kernel
  crash/oops.

### Step 8.4: Risk-benefit
- **Benefit:** Correct hardware init; completes already-partially-
  backported series; tested on RZ/G3E.
- **Risk:** Very low — 18-line reorder, no API changes, NULL-safe.
- **Ratio:** Strong benefit, minimal risk for RZ/G2L users.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real hardware-init bug per official RZ/G2L manual
- Small, surgical, tested on hardware
- Prerequisites already in 6.18.43
- Applies cleanly
- Completes v3 series whose first two patches were already backported
- Reviewed by Renesas engineer with Tested-by on RZ/G3E
- Same driver already receives stable fixes (panic on reboot, delay,
  timing order)

**AGAINST backport:**
- Platform-specific peripheral driver
- No crash/security/data-corruption report
- Patch 3/3 lacks explicit `Cc: stable` in commit message

**Unresolved:** Exact failure modes on all RZ/G2L boards without the fix
(manual violation vs. observed “display broken”).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — manual compliance + Tested-
   by on RZ/G3E
2. Fixes real bug? **PASS** — incorrect reset sequencing
3. Important issue? **PASS** — display failure on affected embedded
   platforms
4. Small and contained? **PASS** — 1 file, ~18 lines
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — cherry-picks cleanly;
   prerequisites present

### Step 9.3: Exception category
- **Hardware workaround / init quirk** — correcting reset sequence per
  SoC manual.

### Step 9.4: Decision rationale
This tree (6.18.43) already carries patches 1/3 and 2/3 of the same
hardware-manual compliance series but not the final ordering fix.
Without it, CMN_RSTB is still deasserted before Link register
programming, which the RZ/G2L manual explicitly forbids. The fix is
small, tested, low-risk, and completes work stable maintainers already
started for this driver.

---

## Verification

- [Phase 1] `git describe HEAD` → v6.18.43; parsed commit message and
  tags
- [Phase 2] Read current `rzg2l_mipi_dsi.c`; confirmed reset calls at
  lines 271–275 and 289
- [Phase 3] `git blame` → reset code from `a4871e6201c46`; `git log --
  drivers/.../rzg2l_mipi_dsi.c` → series history
- [Phase 3] `git merge-base --is-ancestor` → patches 1/3 and 2/3
  present; 8065890f5cda3 absent
- [Phase 4] `b4 dig -c 8065890f5cda3` → lore URL found
- [Phase 4] `b4 dig -a` → v1/v2/v3 series; v3 is latest
- [Phase 4] `b4 dig -w` → DRM/Renesas maintainers CC'd
- [Phase 4] `/tmp/cmn_rstb_thread.mbox` → Reviewed-by, Tested-by on
  RZ/G3E; no NAKs; cover letter describes manual requirements
- [Phase 5] `grep rzg2l_mipi_dsi_startup/stop` → called from
  atomic_pre_enable/post_disable
- [Phase 5] `drivers/reset/core.c` →
  `reset_control_assert/deassert(NULL)` returns 0 (no-op)
- [Phase 6] Buggy code confirmed in 6.18.43 tree
- [Phase 6] `git cherry-pick --no-commit 8065890f5cda3` → exit 0, auto-
  merge only
- [Phase 8] Driver supports `renesas,rzg2l-mipi-dsi` compatible string
  in local tree

**YES**

 drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c b/drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c
index 04a24ff9dde15..1c6f29c285b65 100644
--- a/drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c
+++ b/drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c
@@ -228,7 +228,6 @@ static int rzg2l_mipi_dsi_dphy_init(struct rzg2l_mipi_dsi *dsi,
 	u32 dphytim1;
 	u32 dphytim2;
 	u32 dphytim3;
-	int ret;
 
 	/* All DSI global operation timings are set with recommended setting */
 	for (i = 0; i < ARRAY_SIZE(rzg2l_mipi_dsi_global_timings); ++i) {
@@ -268,12 +267,6 @@ static int rzg2l_mipi_dsi_dphy_init(struct rzg2l_mipi_dsi *dsi,
 	rzg2l_mipi_dsi_phy_write(dsi, DSIDPHYTIM2, dphytim2);
 	rzg2l_mipi_dsi_phy_write(dsi, DSIDPHYTIM3, dphytim3);
 
-	ret = reset_control_deassert(dsi->rstc);
-	if (ret < 0)
-		return ret;
-
-	fsleep(1000);
-
 	return 0;
 }
 
@@ -285,8 +278,6 @@ static void rzg2l_mipi_dsi_dphy_exit(struct rzg2l_mipi_dsi *dsi)
 
 	dphyctrl0 &= ~(DSIDPHYCTRL0_EN_LDO1200 | DSIDPHYCTRL0_EN_BGR);
 	rzg2l_mipi_dsi_phy_write(dsi, DSIDPHYCTRL0, dphyctrl0);
-
-	reset_control_assert(dsi->rstc);
 }
 
 static int rzg2l_dphy_conf_clks(struct rzg2l_mipi_dsi *dsi, unsigned long mode_freq,
@@ -393,6 +384,14 @@ static int rzg2l_mipi_dsi_startup(struct rzg2l_mipi_dsi *dsi,
 	dsisetr |= FIELD_PREP(DSISETR_MRPSZ, RZG2L_DCS_BUF_SIZE);
 	rzg2l_mipi_dsi_link_write(dsi, DSISETR, dsisetr);
 
+	if (dsi->rstc) {
+		ret = reset_control_deassert(dsi->rstc);
+		if (ret < 0)
+			goto err_phy;
+
+		fsleep(1000);
+	}
+
 	return 0;
 
 err_phy:
@@ -404,6 +403,7 @@ static int rzg2l_mipi_dsi_startup(struct rzg2l_mipi_dsi *dsi,
 
 static void rzg2l_mipi_dsi_stop(struct rzg2l_mipi_dsi *dsi)
 {
+	reset_control_assert(dsi->rstc);
 	dsi->info->dphy_exit(dsi);
 	pm_runtime_put(dsi->dev);
 }
-- 
2.53.0

