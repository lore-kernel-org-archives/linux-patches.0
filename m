Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF921F955
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802D1C433C8;
	Tue,  1 Aug 2023 09:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882261;
	bh=H0tGj3e9QajFw5Qzb6rsA9a+53NAdZWBXe6wwXhvosY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LkdzQdfwZwXCR7f1O57Jl4mnWwUylxdjv/FSkwvKNubPkEE/Ytz8nc3fADxPdW1P9
	 S5OGwLQ7XJhx9yYTBNuGEz8DGx+PQLrvC3ymTgw5wL+D9WFW8uOlK3j5j6CRnidGy+
	 FD+mRKpbd3YaE3/4zm1xKoT75/yVd1m93R/yx8kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Lei <Jun.Lei@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/228] drm/amd/display: fix unbounded requesting for high pixel rate modes on dcn315
Date: Tue,  1 Aug 2023 11:18:20 +0200
Message-ID: <20230801091924.398784906@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>

[ Upstream commit 655435df0936ce2fda0d5ced7e50101179a3acfd ]

Unbounded requesting is getting configured for odm mode calculations which
is incorrect. This change checks whether mode requires odm ahead of time.

Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 49f26218c344 ("drm/amd/display: fix dcn315 single stream crb allocation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn315/dcn315_resource.c | 4 +++-
 drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.c    | 5 +++++
 drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.h    | 1 +
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn315/dcn315_resource.c b/drivers/gpu/drm/amd/display/dc/dcn315/dcn315_resource.c
index 31cbc5762eab3..19f2025cb7907 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn315/dcn315_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn315/dcn315_resource.c
@@ -1707,7 +1707,9 @@ static int dcn315_populate_dml_pipes_from_context(
 			dc->config.enable_4to1MPC = true;
 			context->bw_ctx.dml.ip.det_buffer_size_kbytes =
 					(max_usable_det / DCN3_15_CRB_SEGMENT_SIZE_KB / 4) * DCN3_15_CRB_SEGMENT_SIZE_KB;
-		} else if (!is_dual_plane(pipe->plane_state->format) && pipe->plane_state->src_rect.width <= 5120) {
+		} else if (!is_dual_plane(pipe->plane_state->format)
+				&& pipe->plane_state->src_rect.width <= 5120
+				&& pipe->stream->timing.pix_clk_100hz < dcn_get_max_non_odm_pix_rate_100hz(&dc->dml.soc)) {
 			/* Limit to 5k max to avoid forced pipe split when there is not enough detile for swath */
 			context->bw_ctx.dml.ip.det_buffer_size_kbytes = 192;
 			pipes[0].pipe.src.unbounded_req_mode = true;
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.c
index aa1c2917a4a1d..e48923f314b36 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.c
@@ -807,3 +807,8 @@ void dcn316_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_param
 	else
 		dml_init_instance(&dc->dml, &dcn3_16_soc, &dcn3_16_ip, DML_PROJECT_DCN31_FPGA);
 }
+
+int dcn_get_max_non_odm_pix_rate_100hz(struct _vcs_dpi_soc_bounding_box_st *soc)
+{
+	return soc->clock_limits[0].dispclk_mhz * 10000.0 / (1.0 + soc->dcn_downspread_percent / 100.0);
+}
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.h b/drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.h
index fd58b2561ec9e..ab8c48b8b7e05 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.h
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.h
@@ -46,5 +46,6 @@ void dcn31_calculate_wm_and_dlg_fp(
 void dcn31_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_params);
 void dcn315_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_params);
 void dcn316_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_params);
+int dcn_get_max_non_odm_pix_rate_100hz(struct _vcs_dpi_soc_bounding_box_st *soc);
 
 #endif /* __DCN31_FPU_H__*/
-- 
2.39.2



