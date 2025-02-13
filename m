Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16FE281360;
	Thu, 13 Feb 2025 14:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457247; cv=none; b=edi9bsNgvRp9o7UIBDsaDkM3CZXCOadsscmHNUNZpbg/PoDb7Emz39XT9f3lQYU2RjU0sMq4foEm8pt3v7Yh839ccEqSjyaQh5WJLH+UfMV/nqmTbgHmwqHwW1Nu0UXwr7Dr22wd4HOrlTEr1dI/uBmaqjhb7bbywOu6npmjOeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457247; c=relaxed/simple;
	bh=txmYRemdGgV2hQo8pp6i/i440C0qFxgmbDYSkDSiwts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XoeV88A2FXV/avA4vBJi3mNVVCTMoE/H67PvImJCCTv9f17mfaoYNv37ASRJeLJIIPyaK8EUGuAia97kl9cFksELhqKOftC10D7QcE6UI2phjazMPxKPf6RWktDDZe7Gur8gg3198AaYH1mmcRGnis8AqQjltora1HehpWeiVNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mEqiTHOg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mEqiTHOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FEFC4CED1;
	Thu, 13 Feb 2025 14:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457246;
	bh=txmYRemdGgV2hQo8pp6i/i440C0qFxgmbDYSkDSiwts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mEqiTHOgdb6q/Z5FDV/2k+l/WM8z7/4adjeViZXdUdG2o4B+EEUEPf86Z4UJIb52L
	 AUEqWyGM+ZIwf35D6Neyl8k7M3JU2N5zo57O7HoQYy+wtY5SosNxRSoZOSOOAdupUj
	 bLqZdds9bm6GsWh7IBfHKcSU/tIYDLwgo49Ozvhs=
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
Subject: [PATCH 6.12 025/422] drm/amd/display: Populate chroma prefetch parameters, DET buffer fix
Date: Thu, 13 Feb 2025 15:22:54 +0100
Message-ID: <20250213142437.526133273@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 866b0abcff1ba..4d64c45930da4 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c
@@ -533,14 +533,21 @@ static bool optimize_pstate_with_svp_and_drr(struct dml2_context *dml2, struct d
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
@@ -551,14 +558,20 @@ static bool call_dml_mode_support_and_programming(struct dc_state *context)
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
 
@@ -687,6 +700,8 @@ static bool dml2_validate_only(struct dc_state *context)
 	build_unoptimized_policy_settings(dml2->v20.dml_core_ctx.project, &dml2->v20.dml_core_ctx.policy);
 
 	map_dc_state_into_dml_display_cfg(dml2, context, &dml2->v20.scratch.cur_display_config);
+	 if (!dml2->config.skip_hw_state_mapping)
+		 dml2_apply_det_buffer_allocation_policy(dml2, &dml2->v20.scratch.cur_display_config);
 
 	result = pack_and_call_dml_mode_support_ex(dml2,
 		&dml2->v20.scratch.cur_display_config,
-- 
2.39.5



