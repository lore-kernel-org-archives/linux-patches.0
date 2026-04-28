Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C797C407583;
	Tue, 28 Apr 2026 10:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372968; cv=none; b=uzsY6I86m19XNxjNrRI0oJTCwH3tCPzGUsBLsdX5YRcbGSm6fwmbgPUTwglJPcI8iWw8eYYaCa5aAG0s/gfA38rA0w4nznQ72TsciSjL+ieP5iSfMQ0iGngqSwbpYmZlx+cdRMIYLurs0ELnAhXlPaqjUS/aS5od9dfauhDe4B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372968; c=relaxed/simple;
	bh=ftFBoeUNo9XvxtsYcnDiXdJCUTvZ3/oDkUO0Odx4Rr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LlDDxXVDyLkZjWFehjJL941xozHIfraxJSXbv02akA0PKDqUvL9T4fEIQR4ItQ6zuYYWcU6Idtq8OmaUN9Mk+1vP1+L89REc8vsl1BCBck7E7rwgT3VOka2JhT9ImpuAciFixXWRsZkc6iSUvBGXaH2eaVsuHcL0BvKt45ZRhGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t6TdL7Xe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t6TdL7Xe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C818C2BCAF;
	Tue, 28 Apr 2026 10:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372968;
	bh=ftFBoeUNo9XvxtsYcnDiXdJCUTvZ3/oDkUO0Odx4Rr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t6TdL7XeQ0c6Jskuz/zrPlQc3z/Msb1czQ8OiQQ307k3m4ZkE0/yDiLxgxtJW4ztp
	 S10L8fcKzTqBZ+Atpo+jSlo4YaSJoR5AZYHMTOgDrJlxIn3IrkGaZIr7V03cWto6hJ
	 fjE90uLPbCp2MuZk7q1XC0JuNuSj9oSCGJQizxi6OVRN0WGXB0Noa45KyWX7vWY9No
	 a/90s17kxx2JhlVtUZv2y642dpqfp+OLV+5RFMWLA9lObvcMR3J2VwxHgKYK44fKLI
	 VZdkIDgX/s3drxIQObDxpveqD7xFXYvcwld/QKr7OK7bKnjTyggDDJoWEQXRnmSO4Y
	 VzU1OVgpmbKvw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Austin Zheng <austin.zheng@amd.com>,
	Roman Li <roman.li@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	harry.wentland@amd.com,
	sunpeng.li@amd.com,
	Rodrigo.Siqueira@amd.com,
	christian.koenig@amd.com,
	Xinhui.Pan@amd.com,
	airlied@gmail.com,
	daniel@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] drm/amd/display: Fix HostVMMinPageSize unit mismatch in DML2.1
Date: Tue, 28 Apr 2026 06:41:03 -0400
Message-ID: <20260428104133.2858589-52-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Transfer-Encoding: 8bit

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 5721b5b9c9c792233d7817239bd81925fb3ad9d1 ]

[Why]
This was found back on DML2 but was missed when creating DML2.1.

The bottom layer calculation (CalculateHostVMDynamicLevels) expects
a value in bytes, not KB, but we pass in the value in KB (eg. 4).

This causes an extra page table level to be required in the prefetch
bytes which can be significant overhead - preventing some modes
from being supported that should otherwise be.

[How]
Correct the units by multiplying the input and override values by 1024.

Reviewed-by: Austin Zheng <austin.zheng@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my comprehensive analysis, I have enough information to make a
decision. Let me compile my findings.

## Phase 1: Commit Message Forensics

**Step 1.1:** Subject parsing
Record: [drm/amd/display] [Fix] [HostVMMinPageSize unit mismatch in
DML2.1]

**Step 1.2:** Tags
Record:
- Reviewed-by: Austin Zheng (AMD)
- Signed-off-by: Nicholas Kazlauskas (author, AMD), Roman Li (AMD DC
  submaintainer), Alex Deucher (AMD GPU maintainer)
