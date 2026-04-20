Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C826407591;
	Mon, 20 Apr 2026 13:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691631; cv=none; b=Bbbzx/zYdkKTP0Rxo7CMbp4KiI/hIWd+V0h3jPF7qYsHLOrOgy4j+afvUzJ9oD/ixfdYPcfl752ttHt2P48Quos/yEUT/EOYHz/sY0Pc5g97Hr7ZHOhlHAzF1kemOIJM8NteaW6r6ULWnixNnr0P3BAJrFMuTOs/xWzpq+cA1TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691631; c=relaxed/simple;
	bh=7ahyefgd9bplGIDi8XHBmZf3DUzsAV6KcxK3YyD1c+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKXXIpGkUSgNeuDPfUs/d7mSBq9wzLY6BFK4oidR7SEbTA1HGHW7TOs8n902E1qSUWhR8IQnDISjlDsrnrUUu24Ingln9yZKCPbgDdhX8TLqjR+jo6LC0LFYgmp4obHbjuE/Rb9UvCXydt4rsdb5/xSlXZqNyDv2wdRkWPWgJZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IdSp0oCd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IdSp0oCd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FAFC2BCB7;
	Mon, 20 Apr 2026 13:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691631;
	bh=7ahyefgd9bplGIDi8XHBmZf3DUzsAV6KcxK3YyD1c+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IdSp0oCd7US9ak1iLdh7PrptSttEC/IH9X4D68HZsCZWJ0f6puA/bmLIE7SrU4iiT
	 UHa86JY+KRfcZ1JF+huG2j+lABuNxt7yQCiUVTgNLgUdwfI/hxDBtDakxfTd5im85a
	 8rZYSN0hj3ejps8BMDTGNNCreBXmScgjEled+aYL60wuvACWy5BBegd9AnDB2GvC6F
	 zfp4r6EV27fmOhCiVmhzK5MfUscYhGCHqSZGKByMtH9DOaUbV9EUUbFS7BuW539vIL
	 2euN18dAjMtAOsmVWHCwhXrFbc4Esa/FsWsaDhqzKcFeblKuXW5OfNT7TItQ1raDIm
	 j6qsX4G89bRHg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sk Anirban <sk.anirban@intel.com>,
	Badal Nilawar <badal.nilawar@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	matthew.brost@intel.com,
	thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] drm/xe/guc: Add Wa_14025883347 for GuC DMA failure on reset
Date: Mon, 20 Apr 2026 09:18:56 -0400
Message-ID: <20260420132314.1023554-142-sashal@kernel.org>
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

From: Sk Anirban <sk.anirban@intel.com>

[ Upstream commit c57db41b8d2cd410e7219729f446aa17965485ad ]

Prevent GuC firmware DMA failures during GuC-only reset by disabling
idle flow and verifying SRAM handling completion. Without this, reset
can be issued while SRAM handler is copying WOPCM to SRAM,
causing GuC HW to get stuck.

v2: Modify error message (Badal)
    Rename reg bit name (Daniele)
    Update WA skip condition (Daniele)
    Update SRAM handling logic (Daniele)
v3: Reorder WA call (Badal)
    Wait for GuC ready status (Daniele)
v4: Update reg name (Badal)
    Add comment (Daniele)
    Add extended graphics version (Daniele)
    Modify rules

Signed-off-by: Sk Anirban <sk.anirban@intel.com>
Reviewed-by: Badal Nilawar <badal.nilawar@intel.com>
Acked-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Link: https://patch.msgid.link/20260202105313.3338094-4-sk.anirban@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a comprehensive picture. Let me compile my full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
Record: [drm/xe/guc] [Add] Hardware workaround Wa_14025883347 for GuC
DMA failure during GuC-only reset

**Step 1.2: Tags**
- Signed-off-by: Sk Anirban <sk.anirban@intel.com> (author)
- Reviewed-by: Badal Nilawar <badal.nilawar@intel.com>
- Acked-by: Matt Roper <matthew.d.roper@intel.com> (subsystem
  maintainer)
- Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
- Link:
  https://patch.msgid.link/20260202105313.3338094-4-sk.anirban@intel.com
- Signed-off-by: Matt Roper <matthew.d.roper@intel.com> (applied by
  maintainer)
- No Fixes: tag (expected), no Reported-by, no Cc: stable

