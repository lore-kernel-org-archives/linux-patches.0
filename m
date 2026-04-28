Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCA43F20E5;
	Tue, 28 Apr 2026 10:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372913; cv=none; b=hO7DVIoGZ4utevhqnUQMwo7nJZh1vEQLNGZDffNqvO1LfhwzA1jfLSfI08F0psT1Q3KT2ZBvJqHjmxNcD8HKhFAGI9mIkdagvbAk3uiR45MrKdoeCp6Hu/wQebt8DJtHGUkqxM6u2yP6vVYJ6lKFSl8cK6J22p8JwzwYs9QilGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372913; c=relaxed/simple;
	bh=/vq2AcbHo4qV4YUOeFckuoWszLHfZN6gWj0tMUvaB20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rgMZWtAzWDxqsZr4FTVMyTPKANibSdtITpTmJeDLsAPRsDu8jG33Ep5TKIdOouFKapCMuojopYGcXu/VzTuDghznUv48ECvcuTptz6f2DwD7VpH5l+UtPrbOMRRRrRXdDiQudhxWZJImhJMSYS8dteJ6FHGkNt6Lmpla9PKkLHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pNwmNjFi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pNwmNjFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D63C2BCB6;
	Tue, 28 Apr 2026 10:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372913;
	bh=/vq2AcbHo4qV4YUOeFckuoWszLHfZN6gWj0tMUvaB20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pNwmNjFiDkPymI8sU4K1a/5JtrHAUXix4AwiABeW929S3a8w3wxgAkX31ZlLA3BX6
	 JIDRtSCQTmxbGCdJjXM7oA+NncSajqMwCJ6UFBldiKHNOIS2dcVUQejG/G0pb2kgql
	 p2dj2AKS1uFFbKwOUH7ZX6P3OSB7gTndzIPVSak9yrRkj6XHtoDdsnLTQ6rIWRwakH
	 jB021vlWoGEmJYReBkrwrVmypp+O6Sy8oMjFK+gNIgDeVunzjz/bAEVlAOcnR11wp1
	 f+gS2WhAd0oOCigaaiZIChWSm6Jt3473ea7BsXKbb+Et5qsUImlf5NLWNWj1uVNixu
	 idXIK5HQyujqw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
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
Subject: [PATCH AUTOSEL 7.0-6.18] drm/amd/display: Pass min page size from SOC BB to dml2_1 plane config
Date: Tue, 28 Apr 2026 06:40:25 -0400
Message-ID: <20260428104133.2858589-14-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 07ac59230d5fd603d56af2363dae80d3e973e4bc ]

[Why]
Like dml2_0 this isn't guaranteed to be constant for every ASIC.

This can cause corruption or underflow for linear surfaces due to a
wrong PTE_ROW_HEIGHT_LINEAR value if not correctly specified.

[How]
Like dml2_0 pass in the SOC bb into the plane configuration population
functions.

Set both GPUVM and HostVM page sizes in the overrides.

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my forensic investigation, here is my detailed analysis:

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem prefix: `drm/amd/display:`
- Action verb: "Pass" (descriptive of the fix; effectively a bug fix)
- Record: drm/amd/display, action verb "Pass" (corrective), summary:
  ensures DML2.1 plane configuration uses SOC bounding box values for
  min page size instead of hardcoded 256

**Step 1.2: Commit Message Tags**
- Reviewed-by: Dillon Varone <dillon.varone@amd.com>
- Signed-off-by: Nicholas Kazlauskas (author, AMD)
- Signed-off-by: Roman Li (AMD display submaintainer)
- Tested-by: Dan Wheeler <daniel.wheeler@amd.com> (AMD QA tester)
- Signed-off-by: Alex Deucher (AMD GPU maintainer)
- No Fixes:/Cc:stable tags (expected per instructions)
- Record: Strong AMD internal review chain - reviewed, tested by AMD QA,
  signed by maintainers

**Step 1.3: Commit Body Analysis**
- Bug: `gpuvm_min_page_size_kbytes` is hardcoded to 256, but SOC-
  provided values can differ per ASIC
- Symptom: "corruption or underflow for linear surfaces due to a wrong
  PTE_ROW_HEIGHT_LINEAR value if not correctly specified"
- Mechanism: Wrong page size causes wrong PTE row height, which causes
  incorrect PTE prefetching
- Author understands root cause and explicitly notes this mirrors the
  dml2_0 fix
- Record: Hardware corruption/underflow on linear surfaces; explicit
  reference to prior dml2_0 fix

