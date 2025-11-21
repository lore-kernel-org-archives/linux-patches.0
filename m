Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D31530101A;
	Fri, 21 Nov 2025 13:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732430; cv=none; b=FJNHigunWSneLHThDKG7YLXEGFERY/Bqhnl+eg1AdfP463aEI2VXM4Ai+gcc+o3w5bvq4q/+DQMNUyyk74nzpiA62+Kwx5vZfKhewMijTppPKhbU3s/U1ROirUPF8wfhmeJXKqISXbHCsZxdwmwGms3ae9w5QJj8kdv8b66e/ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732430; c=relaxed/simple;
	bh=McMCiC/BRpjMp3yw4XbkVfKUP8OK+/cY3i4sylwVBJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uA9c/SWzH/LOFJY2+2mS8YeV+QR0i5Tn/94BntsjZKx3fcxOYlFEYbBJRfLmOoXfmP6eJ4mXFM5t8/8J8BtVxSUfxqh1giPb1m4R7ODobhu48DevLW9m5jkVCkV0RXPy4t1xka2zjMXsHhhdBquZ8/wXlZ5bweWundZ/dxMz2xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BJlrRCe7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJlrRCe7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42D5C4CEF1;
	Fri, 21 Nov 2025 13:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732430;
	bh=McMCiC/BRpjMp3yw4XbkVfKUP8OK+/cY3i4sylwVBJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJlrRCe7BNA/Dl+vhXcnedvkN4EfLBwNfwaEGaClKT6GTMDl0VlKqZSHvG06Mthwc
	 AFJ0stYb6AFGt9KBw/pUj32ky0Gyj8/8VnsIUmNxorrAdqubfPcZo1SAku5UP/Cz+4
	 wdIKm3EATXXOcZOgMqyHTcQt+Ku1GGhyZppDPt0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Paul Hsieh <Paul.Hsieh@amd.com>,
	Roman Li <roman.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 118/529] drm/amd/display: update dpp/disp clock from smu clock table
Date: Fri, 21 Nov 2025 14:06:57 +0100
Message-ID: <20251121130235.222409772@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Paul Hsieh <Paul.Hsieh@amd.com>

[ Upstream commit 2e72fdba8a32ce062a86571edff4592710c26215 ]

[Why]
The reason some high-resolution monitors fail to display properly
is that this platform does not support sufficiently high DPP and
DISP clock frequencies

