Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B54B1DC998;
	Tue, 27 May 2025 17:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367757; cv=none; b=M8PSw6HOdYLV9u8F4Qrsq1366HSS0tegrsmGxOaCbsRIS4U5Bgb9Juvpu4JzZ+A1bHf0WOsi5Td3PEU0F5yIRIkHa4TEbRtD8JwBi8BvZdxcVa0199joFElks9fYSGRNOWftSA7wDDOkAOi+lCyWl+Hnf/6dDdFenmhNrwTZ5Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367757; c=relaxed/simple;
	bh=sYZ6HjeLui2q05JpGh+izggwBI53f5y34ZcIusC/IYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKZujK50Cl5C4Pcx8ErKfKAc1FMW/L3nwalQ24G+dYklsAfQxwYKGu9/z5g0pgjPw5JFINNozmq/EBXQIb/IJmR3+BeXHvzmYAFOTw+ePJAhMh0LW1Vu3WnsXS3XQ1mecDWsv+ooa5O9M/lYGiaBTX5hwNolz2ETHtVH+3ul3zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ddYWS3aZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ddYWS3aZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C0B7C4CEE9;
	Tue, 27 May 2025 17:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367757;
	bh=sYZ6HjeLui2q05JpGh+izggwBI53f5y34ZcIusC/IYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ddYWS3aZzL6Oj4BdP+7ELiHK/lNh/sP5MMsou8o6DVzstX300adB0LnTtLo4xD/aZ
	 ZhyTmjskdsbxULJ/WmEV+a19ak1yacG646HMvsVPQjUr884jHY84ofG3XS05OGOCeM
	 2E08OFVPJyoUOKnQ7GwXe7qfjCbvbC3sxvv6y4wA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Austin Zheng <Austin.Zheng@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 490/783] drm/amd/display: Account For OTO Prefetch Bandwidth When Calculating Urgent Bandwidth
Date: Tue, 27 May 2025 18:24:47 +0200
Message-ID: <20250527162533.084749348@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Austin Zheng <Austin.Zheng@amd.com>

[ Upstream commit 36681f15bb12b5c01df924379cdab9234259825c ]

[Why]
1) The current calculations for OTO prefetch bandwidth do not consider the number of DPP pipes in use.
As a result, OTO prefetch bandwidth may be larger than the vactive bandwidth if multiple DPP pipes are used.
OTO prefetch bandwidth should never exceed the vactive bandwidth.

2) Mode programming may be mismatched with mode support
In cases where mode support has chosen to use the equalized (equ) prefetch schedule,
mode programming may end up using oto prefetch schedule instead.
The bandwidth required to do the oto schedule may end up being higher than the equ schedule.
This can cause the required urgent bandwidth to exceed the available urgent bandwidth.

