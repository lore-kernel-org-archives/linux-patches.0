Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97DE217664;
	Thu, 12 Dec 2024 15:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016352; cv=none; b=L/3DetHlsZMHSynezvzdoa9YSgmSKhh3vVVBuxg9EtZYXUKqsElyfpKiVPD7xw0dPLDrtcvwl2lv110RcF1tmJ736bSGDwXb4EvwdTSnAhozNno1566o9ra6e6jJE7qVL+r8mKFBc1aQNymRuBiRVeHKwSdi6z1b/dwzcprzhnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016352; c=relaxed/simple;
	bh=+rZtDaIdFlUE33UGDWoG45nDqA7CJ27begtOHJEKx0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTadzkxRUWrKkdQr/uD0x+ndz0ksin4XbmVA7Lg1HkaxhDfBip0Aqa+KUMw2KmVuihqHEmvvHpcbX0CIffHGlmRl50xV5cK5AzI172FbqzTwl1OdE6oBSGn9GqX+9k+OMD8WMDlTl/nxMm7PuWPh0K7GQyGK2ebl5pqBl/jTs1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BXKDPFBB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXKDPFBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76286C4CEDF;
	Thu, 12 Dec 2024 15:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016352;
	bh=+rZtDaIdFlUE33UGDWoG45nDqA7CJ27begtOHJEKx0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BXKDPFBBgtBXYn0xE3iPWbcqMuLFvofF0xUtalljiu0v3FXBQG72csxOIYz+/bgY4
	 UmHBHmTMXsofHWK0Ex+k12xf+lnzhFI+v3CySimamLFNK6OGpTGxEFN4jMZgcKxmM2
	 8s2ze/JzgbEUzW0a8eVGesBTMIIGoy6r3aRmW+2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Jun Lei <jun.lei@amd.com>,
	Anthony Koo <anthony.koo@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.12 175/466] drm/amd/display: Limit VTotal range to max hw cap minus fp
Date: Thu, 12 Dec 2024 15:55:44 +0100
Message-ID: <20241212144313.711723710@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dillon Varone <dillon.varone@amd.com>

commit a29997b7ac1f5c816b543e0c56aa2b5b56baac24 upstream.