**Step 1.3: Commit Body**
The bug: During GuC-only reset, if the SRAM handler is actively copying
WOPCM to SRAM, issuing the reset causes GuC HW to get stuck. The
workaround disables idle flow and waits for SRAM handling completion
before proceeding with reset.

**Step 1.4: Hidden Bug Fix Detection**
This is explicitly a hardware workaround for a known Intel hardware
errata (Wa_14025883347). It prevents the GuC from getting stuck during
reset - this is a real bug fix for a hardware deficiency.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- `drivers/gpu/drm/xe/regs/xe_guc_regs.h`: +8 lines (new register
  definitions)
- `drivers/gpu/drm/xe/xe_guc.c`: +38 lines (new function + call site)
- `drivers/gpu/drm/xe/xe_wa_oob.rules`: +3 lines (WA matching rules)
- Total: +49 lines, 0 removed. 3 files changed.
- Scope: Single-subsystem, well-contained

**Step 2.2: Code Flow Changes**
- New register definitions: BOOT_HASH_CHK, GUC_BOOT_UKERNEL_VALID,
  GUC_SRAM_STATUS, GUC_SRAM_HANDLING_MASK, GUC_IDLE_FLOW_DISABLE
- New function `guc_prevent_fw_dma_failure_on_reset()`: reads GUC_STATUS
  (skips if already in reset), reads BOOT_HASH_CHK (skips if ukernel not
  valid), disables idle flow, waits for GuC ready status, waits for SRAM
  handling completion
- Call site: injected in `xe_guc_reset()` between SRIOV VF check and the
  actual reset write, gated by `XE_GT_WA(gt, 14025883347)`

**Step 2.3: Bug Mechanism**
This is a hardware workaround (category h). Race condition between SRAM
save/restore and reset issuance. Without the WA, reset can arrive while
DMA is in progress, causing hardware hang.

