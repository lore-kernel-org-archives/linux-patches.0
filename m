Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B27147B42E;
	Mon, 20 Apr 2026 13:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691857; cv=none; b=FGCtH9S6jZIQVjqTiOccQHap18oFbxThsQeq+NQlTr7ljnnyo/MUwx3KG9kYd5ad+ZYRFncp0SP/6y5ZXCUBhsRsiljrG+RzYNzXOjJWB7PSjTSIw3CAkMBZABtPPEkUZ4YtCJOZ27BVrPSGLYzWw+cxXju4dkHDeAnolqGpI4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691857; c=relaxed/simple;
	bh=GoDU3myU5m73/KG3MfZbNHoQd8XmLXOs56QN8owq69I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HWD+RTSa0WBxx/eNslBfrXFxD/B8VLy4pOL/VWKGADUPlxXXvZqS+9yGdoedBwghBkmxxE8pSjEN6qxiXpEWMdVnVtlSzLecN24PzraZAqPJF2lToHt/jKGaXQwbTgLd8LQwAsxyKcmXBH9NxYic95OhpqJI9mvxBwq1l2iAFl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X+/f6is4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X+/f6is4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DE3C2BCB4;
	Mon, 20 Apr 2026 13:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691857;
	bh=GoDU3myU5m73/KG3MfZbNHoQd8XmLXOs56QN8owq69I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X+/f6is49+D7YAy+K0d3BpfaQYBB3EqvdyEhxFDD0gJ3HabvZWjM9AUnOHTeLxdfO
	 ieZjQ/WgV2ENgvA0S5vrbKZ48/XbbCimMJi0FvYw6lrvrbxHI7esyONyOGjuUHwQ8K
	 rOQFSc1XpCnRYcMnBR3m8qrm6eXCSDMmzuC/PgktgVQqxMjOdpgVLX7v8hzMYilH0t
	 pW4vwoY88JGTvsKbQvPFttVrd3bLhs8RxsiXv0EfjWg375j9KDG4i3rHuJiSxM2pLr
	 CnAKmSfeOaDKzWKnYCzOh6XsTYSGL/ZOljNCpG+FycmcBWrwKLDsB7kb8AhNXsoohO
	 7W9T5e7GjKxXw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Chuanyu Tseng <chuanyu.tseng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	harry.wentland@amd.com,
	sunpeng.li@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] drm/amd/display: Avoid turning off the PHY when OTG is running for DVI
Date: Mon, 20 Apr 2026 09:20:28 -0400
Message-ID: <20260420132314.1023554-234-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit ee212b0208a18831d2b537865da56708c17af90d ]

[Why]
The OTG's virtual pixel clock source for DVI comes from the PHY.

If the signal type is DVI then the OTG can become stuck on pre DCN401
ASIC when DPMS off occurs because the OTG remains running but the
PHY transmitter is disabled.

[How]
There exists logic to keep track of the OTG running refcount on the
link to determine if the link needs to go to PLL_EN instead of TX_EN
but the logic only checks for HDMI TMDS on older ASIC.

DVI is still a TMDS signal type so the constraint should also apply.

Replace the checks for dc_is_hdmi_tmds_signal with dc_is_tmds_signal to
cover both HDMI and DVI for the symclk refcount workaround.

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Chuanyu Tseng <chuanyu.tseng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for the complete analysis. Let me
compile everything.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem:** drm/amd/display (AMD display driver)
- **Action verb:** "Avoid" (implies preventing an undesirable condition
  - strong bug fix indicator)
- **Summary:** Prevent PHY from being turned off when OTG is running for
  DVI signals

Record: [drm/amd/display] [Avoid] [Prevents PHY shutdown while OTG is
running for DVI, which causes OTG to get stuck]

### Step 1.2: Tags
- **Reviewed-by:** Dillon Varone <dillon.varone@amd.com> - AMD display
  team member
- **Reviewed-by:** Charlene Liu <charlene.liu@amd.com> - AMD display
  team member (senior contributor)
- **Signed-off-by:** Nicholas Kazlauskas <nicholas.kazlauskas@amd.com> -
  Author, prolific AMD display contributor
- **Signed-off-by:** Chuanyu Tseng <chuanyu.tseng@amd.com> - Co-
  author/submitter
- **Signed-off-by:** Alex Deucher <alexander.deucher@amd.com> - AMD DRM
  maintainer
- No Fixes: tag, no Cc: stable (expected for autosel candidates)

