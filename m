Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4757339FC3;
	Fri, 24 Nov 2023 18:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2vXpFuxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8577C433C8;
	Fri, 24 Nov 2023 18:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849171;
	bh=SuQN66Fft7EH9CaFXOpf7Q0szjFVNTEzy88bsYUUk4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2vXpFuxqLHVmWSpyyTbzu3BUV9mIv5E3P5n+CwDgiIWcf9iKXTnaH94SXDd9rxiA+
	 IbDnu/qb+YeO6lMhUUVT6fzDoiIYM8KwPfR1mgWk7GGZzIPspu5O94alBdI9Jcs8o+
	 zOas0btVpcRYVPvYHfbgVqIoK+DdPAXhhj+MYpC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/530] drm/amd: Disable PP_PCIE_DPM_MASK when dynamic speed switching not supported
Date: Fri, 24 Nov 2023 17:44:01 +0000
Message-ID: <20231124172030.348817679@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit fbf1035b033a51eee48d5f42e781b02fff272ca0 ]

Rather than individual ASICs checking for the quirk, set the quirk at the
driver level.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c              | 2 ++
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c     | 4 +---
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c | 2 +-
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c          | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 69f72bca229c9..b9fd755419fb4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2103,6 +2103,8 @@ static int amdgpu_device_ip_early_init(struct amdgpu_device *adev)
 		adev->pm.pp_feature &= ~PP_GFXOFF_MASK;
 	if (amdgpu_sriov_vf(adev) && adev->asic_type == CHIP_SIENNA_CICHLID)
 		adev->pm.pp_feature &= ~PP_OVERDRIVE_MASK;
+	if (!amdgpu_device_pcie_dynamic_switching_supported())
+		adev->pm.pp_feature &= ~PP_PCIE_DPM_MASK;
 
 	total = true;
 	for (i = 0; i < adev->num_ip_blocks; i++) {
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
index 5a2371484a58c..11372fcc59c8f 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
@@ -1823,9 +1823,7 @@ static void smu7_init_dpm_defaults(struct pp_hwmgr *hwmgr)
 
 	data->mclk_dpm_key_disabled = hwmgr->feature_mask & PP_MCLK_DPM_MASK ? false : true;
 	data->sclk_dpm_key_disabled = hwmgr->feature_mask & PP_SCLK_DPM_MASK ? false : true;
-	data->pcie_dpm_key_disabled =
-		!amdgpu_device_pcie_dynamic_switching_supported() ||
-		!(hwmgr->feature_mask & PP_PCIE_DPM_MASK);
+	data->pcie_dpm_key_disabled = !(hwmgr->feature_mask & PP_PCIE_DPM_MASK);
 	/* need to set voltage control types before EVV patching */
 	data->voltage_control = SMU7_VOLTAGE_CONTROL_NONE;
 	data->vddci_control = SMU7_VOLTAGE_CONTROL_NONE;
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index 0cc5d9769d382..a7f4f82d23b4b 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -2108,7 +2108,7 @@ static int sienna_cichlid_update_pcie_parameters(struct smu_context *smu,
 	min_lane_width = min_lane_width > max_lane_width ?
 			 max_lane_width : min_lane_width;
 
-	if (!amdgpu_device_pcie_dynamic_switching_supported()) {
+	if (!(smu->adev->pm.pp_feature & PP_PCIE_DPM_MASK)) {
 		pcie_table->pcie_gen[0] = max_gen_speed;
 		pcie_table->pcie_lane[0] = max_lane_width;
 	} else {
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
index a280c1ed007f6..4aeb84572e5b8 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -2430,7 +2430,7 @@ int smu_v13_0_update_pcie_parameters(struct smu_context *smu,
 	uint32_t smu_pcie_arg;
 	int ret, i;
 
-	if (!amdgpu_device_pcie_dynamic_switching_supported()) {
+	if (!(smu->adev->pm.pp_feature & PP_PCIE_DPM_MASK)) {
 		if (pcie_table->pcie_gen[num_of_levels - 1] < pcie_gen_cap)
 			pcie_gen_cap = pcie_table->pcie_gen[num_of_levels - 1];
 
-- 
2.42.0



