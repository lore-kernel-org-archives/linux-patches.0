Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D0E6A023;
	Tue, 23 Jan 2024 02:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975328; cv=none; b=iDz5wHEfy8oo3KyHzaL3dIGgiYHwvzrvd0d1yN2r1m4zZ+Y+Z2Ww35HvnhmW1cq08qqeD3oeJfDCZomq3wg5Ft5c1Vx9wtLOtwK/zKqATEhtKPz4Ndl1S2QZCv5527nQUETu6XOdgpgfqifUhWzkrAbTkjKlbGD6KLpom7WfqZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975328; c=relaxed/simple;
	bh=ScgY9LtfZH78rmEwHwWZSwEHh8CE/8xXDedcVKhXmYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcVA3yOlji6EtcSm/YazFMjRqTTV/e3U2LnPYvXU707xuEtxLfurpUdiw+ZVzf/PbMvVdUb5fjzRtmV2zW5I6/cqFIjxZe7IUafd8vIy+l67hvUjXi1qyqR4eZuAvkSV4ix4H2HPxawNBCyipk72Mk9vmMNIV4s0PPP2Zgs4qgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=msAIxQcW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="msAIxQcW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60442C43390;
	Tue, 23 Jan 2024 02:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975328;
	bh=ScgY9LtfZH78rmEwHwWZSwEHh8CE/8xXDedcVKhXmYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=msAIxQcWMqTzHB474ZctYbmGQDSX7Jl119utdGfHXE4oPwrIw0bOdkf6nU/LW1+OM
	 cdZiyBlzqxB/7vpuH1wKuWDgILBSxDiz1s4HVi72wiqhc3sd0vbKD9wJwJtxzt5yeW
	 TjXQdvnuAV7UZGy1mBIKsfzLBzCVLb32+/oT6vUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 292/583] drm/amd/pm: fix a double-free in amdgpu_parse_extended_power_table
Date: Mon, 22 Jan 2024 15:55:43 -0800
Message-ID: <20240122235820.943940746@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit a6582701178a47c4d0cb2188c965c59c0c0647c8 ]

The amdgpu_free_extended_power_table is called in every error-handling
paths of amdgpu_parse_extended_power_table. However, after the following
call chain of returning:

amdgpu_parse_extended_power_table
  |-> kv_dpm_init / si_dpm_init
      (the only two caller of amdgpu_parse_extended_power_table)
        |-> kv_dpm_sw_init / si_dpm_sw_init
            (the only caller of kv_dpm_init / si_dpm_init, accordingly)
              |-> kv_dpm_fini / si_dpm_fini
                  (goto dpm_failed in xx_dpm_sw_init)
                    |-> amdgpu_free_extended_power_table

As above, the amdgpu_free_extended_power_table is called twice in this
returning chain and thus a double-free is triggered. Similarily, the
last kfree in amdgpu_parse_extended_power_table also cause a double free
with amdgpu_free_extended_power_table in kv_dpm_fini.

Fixes: 84176663e70d ("drm/amd/pm: create a new holder for those APIs used only by legacy ASICs(si/kv)")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/pm/legacy-dpm/legacy_dpm.c    | 52 +++++--------------
 1 file changed, 13 insertions(+), 39 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/legacy-dpm/legacy_dpm.c b/drivers/gpu/drm/amd/pm/legacy-dpm/legacy_dpm.c
index 81fb4e5dd804..60377747bab4 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/legacy_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/legacy_dpm.c
@@ -272,10 +272,8 @@ int amdgpu_parse_extended_power_table(struct amdgpu_device *adev)
 				 le16_to_cpu(power_info->pplib4.usVddcDependencyOnSCLKOffset));
 			ret = amdgpu_parse_clk_voltage_dep_table(&adev->pm.dpm.dyn_state.vddc_dependency_on_sclk,
 								 dep_table);
-			if (ret) {
-				amdgpu_free_extended_power_table(adev);
+			if (ret)
 				return ret;
-			}
 		}
 		if (power_info->pplib4.usVddciDependencyOnMCLKOffset) {
 			dep_table = (ATOM_PPLIB_Clock_Voltage_Dependency_Table *)
@@ -283,10 +281,8 @@ int amdgpu_parse_extended_power_table(struct amdgpu_device *adev)
 				 le16_to_cpu(power_info->pplib4.usVddciDependencyOnMCLKOffset));
 			ret = amdgpu_parse_clk_voltage_dep_table(&adev->pm.dpm.dyn_state.vddci_dependency_on_mclk,
 								 dep_table);