Record: Two Reviewed-by from AMD display engineers. Author is an active
AMD display subsystem contributor with many commits. Applied by the
subsystem maintainer.

### Step 1.3: Commit Body Analysis
**Bug description:** On pre-DCN401 ASICs, when using a DVI output, DPMS
off causes the PHY transmitter to be disabled while the OTG (Output
Timing Generator) is still running. The OTG's virtual pixel clock source
for DVI comes from the PHY, so disabling the PHY causes the OTG to
become stuck.

**Root cause:** The symclk reference count tracking logic that prevents
premature PHY shutdown only checked for HDMI TMDS signals
(`dc_is_hdmi_tmds_signal`), but DVI is also a TMDS signal type that has
the same clock dependency.

**Fix approach:** Replace `dc_is_hdmi_tmds_signal` with
`dc_is_tmds_signal` to cover both HDMI and DVI signal types.

Record: Hardware hang bug on DVI output during DPMS off. OTG gets stuck
because PHY providing its clock is disabled. Root cause is incomplete
signal type check. Severity: CRITICAL (system hang).

### Step 1.4: Hidden Bug Fix Detection
This is NOT a hidden bug fix - it's explicitly described as preventing a
hardware hang condition. The commit clearly articulates the bug
mechanism, root cause, and fix.

Record: Explicitly described bug fix, not disguised.

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **dce110_hwseq.c**: 2 lines changed (line 1571, line 2421)
- **dcn20_hwseq.c**: 2 lines changed (line 896, line 2859)
- **dcn31_hwseq.c**: 1 line changed (line 552)
- **dcn401_hwseq.c**: 1 line changed (line 2024)
- **Total**: 6 single-line changes across 4 files
- **Functions modified:** `dce110_enable_stream_timing`,
  `dce110_reset_hw_ctx_wrap`, `dcn20_enable_stream_timing`,
  `dcn20_reset_back_end_for_pipe`, `dcn31_reset_back_end_for_pipe`,
  `dcn401_reset_back_end_for_pipe`
- **Scope:** Small, surgical, single-purpose

Record: 6 lines changed, 4 files, all changes are identical substitution
of one function call for another.

### Step 2.2: Code Flow Change
Every change is identical: `dc_is_hdmi_tmds_signal()` ->
`dc_is_tmds_signal()`.

- `dc_is_hdmi_tmds_signal()`: returns true only for
  `SIGNAL_TYPE_HDMI_TYPE_A`
- `dc_is_tmds_signal()`: returns true for `SIGNAL_TYPE_DVI_SINGLE_LINK`,
  `SIGNAL_TYPE_DVI_DUAL_LINK`, AND `SIGNAL_TYPE_HDMI_TYPE_A`

The change extends the signal check to include DVI signals in addition
to HDMI. This ensures:
1. **Enable path**: symclk_ref_cnts.otg is set to 1 and symclk_state is
   properly tracked for DVI (not just HDMI)
2. **Disable/reset path**: symclk_ref_cnts.otg is properly cleared for
   DVI, enabling the proper PHY shutdown sequence

Record: Before: Only HDMI gets symclk tracking. After: Both HDMI and DVI
get symclk tracking. This prevents PHY shutdown while OTG still needs
the clock.

### Step 2.3: Bug Mechanism
**Category:** Hardware hang / OTG stuck due to clock dependency
- The OTG needs a clock from the PHY for TMDS signals (both HDMI and
  DVI)
- Without proper symclk reference counting for DVI, the PHY could be
  powered off while the OTG is still running
- This causes the OTG to become stuck (hardware hang)

Record: Hardware hang in DPMS off path for DVI output on pre-DCN401
ASICs. The fix extends symclk ref counting to cover all TMDS signals.

### Step 2.4: Fix Quality
- **Obviously correct:** YES - `dc_is_tmds_signal` is a strict superset
  of `dc_is_hdmi_tmds_signal`, and the commit message clearly explains
  why DVI needs the same treatment
- **Minimal/surgical:** YES - 6 identical one-line substitutions
- **Regression risk:** Very low - the only behavioral change is that DVI
  now gets symclk tracking (which it should have had). For HDMI,
  behavior is unchanged. For non-TMDS signals, behavior is unchanged.
- **Red flags:** None

