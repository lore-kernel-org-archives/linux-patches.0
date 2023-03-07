Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87606BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B3BC433EF;
	Tue,  7 Mar 2023 17:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211040;
	bh=4VczTlAkO31x6JL1uab2h4dBErDttspwdyHNPQbWUrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p7MN0xWlDgPfCuMNT+31WGYwOxw5tMd5RqzfiVRVEkFM76xTBforI0EG7sEsyB++X
	 6j9euAts9s21u2+kU0YnWt8VgpruOdNE3VSeYSISSpF0Q7Z1+OwrSlQH7s8AT3XgTS
	 0seA5LPSUDhGIgWp0DSscbMXYzDnm509I2CfosX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0735/1001] drm/amd/display: disable SubVP + DRR to prevent underflow
Date: Tue,  7 Mar 2023 17:58:27 +0100
Message-Id: <20230307170053.603912962@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

[ Upstream commit 80c6d6804f31451848a3956a70c2bcb1f07cfcb0 ]

[Why&How]
Temporarily disable SubVP+DRR since Xorg has an architectural limitation
where freesync will not work in a multi monitor configuration. SubVP+DRR
requires that freesync be working.

Whether OS has variable refresh setting enabled or not, the state on
the crtc remains same unless an application requests VRR. Due to this,
there is no way to know whether freesync will actually work or not
while we are on the desktop from the kernel's perspective.

If userspace does not have a limitation with multi-display freesync (for
example wayland), then this feature can be enabled by adding a
dcfeaturemask option to amdgpu on the kernel cmdline like:

amdgpu.dcfeaturemask=0x200

Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c    | 5 +++++
 drivers/gpu/drm/amd/display/dc/dc.h                  | 2 +-
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c | 4 ++++
 drivers/gpu/drm/amd/include/amd_shared.h             | 1 +
 4 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 027ffa5ccda46..1ba8a2905f824 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1551,6 +1551,11 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 	if (amdgpu_dc_feature_mask & DC_DISABLE_LTTPR_DP2_0)
 		init_data.flags.allow_lttpr_non_transparent_mode.bits.DP2_0 = true;
 
+	/* Disable SubVP + DRR config by default */
+	init_data.flags.disable_subvp_drr = true;
+	if (amdgpu_dc_feature_mask & DC_ENABLE_SUBVP_DRR)
+		init_data.flags.disable_subvp_drr = false;
+
 	init_data.flags.seamless_boot_edp_requested = false;
 
 	if (check_seamless_boot_capability(adev)) {
diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index 85ebeaa2de186..37998dc0fc144 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -410,7 +410,7 @@ struct dc_config {
 	bool force_bios_enable_lttpr;
 	uint8_t force_bios_fixed_vs;
 	int sdpif_request_limit_words_per_umc;
-
+	bool disable_subvp_drr;
 };
 
 enum visual_confirm {
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
index 8450f59c26186..69e205ac58b25 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -877,6 +877,10 @@ static bool subvp_drr_schedulable(struct dc *dc, struct dc_state *context, struc
 	int16_t stretched_drr_us = 0;
 	int16_t drr_stretched_vblank_us = 0;
 	int16_t max_vblank_mallregion = 0;
+	const struct dc_config *config = &dc->config;
+
+	if (config->disable_subvp_drr)
+		return false;
 
 	// Find SubVP pipe
 	for (i = 0; i < dc->res_pool->pipe_count; i++) {
diff --git a/drivers/gpu/drm/amd/include/amd_shared.h b/drivers/gpu/drm/amd/include/amd_shared.h
index f175e65b853a0..e4a22c68517d1 100644
--- a/drivers/gpu/drm/amd/include/amd_shared.h
+++ b/drivers/gpu/drm/amd/include/amd_shared.h
@@ -240,6 +240,7 @@ enum DC_FEATURE_MASK {
 	DC_DISABLE_LTTPR_DP2_0 = (1 << 6), //0x40, disabled by default
 	DC_PSR_ALLOW_SMU_OPT = (1 << 7), //0x80, disabled by default
 	DC_PSR_ALLOW_MULTI_DISP_OPT = (1 << 8), //0x100, disabled by default
+	DC_ENABLE_SUBVP_DRR = (1 << 9), // 0x200, disabled by default
 };
 
 enum DC_DEBUG_MASK {
-- 
2.39.2



