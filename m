Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB082346E5E;
	Wed, 20 May 2026 17:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298092; cv=none; b=tKdmzpEb+Xdbwnfk4yzpA3n7eEY1DCoFfGv5INucIeJgtaIBV8GlieLKjMnNuzquqayuCJ+O9fjABDpgoJXvLKZPctMvvlIZ8m5hKunn/Wgz6ZJ2z4nNe7+RZQMj8VK2hzX+Wf/KhQU+jwoIk5oSmc0zB4I7/VHULftZPLMJqVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298092; c=relaxed/simple;
	bh=G/+I+Gr6zx1KJnEalpYn8nHDYl3CI7Nmf4Mp+LRc51w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dXC2cRKwqdaz3BITMFXjsJdGir9DVngbUWDoC8P7715ebh70NM3ewQUKJ4Dv7cLYaqVUJajtzYllMyvSLZDpy4VtH0ZEpi5f6T5A8EDuIq+8ALER30a65umZ4PSWhewi88K4H2vZiY/XjqnqiPVCIfHjkFQ1MuRukkGhKFA/4YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oV3UJEQM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oV3UJEQM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BAC01F0089E;
	Wed, 20 May 2026 17:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298091;
	bh=J2zOVQ5ublqEzgnvFTfdzkEjimedq3qFVJx/Xru1fyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oV3UJEQM8DjYJCMWsQBpFyvxMlqPo83c93mccYXpKE2hmQxgG4XMmIWx/ujMvzfVX
	 c6Tw9+eajFooWNCoy8FDcHYoex8gG7t+gFjiQheGGXKNjh8R8Pp9pSFlzF3kC0/1Xb
	 wn0yPAJI2XCUtz/pDFTAY+dAv4pkFTbgOtaIg3mQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 262/957] drm/amd/pm/smu7: Fix SMU7 voltage dependency on display clock
Date: Wed, 20 May 2026 18:12:25 +0200
Message-ID: <20260520162140.225843056@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 0138610c14130425be53423b35336561829965e0 ]

The DCE (display controller engine) requires a minimum voltage
in order to function correctly, depending on which clock level
it currently uses.

Add a new table that contains display clock frequency levels
and the corresponding required voltages. The clock frequency
levels are taken from DC (and the old radeon driver's voltage
dependency table for CI in cases where its values were lower).
The voltage levels are taken from the following function:
phm_initializa_dynamic_state_adjustment_rule_settings().
Furthermore, in case of CI, call smu7_patch_vddc() on the new
table to account for leakage voltage (like in radeon).

Use the display clock value from amd_pp_display_configuration
to look up the voltage level needed by the DCE. Send the
voltage to the SMU via the PPSMC_MSG_VddC_Request command.

The previous implementation of this feature was non-functional
because it relied on a "dal_power_level" field which was never
assigned; and it was not at all implemented for CI ASICs.

I verified this on a Radeon R9 M380 which previously booted to
a black screen with DC enabled (default since Linux 6.19), but
now works correctly.

Fixes: 599a7e9fe1b6 ("drm/amd/powerplay: implement smu7 hwmgr to manager asics with smu ip version 7.")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c   | 88 ++++++++++++++++++-
 drivers/gpu/drm/amd/pm/powerplay/inc/hwmgr.h  |  1 +
 2 files changed, 86 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
index 9b28c07282699..07d946c38ec04 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
@@ -2802,6 +2802,10 @@ static int smu7_patch_dependency_tables_with_leakage(struct pp_hwmgr *hwmgr)
 	if (tmp)
 		return -EINVAL;
 
+	tmp = smu7_patch_vddc(hwmgr, hwmgr->dyn_state.vddc_dependency_on_display_clock);
+	if (tmp)
+		return -EINVAL;
+
 	tmp = smu7_patch_vce_vddc(hwmgr, hwmgr->dyn_state.vce_clock_voltage_dependency_table);
 	if (tmp)
 		return -EINVAL;
@@ -2885,6 +2889,8 @@ static int smu7_hwmgr_backend_fini(struct pp_hwmgr *hwmgr)
 {
 	kfree(hwmgr->dyn_state.vddc_dep_on_dal_pwrl);
 	hwmgr->dyn_state.vddc_dep_on_dal_pwrl = NULL;
+	kfree(hwmgr->dyn_state.vddc_dependency_on_display_clock);
+	hwmgr->dyn_state.vddc_dependency_on_display_clock = NULL;
 	kfree(hwmgr->backend);
 	hwmgr->backend = NULL;
 
@@ -2955,6 +2961,51 @@ static int smu7_update_edc_leakage_table(struct pp_hwmgr *hwmgr)
 	return ret;
 }
 