- Tested-by: Dan Wheeler (AMD test engineer)
- No Fixes: tag, no Cc: stable tag (expected for review candidates)

**Step 1.3:** Body analysis
Record: The bug is that `CalculateHostVMDynamicLevels` expects
HostVMMinPageSize in bytes (thresholds 2048 and 1048576 = 2KB and 1MB),
but DML2.1 passes the value in KB (e.g., 4 for 4KB). This causes wrong
branch selection and adds an extra page table level to prefetch
overhead, "preventing some modes from being supported that should
otherwise be." Failure mode = display mode unnecessarily rejected by
validator.

**Step 1.4:** Hidden bug fix detection
Record: Not hidden - clearly described as a fix for a unit mismatch. The
verb "Fix" is explicit.

## Phase 2: Diff Analysis

**Step 2.1:** Inventory
Record: Single file `dml2_core_dcn4_calcs.c`, 6 lines changed (+6/-6), 6
hunks. All in `dml_core_ms_prefetch_check`, `dml_core_mode_support`,
`dml_core_mode_programming`. Scope: surgical single-file fix.

**Step 2.2:** Code flow
Record: Each hunk replaces `hostvm_min_page_size_kbytes` (a value in KB)
with `hostvm_min_page_size_kbytes * 1024` (converting to bytes). Affects
calls to `CalculateExtraLatency`,
`CalculatePrefetchSchedule_params->HostVMMinPageSize`, and
`CalculateVMRowAndSwath_params->HostVMMinPageSize`.

**Step 2.3:** Bug mechanism
Record: Type/unit bug. The receiving function checks `< 2048`, `>= 2048
&& < 1048576`, `>= 1048576` (bytes thresholds). With KB input (e.g., 4),
every value falls into the first branch, causing maximum page table
levels to be added incorrectly, which inflates prefetch bandwidth
requirements.

**Step 2.4:** Fix quality
Record: Trivially correct - just multiplying by a constant. No
regression risk from the fix itself. Same fix pattern was historically
applied to DML2.0 (commit 22136ff27c4e0/dcf6cd7f35de5) with `Cc:
stable`.

## Phase 3: Git History Investigation

**Step 3.1:** File history
Record: File introduced in commit `70839da636050` (2024-04-19, v6.11)
"drm/amd/display: Add new DCN401 sources". Bug present since v6.11.

**Step 3.2:** Fixes: tag follow-up
Record: No Fixes: tag, but commit message references DML2 history. Found
related history:
- `22136ff27c4e0`/`dcf6cd7f35de5` (Nov 2023): Original DML2 fix with Cc:
  stable - did exactly this multiplication
- `d0f639c586939`/`a409c053b0b0c` (Dec 2023): Reverted, claimed spec
  said KB
- `bf282eb92b8` (Dec 2023): Re-applied the *1024 fix because revert
  "causes failure to light up for 1080p eDP + 8k HDMI panel combo"
This proves the *1024 IS the correct value.

**Step 3.3:** File history for related changes
Record: Related patches in same April 2 patch series include:
- Patch 13: `df9228624afde` "Pass min page size from SOC BB to dml2_1
  plane config" - related fix but independent
- Patch 14: `90b05672b7f0e` "Fix DCN42 gpuvm_min_page_size_kbytes in SOC
  BB" - related but independent
This patch (11) is self-contained.

**Step 3.4:** Author context
Record: Nicholas Kazlauskas is a regular DC contributor and authored the
related DCN35/DCN401 fixes. Reviewer Austin Zheng is also DC
contributor. Submitter Roman Li is DC submaintainer.

**Step 3.5:** Dependencies
Record: Standalone fix. Multiplication by 1024 is purely a numeric
correction at call sites. No dependencies.

## Phase 4: Mailing List Research

**Step 4.1:** b4 dig
Record: b4 dig could not find a match (commit too recent / not yet
indexed). Found via direct lore search at
`https://lists.freedesktop.org/archives/amd-gfx/2026-April/142246.html`.
Posted as PATCH 11/22 of "DC Patches April 02, 2026" by Roman Li on Thu
Apr 2 18:33:03 UTC 2026.

