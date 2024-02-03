Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3752171A4;
	Sat,  3 Feb 2024 04:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933909; cv=none; b=DfXeVwsZsm2MS5/FtFlfnfhRUxEnrQfZXhi/4kY86bGX4sOQl+QcOsWsbbsrgsFuYhgk+oWC3RaYUdRTVZfXNg9d6W7AkOr6YHXu8IxQvpmvwTokfIi6tmo87eNW3TTPow+1ce6BQj1/+jfZqXHWfmrn8z4NloD4oCTtDju5XpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933909; c=relaxed/simple;
	bh=6mVA8kcgHIFLJETJBZYFYi1I9pp0C2TDqb0cBiIYHeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvugS+b123WzOYlmHNxd+E+Iv8JX9Ykuq7hOL5OAkYdpjJbLLAiKmi99KOnSVeABPGKLQgZd8Q7zBXNiKwZmwFJo5hyb3K2DHxa9aYjvx6dWItUds1ZRgLpy35k8YKww2jWpKwFUlWR5x7Qf5e+ClfoPQ61bK6ZDNhCEIz9FL1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zBWMno1c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zBWMno1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FDAC43390;
	Sat,  3 Feb 2024 04:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933909;
	bh=6mVA8kcgHIFLJETJBZYFYi1I9pp0C2TDqb0cBiIYHeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zBWMno1cw83ZQz7b2hBWoAz7p844Id0AWoF4T9hhId0MFTlHbnUZhLjsEZyCRo3rS
	 b+fJxceCKO0L2Ewl+dFcvRpUMqE6ekiWmBANpEidQmfRIRB9nCrtYmMR2HfbfrQ1+x
	 R6707CCq1RzRkMQ+xjYAqr6be5ANq8go4YrQ0qoI=
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
Subject: [PATCH 6.7 223/353] drm/amd/display: Only clear symclk otg flag for HDMI
Date: Fri,  2 Feb 2024 20:05:41 -0800
Message-ID: <20240203035410.727527274@linuxfoundation.org>
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
 drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c | 3 ++-
 drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c   | 3 ++-
 drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c   | 3 ++-
 drivers/gpu/drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c   | 3 ++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index 9b8299d97e40..578e51a19fdd 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -2124,7 +2124,8 @@ static void dce110_reset_hw_ctx_wrap(
 				BREAK_TO_DEBUGGER();
 			}
 			pipe_ctx_old->stream_res.tg->funcs->disable_crtc(pipe_ctx_old->stream_res.tg);
-			pipe_ctx_old->stream->link->phy_state.symclk_ref_cnts.otg = 0;
+			if (dc_is_hdmi_tmds_signal(pipe_ctx_old->stream->signal))
+				pipe_ctx_old->stream->link->phy_state.symclk_ref_cnts.otg = 0;
 			pipe_ctx_old->plane_res.mi->funcs->free_mem_input(
 					pipe_ctx_old->plane_res.mi, dc->current_state->stream_count);
 
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c
index cdb903116eb7..1fc8436c8130 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c
@@ -1057,7 +1057,8 @@ static void dcn10_reset_back_end_for_pipe(
 		if (pipe_ctx->stream_res.tg->funcs->set_drr)
 			pipe_ctx->stream_res.tg->funcs->set_drr(
 					pipe_ctx->stream_res.tg, NULL);
-		pipe_ctx->stream->link->phy_state.symclk_ref_cnts.otg = 0;
+		if (dc_is_hdmi_tmds_signal(pipe_ctx->stream->signal))
+			pipe_ctx->stream->link->phy_state.symclk_ref_cnts.otg = 0;
 	}
 
 	for (i = 0; i < dc->res_pool->pipe_count; i++)
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
index c3c83178eb1e..da0181fef411 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -2610,7 +2610,8 @@ static void dcn20_reset_back_end_for_pipe(
 		 * the case where the same symclk is shared across multiple otg
 		 * instances
 		 */
-		link->phy_state.symclk_ref_cnts.otg = 0;
+		if (dc_is_hdmi_tmds_signal(pipe_ctx->stream->signal))
+			link->phy_state.symclk_ref_cnts.otg = 0;
 		if (link->phy_state.symclk_state == SYMCLK_ON_TX_OFF) {
 			link_hwss->disable_link_output(link,
 					&pipe_ctx->link_res, pipe_ctx->stream->signal);
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c
index 52656691ae48..3a70a3cbc274 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c
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