Record: Fix is obviously correct, minimal, and very low regression risk.

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The buggy code (`dc_is_hdmi_tmds_signal` used for symclk tracking) was
introduced by commit `9c75891feef0f9` ("drm/amd/display: rework recent
update PHY state commit") by Wenjing Liu, which went into v6.1-rc1. This
commit introduced the symclk reference counting workaround but only for
HDMI TMDS signals.

Record: Buggy code introduced in v6.1-rc1 by commit 9c75891feef0f9.
Present in all stable trees >= v6.1.

### Step 3.2: Fixes Tag
No explicit Fixes: tag present (expected for autosel candidate).
However, the implicit fix target is `9c75891feef0f9` which is present
since v6.1-rc1.

Record: Implicitly fixes 9c75891feef0f9 (v6.1-rc1).

### Step 3.3: File History
Related commits in the same area:
- `dff45f03f508` (v6.8-rc1): "Only clear symclk otg flag for HDMI" -
  this was a NARROWING of the check (from unconditional to HDMI-only) to
  fix a SubVP phantom pipe issue. It actually made the DVI bug worse by
  adding the hdmi-only condition to the reset path too.
- `4589712e01113`: "Ensure link output is disabled in backend reset for
  PLL_ON" - ports DCN401 behavior to DCN31
- `75372d75a4e23`: "Adjust PHY FSM transition to TX_EN-to-PLL_ON for
  TMDS on DCN35" - related PHY FSM fix

Record: The fix is standalone. No prerequisites needed beyond the
already-present code.

### Step 3.4: Author
Nicholas Kazlauskas is a prolific AMD display contributor (20+ commits
in the hwss directory alone) with deep knowledge of the PHY state
machine and clock management. He authored the DCN35 TMDS fix and the
link output disable fix as well.

Record: Author is a core AMD display contributor with extensive
subsystem expertise.

### Step 3.5: Dependencies
The patch is self-contained. It only changes function calls that already
exist. Both `dc_is_tmds_signal` and `dc_is_hdmi_tmds_signal` have been
in the codebase since well before v6.1. No new functions, structures, or
APIs are introduced.

Record: No dependencies. Applies standalone.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Steps 4.1-4.5
b4 is not available and lore.kernel.org blocks automated access. Web
search found:
- The related DCN35 PHY FSM fix was submitted as part of a 21-patch
  series
- The "Ensure link output is disabled in backend reset for PLL_ON" fix
  was also part of stable backport discussions
- Both related fixes were included in stable backport attempts (6.19
  stable patches)

Record: Related fixes in the same PHY/OTG area have been submitted for
stable. The commit was reviewed by two AMD engineers and the maintainer.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Functions Modified
1. `dce110_enable_stream_timing` - used by DCE110 hardware
2. `dce110_reset_hw_ctx_wrap` - used by DCE110 hardware
3. `dcn20_enable_stream_timing` - shared by DCN20, DCN21, DCN30, DCN301,
   DCN31, DCN314, DCN32, DCN35, DCN351
4. `dcn20_reset_back_end_for_pipe` - used by DCN20, DCN21, DCN30,
   DCN301, DCN32
5. `dcn31_reset_back_end_for_pipe` - used by DCN31, DCN314, DCN35,
   DCN351
6. `dcn401_reset_back_end_for_pipe` - used by DCN401

Record: The fix covers the majority of AMD display hardware generations.

### Step 5.2: Callers
These functions are called during display mode set and DPMS operations -
common display operations triggered by user actions
(connecting/disconnecting monitors, screen off/on, suspend/resume).

Record: Functions are called in normal display operation paths - common
trigger.

### Step 5.3-5.5
The `dc_is_tmds_signal` function already exists and is used correctly in
other parts of the DCN401 code (lines 711, 740, 747, 936, 1063),
confirming the pattern. The DCN35 code also uses `dc_is_tmds_signal`
correctly (line 1765). The inconsistency is specifically in the symclk
tracking code in the older HWSEQ implementations.

Record: Pattern is consistent with existing correct usage in DCN35 and
DCN401.

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Code in Stable
The buggy code was introduced in v6.1-rc1 by `9c75891feef0f9`. It exists
in all active stable trees >= v6.1.

Record: Buggy code present in stable trees 6.1.y, 6.6.y, 6.12.y.

### Step 6.2: Backport Complications
The fix only changes function call names in-place. No structural changes
to the surrounding code are needed. The 4 files modified have been
present since v6.1. The `dc_is_tmds_signal` function has existed since
before v6.1.

Note: For older stable trees (6.1, 6.6), the dcn401_hwseq.c file may not
exist (DCN401 was added later). The patch would need to be trimmed for
those trees, but the other 3 files should apply cleanly or with minimal
fuzz.

Record: Should apply cleanly to 6.12.y. May need minor trimming for
6.1.y and 6.6.y (dcn401 file may not exist).

### Step 6.3: No related fix already in stable for this specific DVI
issue.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1
**Subsystem:** drm/amd/display - AMD GPU display driver
**Criticality:** IMPORTANT - affects all AMD GPU users with DVI
connections

### Step 7.2
The AMD display subsystem is very actively developed with constant
updates.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
All AMD GPU users with DVI monitors on pre-DCN401 hardware (which covers
the vast majority of AMD GPUs supporting DVI).

### Step 8.2: Trigger Conditions
- Trigger: DPMS off on a DVI-connected display (screen blank, suspend,
  monitor power off)
- This is a common operation that any DVI user would hit
- Not timing-dependent or race-related - deterministic bug

### Step 8.3: Severity
**CRITICAL** - OTG becomes stuck (hardware hang). The commit message
from the related DCN35 fix mentions this can "lead to a hang in the
DCHVM's ability to ACK invalidations" which can trigger IOMMU watchdog
timeouts.

### Step 8.4: Risk-Benefit
**Benefit:** HIGH - Prevents hardware hang for all DVI users on AMD GPUs
**Risk:** VERY LOW - 6 one-line changes, each a simple function
substitution to a well-tested superset function. Existing HDMI behavior
is 100% unchanged.

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting:**
- Fixes a hardware hang (OTG stuck) for DVI users - CRITICAL severity
- Deterministic trigger during common operation (DPMS off)
- Fix is minimal: 6 identical one-line substitutions
- Obviously correct: `dc_is_tmds_signal` is a superset that covers both
  DVI and HDMI
- Pattern already used correctly in newer code (DCN401 enable path,
  DCN35)
- Two Reviewed-by from AMD engineers
- Author is a core AMD display contributor
- Buggy code exists in all stable trees >= v6.1
- Self-contained, no dependencies
- Very low regression risk

**AGAINST backporting:**
- Touches 4 files (but changes are minimal and identical in nature)
- DCN401 file may not exist in older stable trees (minor backport
  trimming needed)
- No explicit Cc: stable or Fixes: tag (expected for autosel)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** - Reviewed by 2 AMD engineers,
   obviously correct from code analysis
2. Fixes a real bug? **YES** - Hardware hang for DVI users during DPMS
   off
3. Important issue? **YES** - System hang/stuck OTG, CRITICAL severity
4. Small and contained? **YES** - 6 one-line changes, purely mechanical
   substitution
5. No new features or APIs? **YES** - No new features, just extends
   existing check to cover DVI
6. Can apply to stable trees? **YES** - may need DCN401 hunk dropped for
   older trees

### Step 9.3: Exception Categories
Not an exception category - this is a straightforward bug fix.

### Step 9.4: Decision
This is a clear YES. It fixes a CRITICAL hardware hang for DVI users on
AMD GPUs, the fix is minimal and obviously correct, it has been reviewed
by AMD engineers, and it carries very low regression risk.

## Verification

- [Phase 1] Parsed tags: 2x Reviewed-by (AMD engineers), Signed-off-by
  author is active AMD contributor
- [Phase 2] Diff analysis: 6 one-line changes across 4 files, each
  replacing `dc_is_hdmi_tmds_signal` with `dc_is_tmds_signal`
- [Phase 2] Verified `dc_is_hdmi_tmds_signal` only matches HDMI_TYPE_A;
  `dc_is_tmds_signal` matches DVI_SINGLE_LINK, DVI_DUAL_LINK, and
  HDMI_TYPE_A (confirmed from signal_types.h)
- [Phase 3] git blame: buggy code introduced in commit 9c75891feef0f9
  (v6.1-rc1) by Wenjing Liu
- [Phase 3] Verified `dc_is_tmds_signal` function exists in
  signal_types.h since before v6.1
- [Phase 3] Found related commit dff45f03f508 (v6.8-rc1) that added
  hdmi-only condition to reset path for SubVP workaround
- [Phase 3] Author Nicholas Kazlauskas has 20+ commits in hwss directory
- [Phase 4] Web search confirmed related PHY/OTG fixes (DCN35 TMDS,
  backend reset PLL_ON) were submitted for stable
- [Phase 5] Verified `dcn20_enable_stream_timing` is shared by
  DCN20/21/30/301/31/314/32/35/351 via init.c files
- [Phase 5] Verified DCN401 already uses `dc_is_tmds_signal` at lines
  711, 740, 747, 936, 1063 - confirming correct pattern
- [Phase 6] Buggy code confirmed present since v6.1-rc1, exists in all
  active stable trees
- [Phase 6] Fix is self-contained - no new functions/structures
  introduced
- [Phase 8] Trigger: deterministic on DPMS off for DVI. Severity:
  CRITICAL (OTG hang)
- UNVERIFIED: Exact behavior of the OTG hang (whether it requires power
  cycle recovery) - but the related DCN35 fix mentions IOMMU watchdog
  timeouts, suggesting severe impact

**YES**

 drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c | 4 ++--
 drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c   | 4 ++--
 drivers/gpu/drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c   | 2 +-
 drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index 699a756bbc405..9e7085057f8ba 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1534,7 +1534,7 @@ static enum dc_status dce110_enable_stream_timing(
 			return DC_ERROR_UNEXPECTED;
 		}
 
-		if (dc_is_hdmi_tmds_signal(stream->signal)) {
+		if (dc_is_tmds_signal(stream->signal)) {
 			stream->link->phy_state.symclk_ref_cnts.otg = 1;
 			if (stream->link->phy_state.symclk_state == SYMCLK_OFF_TX_OFF)
 				stream->link->phy_state.symclk_state = SYMCLK_ON_TX_OFF;
@@ -2334,7 +2334,7 @@ static void dce110_reset_hw_ctx_wrap(
 				BREAK_TO_DEBUGGER();
 			}
 			pipe_ctx_old->stream_res.tg->funcs->disable_crtc(pipe_ctx_old->stream_res.tg);
-			if (dc_is_hdmi_tmds_signal(pipe_ctx_old->stream->signal))
+			if (dc_is_tmds_signal(pipe_ctx_old->stream->signal))
 				pipe_ctx_old->stream->link->phy_state.symclk_ref_cnts.otg = 0;
 			pipe_ctx_old->plane_res.mi->funcs->free_mem_input(
 					pipe_ctx_old->plane_res.mi, dc->current_state->stream_count);
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
index 307e8f8060e6d..a673ab0803a8f 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -893,7 +893,7 @@ enum dc_status dcn20_enable_stream_timing(
 		dccg->funcs->set_dtbclk_dto(dccg, &dto_params);
 	}
 
-	if (dc_is_hdmi_tmds_signal(stream->signal)) {
+	if (dc_is_tmds_signal(stream->signal)) {
 		stream->link->phy_state.symclk_ref_cnts.otg = 1;
 		if (stream->link->phy_state.symclk_state == SYMCLK_OFF_TX_OFF)
 			stream->link->phy_state.symclk_state = SYMCLK_ON_TX_OFF;
@@ -2856,7 +2856,7 @@ void dcn20_reset_back_end_for_pipe(
 		 * the case where the same symclk is shared across multiple otg
 		 * instances
 		 */
-		if (dc_is_hdmi_tmds_signal(pipe_ctx->stream->signal))
+		if (dc_is_tmds_signal(pipe_ctx->stream->signal))
 			link->phy_state.symclk_ref_cnts.otg = 0;
 		if (link->phy_state.symclk_state == SYMCLK_ON_TX_OFF) {
 			link_hwss->disable_link_output(link,
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c
index db2f7cbb12ff5..d6b027c06205e 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c
@@ -549,7 +549,7 @@ static void dcn31_reset_back_end_for_pipe(
 	 * the case where the same symclk is shared across multiple otg
 	 * instances
 	 */
-	if (dc_is_hdmi_tmds_signal(pipe_ctx->stream->signal))
+	if (dc_is_tmds_signal(pipe_ctx->stream->signal))
 		link->phy_state.symclk_ref_cnts.otg = 0;
 
 	if (pipe_ctx->top_pipe == NULL) {
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
index a3d33d10853b8..9d9dcd2dd5fae 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -2040,7 +2040,7 @@ void dcn401_reset_back_end_for_pipe(
 		 * the case where the same symclk is shared across multiple otg
 		 * instances
 		 */
-		if (dc_is_hdmi_tmds_signal(pipe_ctx->stream->signal))
+		if (dc_is_tmds_signal(pipe_ctx->stream->signal))
 			link->phy_state.symclk_ref_cnts.otg = 0;
 		if (link->phy_state.symclk_state == SYMCLK_ON_TX_OFF) {
 			link_hwss->disable_link_output(link,
-- 
2.53.0