[How]
Update DISP and DPP clocks from the smu clock table then DML can
filter these mode if not support.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Paul Hsieh <Paul.Hsieh@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../display/dc/clk_mgr/dcn301/vg_clk_mgr.c    | 16 +++++++++++++++
 .../amd/display/dc/dml/dcn301/dcn301_fpu.c    | 20 ++++++++++++++++---
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c
index a5489fe6875f4..086f60e1dd173 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c
@@ -561,6 +561,7 @@ static void vg_clk_mgr_helper_populate_bw_params(
 {
 	int i, j;
 	struct clk_bw_params *bw_params = clk_mgr->base.bw_params;
+	uint32_t max_dispclk = 0, max_dppclk = 0;
 
 	j = -1;
 
@@ -581,6 +582,15 @@ static void vg_clk_mgr_helper_populate_bw_params(
 		return;
 	}
 
+	/* dispclk and dppclk can be max at any voltage, same number of levels for both */
+	if (clock_table->NumDispClkLevelsEnabled <= VG_NUM_DISPCLK_DPM_LEVELS &&
+	    clock_table->NumDispClkLevelsEnabled <= VG_NUM_DPPCLK_DPM_LEVELS) {
+		max_dispclk = find_max_clk_value(clock_table->DispClocks, clock_table->NumDispClkLevelsEnabled);
+		max_dppclk = find_max_clk_value(clock_table->DppClocks, clock_table->NumDispClkLevelsEnabled);
+	} else {
+		ASSERT(0);
+	}
+
 	bw_params->clk_table.num_entries = j + 1;
 
 	for (i = 0; i < bw_params->clk_table.num_entries - 1; i++, j--) {
@@ -588,11 +598,17 @@ static void vg_clk_mgr_helper_populate_bw_params(
 		bw_params->clk_table.entries[i].memclk_mhz = clock_table->DfPstateTable[j].memclk;
 		bw_params->clk_table.entries[i].voltage = clock_table->DfPstateTable[j].voltage;
 		bw_params->clk_table.entries[i].dcfclk_mhz = find_dcfclk_for_voltage(clock_table, clock_table->DfPstateTable[j].voltage);
+
+		/* Now update clocks we do read */
+		bw_params->clk_table.entries[i].dispclk_mhz = max_dispclk;
+		bw_params->clk_table.entries[i].dppclk_mhz = max_dppclk;
 	}
 	bw_params->clk_table.entries[i].fclk_mhz = clock_table->DfPstateTable[j].fclk;
 	bw_params->clk_table.entries[i].memclk_mhz = clock_table->DfPstateTable[j].memclk;
 	bw_params->clk_table.entries[i].voltage = clock_table->DfPstateTable[j].voltage;
 	bw_params->clk_table.entries[i].dcfclk_mhz = find_max_clk_value(clock_table->DcfClocks, VG_NUM_DCFCLK_DPM_LEVELS);
+	bw_params->clk_table.entries[i].dispclk_mhz = find_max_clk_value(clock_table->DispClocks, VG_NUM_DISPCLK_DPM_LEVELS);
+	bw_params->clk_table.entries[i].dppclk_mhz = find_max_clk_value(clock_table->DppClocks, VG_NUM_DPPCLK_DPM_LEVELS);
 
 	bw_params->vram_type = bios_info->memory_type;
 	bw_params->num_channels = bios_info->ma_channel_number;
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.c
index 6ce90678b33c0..dc7435d5ef4df 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.c
@@ -326,7 +326,7 @@ void dcn301_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_param
 	struct dcn301_resource_pool *pool = TO_DCN301_RES_POOL(dc->res_pool);
 	struct clk_limit_table *clk_table = &bw_params->clk_table;
 	unsigned int i, closest_clk_lvl;
-	int j;
+	int j = 0, max_dispclk_mhz = 0, max_dppclk_mhz = 0;
 
 	dc_assert_fp_enabled();
 
@@ -338,6 +338,15 @@ void dcn301_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_param
 	dcn3_01_soc.num_chans = bw_params->num_channels;
 
 	ASSERT(clk_table->num_entries);
+
+	/* Prepass to find max clocks independent of voltage level. */
+	for (i = 0; i < clk_table->num_entries; ++i) {
+		if (clk_table->entries[i].dispclk_mhz > max_dispclk_mhz)
+			max_dispclk_mhz = clk_table->entries[i].dispclk_mhz;
+		if (clk_table->entries[i].dppclk_mhz > max_dppclk_mhz)
+			max_dppclk_mhz = clk_table->entries[i].dppclk_mhz;
+	}
+
 	for (i = 0; i < clk_table->num_entries; i++) {
 		/* loop backwards*/
 		for (closest_clk_lvl = 0, j = dcn3_01_soc.num_states - 1; j >= 0; j--) {
@@ -353,8 +362,13 @@ void dcn301_update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_param
 		s[i].socclk_mhz = clk_table->entries[i].socclk_mhz;
 		s[i].dram_speed_mts = clk_table->entries[i].memclk_mhz * 2;
 
-		s[i].dispclk_mhz = dcn3_01_soc.clock_limits[closest_clk_lvl].dispclk_mhz;
-		s[i].dppclk_mhz = dcn3_01_soc.clock_limits[closest_clk_lvl].dppclk_mhz;
+		/* Clocks independent of voltage level. */
+		s[i].dispclk_mhz = max_dispclk_mhz ? max_dispclk_mhz :
+			dcn3_01_soc.clock_limits[closest_clk_lvl].dispclk_mhz;
+
+		s[i].dppclk_mhz = max_dppclk_mhz ? max_dppclk_mhz :
+			dcn3_01_soc.clock_limits[closest_clk_lvl].dppclk_mhz;
+
 		s[i].dram_bw_per_chan_gbps =
 			dcn3_01_soc.clock_limits[closest_clk_lvl].dram_bw_per_chan_gbps;
 		s[i].dscclk_mhz = dcn3_01_soc.clock_limits[closest_clk_lvl].dscclk_mhz;
-- 
2.51.0



