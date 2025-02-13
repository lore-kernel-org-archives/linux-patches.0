Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A57723F403;
	Thu, 13 Feb 2025 14:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458612; cv=none; b=oYUuxwaUk8/I+hWe0B/esD0xJDLoG43N2DI+wCqqWttNaQN+9IJdGf6hKXzQYqRJ+uujS24rCvnr47Vomuz9xMs4t5fctp+9MqZQ0GMKdV37aHVKExBDBbi2RWB5JD/neotxg4r1WW+XliZizwvt7OJW3uBG+tjLPYv3wnWHjig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458612; c=relaxed/simple;
	bh=E3PPsp91GCFTi9dounqkKQtbAHrk2YZFBcVtFMPYijw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gLrQJ6n20eIq2z6Tlbkr5V/1b2a1ZFeg/yBh6xLX/oMgid+JOzvQKiPMDyG2PAy04fOjNy0QXYKTOsEhbGpbGjy275w62oDVCyiXqkaJHl02QX95R3NeffRS6z0c21i00p0ZG+I1vrmLPo79FeaCz2aG+Hwe4KdV2jB83ICbJgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OdAykxnX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OdAykxnX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6A8C4CED1;
	Thu, 13 Feb 2025 14:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458612;
	bh=E3PPsp91GCFTi9dounqkKQtbAHrk2YZFBcVtFMPYijw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OdAykxnXo18nZreyUZhIIL70Gbbo9dtYT5V6NKsoIcgChVI7ZaVZZd+x7AfruJFH8
	 bVENhMTOPrahsyvTnFTWnmnuL0Q71F5Vq8ll2934MLrVM7B1QfV60iPHfODMVu9qUi
	 tQhCerBOMg+4Hm/P5UP5xi5cERQWX/DZyKsMo1ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <charlene.liu@amd.com>,
	Ausef Yousof <Ausef.Yousof@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 028/443] drm/amd/display: Populate chroma prefetch parameters, DET buffer fix
Date: Thu, 13 Feb 2025 15:23:13 +0100
Message-ID: <20250213142441.711374746@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ausef Yousof <Ausef.Yousof@amd.com>

[ Upstream commit 70fec46519fca859aa209f5f02e7e0a0123aca4a ]

[WHY]
Soft hang/lag observed during 10bit playback + moving cursor, corruption
observed in other tickets for same reason, also failing MPO.

1. Currently, we are always running
   calculate_lowest_supported_state_for_temp_read which is only
   necessary on dGPU
2. Fast validate path does not apply DET buffer allocation policy
3. Prefetch UrgBFactor chroma parameter not populated in prefetch
   calculation

[HOW]
1. Add a check to see if we are on APU, if so, skip the code
2. Add det buffer alloc policy checks to fast validate path
3. Populate UrgentBurstChroma param in call to calculate
   UrgBChroma prefetch values

-revision commits: small formatting/brackets/null check addition + remove test change + dGPU code

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Ausef Yousof <Ausef.Yousof@amd.com>
Signed-off-by: Fangzhi Zuo <jerry.zuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/dml2/display_mode_core.c   |  5 ++-
 .../drm/amd/display/dc/dml2/dml2_wrapper.c    | 35 +++++++++++++------
 2 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c b/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
index 8dabb1ac0b684..be87dc0f07799 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
@@ -6434,7 +6434,7 @@ static void dml_prefetch_check(struct display_mode_lib_st *mode_lib)
 							/* Output */
 							&mode_lib->ms.UrgentBurstFactorCursorPre[k],
 							&mode_lib->ms.UrgentBurstFactorLumaPre[k],
-							&mode_lib->ms.UrgentBurstFactorChroma[k],
+							&mode_lib->ms.UrgentBurstFactorChromaPre[k],
 							&mode_lib->ms.NotUrgentLatencyHidingPre[k]);
 
 					mode_lib->ms.cursor_bw_pre[k] = mode_lib->ms.cache_display_cfg.plane.NumberOfCursors[k] * mode_lib->ms.cache_display_cfg.plane.CursorWidth[k] *
@@ -9190,6 +9190,8 @@ void dml_core_mode_programming(struct display_mode_lib_st *mode_lib, const struc
 			&locals->FractionOfUrgentBandwidth,
 			&s->dummy_boolean[0]); // dml_bool_t *PrefetchBandwidthSupport
 
