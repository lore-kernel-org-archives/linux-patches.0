Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F259446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:34:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1341C433C8;
	Sun, 13 Aug 2023 21:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962462;
	bh=z0jKmbNGbh9G3GNX/cUAormnXg3p5CZ0IAFdH+dlhRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aBQ2kYxS3a0OlY7SiXI+N2RfaPIvZN2nX7rsV+FJBKmrAa68ls7JwxRYKsSo6/q8m
	 mOxoXHmeOSzZ+AcqSo4wWizXmze9ra6Se1QtwwLKNlcFuPMg7wrJTkZpieBa2PT0Yj
	 k3aGDG/nszmYBsJNxWxr0tayVcjXy0vuAa5XmbBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Evan Quan <evan.quan@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 038/149] drm/amd/pm: expose swctf threshold setting for legacy powerplay
Date: Sun, 13 Aug 2023 23:18:03 +0200
Message-ID: <20230813211719.947375245@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Evan Quan <evan.quan@amd.com>

commit 064329c595da56eff6d7a7e7760660c726433139 upstream

Preparation for coming optimization which eliminates the influence of
GPU temperature momentary fluctuation.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h                  |    2 ++
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/hardwaremanager.c |    4 +++-
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c      |    2 ++
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c    |   10 ++++++++++
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c    |    4 ++++
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c    |    4 ++++
 drivers/gpu/drm/amd/pm/powerplay/inc/power_state.h       |    1 +
 7 files changed, 26 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h
+++ b/drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h
@@ -89,6 +89,8 @@ struct amdgpu_dpm_thermal {
 	int                max_mem_crit_temp;
 	/* memory max emergency(shutdown) temp */
 	int                max_mem_emergency_temp;
+	/* SWCTF threshold */
+	int                sw_ctf_threshold;
 	/* was last interrupt low to high or high to low */
 	bool               high_to_low;
 	/* interrupt source */
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/hardwaremanager.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/hardwaremanager.c
@@ -241,7 +241,8 @@ int phm_start_thermal_controller(struct
 		TEMP_RANGE_MAX,
 		TEMP_RANGE_MIN,
 		TEMP_RANGE_MAX,
-		TEMP_RANGE_MAX};
+		TEMP_RANGE_MAX,
+		0};
 	struct amdgpu_device *adev = hwmgr->adev;
 
 	if (!hwmgr->not_vf)
@@ -265,6 +266,7 @@ int phm_start_thermal_controller(struct
 	adev->pm.dpm.thermal.min_mem_temp = range.mem_min;
 	adev->pm.dpm.thermal.max_mem_crit_temp = range.mem_crit_max;
 	adev->pm.dpm.thermal.max_mem_emergency_temp = range.mem_emergency_max;
+	adev->pm.dpm.thermal.sw_ctf_threshold = range.sw_ctf_threshold;
 
 	return ret;
 }
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
@@ -5381,6 +5381,8 @@ static int smu7_get_thermal_temperature_
 		thermal_data->max = data->thermal_temp_setting.temperature_shutdown *
 			PP_TEMPERATURE_UNITS_PER_CENTIGRADES;
 
+	thermal_data->sw_ctf_threshold = thermal_data->max;
+
 	return 0;
 }
 
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -5221,6 +5221,9 @@ static int vega10_get_thermal_temperatur
 {
 	struct vega10_hwmgr *data = hwmgr->backend;
 	PPTable_t *pp_table = &(data->smc_state_table.pp_table);
+	struct phm_ppt_v2_information *pp_table_info =
+		(struct phm_ppt_v2_information *)(hwmgr->pptable);
+	struct phm_tdp_table *tdp_table = pp_table_info->tdp_table;
 
 	memcpy(thermal_data, &SMU7ThermalWithDelayPolicy[0], sizeof(struct PP_TemperatureRange));
 
@@ -5237,6 +5240,13 @@ static int vega10_get_thermal_temperatur
 	thermal_data->mem_emergency_max = (pp_table->ThbmLimit + CTF_OFFSET_HBM)*
 		PP_TEMPERATURE_UNITS_PER_CENTIGRADES;
 
+	if (tdp_table->usSoftwareShutdownTemp > pp_table->ThotspotLimit &&
+	    tdp_table->usSoftwareShutdownTemp < VEGA10_THERMAL_MAXIMUM_ALERT_TEMP)
+		thermal_data->sw_ctf_threshold = tdp_table->usSoftwareShutdownTemp;
+	else
+		thermal_data->sw_ctf_threshold = VEGA10_THERMAL_MAXIMUM_ALERT_TEMP;
+	thermal_data->sw_ctf_threshold *= PP_TEMPERATURE_UNITS_PER_CENTIGRADES;
+
 	return 0;
 }
 
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c
@@ -2742,6 +2742,8 @@ static int vega12_notify_cac_buffer_info
 static int vega12_get_thermal_temperature_range(struct pp_hwmgr *hwmgr,
 		struct PP_TemperatureRange *thermal_data)
 {
+	struct phm_ppt_v3_information *pptable_information =
+		(struct phm_ppt_v3_information *)hwmgr->pptable;
 	struct vega12_hwmgr *data =
 			(struct vega12_hwmgr *)(hwmgr->backend);
 	PPTable_t *pp_table = &(data->smc_state_table.pp_table);
@@ -2760,6 +2762,8 @@ static int vega12_get_thermal_temperatur
 		PP_TEMPERATURE_UNITS_PER_CENTIGRADES;
 	thermal_data->mem_emergency_max = (pp_table->ThbmLimit + CTF_OFFSET_HBM)*
 		PP_TEMPERATURE_UNITS_PER_CENTIGRADES;
+	thermal_data->sw_ctf_threshold = pptable_information->us_software_shutdown_temp *
+		PP_TEMPERATURE_UNITS_PER_CENTIGRADES;
 
 	return 0;
 }
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
@@ -4213,6 +4213,8 @@ static int vega20_notify_cac_buffer_info
 static int vega20_get_thermal_temperature_range(struct pp_hwmgr *hwmgr,
 		struct PP_TemperatureRange *thermal_data)
 {
+	struct phm_ppt_v3_information *pptable_information =
+		(struct phm_ppt_v3_information *)hwmgr->pptable;
 	struct vega20_hwmgr *data =
 			(struct vega20_hwmgr *)(hwmgr->backend);
 	PPTable_t *pp_table = &(data->smc_state_table.pp_table);
@@ -4231,6 +4233,8 @@ static int vega20_get_thermal_temperatur
 		PP_TEMPERATURE_UNITS_PER_CENTIGRADES;
 	thermal_data->mem_emergency_max = (pp_table->ThbmLimit + CTF_OFFSET_HBM)*
 		PP_TEMPERATURE_UNITS_PER_CENTIGRADES;
+	thermal_data->sw_ctf_threshold = pptable_information->us_software_shutdown_temp *
+		PP_TEMPERATURE_UNITS_PER_CENTIGRADES;
 
 	return 0;
 }
--- a/drivers/gpu/drm/amd/pm/powerplay/inc/power_state.h
+++ b/drivers/gpu/drm/amd/pm/powerplay/inc/power_state.h
@@ -131,6 +131,7 @@ struct PP_TemperatureRange {
 	int mem_min;
 	int mem_crit_max;
 	int mem_emergency_max;
+	int sw_ctf_threshold;
 };
 
 struct PP_StateValidationBlock {


