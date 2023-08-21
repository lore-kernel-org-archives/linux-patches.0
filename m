Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDDB1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:00:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F313CC433C8;
	Mon, 21 Aug 2023 20:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648043;
	bh=uUZjsbFqBr2d5lMs9bBsLBNcJ3RSbFlRl0DXdjgStGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mFwwdrPhcx6G6ZYp+HJONn62io3t3valY9m9yNi4TS+kd2y57ZIkEDdlQfGMxtyP4
	 +WLPRvooASGT5a7nc2RKRqbJ7fMNbXQ7gd1eRH3q9CsDwBAjl09TFtAVQ300cStOWf
	 ufRGGxsRiLp95+zwdtUlw+ccr6GIj3mAI40TEhA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 009/234] Revert "drm/amd/display: disable SubVP + DRR to prevent underflow"
Date: Mon, 21 Aug 2023 21:39:32 +0200
Message-ID: <20230821194129.161408450@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

[ Upstream commit f38129bb081758176dd78304faaee95007fb8838 ]

This reverts commit 80c6d6804f31451848a3956a70c2bcb1f07cfcb0.
The orignal commit was intended as a workaround to prevent underflow and
flickering when using one normal monitor and the other high refresh rate
monitor (> 120Hz).

This patch is being reverted in favour of a software solution to enable
SubVP+DRR

Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c    | 5 -----
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c | 4 ----
 drivers/gpu/drm/amd/include/amd_shared.h             | 1 -
 3 files changed, 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index bdce367544368..4dd9a85f5c724 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1653,11 +1653,6 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 	if (amdgpu_dc_feature_mask & DC_DISABLE_LTTPR_DP2_0)
 		init_data.flags.allow_lttpr_non_transparent_mode.bits.DP2_0 = true;
 
-	/* Disable SubVP + DRR config by default */
-	init_data.flags.disable_subvp_drr = true;
-	if (amdgpu_dc_feature_mask & DC_ENABLE_SUBVP_DRR)
-		init_data.flags.disable_subvp_drr = false;
-
 	init_data.flags.seamless_boot_edp_requested = false;
 
 	if (check_seamless_boot_capability(adev)) {
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
index d8b4119820bfc..1bfda6e2b3070 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -880,10 +880,6 @@ static bool subvp_drr_schedulable(struct dc *dc, struct dc_state *context, struc
 	int16_t stretched_drr_us = 0;
 	int16_t drr_stretched_vblank_us = 0;
 	int16_t max_vblank_mallregion = 0;
-	const struct dc_config *config = &dc->config;
-
-	if (config->disable_subvp_drr)
-		return false;
 
 	// Find SubVP pipe
 	for (i = 0; i < dc->res_pool->pipe_count; i++) {
diff --git a/drivers/gpu/drm/amd/include/amd_shared.h b/drivers/gpu/drm/amd/include/amd_shared.h
index e4a22c68517d1..f175e65b853a0 100644
--- a/drivers/gpu/drm/amd/include/amd_shared.h
+++ b/drivers/gpu/drm/amd/include/amd_shared.h
@@ -240,7 +240,6 @@ enum DC_FEATURE_MASK {
 	DC_DISABLE_LTTPR_DP2_0 = (1 << 6), //0x40, disabled by default
 	DC_PSR_ALLOW_SMU_OPT = (1 << 7), //0x80, disabled by default
 	DC_PSR_ALLOW_MULTI_DISP_OPT = (1 << 8), //0x100, disabled by default
-	DC_ENABLE_SUBVP_DRR = (1 << 9), // 0x200, disabled by default
 };
 
 enum DC_DEBUG_MASK {
-- 
2.40.1



