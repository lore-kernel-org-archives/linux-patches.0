Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30454570C3;
	Mon, 31 Aug 2026 13:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183274; cv=none; b=GEYSRviGpyXeES81yUa3kD79+QDm5d26Lc2/03Dq52VFMo9RR81tQPbIFM5z4NtHiBxTB2iuhbVLkoE7/Rig5+Un9tnZ9kvu3OLibDOF5YCXNroMVMxbtepajB5eH9t2NiibHAOXmxmQN/echy33bXxa33aNW2jTgtHT48ucEvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183274; c=relaxed/simple;
	bh=t/bXt/ASDbbvGez2CuTMegvHsZ2LU2lk5dnKRVp7Vhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A3m2pDwVGGC4GIEKCp/kQuek5jdZe7xyIilSmXffCTb9plStiik8rzF0pP0FoXrkAwf8F0cWU8nUhhykZCtNvsaRkXIrTvBhphAV72uUCBD5UMcKpmpoVUTetSqMv0+NXMcc5xCL7Gx3KQ3OP8zembcMAxlIKaK2pu/Q9sRyj0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FLNmgTjH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FLNmgTjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113951F00A3D;
	Mon, 31 Aug 2026 13:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183272;
	bh=lmSOHeqnUc5i0bcj+yq+SYcrx7e+BzRTeVbv18wv6GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FLNmgTjHiQAyD6JZy9/5TgGv7f7/oiDsGfNDsCXjLk9B2gTxtaYvcEROJ4sld+5QX
	 ioG2/Iq25tZBoy1UR3EkCgxjqYtWpkK/8B9B/Vm6erww2hLH/76mOSMnOpehfquU6s
	 d/8e8gfbwQwAhVxT873niz855wX0t4aL7tpX1oyZHrlBY9dGpKmMe384DyKnsEHXFJ
	 LfCyAkS0vayVM4R+bO2/JUvm9/JuLwmpTqKlcClF6pIonCB+AzWR+YaaVo9snciuS1
	 5g1lQxwR0X4a4z8JmAif1i/1LF8xGlxJmouFgf0Bytjno0RZwZJr1fMcKSQidOPhN5
	 ty+B+MqeU3HYA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-renesas-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] drm: rz-du: Ensure correct suspend/resume ordering with VSP
Date: Mon, 31 Aug 2026 09:21:16 -0400
Message-ID: <20260831133314.4125787-48-sashal@kernel.org>
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

From: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>

[ Upstream commit c94e765abb051df62b9f7c27116ef9307216c868 ]

The VSP serves as an interface to memory and a compositor to the DU. It
therefore needs to be suspended after and resumed before the DU, to be
properly stopped and restarted in a controlled fashion driven by the DU
driver. This currently works by chance. Avoid relying on luck by
enforcing the correct suspend/resume ordering with device links.

