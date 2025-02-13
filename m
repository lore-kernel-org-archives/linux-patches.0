Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F2A26B097;
	Thu, 13 Feb 2025 15:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459162; cv=none; b=dWwgsuEOPe+MT+0u6A7C3Ns1br63gBQWAoU9FrcivnOOv68Z2muK9pKSGIHc85Q95inVO+tdkTrwTetLLQv2JX1S6RSwHEklTIq3Vkr0vQQLAkVfRrwZwoWWWFTH3MxUSw+3l5ouXwOyTl2L0nvgEqU7uKaN2ZiRO3joIVVn1DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459162; c=relaxed/simple;
	bh=8aFFFJfWOeusvNUrfMOJiCeK4FI6QuDzqqhlCnpFXZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPhxnw9vrRseVOgjZ9ZfX/dQCJKR9/JNoLHxu+Y5vSXIcXP7CcMxsFIVwlf0Zh8RXSFuDCgn122kYyVvWq3ZrBCh8TPXH/SjI8F5/tx6efL3JlEoGYxd4J8jzQ4yKxeXinP/d8WFVD0LWxJix03JAzxEa4jws82KUek9GhMANsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L11MF73t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L11MF73t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ECB1C4CED1;
	Thu, 13 Feb 2025 15:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459161;
	bh=8aFFFJfWOeusvNUrfMOJiCeK4FI6QuDzqqhlCnpFXZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L11MF73tXOe8XiWbitW7pNfpbrULeFhhfRKO9lj23DCrG23afT0/fDri/SgmJai9O
	 mjI+oIbkkI2AMMef7ZyJ5w2HTdR6frmJAm3Ej1fj9r6mWIZXIik2zpy5Ojc8nzzmww
	 2JQGworAxUlbuqVJFiYRVBMUdKpbcpKRWMdZnxQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Lo-an Chen <lo-an.chen@amd.com>,
	Paul Hsieh <paul.hsieh@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.13 187/443] drm/amd/display: Fix seamless boot sequence
Date: Thu, 13 Feb 2025 15:25:52 +0100
Message-ID: <20250213142447.831133226@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lo-an Chen <lo-an.chen@amd.com>

commit e01f07cb92513ca4b9b219ab9caa34d607bc1e2d upstream.

[WHY]
When the system powers up eDP with external monitors in seamless boot
sequence, stutter get enabled before TTU and HUBP registers being
programmed, which resulting in underflow.

[HOW]
Enable TTU in hubp_init.
Change the sequence that do not perpare_bandwidth and optimize_bandwidth
while having seamless boot streams.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Lo-an Chen <lo-an.chen@amd.com>
Signed-off-by: Paul Hsieh <paul.hsieh@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c                   |    2 +-
 drivers/gpu/drm/amd/display/dc/hubbub/dcn30/dcn30_hubbub.c |    3 ++-
 drivers/gpu/drm/amd/display/dc/hubbub/dcn31/dcn31_hubbub.c |    3 ++-
 drivers/gpu/drm/amd/display/dc/hubbub/dcn32/dcn32_hubbub.c |    3 ++-
 drivers/gpu/drm/amd/display/dc/hubbub/dcn35/dcn35_hubbub.c |    3 ++-
 drivers/gpu/drm/amd/display/dc/hubp/dcn30/dcn30_hubp.c     |    2 ++
 drivers/gpu/drm/amd/display/dc/hubp/dcn32/dcn32_hubp.c     |    2 ++
 drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c    |    3 ++-
 8 files changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2063,7 +2063,7 @@ static enum dc_status dc_commit_state_no
 
 	dc_enable_stereo(dc, context, dc_streams, context->stream_count);
 
