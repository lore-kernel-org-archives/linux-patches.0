Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4026A35C1BC;
	Sat, 17 Oct 2026 16:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253822; cv=none; b=OMt+L7UWVICWn6I88WtO9xJtIN6jTVcVaKvguGtKSMRli5nblDpW9esVq5fpA0wfEWV8KZYvAsElV+CEVBRvc9j0EkHfUu7obkdLKtsORIdGVycfZz/Urrwzxrkzns8NcMSmKYqDAcXUjJOuWr3GpLlbp2Bxk9ZQRxtNckEEgx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253822; c=relaxed/simple;
	bh=3GU9lxImVo/aFCDSS3SXrZK1VxER7W//R/P8bA3ARPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYDy8XZMCohC+3ASvkfU2+zN0tWyjyavwbQrs4v1wz9AXIKAjSDlSoU792MDJ1t2Y/mgCqtD4XgXOfI1tly7Te3BoVww9pnsrXlB/kWN6w7bqTSxIFhkilnWES5ffXkw3z7RcN/q8D+AJndqaL0Gk+viSXvmBTPVqz4x/lLvgiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrcwV/Do; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrcwV/Do"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1011F000C4;
	Sat, 17 Oct 2026 16:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253821;
	bh=5ShFhOttLEPtpBytHn1/l866QrIDJQZCQeBugro1ADQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LrcwV/DoCPLLwB4L9LpmKiYw1Pc+0na/sExhs11djLUR/PNNg1sivHjqmE5aGwRCq
	 ZjhK9EgWr0QT8BddWuROllR3rwhQxADWy5xQQpXf+M17/nbiOMCyMojnEJ0hSymbbP
	 HQz6VxlQYU/mJsNaxEefXO53xbtN1VAJt109FeAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihan Zhu <yihan.zhu@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Matthew Stewart <matthew.stewart2@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 242/869] drm/amd/display: Adjust PHY FSM transition to TX_EN-to-PLL_ON for TMDS on DCN35
Date: Sat, 17 Oct 2026 17:51:23 +0200
Message-ID: <20261017160043.264607348@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 75372d75a4e23783583998ed99d5009d555850da ]

[Why]
A backport of the change made for DCN401 that addresses an issue where
we turn off the PHY PLL when disabling TMDS output, which causes the
OTG to remain stuck.

The OTG being stuck can lead to a hang in the DCHVM's ability to ACK
invalidations when it thinks the HUBP is still on but it's not receiving
global sync.

The transition to PLL_ON needs to be atomic as there's no guarantee
that the thread isn't pre-empted or is able to complete before the
IOMMU watchdog times out.

[How]
Backport the implementation from dcn401 back to dcn35.

There's a functional difference in when the eDP output is disabled in
dcn401 code so we don't want to utilize it directly.

Reviewed-by: Yihan Zhu <yihan.zhu@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Matthew Stewart <matthew.stewart2@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/hwss/dcn35/dcn35_hwseq.c   | 52 +++++++++++++++++++
 .../amd/display/dc/hwss/dcn35/dcn35_hwseq.h   |  4 ++
 .../amd/display/dc/hwss/dcn35/dcn35_init.c    |  2 +-
 3 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
index c739e5b2c5595..0745980483898 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
@@ -1617,3 +1617,55 @@ bool dcn35_is_dp_dig_pixel_rate_div_policy(struct pipe_ctx *pipe_ctx)
 
 	return false;
 }
+
+static void disable_link_output_symclk_on_tx_off(struct dc_link *link, enum dp_link_encoding link_encoding)
+{
+	struct dc *dc = link->ctx->dc;
+	struct pipe_ctx *pipe_ctx = NULL;
+	uint8_t i;
+
+	for (i = 0; i < MAX_PIPES; i++) {
+		pipe_ctx = &dc->current_state->res_ctx.pipe_ctx[i];
+		if (pipe_ctx->stream && pipe_ctx->stream->link == link && pipe_ctx->top_pipe == NULL) {
+			pipe_ctx->clock_source->funcs->program_pix_clk(
+					pipe_ctx->clock_source,
+					&pipe_ctx->stream_res.pix_clk_params,
+					link_encoding,
+					&pipe_ctx->pll_settings);
+			break;
+		}
+	}
+}
+
+void dcn35_disable_link_output(struct dc_link *link,
+		const struct link_resource *link_res,
+		enum signal_type signal)
+{
+	struct dc *dc = link->ctx->dc;
+	const struct link_hwss *link_hwss = get_link_hwss(link, link_res);
+	struct dmcu *dmcu = dc->res_pool->dmcu;
+
+	if (signal == SIGNAL_TYPE_EDP &&
+			link->dc->hwss.edp_backlight_control &&
+			!link->skip_implict_edp_power_control)
+		link->dc->hwss.edp_backlight_control(link, false);
+	else if (dmcu != NULL && dmcu->funcs->lock_phy)
+		dmcu->funcs->lock_phy(dmcu);
+
+	if (dc_is_tmds_signal(signal) && link->phy_state.symclk_ref_cnts.otg > 0) {
+		disable_link_output_symclk_on_tx_off(link, DP_UNKNOWN_ENCODING);
+		link->phy_state.symclk_state = SYMCLK_ON_TX_OFF;
+	} else {
+		link_hwss->disable_link_output(link, link_res, signal);
+		link->phy_state.symclk_state = SYMCLK_OFF_TX_OFF;
+	}
+	/*
+	 * Add the logic to extract BOTH power up and power down sequences
+	 * from enable/disable link output and only call edp panel control
+	 * in enable_link_dp and disable_link_dp once.
+	 */
+	if (dmcu != NULL && dmcu->funcs->unlock_phy)
+		dmcu->funcs->unlock_phy(dmcu);
+
+	dc->link_srv->dp_trace_source_sequence(link, DPCD_SOURCE_SEQ_AFTER_DISABLE_LINK_PHY);
+}
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.h b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.h
index e27b3609020ff..45e762f99119f 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.h
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.h
@@ -99,4 +99,8 @@ void dcn35_set_long_vblank(struct pipe_ctx **pipe_ctx,
 
 bool dcn35_is_dp_dig_pixel_rate_div_policy(struct pipe_ctx *pipe_ctx);
 
+void dcn35_disable_link_output(struct dc_link *link,
+		const struct link_resource *link_res,
+		enum signal_type signal);
+
 #endif /* __DC_HWSS_DCN35_H__ */
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_init.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_init.c
index 2bbf1fef94fd2..e34f292f5c41a 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_init.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_init.c
@@ -107,7 +107,7 @@ static const struct hw_sequencer_funcs dcn35_funcs = {
 	.enable_lvds_link_output = dce110_enable_lvds_link_output,
 	.enable_tmds_link_output = dce110_enable_tmds_link_output,
 	.enable_dp_link_output = dce110_enable_dp_link_output,
-	.disable_link_output = dcn32_disable_link_output,
+	.disable_link_output = dcn35_disable_link_output,
 	.z10_restore = dcn35_z10_restore,
 	.z10_save_init = dcn31_z10_save_init,
 	.set_disp_pattern_generator = dcn30_set_disp_pattern_generator,
-- 
2.53.0



