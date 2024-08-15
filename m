Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BD61AC8A2;
	Thu, 15 Aug 2024 13:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729131; cv=none; b=q8cvSz7znyyPdUBL3T6ujWockN+gD0V9sYbQc0pswuMyuMC8H+nqMDSWm0tvqW+YLSEpshxoN5tSoL2ezA7QkpTuCCgIHi2zS8kYXr52mzjjc3y+IhYrueBPD2U4LvBUjUYYPWolpThMXg1ADPZfOgeJnGT8mV6Iqb6Zw74Ejvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729131; c=relaxed/simple;
	bh=HOAny0Mr/rSB+NoxRYDUfeRcN7pXQ8mDTjekN4Kykm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pB9pJjMcbEAiJQ6Th0+2/FCoNsX28F43VSZp0YvtIyNDJIKF95OJay3PbJoqohW6YBlkggqFqdSKSp09OCap+AIlEOTQlH3ydVts0tCP2FfrP212I3pmwtCL1HmDG1+i0J9eh8lhCHsclau6u7HENOy5JGVyyDZeAEJQS5CqWmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g8wmrmpr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g8wmrmpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D34C32786;
	Thu, 15 Aug 2024 13:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729131;
	bh=HOAny0Mr/rSB+NoxRYDUfeRcN7pXQ8mDTjekN4Kykm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g8wmrmpr2KDC3PssMan2dCOPfEdQos/IJcafLsfw0U0DVGJn0HijU4M3UvTuUFA5R
	 pCHq7a44qGELj2vUrhXd02E3q5qgvupVlYksFXHkJL5vFJhegy507pLtFIfPUu8GQc
	 fwnU5KbHmDIsjqqUzJJ9heWL1k0E0JtpDH6EUONc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Agustin Gutierrez <agustin.gutierrez@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Kevin Holm <kevin@holm.dev>
Subject: [PATCH 6.10 03/22] drm/amd/display: Separate setting and programming of cursor
Date: Thu, 15 Aug 2024 15:25:11 +0200
Message-ID: <20240815131831.398609182@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131831.265729493@linuxfoundation.org>
References: <20240815131831.265729493@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Wentland <harry.wentland@amd.com>

commit f63f86b5affcc2abd1162f11824b9386fc06ac94 upstream.

We're seeing issues when user-space tries to do an atomic update of
the primary surface, as well as the cursor. These two updates are
separate calls into DC and don't currently act as an atomic update.
This might lead to cursor updates being locked out and cursors
stuttering.

In order to solve this problem we want to separate the setting
and programming of cursor attributes and position. That's what
we're doing in this patch. The subsequent patch will then be
able to use the cursor setters in independent cursor updates,
as well as in atomic commits.

