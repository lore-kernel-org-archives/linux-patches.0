Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF50015956D;
	Mon, 29 Jan 2024 17:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548390; cv=none; b=qVzXbQYdqdKvCX+VJReXFHihfYhHkZiSGBuv2jQv3pkkePPUDCOLbH9cQm2UmE7YQDAOiDBxyaSZhv1pYOPca9kykJoR2rYMNfnpmgGL3tFRbu1SHG4GzVLclB8tw1q8By6zN+3bFS1cTZvtn1k5vI3jji11FD6eh8z7IX+Zv1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548390; c=relaxed/simple;
	bh=3WJq7hE25dSAS5K9VJsXO6S+1Udt7K/gYDV9vdCKfPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9MoKXSrCaiioFzbgvDYzFQv/U7YaUHf7ZfUSAFra+f1hJiuMFLsxsmrxZUz6SdtUYWAlaYEhCpIOHjBelPzyfj+y0twL6/jvtBFdKbrfw1RDkjpykF92QJJt/3IxPvJHnjumQYJx92OomGnQbciv5b2OXLzjZROoPxDPX4ccww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CPRLKsGX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CPRLKsGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9684C43390;
	Mon, 29 Jan 2024 17:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548389;
	bh=3WJq7hE25dSAS5K9VJsXO6S+1Udt7K/gYDV9vdCKfPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CPRLKsGXo5EbGCd8/miy81c+cfrXCLXVDi9Tfern+gfNK6pPyLD8mkh76gnD52Vm2
	 TRLBvphffaWNN+AQyLFCn0ESDPhlGXllqpsCjJpgzlZVOoitfqlEzMHQJ4mlRaotWu
	 ZzKmuGBsLpdfDmo3zfL3R9xT7U1v5OPAo+nY+xmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.1 139/185] drm/amd/display: Port DENTIST hang and TDR fixes to OTG disable W/A
Date: Mon, 29 Jan 2024 09:05:39 -0800
Message-ID: <20240129170003.055061277@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit 4b56f7d47be87cde5f368b67bc7fac53a2c3e8d2 upstream.

[Why]
We can experience DENTIST hangs during optimize_bandwidth or TDRs if
FIFO is toggled and hangs.

[How]
Port the DCN35 fixes to DCN314.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c |   21 ++++------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c
@@ -131,30 +131,27 @@ static int dcn314_get_active_display_cnt
 	return display_count;
 }
 
-static void dcn314_disable_otg_wa(struct clk_mgr *clk_mgr_base, struct dc_state *context, bool disable)
+static void dcn314_disable_otg_wa(struct clk_mgr *clk_mgr_base, struct dc_state *context,
+				  bool safe_to_lower, bool disable)
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
 		if (pipe->stream && (pipe->stream->dpms_off || dc_is_virtual_signal(pipe->stream->signal))) {
-			struct stream_encoder *stream_enc = pipe->stream_res.stream_enc;
-
 			if (disable) {
-				if (stream_enc && stream_enc->funcs->disable_fifo)
-					pipe->stream_res.stream_enc->funcs->disable_fifo(stream_enc);
+				if (pipe->stream_res.tg && pipe->stream_res.tg->funcs->immediate_disable_crtc)
+					pipe->stream_res.tg->funcs->immediate_disable_crtc(pipe->stream_res.tg);
 
-				pipe->stream_res.tg->funcs->immediate_disable_crtc(pipe->stream_res.tg);
 				reset_sync_context_for_pipe(dc, context, i);
 			} else {
 				pipe->stream_res.tg->funcs->enable_crtc(pipe->stream_res.tg);
-
-				if (stream_enc && stream_enc->funcs->enable_fifo)
-					pipe->stream_res.stream_enc->funcs->enable_fifo(stream_enc);
 			}
 		}
 	}
@@ -254,11 +251,11 @@ void dcn314_update_clocks(struct clk_mgr
 	}
 
 	if (should_set_clock(safe_to_lower, new_clocks->dispclk_khz, clk_mgr_base->clks.dispclk_khz)) {
-		dcn314_disable_otg_wa(clk_mgr_base, context, true);
+		dcn314_disable_otg_wa(clk_mgr_base, context, safe_to_lower, true);
 
 		clk_mgr_base->clks.dispclk_khz = new_clocks->dispclk_khz;
 		dcn314_smu_set_dispclk(clk_mgr, clk_mgr_base->clks.dispclk_khz);
-		dcn314_disable_otg_wa(clk_mgr_base, context, false);
+		dcn314_disable_otg_wa(clk_mgr_base, context, safe_to_lower, false);
 
 		update_dispclk = true;
 	}


