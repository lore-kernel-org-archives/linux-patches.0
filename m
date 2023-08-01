Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD6B1F953
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E50FC433C7;
	Tue,  1 Aug 2023 09:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882902;
	bh=6fjvUkJrBH9rmTv+vUIgZ0y0rt5DVGj5dB+mQfLmuIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g2t/VLocAEvA79y/Pkx8DCPJmDOjFAwhmUqWNPYfGIJgo7M+jdJELGZ7FV01rTA2a
	 nMdgq7Scff/YvWqa2mjswLkoQUZtTv8F+HgKh+9V1ySUJeg42SQWFkh/o4uwg3Cd2l
	 E5d11w2Yls0gnIVWAvsQoehoov9G/kD2JfKEQLzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Lei <jun.lei@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Miess <daniel.miess@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 044/239] drm/amd/display: Fix possible underflow for displays with large vblank
Date: Tue,  1 Aug 2023 11:18:28 +0200
Message-ID: <20230801091927.162996487@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Miess <daniel.miess@amd.com>

[ Upstream commit 1a4bcdbea4319efeb26cc4b05be859a7867e02dc ]

[Why]
Underflow observed when using a display with a large vblank region
and low refresh rate

[How]
Simplify calculation of vblank_nom

Increase value for VBlankNomDefaultUS to 800us

Reviewed-by: Jun Lei <jun.lei@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Daniel Miess <daniel.miess@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 2a9482e55968 ("drm/amd/display: Prevent vtotal from being set to 0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/dml/dcn314/dcn314_fpu.c    | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c
index 1d00eb9e73c62..554152371eb53 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c
@@ -33,7 +33,7 @@
 #include "dml/display_mode_vba.h"
 
 struct _vcs_dpi_ip_params_st dcn3_14_ip = {
-	.VBlankNomDefaultUS = 668,
+	.VBlankNomDefaultUS = 800,
 	.gpuvm_enable = 1,
 	.gpuvm_max_page_table_levels = 1,
 	.hostvm_enable = 1,
@@ -286,7 +286,7 @@ int dcn314_populate_dml_pipes_from_context_fpu(struct dc *dc, struct dc_state *c
 	struct resource_context *res_ctx = &context->res_ctx;
 	struct pipe_ctx *pipe;
 	bool upscaled = false;
-	bool isFreesyncVideo = false;
+	const unsigned int max_allowed_vblank_nom = 1023;
 
 	dc_assert_fp_enabled();
 
@@ -300,16 +300,11 @@ int dcn314_populate_dml_pipes_from_context_fpu(struct dc *dc, struct dc_state *c
 		pipe = &res_ctx->pipe_ctx[i];
 		timing = &pipe->stream->timing;
 
-		isFreesyncVideo = pipe->stream->adjust.v_total_max == pipe->stream->adjust.v_total_min;
-		isFreesyncVideo = isFreesyncVideo && pipe->stream->adjust.v_total_min > timing->v_total;
-
-		if (!isFreesyncVideo) {
-			pipes[pipe_cnt].pipe.dest.vblank_nom =
-				dcn3_14_ip.VBlankNomDefaultUS / (timing->h_total / (timing->pix_clk_100hz / 10000.0));
-		} else {
-			pipes[pipe_cnt].pipe.dest.vtotal = pipe->stream->adjust.v_total_min;
-			pipes[pipe_cnt].pipe.dest.vblank_nom = timing->v_total - pipes[pipe_cnt].pipe.dest.vactive;
-		}
+		pipes[pipe_cnt].pipe.dest.vtotal = pipe->stream->adjust.v_total_min;
+		pipes[pipe_cnt].pipe.dest.vblank_nom = timing->v_total - pipes[pipe_cnt].pipe.dest.vactive;
+		pipes[pipe_cnt].pipe.dest.vblank_nom = min(pipes[pipe_cnt].pipe.dest.vblank_nom, dcn3_14_ip.VBlankNomDefaultUS);
+		pipes[pipe_cnt].pipe.dest.vblank_nom = max(pipes[pipe_cnt].pipe.dest.vblank_nom, timing->v_sync_width);
+		pipes[pipe_cnt].pipe.dest.vblank_nom = min(pipes[pipe_cnt].pipe.dest.vblank_nom, max_allowed_vblank_nom);
 
 		if (pipe->plane_state &&
 				(pipe->plane_state->src_rect.height < pipe->plane_state->dst_rect.height ||
-- 
2.39.2



