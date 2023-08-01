Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FABF200A5
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49AAC433C8;
	Tue,  1 Aug 2023 09:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882330;
	bh=tMoUAGfdj66RAtX806LNdzBDqN9RZZW2WJx1QIK0ExM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MJDwgu4QiiicFcIysFR/LX1NGBLM6+mmS/FQRFR8FkCYTWBVqYgsc4nn59LmQTN1a
	 +pTyssZpJZFb2TamPxCSQ6jHIo7gOsg5hbZJjcfJkLDbh78EYF4gKnHsHwO6Ehc1h6
	 N9m0WJH33MpK2fH7lSaV+Alx2uCL4u7ou1XXvhd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <Alvin.Lee2@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/228] drm/amd/display: Add FAMS validation before trying to use it
Date: Tue,  1 Aug 2023 11:18:45 +0200
Message-ID: <20230801091925.254191995@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

[ Upstream commit e3416e872f84086667df21daf166506fab97358d ]

To ensure that FAMS can be used, DC must check if there is VRR support.
This commit adds the required configuration to ensure FAMS can be executed in the target system.

Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 2a9482e55968 ("drm/amd/display: Prevent vtotal from being set to 0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c          | 6 ++++++
 drivers/gpu/drm/amd/display/dc/dc_stream.h        | 1 +
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_optc.c | 7 ++++++-
 drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h   | 2 +-
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 6e2220e2e5ba3..27cec123cb06f 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2588,6 +2588,12 @@ static enum surface_update_type check_update_surfaces_for_stream(
 
 		if (stream_update->mst_bw_update)
 			su_flags->bits.mst_bw = 1;
+
+		if (stream_update->stream && stream_update->stream->freesync_on_desktop &&
+			(stream_update->vrr_infopacket || stream_update->allow_freesync ||
+				stream_update->vrr_active_variable))
+			su_flags->bits.fams_changed = 1;
+
 		if (stream_update->crtc_timing_adjust && dc_extended_blank_supported(dc))
 			su_flags->bits.crtc_timing_adjust = 1;
 
diff --git a/drivers/gpu/drm/amd/display/dc/dc_stream.h b/drivers/gpu/drm/amd/display/dc/dc_stream.h
index 73dccd485895d..364ff913527d8 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_stream.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_stream.h
@@ -131,6 +131,7 @@ union stream_update_flags {
 		uint32_t dsc_changed : 1;
 		uint32_t mst_bw : 1;
 		uint32_t crtc_timing_adjust : 1;
+		uint32_t fams_changed : 1;
 	} bits;
 
 	uint32_t raw;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_optc.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_optc.c
index 25749f7d88366..94894fd6c9062 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_optc.c
@@ -292,7 +292,12 @@ void optc3_wait_drr_doublebuffer_pending_clear(struct timing_generator *optc)
 
 void optc3_set_vtotal_min_max(struct timing_generator *optc, int vtotal_min, int vtotal_max)
 {
-	optc1_set_vtotal_min_max(optc, vtotal_min, vtotal_max);
+	struct dc *dc = optc->ctx->dc;
+
+	if (dc->caps.dmub_caps.mclk_sw && !dc->debug.disable_fams)
+		dc_dmub_srv_drr_update_cmd(dc, optc->inst, vtotal_min, vtotal_max);
+	else
+		optc1_set_vtotal_min_max(optc, vtotal_min, vtotal_max);
 }
 
 void optc3_tg_init(struct timing_generator *optc)
diff --git a/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h b/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h
index 27a4ea7dc74ec..d8c05bc45957b 100644
--- a/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h
+++ b/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h
@@ -345,7 +345,7 @@ union dmub_fw_boot_status {
 		uint32_t optimized_init_done : 1; /**< 1 if optimized init done */
 		uint32_t restore_required : 1; /**< 1 if driver should call restore */
 		uint32_t defer_load : 1; /**< 1 if VBIOS data is deferred programmed */
-		uint32_t reserved : 1;
+		uint32_t fams_enabled : 1; /**< 1 if VBIOS data is deferred programmed */
 		uint32_t detection_required: 1; /**<  if detection need to be triggered by driver */
 
 	} bits; /**< status bits */
-- 
2.39.2



