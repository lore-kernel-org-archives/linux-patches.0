Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B287620F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3520AC433C7;
	Fri, 21 Jul 2023 19:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967466;
	bh=Xhz2wT/9ZzyTENKCVFwgr4pTd+XLLsgr1CmAmxrI1uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tyC0h/4R3PfkzMsfS5GvG0dHt6/4emXvu/4msXdHkY+CnxF/YdDsc6KicF5XyzKV2
	 1GYcTsRqlAXS46ATCCKKn8XPBHmObVMcL9KyniBzuvj+UE6jkvSETRyQ7pseMMgm2m
	 ocoXuQ1ltK1v8VlRLrd3JmyhK1UCoYwbBlrTML20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Stylon Wang <stylon.wang@amd.com>,
	Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>,
	Charlene Liu <Charlene.Liu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.1 145/223] drm/amd/display: fix seamless odm transitions
Date: Fri, 21 Jul 2023 18:06:38 +0200
Message-ID: <20230721160527.054094455@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
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

commit 75c2b7ed080d7421157c03064be82275364136e7 upstream.

Add missing programming and function pointers

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Acked-by: Stylon Wang <stylon.wang@amd.com>
Signed-off-by: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>
Reviewed-by: Charlene Liu <Charlene.Liu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |   11 +++++++++++
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c  |    2 +-
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.h  |    1 +
 3 files changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1678,6 +1678,17 @@ static void dcn20_program_pipe(
 
 		if (hws->funcs.setup_vupdate_interrupt)
 			hws->funcs.setup_vupdate_interrupt(dc, pipe_ctx);
+
+		if (hws->funcs.calculate_dccg_k1_k2_values && dc->res_pool->dccg->funcs->set_pixel_rate_div) {
+			unsigned int k1_div, k2_div;
+
+			hws->funcs.calculate_dccg_k1_k2_values(pipe_ctx, &k1_div, &k2_div);
+
+			dc->res_pool->dccg->funcs->set_pixel_rate_div(
+				dc->res_pool->dccg,
+				pipe_ctx->stream_res.tg->inst,
+				k1_div, k2_div);
+		}
 	}
 
 	if (pipe_ctx->update_flags.bits.odm)
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.c
@@ -98,7 +98,7 @@ static void optc32_set_odm_combine(struc
 	optc1->opp_count = opp_cnt;
 }
 
-static void optc32_set_h_timing_div_manual_mode(struct timing_generator *optc, bool manual_mode)
+void optc32_set_h_timing_div_manual_mode(struct timing_generator *optc, bool manual_mode)
 {
 	struct optc *optc1 = DCN10TG_FROM_TG(optc);
 
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_optc.h
@@ -250,5 +250,6 @@
 	SF(OTG0_OTG_DRR_CONTROL, OTG_V_TOTAL_LAST_USED_BY_DRR, mask_sh)
 
 void dcn32_timing_generator_init(struct optc *optc1);
+void optc32_set_h_timing_div_manual_mode(struct timing_generator *optc, bool manual_mode);
 
 #endif /* __DC_OPTC_DCN32_H__ */


