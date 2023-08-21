Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99AD61171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07824C433C7;
	Mon, 21 Aug 2023 20:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648029;
	bh=GQzKAopDbC+XOyc4Z0qhNQCKG7SGBcLiVMLGZqFEBk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XM/6c2hhFTYx+58k8XoMv8mZ5bY7cax/iGctBZWtaS22hzpdfvPBAuMVLnC8gwv2V
	 ltYCjLIefV4EEQPMgVbkxJatJgomoKBwH3tHJFQMua5wJwRQpE4MsoxvmdadqrTNlp
	 pVizlJKYei6DsWD7U1vZV6Vn/L2HAwrpLaH3fUcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alvin Lee <Alvin.Lee2@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 004/234] drm/amd/display: Update DTBCLK for DCN32
Date: Mon, 21 Aug 2023 21:39:27 +0200
Message-ID: <20230821194128.944069181@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
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

[ Upstream commit 128c1ca0303fe764a4cde5f761e72810d9e40b6e ]

[Why&How]
- Implement interface to program DTBCLK DTO’s
  according to reference DTBCLK returned by PMFW
- This is required because DTO programming
  requires exact DTBCLK reference freq or it could
  result in underflow

Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alvin Lee <Alvin.Lee2@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c  | 27 +++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
index 8d9444db092ab..eea103908b09f 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
@@ -233,6 +233,32 @@ void dcn32_init_clocks(struct clk_mgr *clk_mgr_base)
 	DC_FP_END();
 }
 
+static void dcn32_update_clocks_update_dtb_dto(struct clk_mgr_internal *clk_mgr,
+			struct dc_state *context,
+			int ref_dtbclk_khz)
+{
+	struct dccg *dccg = clk_mgr->dccg;
+	uint32_t tg_mask = 0;
+	int i;
+
+	for (i = 0; i < clk_mgr->base.ctx->dc->res_pool->pipe_count; i++) {
+		struct pipe_ctx *pipe_ctx = &context->res_ctx.pipe_ctx[i];
+		struct dtbclk_dto_params dto_params = {0};
+
+		/* use mask to program DTO once per tg */
+		if (pipe_ctx->stream_res.tg &&
+				!(tg_mask & (1 << pipe_ctx->stream_res.tg->inst))) {
+			tg_mask |= (1 << pipe_ctx->stream_res.tg->inst);
+
+			dto_params.otg_inst = pipe_ctx->stream_res.tg->inst;
+			dto_params.ref_dtbclk_khz = ref_dtbclk_khz;
+
+			dccg->funcs->set_dtbclk_dto(clk_mgr->dccg, &dto_params);
+			//dccg->funcs->set_audio_dtbclk_dto(clk_mgr->dccg, &dto_params);
+		}
+	}
+}
+
 /* Since DPPCLK request to PMFW needs to be exact (due to DPP DTO programming),
  * update DPPCLK to be the exact frequency that will be set after the DPPCLK
  * divider is updated. This will prevent rounding issues that could cause DPP
@@ -570,6 +596,7 @@ static void dcn32_update_clocks(struct clk_mgr *clk_mgr_base,
 		/* DCCG requires KHz precision for DTBCLK */
 		clk_mgr_base->clks.ref_dtbclk_khz =
 				dcn32_smu_set_hard_min_by_freq(clk_mgr, PPCLK_DTBCLK, khz_to_mhz_ceil(new_clocks->ref_dtbclk_khz));
+		dcn32_update_clocks_update_dtb_dto(clk_mgr, context, clk_mgr_base->clks.ref_dtbclk_khz);
 	}
 
 	if (dc->config.forced_clocks == false || (force_reset && safe_to_lower)) {
-- 
2.40.1