**Step 2.4: Fix Quality**
- Gated behind hardware version checks (only runs on affected hardware)
- Has early-return safety checks (already in reset, ukernel not valid)
- Uses existing MMIO wait infrastructure with timeouts
- Only emits warnings on timeout, doesn't abort the reset
- Very low regression risk for unaffected hardware (gated by XE_GT_WA)
- For affected hardware, the risk is also low: it adds delays before
  reset which is inherently safe

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
The `xe_guc_reset()` function was introduced with the xe driver in
commit dd08ebf6c3525a (Matthew Brost, 2023-03-30, "Introduce a new DRM
driver for Intel GPUs"). The function has been stable since, with minor
API changes (MMIO parameter refactoring by Matt Roper in
c18d4193b53be7).

**Step 3.2: Fixes tag**
No Fixes: tag present. The bug is inherent in the hardware itself, not
introduced by any specific software commit.

**Step 3.3: File History**
`xe_guc.c` has had 20 recent commits mostly around GuC
load/submit/communication. `xe_wa_oob.rules` has had 35 changes since
v6.12.

**Step 3.4: Author**
Sk Anirban has 4 xe-related commits including this one, with
d72779c29d82c ("drm/xe/ptl: Apply Wa_16026007364") also being a WA
patch. A regular Intel contributor focused on WA/frequency work.

**Step 3.5: Dependencies**
This is "PATCH v4 1/1" - a standalone single patch. No dependencies on
other patches. It uses existing infrastructure: XE_GT_WA macro,
xe_mmio_* functions, existing register headers.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1: Original Discussion**
Found on freedesktop.org/archives/intel-xe/2026-February/. The patch
went through 4 revisions (v1-v4) with extensive review from Daniele
Ceraolo Spurio and Badal Nilawar. Each version addressed reviewer
feedback.

**Step 4.2: Reviewers**
- Daniele Ceraolo Spurio: Intel GuC expert, provided detailed review
  across all 4 versions, gave final Reviewed-by
- Matt Roper: Subsystem maintainer, discussed the WA range policy, gave
  Acked-by and applied the patch
- Badal Nilawar: Intel engineer, reviewed and gave Reviewed-by

Daniele's only concern was about using large version ranges in the WA
table; Matt Roper acked this explicitly. No technical concerns about the
fix itself.

**Step 4.3: No external bug report found** - this is an internal Intel
hardware errata workaround.

**Step 4.4: Series Context**
Standalone patch (1/1). No dependencies.

**Step 4.5: No stable-specific discussion found.**

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions Modified**
- New: `guc_prevent_fw_dma_failure_on_reset()` (static, only called from
  xe_guc_reset)
- Modified: `xe_guc_reset()` (3-line addition)

**Step 5.2: Callers of xe_guc_reset**
- `uc_reset()` in xe_uc.c -> called from `xe_uc_sanitize_reset()`
- Called during GT reset paths and UC initialization

**Step 5.3-5.4: Call Chain**
xe_gt reset path -> xe_uc_sanitize_reset -> uc_reset -> xe_guc_reset.
This is the standard GPU reset path, triggered when the GPU needs reset
(hang recovery, device suspend/resume, driver load).

**Step 5.5: Similar Patterns**
The xe driver has many similar XE_GT_WA patterns throughout the codebase
(8 existing uses in xe_guc.c alone).

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy Code Existence**
The xe driver was introduced in v6.8. `xe_guc_reset()` exists in v6.8+.
The hardware affected (MEDIA_VERSION_RANGE 1301-3503,
GRAPHICS_VERSION_RANGE 2004-3005) includes Panther Lake and newer
platforms. Some of these platforms were only added in recent kernel
versions.

**Step 6.2: Backport Complications**
- For 7.0.y: Should apply cleanly. The tree is at v7.0, and the MMIO API
  and wa_oob.rules match.
- For 6.12.y: The MMIO API changed (`xe_mmio_write32(gt, ...)` vs
  `xe_mmio_write32(&gt->mmio, ...)`). Also, `xe_guc.c` has `struct
  xe_mmio *mmio` variable in v7.0 but not in v6.12. Significant rework
  needed.
- For 6.6.y and earlier: xe driver doesn't exist.

**Step 6.3: No related fixes already in stable.**

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: Subsystem Criticality**
drm/xe is the Intel GPU driver. It's IMPORTANT - affects all users with
Intel discrete and integrated GPUs running the xe driver.

**Step 7.2: Subsystem Activity**
Very active (20+ commits recently). The xe driver is under rapid
development.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**
Users with Intel GPUs matching MEDIA_VERSION_RANGE(1301, 3503) or
GRAPHICS_VERSION_RANGE(2004, 3005). This includes Panther Lake and some
newer Intel GPU generations.

**Step 8.2: Trigger Conditions**
The bug triggers during GuC-only reset when SRAM handler is actively
copying WOPCM to SRAM. This is a timing-dependent race that can occur
during any GPU reset operation (hang recovery, suspend/resume, etc.).

**Step 8.3: Failure Mode**
GuC HW gets stuck - this is effectively a GPU hang. Severity: HIGH.
Without recovery, the GPU becomes unusable requiring a reboot.

**Step 8.4: Risk-Benefit**
- BENEFIT: Prevents GPU hangs on affected Intel hardware during reset.
  HIGH benefit for affected hardware users.
- RISK: Very low. The fix is gated behind XE_GT_WA (only active on
  affected hardware), adds only MMIO reads and waits before existing
  reset sequence, and emits warnings rather than aborting on timeout.
  Risk: very low.
- Ratio: HIGH benefit / very low risk = favorable

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
- Hardware workaround (WA) - a standard exception category for stable
- Prevents GPU hangs (GuC stuck) during reset operations
- Well-reviewed: 3 Intel engineers (including subsystem maintainer)
  reviewed/acked
- Went through 4 revision cycles addressing reviewer feedback
- CI passed (Xe.CI.BAT: success)
- Standalone patch (1/1), no dependencies
- Well-contained: 49 lines across 3 files
- Gated behind hardware version check (no impact on unaffected hardware)
- Uses existing infrastructure (XE_GT_WA, xe_mmio_wait32)
- Should apply cleanly to v7.0.y

**Evidence AGAINST backporting:**
- Adds new register definitions and a new function (albeit small and
  contained)
- The WA uses version ranges that span many hardware generations
  (discussion concern from Daniele)
- For stable trees older than 7.0.y (e.g., 6.12.y), the MMIO API changed
  and significant rework would be needed
- Affects only specific newer Intel GPU hardware (Panther Lake and
  beyond)
- No user bug reports - this is a proactive hardware errata fix
- The xe driver is evolving rapidly, making older stable tree backports
  risky

**Stable Rules Checklist:**
1. Obviously correct and tested? YES - extensive review, CI tested,
   straightforward register reads/waits
2. Fixes a real bug? YES - GPU hang during reset
3. Important issue? YES - hardware hang requiring reboot
4. Small and contained? YES - 49 lines, 3 files, single subsystem
5. No new features or APIs? CORRECT - hardware workaround only
6. Can apply to stable? For 7.0.y: YES (clean). For 6.12.y: needs
   rework.

**Exception Category:** This is a hardware quirk/workaround - these are
explicitly allowed in stable.

## Verification

- [Phase 1] Parsed all tags: Reviewed-by (2), Acked-by (1), Link
  present, no Fixes, no Reported-by
- [Phase 2] Diff analysis: +49 lines across 3 files - new register defs,
  new WA function, WA rules entry
- [Phase 3] git blame: xe_guc_reset() introduced in dd08ebf6c3525a
  (March 2023, initial xe driver)
- [Phase 3] git log: no prerequisite commits needed, standalone patch
- [Phase 4] Freedesktop archive: Found [PATCH v4 0/1] and [PATCH v4 1/1]
  confirming single standalone patch
- [Phase 4] Freedesktop archive: Daniele's review comment on version
  ranges, Matt Roper's ack and policy discussion
- [Phase 4] Daniele gave final Reviewed-by after Matt acked the ranges
  approach
- [Phase 5] xe_guc_reset() called from uc_reset() in xe_uc.c, part of
  standard GT reset path
- [Phase 5] XE_GT_WA macro used 8 times in xe_guc.c already -
  established pattern
- [Phase 6] xe driver exists in v6.8+, not in v6.6. MMIO API changed
  between v6.12 and v7.0
- [Phase 6] For v7.0.y: patch should apply cleanly (tree matches patch
  base)
- [Phase 6] For v6.12.y: MMIO API mismatch would require rework
- [Phase 8] Failure mode: GuC stuck = GPU hang = severity HIGH
- UNVERIFIED: Cannot confirm which exact kernel versions first support
  the specific GPU generations targeted by MEDIA_VERSION_RANGE(1301,
  3503) and GRAPHICS_VERSION_RANGE(2004, 3005)

This is a well-reviewed, well-contained hardware workaround that
prevents GPU hangs during reset on affected Intel hardware. It falls
squarely into the "hardware quirk/workaround" exception category for
stable kernels. The fix is gated behind hardware detection, uses
existing infrastructure, and was authored as a standalone patch with no
dependencies. It should apply cleanly to the 7.0 stable tree.

**YES**

 drivers/gpu/drm/xe/regs/xe_guc_regs.h |  8 ++++++
 drivers/gpu/drm/xe/xe_guc.c           | 38 +++++++++++++++++++++++++++
 drivers/gpu/drm/xe/xe_wa_oob.rules    |  3 +++
 3 files changed, 49 insertions(+)

diff --git a/drivers/gpu/drm/xe/regs/xe_guc_regs.h b/drivers/gpu/drm/xe/regs/xe_guc_regs.h
index 87984713dd126..5faac8316b66c 100644
--- a/drivers/gpu/drm/xe/regs/xe_guc_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_guc_regs.h
@@ -40,6 +40,9 @@
 #define   GS_BOOTROM_JUMP_PASSED		REG_FIELD_PREP(GS_BOOTROM_MASK, 0x76)
 #define   GS_MIA_IN_RESET			REG_BIT(0)
 
+#define BOOT_HASH_CHK				XE_REG(0xc010)
+#define   GUC_BOOT_UKERNEL_VALID		REG_BIT(31)
+
 #define GUC_HEADER_INFO				XE_REG(0xc014)
 
 #define GUC_WOPCM_SIZE				XE_REG(0xc050)
@@ -83,7 +86,12 @@
 #define   GUC_WOPCM_OFFSET_MASK			REG_GENMASK(31, GUC_WOPCM_OFFSET_SHIFT)
 #define   HUC_LOADING_AGENT_GUC			REG_BIT(1)
 #define   GUC_WOPCM_OFFSET_VALID		REG_BIT(0)
+
+#define GUC_SRAM_STATUS				XE_REG(0xc398)
+#define   GUC_SRAM_HANDLING_MASK		REG_GENMASK(8, 7)
+
 #define GUC_MAX_IDLE_COUNT			XE_REG(0xc3e4)
+#define   GUC_IDLE_FLOW_DISABLE			REG_BIT(31)
 #define GUC_PMTIMESTAMP_LO			XE_REG(0xc3e8)
 #define GUC_PMTIMESTAMP_HI			XE_REG(0xc3ec)
 
diff --git a/drivers/gpu/drm/xe/xe_guc.c b/drivers/gpu/drm/xe/xe_guc.c
index 4ab65cae87433..96c28014f3887 100644
--- a/drivers/gpu/drm/xe/xe_guc.c
+++ b/drivers/gpu/drm/xe/xe_guc.c
@@ -900,6 +900,41 @@ int xe_guc_post_load_init(struct xe_guc *guc)
 	return xe_guc_submit_enable(guc);
 }
 