+
+
 		if (s->VRatioPrefetchMoreThanMax != false || s->DestinationLineTimesForPrefetchLessThan2 != false) {
 			dml_print("DML::%s: VRatioPrefetchMoreThanMax                   = %u\n", __func__, s->VRatioPrefetchMoreThanMax);
 			dml_print("DML::%s: DestinationLineTimesForPrefetchLessThan2    = %u\n", __func__, s->DestinationLineTimesForPrefetchLessThan2);
@@ -9204,6 +9206,7 @@ void dml_core_mode_programming(struct display_mode_lib_st *mode_lib, const struc
 			}
 		}
 
+
 		if (locals->PrefetchModeSupported == true && mode_lib->ms.support.ImmediateFlipSupport == true) {
 			locals->BandwidthAvailableForImmediateFlip = CalculateBandwidthAvailableForImmediateFlip(
 																	mode_lib->ms.num_active_planes,
diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c b/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c
index 9190c1328d5b2..340791d40ecbf 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c
@@ -531,14 +531,21 @@ static bool optimize_pstate_with_svp_and_drr(struct dml2_context *dml2, struct d
 static bool call_dml_mode_support_and_programming(struct dc_state *context)
 {
 	unsigned int result = 0;
-	unsigned int min_state;
+	unsigned int min_state = 0;
 	int min_state_for_g6_temp_read = 0;
+
+
+	if (!context)
+		return false;
+
 	struct dml2_context *dml2 = context->bw_ctx.dml2;
 	struct dml2_wrapper_scratch *s = &dml2->v20.scratch;
 
-	min_state_for_g6_temp_read = calculate_lowest_supported_state_for_temp_read(dml2, context);
+	if (!context->streams[0]->sink->link->dc->caps.is_apu) {
+		min_state_for_g6_temp_read = calculate_lowest_supported_state_for_temp_read(dml2, context);
 
-	ASSERT(min_state_for_g6_temp_read >= 0);
+		ASSERT(min_state_for_g6_temp_read >= 0);
+	}
 
 	if (!dml2->config.use_native_pstate_optimization) {
 		result = optimize_pstate_with_svp_and_drr(dml2, context);
@@ -549,14 +556,20 @@ static bool call_dml_mode_support_and_programming(struct dc_state *context)
 	/* Upon trying to sett certain frequencies in FRL, min_state_for_g6_temp_read is reported as -1. This leads to an invalid value of min_state causing crashes later on.
 	 * Use the default logic for min_state only when min_state_for_g6_temp_read is a valid value. In other cases, use the value calculated by the DML directly.
 	 */
-	if (min_state_for_g6_temp_read >= 0)
-		min_state = min_state_for_g6_temp_read > s->mode_support_params.out_lowest_state_idx ? min_state_for_g6_temp_read : s->mode_support_params.out_lowest_state_idx;
-	else
-		min_state = s->mode_support_params.out_lowest_state_idx;
-
-	if (result)
-		result = dml_mode_programming(&dml2->v20.dml_core_ctx, min_state, &s->cur_display_config, true);
+	if (!context->streams[0]->sink->link->dc->caps.is_apu) {
+		if (min_state_for_g6_temp_read >= 0)
+			min_state = min_state_for_g6_temp_read > s->mode_support_params.out_lowest_state_idx ? min_state_for_g6_temp_read : s->mode_support_params.out_lowest_state_idx;
+		else
+			min_state = s->mode_support_params.out_lowest_state_idx;
+	}
 
+	if (result) {
+		if (!context->streams[0]->sink->link->dc->caps.is_apu) {
+			result = dml_mode_programming(&dml2->v20.dml_core_ctx, min_state, &s->cur_display_config, true);
+		} else {
+			result = dml_mode_programming(&dml2->v20.dml_core_ctx, s->mode_support_params.out_lowest_state_idx, &s->cur_display_config, true);
+		}
+	}
 	return result;
 }
 
@@ -685,6 +698,8 @@ static bool dml2_validate_only(struct dc_state *context)
 	build_unoptimized_policy_settings(dml2->v20.dml_core_ctx.project, &dml2->v20.dml_core_ctx.policy);
 
 	map_dc_state_into_dml_display_cfg(dml2, context, &dml2->v20.scratch.cur_display_config);
+	 if (!dml2->config.skip_hw_state_mapping)
+		 dml2_apply_det_buffer_allocation_policy(dml2, &dml2->v20.scratch.cur_display_config);
 
 	result = pack_and_call_dml_mode_support_ex(dml2,
 		&dml2->v20.scratch.cur_display_config,
-- 
2.39.5



