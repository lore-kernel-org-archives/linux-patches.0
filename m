Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029321642F;
	Sat,  3 Feb 2024 04:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933849; cv=none; b=FMZV+VSOASNrOv57XVVdgJbXXWPzZIxujyQMxOwTEN7O3QCo2W316E8S4nyL9O6sqCtOcuXX2ndPUz5C1klOMjUWlW1p7UtLQvXGXYw+Miog3FPlD9v1uEiPGO7V3FDH2KoV6i7/nK7H+oqm0OB64hQui/thSq2bb8c/D2BDKDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933849; c=relaxed/simple;
	bh=XGf+q+pH1mqkodC28+8E9QQW5BWDrpMjUxENR+JlgEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qdCx5ljRqm7gYjculOlOUcsJvqLM1KzqQF6g9C2OEkilkHFFVPEyktvXMrr1XBoKVBjmAaEz4n4cskDLjI29HN39I7agsVEWxFedCo+wB1wOh64w+qI0TwWnMXqkT0XdT3HoYQFZbSJ1TqLSDSRcx3B0vPzAxOGmQ54XS8zpZn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0fB1Fti5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0fB1Fti5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1164C433A6;
	Sat,  3 Feb 2024 04:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933848;
	bh=XGf+q+pH1mqkodC28+8E9QQW5BWDrpMjUxENR+JlgEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0fB1Fti5DLa+EQfYc6Kxaannyipa0FJjsQs0UISDxb3ggal1ZABYX2kwM0WzXiBWn
	 FUn851M/MBjKbbuibRraHHmQORl4FZFWW6mdG/R9NlVcXmkP1speR1xISAYMofEClP
	 /veNwx4pVYGjmTprwNc7lJpxcvovHGnLzuc7nzfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Chaitanya Dhere <chaitanya.dhere@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 178/353] drm/amd/display: add support for DTO genarated dscclk
Date: Fri,  2 Feb 2024 20:04:56 -0800
Message-ID: <20240203035409.285186310@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenjing Liu <wenjing.liu@amd.com>

[ Upstream commit 08a32addf17317b9fac55be9b31275cbf6e41fb7 ]

Current implementation will choose to use refclk as dscclk. This is not
recommended by hardware team as refclk is a fixed value which could
cause unnecessary power consumption or it could be not enough for large
DSC timings. So we are adding new interfaces so we could switch to use
dynamically generated DSCCLK by DTO. So DSCCLK is programmable based on
current pixel clock and dispclk.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Chaitanya Dhere <chaitanya.dhere@amd.com>
Acked-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/hwss/dcn32/dcn32_hwseq.c   | 25 +++++++++++++++++
 drivers/gpu/drm/amd/display/dc/inc/hw/dccg.h  |  4 +++
 .../gpu/drm/amd/display/dc/link/link_dpms.c   | 27 ++++++++++++++++++-
 3 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
