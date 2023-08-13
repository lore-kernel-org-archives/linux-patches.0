Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2179446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:39:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52040C433C8;
	Sun, 13 Aug 2023 21:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962767;
	bh=B1nzU/Sl4RFTM47PAyubqm9BNZK+ewsWFi29bGWNovo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ceiiblWOyxcb43NdpERvnS+Ay7aR2GuKKZK6+T60cqbOP5zT+mf6HDLsEyTCwQT1B
	 1P0KPwTBmDUHpysOEb+Ylshvew7OhNVrj4N6UYqWXZhy6urV9OojyrIowRN2mhnFNV
	 CmyorEMoZ5D02DThLqYS3f3ZKOZ3tTzkqoK9rR+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Quan <evan.quan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 149/149] drm/amd/pm/smu7: move variables to where they are used
Date: Sun, 13 Aug 2023 23:19:54 +0200
Message-ID: <20230813211723.144027583@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit 63a9ab264a8c030482ab9e7e20b6c4c162299531 upstream.

Move variable declarations to where they are used.  Fixes
a segfault on smu7 V0 structures where some tables don't
exist.

Cc: Evan Quan <evan.quan@amd.com>
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2388
Fixes: b1a9557a7d00 ("drm/amd/pm: fulfill powerplay peak profiling mode shader/memory clock settings")
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
@@ -1505,12 +1505,6 @@ static void smu7_populate_umdpstate_cloc
 {
 	struct smu7_hwmgr *data = (struct smu7_hwmgr *)(hwmgr->backend);
 	struct smu7_dpm_table *golden_dpm_table = &data->golden_dpm_table;
-	struct phm_clock_voltage_dependency_table *vddc_dependency_on_sclk =
-			hwmgr->dyn_state.vddc_dependency_on_sclk;
-	struct phm_ppt_v1_information *table_info =
-			(struct phm_ppt_v1_information *)(hwmgr->pptable);
-	struct phm_ppt_v1_clock_voltage_dependency_table *vdd_dep_on_sclk =
-			table_info->vdd_dep_on_sclk;
 	int32_t tmp_sclk, count, percentage;
 
 	if (golden_dpm_table->mclk_table.count == 1) {
@@ -1525,6 +1519,9 @@ static void smu7_populate_umdpstate_cloc
 	tmp_sclk = hwmgr->pstate_mclk * percentage / 100;
 
 	if (hwmgr->pp_table_version == PP_TABLE_V0) {
+		struct phm_clock_voltage_dependency_table *vddc_dependency_on_sclk =
+			hwmgr->dyn_state.vddc_dependency_on_sclk;
+
 		for (count = vddc_dependency_on_sclk->count - 1; count >= 0; count--) {
 			if (tmp_sclk >= vddc_dependency_on_sclk->entries[count].clk) {
 				hwmgr->pstate_sclk = vddc_dependency_on_sclk->entries[count].clk;
@@ -1537,6 +1534,11 @@ static void smu7_populate_umdpstate_cloc
 		hwmgr->pstate_sclk_peak =
 			vddc_dependency_on_sclk->entries[vddc_dependency_on_sclk->count - 1].clk;
 	} else if (hwmgr->pp_table_version == PP_TABLE_V1) {
+		struct phm_ppt_v1_information *table_info =
+			(struct phm_ppt_v1_information *)(hwmgr->pptable);
+		struct phm_ppt_v1_clock_voltage_dependency_table *vdd_dep_on_sclk =
+			table_info->vdd_dep_on_sclk;
+
 		for (count = vdd_dep_on_sclk->count - 1; count >= 0; count--) {
 			if (tmp_sclk >= vdd_dep_on_sclk->entries[count].clk) {
 				hwmgr->pstate_sclk = vdd_dep_on_sclk->entries[count].clk;