**Step 1.4: Hidden Bug Fix Detection**
- "Pass min page size from SOC BB" is corrective phrasing
- Commit explicitly says "can cause corruption or underflow"
- Record: This IS a bug fix despite verb-only-language ("Pass")

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 1 file: `drivers/gpu/drm/amd/display/dc/dml2_0/dml21/dml21_translation
  _helper.c`
- 15 insertions, 6 deletions
- 3 functions modified: `populate_dml21_dummy_plane_cfg`,
  `populate_dml21_plane_config_from_plane_state`,
  `dml21_map_dc_state_into_dml_display_cfg`
- Record: Single-file surgical fix, very small scope

**Step 2.2: Code Flow Change**
- BEFORE: `plane->overrides.gpuvm_min_page_size_kbytes = 256;`
  (hardcoded)
- AFTER: `plane->overrides.gpuvm_min_page_size_kbytes =
  soc_bb->gpuvm_min_page_size_kbytes;` (from SOC bb)
- Also adds: `plane->overrides.hostvm_min_page_size_kbytes =
  soc_bb->hostvm_min_page_size_kbytes;`
- Function signatures extended to accept `struct dml2_soc_bb *soc_bb`
  parameter
- Caller updated to pass `&dml_ctx->v21.dml_init.soc_bb`
- Record: Replaces hardcoded values with SOC-provided values; added
  missing hostvm setting

**Step 2.3: Bug Mechanism**
- Category: Logic/correctness fix (hardware programming)
- Root cause: hardcoded constant where ASIC-specific value should be
  used
- Specific impact: Wrong gpuvm_min_page_size affects
  PTE_ROW_HEIGHT_LINEAR HW register programming on DCN401 hardware
- Record: Hardware programming correctness bug; can cause display
  corruption

**Step 2.4: Fix Quality**
- Obviously correct: just propagates existing SOC bb values
- Minimal/surgical: 21-line diff, no unrelated changes
- Regression risk: very low - just replaces hardcoded values with
  structured access; for DCN401 default SOC bb, values are identical
  (256/0)
- Record: High quality, low-risk fix

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
- Hardcoded `= 256` lines have been present since the dml21 directory
  was first added
- The dml21 file itself was renamed from `dml2/dml21/` to
  `dml2_0/dml21/` in commit `e6a8a000cfe6a` (v6.19)
- Original creation: commit `70839da636050` ("Add new DCN401 sources")
  from April 2024, first appeared in v6.11
- Record: Buggy code present since v6.11

**Step 3.2: Fixes: Tag**
- No Fixes: tag, but the commit explicitly references "Like dml2_0"
  referring to commit `31663521ede2e` ("Use gpuvm_min_page_size_kbytes
  for DML2 surfaces", July 2024)
- The dml2_0 fix WAS selected for stable trees: backported to 6.10.y
  (54877301a7551), 6.11.y (291c87fd3abe1), 6.12.y, 6.18.y, 6.19.y
- Record: Direct precedent for backporting this class of fix

**Step 3.3: Related Recent Changes**
- Adjacent commit `5721b5b9c9c79` (Mar 24, 2026): "Fix HostVMMinPageSize
  unit mismatch in DML2.1" - related but independent (fixes core
  calculation, not override population)
- Adjacent commit `5a89553231833` (Mar 24, 2026): DCN42 SOC bb
  correction
- Record: Part of a series of DML2.1 hardening fixes; this commit is
  self-contained

**Step 3.4: Author Context**
- Nicholas Kazlauskas: AMD display engineer, primary author of DML logic
- Roman Li: AMD display maintainer
- Alex Deucher: AMD GPU subsystem maintainer
- Record: Author has full subsystem authority

