Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232A8FBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8507BC4339C;
	Mon, 15 May 2023 17:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170024;
	bh=9El609+Nibho81bobFPB1/SB183PIIVPQUPL50EmM54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rvX5Y84UbdSl08pxLhOFXkCJll/XEdtTrXWnhhPnq5upBGSZPhadsDwMVeI9cRptt
	 QIsSDMxDTpbomRVCsYGF1FDx2Kn4wuYR879aP7OwSmlrA/i4fKlFrGKjXjWw5DM8E3
	 yQEA5+vJjk9dE+nx3yqyoQWBzyveHnApi0QHy0Vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Lei <Jun.Lei@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 221/246] drm/amd/display: Add minimum Z8 residency debug option
Date: Mon, 15 May 2023 18:27:13 +0200
Message-Id: <20230515161729.223087980@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 0db13eae41fcc67f408dbb3dfda59633c4fa03fb ]

[Why]
Allows finer control and tuning for debug and profiling.

[How]
Add the debug option into DC. The default remains the same as before
for now.

Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: d893f39320e1 ("drm/amd/display: Lowering min Z8 residency time")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc.h                     | 1 +
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c | 1 +
 drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c    | 3 ++-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index 84caf1f6b9e0e..3fb868f2f6f5b 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -795,6 +795,7 @@ struct dc_debug_options {
 	unsigned int force_odm_combine; //bit vector based on otg inst
 	unsigned int seamless_boot_odm_combine;
 	unsigned int force_odm_combine_4to1; //bit vector based on otg inst
+	int minimum_z8_residency_time;
 	bool disable_z9_mpc;
 	unsigned int force_fclk_khz;
 	bool enable_tri_buf;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
index 9ffba4c6fe550..5c23c934c9751 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
@@ -887,6 +887,7 @@ static const struct dc_plane_cap plane_cap = {
 static const struct dc_debug_options debug_defaults_drv = {
 	.disable_z10 = false,
 	.enable_z9_disable_interface = true,
+	.minimum_z8_residency_time = 1000,
 	.psr_skip_crtc_disable = true,
 	.disable_dmcu = true,
 	.force_abm_enable = false,
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c
index d3ba65efe1d2e..f3cfc144e3587 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c
@@ -973,7 +973,8 @@ static enum dcn_zstate_support_state  decide_zstate_support(struct dc *dc, struc
 	else if (context->stream_count == 1 &&  context->streams[0]->signal == SIGNAL_TYPE_EDP) {
 		struct dc_link *link = context->streams[0]->sink->link;
 		struct dc_stream_status *stream_status = &context->stream_status[0];
-		bool allow_z8 = context->bw_ctx.dml.vba.StutterPeriod > 1000.0;
+		int minmum_z8_residency = dc->debug.minimum_z8_residency_time > 0 ? dc->debug.minimum_z8_residency_time : 1000;
+		bool allow_z8 = context->bw_ctx.dml.vba.StutterPeriod > (double)minmum_z8_residency;
 		bool is_pwrseq0 = link->link_index == 0;
 
 		if (dc_extended_blank_supported(dc)) {
-- 
2.39.2