index 5bf9e7c1e052..cb9d8389329f 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
@@ -995,9 +995,22 @@ static int calc_mpc_flow_ctrl_cnt(const struct dc_stream_state *stream,
 static void update_dsc_on_stream(struct pipe_ctx *pipe_ctx, bool enable)
 {
 	struct display_stream_compressor *dsc = pipe_ctx->stream_res.dsc;
+	struct dc *dc = pipe_ctx->stream->ctx->dc;
 	struct dc_stream_state *stream = pipe_ctx->stream;
 	struct pipe_ctx *odm_pipe;
 	int opp_cnt = 1;
+	struct dccg *dccg = dc->res_pool->dccg;
+	/* It has been found that when DSCCLK is lower than 16Mhz, we will get DCN
+	 * register access hung. When DSCCLk is based on refclk, DSCCLk is always a
+	 * fixed value higher than 16Mhz so the issue doesn't occur. When DSCCLK is
+	 * generated by DTO, DSCCLK would be based on 1/3 dispclk. For small timings
+	 * with DSC such as 480p60Hz, the dispclk could be low enough to trigger
+	 * this problem. We are implementing a workaround here to keep using dscclk
+	 * based on fixed value refclk when timing is smaller than 3x16Mhz (i.e
+	 * 48Mhz) pixel clock to avoid hitting this problem.
+	 */
+	bool should_use_dto_dscclk = (dccg->funcs->set_dto_dscclk != NULL) &&
+			stream->timing.pix_clk_100hz > 480000;
 
 	ASSERT(dsc);
 	for (odm_pipe = pipe_ctx->next_odm_pipe; odm_pipe; odm_pipe = odm_pipe->next_odm_pipe)
@@ -1020,12 +1033,16 @@ static void update_dsc_on_stream(struct pipe_ctx *pipe_ctx, bool enable)
 
 		dsc->funcs->dsc_set_config(dsc, &dsc_cfg, &dsc_optc_cfg);
 		dsc->funcs->dsc_enable(dsc, pipe_ctx->stream_res.opp->inst);
+		if (should_use_dto_dscclk)
+			dccg->funcs->set_dto_dscclk(dccg, dsc->inst);
 		for (odm_pipe = pipe_ctx->next_odm_pipe; odm_pipe; odm_pipe = odm_pipe->next_odm_pipe) {
 			struct display_stream_compressor *odm_dsc = odm_pipe->stream_res.dsc;
 
 			ASSERT(odm_dsc);
 			odm_dsc->funcs->dsc_set_config(odm_dsc, &dsc_cfg, &dsc_optc_cfg);
 			odm_dsc->funcs->dsc_enable(odm_dsc, odm_pipe->stream_res.opp->inst);
+			if (should_use_dto_dscclk)
+				dccg->funcs->set_dto_dscclk(dccg, odm_dsc->inst);
 		}
 		dsc_cfg.dc_dsc_cfg.num_slices_h *= opp_cnt;
 		dsc_cfg.pic_width *= opp_cnt;
@@ -1045,9 +1062,13 @@ static void update_dsc_on_stream(struct pipe_ctx *pipe_ctx, bool enable)
 				OPTC_DSC_DISABLED, 0, 0);
 
 		/* disable DSC block */
+		if (dccg->funcs->set_ref_dscclk)
+			dccg->funcs->set_ref_dscclk(dccg, pipe_ctx->stream_res.dsc->inst);
 		dsc->funcs->dsc_disable(pipe_ctx->stream_res.dsc);
 		for (odm_pipe = pipe_ctx->next_odm_pipe; odm_pipe; odm_pipe = odm_pipe->next_odm_pipe) {
 			ASSERT(odm_pipe->stream_res.dsc);
+			if (dccg->funcs->set_ref_dscclk)
+				dccg->funcs->set_ref_dscclk(dccg, odm_pipe->stream_res.dsc->inst);
 			odm_pipe->stream_res.dsc->funcs->dsc_disable(odm_pipe->stream_res.dsc);
 		}
 	}
@@ -1130,6 +1151,10 @@ void dcn32_update_odm(struct dc *dc, struct dc_state *context, struct pipe_ctx *
 		if (!pipe_ctx->next_odm_pipe && current_pipe_ctx->next_odm_pipe &&
 				current_pipe_ctx->next_odm_pipe->stream_res.dsc) {
 			struct display_stream_compressor *dsc = current_pipe_ctx->next_odm_pipe->stream_res.dsc;
+			struct dccg *dccg = dc->res_pool->dccg;
+
+			if (dccg->funcs->set_ref_dscclk)
+				dccg->funcs->set_ref_dscclk(dccg, dsc->inst);
 			/* disconnect DSC block from stream */
 			dsc->funcs->dsc_disconnect(dsc);
 		}
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw/dccg.h b/drivers/gpu/drm/amd/display/dc/inc/hw/dccg.h
index ce2f0c0e82bd..6b44557fcb1a 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/dccg.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/dccg.h
@@ -201,6 +201,10 @@ struct dccg_funcs {
 			struct dccg *dccg,
 			enum streamclk_source src,
 			uint32_t otg_inst);
+	void (*set_dto_dscclk)(
+			struct dccg *dccg,
+			uint32_t dsc_inst);
+	void (*set_ref_dscclk)(struct dccg *dccg, uint32_t dsc_inst);
 };
 
 #endif //__DAL_DCCG_H__
