Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9C744CAF7;
	Thu, 30 Jul 2026 16:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427978; cv=none; b=FOI0s7GHA2SXZikzYZFBDO71OB/9xTiQLLZxO/GchOUOwI+gbuwEhbDEYnx9D2vpy++KWLTchppQuE0A5QhimoqKGk7onACqmcGJUNmfH5OF2WJyaVSJouC08VpDR0bJEqMKoKowXSXoWv7Ntdd+Fm0i1AWgioDGlOhu03r8Aw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427978; c=relaxed/simple;
	bh=jYrLQa9WlHH6bBFd6wB6KO0qmvxZc7AapTzvLR9c6ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGD9GFyXt+TfZyzx5zis7nM/ZBV6XUbMaTfrD07B7nBw6KvOShOBggkI0xGqI40hgC5m8d5wuVwm2msoJHkbhtFLgpUOYRV/M5CNA7WADHJUcavzVXaAsbDRdGam2/owlgslvsVcklSDyOiT+pb/EA/D4LdKrz8Smkw9Jh2rXQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebXJS+z6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebXJS+z6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA241F000E9;
	Thu, 30 Jul 2026 16:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427976;
	bh=kAHDAhm8AnbaD6Dptd4ufI/l+8xUnT/sWcZ9CHxrND0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ebXJS+z68JM4hUDqarV2psHj8us6btkh7nH/F6cVpycFXcGaDgoSr2i4TXHlSxti8
	 dhYj3DX/OAC9MIWyosMFR/OxvzugqD84xjs/0a2ECgbhB5Uo00UMcPBEhj8lrGwFDc
	 R3V/YwrOW6I19Q/HCSWi+mIq4hRaI2Xc9NxX7H7g=
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
Subject: [PATCH 6.6 359/484] drm/amd/display: Fix dcn32 DTB DTO update breaking live pixel rate sources
Date: Thu, 30 Jul 2026 16:14:16 +0200
Message-ID: <20260730141431.275042214@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Wentland <harry.wentland@amd.com>

commit 76a2db58e95e328007043f54ac3c7336ccbee440 upstream.

dcn32_update_clocks_update_dtb_dto() reprograms the DTB DTO of every
timing generator in the context whenever the DTBCLK reference changes,
passing a zeroed pixel rate and never setting is_hdmi.
dccg32_set_dtbclk_dto() treats a zero pixel rate as a disable request,
and that branch drives PIPE_DTO_SRC_SEL to the DP DTO source. A timing
generator actively scanning out an HDMI stream therefore has its pixel
rate source re-muxed out from under the live raster, and the OTG stops
on the spot.

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
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ mschwartz: dcn32 clk_mgr hunk only, as 6.6.y predates the dcn35
  clk_mgr. The rest is HDMI FRL enablement, absent before 7.2, so the
  FRL conditions and the req_audio_dtbclk_khz assignment they guard are
  dropped and the FRL-centric changelog is rewritten. Added the
  pipe_ctx->stream check the new dereferences need. ]
Signed-off-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
index 1c5ae4d62e37b7..65344d0c7c10d2 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
@@ -255,13 +255,20 @@ static void dcn32_update_clocks_update_dtb_dto(struct clk_mgr_internal *clk_mgr,
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



