Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9606614F9C8;
	Tue, 20 Feb 2024 21:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465025; cv=none; b=g7o5FwheAwC2tS2Z2cS2vhmODD5WhKuPQ60jmRjXyySWivpGKywUr+nVmRx7Xxin7nqVHQOzzivqyMwh/40FQaZ4NwpgHziyfM2hxHHhkCig0rA1kcT5Y+u7DeUKOb/OLH2tsGLxVR3mPwdaovKTQjK4wuEc1Szcpj6y+PnJqjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465025; c=relaxed/simple;
	bh=TAzzRICaSCZvezukh9yD13X2sSWaxLbh85SiDMF2iCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zw0JuVtcsfP5Iwlz9N6usJFkeV18RFyHoVJSzWyuXu+qDHp4vUDe+QD6NDxkBFXLJmGc09E7sbj5VWa5bhJnX8esLYSjhZ6tHHwOkqnVUMrIBTEBI3uRARg1IHnTcgB5cEo2ihO8omZwDavkno4DMNH0i/j/w+sudsdsBRc8+5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tlSE9y8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tlSE9y8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D340C433F1;
	Tue, 20 Feb 2024 21:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465025;
	bh=TAzzRICaSCZvezukh9yD13X2sSWaxLbh85SiDMF2iCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tlSE9y8Mr1FICvw2vBO+4hSSwlUGub0RKWBVBg62TW6t19wG69sFuXko1hGcqz+az
	 Azk2OL69Ko/C0F15wJBTTjjRatt4A+ssrdr/DxPcVB5IFkNggyewO29t88jeZtfT5Y
	 SU+bFskV3D9MVoS/bE87Z3Q7tMg1OWRTKGvqo/fI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Roman Li <roman.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.7 212/309] drm/amd/display: Fix array-index-out-of-bounds in dcn35_clkmgr
Date: Tue, 20 Feb 2024 21:56:11 +0100
Message-ID: <20240220205639.808401527@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Li <roman.li@amd.com>

commit 46806e59a87790760870d216f54951a5b4d545bc upstream.

[Why]
There is a potential memory access violation while
iterating through array of dcn35 clks.

[How]
Limit iteration per array size.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c |   17 +++++++----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
@@ -654,10 +654,13 @@ static void dcn35_clk_mgr_helper_populat
 	struct clk_limit_table_entry def_max = bw_params->clk_table.entries[bw_params->clk_table.num_entries - 1];
 	uint32_t max_fclk = 0, min_pstate = 0, max_dispclk = 0, max_dppclk = 0;
 	uint32_t max_pstate = 0, max_dram_speed_mts = 0, min_dram_speed_mts = 0;
+	uint32_t num_memps, num_fclk, num_dcfclk;
 	int i;
 
 	/* Determine min/max p-state values. */
-	for (i = 0; i < clock_table->NumMemPstatesEnabled; i++) {
+	num_memps = (clock_table->NumMemPstatesEnabled > NUM_MEM_PSTATE_LEVELS) ? NUM_MEM_PSTATE_LEVELS :
+		clock_table->NumMemPstatesEnabled;
+	for (i = 0; i < num_memps; i++) {
 		uint32_t dram_speed_mts = calc_dram_speed_mts(&clock_table->MemPstateTable[i]);
 
 		if (is_valid_clock_value(dram_speed_mts) && dram_speed_mts > max_dram_speed_mts) {
@@ -669,7 +672,7 @@ static void dcn35_clk_mgr_helper_populat
 	min_dram_speed_mts = max_dram_speed_mts;
 	min_pstate = max_pstate;
 
-	for (i = 0; i < clock_table->NumMemPstatesEnabled; i++) {
+	for (i = 0; i < num_memps; i++) {
 		uint32_t dram_speed_mts = calc_dram_speed_mts(&clock_table->MemPstateTable[i]);
 
 		if (is_valid_clock_value(dram_speed_mts) && dram_speed_mts < min_dram_speed_mts) {
@@ -698,9 +701,13 @@ static void dcn35_clk_mgr_helper_populat
 	/* Base the clock table on dcfclk, need at least one entry regardless of pmfw table */
 	ASSERT(clock_table->NumDcfClkLevelsEnabled > 0);
 
-	max_fclk = find_max_clk_value(clock_table->FclkClocks_Freq, clock_table->NumFclkLevelsEnabled);
-
-	for (i = 0; i < clock_table->NumDcfClkLevelsEnabled; i++) {
+	num_fclk = (clock_table->NumFclkLevelsEnabled > NUM_FCLK_DPM_LEVELS) ? NUM_FCLK_DPM_LEVELS :
+		clock_table->NumFclkLevelsEnabled;
+	max_fclk = find_max_clk_value(clock_table->FclkClocks_Freq, num_fclk);
+
+	num_dcfclk = (clock_table->NumFclkLevelsEnabled > NUM_DCFCLK_DPM_LEVELS) ? NUM_DCFCLK_DPM_LEVELS :
+		clock_table->NumDcfClkLevelsEnabled;
+	for (i = 0; i < num_dcfclk; i++) {
 		int j;
 
 		/* First search defaults for the clocks we don't read using closest lower or equal default dcfclk */