**Step 3.5: Dependencies**
- The override field `hostvm_min_page_size_kbytes` was added to the
  `plane->overrides` struct in commit `76468055069ce` ("DML21
  Reintegration"), first appearing in v6.16
- For stable trees < 6.16, the hostvm field doesn't exist in the
  override struct → backport adjustment needed
- The gpuvm portion can apply to all stable trees with the dml21
  directory
- Record: Partial dependency on field availability; gpuvm portion
  universally applicable

## PHASE 4: MAILING LIST INVESTIGATION

**Step 4.1: b4 dig**
- `b4 dig -c 07ac59230d5fd`: returned "Could not find anything matching"
  - typical for AMD display patches that go through the internal `amd-
  staging-drm-next` tree before mainline (not posted directly to lkml)
- Record: Patch went through AMD internal pipeline; no public list
  discussion to investigate

**Step 4.2: Reviewers**
- Verified through commit message: AMD internal review (Dillon Varone,
  Roman Li, Alex Deucher all involved)
- Tested by AMD QA (Dan Wheeler)

**Step 4.3-4.5: External Research**
- No bug report links; no Reported-by tags
- No syzbot involvement
- The commit was developed proactively after dml2_0 fix to address
  parallel bug

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.4: Functions and Reachability**
- `populate_dml21_dummy_plane_cfg`: called when stream has no planes
  (e.g., display blanked/initial state)
- `populate_dml21_plane_config_from_plane_state`: called for every plane
  on every mode-set
- Caller: `dml21_map_dc_state_into_dml_display_cfg` invoked from
  `dml21_validate`/`dml21_compute_subvp_state`
- Reachable from: every atomic commit / mode-set on DCN401 hardware
- Record: HIGHLY reachable - any display configuration change on DCN401

**Step 5.5: Similar Patterns**
- The same fix was already done for dml2_0
  (`populate_dummy_dml_plane_cfg`,
  `populate_dml_plane_cfg_from_plane_state`)
- DCN401 uses `using_dml21 = true` (verified in `dcn401_resource.c`), so
  dml2_1 path is the active one for this hardware
- Record: Direct parallel to previously-fixed dml2_0 bug

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Code Existence**
- 6.6.y: file does NOT exist (no DCN401 support, dml21 dir absent)
- 6.11.y - 6.18.y: file exists at
  `drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_translation_helper.c`
- 6.19.y - 7.0.y: file exists at `drivers/gpu/drm/amd/display/dc/dml2_0/
  dml21/dml21_translation_helper.c` (renamed)
- Record: Bug exists in 6.11.y onward; not applicable to 6.6.y and
  earlier

**Step 6.2: Backport Difficulty**
- 7.0.y, 6.19.y: clean apply
- 6.18.y: needs path adjustment (dml2 vs dml2_0)
- 6.16.y - 6.17.y: needs path adjustment; both fields available
- 6.12.y, 6.15.y: needs path adjustment AND hostvm field doesn't exist
  in override struct → drop the hostvm override line
- 6.11.y: similar to 6.12.y (needs adjustment)
- Record: Trivial path adjustment for older trees; hostvm portion may
  need dropping for 6.15.y and earlier

**Step 6.3: Related Fixes Already in Stable**
- The dml2_0 equivalent IS already in stable from 6.10.y onward
- The dml2_1 specific fix is NOT yet in any stable tree
- Record: This commit fills a gap left by the prior dml2_0 fix

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1: Subsystem**
- `drivers/gpu/drm/amd/display/` - AMD DC display driver
- Affects: DCN401 hardware (RX 9000 / RDNA4 GPUs, gfx12.0.0/12.0.1)
- Criticality: IMPORTANT - affects users of new AMD GPUs

**Step 7.2: Activity**
- Highly active subsystem; frequent fixes flow to stable
- Record: Active; AMD regularly submits display fixes to stable

## PHASE 8: IMPACT AND RISK

**Step 8.1: Affected Users**
- DCN401 hardware users (AMD RX 9000 / RDNA 4)
- Triggered on every mode-set/atomic commit
- Record: Driver-specific (DCN401), but on every display config change

**Step 8.2: Trigger Conditions**
- Per-ASIC dependent: only triggers visible corruption when SOC bb has
  non-default values
- For DCN401 default SOC bb, values are identical (gpuvm=256, hostvm=0),
  so the fix is a no-op functionally
- For DCN42 (in master, not yet stable) and other future ASICs with
  different values, this prevents corruption
- Record: Latent bug; impact varies per ASIC

**Step 8.3: Failure Mode Severity**
- Per commit message: "corruption or underflow for linear surfaces"
- HIGH severity: visible display corruption is user-visible
- Record: HIGH for affected ASICs

**Step 8.4: Risk-Benefit**
- Benefit: prevents a documented hardware programming bug; mirrors
  approved dml2_0 fix
- Risk: very low - structural change replacing constant with same-value
  lookup; for current DCN401 default, no behavior change
- Record: Favorable risk-benefit ratio

## PHASE 9: SYNTHESIS

**Evidence FOR backport:**
- Direct precedent: the dml2_0 equivalent was selected for stable
  (6.10-6.19+)
- Small surgical fix (~15 lines)
- Low regression risk; for default DCN401 SOC bb the values are
  identical
- Reviewed and tested by AMD
- Hardware corruption potential explicitly stated by author
- Affects DCN401 users on every mode-set

**Evidence AGAINST backport:**
- For older stable trees (<6.16), the hostvm override field doesn't
  exist - needs backport adjustment
- For DCN401's default SOC bb, this is essentially a structural fix
  without functional change in practice
- Bug is latent for default configurations on current hardware

**Stable Rules Checklist:**
1. Obviously correct and tested? YES (Reviewed-by, Tested-by AMD QA)
2. Real bug? YES (per commit message: corruption/underflow potential)
3. Important issue? YES (display corruption is HIGH severity)
4. Small and contained? YES (1 file, 21 lines)
5. No new features? YES (just propagates existing SOC bb values)
6. Applies cleanly? PARTIALLY - clean for 6.19+, needs path/feature
   adjustments for older

This commit follows the established pattern: the dml2_0 equivalent fix
was an AUTOSEL stable backport, and this fixes the parallel bug in
dml2_1. While the impact on the current DCN401 default configuration is
minimal (values match), it is the correct structural fix that prevents
corruption on ASICs with different SOC bb values, including upcoming
DCN42 hardware. The fix is small, well-reviewed, and low-risk.

## Verification

- [Phase 1] Parsed tags: confirmed Reviewed-by Dillon Varone, Tested-by
  Dan Wheeler, signed by Roman Li and Alex Deucher
- [Phase 2] Diff analysis: 15 insertions, 6 deletions in single file;
  verified function signature changes via diff
- [Phase 3] git log on file: dml21 dir created in commit `70839da636050`
  (April 2024); confirmed via `git tag --contains` it first appeared in
  v6.11
- [Phase 3] git log/show `31663521ede2e`: confirmed dml2_0 equivalent
  exists, was authored July 2024 by same author Nicholas Kazlauskas
- [Phase 3] Confirmed dml2_0 fix backported to stable: 54877301a7551
  (6.10.y), 291c87fd3abe1 (6.11.y), 31663521ede2e (6.12.y, 6.18.y,
  6.19.y)
- [Phase 3] git show `5721b5b9c9c79`: verified adjacent independent fix
  for HostVMMinPageSize unit mismatch
- [Phase 4] b4 dig -c 07ac59230d5fd: returned "Could not find anything
  matching" - typical for AMD internal pipeline
- [Phase 5] grep verified `using_dml21 = true` in dcn401_resource.c
  (line 731), confirming dml2_1 path is active for DCN401
- [Phase 5] grep verified callers of populate functions trace back to
  mode-set/atomic commit paths
- [Phase 6] git ls-tree on stable trees: confirmed file presence per
  branch (6.6.y absent, 6.11+ present, renamed at 6.19)
- [Phase 6] git show on 6.12.y soc_parameter_types.h: confirmed
  `hostvm_min_page_size_kbytes` exists in dml2_soc_bb but verified the
  dml_top_display_cfg_types.h plane override only had
  `gpuvm_min_page_size_kbytes` (not hostvm) until v6.16
- [Phase 6] git show on 6.18.y/6.19.y override struct: confirmed both
  fields present
- [Phase 7] Verified subsystem activity via recent commit log
- [Phase 8] Verified default DCN4 SOC bb values:
  `gpuvm_min_page_size_kbytes = 256`, `hostvm_min_page_size_kbytes = 0`
  in `dcn4_soc_bb.h` - identical to previous hardcoding for default case
- [Phase 8] Verified `display_config` is memset to 0 before population
  in `dml21_wrapper.c` (line 210), so hostvm starts at 0 effectively
  even before fix
- UNVERIFIED: Could not find the patch on lore.kernel.org (b4 dig and
  direct lore search both failed); typical for AMD internal pipeline
  patches that don't get posted to public lists before merge

The fix matches a previously-approved stable backport pattern, is small
and surgical, addresses a documented hardware programming concern
(PTE_ROW_HEIGHT_LINEAR causing corruption/underflow), and has negligible
regression risk.

**YES**

 .../dml2_0/dml21/dml21_translation_helper.c   | 21 +++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2_0/dml21/dml21_translation_helper.c b/drivers/gpu/drm/amd/display/dc/dml2_0/dml21/dml21_translation_helper.c
index bf5e7f4e04167..a64c0407ad515 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2_0/dml21/dml21_translation_helper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2_0/dml21/dml21_translation_helper.c
@@ -381,7 +381,9 @@ static void populate_dml21_dummy_surface_cfg(struct dml2_surface_cfg *surface, c
 	surface->tiling = dml2_sw_64kb_2d;
 }
 
-static void populate_dml21_dummy_plane_cfg(struct dml2_plane_parameters *plane, const struct dc_stream_state *stream)
+static void populate_dml21_dummy_plane_cfg(struct dml2_plane_parameters *plane,
+					   const struct dc_stream_state *stream,
+					   const struct dml2_soc_bb *soc_bb)
 {
 	unsigned int width, height;
 
@@ -425,7 +427,8 @@ static void populate_dml21_dummy_plane_cfg(struct dml2_plane_parameters *plane,
 	plane->pixel_format = dml2_444_32;
 
 	plane->dynamic_meta_data.enable = false;
-	plane->overrides.gpuvm_min_page_size_kbytes = 256;
+	plane->overrides.gpuvm_min_page_size_kbytes = soc_bb->gpuvm_min_page_size_kbytes;
+	plane->overrides.hostvm_min_page_size_kbytes = soc_bb->hostvm_min_page_size_kbytes;
 }
 
 static void populate_dml21_surface_config_from_plane_state(
@@ -495,7 +498,7 @@ static const struct scaler_data *get_scaler_data_for_plane(
 
 static void populate_dml21_plane_config_from_plane_state(struct dml2_context *dml_ctx,
 		struct dml2_plane_parameters *plane, const struct dc_plane_state *plane_state,
-		const struct dc_state *context, unsigned int stream_index)
+		const struct dc_state *context, unsigned int stream_index, const struct dml2_soc_bb *soc_bb)
 {
 	const struct scaler_data *scaler_data = get_scaler_data_for_plane(dml_ctx, plane_state, context);
 	struct dc_stream_state *stream = context->streams[stream_index];
@@ -631,7 +634,8 @@ static void populate_dml21_plane_config_from_plane_state(struct dml2_context *dm
 	plane->composition.rotation_angle = (enum dml2_rotation_angle) plane_state->rotation;
 	plane->stream_index = stream_index;
 
-	plane->overrides.gpuvm_min_page_size_kbytes = 256;
+	plane->overrides.gpuvm_min_page_size_kbytes = soc_bb->gpuvm_min_page_size_kbytes;
+	plane->overrides.hostvm_min_page_size_kbytes = soc_bb->hostvm_min_page_size_kbytes;
 
 	plane->immediate_flip = plane_state->flip_immediate;
 
@@ -765,7 +769,9 @@ bool dml21_map_dc_state_into_dml_display_cfg(const struct dc *in_dc, struct dc_s
 		if (context->stream_status[stream_index].plane_count == 0) {
 			disp_cfg_plane_location = dml_dispcfg->num_planes++;
 			populate_dml21_dummy_surface_cfg(&dml_dispcfg->plane_descriptors[disp_cfg_plane_location].surface, context->streams[stream_index]);
-			populate_dml21_dummy_plane_cfg(&dml_dispcfg->plane_descriptors[disp_cfg_plane_location], context->streams[stream_index]);
+			populate_dml21_dummy_plane_cfg(
+				&dml_dispcfg->plane_descriptors[disp_cfg_plane_location],
+				context->streams[stream_index], &dml_ctx->v21.dml_init.soc_bb);
 			dml_dispcfg->plane_descriptors[disp_cfg_plane_location].stream_index = disp_cfg_stream_location;
 		} else {
 			for (plane_index = 0; plane_index < context->stream_status[stream_index].plane_count; plane_index++) {
@@ -777,7 +783,10 @@ bool dml21_map_dc_state_into_dml_display_cfg(const struct dc *in_dc, struct dc_s
 				ASSERT(disp_cfg_plane_location >= 0 && disp_cfg_plane_location < __DML2_WRAPPER_MAX_STREAMS_PLANES__);
 
 				populate_dml21_surface_config_from_plane_state(in_dc, &dml_dispcfg->plane_descriptors[disp_cfg_plane_location].surface, context->stream_status[stream_index].plane_states[plane_index]);
-				populate_dml21_plane_config_from_plane_state(dml_ctx, &dml_dispcfg->plane_descriptors[disp_cfg_plane_location], context->stream_status[stream_index].plane_states[plane_index], context, stream_index);
+				populate_dml21_plane_config_from_plane_state(
+					dml_ctx, &dml_dispcfg->plane_descriptors[disp_cfg_plane_location],
+					context->stream_status[stream_index].plane_states[plane_index],
+					context, stream_index, &dml_ctx->v21.dml_init.soc_bb);
 				dml_dispcfg->plane_descriptors[disp_cfg_plane_location].stream_index = disp_cfg_stream_location;
 
 				if (dml21_wrapper_get_plane_id(context, context->streams[stream_index]->stream_id, context->stream_status[stream_index].plane_states[plane_index], &dml_ctx->v21.dml_to_dc_pipe_mapping.disp_cfg_to_plane_id[disp_cfg_plane_location]))
-- 
2.53.0

