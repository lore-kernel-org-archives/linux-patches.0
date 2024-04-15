Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D386278685;
	Mon, 15 Apr 2024 14:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191899; cv=none; b=PEpSuSY/WCisV8RvTTCIV3efLjo9k0RrHD5x/aTNpSuvvo8ad33vApNq6lW0aKnJfQxM7xudfzblViFpm9xm4GyqaHBK6Dv11U9XqZkWtyCvBZ2i4OFeVhItKyq0wwijdiyzyzpLUirRA40RKqPrX6iuHXvbHtCy7MmKAsMZGtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191899; c=relaxed/simple;
	bh=QFzD9EftAAVficFMv+b3k7Z5qYGYOXuTbwJ9//ppx+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iw+IabRMOQjsHD206T5tFWcHgVeCHVGLufWhuHUDdVxUDlozYUZfybPTfZF2v6BeltuCtw0FC2CX1aMMBKAXeRYwgVssh2R/JtT+oxga3nmaC13BLJKOOMTjBjF5rh1eGSSaGMRqe+74mWCBoOwrXxXeqrW92TrhzgEClNsVeMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V4kwZi2X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V4kwZi2X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2DFC113CC;
	Mon, 15 Apr 2024 14:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191899;
	bh=QFzD9EftAAVficFMv+b3k7Z5qYGYOXuTbwJ9//ppx+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V4kwZi2X8ooKaWrDDQuzJur2sMT5ueFYonRAo5wt+E9kfKrTh6Z0YvuPzMX4oy4G/
	 4xaTC+tBayx3MeiUGiZeqQrFlZOW+agoOXbkAvBqR4aVe7WTNNSj3GmvXhyLLcq3Wg
	 6NAXHbrxG3mxRSeZQRu5sa3AixnFf/K60QB8jUrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Fudongwang <fudong.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 122/122] drm/amd/display: fix disable otg wa logic in DCN316
Date: Mon, 15 Apr 2024 16:21:27 +0200
Message-ID: <20240415141957.029397225@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

From: Fudongwang <fudong.wang@amd.com>

commit cf79814cb0bf5749b9f0db53ca231aa540c02768 upstream.

[Why]
Wrong logic cause screen corruption.

[How]
Port logic from DCN35/314.

Cc: stable@vger.kernel.org
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Fudongwang <fudong.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn316/dcn316_clk_mgr.c |   19 ++++++----
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn316/dcn316_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn316/dcn316_clk_mgr.c
@@ -99,20 +99,25 @@ static int dcn316_get_active_display_cnt
 	return display_count;
 }
 
-static void dcn316_disable_otg_wa(struct clk_mgr *clk_mgr_base, struct dc_state *context, bool disable)
+static void dcn316_disable_otg_wa(struct clk_mgr *clk_mgr_base, struct dc_state *context,
+		bool safe_to_lower, bool disable)
 {
 	struct dc *dc = clk_mgr_base->ctx->dc;
 	int i;
 
 	for (i = 0; i < dc->res_pool->pipe_count; ++i) {
-		struct pipe_ctx *pipe = &dc->current_state->res_ctx.pipe_ctx[i];
+		struct pipe_ctx *pipe = safe_to_lower
+			? &context->res_ctx.pipe_ctx[i]
+			: &dc->current_state->res_ctx.pipe_ctx[i];
 
 		if (pipe->top_pipe || pipe->prev_odm_pipe)
 			continue;
-		if (pipe->stream && (pipe->stream->dpms_off || pipe->plane_state == NULL ||
-				     dc_is_virtual_signal(pipe->stream->signal))) {
+		if (pipe->stream && (pipe->stream->dpms_off || dc_is_virtual_signal(pipe->stream->signal) ||
+				     !pipe->stream->link_enc)) {
 			if (disable) {
-				pipe->stream_res.tg->funcs->immediate_disable_crtc(pipe->stream_res.tg);
+				if (pipe->stream_res.tg && pipe->stream_res.tg->funcs->immediate_disable_crtc)
+					pipe->stream_res.tg->funcs->immediate_disable_crtc(pipe->stream_res.tg);
+
 				reset_sync_context_for_pipe(dc, context, i);
 			} else
 				pipe->stream_res.tg->funcs->enable_crtc(pipe->stream_res.tg);
@@ -207,11 +212,11 @@ static void dcn316_update_clocks(struct
 	}
 
 	if (should_set_clock(safe_to_lower, new_clocks->dispclk_khz, clk_mgr_base->clks.dispclk_khz)) {
-		dcn316_disable_otg_wa(clk_mgr_base, context, true);
+		dcn316_disable_otg_wa(clk_mgr_base, context, safe_to_lower, true);
 
 		clk_mgr_base->clks.dispclk_khz = new_clocks->dispclk_khz;
 		dcn316_smu_set_dispclk(clk_mgr, clk_mgr_base->clks.dispclk_khz);
-		dcn316_disable_otg_wa(clk_mgr_base, context, false);
+		dcn316_disable_otg_wa(clk_mgr_base, context, safe_to_lower, false);
 
 		update_dispclk = true;
 	}