+/*
+ * Wa_14025883347: Prevent GuC firmware DMA failures during GuC-only reset by ensuring
+ * SRAM save/restore operations are complete before reset.
+ */
+static void guc_prevent_fw_dma_failure_on_reset(struct xe_guc *guc)
+{
+	struct xe_gt *gt = guc_to_gt(guc);
+	u32 boot_hash_chk, guc_status, sram_status;
+	int ret;
+
+	guc_status = xe_mmio_read32(&gt->mmio, GUC_STATUS);
+	if (guc_status & GS_MIA_IN_RESET)
+		return;
+
+	boot_hash_chk = xe_mmio_read32(&gt->mmio, BOOT_HASH_CHK);
+	if (!(boot_hash_chk & GUC_BOOT_UKERNEL_VALID))
+		return;
+
+	/* Disable idle flow during reset (GuC reset re-enables it automatically) */
+	xe_mmio_rmw32(&gt->mmio, GUC_MAX_IDLE_COUNT, 0, GUC_IDLE_FLOW_DISABLE);
+
+	ret = xe_mmio_wait32(&gt->mmio, GUC_STATUS, GS_UKERNEL_MASK,
+			     FIELD_PREP(GS_UKERNEL_MASK, XE_GUC_LOAD_STATUS_READY),
+			     100000, &guc_status, false);
+	if (ret)
+		xe_gt_warn(gt, "GuC not ready after disabling idle flow (GUC_STATUS: 0x%x)\n",
+			   guc_status);
+
+	ret = xe_mmio_wait32(&gt->mmio, GUC_SRAM_STATUS, GUC_SRAM_HANDLING_MASK,
+			     0, 5000, &sram_status, false);
+	if (ret)
+		xe_gt_warn(gt, "SRAM handling not complete (GUC_SRAM_STATUS: 0x%x)\n",
+			   sram_status);
+}
+
 int xe_guc_reset(struct xe_guc *guc)
 {
 	struct xe_gt *gt = guc_to_gt(guc);
@@ -912,6 +947,9 @@ int xe_guc_reset(struct xe_guc *guc)
 	if (IS_SRIOV_VF(gt_to_xe(gt)))
 		return xe_gt_sriov_vf_bootstrap(gt);
 
+	if (XE_GT_WA(gt, 14025883347))
+		guc_prevent_fw_dma_failure_on_reset(guc);
+
 	xe_mmio_write32(mmio, GDRST, GRDOM_GUC);
 
 	ret = xe_mmio_wait32(mmio, GDRST, GRDOM_GUC, 0, 5000, &gdrst, false);
diff --git a/drivers/gpu/drm/xe/xe_wa_oob.rules b/drivers/gpu/drm/xe/xe_wa_oob.rules
index 5cd7fa6d2a5c0..ac08f94f90a14 100644
--- a/drivers/gpu/drm/xe/xe_wa_oob.rules
+++ b/drivers/gpu/drm/xe/xe_wa_oob.rules
@@ -73,3 +73,6 @@
 15015404425_disable	PLATFORM(PANTHERLAKE), MEDIA_STEP(B0, FOREVER)
 16026007364    MEDIA_VERSION(3000)
 14020316580    MEDIA_VERSION(1301)
+
+14025883347	MEDIA_VERSION_RANGE(1301, 3503)
+		GRAPHICS_VERSION_RANGE(2004, 3005)
-- 
2.53.0