+static int smu7_init_voltage_dependency_on_display_clock_table(struct pp_hwmgr *hwmgr)
+{
+	struct phm_clock_voltage_dependency_table *table;
+
+	if (!amdgpu_device_ip_get_ip_block(hwmgr->adev, AMD_IP_BLOCK_TYPE_DCE))
+		return 0;
+
+	table = kzalloc(struct_size(table, entries, 4), GFP_KERNEL);
+	if (!table)
+		return -ENOMEM;
+
+	if (hwmgr->chip_id >= CHIP_POLARIS10) {
+		table->entries[0].clk = 38918;
+		table->entries[1].clk = 45900;
+		table->entries[2].clk = 66700;
+		table->entries[3].clk = 113200;
+
+		table->entries[0].v = 700;
+		table->entries[1].v = 740;
+		table->entries[2].v = 800;
+		table->entries[3].v = 900;
+	} else {
+		if (hwmgr->chip_family == AMDGPU_FAMILY_CZ) {
+			table->entries[0].clk = 35200;
+			table->entries[1].clk = 35200;
+			table->entries[2].clk = 46700;
+			table->entries[3].clk = 64300;
+		} else {
+			table->entries[0].clk = 0;
+			table->entries[1].clk = 35200;
+			table->entries[2].clk = 54000;
+			table->entries[3].clk = 62500;
+		}
+
+		table->entries[0].v = 0;
+		table->entries[1].v = 720;
+		table->entries[2].v = 810;
+		table->entries[3].v = 900;
+	}
+
+	table->count = 4;
+	hwmgr->dyn_state.vddc_dependency_on_display_clock = table;
+	return 0;
+}
+
 static int smu7_hwmgr_backend_init(struct pp_hwmgr *hwmgr)
 {
 	struct amdgpu_device *adev = hwmgr->adev;
@@ -2983,6 +3034,10 @@ static int smu7_hwmgr_backend_init(struct pp_hwmgr *hwmgr)
 		smu7_get_elb_voltages(hwmgr);
 	}
 
+	result = smu7_init_voltage_dependency_on_display_clock_table(hwmgr);
+	if (result)
+		goto fail;
+
 	if (hwmgr->pp_table_version == PP_TABLE_V1) {
 		smu7_complete_dependency_tables(hwmgr);
 		smu7_set_private_data_based_on_pptable_v1(hwmgr);
@@ -3079,13 +3134,40 @@ static int smu7_force_dpm_highest(struct pp_hwmgr *hwmgr)
 	return 0;
 }
 
+static uint32_t smu7_lookup_vddc_from_dispclk(struct pp_hwmgr *hwmgr)
+{
+	const struct amd_pp_display_configuration *cfg = hwmgr->display_config;
+	const struct phm_clock_voltage_dependency_table *vddc_dep_on_dispclk =
+			hwmgr->dyn_state.vddc_dependency_on_display_clock;
+	uint32_t i;
+
+	if (!vddc_dep_on_dispclk || !vddc_dep_on_dispclk->count ||
+	    !cfg || !cfg->num_display || !cfg->display_clk)
+		return 0;
+
+	/* Start from 1 because ClocksStateUltraLow should not be used according to DC. */
+	for (i = 1; i < vddc_dep_on_dispclk->count; ++i)
+		if (vddc_dep_on_dispclk->entries[i].clk >= cfg->display_clk)
+			return vddc_dep_on_dispclk->entries[i].v;
+
+	return vddc_dep_on_dispclk->entries[vddc_dep_on_dispclk->count - 1].v;
+}
+
+static void smu7_apply_minimum_dce_voltage_request(struct pp_hwmgr *hwmgr)
+{
+	uint32_t req_vddc = smu7_lookup_vddc_from_dispclk(hwmgr);
+
+	smum_send_msg_to_smc_with_parameter(hwmgr,
+			PPSMC_MSG_VddC_Request,
+			req_vddc * VOLTAGE_SCALE,
+			NULL);
+}
+
 static int smu7_upload_dpm_level_enable_mask(struct pp_hwmgr *hwmgr)
 {
 	struct smu7_hwmgr *data = (struct smu7_hwmgr *)(hwmgr->backend);
 
-	if (hwmgr->pp_table_version == PP_TABLE_V1)
-		phm_apply_dal_min_voltage_request(hwmgr);
-/* TO DO  for v0 iceland and Ci*/
+	smu7_apply_minimum_dce_voltage_request(hwmgr);
 
 	if (!data->sclk_dpm_key_disabled) {
 		if (data->dpm_level_enable_mask.sclk_dpm_enable_mask)
diff --git a/drivers/gpu/drm/amd/pm/powerplay/inc/hwmgr.h b/drivers/gpu/drm/amd/pm/powerplay/inc/hwmgr.h
index c661185753b42..2f49c95342a14 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/inc/hwmgr.h
+++ b/drivers/gpu/drm/amd/pm/powerplay/inc/hwmgr.h
@@ -631,6 +631,7 @@ struct phm_dynamic_state_info {
 	struct phm_clock_voltage_dependency_table *vddci_dependency_on_mclk;
 	struct phm_clock_voltage_dependency_table *vddc_dependency_on_mclk;
 	struct phm_clock_voltage_dependency_table *mvdd_dependency_on_mclk;
+	struct phm_clock_voltage_dependency_table *vddc_dependency_on_display_clock;
 	struct phm_clock_voltage_dependency_table *vddc_dep_on_dal_pwrl;
 	struct phm_clock_array                    *valid_sclk_values;
 	struct phm_clock_array                    *valid_mclk_values;
-- 
2.53.0