-	if (context->stream_count > get_seamless_boot_stream_count(context) ||
+	if (get_seamless_boot_stream_count(context) == 0 ||
 		context->stream_count == 0) {
 		/* Must wait for no flips to be pending before doing optimize bw */
 		hwss_wait_for_no_pipes_pending(dc, context);
--- a/drivers/gpu/drm/amd/display/dc/hubbub/dcn30/dcn30_hubbub.c
+++ b/drivers/gpu/drm/amd/display/dc/hubbub/dcn30/dcn30_hubbub.c
@@ -129,7 +129,8 @@ bool hubbub3_program_watermarks(
 	REG_UPDATE(DCHUBBUB_ARB_DF_REQ_OUTSTAND,
 			DCHUBBUB_ARB_MIN_REQ_OUTSTAND, 0x1FF);
 
-	hubbub1_allow_self_refresh_control(hubbub, !hubbub->ctx->dc->debug.disable_stutter);
+	if (safe_to_lower || hubbub->ctx->dc->debug.disable_stutter)
+		hubbub1_allow_self_refresh_control(hubbub, !hubbub->ctx->dc->debug.disable_stutter);
 
 	return wm_pending;
 }
--- a/drivers/gpu/drm/amd/display/dc/hubbub/dcn31/dcn31_hubbub.c
+++ b/drivers/gpu/drm/amd/display/dc/hubbub/dcn31/dcn31_hubbub.c
@@ -750,7 +750,8 @@ static bool hubbub31_program_watermarks(
 	REG_UPDATE(DCHUBBUB_ARB_DF_REQ_OUTSTAND,
 			DCHUBBUB_ARB_MIN_REQ_OUTSTAND, 0x1FF);*/
 
-	hubbub1_allow_self_refresh_control(hubbub, !hubbub->ctx->dc->debug.disable_stutter);
+	if (safe_to_lower || hubbub->ctx->dc->debug.disable_stutter)
+		hubbub1_allow_self_refresh_control(hubbub, !hubbub->ctx->dc->debug.disable_stutter);
 	return wm_pending;
 }
 
--- a/drivers/gpu/drm/amd/display/dc/hubbub/dcn32/dcn32_hubbub.c
+++ b/drivers/gpu/drm/amd/display/dc/hubbub/dcn32/dcn32_hubbub.c
@@ -786,7 +786,8 @@ static bool hubbub32_program_watermarks(
 	REG_UPDATE(DCHUBBUB_ARB_DF_REQ_OUTSTAND,
 			DCHUBBUB_ARB_MIN_REQ_OUTSTAND, 0x1FF);*/
 
-	hubbub1_allow_self_refresh_control(hubbub, !hubbub->ctx->dc->debug.disable_stutter);
+	if (safe_to_lower || hubbub->ctx->dc->debug.disable_stutter)
+		hubbub1_allow_self_refresh_control(hubbub, !hubbub->ctx->dc->debug.disable_stutter);
 
 	hubbub32_force_usr_retraining_allow(hubbub, hubbub->ctx->dc->debug.force_usr_allow);
 
--- a/drivers/gpu/drm/amd/display/dc/hubbub/dcn35/dcn35_hubbub.c
+++ b/drivers/gpu/drm/amd/display/dc/hubbub/dcn35/dcn35_hubbub.c
@@ -326,7 +326,8 @@ static bool hubbub35_program_watermarks(
 			DCHUBBUB_ARB_MIN_REQ_OUTSTAND_COMMIT_THRESHOLD, 0xA);/*hw delta*/
 	REG_UPDATE(DCHUBBUB_ARB_HOSTVM_CNTL, DCHUBBUB_ARB_MAX_QOS_COMMIT_THRESHOLD, 0xF);
 
-	hubbub1_allow_self_refresh_control(hubbub, !hubbub->ctx->dc->debug.disable_stutter);
+	if (safe_to_lower || hubbub->ctx->dc->debug.disable_stutter)
+		hubbub1_allow_self_refresh_control(hubbub, !hubbub->ctx->dc->debug.disable_stutter);
 
 	hubbub32_force_usr_retraining_allow(hubbub, hubbub->ctx->dc->debug.force_usr_allow);
 
--- a/drivers/gpu/drm/amd/display/dc/hubp/dcn30/dcn30_hubp.c
+++ b/drivers/gpu/drm/amd/display/dc/hubp/dcn30/dcn30_hubp.c
@@ -484,6 +484,8 @@ void hubp3_init(struct hubp *hubp)
 	//hubp[i].HUBPREQ_DEBUG.HUBPREQ_DEBUG[26] = 1;
 	REG_WRITE(HUBPREQ_DEBUG, 1 << 26);
 
+	REG_UPDATE(DCHUBP_CNTL, HUBP_TTU_DISABLE, 0);
+
 	hubp_reset(hubp);
 }
 
--- a/drivers/gpu/drm/amd/display/dc/hubp/dcn32/dcn32_hubp.c
+++ b/drivers/gpu/drm/amd/display/dc/hubp/dcn32/dcn32_hubp.c
@@ -168,6 +168,8 @@ void hubp32_init(struct hubp *hubp)
 {
 	struct dcn20_hubp *hubp2 = TO_DCN20_HUBP(hubp);
 	REG_WRITE(HUBPREQ_DEBUG_DB, 1 << 8);
+
+	REG_UPDATE(DCHUBP_CNTL, HUBP_TTU_DISABLE, 0);
 }
 static struct hubp_funcs dcn32_hubp_funcs = {
 	.hubp_enable_tripleBuffer = hubp2_enable_triplebuffer,
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
@@ -236,7 +236,8 @@ void dcn35_init_hw(struct dc *dc)
 		}
 
 		hws->funcs.init_pipes(dc, dc->current_state);
-		if (dc->res_pool->hubbub->funcs->allow_self_refresh_control)
+		if (dc->res_pool->hubbub->funcs->allow_self_refresh_control &&
+			!dc->res_pool->hubbub->ctx->dc->debug.disable_stutter)
 			dc->res_pool->hubbub->funcs->allow_self_refresh_control(dc->res_pool->hubbub,
 					!dc->res_pool->hubbub->ctx->dc->debug.disable_stutter);
 	}