**Step 4.2:** Reviewers
Record: Reviewed by Austin Zheng (AMD DC). Sent to amd-gfx list with
appropriate maintainer CC.

**Step 4.3:** Bug reports
Record: No specific Reported-by, no syzbot link, no bugzilla link. Bug
found internally by AMD when reviewing DML2.1 vs DML2 differences.

**Step 4.4:** Series context
Record: Part of "DC Patches April 02, 2026" with 22 patches. The
Nicholas Kazlauskas DML2.1 cluster (patches 11-15) addresses related but
independent issues. This patch (11) does not depend on the others.

**Step 4.5:** Stable history
Record: No discussion on stable@vger.kernel.org. Original DML2 fix was
Cc'd to stable; this DML2.1 version was not.

## Phase 5: Code Semantic Analysis

**Step 5.1:** Functions modified
Record: 3 functions: `dml_core_ms_prefetch_check`,
`dml_core_mode_support`, `dml_core_mode_programming`. All are core mode
validation/programming entry points called from DML2.1.

**Step 5.2:** Callers
Record: Called from `dml21_create`/`dml21_reinit`, which are called when
`using_dml21=true && dce_version >= DCN_VERSION_4_01`. This means:
DCN401 (RDNA4 / RX 9000 series GPUs) and DCN42 hardware. Reachable from
every display mode validation.

**Step 5.3:** Callees
Record: `CalculateExtraLatency` and via params,
`CalculateHostVMDynamicLevels` (line 1565) which has the byte-threshold
checks (`< 2048`, `< 1048576`).

**Step 5.4:** Reachability
Record: Every kernel modeset path on DCN401/DCN42 hardware. Highly
reachable from userspace via DRM modeset ioctls.

**Step 5.5:** Similar patterns
Record: Same fix pattern was previously applied to DML2.0 in current
mainline (`drivers/gpu/drm/amd/display/dc/dml2_0/display_mode_core.c`
has `* 1024` at the same kind of call sites).

## Phase 6: Cross-Referencing

**Step 6.1:** Code in stable trees
Record: Buggy code present in v6.11 through v6.18 (and v7.0). Verified
with `git show v6.18:drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_
core/dml2_core_dcn4_calcs.c | grep "soc.hostvm_min_page_size_kbytes,"` -
bug exists.

**Step 6.2:** Backport complications
Record: Path was renamed from `dml2/dml21/` to `dml2_0/dml21/` in commit
`e6a8a000cfe6a` (2025-10-21). For stable trees v6.11-v6.18, the file is
at `drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dc
n4_calcs.c`. Each `* 1024` change applies cleanly with path translation
- line numbers vary by tree but contexts are stable. Minor manual rework
needed for path.

**Step 6.3:** Related fixes already in stable
Record: No, the DML2.1 version of this fix has not been backported to
any stable tree.

## Phase 7: Subsystem Context

**Step 7.1:** Subsystem criticality
Record: drivers/gpu/drm/amd/display - PERIPHERAL (driver-specific) but
affects display output, which is user-visible. Users of DCN401 (Navi 4x
discrete GPUs) and DCN42 (newer APUs) can lose display mode
availability.

**Step 7.2:** Subsystem activity
Record: Highly active subsystem with frequent DC patch series.

## Phase 8: Impact and Risk

**Step 8.1:** Affected population
Record: DRIVER-SPECIFIC: Users with AMD DCN401 (RX 9070, RX 9060XT etc.)
or DCN42 hardware running v6.11+. As DCN401 is the Navi 4x architecture
(recent consumer GPU), this is a meaningful but smaller user base than
core fixes.

**Step 8.2:** Trigger conditions
Record: Triggered on every display mode validation when
`using_dml21=true` (default). Bug manifests as "mode rejected" only when
the actual page table level overhead matters, i.e., for high-bandwidth
modes (high resolution + high refresh rate, multi-display). The DML2
history shows real-world failure with "1080p eDP + 8k HDMI" combo.