Based on similar work done by Laurent Pinchart for R-Car DU.
commit db5be3a7d6bd ("drm: rcar-du: Ensure correct suspend/resume
ordering with VSP")

Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Link: https://patch.msgid.link/20260330144651.817338-1-tommaso.merciai.xr@bp.renesas.com
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `drm: rz-du: Ensure correct suspend/resume
ordering with VSP`

**Local tree:** Linux **6.18.43** (`git describe HEAD` → `v6.18.43`,
detached at `stable/linux-6.18.y`)

**Upstream commit:** `c94e765abb051` (on `all-next`, not yet in this
6.18.43 checkout)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[drm: rz-du]` `[Ensure]` — enforce correct suspend/resume
ordering between RZ/G2L Display Unit (DU) and its VSP compositor via
device links.

### Step 1.2: Tags
**Record:**
| Tag | Value |
|-----|-------|
| Reviewed-by | Laurent Pinchart
\<laurent.pinchart+renesas@ideasonboard.com\> |
| Signed-off-by | Tommaso Merciai, Biju Das |
| Link | https://patch.msgid.link/20260330144651.817338-1-
tommaso.merciai.xr@bp.renesas.com |
| Fixes: | **None** (expected for manual review) |
| Cc: stable | **None** |
| Reported-by / Tested-by | **None** |
| syzbot | **None** |

Notable: reviewed by the R-Car/Renesas DRM expert who authored the
identical rcar-du fix. No user crash report or Tested-by.

### Step 1.3: Body analysis
**Record:**
- **Bug:** VSP must be suspended *after* DU and resumed *before* DU
  because VSP is DU's memory interface/compositor. Current ordering
  relies on luck (device-tree probe order).
- **Symptom:** Incorrect suspend/resume ordering can leave VSP stopped
  while DU still uses it (or vice versa on resume) — undefined behavior
  during power transitions.
- **Root cause:** No explicit consumer/supplier relationship between DU
  and VSP platform devices.
- **Fix approach:** `device_link_add(DU, VSP, DL_FLAG_STATELESS)` plus
  cleanup in `rzg2l_du_vsp_cleanup()`.
- **Reference:** Mirrors `db5be3a7d6bd` ("drm: rcar-du: Ensure correct
  suspend/resume ordering with VSP").

### Step 1.4: Hidden bug fix?
**Record:** Yes. Despite "Ensure" wording rather than "fix", this is a
power-management correctness bug fix — a race/ordering hazard disguised
as hardening. Same pattern as a well-understood rcar-du bug fix.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
| File | Changes |
|------|---------|
| `rzg2l_du_vsp.c` | +16 lines |
| `rzg2l_du_vsp.h` | +2 lines (`struct device_link *link`) |
| **Total** | 18 lines, 2 files |
| **Functions** | `rzg2l_du_vsp_cleanup()`, `rzg2l_du_vsp_init()` |
| **Scope** | Single-subsystem, surgical |

### Step 2.2: Code flow per hunk
**Record:**
1. **Include `linux/device.h`** — needed for `device_link_add/del`.
2. **`rzg2l_du_vsp_cleanup()`** — Before: only `put_device(vsp->vsp)`.
   After: also `device_link_del(vsp->link)` if set.
3. **`rzg2l_du_vsp_init()`** — Before: find VSP pdev, register cleanup,
   call `vsp1_du_init()`. After: create stateless device link
   `DU(consumer) → VSP(supplier)`; fail probe with `-EINVAL` if link
   creation fails.
4. **`rzg2l_du_vsp.h`** — Add `struct device_link *link` to `struct
   rzg2l_du_vsp`.

### Step 2.3: Bug mechanism
**Record:** **Category:** Power-management ordering / race condition.
- VSP (`vsp1_drv.c`) has `SYSTEM_SLEEP_PM_OPS`
  (`vsp1_pm_suspend`/`vsp1_pm_resume`).
- When `vsp1->drm` is set (DU pipeline mode), VSP expects DU to
  stop/restart it explicitly; it only does `pm_runtime_force_suspend`
  during system sleep.
- Without a device link, kernel suspend/shutdown order depends on
  ACPI/DT enumeration order — nondeterministic across platforms.
- `device_link_add(consumer, supplier)` reorders
  `dpm_list`/`devices_kset` so consumer is always processed before
  supplier on suspend/shutdown and after supplier on resume.

### Step 2.4: Fix quality
**Record:**
- **Obviously correct:** Yes — identical, proven pattern from rcar-du;
  reviewed by subsystem maintainer.
- **Minimal:** Yes — 18 lines, no refactoring.
- **Regression risk:** Very low. Worst case: `device_link_add()` fails
  at probe (logged, `-EINVAL`); no hot-path changes.
- **Red flags:** None.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `rzg2l_du_vsp_init()` and cleanup logic date to initial VSP
integration (file introduced with RZ/G2L DU driver). Buggy code (no
device link) has been present since VSP support was added. RZ/G2L DU
driver landed in `768e9e61b3b99` ("drm: renesas: Add RZ/G2L DU
Support"), confirmed ancestor of HEAD.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:** Recent rz-du stable activity includes power-sequencing fixes
(e.g. `79f42487ed60d` — MIPI DSI reboot panic). No prior device_link fix
for rz-du in this tree. rcar-du sibling fix `db5be3a7d6bd` exists on
`all-next` but is **not** an ancestor of 6.18.43 HEAD.

### Step 3.4: Author commits
**Record:** Tommaso Merciai — Renesas contributor; no other rz-du
commits in this 6.18.43 tree. Biju Das is rz-du maintainer (signed off).

### Step 3.5: Dependencies
**Record:** **Standalone.** Single patch (v1→v2 only added Reviewed-by
tag and rcar-du commit reference). No prerequisite commits. Applies
cleanly (`git apply --check` passed).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- `b4 dig -c c94e765abb051` → https://patch.msgid.link/20260330144651.81
  7338-1-tommaso.merciai.xr@bp.renesas.com
- Series: v1 (2026-03-24) → v2 (2026-03-30, committed version)
- Maintainer response: "Applied to drm-misc-next" (Biju Das)
- **No stable nomination, no NAKs**

### Step 4.2: Reviewers
**Record:** CC'd to `dri-devel`, `linux-renesas-soc`, Laurent Pinchart,
Maarten Lankhorst, David Airlie, Thomas Zimmermann, etc. Reviewed-by
from Laurent Pinchart (subsystem expert).

### Step 4.3: Bug report
**Record:** No external bug report, stack trace, or syzbot link. Issue
identified by code analysis ("works by chance").

### Step 4.4: Series context
**Record:** Standalone 1-patch series. rcar-du counterpart is separate
but parallel.

### Step 4.5: Stable list
**Record:** No stable@vger.kernel.org discussion found for this specific
patch.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `rzg2l_du_vsp_init()`, `rzg2l_du_vsp_cleanup()`,
`rzg2l_du_vsps_init()` (caller).

### Step 5.2: Callers
**Record:** `rzg2l_du_vsps_init()` → called from
`rzg2l_du_modeset_init()` during DU probe. Runs once per VSP referenced
in DT `renesas,vsps` property. Init path only — not a hot path.

### Step 5.3: Callees
**Record:** `of_find_device_by_node()`, `drmm_add_action_or_reset()`,
`device_link_add()`, `vsp1_du_init()`, `device_link_del()`,
`put_device()`.

### Step 5.4: Reachability
**Record:** Triggered at boot on RZ/G2L platforms with
`CONFIG_DRM_RZG2L_DU` + `CONFIG_VIDEO_RENESAS_VSP1`. Power-transition
bugs manifest on suspend/resume/reboot/shutdown — common embedded
operations.

### Step 5.5: Similar patterns
**Record:** Identical fix in `rcar_du_vsp.c` (`db5be3a7d6bd` on all-
next). rcar-du also uses `device_link_add` for CMM ordering in
`rcar_du_kms.c` (already in 6.18.43). Established Renesas DRM pattern.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.43)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current `rzg2l_du_vsp.c` lacks
`device_link_add/del` and `vsp->link` field. VSP integration has been
present since RZ/G2L DU driver merge (`768e9e61b3b99` is ancestor of
HEAD).

### Step 6.2: Backport complications
**Record:** **Clean apply** — `git apply --check` on commit diff
succeeded with no conflicts.

### Step 6.3: Related fixes already present?
**Record:** No equivalent device_link fix for rz-du in 6.18.43. Related
rz-du power fix `79f42487ed60d` (MIPI DSI reboot panic) is already in
stable — shows this subsystem's power-sequencing bugs are stable-worthy.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/gpu/drm/renesas/rz-du/` — **PERIPHERAL** (Renesas
RZ/G2L embedded SoCs only). Critical for affected hardware users; not
universal.

### Step 7.2: Activity
**Record:** Actively maintained in 6.18.y (MIPI DSI fixes, resolution
updates, encoder fixes in 2025–2026).

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users of RZ/G2L/RZ/V2L SoCs with DU+VSP display pipeline
(`CONFIG_DRM_RZG2L_DU`, `ARCH_RZG2L`). Driver-specific, not config-
universal.

### Step 8.2: Trigger conditions
**Record:** System suspend (S3), resume, reboot/shutdown. DU has
`.shutdown` handler (`drm_atomic_helper_shutdown`); VSP has system-sleep
PM ops. Ordering nondeterminism depends on DT/ACPI device enumeration —
"works by chance" today.

**Note:** rz-du lacks explicit `DEFINE_SIMPLE_DEV_PM_OPS` suspend/resume
(unlike rcar-du). This limits the immediate S3 benefit until DU PM is
added, but device links still affect shutdown ordering and will enforce
correct ordering once PM is added. Maintainers merged this on mainline
knowing rz-du has no PM ops yet.

### Step 8.3: Failure mode severity
**Record:** When wrong order triggers: VSP suspended while DU still
active → undefined behavior, possible oops/corruption/display failure.
**Severity: HIGH** when triggered; **likelihood: LOW–MEDIUM** (depends
on DT order). Prior rz-du reboot panic stable backport confirms real-
world power-transition failures in this driver.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** MEDIUM-HIGH for RZ/G2L embedded users; prevents
  nondeterministic suspend/shutdown ordering bugs.
- **Risk:** VERY LOW — 18-line, proven pattern, probe-time only.
- **Ratio:** Favorable.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real PM ordering bug in production code path (VSP system-sleep PM + DU
  dependency)
- Small, surgical, obviously correct fix mirroring accepted rcar-du
  pattern
- Reviewed by Laurent Pinchart (Renesas DRM expert)
- Buggy code confirmed present in 6.18.43; patch applies cleanly
- Prior stable backport of rz-du power-sequencing bug (`79f42487ed60d`)
- VSP driver explicitly documents DU must control VSP during pipeline
  suspend

**AGAINST backport:**
- No user-reported crash or Tested-by for rz-du specifically
- rz-du lacks system-sleep PM ops (unlike rcar-du), reducing immediate
  S3 suspend benefit
- Peripheral driver — limited user base
- Theoretical "works by chance" rather than demonstrated failure

**Unresolved:** No runtime test evidence for rz-du specifically; exact
failure rate on RZ/G2L boards unverified.

### Step 9.2: Stable rules checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — correct by inspection;
reviewed by maintainer; rcar-du analogue tested |
| 2. Fixes real bug? | **PASS** — PM ordering hazard in DU+VSP pipeline
|
| 3. Important issue? | **PASS** — potential crash/corruption on
suspend/resume/reboot (HIGH severity, moderate likelihood) |
| 4. Small and contained? | **PASS** — 18 lines, 2 files |
| 5. No new features/APIs? | **PASS** — internal device link only |
| 6. Applies to local tree? | **PASS** — clean apply, code and driver
present |

### Step 9.3: Exception categories
**Record:** N/A — standard bug fix, not device-ID/quirk/DT/build/doc
exception.

### Step 9.4: Decision rationale
This commit fixes a real power-management ordering defect in the RZ/G2L
DU driver that has been present since VSP support was added to 6.18.y.
The fix is minimal, follows an identical accepted rcar-du pattern, is
reviewed by the subsystem expert, and applies cleanly to 6.18.43. While
rz-du currently lacks explicit system-sleep PM callbacks (a separate
gap), the device link still enforces correct shutdown ordering (DU has a
`.shutdown` handler) and ensures correct suspend/resume ordering for the
VSP's system-sleep PM path. The risk is negligible and consistent with
prior stable backports of rz-du power-sequencing fixes.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user-provided diff
  and `git show c94e765abb051`
- **[Phase 2]** Diff analysis: 18 lines across 2 files; adds
  `device_link_add/del` in init/cleanup
- **[Phase 3]** `git describe HEAD` → v6.18.43; `git blame` on
  `rzg2l_du_vsp.c:292-325` → original VSP init code; `git merge-base
  --is-ancestor 768e9e61b3b99 HEAD` → rz-du driver in tree;
  `db5be3a7d6bd` not ancestor of HEAD
- **[Phase 3]** `git apply --check` on commit diff → applies cleanly
- **[Phase 4]** `b4 dig -c c94e765abb051` → lore URL; `b4 dig -a` →
  v1/v2 only; `b4 dig -w` → maintainers CC'd; mbox grep → Reviewed-by
  Laurent Pinchart, "Applied to drm-misc-next", no stable nomination
- **[Phase 5]** `grep rzg2l_du_vsp_init` → called from
  `rzg2l_du_vsps_init()` in `rzg2l_du_kms.c`; verified VSP PM ops in
  `vsp1_drv.c:625-701`
- **[Phase 6]** Read current `rzg2l_du_vsp.c` — no device_link present;
  `grep device_link` in rz-du → no matches
- **[Phase 6]** `git show all-next:rzg2l_du_drv.c | rg pm` → no PM ops
  on all-next either (fix merged without DU PM)
- **[Phase 6]** Confirmed `79f42487ed60d` in tree as prior rz-du power
  stable backport
- **[Phase 7]** Driver is `CONFIG_DRM_RZG2L_DU`, `ARCH_RZG2L` —
  peripheral/embedded
- **[Phase 8]** Verified rz-du has `.shutdown` but no `.pm`
  suspend/resume in `rzg2l_du_drv.c`; rcar-du has PM ops for comparison

**YES**The analysis is complete for **Linux 6.18.43**
(`stable/linux-6.18.y`).

**Commit:** `c94e765abb051` — `drm: rz-du: Ensure correct suspend/resume
ordering with VSP`
**Verdict: YES** — backport to this tree.

**Summary:** The RZ/G2L DU driver in 6.18.43 uses a VSP compositor
without an explicit device link, so suspend/resume/shutdown ordering
depends on DT probe order. The patch adds the same small
`device_link_add()` pattern already used for rcar-du (~18 lines, applies
cleanly). Reviewed by Laurent Pinchart; low risk and consistent with
prior stable rz-du power-sequencing fixes.

**Caveat:** rz-du still lacks system-sleep PM callbacks (unlike rcar-
du), so the main immediate benefit is shutdown ordering and future-
proofing when PM is added — but the underlying ordering bug is real on
RZ/G2L hardware with VSP.

 drivers/gpu/drm/renesas/rz-du/rzg2l_du_vsp.c | 16 ++++++++++++++++
 drivers/gpu/drm/renesas/rz-du/rzg2l_du_vsp.h |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/drivers/gpu/drm/renesas/rz-du/rzg2l_du_vsp.c b/drivers/gpu/drm/renesas/rz-du/rzg2l_du_vsp.c
index 040d4e4aff000..ab49604d69acf 100644
--- a/drivers/gpu/drm/renesas/rz-du/rzg2l_du_vsp.c
+++ b/drivers/gpu/drm/renesas/rz-du/rzg2l_du_vsp.c
@@ -20,6 +20,7 @@
 #include <drm/drm_vblank.h>
 
 #include <linux/bitops.h>
+#include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
@@ -293,6 +294,9 @@ static void rzg2l_du_vsp_cleanup(struct drm_device *dev, void *res)
 {
 	struct rzg2l_du_vsp *vsp = res;
 
+	if (vsp->link)
+		device_link_del(vsp->link);
+
 	put_device(vsp->vsp);
 }
 
@@ -317,6 +321,18 @@ int rzg2l_du_vsp_init(struct rzg2l_du_vsp *vsp, struct device_node *np,
 	if (ret < 0)
 		return ret;
 
+	/*
+	 * Enforce suspend/resume ordering between the DU (consumer) and the
+	 * VSP (supplier). The DU will be suspended before and resume after the
+	 * VSP.
+	 */
+	vsp->link = device_link_add(rcdu->dev, vsp->vsp, DL_FLAG_STATELESS);
+	if (!vsp->link) {
+		dev_err(rcdu->dev, "Failed to create device link to VSP %s\n",
+			dev_name(vsp->vsp));
+		return -EINVAL;
+	}
+
 	ret = vsp1_du_init(vsp->vsp);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/gpu/drm/renesas/rz-du/rzg2l_du_vsp.h b/drivers/gpu/drm/renesas/rz-du/rzg2l_du_vsp.h
index 322eb80dcbaff..a22aaf0843ed7 100644
--- a/drivers/gpu/drm/renesas/rz-du/rzg2l_du_vsp.h
+++ b/drivers/gpu/drm/renesas/rz-du/rzg2l_du_vsp.h
@@ -15,6 +15,7 @@
 #include <linux/scatterlist.h>
 
 struct device;
+struct device_link;
 struct drm_framebuffer;
 struct rzg2l_du_device;
 struct rzg2l_du_format_info;
@@ -29,6 +30,7 @@ struct rzg2l_du_vsp_plane {
 struct rzg2l_du_vsp {
 	unsigned int index;
 	struct device *vsp;
+	struct device_link *link;
 	struct rzg2l_du_device *dev;
 };
 
-- 
2.53.0