diff --git a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
index d28564b1b28a..a08ae59c1ea9 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
@@ -776,10 +776,26 @@ static bool dp_set_dsc_on_rx(struct pipe_ctx *pipe_ctx, bool enable)
  */
 void link_set_dsc_on_stream(struct pipe_ctx *pipe_ctx, bool enable)
 {
+	/* TODO: Move this to HWSS as this is hardware programming sequence not a
+	 * link layer sequence
+	 */
 	struct display_stream_compressor *dsc = pipe_ctx->stream_res.dsc;
+	struct dc *dc = pipe_ctx->stream->ctx->dc;
 	struct dc_stream_state *stream = pipe_ctx->stream;
 	struct pipe_ctx *odm_pipe;
 	int opp_cnt = 1;
+	struct dccg *dccg = dc->res_pool->dccg;
+	/* It has been found that when DSCCLK is lower than 16Mhz, we will get DCN
+	 * register access hung. When DSCCLk is based on refclk, DSCCLk is always a
+	 * fixed value higher than 16Mhz so the issue doesn't occur. When DSCCLK is
+	 * generated by DTO, DSCCLK would be based on 1/3 dispclk. For small timings
+	 * with DSC such as 480p60Hz, the dispclk could be low enough to trigger
+	 * this problem. We are implementing a workaround here to keep using dscclk
+	 * based on fixed value refclk when timing is smaller than 3x16Mhz (i.e
+	 * 48Mhz) pixel clock to avoid hitting this problem.
+	 */
+	bool should_use_dto_dscclk = (dccg->funcs->set_dto_dscclk != NULL) &&
+			stream->timing.pix_clk_100hz > 480000;
 	DC_LOGGER_INIT(dsc->ctx->logger);
 
 	for (odm_pipe = pipe_ctx->next_odm_pipe; odm_pipe; odm_pipe = odm_pipe->next_odm_pipe)
@@ -802,11 +818,15 @@ void link_set_dsc_on_stream(struct pipe_ctx *pipe_ctx, bool enable)
 
 		dsc->funcs->dsc_set_config(dsc, &dsc_cfg, &dsc_optc_cfg);
 		dsc->funcs->dsc_enable(dsc, pipe_ctx->stream_res.opp->inst);
+		if (should_use_dto_dscclk)
+			dccg->funcs->set_dto_dscclk(dccg, dsc->inst);
 		for (odm_pipe = pipe_ctx->next_odm_pipe; odm_pipe; odm_pipe = odm_pipe->next_odm_pipe) {
 			struct display_stream_compressor *odm_dsc = odm_pipe->stream_res.dsc;
 
 			odm_dsc->funcs->dsc_set_config(odm_dsc, &dsc_cfg, &dsc_optc_cfg);
 			odm_dsc->funcs->dsc_enable(odm_dsc, odm_pipe->stream_res.opp->inst);
+			if (should_use_dto_dscclk)
+				dccg->funcs->set_dto_dscclk(dccg, odm_dsc->inst);
 		}
 		dsc_cfg.dc_dsc_cfg.num_slices_h *= opp_cnt;
 		dsc_cfg.pic_width *= opp_cnt;
@@ -856,9 +876,14 @@ void link_set_dsc_on_stream(struct pipe_ctx *pipe_ctx, bool enable)
 		}
 
 		/* disable DSC block */
+		if (dccg->funcs->set_ref_dscclk)
+			dccg->funcs->set_ref_dscclk(dccg, pipe_ctx->stream_res.dsc->inst);
 		pipe_ctx->stream_res.dsc->funcs->dsc_disable(pipe_ctx->stream_res.dsc);
-		for (odm_pipe = pipe_ctx->next_odm_pipe; odm_pipe; odm_pipe = odm_pipe->next_odm_pipe)
+		for (odm_pipe = pipe_ctx->next_odm_pipe; odm_pipe; odm_pipe = odm_pipe->next_odm_pipe) {
+			if (dccg->funcs->set_ref_dscclk)
+				dccg->funcs->set_ref_dscclk(dccg, odm_pipe->stream_res.dsc->inst);
 			odm_pipe->stream_res.dsc->funcs->dsc_disable(odm_pipe->stream_res.dsc);
+		}
 	}
 }
 
-- 
2.43.0



