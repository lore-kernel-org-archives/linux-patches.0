Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583961FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD591C433C7;
	Tue,  1 Aug 2023 09:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882958;
	bh=PJ8vPfA4wTvmLgfmcJRNRpw38qb5HDJeeo5EHd5rInw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cTpSJy4A/9FAZa1Gtj9zQJd5lKpWRuymRuC8DSlyEtKeENlF4xXJ1CDF9zaXRqIni
	 nLWF9nrQQYdVoePxZkVvS7XifAyw46raGKg25lR1DCHGJ149VUWBxyxDyXw2SFvYtd
	 g9hXQeX7/lnDP7Zd4doEoaIMO4t7w9WR0mB5aE34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Stylon Wang <stylon.wang@amd.com>,
	Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>,
	Charlene Liu <Charlene.Liu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 035/239] drm/amd/display: fix dcn315 single stream crb allocation
Date: Tue,  1 Aug 2023 11:18:19 +0200
Message-ID: <20230801091926.864394157@linuxfoundation.org>
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

From: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>

[ Upstream commit 49f26218c344741cb3eaa740b1e44e960551a87f ]

Change to improve avoiding asymetric crb calculations for single stream
scenarios.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Acked-by: Stylon Wang <stylon.wang@amd.com>
Signed-off-by: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>
Reviewed-by: Charlene Liu <Charlene.Liu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/dcn315/dcn315_resource.c   | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn315/dcn315_resource.c b/drivers/gpu/drm/amd/display/dc/dcn315/dcn315_resource.c
index 42a0157fd8133..ae99b2851e019 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn315/dcn315_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn315/dcn315_resource.c
@@ -1662,6 +1662,10 @@ static bool allow_pixel_rate_crb(struct dc *dc, struct dc_state *context)
 	int i;
 	struct resource_context *res_ctx = &context->res_ctx;
 
+	/*Don't apply for single stream*/
+	if (context->stream_count < 2)
+		return false;
+
 	for (i = 0; i < dc->res_pool->pipe_count; i++) {
 		if (!res_ctx->pipe_ctx[i].stream)
 			continue;
@@ -1748,19 +1752,23 @@ static int dcn315_populate_dml_pipes_from_context(
 		pipe_cnt++;
 	}
 
-	/* Spread remaining unreserved crb evenly among all pipes, use default policy if not enough det or single pipe */
+	/* Spread remaining unreserved crb evenly among all pipes*/
 	if (pixel_rate_crb) {
 		for (i = 0, pipe_cnt = 0, crb_idx = 0; i < dc->res_pool->pipe_count; i++) {
 			pipe = &res_ctx->pipe_ctx[i];
 			if (!pipe->stream)
 				continue;
 
+			/* Do not use asymetric crb if not enough for pstate support */
+			if (remaining_det_segs < 0) {
+				pipes[pipe_cnt].pipe.src.det_size_override = 0;
+				continue;
+			}
+
 			if (!pipe->top_pipe && !pipe->prev_odm_pipe) {
 				bool split_required = pipe->stream->timing.pix_clk_100hz >= dcn_get_max_non_odm_pix_rate_100hz(&dc->dml.soc)
 						|| (pipe->plane_state && pipe->plane_state->src_rect.width > 5120);
 
-				if (remaining_det_segs < 0 || crb_pipes == 1)
-					pipes[pipe_cnt].pipe.src.det_size_override = 0;
 				if (remaining_det_segs > MIN_RESERVED_DET_SEGS)
 					pipes[pipe_cnt].pipe.src.det_size_override += (remaining_det_segs - MIN_RESERVED_DET_SEGS) / crb_pipes +
 							(crb_idx < (remaining_det_segs - MIN_RESERVED_DET_SEGS) % crb_pipes ? 1 : 0);
@@ -1776,6 +1784,7 @@ static int dcn315_populate_dml_pipes_from_context(
 				}
 				/* Convert segments into size for DML use */
 				pipes[pipe_cnt].pipe.src.det_size_override *= DCN3_15_CRB_SEGMENT_SIZE_KB;
+
 				crb_idx++;
 			}
 			pipe_cnt++;
-- 
2.39.2



