Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C70175A6D;
	Thu, 30 Jul 2026 14:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423269; cv=none; b=C3BPmIpxvL4qqJE6TU8zh98OLBhlKVJslOdIcrpWuD5eIoyACoh7QGew/+9ucri1zvMR2KoGNDzbrvRTvtI1RsFWUu9FiFl8ImoFtKV+hY1TngVhNj6Ku/qo/v0XbpFpHBSMGlhtTmFtOmdORsSSTRAYZxnm1Xb31cOgBaLYtUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423269; c=relaxed/simple;
	bh=1BWo54pah8P0qKsh74KTe1CBmUhCb9CLmk2ra2DHakU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a79WXmrS55s7Ji08GNAez0TckFQwkHeCic+88fNbJaRYfXxNi99fTeXG9BGypLmtsoupuMF1vOVE8rb16LRLxLUXeoUfmSj2DayV8aqilbrp9nuwNQEllMGQfHsxL/cW60+EUTphkYAcUQS+mHxAKqrv0CUxy/w8wNY/azXzOgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bs+gw64f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bs+gw64f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562601F000E9;
	Thu, 30 Jul 2026 14:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423267;
	bh=vk1cfEurVECB/TATxFeIIEZTnccKZ+IAXY4kI+n939k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bs+gw64fponz3EHF8iDvm3BuBpj4pwae/RzB6dI5UquhzzekHU3kvVtCGrq2ss5zC
	 v4lhiaC0G8wHNzOaUaXVXkmun+meL9CILMgXcoFbZuMdEiaJDEDT7E1OX+A0SkLXXi
	 myUM/xUtsLKalJ27uEKJp3bUtH8xUgxXX211dqjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Fangzhi Zuo <Jerry.Zuo@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 724/744] drm/amd/display: Fix DTB DTO updates breaking live pixel rate sources
Date: Thu, 30 Jul 2026 16:16:37 +0200
Message-ID: <20260730141459.674738303@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Wentland <harry.wentland@amd.com>

commit 76a2db58e95e328007043f54ac3c7336ccbee440 upstream.

dcn32_update_clocks_update_dtb_dto() and its dcn35 counterpart reprogram
the DTB DTO of every timing generator in the context whenever the DTBCLK
reference changes, passing a zeroed pixel rate and never setting
is_hdmi. Both dccg set_dtbclk_dto() implementations treat a zero pixel
rate as a disable request. On dcn32 that branch drives PIPE_DTO_SRC_SEL
to the DP DTO source, so a timing generator actively scanning out an
HDMI stream has its pixel rate source re-muxed out from under the live
raster and the OTG stops on the spot. On dcn35 it clears
DTBCLK_DTO_ENABLE and restores DTBCLK_Pn clock gating, which does the
same to a live 128b/132b stream.

Two displays where only one runs a 128b/132b link hit this reliably.
is_dtbclk_required() holds the DTBCLK reference high while both are
active, and the moment the 128b/132b stream is torn down (compositor
switch, display disable, hot-unplug) the next safe_to_lower pass drops
the reference to the lowest DPM level and the DTO walk freezes the
surviving screen. On Navi31 the DAL mailbox then goes deaf on the
DISPCLK hard-min that follows the walk in dcn32_update_clocks(),
stranding both SMU mailboxes until reboot.

Set is_hdmi for HDMI and DVI signals so the disable path leaves the
pixel rate source selection on the HDMI path, and pass the real pixel
rate for 128b/132b streams so a reference change rescales their DTO
instead of disabling it.

Fixes: 128c1ca0303f ("drm/amd/display: Update DTBCLK for DCN32")
Fixes: 8774029f76b9 ("drm/amd/display: Add DCN35 CLK_MGR")
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ mschwartz: dcn32 and dcn35 clk_mgr hunks only. The rest is HDMI FRL
  enablement, absent before 7.2, so the FRL conditions and the
  req_audio_dtbclk_khz assignment they guard are dropped and the
  FRL-centric changelog is rewritten. Added the pipe_ctx->stream check
  the new dereferences need. ]
Signed-off-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c | 9 ++++++++-
 .../gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c | 9 ++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
index fda6cade30a8de..e2787c7084ec07 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
@@ -276,13 +276,20 @@ static void dcn32_update_clocks_update_dtb_dto(struct clk_mgr_internal *clk_mgr,
 		struct dtbclk_dto_params dto_params = {0};
 
 		/* use mask to program DTO once per tg */
-		if (pipe_ctx->stream_res.tg &&
+		if (pipe_ctx->stream && pipe_ctx->stream_res.tg &&
 				!(tg_mask & (1 << pipe_ctx->stream_res.tg->inst))) {
 			tg_mask |= (1 << pipe_ctx->stream_res.tg->inst);
 
 			dto_params.otg_inst = pipe_ctx->stream_res.tg->inst;
 			dto_params.ref_dtbclk_khz = ref_dtbclk_khz;
 
+			if (dccg->ctx->dc->link_srv->dp_is_128b_132b_signal(pipe_ctx))
+				dto_params.pixclk_khz = pipe_ctx->stream->timing.pix_clk_100hz / 10;
+
+			if (dc_is_hdmi_signal(pipe_ctx->stream->signal) ||
+					dc_is_dvi_signal(pipe_ctx->stream->signal))
+				dto_params.is_hdmi = true;
+
 			dccg->funcs->set_dtbclk_dto(clk_mgr->dccg, &dto_params);
 			//dccg->funcs->set_audio_dtbclk_dto(clk_mgr->dccg, &dto_params);
 		}
diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
index 3f58a1640d64e7..020d43c7fab855 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
@@ -264,13 +264,20 @@ static void dcn35_update_clocks_update_dtb_dto(struct clk_mgr_internal *clk_mgr,
 		struct dtbclk_dto_params dto_params = {0};
 
 		/* use mask to program DTO once per tg */
-		if (pipe_ctx->stream_res.tg &&
+		if (pipe_ctx->stream && pipe_ctx->stream_res.tg &&
 				!(tg_mask & (1 << pipe_ctx->stream_res.tg->inst))) {
 			tg_mask |= (1 << pipe_ctx->stream_res.tg->inst);
 
 			dto_params.otg_inst = pipe_ctx->stream_res.tg->inst;
 			dto_params.ref_dtbclk_khz = ref_dtbclk_khz;
 
+			if (dccg->ctx->dc->link_srv->dp_is_128b_132b_signal(pipe_ctx))
+				dto_params.pixclk_khz = pipe_ctx->stream->timing.pix_clk_100hz / 10;
+
+			if (dc_is_hdmi_signal(pipe_ctx->stream->signal) ||
+					dc_is_dvi_signal(pipe_ctx->stream->signal))
+				dto_params.is_hdmi = true;
+
 			dccg->funcs->set_dtbclk_dto(clk_mgr->dccg, &dto_params);
 			//dccg->funcs->set_audio_dtbclk_dto(clk_mgr->dccg, &dto_params);
 		}
-- 
2.53.0