-			if (ret) {
-				amdgpu_free_extended_power_table(adev);
+			if (ret)
 				return ret;
-			}
 		}
 		if (power_info->pplib4.usVddcDependencyOnMCLKOffset) {
 			dep_table = (ATOM_PPLIB_Clock_Voltage_Dependency_Table *)
@@ -294,10 +290,8 @@ int amdgpu_parse_extended_power_table(struct amdgpu_device *adev)
 				 le16_to_cpu(power_info->pplib4.usVddcDependencyOnMCLKOffset));
 			ret = amdgpu_parse_clk_voltage_dep_table(&adev->pm.dpm.dyn_state.vddc_dependency_on_mclk,
 								 dep_table);
-			if (ret) {
-				amdgpu_free_extended_power_table(adev);
+			if (ret)
 				return ret;
-			}
 		}
 		if (power_info->pplib4.usMvddDependencyOnMCLKOffset) {
 			dep_table = (ATOM_PPLIB_Clock_Voltage_Dependency_Table *)
@@ -305,10 +299,8 @@ int amdgpu_parse_extended_power_table(struct amdgpu_device *adev)
 				 le16_to_cpu(power_info->pplib4.usMvddDependencyOnMCLKOffset));
 			ret = amdgpu_parse_clk_voltage_dep_table(&adev->pm.dpm.dyn_state.mvdd_dependency_on_mclk,
 								 dep_table);