[How]
Output the oto prefetch bandwidth and incorperate it into the urgent bandwidth calculations
even if the prefetch schedule being used is not the oto schedule.

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Austin Zheng <Austin.Zheng@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../src/dml2_core/dml2_core_dcn4_calcs.c      | 25 ++++++++++++++++++-
 .../src/dml2_core/dml2_core_shared_types.h    |  5 ++++
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
index 8ad7704b76691..913f33c31cf38 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
@@ -4915,6 +4915,7 @@ static double get_urgent_bandwidth_required(
 	double ReadBandwidthChroma[],
 	double PrefetchBandwidthLuma[],
 	double PrefetchBandwidthChroma[],
+	double PrefetchBandwidthOto[],
 	double excess_vactive_fill_bw_l[],
 	double excess_vactive_fill_bw_c[],
 	double cursor_bw[],
@@ -4978,8 +4979,9 @@ static double get_urgent_bandwidth_required(
 			l->vm_row_bw = NumberOfDPP[k] * prefetch_vmrow_bw[k];
 			l->flip_and_active_bw = l->per_plane_flip_bw[k] + ReadBandwidthLuma[k] * l->adj_factor_p0 + ReadBandwidthChroma[k] * l->adj_factor_p1 + cursor_bw[k] * l->adj_factor_cur;
 			l->flip_and_prefetch_bw = l->per_plane_flip_bw[k] + NumberOfDPP[k] * (PrefetchBandwidthLuma[k] * l->adj_factor_p0_pre + PrefetchBandwidthChroma[k] * l->adj_factor_p1_pre) + prefetch_cursor_bw[k] * l->adj_factor_cur_pre;
+			l->flip_and_prefetch_bw_oto = l->per_plane_flip_bw[k] + NumberOfDPP[k] * (PrefetchBandwidthOto[k] * l->adj_factor_p0_pre + PrefetchBandwidthChroma[k] * l->adj_factor_p1_pre) + prefetch_cursor_bw[k] * l->adj_factor_cur_pre;
 			l->active_and_excess_bw = (ReadBandwidthLuma[k] + excess_vactive_fill_bw_l[k]) * l->tmp_nom_adj_factor_p0 + (ReadBandwidthChroma[k] + excess_vactive_fill_bw_c[k]) * l->tmp_nom_adj_factor_p1 + dpte_row_bw[k] + meta_row_bw[k];
-			surface_required_bw[k] = math_max4(l->vm_row_bw, l->flip_and_active_bw, l->flip_and_prefetch_bw, l->active_and_excess_bw);
+			surface_required_bw[k] = math_max5(l->vm_row_bw, l->flip_and_active_bw, l->flip_and_prefetch_bw, l->active_and_excess_bw, l->flip_and_prefetch_bw_oto);
 
 			/* export peak required bandwidth for the surface */
 			surface_peak_required_bw[k] = math_max2(surface_required_bw[k], surface_peak_required_bw[k]);
@@ -5177,6 +5179,7 @@ static bool CalculatePrefetchSchedule(struct dml2_core_internal_scratch *scratch
 	s->Tsw_est3 = 0.0;
 	s->cursor_prefetch_bytes = 0;
 	*p->prefetch_cursor_bw = 0;
+	*p->RequiredPrefetchBWOTO = 0.0;
 
 	dcc_mrq_enable = (p->dcc_enable && p->mrq_present);
 
@@ -5390,6 +5393,9 @@ static bool CalculatePrefetchSchedule(struct dml2_core_internal_scratch *scratch
 		s->prefetch_bw_oto += (p->swath_width_chroma_ub * p->myPipe->BytePerPixelC) / s->LineTime;
 	}
 
+	/* oto prefetch bw should be always be less than total vactive bw */
+	DML2_ASSERT(s->prefetch_bw_oto < s->per_pipe_vactive_sw_bw * p->myPipe->DPPPerSurface);
+
 	s->prefetch_bw_oto = math_max2(s->per_pipe_vactive_sw_bw, s->prefetch_bw_oto) * p->mall_prefetch_sdp_overhead_factor;
 
 	s->prefetch_bw_oto = math_min2(s->prefetch_bw_oto, *p->prefetch_sw_bytes/(s->min_Lsw_oto*s->LineTime));
@@ -5400,6 +5406,12 @@ static bool CalculatePrefetchSchedule(struct dml2_core_internal_scratch *scratch
 					p->vm_bytes * p->HostVMInefficiencyFactor / (31 * s->LineTime) - *p->Tno_bw,
 					(p->PixelPTEBytesPerRow * p->HostVMInefficiencyFactor + p->meta_row_bytes + tdlut_row_bytes) / (15 * s->LineTime));
 
+	/* oto bw needs to be outputted even if the oto schedule isn't being used to avoid ms/mp mismatch.
+	 * mp will fail if ms decides to use equ schedule and mp decides to use oto schedule
+	 * and the required bandwidth increases when going from ms to mp
+	 */
+	*p->RequiredPrefetchBWOTO = s->prefetch_bw_oto;
+
 #ifdef __DML_VBA_DEBUG__
 	dml2_printf("DML::%s: vactive_sw_bw_l = %f\n", __func__, p->vactive_sw_bw_l);
 	dml2_printf("DML::%s: vactive_sw_bw_c = %f\n", __func__, p->vactive_sw_bw_c);
@@ -6160,6 +6172,7 @@ static void calculate_peak_bandwidth_required(
 				p->surface_read_bandwidth_c,
 				l->zero_array, //PrefetchBandwidthLuma,
 				l->zero_array, //PrefetchBandwidthChroma,
+				l->zero_array, //PrefetchBWOTO
 				l->zero_array,
 				l->zero_array,
 				l->zero_array,
@@ -6196,6 +6209,7 @@ static void calculate_peak_bandwidth_required(
 				p->surface_read_bandwidth_c,
 				l->zero_array, //PrefetchBandwidthLuma,
 				l->zero_array, //PrefetchBandwidthChroma,
+				l->zero_array, //PrefetchBWOTO
 				p->excess_vactive_fill_bw_l,
 				p->excess_vactive_fill_bw_c,
 				p->cursor_bw,
@@ -6232,6 +6246,7 @@ static void calculate_peak_bandwidth_required(
 				p->surface_read_bandwidth_c,
 				p->prefetch_bandwidth_l,
 				p->prefetch_bandwidth_c,
+				p->prefetch_bandwidth_oto, // to prevent ms/mp mismatch when oto bw > total vactive bw
 				p->excess_vactive_fill_bw_l,
 				p->excess_vactive_fill_bw_c,
 				p->cursor_bw,
@@ -6268,6 +6283,7 @@ static void calculate_peak_bandwidth_required(
 				p->surface_read_bandwidth_c,
 				p->prefetch_bandwidth_l,
 				p->prefetch_bandwidth_c,
+				p->prefetch_bandwidth_oto, // to prevent ms/mp mismatch when oto bw > total vactive bw
 				p->excess_vactive_fill_bw_l,
 				p->excess_vactive_fill_bw_c,
 				p->cursor_bw,
@@ -6304,6 +6320,7 @@ static void calculate_peak_bandwidth_required(
 				p->surface_read_bandwidth_c,
 				p->prefetch_bandwidth_l,
 				p->prefetch_bandwidth_c,
+				p->prefetch_bandwidth_oto, // to prevent ms/mp mismatch when oto bw > total vactive bw
 				p->excess_vactive_fill_bw_l,
 				p->excess_vactive_fill_bw_c,
 				p->cursor_bw,
@@ -9066,6 +9083,7 @@ static bool dml_core_mode_support(struct dml2_core_calcs_mode_support_ex *in_out
 				CalculatePrefetchSchedule_params->VRatioPrefetchC = &mode_lib->ms.VRatioPreC[k];
 				CalculatePrefetchSchedule_params->RequiredPrefetchPixelDataBWLuma = &mode_lib->ms.RequiredPrefetchPixelDataBWLuma[k]; // prefetch_sw_bw_l
 				CalculatePrefetchSchedule_params->RequiredPrefetchPixelDataBWChroma = &mode_lib->ms.RequiredPrefetchPixelDataBWChroma[k]; // prefetch_sw_bw_c
+				CalculatePrefetchSchedule_params->RequiredPrefetchBWOTO = &mode_lib->ms.RequiredPrefetchBWOTO[k];
 				CalculatePrefetchSchedule_params->NotEnoughTimeForDynamicMetadata = &mode_lib->ms.NoTimeForDynamicMetadata[k];
 				CalculatePrefetchSchedule_params->Tno_bw = &mode_lib->ms.Tno_bw[k];
 				CalculatePrefetchSchedule_params->Tno_bw_flip = &mode_lib->ms.Tno_bw_flip[k];
@@ -9210,6 +9228,7 @@ static bool dml_core_mode_support(struct dml2_core_calcs_mode_support_ex *in_out
 				calculate_peak_bandwidth_params->surface_read_bandwidth_c = mode_lib->ms.vactive_sw_bw_c;
 				calculate_peak_bandwidth_params->prefetch_bandwidth_l = mode_lib->ms.RequiredPrefetchPixelDataBWLuma;
 				calculate_peak_bandwidth_params->prefetch_bandwidth_c = mode_lib->ms.RequiredPrefetchPixelDataBWChroma;
+				calculate_peak_bandwidth_params->prefetch_bandwidth_oto = mode_lib->ms.RequiredPrefetchBWOTO;
 				calculate_peak_bandwidth_params->excess_vactive_fill_bw_l = mode_lib->ms.excess_vactive_fill_bw_l;
 				calculate_peak_bandwidth_params->excess_vactive_fill_bw_c = mode_lib->ms.excess_vactive_fill_bw_c;
 				calculate_peak_bandwidth_params->cursor_bw = mode_lib->ms.cursor_bw;
@@ -9376,6 +9395,7 @@ static bool dml_core_mode_support(struct dml2_core_calcs_mode_support_ex *in_out
 			calculate_peak_bandwidth_params->surface_read_bandwidth_c = mode_lib->ms.vactive_sw_bw_c;
 			calculate_peak_bandwidth_params->prefetch_bandwidth_l = mode_lib->ms.RequiredPrefetchPixelDataBWLuma;
 			calculate_peak_bandwidth_params->prefetch_bandwidth_c = mode_lib->ms.RequiredPrefetchPixelDataBWChroma;
+			calculate_peak_bandwidth_params->prefetch_bandwidth_oto = mode_lib->ms.RequiredPrefetchBWOTO;
 			calculate_peak_bandwidth_params->excess_vactive_fill_bw_l = mode_lib->ms.excess_vactive_fill_bw_l;
 			calculate_peak_bandwidth_params->excess_vactive_fill_bw_c = mode_lib->ms.excess_vactive_fill_bw_c;
 			calculate_peak_bandwidth_params->cursor_bw = mode_lib->ms.cursor_bw;
@@ -11292,6 +11312,7 @@ static bool dml_core_mode_programming(struct dml2_core_calcs_mode_programming_ex
 			CalculatePrefetchSchedule_params->VRatioPrefetchC = &mode_lib->mp.VRatioPrefetchC[k];
 			CalculatePrefetchSchedule_params->RequiredPrefetchPixelDataBWLuma = &mode_lib->mp.RequiredPrefetchPixelDataBWLuma[k];
 			CalculatePrefetchSchedule_params->RequiredPrefetchPixelDataBWChroma = &mode_lib->mp.RequiredPrefetchPixelDataBWChroma[k];
+			CalculatePrefetchSchedule_params->RequiredPrefetchBWOTO = &s->dummy_single_array[0][k];
 			CalculatePrefetchSchedule_params->NotEnoughTimeForDynamicMetadata = &mode_lib->mp.NotEnoughTimeForDynamicMetadata[k];
 			CalculatePrefetchSchedule_params->Tno_bw = &mode_lib->mp.Tno_bw[k];
 			CalculatePrefetchSchedule_params->Tno_bw_flip = &mode_lib->mp.Tno_bw_flip[k];
@@ -11434,6 +11455,7 @@ static bool dml_core_mode_programming(struct dml2_core_calcs_mode_programming_ex
 			calculate_peak_bandwidth_params->surface_read_bandwidth_c = mode_lib->mp.vactive_sw_bw_c;
 			calculate_peak_bandwidth_params->prefetch_bandwidth_l = mode_lib->mp.RequiredPrefetchPixelDataBWLuma;
 			calculate_peak_bandwidth_params->prefetch_bandwidth_c = mode_lib->mp.RequiredPrefetchPixelDataBWChroma;
+			calculate_peak_bandwidth_params->prefetch_bandwidth_oto = s->dummy_single_array[0];
 			calculate_peak_bandwidth_params->excess_vactive_fill_bw_l = mode_lib->mp.excess_vactive_fill_bw_l;
 			calculate_peak_bandwidth_params->excess_vactive_fill_bw_c = mode_lib->mp.excess_vactive_fill_bw_c;
 			calculate_peak_bandwidth_params->cursor_bw = mode_lib->mp.cursor_bw;
@@ -11566,6 +11588,7 @@ static bool dml_core_mode_programming(struct dml2_core_calcs_mode_programming_ex
 			calculate_peak_bandwidth_params->surface_read_bandwidth_c = mode_lib->mp.vactive_sw_bw_c;
 			calculate_peak_bandwidth_params->prefetch_bandwidth_l = mode_lib->mp.RequiredPrefetchPixelDataBWLuma;
 			calculate_peak_bandwidth_params->prefetch_bandwidth_c = mode_lib->mp.RequiredPrefetchPixelDataBWChroma;
+			calculate_peak_bandwidth_params->prefetch_bandwidth_oto = s->dummy_single_array[k];
 			calculate_peak_bandwidth_params->excess_vactive_fill_bw_l = mode_lib->mp.excess_vactive_fill_bw_l;
 			calculate_peak_bandwidth_params->excess_vactive_fill_bw_c = mode_lib->mp.excess_vactive_fill_bw_c;
 			calculate_peak_bandwidth_params->cursor_bw = mode_lib->mp.cursor_bw;
diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_shared_types.h b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_shared_types.h
index 23c0fca5515fe..b7cb017b59baa 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_shared_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_shared_types.h
@@ -484,6 +484,8 @@ struct dml2_core_internal_mode_support {
 	double WriteBandwidth[DML2_MAX_PLANES][DML2_MAX_WRITEBACK];
 	double RequiredPrefetchPixelDataBWLuma[DML2_MAX_PLANES];
 	double RequiredPrefetchPixelDataBWChroma[DML2_MAX_PLANES];
+	/* oto bw should also be considered when calculating urgent bw to avoid situations oto/equ mismatches between ms and mp */
+	double RequiredPrefetchBWOTO[DML2_MAX_PLANES];
 	double cursor_bw[DML2_MAX_PLANES];
 	double prefetch_cursor_bw[DML2_MAX_PLANES];
 	double prefetch_vmrow_bw[DML2_MAX_PLANES];
@@ -1381,6 +1383,7 @@ struct dml2_core_shared_get_urgent_bandwidth_required_locals {
 	double vm_row_bw;
 	double flip_and_active_bw;
 	double flip_and_prefetch_bw;
+	double flip_and_prefetch_bw_oto;
 	double active_and_excess_bw;
 };
 
@@ -1792,6 +1795,7 @@ struct dml2_core_calcs_CalculatePrefetchSchedule_params {
 	double *VRatioPrefetchC;
 	double *RequiredPrefetchPixelDataBWLuma;
 	double *RequiredPrefetchPixelDataBWChroma;
+	double *RequiredPrefetchBWOTO;
 	bool *NotEnoughTimeForDynamicMetadata;
 	double *Tno_bw;
 	double *Tno_bw_flip;
@@ -2025,6 +2029,7 @@ struct dml2_core_calcs_calculate_peak_bandwidth_required_params {
 	double *surface_read_bandwidth_c;
 	double *prefetch_bandwidth_l;
 	double *prefetch_bandwidth_c;
+	double *prefetch_bandwidth_oto;
 	double *excess_vactive_fill_bw_l;
 	double *excess_vactive_fill_bw_c;
 	double *cursor_bw;
-- 
2.39.5



