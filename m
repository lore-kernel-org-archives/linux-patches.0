Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDA34F392E;
	Tue, 13 Oct 2026 12:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893298; cv=none; b=X5LvXoejNVgQ/QemMuLEaTcKj6XjUv4gFkUHwUcY/MYwmz4xx9onQpStxsI9If0iwZJ4NBHkni938VrmeEMCScYgGoxowV12Zc2ZJHsUEHA5SLyUS2w3lLy9Ishbne/Zd4e9Xn6aMZBU97QiAEy3D6mpEkE9E18FVFmyZd4nXhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893298; c=relaxed/simple;
	bh=wVhvEu5hZ3bkDEciJnkKVdwvT+DGPTOe/kJ8WZePnr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CS7PzQke7YcSvqdwx66qBckY6XKuZ9VkfZY/SaI2QY9zJjIhP9+g9Y8AxrYbnetXBpHxcHHl91FJR69+yPHKHCyeWX3IPH2GIjFSvEu4tEL8hEkYndVydOnXjLAqCold3/K5pV8m1oQYWb7cIvwJAlRqV7dOhQYVCwdnjaXuBNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VPeiizxA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VPeiizxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA791F000FF;
	Tue, 13 Oct 2026 12:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893297;
	bh=mdrDcJNtjeaYYaSZh6rVNJakqLeW5/zWZ9RcQzfuYQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VPeiizxADEZ4yGa+GIWie3963MDrf5/BpA1qdlyQqEzMbW7dPXD7aO0JssBXp9wXV
	 Vp4yhyH2kN7fbgCIjsrHAbgw/ptrhUuG9Jgc4Yx3dICqwea2ZHSVke1DqGw5Ab3WsL
	 wTctPphiJO8K2RkCLr2Uq0dm8AUT46Xd7X6HoOkc=
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
Subject: [PATCH 6.18 179/621] drm/amd/display: Adjust PHY FSM transition to TX_EN-to-PLL_ON for TMDS on DCN35
Date: Tue, 13 Oct 2026 13:32:54 +0200
Message-ID: <20261013112925.109849883@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 05011061822cf..8688ed4d72803 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
@@ -1592,3 +1592,55 @@ void dcn35_hardware_release(struct dc *dc)
 	if (dc->hwss.hw_block_power_up)
 		dc->hwss.hw_block_power_up(dc, &pg_update_state);
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
index 0b1d6f608edd7..7e4f4eeb47501 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.h
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.h
@@ -101,4 +101,8 @@ bool dcn35_is_dp_dig_pixel_rate_div_policy(struct pipe_ctx *pipe_ctx);
 
 void dcn35_hardware_release(struct dc *dc);
 
+void dcn35_disable_link_output(struct dc_link *link,
+		const struct link_resource *link_res,
+		enum signal_type signal);
+
 #endif /* __DC_HWSS_DCN35_H__ */
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_init.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_init.c
index f2f16a0bdb4f3..a3bcfc13aa92f 100644
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



