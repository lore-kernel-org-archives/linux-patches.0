Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DAF12EBEA;
	Tue, 25 Jun 2024 09:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308692; cv=none; b=jaEsoKjzSu3DluiGEfIcIRNgIgDwXcOLEGAv0RhZ2cUz4FhhUfr+vEMPbRuCg24DCxF2J5SFM5PC2rZQORR3R7Dkmxpl270yey7FcFTVFstTEtaVl+QLclSKTKW41wlwZPQOwoU2EaAzVZZjaAWODEjrtX/d2VM6ta70pKs51Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308692; c=relaxed/simple;
	bh=dY9GQo6t6p9mrCX16qlGRgma/Bh9UCWzGEm4avuAd0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEZ6TCCIRRZ9j34WJYF9Ww8E1pStnYRbnO4sHsWkZpar+RP2ZBZCk+jc89DU7VGlASPwuaoeoJUi4D/hcboF0bFXiwZDgBASLAouSStJ9+LyBaerBTASRh3igSv1ZOoSa00L6SeM3lK6RZEK3P9W4EMWWIdbcJsXY/IyO2FkV1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hy78bJ85; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hy78bJ85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956AFC32781;
	Tue, 25 Jun 2024 09:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308692;
	bh=dY9GQo6t6p9mrCX16qlGRgma/Bh9UCWzGEm4avuAd0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hy78bJ85M4UnChwcrkFqdXQbOMWY6WRA6ceCR+egcdX0H6cY3tjv9nxNc4GmHTQms
	 DIoHodC/rS044m612iFbu+94bEo20P3RP7H3KWdDDwAx2ETe5xD51MQ+iSccHCzd+N
	 how4T5g48dwxl1U4+AuAwKRmaLo3oYRpKg4bmSCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjing Liu <wenjing.liu@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Michael Strauss <michael.strauss@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.9 208/250] drm/amd/display: Attempt to avoid empty TUs when endpoint is DPIA
Date: Tue, 25 Jun 2024 11:32:46 +0200
Message-ID: <20240625085556.037705662@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Strauss <michael.strauss@amd.com>

commit c03d770c0b014a3007a5874bf6b3c3e64d32aaac upstream.

[WHY]
Empty SST TUs are illegal to transmit over a USB4 DP tunnel.
Current policy is to configure stream encoder to pack 2 pixels per pclk
even when ODM combine is not in use, allowing seamless dynamic ODM
reconfiguration. However, in extreme edge cases where average pixel
count per TU is less than 2, this can lead to unexpected empty TU
generation during compliance testing. For example, VIC 1 with a 1xHBR3
link configuration will average 1.98 pix/TU.

[HOW]
Calculate average pixel count per TU, and block 2 pixels per clock if
endpoint is a DPIA tunnel and pixel clock is low enough that we will
never require 2:1 ODM combine.

Cc: stable@vger.kernel.org # 6.6+
Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Michael Strauss <michael.strauss@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c |   72 ++++++++++++++++
 drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.h |    2 
 drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_init.c  |    2 
 3 files changed, 75 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
@@ -1373,3 +1373,75 @@ void dcn35_set_static_screen_control(str
 			set_static_screen_control(pipe_ctx[i]->stream_res.tg,
 					triggers, params->num_frames);
 }
+
+static bool should_avoid_empty_tu(struct pipe_ctx *pipe_ctx)
+{
+	/* Calculate average pixel count per TU, return false if under ~2.00 to
+	 * avoid empty TUs. This is only required for DPIA tunneling as empty TUs
+	 * are legal to generate for native DP links. Assume TU size 64 as there
+	 * is currently no scenario where it's reprogrammed from HW default.
+	 * MTPs have no such limitation, so this does not affect MST use cases.
+	 */
+	unsigned int pix_clk_mhz;
+	unsigned int symclk_mhz;
+	unsigned int avg_pix_per_tu_x1000;
+	unsigned int tu_size_bytes = 64;
+	struct dc_crtc_timing *timing = &pipe_ctx->stream->timing;
+	struct dc_link_settings *link_settings = &pipe_ctx->link_config.dp_link_settings;
+	const struct dc *dc = pipe_ctx->stream->link->dc;
+
+	if (pipe_ctx->stream->link->ep_type != DISPLAY_ENDPOINT_USB4_DPIA)
+		return false;
+
+	// Not necessary for MST configurations
+	if (pipe_ctx->stream->signal == SIGNAL_TYPE_DISPLAY_PORT_MST)
+		return false;
+
+	pix_clk_mhz = timing->pix_clk_100hz / 10000;
+
+	// If this is true, can't block due to dynamic ODM
+	if (pix_clk_mhz > dc->clk_mgr->bw_params->clk_table.entries[0].dispclk_mhz)
+		return false;
+
+	switch (link_settings->link_rate) {
+	case LINK_RATE_LOW:
+		symclk_mhz = 162;
+		break;
+	case LINK_RATE_HIGH:
+		symclk_mhz = 270;
+		break;
+	case LINK_RATE_HIGH2:
+		symclk_mhz = 540;
+		break;
+	case LINK_RATE_HIGH3:
+		symclk_mhz = 810;
+		break;
+	default:
+		// We shouldn't be tunneling any other rates, something is wrong
+		ASSERT(0);
+		return false;
+	}
+
+	avg_pix_per_tu_x1000 = (1000 * pix_clk_mhz * tu_size_bytes)
+		/ (symclk_mhz * link_settings->lane_count);
+
+	// Add small empirically-decided margin to account for potential jitter
+	return (avg_pix_per_tu_x1000 < 2020);
+}
+
+bool dcn35_is_dp_dig_pixel_rate_div_policy(struct pipe_ctx *pipe_ctx)
+{
+	struct dc *dc = pipe_ctx->stream->ctx->dc;
+
+	if (!is_h_timing_divisible_by_2(pipe_ctx->stream))
+		return false;
+
+	if (should_avoid_empty_tu(pipe_ctx))
+		return false;
+
+	if (dc_is_dp_signal(pipe_ctx->stream->signal) && !dc->link_srv->dp_is_128b_132b_signal(pipe_ctx) &&
+		dc->debug.enable_dp_dig_pixel_rate_div_policy)
+		return true;
+
+	return false;
+}
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.h
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.h
@@ -93,4 +93,6 @@ void dcn35_set_drr(struct pipe_ctx **pip
 void dcn35_set_static_screen_control(struct pipe_ctx **pipe_ctx,
 		int num_pipes, const struct dc_static_screen_params *params);
 
+bool dcn35_is_dp_dig_pixel_rate_div_policy(struct pipe_ctx *pipe_ctx);
+
 #endif /* __DC_HWSS_DCN35_H__ */
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_init.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_init.c
@@ -158,7 +158,7 @@ static const struct hwseq_private_funcs
 	.setup_hpo_hw_control = dcn35_setup_hpo_hw_control,
 	.calculate_dccg_k1_k2_values = dcn32_calculate_dccg_k1_k2_values,
 	.set_pixels_per_cycle = dcn32_set_pixels_per_cycle,
-	.is_dp_dig_pixel_rate_div_policy = dcn32_is_dp_dig_pixel_rate_div_policy,
+	.is_dp_dig_pixel_rate_div_policy = dcn35_is_dp_dig_pixel_rate_div_policy,
 	.dsc_pg_control = dcn35_dsc_pg_control,
 	.dsc_pg_status = dcn32_dsc_pg_status,
 	.enable_plane = dcn35_enable_plane,


