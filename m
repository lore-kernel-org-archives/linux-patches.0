Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03652183CA6;
	Mon, 12 Aug 2024 16:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479811; cv=none; b=gUtaCJzQWPJJ8A9yNhk5J89wwYwqrElTyECC7kLAmkUEts8DqdyDZGriRGa7qLposMegCsxaqymTrWl1wCjvTesWf0K/7K9RqfFYWZPgH/TlOoQ6n2PWwRt0W3FwlyyM4pOdzlR9THpNicRqgCLVYUhT+K/E+gP1/z46t0FA0ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479811; c=relaxed/simple;
	bh=gnYTYDCndSgW58jUigszUILbnocwHSLU2TZLr3Ca2ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZrtcJznGYuWGzUxasGgYTGZyfRKePZfJaqXUALsyIyPB2veUMXhcBdXJX+GhvuuXDtseQcQ+oKNNuNzet2WHhI+OlupTVpQlbQh09ScFJBlhq077I+dN2FE8XThazhn5/kWW0aYxhuOvn4dO/KK/1Y1ifZSsvR4Yfw9VhbIG6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=owCOP75g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="owCOP75g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660C7C32782;
	Mon, 12 Aug 2024 16:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479810;
	bh=gnYTYDCndSgW58jUigszUILbnocwHSLU2TZLr3Ca2ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=owCOP75gel4xBKLQrPPOHJkInNBVLUdBmRpcoFvTSS0DQ9IspOLOymnOnIgEUw56u
	 IGp57vrkansuYXcxW43jeaS6PYNi5p3C2BaMzjY/WIeEpMY0hpYOG84BxyZCy7ZX97
	 GGB+n0td/a3MVhA8MxEMi1SiDGjGed5xO7q251Jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Zuo <jerry.zuo@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Kevin Holm <kevin@holm.dev>
Subject: [PATCH 6.10 001/263] drm/amd/display: Refactor function dm_dp_mst_is_port_support_mode()
Date: Mon, 12 Aug 2024 18:00:02 +0200
Message-ID: <20240812160146.577569393@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Lin <wayne.lin@amd.com>

commit fa57924c76d995e87ca3533ec60d1d5e55769a27 upstream.

[Why]
dm_dp_mst_is_port_support_mode() is a bit not following the original design rule and cause
light up issue with multiple 4k monitors after mst dsc hub.

[How]
Refactor function dm_dp_mst_is_port_support_mode() a bit to solve the light up issue.

Reviewed-by: Jerry Zuo <jerry.zuo@amd.com>
Acked-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[kevin@holm.dev: Resolved merge conflict in .../amdgpu_dm_mst_types.c]
Fixes: 4df96ba6676034 ("drm/amd/display: Add timing pixel encoding for mst mode validation")
Link: https://lore.kernel.org/stable/d74a7768e957e6ce88c27a5bece0c64dff132e24@holm.dev/T/#u
Signed-off-by: Kevin Holm <kevin@holm.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |  228 +++++++-----
 1 file changed, 145 insertions(+), 83 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1595,109 +1595,171 @@ static bool is_dsc_common_config_possibl
 	return bw_range->max_target_bpp_x16 && bw_range->min_target_bpp_x16;
 }
 