Reviewed-by: Agustin Gutierrez <agustin.gutierrez@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Kevin Holm <kevin@holm.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c       |    2 
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c |    6 -
 drivers/gpu/drm/amd/display/dc/core/dc_stream.c         |   89 ++++++++++------
 drivers/gpu/drm/amd/display/dc/dc_stream.h              |    8 +
 drivers/gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c |    2 
 5 files changed, 73 insertions(+), 34 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8947,7 +8947,7 @@ static void amdgpu_dm_commit_streams(str
 
 			memset(&position, 0, sizeof(position));
 			mutex_lock(&dm->dc_lock);
-			dc_stream_set_cursor_position(dm_old_crtc_state->stream, &position);
+			dc_stream_program_cursor_position(dm_old_crtc_state->stream, &position);
 			mutex_unlock(&dm->dc_lock);
 		}
 
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c
@@ -1254,7 +1254,7 @@ void amdgpu_dm_plane_handle_cursor_updat
 		/* turn off cursor */
 		if (crtc_state && crtc_state->stream) {
 			mutex_lock(&adev->dm.dc_lock);
-			dc_stream_set_cursor_position(crtc_state->stream,
+			dc_stream_program_cursor_position(crtc_state->stream,
 						      &position);
 			mutex_unlock(&adev->dm.dc_lock);
 		}
@@ -1284,11 +1284,11 @@ void amdgpu_dm_plane_handle_cursor_updat
 
 	if (crtc_state->stream) {
 		mutex_lock(&adev->dm.dc_lock);
-		if (!dc_stream_set_cursor_attributes(crtc_state->stream,
+		if (!dc_stream_program_cursor_attributes(crtc_state->stream,
 							 &attributes))
 			DRM_ERROR("DC failed to set cursor attributes\n");
 
-		if (!dc_stream_set_cursor_position(crtc_state->stream,
+		if (!dc_stream_program_cursor_position(crtc_state->stream,
 						   &position))
 			DRM_ERROR("DC failed to set cursor position\n");
 		mutex_unlock(&adev->dm.dc_lock);
--- a/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
@@ -266,7 +266,6 @@ bool dc_stream_set_cursor_attributes(
 	const struct dc_cursor_attributes *attributes)
 {
 	struct dc  *dc;
-	bool reset_idle_optimizations = false;
 
 	if (NULL == stream) {
 		dm_error("DC: dc_stream is NULL!\n");
@@ -297,20 +296,36 @@ bool dc_stream_set_cursor_attributes(
 
 	stream->cursor_attributes = *attributes;
 
-	dc_z10_restore(dc);
-	/* disable idle optimizations while updating cursor */
-	if (dc->idle_optimizations_allowed) {
-		dc_allow_idle_optimizations(dc, false);
-		reset_idle_optimizations = true;
-	}
+	return true;
+}
 
-	program_cursor_attributes(dc, stream, attributes);
-
-	/* re-enable idle optimizations if necessary */
-	if (reset_idle_optimizations && !dc->debug.disable_dmub_reallow_idle)
-		dc_allow_idle_optimizations(dc, true);
+bool dc_stream_program_cursor_attributes(
+	struct dc_stream_state *stream,
+	const struct dc_cursor_attributes *attributes)
+{
+	struct dc  *dc;
+	bool reset_idle_optimizations = false;
 
-	return true;
+	dc = stream ? stream->ctx->dc : NULL;
+
+	if (dc_stream_set_cursor_attributes(stream, attributes)) {
+		dc_z10_restore(dc);
+		/* disable idle optimizations while updating cursor */
+		if (dc->idle_optimizations_allowed) {
+			dc_allow_idle_optimizations(dc, false);
+			reset_idle_optimizations = true;
+		}
+
+		program_cursor_attributes(dc, stream, attributes);
+
+		/* re-enable idle optimizations if necessary */
+		if (reset_idle_optimizations && !dc->debug.disable_dmub_reallow_idle)
+			dc_allow_idle_optimizations(dc, true);
+
+		return true;
+	}
+
+	return false;
 }
 
 static void program_cursor_position(
@@ -355,9 +370,6 @@ bool dc_stream_set_cursor_position(
 	struct dc_stream_state *stream,
 	const struct dc_cursor_position *position)
 {
-	struct dc *dc;
-	bool reset_idle_optimizations = false;
-
 	if (NULL == stream) {
 		dm_error("DC: dc_stream is NULL!\n");
 		return false;
@@ -368,24 +380,43 @@ bool dc_stream_set_cursor_position(
 		return false;
 	}
 
+	stream->cursor_position = *position;
+
+
+	return true;
+}
+
+bool dc_stream_program_cursor_position(
+	struct dc_stream_state *stream,
+	const struct dc_cursor_position *position)
+{
+	struct dc *dc;
+	bool reset_idle_optimizations = false;
+	const struct dc_cursor_position *old_position;
+
+	old_position = stream ? &stream->cursor_position : NULL;
 	dc = stream->ctx->dc;
-	dc_z10_restore(dc);
 
-	/* disable idle optimizations if enabling cursor */
-	if (dc->idle_optimizations_allowed && (!stream->cursor_position.enable || dc->debug.exit_idle_opt_for_cursor_updates)
-			&& position->enable) {
-		dc_allow_idle_optimizations(dc, false);
-		reset_idle_optimizations = true;
-	}
+	if (dc_stream_set_cursor_position(stream, position)) {
+		dc_z10_restore(dc);
 
-	stream->cursor_position = *position;
+		/* disable idle optimizations if enabling cursor */
+		if (dc->idle_optimizations_allowed &&
+		    (!old_position->enable || dc->debug.exit_idle_opt_for_cursor_updates) &&
+		    position->enable) {
+			dc_allow_idle_optimizations(dc, false);
+			reset_idle_optimizations = true;
+		}
 
-	program_cursor_position(dc, stream, position);
-	/* re-enable idle optimizations if necessary */
-	if (reset_idle_optimizations && !dc->debug.disable_dmub_reallow_idle)
-		dc_allow_idle_optimizations(dc, true);
+		program_cursor_position(dc, stream, position);
+		/* re-enable idle optimizations if necessary */
+		if (reset_idle_optimizations && !dc->debug.disable_dmub_reallow_idle)
+			dc_allow_idle_optimizations(dc, true);
 
-	return true;
+		return true;
+	}
+
+	return false;
 }
 
 bool dc_stream_add_writeback(struct dc *dc,
--- a/drivers/gpu/drm/amd/display/dc/dc_stream.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_stream.h
@@ -470,10 +470,18 @@ bool dc_stream_set_cursor_attributes(
 	struct dc_stream_state *stream,
 	const struct dc_cursor_attributes *attributes);
 
+bool dc_stream_program_cursor_attributes(
+	struct dc_stream_state *stream,
+	const struct dc_cursor_attributes *attributes);
+
 bool dc_stream_set_cursor_position(
 	struct dc_stream_state *stream,
 	const struct dc_cursor_position *position);
 
+bool dc_stream_program_cursor_position(
+	struct dc_stream_state *stream,
+	const struct dc_cursor_position *position);
+
 
 bool dc_stream_adjust_vmin_vmax(struct dc *dc,
 				struct dc_stream_state *stream,
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c
@@ -1041,7 +1041,7 @@ bool dcn30_apply_idle_power_optimization
 
 					/* Use copied cursor, and it's okay to not switch back */
 					cursor_attr.address.quad_part = cmd.mall.cursor_copy_dst.quad_part;
-					dc_stream_set_cursor_attributes(stream, &cursor_attr);
+					dc_stream_program_cursor_attributes(stream, &cursor_attr);
 				}
 
 				/* Enable MALL */