**Step 8.3:** Failure mode severity
Record: MEDIUM-HIGH. Failure mode is display modes being rejected that
should work. Not a crash or data corruption, but user-visible feature
loss (e.g., user cannot enable their monitor's native resolution/refresh
rate). On laptops with eDP + external display, may prevent multi-monitor
configurations.

**Step 8.4:** Risk-benefit
Record:
- BENEFIT: enables previously-rejected display modes for DCN401/DCN42
  users (real-world impact demonstrated in DML2 history)
- RISK: very low - 6 lines of arithmetic correction, well-tested in
  mainline, identical pattern proven correct in DML2.0
- Ratio: clearly favors backport

## Phase 9: Final Synthesis

**Step 9.1:** Evidence
FOR backporting:
- Small, surgical, obviously correct fix (just `* 1024`)
- Bug present in stable trees v6.11+
- Same fix pattern proven correct via DML2.0 history (revert/re-apply
  cycle confirmed `*1024` is right)
- Tested-by, Reviewed-by from AMD team
- Real user-visible impact demonstrated historically (modes failing to
  light up)
- Bug already in mainline since April 2026
- Fix is mathematical - no behavioral risk

AGAINST:
- No Cc: stable tag from authors
- Smaller user base (DCN401/DCN42 specific hardware)
- Path requires translation for older stable trees (`dml2_0/dml21/` ->
  `dml2/dml21/`)
- The DML2 version of this fix had a turbulent revert history (though
  ultimately confirmed correct)

UNRESOLVED:
- Could not run b4 dig successfully (patch too recent for indexing)
- Could not verify whether AMD will explicitly nominate this for stable
  in a follow-up

**Step 9.2:** Stable rules checklist
1. Obviously correct? YES - simple multiplication, function clearly
   expects bytes (thresholds in bytes)
2. Fixes real bug affecting users? YES - mode validation incorrectly
   rejects valid modes
3. Important issue? MEDIUM - prevents some display modes from working,
   similar pattern caused 1080p+8k failure in DML2
4. Small and contained? YES - 6 lines, single file
5. No new features/APIs? YES - pure fix
6. Applies to stable? YES with minor path translation for v6.11-v6.18

**Step 9.3:** Exception categories
Not in special exception categories, but qualifies as a regular bug fix.

**Step 9.4:** Decision
The fix is small, surgical, obviously correct, well-tested, and
addresses a real bug that affects users of recent AMD GPU/APU hardware.
The historical precedent in DML2.0 (where the same `*1024` correction
was eventually applied to stable after extensive testing confirmed it
was right) strengthens confidence. The risk of regression is minimal
given the trivial nature of the change.

## Verification

- [Phase 1] Parsed tags: Reviewed-by (Austin Zheng), Tested-by (Dan
  Wheeler), no Fixes/Cc:stable - verified by reading commit message
- [Phase 2] Diff analysis: confirmed 6 hunks, all `* 1024` multiplier
  additions in single file - verified by reading patch
- [Phase 3] git log + git show: bug code present since `70839da636050`
  (v6.11, 2024-04-19) - verified
- [Phase 3] git show 22136ff27c4e0: original DML2 fix with `Cc:
  stable@vger.kernel.org` did same `*1024` change - verified
- [Phase 3] git show bf282eb92b8: revert-of-revert for DML2 because
  *1024 absence broke "1080p eDP + 8k HDMI" - verified
- [Phase 3] git show e6a8a000cfe6a: path renamed `dml2/dml21/` ->
  `dml2_0/dml21/` in 2025-10-21 - verified
- [Phase 3] Local file read at line 1565: `CalculateHostVMDynamicLevels`
  checks `< 2048`, `< 1048576` (bytes thresholds) - verified
- [Phase 4] WebFetch lore archive: found patch 11/22 of "DC Patches
  April 02, 2026" thread - verified
