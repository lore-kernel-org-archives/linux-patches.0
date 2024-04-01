Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAAF45BE4;
	Mon,  1 Apr 2024 16:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987242; cv=none; b=rzlC9DYVQcpQue7NJ1kmpJGbcK4hIECPZK//526t7wTm/zPHwpL38J+O7xGVQBp8pSrWSLzV2R9Bz0FDgnIr5mro1Gpp//2nNTxFL4w6u7DXdMaLCQT4zloFyd7bf19T9VCOvJ5OjlqOILAad2ojXKvOc07KHJzvyCf4ohymJ0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987242; c=relaxed/simple;
	bh=TCuAoWkq45kUj0DJlNsCx1gsL4UOJxlaPtLtkoheXJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7GVJmAYsPQWcD0eQo2jjd/UXfvynTsgpphlXwHWysK8MW0mO5d5HNV2uMlS7ozGRT43Wjy2JbRrh61nMs9uPt6ZYmPRYS9tphq91c/xqzR0Te/ZLauQoLy1H55gjhpeUc6tQxid788GwID8aKgTYBSEUYvelSKG6NtD++0eikc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=anwoPL+q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="anwoPL+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DD1C43390;
	Mon,  1 Apr 2024 16:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987242;
	bh=TCuAoWkq45kUj0DJlNsCx1gsL4UOJxlaPtLtkoheXJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=anwoPL+qqfkkVy6NY4xLuYeae2bo0enYyXfx9TX+M7uqtXyhQRlRGpEpdSZPfwhpf
	 v4RtUVUx21zm0mAcZOmWdEJ6Jd7y2QrVnittzzFCXtUbomq0Cm9Ss5QWApGlS+v+K+
	 2VFUJjI0CNDJLch/g9qt7U9EPmgFgvZ8EanDmbzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <alvin.lee2@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Aric Cyr <aric.cyr@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 226/399] drm/amd/display: Unify optimize_required flags and VRR adjustments
Date: Mon,  1 Apr 2024 17:43:12 +0200
Message-ID: <20240401152555.926313043@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aric Cyr <aric.cyr@amd.com>

[ Upstream commit dcbf438d48341dc60e08e3df92120a4aeb097c84 ]

[why]
There is only a single call to dc_post_update_surfaces_to_stream
so there is no need to have two flags to control it. Unifying
this to a single flag allows dc_stream_adjust_vmin_vmax to skip
actual programming when there is no change required.

[how]
Remove wm_optimze_required flag and set only optimize_required in its
place.  Then in dc_stream_adjust_vmin_vmax, check that the stream timing
range matches the requested one and skip programming if they are equal.

Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Aric Cyr <aric.cyr@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: a9b1a4f684b3 ("drm/amd/display: Add more checks for exiting idle in DC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c           | 14 +++++---------
 drivers/gpu/drm/amd/display/dc/dc.h                |  1 -
 drivers/gpu/drm/amd/display/dc/dc_stream.h         |  2 --
 .../drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c    |  2 +-
 .../drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c    |  8 ++++----
 5 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 02e85b832a7d3..3b65f216048e1 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -411,9 +411,12 @@ bool dc_stream_adjust_vmin_vmax(struct dc *dc,
 	 * avoid conflicting with firmware updates.
 	 */
 	if (dc->ctx->dce_version > DCE_VERSION_MAX)
-		if (dc->optimized_required || dc->wm_optimized_required)
+		if (dc->optimized_required)
 			return false;
 
+	if (!memcmp(&stream->adjust, adjust, sizeof(*adjust)))
+		return true;
+
 	stream->adjust.v_total_max = adjust->v_total_max;
 	stream->adjust.v_total_mid = adjust->v_total_mid;
 	stream->adjust.v_total_mid_frame_num = adjust->v_total_mid_frame_num;
@@ -2280,7 +2283,6 @@ void dc_post_update_surfaces_to_stream(struct dc *dc)
 	}
 
 	dc->optimized_required = false;
-	dc->wm_optimized_required = false;
 }
 
 bool dc_set_generic_gpio_for_stereo(bool enable,
@@ -2703,8 +2705,6 @@ enum surface_update_type dc_check_update_surfaces_for_stream(
 		} else if (memcmp(&dc->current_state->bw_ctx.bw.dcn.clk, &dc->clk_mgr->clks, offsetof(struct dc_clocks, prev_p_state_change_support)) != 0) {
 			dc->optimized_required = true;
 		}
-
-		dc->optimized_required |= dc->wm_optimized_required;
 	}
 
 	return type;
