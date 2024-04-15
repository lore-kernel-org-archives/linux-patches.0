Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506DE2119;
	Mon, 15 Apr 2024 14:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192110; cv=none; b=Dn1oj+0gFlbRBsnM9VWq3WNlESy+d+8Us+XWrrhJFPsKQC105i61+wfD3lOUIyWjAslAkpUFUvyIPgN95DlBM6jgpQAIxto0E7pS+wOBL+IJBIrh1E2tqVlb6mvbvK5wTNtwfcE+N1j8k3seLl6zy9R9GjTUN23c6OcZ+Ka4oPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192110; c=relaxed/simple;
	bh=m/Pkv0zgVHxi+YUhAj5gls7HrkpLTcyToc9I9HL7Tvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxDMz3HI+ZqhUVqEHalMORESglhws+CefeGT3tFt6N1mNrwkchK3ZBQz8q6CcB3mN0CAllm1Lo2XRYUC7FiYJP+xZQ8faQ4qWPYtvj2vOwMRR6iQk6shdVm6P9pi+7xDF4vlLRk0+fOZR+frbzsSuyIyQML1oQ0etcxZv+FOtQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EkpnTZwh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EkpnTZwh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA09EC113CC;
	Mon, 15 Apr 2024 14:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192110;
	bh=m/Pkv0zgVHxi+YUhAj5gls7HrkpLTcyToc9I9HL7Tvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EkpnTZwhaQ4BiqEFeZ/UexmsCQyu+JGU2mTEWKNdwRp87BgKdFKPueoZQuQaFwV2Z
	 NzMtMy6wD9ywBBl20BdHdR29O/N52CmbVt0mnu8qHx+Ojok5uQOiwuugGnsVwiL88R
	 GU40Dc4T1wB/h3akCX2kEopFWLlSo4yL9nE2mba4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Fudongwang <fudong.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 69/69] drm/amd/display: fix disable otg wa logic in DCN316
Date: Mon, 15 Apr 2024 16:21:40 +0200
Message-ID: <20240415141948.248193251@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -112,20 +112,25 @@ static int dcn316_get_active_display_cnt
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
@@ -222,11 +227,11 @@ static void dcn316_update_clocks(struct
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