- [Phase 4] b4 dig -c bd8001acfa62b: failed to find (patch too recent) -
  acknowledged
- [Phase 5] Grep for using_dml21: confirmed DML2.1 active for
  DCN401/DCN42 with `dce_version >= DCN_VERSION_4_01` - verified
- [Phase 6] git show
  v6.18:.../dml2/dml21/src/.../dml2_core_dcn4_calcs.c: bug present in
  v6.18 - verified
- [Phase 6] git show
  v6.12:.../dml2/dml21/src/.../dml2_core_dcn4_calcs.c: bug present in
  v6.12 - verified
- [Phase 6] dml2_0/display_mode_core.c grep: confirmed `*1024` already
  applied for DML2.0 - verified
- [Phase 7] DCN_VERSION_4_01 grep: confirmed dce_version usage gates
  DML2.1 to DCN401+ hardware - verified
- UNVERIFIED: Exact mailing list discussion URL - the patch is indexed
  at lists.freedesktop.org (got the patch text), but lore.kernel.org has
  not yet indexed it (b4 dig failure)
- UNVERIFIED: Whether reviewers explicitly suggested stable backport -
  did not find direct discussion

The fix meets all stable kernel criteria: it is obviously correct, fixes
a real bug affecting users of recent AMD hardware, is small and
contained (6 lines, one file), introduces no new features, and applies
to stable with only minor path translation. The historical DML2
precedent strongly supports correctness and the user-visible impact.

**YES**

 .../dml21/src/dml2_core/dml2_core_dcn4_calcs.c       | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2_0/dml21/src/dml2_core/dml2_core_dcn4_calcs.c b/drivers/gpu/drm/amd/display/dc/dml2_0/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