-			if (ret) {
-				amdgpu_free_extended_power_table(adev);
+			if (ret)
 				return ret;
-			}
 		}
 		if (power_info->pplib4.usMaxClockVoltageOnDCOffset) {
 			ATOM_PPLIB_Clock_Voltage_Limit_Table *clk_v =
@@ -339,10 +331,8 @@ int amdgpu_parse_extended_power_table(struct amdgpu_device *adev)
 				kcalloc(psl->ucNumEntries,
 					sizeof(struct amdgpu_phase_shedding_limits_entry),
 					GFP_KERNEL);
-			if (!adev->pm.dpm.dyn_state.phase_shedding_limits_table.entries) {
-				amdgpu_free_extended_power_table(adev);
+			if (!adev->pm.dpm.dyn_state.phase_shedding_limits_table.entries)
 				return -ENOMEM;
-			}
 
 			entry = &psl->entries[0];
 			for (i = 0; i < psl->ucNumEntries; i++) {
@@ -383,10 +373,8 @@ int amdgpu_parse_extended_power_table(struct amdgpu_device *adev)
 			ATOM_PPLIB_CAC_Leakage_Record *entry;
 			u32 size = cac_table->ucNumEntries * sizeof(struct amdgpu_cac_leakage_table);
 			adev->pm.dpm.dyn_state.cac_leakage_table.entries = kzalloc(size, GFP_KERNEL);
-			if (!adev->pm.dpm.dyn_state.cac_leakage_table.entries) {
-				amdgpu_free_extended_power_table(adev);
+			if (!adev->pm.dpm.dyn_state.cac_leakage_table.entries)
 				return -ENOMEM;
-			}
 			entry = &cac_table->entries[0];
 			for (i = 0; i < cac_table->ucNumEntries; i++) {
 				if (adev->pm.dpm.platform_caps & ATOM_PP_PLATFORM_CAP_EVV) {
@@ -438,10 +426,8 @@ int amdgpu_parse_extended_power_table(struct amdgpu_device *adev)
 				sizeof(struct amdgpu_vce_clock_voltage_dependency_entry);
 			adev->pm.dpm.dyn_state.vce_clock_voltage_dependency_table.entries =
 				kzalloc(size, GFP_KERNEL);
-			if (!adev->pm.dpm.dyn_state.vce_clock_voltage_dependency_table.entries) {
-				amdgpu_free_extended_power_table(adev);
+			if (!adev->pm.dpm.dyn_state.vce_clock_voltage_dependency_table.entries)
 				return -ENOMEM;
-			}
 			adev->pm.dpm.dyn_state.vce_clock_voltage_dependency_table.count =
 				limits->numEntries;
 			entry = &limits->entries[0];
@@ -493,10 +479,8 @@ int amdgpu_parse_extended_power_table(struct amdgpu_device *adev)
 				sizeof(struct amdgpu_uvd_clock_voltage_dependency_entry);
 			adev->pm.dpm.dyn_state.uvd_clock_voltage_dependency_table.entries =
 				kzalloc(size, GFP_KERNEL);
-			if (!adev->pm.dpm.dyn_state.uvd_clock_voltage_dependency_table.entries) {
-				amdgpu_free_extended_power_table(adev);
+			if (!adev->pm.dpm.dyn_state.uvd_clock_voltage_dependency_table.entries)
 				return -ENOMEM;
-			}
 			adev->pm.dpm.dyn_state.uvd_clock_voltage_dependency_table.count =
 				limits->numEntries;
 			entry = &limits->entries[0];
@@ -525,10 +509,8 @@ int amdgpu_parse_extended_power_table(struct amdgpu_device *adev)
 				sizeof(struct amdgpu_clock_voltage_dependency_entry);
 			adev->pm.dpm.dyn_state.samu_clock_voltage_dependency_table.entries =
 				kzalloc(size, GFP_KERNEL);
-			if (!adev->pm.dpm.dyn_state.samu_clock_voltage_dependency_table.entries) {
-				amdgpu_free_extended_power_table(adev);
+			if (!adev->pm.dpm.dyn_state.samu_clock_voltage_dependency_table.entries)
 				return -ENOMEM;
-			}
 			adev->pm.dpm.dyn_state.samu_clock_voltage_dependency_table.count =
 				limits->numEntries;
 			entry = &limits->entries[0];
@@ -548,10 +530,8 @@ int amdgpu_parse_extended_power_table(struct amdgpu_device *adev)
 				 le16_to_cpu(ext_hdr->usPPMTableOffset));
 			adev->pm.dpm.dyn_state.ppm_table =
 				kzalloc(sizeof(struct amdgpu_ppm_table), GFP_KERNEL);
-			if (!adev->pm.dpm.dyn_state.ppm_table) {
-				amdgpu_free_extended_power_table(adev);
+			if (!adev->pm.dpm.dyn_state.ppm_table)
 				return -ENOMEM;
-			}
 			adev->pm.dpm.dyn_state.ppm_table->ppm_design = ppm->ucPpmDesign;
 			adev->pm.dpm.dyn_state.ppm_table->cpu_core_number =
 				le16_to_cpu(ppm->usCpuCoreNumber);
@@ -583,10 +563,8 @@ int amdgpu_parse_extended_power_table(struct amdgpu_device *adev)
 				sizeof(struct amdgpu_clock_voltage_dependency_entry);
 			adev->pm.dpm.dyn_state.acp_clock_voltage_dependency_table.entries =
 				kzalloc(size, GFP_KERNEL);
-			if (!adev->pm.dpm.dyn_state.acp_clock_voltage_dependency_table.entries) {
-				amdgpu_free_extended_power_table(adev);
+			if (!adev->pm.dpm.dyn_state.acp_clock_voltage_dependency_table.entries)
 				return -ENOMEM;
-			}
 			adev->pm.dpm.dyn_state.acp_clock_voltage_dependency_table.count =
 				limits->numEntries;
 			entry = &limits->entries[0];
@@ -606,10 +584,8 @@ int amdgpu_parse_extended_power_table(struct amdgpu_device *adev)
 			ATOM_PowerTune_Table *pt;
 			adev->pm.dpm.dyn_state.cac_tdp_table =
 				kzalloc(sizeof(struct amdgpu_cac_tdp_table), GFP_KERNEL);
-			if (!adev->pm.dpm.dyn_state.cac_tdp_table) {
-				amdgpu_free_extended_power_table(adev);
+			if (!adev->pm.dpm.dyn_state.cac_tdp_table)
 				return -ENOMEM;
-			}
 			if (rev > 0) {
 				ATOM_PPLIB_POWERTUNE_Table_V1 *ppt = (ATOM_PPLIB_POWERTUNE_Table_V1 *)
 					(mode_info->atom_context->bios + data_offset +
@@ -645,10 +621,8 @@ int amdgpu_parse_extended_power_table(struct amdgpu_device *adev)
 			ret = amdgpu_parse_clk_voltage_dep_table(
 					&adev->pm.dpm.dyn_state.vddgfx_dependency_on_sclk,
 					dep_table);
-			if (ret) {
-				kfree(adev->pm.dpm.dyn_state.vddgfx_dependency_on_sclk.entries);
+			if (ret)
 				return ret;
-			}
 		}
 	}
 
-- 
2.43.0



