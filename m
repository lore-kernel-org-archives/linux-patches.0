Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F3010965;
	Sat,  3 Feb 2024 04:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933630; cv=none; b=YgcRgSNI9NC6pe1Rok8Pl+CMEVCrojx+jUAbIxRIjtqOoBWfz38P7kSC8nkLmXy89uIfUw68rR0Mg/miBDlmYuJ00+RB6DATpxm/d8cp3ezAaAKCY2aW3hHIULys9pT+BNImvqnW9I566hB9Pu0/mysM1ZowdJBLtVhPS4Xdi+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933630; c=relaxed/simple;
	bh=t+BdTnPmuHrAaAwaoU5NF8kvlDSEnXtwG0Is3Q98Osc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/LCrcWTkucCbRwv9jCZXfDlYWtg9jOQRd91L9RC9htFjyy6n4acKlGNn56nrarlUcEI1bwgXYm0+AyQ0toHXT3SkbFKJiFKHGzx0SMYwcuajUBGxGbq3srKovG7MXnLdJ5JzPISSsfQkRcDhc2qwfpszvO9MaifJKS5mv/cS2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZCNMGFK+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZCNMGFK+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81BEC43390;
	Sat,  3 Feb 2024 04:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933630;
	bh=t+BdTnPmuHrAaAwaoU5NF8kvlDSEnXtwG0Is3Q98Osc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZCNMGFK+Dw38nErgsg5OpA9gsJgP9LIXWhP9qmjE+9twc9ujWNJooBS3KIVc63Id5
	 PJ65SlNw95FKU1+CHl975wc5YqgSUbHQ5gqex4sYmpDdeC1IY0h9raG8n/biCrDqH7
	 icl46E17SVFgnfpWcxsKFFpgnNX9DwO4XHTgCL0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samson Tam <samson.tam@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 207/322] drm/amd/display: Only clear symclk otg flag for HDMI
Date: Fri,  2 Feb 2024 20:05:04 -0800
Message-ID: <20240203035405.941360273@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alvin Lee <alvin.lee2@amd.com>

[ Upstream commit dff45f03f508c92cd8eb2050e27b726726b8ae0b ]

[Description]
There is a corner case where the symclk otg flag is cleared
when disabling the phantom pipe for subvp (because the phantom
and main pipe share the same link). This is undesired because
we need the maintain the correct symclk otg flag state for
the main pipe.

For now only clear the flag only for HDMI signal type, since
it's only set for HDMI signal type (phantom is virtual). The
ideal solution is to not clear it if the stream is phantom but
currently there's a bug that doesn't allow us to do this. Once
this issue is fixed the proper fix can be implemented.

Reviewed-by: Samson Tam <samson.tam@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Alvin Lee <alvin.lee2@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c | 3 ++-
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c   | 3 ++-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c          | 3 ++-
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c          | 3 ++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
index 7fbbad69064f..251dd800a2a6 100644
--- a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
@@ -2124,7 +2124,8 @@ static void dce110_reset_hw_ctx_wrap(
 				BREAK_TO_DEBUGGER();
 			}
 			pipe_ctx_old->stream_res.tg->funcs->disable_crtc(pipe_ctx_old->stream_res.tg);
-			pipe_ctx_old->stream->link->phy_state.symclk_ref_cnts.otg = 0;
+			if (dc_is_hdmi_tmds_signal(pipe_ctx_old->stream->signal))
+				pipe_ctx_old->stream->link->phy_state.symclk_ref_cnts.otg = 0;
 			pipe_ctx_old->plane_res.mi->funcs->free_mem_input(
 					pipe_ctx_old->plane_res.mi, dc->current_state->stream_count);
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index 13ccb57379c7..db1d7be7fda3 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -1054,7 +1054,8 @@ static void dcn10_reset_back_end_for_pipe(
 		if (pipe_ctx->stream_res.tg->funcs->set_drr)
 			pipe_ctx->stream_res.tg->funcs->set_drr(
 					pipe_ctx->stream_res.tg, NULL);
-		pipe_ctx->stream->link->phy_state.symclk_ref_cnts.otg = 0;
+		if (dc_is_hdmi_tmds_signal(pipe_ctx->stream->signal))
+			pipe_ctx->stream->link->phy_state.symclk_ref_cnts.otg = 0;
 	}
 
 	for (i = 0; i < dc->res_pool->pipe_count; i++)
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 2c4bcbca8bb8..1e3803739ae6 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -2533,7 +2533,8 @@ static void dcn20_reset_back_end_for_pipe(
 		 * the case where the same symclk is shared across multiple otg
 		 * instances
 		 */
-		link->phy_state.symclk_ref_cnts.otg = 0;
+		if (dc_is_hdmi_tmds_signal(pipe_ctx->stream->signal))
+			link->phy_state.symclk_ref_cnts.otg = 0;
 		if (link->phy_state.symclk_state == SYMCLK_ON_TX_OFF) {
 			link_hwss->disable_link_output(link,
 					&pipe_ctx->link_res, pipe_ctx->stream->signal);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c
index 2a7f47642a44..22da2007601e 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c
@@ -523,7 +523,8 @@ static void dcn31_reset_back_end_for_pipe(
 	if (pipe_ctx->stream_res.tg->funcs->set_odm_bypass)
 		pipe_ctx->stream_res.tg->funcs->set_odm_bypass(
 				pipe_ctx->stream_res.tg, &pipe_ctx->stream->timing);
-	pipe_ctx->stream->link->phy_state.symclk_ref_cnts.otg = 0;
+	if (dc_is_hdmi_tmds_signal(pipe_ctx->stream->signal))
+		pipe_ctx->stream->link->phy_state.symclk_ref_cnts.otg = 0;
 
 	if (pipe_ctx->stream_res.tg->funcs->set_drr)
 		pipe_ctx->stream_res.tg->funcs->set_drr(
-- 
2.43.0



