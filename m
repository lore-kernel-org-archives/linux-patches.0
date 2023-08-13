Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B259446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:34:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B957C433C7;
	Sun, 13 Aug 2023 21:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962488;
	bh=EPmYavWQM+CvgmCbcBm7aPBQpmrKNVRDLUDkolzPP1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kqDEMPs3KmD/GxZnz1V6xhc42gGsxnq95pwVMDnR5CxVFSe9qaZawwYbuzBmqmxXP
	 WM7TnX/EqNZ2wIt9dw1nPV3L/vpER2NYl92Jyt+eLgI/80dS1gEM3uetgWCeDM06Z7
	 d5BYVQtFP3ar6xVFzhrQ6PPwNpdSNH3h9TmRMjvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Lei <Jun.Lei@amd.com>,
	Alan Liu <HaoPing.Liu@amd.com>,
	Alvin Lee <Alvin.Lee2@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.1 047/149] drm/amd/display: Disable phantom OTG after enable for plane disable
Date: Sun, 13 Aug 2023 23:18:12 +0200
Message-ID: <20230813211720.224501516@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alvin Lee <Alvin.Lee2@amd.com>

commit dc55b106ad477c67f969f3432d9070c6846fb557 upstream

[Description]
- Need to disable phantom OTG after it's enabled
  in order to restore it to it's original state.
- If it's enabled and then an MCLK switch comes in
  we may not prefetch the correct data since the phantom
  OTG could already be in the middle of the frame.

Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Alan Liu <HaoPing.Liu@amd.com>
Signed-off-by: Alvin Lee <Alvin.Lee2@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c                 |   14 +++++++++++++-
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c        |    8 ++++++++
 drivers/gpu/drm/amd/display/dc/inc/hw/timing_generator.h |    1 +
 3 files changed, 22 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1079,6 +1079,7 @@ static void disable_dangling_plane(struc
 	struct dc_state *dangling_context = dc_create_state(dc);
 	struct dc_state *current_ctx;
 	struct pipe_ctx *pipe;
+	struct timing_generator *tg;
 
 	if (dangling_context == NULL)
 		return;
@@ -1122,6 +1123,7 @@ static void disable_dangling_plane(struc
 
 		if (should_disable && old_stream) {
 			pipe = &dc->current_state->res_ctx.pipe_ctx[i];
+			tg = pipe->stream_res.tg;
 			/* When disabling plane for a phantom pipe, we must turn on the
 			 * phantom OTG so the disable programming gets the double buffer
 			 * update. Otherwise the pipe will be left in a partially disabled
@@ -1129,7 +1131,8 @@ static void disable_dangling_plane(struc
 			 * again for different use.
 			 */
 			if (old_stream->mall_stream_config.type == SUBVP_PHANTOM) {
-				pipe->stream_res.tg->funcs->enable_crtc(pipe->stream_res.tg);
+				if (tg->funcs->enable_crtc)
+					tg->funcs->enable_crtc(tg);
 			}
 			dc_rem_all_planes_for_stream(dc, old_stream, dangling_context);
 			disable_all_writeback_pipes_for_stream(dc, old_stream, dangling_context);
@@ -1146,6 +1149,15 @@ static void disable_dangling_plane(struc
 				dc->hwss.interdependent_update_lock(dc, dc->current_state, false);
 				dc->hwss.post_unlock_program_front_end(dc, dangling_context);
 			}
+			/* We need to put the phantom OTG back into it's default (disabled) state or we
+			 * can get corruption when transition from one SubVP config to a different one.
+			 * The OTG is set to disable on falling edge of VUPDATE so the plane disable
+			 * will still get it's double buffer update.
+			 */
+			if (old_stream->mall_stream_config.type == SUBVP_PHANTOM) {
+				if (tg->funcs->disable_phantom_crtc)
+					tg->funcs->disable_phantom_crtc(tg);
+			}
 		}
 	}
 
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
@@ -167,6 +167,13 @@ static void optc32_phantom_crtc_post_ena
 	REG_WAIT(OTG_CLOCK_CONTROL, OTG_BUSY, 0, 1, 100000);
 }
 
+static void optc32_disable_phantom_otg(struct timing_generator *optc)
+{
+	struct optc *optc1 = DCN10TG_FROM_TG(optc);
+
+	REG_UPDATE(OTG_CONTROL, OTG_MASTER_EN, 0);
+}
+
 static void optc32_set_odm_bypass(struct timing_generator *optc,
 		const struct dc_crtc_timing *dc_crtc_timing)
 {
@@ -260,6 +267,7 @@ static struct timing_generator_funcs dcn
 		.enable_crtc = optc32_enable_crtc,
 		.disable_crtc = optc32_disable_crtc,
 		.phantom_crtc_post_enable = optc32_phantom_crtc_post_enable,
+		.disable_phantom_crtc = optc32_disable_phantom_otg,
 		/* used by enable_timing_synchronization. Not need for FPGA */
 		.is_counter_moving = optc1_is_counter_moving,
 		.get_position = optc1_get_position,
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/timing_generator.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/timing_generator.h
@@ -184,6 +184,7 @@ struct timing_generator_funcs {
 	bool (*disable_crtc)(struct timing_generator *tg);
 #ifdef CONFIG_DRM_AMD_DC_DCN
 	void (*phantom_crtc_post_enable)(struct timing_generator *tg);
+	void (*disable_phantom_crtc)(struct timing_generator *tg);
 #endif
 	bool (*immediate_disable_crtc)(struct timing_generator *tg);
 	bool (*is_counter_moving)(struct timing_generator *tg);


