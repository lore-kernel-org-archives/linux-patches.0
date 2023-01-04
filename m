Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E26AD38
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D9FC433F0;
	Wed,  4 Jan 2023 16:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672848674;
	bh=RMlV+wJd0i/9lQeG86KmABf7eoEg28Xrh7cV4TvGs+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ki3VB1n/u0fBwUFLA7f9dyV+fqHMVpNho6EBKUadf5FUZly1rL1hgg9nSZH6Jd3YG
	 FB0MjdUP189VDwJgVLimI2VgIavgwiFbPjhglaL/InImgNYJxcG7G2rxCZiHCBffS3
	 oo2iYcMQuSXUlw7pCDwxTmkcP2ZOTjjTK58cDdaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Quan <evan.quan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 019/207] drm/amd/pm: correct SMU13.0.0 pstate profiling clock settings
Date: Wed,  4 Jan 2023 17:04:37 +0100
Message-Id: <20230104160512.529508547@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

commit 32a7819ff8e25375c7515aaae5cfcb8c44a461b7 upstream.

Correct the pstate standard/peak profiling mode clock settings
for SMU13.0.0.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c |   22 ++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -1349,9 +1349,17 @@ static int smu_v13_0_0_populate_umd_stat
 				&dpm_context->dpm_tables.fclk_table;
 	struct smu_umd_pstate_table *pstate_table =
 				&smu->pstate_table;
+	struct smu_table_context *table_context = &smu->smu_table;
+	PPTable_t *pptable = table_context->driver_pptable;
+	DriverReportedClocks_t driver_clocks =
+			pptable->SkuTable.DriverReportedClocks;
 
 	pstate_table->gfxclk_pstate.min = gfx_table->min;
-	pstate_table->gfxclk_pstate.peak = gfx_table->max;
+	if (driver_clocks.GameClockAc &&
+	    (driver_clocks.GameClockAc < gfx_table->max))
+		pstate_table->gfxclk_pstate.peak = driver_clocks.GameClockAc;
+	else
+		pstate_table->gfxclk_pstate.peak = gfx_table->max;
 
 	pstate_table->uclk_pstate.min = mem_table->min;
 	pstate_table->uclk_pstate.peak = mem_table->max;
@@ -1368,12 +1376,12 @@ static int smu_v13_0_0_populate_umd_stat
 	pstate_table->fclk_pstate.min = fclk_table->min;
 	pstate_table->fclk_pstate.peak = fclk_table->max;
 
-	/*
-	 * For now, just use the mininum clock frequency.
-	 * TODO: update them when the real pstate settings available
-	 */
-	pstate_table->gfxclk_pstate.standard = gfx_table->min;
-	pstate_table->uclk_pstate.standard = mem_table->min;
+	if (driver_clocks.BaseClockAc &&
+	    driver_clocks.BaseClockAc < gfx_table->max)
+		pstate_table->gfxclk_pstate.standard = driver_clocks.BaseClockAc;
+	else
+		pstate_table->gfxclk_pstate.standard = gfx_table->max;
+	pstate_table->uclk_pstate.standard = mem_table->max;
 	pstate_table->socclk_pstate.standard = soc_table->min;
 	pstate_table->vclk_pstate.standard = vclk_table->min;
 	pstate_table->dclk_pstate.standard = dclk_table->min;