@@ -2912,9 +2912,6 @@ static void copy_stream_update_to_stream(struct dc *dc,
 	if (update->vrr_active_fixed)
 		stream->vrr_active_fixed = *update->vrr_active_fixed;
 
-	if (update->crtc_timing_adjust)
-		stream->adjust = *update->crtc_timing_adjust;
-
 	if (update->dpms_off)
 		stream->dpms_off = *update->dpms_off;
 
@@ -4350,8 +4347,7 @@ static bool full_update_required(struct dc *dc,
 			stream_update->mst_bw_update ||
 			stream_update->func_shaper ||
 			stream_update->lut3d_func ||
-			stream_update->pending_test_pattern ||
-			stream_update->crtc_timing_adjust))
+			stream_update->pending_test_pattern))
 		return true;
 
 	if (stream) {
diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index c9317ea0258ea..7aa9954ec8407 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -1037,7 +1037,6 @@ struct dc {
 
 	/* Require to optimize clocks and bandwidth for added/removed planes */
 	bool optimized_required;
-	bool wm_optimized_required;
 	bool idle_optimizations_allowed;
 	bool enable_c20_dtm_b0;
 
diff --git a/drivers/gpu/drm/amd/display/dc/dc_stream.h b/drivers/gpu/drm/amd/display/dc/dc_stream.h
index ee10941caa598..a23eebd9933b7 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_stream.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_stream.h
@@ -139,7 +139,6 @@ union stream_update_flags {
 		uint32_t wb_update:1;
 		uint32_t dsc_changed : 1;
 		uint32_t mst_bw : 1;
-		uint32_t crtc_timing_adjust : 1;
 		uint32_t fams_changed : 1;
 	} bits;
 
@@ -326,7 +325,6 @@ struct dc_stream_update {
 	struct dc_3dlut *lut3d_func;
 
 	struct test_pattern *pending_test_pattern;
-	struct dc_crtc_timing_adjust *crtc_timing_adjust;
 };
 
 bool dc_is_stream_unchanged(
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c
index f614bc2806d86..c45f84aa320ef 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c
@@ -3079,7 +3079,7 @@ void dcn10_prepare_bandwidth(
 			context,
 			false);
 
-	dc->wm_optimized_required = hubbub->funcs->program_watermarks(hubbub,
+	dc->optimized_required |= hubbub->funcs->program_watermarks(hubbub,
 			&context->bw_ctx.bw.dcn.watermarks,
 			dc->res_pool->ref_clocks.dchub_ref_clock_inKhz / 1000,
 			true);
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
index c29c7eb017c37..868a086c72a2c 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -2160,10 +2160,10 @@ void dcn20_prepare_bandwidth(
 	}
 
 	/* program dchubbub watermarks:
-	 * For assigning wm_optimized_required, use |= operator since we don't want
+	 * For assigning optimized_required, use |= operator since we don't want
 	 * to clear the value if the optimize has not happened yet
 	 */
-	dc->wm_optimized_required |= hubbub->funcs->program_watermarks(hubbub,
+	dc->optimized_required |= hubbub->funcs->program_watermarks(hubbub,
 					&context->bw_ctx.bw.dcn.watermarks,
 					dc->res_pool->ref_clocks.dchub_ref_clock_inKhz / 1000,
 					false);
@@ -2176,10 +2176,10 @@ void dcn20_prepare_bandwidth(
 	if (hubbub->funcs->program_compbuf_size) {
 		if (context->bw_ctx.dml.ip.min_comp_buffer_size_kbytes) {
 			compbuf_size_kb = context->bw_ctx.dml.ip.min_comp_buffer_size_kbytes;
-			dc->wm_optimized_required |= (compbuf_size_kb != dc->current_state->bw_ctx.dml.ip.min_comp_buffer_size_kbytes);
+			dc->optimized_required |= (compbuf_size_kb != dc->current_state->bw_ctx.dml.ip.min_comp_buffer_size_kbytes);
 		} else {
 			compbuf_size_kb = context->bw_ctx.bw.dcn.compbuf_size_kb;
-			dc->wm_optimized_required |= (compbuf_size_kb != dc->current_state->bw_ctx.bw.dcn.compbuf_size_kb);
+			dc->optimized_required |= (compbuf_size_kb != dc->current_state->bw_ctx.bw.dcn.compbuf_size_kb);
 		}
 
 		hubbub->funcs->program_compbuf_size(hubbub, compbuf_size_kb, false);
-- 
2.43.0



