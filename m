Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12D52572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685F6C4339B;
	Tue, 18 Apr 2023 12:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681822053;
	bh=mfsf9TRt3ntpdFjhdDxOz1o86aduJHi9ZX6MoCJRe6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c+5ck37mX6RMWLifO2sp82RXyuI9rZ+7MmnsmVeRDm+EmvOt6hQBjj4mz29h1301p
	 eia3UBWWngMxkSqFjnNH0Jfwj85xPqWIKm9rf0Snzn1iFGMw4Qme/10H5UyJOhh7g0
	 j+oR75IlImFyQeCrnXoxZswWdDghZgV7z9y9Ok4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatio Zhang <Hongkun.Zhang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 114/134] drm/amd/pm: correct SMU13.0.7 pstate profiling clock settings
Date: Tue, 18 Apr 2023 14:22:50 +0200
Message-Id: <20230418120317.172653432@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Horatio Zhang <Hongkun.Zhang@amd.com>

commit f06b8887e3ef4f50098d3a949aef392c529c831a upstream.

Correct the pstate standard/peak profiling mode clock
settings for SMU13.0.7.

Signed-off-by: Horatio Zhang <Hongkun.Zhang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c |   22 ++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -1328,9 +1328,17 @@ static int smu_v13_0_7_populate_umd_stat
 				&dpm_context->dpm_tables.fclk_table;
 	struct smu_umd_pstate_table *pstate_table =
 				&smu->pstate_table;
+	struct smu_table_context *table_context = &smu->smu_table;
+	PPTable_t *pptable = table_context->driver_pptable;
+	DriverReportedClocks_t driver_clocks =
+		pptable->SkuTable.DriverReportedClocks;
 
 	pstate_table->gfxclk_pstate.min = gfx_table->min;
-	pstate_table->gfxclk_pstate.peak = gfx_table->max;
+	if (driver_clocks.GameClockAc &&
+		(driver_clocks.GameClockAc < gfx_table->max))
+		pstate_table->gfxclk_pstate.peak = driver_clocks.GameClockAc;
+	else
+		pstate_table->gfxclk_pstate.peak = gfx_table->max;
 
 	pstate_table->uclk_pstate.min = mem_table->min;
 	pstate_table->uclk_pstate.peak = mem_table->max;
@@ -1347,12 +1355,12 @@ static int smu_v13_0_7_populate_umd_stat
 	pstate_table->fclk_pstate.min = fclk_table->min;
 	pstate_table->fclk_pstate.peak = fclk_table->max;
 
-	/*
-	 * For now, just use the mininum clock frequency.
-	 * TODO: update them when the real pstate settings available
-	 */
-	pstate_table->gfxclk_pstate.standard = gfx_table->min;
-	pstate_table->uclk_pstate.standard = mem_table->min;
+	if (driver_clocks.BaseClockAc &&
+		driver_clocks.BaseClockAc < gfx_table->max)
+		pstate_table->gfxclk_pstate.standard = driver_clocks.BaseClockAc;
+	else
+		pstate_table->gfxclk_pstate.standard = gfx_table->max;
+	pstate_table->uclk_pstate.standard = mem_table->max;
 	pstate_table->socclk_pstate.standard = soc_table->min;
 	pstate_table->vclk_pstate.standard = vclk_table->min;
 	pstate_table->dclk_pstate.standard = dclk_table->min;