[WHY & HOW]
Hardware does not support the VTotal to be between fp2 lines of the
maximum possible VTotal, so add a capability flag to track it and apply
where necessary.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Jun Lei <jun.lei@amd.com>
Reviewed-by: Anthony Koo <anthony.koo@amd.com>
Signed-off-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dc.h                                  |    1 
 drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_translation_helper.c |   27 +++++++++-
 drivers/gpu/drm/amd/display/dc/resource/dcn30/dcn30_resource.c       |    1 
 drivers/gpu/drm/amd/display/dc/resource/dcn302/dcn302_resource.c     |    1 
 drivers/gpu/drm/amd/display/dc/resource/dcn303/dcn303_resource.c     |    1 
 drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c       |    1 
 drivers/gpu/drm/amd/display/dc/resource/dcn321/dcn321_resource.c     |    1 
 drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c       |    1 
 drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c     |    1 
 drivers/gpu/drm/amd/display/dc/resource/dcn401/dcn401_resource.c     |    1 
 drivers/gpu/drm/amd/display/modules/freesync/freesync.c              |   13 ++++
 11 files changed, 46 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -285,6 +285,7 @@ struct dc_caps {
 	uint16_t subvp_vertical_int_margin_us;
 	bool seamless_odm;
 	uint32_t max_v_total;
+	bool vtotal_limited_by_fp2;
 	uint32_t max_disp_clock_khz_at_vmin;
 	uint8_t subvp_drr_vblank_start_margin_us;
 	bool cursor_not_scaled;
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_translation_helper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_translation_helper.c
@@ -339,11 +339,22 @@ void dml21_apply_soc_bb_overrides(struct
 	// }
 }
 
+static unsigned int calc_max_hardware_v_total(const struct dc_stream_state *stream)
+{
+	unsigned int max_hw_v_total = stream->ctx->dc->caps.max_v_total;
+
+	if (stream->ctx->dc->caps.vtotal_limited_by_fp2) {
+		max_hw_v_total -= stream->timing.v_front_porch + 1;
+	}
+
+	return max_hw_v_total;
+}
+
 static void populate_dml21_timing_config_from_stream_state(struct dml2_timing_cfg *timing,
 		struct dc_stream_state *stream,
 		struct dml2_context *dml_ctx)
 {
-	unsigned int hblank_start, vblank_start;
+	unsigned int hblank_start, vblank_start, min_hardware_refresh_in_uhz;
 
 	timing->h_active = stream->timing.h_addressable + stream->timing.h_border_left + stream->timing.h_border_right;
 	timing->v_active = stream->timing.v_addressable + stream->timing.v_border_bottom + stream->timing.v_border_top;
@@ -371,11 +382,23 @@ static void populate_dml21_timing_config
 		- stream->timing.v_border_top - stream->timing.v_border_bottom;
 
 	timing->drr_config.enabled = stream->ignore_msa_timing_param;
-	timing->drr_config.min_refresh_uhz = stream->timing.min_refresh_in_uhz;
 	timing->drr_config.drr_active_variable = stream->vrr_active_variable;
 	timing->drr_config.drr_active_fixed = stream->vrr_active_fixed;
 	timing->drr_config.disallowed = !stream->allow_freesync;
 
+	/* limit min refresh rate to DC cap */
+	min_hardware_refresh_in_uhz = stream->timing.min_refresh_in_uhz;
+	if (stream->ctx->dc->caps.max_v_total != 0) {
+		min_hardware_refresh_in_uhz = div64_u64((stream->timing.pix_clk_100hz * 100000000ULL),
+				(stream->timing.h_total * (long long)calc_max_hardware_v_total(stream)));
+	}
+
+	if (stream->timing.min_refresh_in_uhz > min_hardware_refresh_in_uhz) {
+		timing->drr_config.min_refresh_uhz = stream->timing.min_refresh_in_uhz;
+	} else {
+		timing->drr_config.min_refresh_uhz = min_hardware_refresh_in_uhz;
+	}
+
 	if (dml_ctx->config.callbacks.get_max_flickerless_instant_vtotal_increase &&
 			stream->ctx->dc->config.enable_fpo_flicker_detection == 1)
 		timing->drr_config.max_instant_vtotal_delta = dml_ctx->config.callbacks.get_max_flickerless_instant_vtotal_increase(stream, false);
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn30/dcn30_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn30/dcn30_resource.c
@@ -2354,6 +2354,7 @@ static bool dcn30_resource_construct(
 
 	dc->caps.dp_hdmi21_pcon_support = true;
 	dc->caps.max_v_total = (1 << 15) - 1;
+	dc->caps.vtotal_limited_by_fp2 = true;
 
 	/* read VBIOS LTTPR caps */
 	{
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn302/dcn302_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn302/dcn302_resource.c
@@ -1234,6 +1234,7 @@ static bool dcn302_resource_construct(
 	dc->caps.extended_aux_timeout_support = true;
 	dc->caps.dmcub_support = true;
 	dc->caps.max_v_total = (1 << 15) - 1;
+	dc->caps.vtotal_limited_by_fp2 = true;
 
 	/* Color pipeline capabilities */
 	dc->caps.color.dpp.dcn_arch = 1;
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn303/dcn303_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn303/dcn303_resource.c
@@ -1179,6 +1179,7 @@ static bool dcn303_resource_construct(
 	dc->caps.extended_aux_timeout_support = true;
 	dc->caps.dmcub_support = true;
 	dc->caps.max_v_total = (1 << 15) - 1;
+	dc->caps.vtotal_limited_by_fp2 = true;
 
 	/* Color pipeline capabilities */
 	dc->caps.color.dpp.dcn_arch = 1;
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
@@ -2186,6 +2186,7 @@ static bool dcn32_resource_construct(
 	dc->caps.dmcub_support = true;
 	dc->caps.seamless_odm = true;
 	dc->caps.max_v_total = (1 << 15) - 1;
+	dc->caps.vtotal_limited_by_fp2 = true;
 
 	/* Color pipeline capabilities */
 	dc->caps.color.dpp.dcn_arch = 1;
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn321/dcn321_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn321/dcn321_resource.c
@@ -1743,6 +1743,7 @@ static bool dcn321_resource_construct(
 	dc->caps.extended_aux_timeout_support = true;
 	dc->caps.dmcub_support = true;
 	dc->caps.max_v_total = (1 << 15) - 1;
+	dc->caps.vtotal_limited_by_fp2 = true;
 
 	/* Color pipeline capabilities */
 	dc->caps.color.dpp.dcn_arch = 1;
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
@@ -1850,6 +1850,7 @@ static bool dcn35_resource_construct(
 	dc->caps.zstate_support = true;
 	dc->caps.ips_support = true;
 	dc->caps.max_v_total = (1 << 15) - 1;
+	dc->caps.vtotal_limited_by_fp2 = true;
 
 	/* Color pipeline capabilities */
 	dc->caps.color.dpp.dcn_arch = 1;
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
@@ -1829,6 +1829,7 @@ static bool dcn351_resource_construct(
 	dc->caps.zstate_support = true;
 	dc->caps.ips_support = true;
 	dc->caps.max_v_total = (1 << 15) - 1;
+	dc->caps.vtotal_limited_by_fp2 = true;
 
 	/* Color pipeline capabilities */
 	dc->caps.color.dpp.dcn_arch = 1;
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn401/dcn401_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn401/dcn401_resource.c
@@ -1826,6 +1826,7 @@ static bool dcn401_resource_construct(
 	dc->caps.extended_aux_timeout_support = true;
 	dc->caps.dmcub_support = true;
 	dc->caps.max_v_total = (1 << 15) - 1;
+	dc->caps.vtotal_limited_by_fp2 = true;
 
 	if (ASICREV_IS_GC_12_0_1_A0(dc->ctx->asic_id.hw_internal_rev))
 		dc->caps.dcc_plane_width_limit = 7680;
--- a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
+++ b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
@@ -121,6 +121,17 @@ static unsigned int calc_duration_in_us_
 	return duration_in_us;
 }
 
+static unsigned int calc_max_hardware_v_total(const struct dc_stream_state *stream)
+{
+	unsigned int max_hw_v_total = stream->ctx->dc->caps.max_v_total;
+
+	if (stream->ctx->dc->caps.vtotal_limited_by_fp2) {
+		max_hw_v_total -= stream->timing.v_front_porch + 1;
+	}
+
+	return max_hw_v_total;
+}
+
 unsigned int mod_freesync_calc_v_total_from_refresh(
 		const struct dc_stream_state *stream,
 		unsigned int refresh_in_uhz)
@@ -1002,7 +1013,7 @@ void mod_freesync_build_vrr_params(struc
 
 	if (stream->ctx->dc->caps.max_v_total != 0 && stream->timing.h_total != 0) {
 		min_hardware_refresh_in_uhz = div64_u64((stream->timing.pix_clk_100hz * 100000000ULL),
-			(stream->timing.h_total * (long long)stream->ctx->dc->caps.max_v_total));
+			(stream->timing.h_total * (long long)calc_max_hardware_v_total(stream)));
 	}
 	/* Limit minimum refresh rate to what can be supported by hardware */
 	min_refresh_in_uhz = min_hardware_refresh_in_uhz > in_config->min_refresh_in_uhz ?