+#if defined(CONFIG_DRM_AMD_DC_FP)
+static bool dp_get_link_current_set_bw(struct drm_dp_aux *aux, uint32_t *cur_link_bw)
+{
+	uint32_t total_data_bw_efficiency_x10000 = 0;
+	uint32_t link_rate_per_lane_kbps = 0;
+	enum dc_link_rate link_rate;
+	union lane_count_set lane_count;
+	u8 dp_link_encoding;
+	u8 link_bw_set = 0;
+
+	*cur_link_bw = 0;
+
+	if (drm_dp_dpcd_read(aux, DP_MAIN_LINK_CHANNEL_CODING_SET, &dp_link_encoding, 1) != 1 ||
+		drm_dp_dpcd_read(aux, DP_LANE_COUNT_SET, &lane_count.raw, 1) != 1 ||
+		drm_dp_dpcd_read(aux, DP_LINK_BW_SET, &link_bw_set, 1) != 1)
+		return false;
+
+	switch (dp_link_encoding) {
+	case DP_8b_10b_ENCODING:
+		link_rate = link_bw_set;
+		link_rate_per_lane_kbps = link_rate * LINK_RATE_REF_FREQ_IN_KHZ * BITS_PER_DP_BYTE;
+		total_data_bw_efficiency_x10000 = DATA_EFFICIENCY_8b_10b_x10000;
+		total_data_bw_efficiency_x10000 /= 100;
+		total_data_bw_efficiency_x10000 *= DATA_EFFICIENCY_8b_10b_FEC_EFFICIENCY_x100;
+		break;
+	case DP_128b_132b_ENCODING:
+		switch (link_bw_set) {
+		case DP_LINK_BW_10:
+			link_rate = LINK_RATE_UHBR10;
+			break;
+		case DP_LINK_BW_13_5:
+			link_rate = LINK_RATE_UHBR13_5;
+			break;
+		case DP_LINK_BW_20:
+			link_rate = LINK_RATE_UHBR20;
+			break;
+		default:
+			return false;
+		}
+
+		link_rate_per_lane_kbps = link_rate * 10000;
+		total_data_bw_efficiency_x10000 = DATA_EFFICIENCY_128b_132b_x10000;
+		break;
+	default:
+		return false;
+	}
+
+	*cur_link_bw = link_rate_per_lane_kbps * lane_count.bits.LANE_COUNT_SET / 10000 * total_data_bw_efficiency_x10000;
+	return true;
+}
+#endif
+
 enum dc_status dm_dp_mst_is_port_support_mode(
 	struct amdgpu_dm_connector *aconnector,
 	struct dc_stream_state *stream)
 {
-	int pbn, branch_max_throughput_mps = 0;
+#if defined(CONFIG_DRM_AMD_DC_FP)
+	int branch_max_throughput_mps = 0;
 	struct dc_link_settings cur_link_settings;
-	unsigned int end_to_end_bw_in_kbps = 0;
-	unsigned int upper_link_bw_in_kbps = 0, down_link_bw_in_kbps = 0;
+	uint32_t end_to_end_bw_in_kbps = 0;
+	uint32_t root_link_bw_in_kbps = 0;
+	uint32_t virtual_channel_bw_in_kbps = 0;
 	struct dc_dsc_bw_range bw_range = {0};
 	struct dc_dsc_config_options dsc_options = {0};
+	uint32_t stream_kbps;
 
-	/*
-	 * Consider the case with the depth of the mst topology tree is equal or less than 2
-	 * A. When dsc bitstream can be transmitted along the entire path
-	 *    1. dsc is possible between source and branch/leaf device (common dsc params is possible), AND
-	 *    2. dsc passthrough supported at MST branch, or
-	 *    3. dsc decoding supported at leaf MST device
-	 *    Use maximum dsc compression as bw constraint
-	 * B. When dsc bitstream cannot be transmitted along the entire path
-	 *    Use native bw as bw constraint
+	/* DSC unnecessary case
+	 * Check if timing could be supported within end-to-end BW
 	 */
-	if (is_dsc_common_config_possible(stream, &bw_range) &&
-	   (aconnector->mst_output_port->passthrough_aux ||
-	    aconnector->dsc_aux == &aconnector->mst_output_port->aux)) {
-		cur_link_settings = stream->link->verified_link_cap;
-		upper_link_bw_in_kbps = dc_link_bandwidth_kbps(aconnector->dc_link, &cur_link_settings);
-		down_link_bw_in_kbps = kbps_from_pbn(aconnector->mst_output_port->full_pbn);
+	stream_kbps =
+		dc_bandwidth_in_kbps_from_timing(&stream->timing,
+			dc_link_get_highest_encoding_format(stream->link));
+	cur_link_settings = stream->link->verified_link_cap;
+	root_link_bw_in_kbps = dc_link_bandwidth_kbps(aconnector->dc_link, &cur_link_settings);
+	virtual_channel_bw_in_kbps = kbps_from_pbn(aconnector->mst_output_port->full_pbn);
+
+	/* pick the end to end bw bottleneck */
+	end_to_end_bw_in_kbps = min(root_link_bw_in_kbps, virtual_channel_bw_in_kbps);
+
+	if (stream_kbps <= end_to_end_bw_in_kbps) {
+		DRM_DEBUG_DRIVER("No DSC needed. End-to-end bw sufficient.");
+		return DC_OK;
+	}
+
+	/*DSC necessary case*/
+	if (!aconnector->dsc_aux)
+		return DC_FAIL_BANDWIDTH_VALIDATE;
 
-		/* pick the end to end bw bottleneck */
-		end_to_end_bw_in_kbps = min(upper_link_bw_in_kbps, down_link_bw_in_kbps);
+	if (is_dsc_common_config_possible(stream, &bw_range)) {
 
-		if (end_to_end_bw_in_kbps < bw_range.min_kbps) {
-			DRM_DEBUG_DRIVER("maximum dsc compression cannot fit into end-to-end bandwidth\n");
+		/*capable of dsc passthough. dsc bitstream along the entire path*/
+		if (aconnector->mst_output_port->passthrough_aux) {
+			if (bw_range.min_kbps > end_to_end_bw_in_kbps) {
+				DRM_DEBUG_DRIVER("DSC passthrough. Max dsc compression can't fit into end-to-end bw\n");
 			return DC_FAIL_BANDWIDTH_VALIDATE;
-		}
+			}
+		} else {
+			/*dsc bitstream decoded at the dp last link*/
+			struct drm_dp_mst_port *immediate_upstream_port = NULL;
+			uint32_t end_link_bw = 0;
+
+			/*Get last DP link BW capability*/
+			if (dp_get_link_current_set_bw(&aconnector->mst_output_port->aux, &end_link_bw)) {
+				if (stream_kbps > end_link_bw) {
+					DRM_DEBUG_DRIVER("DSC decode at last link. Mode required bw can't fit into available bw\n");
+					return DC_FAIL_BANDWIDTH_VALIDATE;
+				}
+			}
 
-		if (end_to_end_bw_in_kbps < bw_range.stream_kbps) {
-			dc_dsc_get_default_config_option(stream->link->dc, &dsc_options);
-			dsc_options.max_target_bpp_limit_override_x16 = aconnector->base.display_info.max_dsc_bpp * 16;
-			if (dc_dsc_compute_config(stream->sink->ctx->dc->res_pool->dscs[0],
-					&stream->sink->dsc_caps.dsc_dec_caps,
-					&dsc_options,
-					end_to_end_bw_in_kbps,
-					&stream->timing,
-					dc_link_get_highest_encoding_format(stream->link),
-					&stream->timing.dsc_cfg)) {
-				stream->timing.flags.DSC = 1;
-				DRM_DEBUG_DRIVER("end-to-end bandwidth require dsc and dsc config found\n");
-			} else {
-				DRM_DEBUG_DRIVER("end-to-end bandwidth require dsc but dsc config not found\n");
-				return DC_FAIL_BANDWIDTH_VALIDATE;
+			/*Get virtual channel bandwidth between source and the link before the last link*/
+			if (aconnector->mst_output_port->parent->port_parent)
+				immediate_upstream_port = aconnector->mst_output_port->parent->port_parent;
+
+			if (immediate_upstream_port) {
+				virtual_channel_bw_in_kbps = kbps_from_pbn(immediate_upstream_port->full_pbn);
+				virtual_channel_bw_in_kbps = min(root_link_bw_in_kbps, virtual_channel_bw_in_kbps);
+				if (bw_range.min_kbps > virtual_channel_bw_in_kbps) {
+					DRM_DEBUG_DRIVER("DSC decode at last link. Max dsc compression can't fit into MST available bw\n");
+					return DC_FAIL_BANDWIDTH_VALIDATE;
+				}
 			}
 		}
-	} else {
-		/* Check if mode could be supported within max slot
-		 * number of current mst link and full_pbn of mst links.
-		 */
-		int pbn_div, slot_num, max_slot_num;
-		enum dc_link_encoding_format link_encoding;
-		uint32_t stream_kbps =
-			dc_bandwidth_in_kbps_from_timing(&stream->timing,
-				dc_link_get_highest_encoding_format(stream->link));
-
-		pbn = kbps_to_peak_pbn(stream_kbps);
-		pbn_div = dm_mst_get_pbn_divider(stream->link);
-		slot_num = DIV_ROUND_UP(pbn, pbn_div);
-
-		link_encoding = dc_link_get_highest_encoding_format(stream->link);
-		if (link_encoding == DC_LINK_ENCODING_DP_8b_10b)
-			max_slot_num = 63;
-		else if (link_encoding == DC_LINK_ENCODING_DP_128b_132b)
-			max_slot_num = 64;
-		else {
-			DRM_DEBUG_DRIVER("Invalid link encoding format\n");
-			return DC_FAIL_BANDWIDTH_VALIDATE;
-		}
 
-		if (slot_num > max_slot_num ||
-			pbn > aconnector->mst_output_port->full_pbn) {
-			DRM_DEBUG_DRIVER("Mode can not be supported within mst links!");
+		/*Confirm if we can obtain dsc config*/
+		dc_dsc_get_default_config_option(stream->link->dc, &dsc_options);
+		dsc_options.max_target_bpp_limit_override_x16 = aconnector->base.display_info.max_dsc_bpp * 16;
+		if (dc_dsc_compute_config(stream->sink->ctx->dc->res_pool->dscs[0],
+				&stream->sink->dsc_caps.dsc_dec_caps,
+				&dsc_options,
+				end_to_end_bw_in_kbps,
+				&stream->timing,
+				dc_link_get_highest_encoding_format(stream->link),
+				&stream->timing.dsc_cfg)) {
+			stream->timing.flags.DSC = 1;
+			DRM_DEBUG_DRIVER("Require dsc and dsc config found\n");
+		} else {
+			DRM_DEBUG_DRIVER("Require dsc but can't find appropriate dsc config\n");
 			return DC_FAIL_BANDWIDTH_VALIDATE;
 		}
-	}
 
-	/* check is mst dsc output bandwidth branch_overall_throughput_0_mps */
-	switch (stream->timing.pixel_encoding) {
-	case PIXEL_ENCODING_RGB:
-	case PIXEL_ENCODING_YCBCR444:
-		branch_max_throughput_mps =
-			aconnector->dc_sink->dsc_caps.dsc_dec_caps.branch_overall_throughput_0_mps;
-		break;
-	case PIXEL_ENCODING_YCBCR422:
-	case PIXEL_ENCODING_YCBCR420:
-		branch_max_throughput_mps =
-			aconnector->dc_sink->dsc_caps.dsc_dec_caps.branch_overall_throughput_1_mps;
-		break;
-	default:
-		break;
-	}
+		/* check is mst dsc output bandwidth branch_overall_throughput_0_mps */
+		switch (stream->timing.pixel_encoding) {
+		case PIXEL_ENCODING_RGB:
+		case PIXEL_ENCODING_YCBCR444:
+			branch_max_throughput_mps =
+				aconnector->dc_sink->dsc_caps.dsc_dec_caps.branch_overall_throughput_0_mps;
+			break;
+		case PIXEL_ENCODING_YCBCR422:
+		case PIXEL_ENCODING_YCBCR420:
+			branch_max_throughput_mps =
+				aconnector->dc_sink->dsc_caps.dsc_dec_caps.branch_overall_throughput_1_mps;
+			break;
+		default:
+			break;
+		}
 
-	if (branch_max_throughput_mps != 0 &&
-		((stream->timing.pix_clk_100hz / 10) >  branch_max_throughput_mps * 1000))
+		if (branch_max_throughput_mps != 0 &&
+			((stream->timing.pix_clk_100hz / 10) >  branch_max_throughput_mps * 1000)) {
+			DRM_DEBUG_DRIVER("DSC is required but max throughput mps fails");
 		return DC_FAIL_BANDWIDTH_VALIDATE;
-
+		}
+	} else {
+		DRM_DEBUG_DRIVER("DSC is required but can't find common dsc config.");
+		return DC_FAIL_BANDWIDTH_VALIDATE;
+	}
+#endif
 	return DC_OK;
 }