index ca5ac3c0deb56..cdd7c771afff9 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2_0/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2_0/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
@@ -7381,7 +7381,7 @@ static noinline_for_stack void dml_core_ms_prefetch_check(struct dml2_core_inter
 		s->tdlut_bytes_per_group,
 		s->HostVMInefficiencyFactor,
 		s->HostVMInefficiencyFactorPrefetch,
-		mode_lib->soc.hostvm_min_page_size_kbytes,
+		mode_lib->soc.hostvm_min_page_size_kbytes * 1024,
 		mode_lib->soc.qos_parameters.qos_type,
 		!(display_cfg->overrides.max_outstanding_when_urgent_expected_disable),
 		mode_lib->soc.max_outstanding_reqs,
@@ -7477,7 +7477,7 @@ static noinline_for_stack void dml_core_ms_prefetch_check(struct dml2_core_inter
 			CalculatePrefetchSchedule_params->OutputFormat = display_cfg->stream_descriptors[display_cfg->plane_descriptors[k].stream_index].output.output_format;
 			CalculatePrefetchSchedule_params->MaxInterDCNTileRepeaters = mode_lib->ip.max_inter_dcn_tile_repeaters;
 			CalculatePrefetchSchedule_params->VStartup = s->MaximumVStartup[k];
-			CalculatePrefetchSchedule_params->HostVMMinPageSize = mode_lib->soc.hostvm_min_page_size_kbytes;
+			CalculatePrefetchSchedule_params->HostVMMinPageSize = mode_lib->soc.hostvm_min_page_size_kbytes * 1024;
 			CalculatePrefetchSchedule_params->DynamicMetadataEnable = display_cfg->plane_descriptors[k].dynamic_meta_data.enable;
 			CalculatePrefetchSchedule_params->DynamicMetadataVMEnabled = mode_lib->ip.dynamic_metadata_vm_enabled;
 			CalculatePrefetchSchedule_params->DynamicMetadataLinesBeforeActiveRequired = display_cfg->plane_descriptors[k].dynamic_meta_data.lines_before_active_required;
@@ -8965,7 +8965,7 @@ static bool dml_core_mode_support(struct dml2_core_calcs_mode_support_ex *in_out
 	CalculateVMRowAndSwath_params->MALLAllocatedForDCN = mode_lib->soc.mall_allocated_for_dcn_mbytes;
 	CalculateVMRowAndSwath_params->SwathWidthY = mode_lib->ms.SwathWidthY;
 	CalculateVMRowAndSwath_params->SwathWidthC = mode_lib->ms.SwathWidthC;
-	CalculateVMRowAndSwath_params->HostVMMinPageSize = mode_lib->soc.hostvm_min_page_size_kbytes;
+	CalculateVMRowAndSwath_params->HostVMMinPageSize = mode_lib->soc.hostvm_min_page_size_kbytes * 1024;
 	CalculateVMRowAndSwath_params->DCCMetaBufferSizeBytes = mode_lib->ip.dcc_meta_buffer_size_bytes;
 	CalculateVMRowAndSwath_params->mrq_present = mode_lib->ip.dcn_mrq_present;
 
@@ -10755,7 +10755,7 @@ static bool dml_core_mode_programming(struct dml2_core_calcs_mode_programming_ex
 	CalculateVMRowAndSwath_params->MALLAllocatedForDCN = mode_lib->soc.mall_allocated_for_dcn_mbytes;
 	CalculateVMRowAndSwath_params->SwathWidthY = mode_lib->mp.SwathWidthY;
 	CalculateVMRowAndSwath_params->SwathWidthC = mode_lib->mp.SwathWidthC;
-	CalculateVMRowAndSwath_params->HostVMMinPageSize = mode_lib->soc.hostvm_min_page_size_kbytes;
+	CalculateVMRowAndSwath_params->HostVMMinPageSize = mode_lib->soc.hostvm_min_page_size_kbytes * 1024;
 	CalculateVMRowAndSwath_params->DCCMetaBufferSizeBytes = mode_lib->ip.dcc_meta_buffer_size_bytes;
 	CalculateVMRowAndSwath_params->mrq_present = mode_lib->ip.dcn_mrq_present;
 
@@ -10971,7 +10971,7 @@ static bool dml_core_mode_programming(struct dml2_core_calcs_mode_programming_ex
 		s->tdlut_bytes_per_group,
 		s->HostVMInefficiencyFactor,
 		s->HostVMInefficiencyFactorPrefetch,
-		mode_lib->soc.hostvm_min_page_size_kbytes,
+		mode_lib->soc.hostvm_min_page_size_kbytes * 1024,
 		mode_lib->soc.qos_parameters.qos_type,
 		!(display_cfg->overrides.max_outstanding_when_urgent_expected_disable),
 		mode_lib->soc.max_outstanding_reqs,
@@ -11264,7 +11264,7 @@ static bool dml_core_mode_programming(struct dml2_core_calcs_mode_programming_ex
 			CalculatePrefetchSchedule_params->OutputFormat = display_cfg->stream_descriptors[display_cfg->plane_descriptors[k].stream_index].output.output_format;
 			CalculatePrefetchSchedule_params->MaxInterDCNTileRepeaters = mode_lib->ip.max_inter_dcn_tile_repeaters;
 			CalculatePrefetchSchedule_params->VStartup = s->MaxVStartupLines[k];
-			CalculatePrefetchSchedule_params->HostVMMinPageSize = mode_lib->soc.hostvm_min_page_size_kbytes;
+			CalculatePrefetchSchedule_params->HostVMMinPageSize = mode_lib->soc.hostvm_min_page_size_kbytes * 1024;
 			CalculatePrefetchSchedule_params->DynamicMetadataEnable = display_cfg->plane_descriptors[k].dynamic_meta_data.enable;
 			CalculatePrefetchSchedule_params->DynamicMetadataVMEnabled = mode_lib->ip.dynamic_metadata_vm_enabled;
 			CalculatePrefetchSchedule_params->DynamicMetadataLinesBeforeActiveRequired = display_cfg->plane_descriptors[k].dynamic_meta_data.lines_before_active_required;
-- 
2.53.0

