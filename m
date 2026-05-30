Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9600AEEA8;
	Sat, 30 May 2026 17:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161093; cv=none; b=DI3gIaP9nWVMqVxC1DTtdzunmR3V0OICR39CkT0SAvAKZPthXCx1aK7TC++IIIAnTtmZ3LwNcOq7qJ0C6ecwHKSnI5B5wI8SQMioEejsRyaQ3tA2x7IRLbEUuaQ1tF/YvRkaBy6iHkgnIedByoyv2jWsooAnThkyYw1uBZCGLFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161093; c=relaxed/simple;
	bh=mJwVDUebmr/c9kWRClXrjv9L/6MTNJcb/lonbT1QRdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZUzhSqQmpW1MNydxBJ+ar5+7rTmyVJftmwaBBgbAgK75OYr5DQIJRrqiaaSIqQgRLFikHjotnKPk4szvE3RWFGFmCNr+HAitZ6YBKiNgeZGCWBbUo0gahQ9zJTHgwVtZFkQUfmPYN++RHmczccBl4WpRc/OsaRDC3e/lum5FKOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JVoik4uK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JVoik4uK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C491D1F00893;
	Sat, 30 May 2026 17:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161092;
	bh=qdFthQ5ysaiwYU2QOP2BvzTwwXlHc3TxNfVP5Az7Oiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JVoik4uKtlubgPjjt5JIivBx6UJQAa+ImvMRbvmD/Se4xBoSQRAjdP3T/aqp9GZbf
	 k5s0xy6HUNhRqCOfLzHEZP+4xXArHA0IzKI52UKjtwtspFgAxhdA7Zca2GwCeD4zlb
	 CykfI6p04W5H1QRXqEMLn/Irn67L13d3ylBidCzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 523/969] drm/amd/pm/smu7: Add SCLK cap for quirky Hawaii board
Date: Sat, 30 May 2026 18:00:47 +0200
Message-ID: <20260530160314.795551253@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 4724bc5b8d78c34b993594f9406135408ccb312a ]

On a specific Radeon R9 390X board, the GPU can "randomly" hang
while gaming. Initially I thought this was a RADV bug and tried
to work around this in Mesa:
commit 8ea08747b86b ("radv: Mitigate GPU hang on Hawaii in Dota 2 and RotTR")

However, I got some feedback from other users who are reporting
that the above mitigation causes a significant performance
regression for them, and they didn't experience the hang on their
GPU in the first place.

After some further investigation, it turns out that the problem
is that the highest SCLK DPM level on this board isn't stable.
Lowering SCLK to 1040 MHz (from 1070 MHz) works around the issue,
and has a negligible impact on performance compared to the Mesa
patch. (Note that increasing the voltage can also work around it,
but we felt that lowering the SCLK is the safer option.)

To solve the above issue, add an "sclk_cap" field to smu7_hwmgr
and set this field for the affected board. The capped SCLK value
correctly appears on the sysfs interface and shows up in GUI
tools such as LACT.

Fixes: 9f4b35411cfe ("drm/amd/powerplay: add CI asics support to smumgr (v3)")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c   | 30 ++++++++++++++++---
 .../drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.h   |  1 +
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
index f9454e43e5c63..132669fb39860 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
@@ -788,7 +788,7 @@ static int smu7_setup_dpm_tables_v0(struct pp_hwmgr *hwmgr)
 		hwmgr->dyn_state.vddc_dependency_on_mclk;
 	struct phm_cac_leakage_table *std_voltage_table =
 		hwmgr->dyn_state.cac_leakage_table;
-	uint32_t i;
+	uint32_t i, clk;
 
 	PP_ASSERT_WITH_CODE(allowed_vdd_sclk_table != NULL,
 		"SCLK dependency table is missing. This table is mandatory", return -EINVAL);
@@ -805,10 +805,12 @@ static int smu7_setup_dpm_tables_v0(struct pp_hwmgr *hwmgr)
 	data->dpm_table.sclk_table.count = 0;
 
 	for (i = 0; i < allowed_vdd_sclk_table->count; i++) {
+		clk = min(allowed_vdd_sclk_table->entries[i].clk, data->sclk_cap);
+
 		if (i == 0 || data->dpm_table.sclk_table.dpm_levels[data->dpm_table.sclk_table.count-1].value !=
-				allowed_vdd_sclk_table->entries[i].clk) {
+				clk) {
 			data->dpm_table.sclk_table.dpm_levels[data->dpm_table.sclk_table.count].value =
-				allowed_vdd_sclk_table->entries[i].clk;
+				clk;
 			data->dpm_table.sclk_table.dpm_levels[data->dpm_table.sclk_table.count].enabled = (i == 0) ? 1 : 0;
 			data->dpm_table.sclk_table.count++;
 		}
@@ -3019,6 +3021,25 @@ static int smu7_init_voltage_dependency_on_display_clock_table(struct pp_hwmgr *
 	return 0;
 }
 
+static void smu7_set_sclk_cap(struct pp_hwmgr *hwmgr)
+{
+	struct amdgpu_device *adev = hwmgr->adev;
+	struct smu7_hwmgr *data = (struct smu7_hwmgr *)(hwmgr->backend);
+
+	data->sclk_cap = 0xffffffff;
+
+	if (hwmgr->od_enabled)
+		return;
+
+	/* R9 390X board: last sclk dpm level is unstable, use lower sclk */
+	if (adev->pdev->device == 0x67B0 &&
+	    adev->pdev->subsystem_vendor == 0x1043)
+		data->sclk_cap = 104000; /* 1040 MHz */
+
+	if (data->sclk_cap != 0xffffffff)
+		dev_info(adev->dev, "sclk cap: %u kHz on quirky ASIC\n", data->sclk_cap * 10);
+}
+
 static int smu7_hwmgr_backend_init(struct pp_hwmgr *hwmgr)
 {
 	struct amdgpu_device *adev = hwmgr->adev;
@@ -3030,6 +3051,7 @@ static int smu7_hwmgr_backend_init(struct pp_hwmgr *hwmgr)
 		return -ENOMEM;
 
 	hwmgr->backend = data;
+	smu7_set_sclk_cap(hwmgr);
 	smu7_patch_voltage_workaround(hwmgr);
 	smu7_init_dpm_defaults(hwmgr);
 
@@ -3916,7 +3938,7 @@ static int smu7_get_pp_table_entry_callback_func_v0(struct pp_hwmgr *hwmgr,
 
 	/* Performance levels are arranged from low to high. */
 	performance_level->memory_clock = memory_clock;
-	performance_level->engine_clock = engine_clock;
+	performance_level->engine_clock = min(engine_clock, data->sclk_cap);
 
 	pcie_gen_from_bios = visland_clk_info->ucPCIEGen;
 
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.h b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.h
index d9e8b386bd4d3..66adabeab6a3a 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.h
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.h
@@ -234,6 +234,7 @@ struct smu7_hwmgr {
 	uint32_t                       pcie_gen_cap;
 	uint32_t                       pcie_lane_cap;
 	uint32_t                       pcie_spc_cap;
+	uint32_t                       sclk_cap;
 	struct smu7_leakage_voltage          vddc_leakage;
 	struct smu7_leakage_voltage          vddci_leakage;
 	struct smu7_leakage_voltage          vddcgfx_leakage;
-- 
2.53.0



