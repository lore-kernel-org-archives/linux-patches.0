Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE84523FC41;
	Tue, 26 Aug 2025 13:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214564; cv=none; b=DXp4SL//rpo45On8iKUmEeXEfrKHdfOv5NmB3ucaW7OLlYvTTkEa21WNRYNihi809zk+ykjbwGqdqGGw9TbsYu00CVKEqZ5QtOPtHexL9mcHDy9nxuxPIF9o4VwUUr0ITINg9jUmt/Gd69vinU+aXlpruJzcBYQ7yWOx+I3UpHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214564; c=relaxed/simple;
	bh=x4Dr+7pGJ7c8giGaG//OZQMwtLiMgXT212npDpmicVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGVUktD8uJITiT9JzSsStNn/+jbcV3zbERnB+/ATMExnrXSlCCD8NuOSoNizgPdfLff3PnkSPtynGd1hxWbQ4AGsFnm06SEEYTL9hXy6YAGejzrATev1L68YaGLpaTFBh2zza/tEyU4qI6Y/rfJ+HLEXvkaOeonnshWY7FqpZ4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xvSo10a/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xvSo10a/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EDD6C4CEF1;
	Tue, 26 Aug 2025 13:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214564;
	bh=x4Dr+7pGJ7c8giGaG//OZQMwtLiMgXT212npDpmicVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xvSo10a/iSf+hKAm5X6X7JlF6gq8QFrJqU3YSgu1W/5XklSnZBuJFyeipi3JP1aA9
	 eez9Nh5pqR3rzfTCG6hNCZ++wxon1btT1hfOHZnO8zWL9IN44rpIT3wL2vPIXGi5VL
	 zai5N9YNSm/4V3vJcT+pvT2UmoJ/aLt6lV5n/Dnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>,
	Vicki Pfau <vi@endrift.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 155/482] drm/amd: Allow printing VanGogh OD SCLK levels without setting dpm to manual
Date: Tue, 26 Aug 2025 13:06:48 +0200
Message-ID: <20250826110934.643769619@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 2d1ec1e955414e8e8358178011c35afca1a1c0b1 ]

Several other ASICs allow printing OD SCLK levels without setting DPM
control to manual.  When OD is disabled it will show the range the
hardware supports. When OD is enabled it will show what values have
been programmed. Adjust VanGogh to work the same.

Cc: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
Reported-by: Vicki Pfau <vi@endrift.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://lore.kernel.org/r/20250609031227.479079-1-superm1@kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c  | 37 ++++++++-----------
 1 file changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
index c9c0aa6376e3..e2fa0ee0dc92 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
@@ -681,7 +681,6 @@ static int vangogh_print_clk_levels(struct smu_context *smu,
 {
 	DpmClocks_t *clk_table = smu->smu_table.clocks_table;
 	SmuMetrics_t metrics;
-	struct smu_dpm_context *smu_dpm_ctx = &(smu->smu_dpm);
 	int i, idx, size = 0, ret = 0;
 	uint32_t cur_value = 0, value = 0, count = 0;
 	bool cur_value_match_level = false;
@@ -697,31 +696,25 @@ static int vangogh_print_clk_levels(struct smu_context *smu,
 
 	switch (clk_type) {
 	case SMU_OD_SCLK:
-		if (smu_dpm_ctx->dpm_level == AMD_DPM_FORCED_LEVEL_MANUAL) {
-			size += sysfs_emit_at(buf, size, "%s:\n", "OD_SCLK");
-			size += sysfs_emit_at(buf, size, "0: %10uMhz\n",
-			(smu->gfx_actual_hard_min_freq > 0) ? smu->gfx_actual_hard_min_freq : smu->gfx_default_hard_min_freq);
-			size += sysfs_emit_at(buf, size, "1: %10uMhz\n",
-			(smu->gfx_actual_soft_max_freq > 0) ? smu->gfx_actual_soft_max_freq : smu->gfx_default_soft_max_freq);
-		}
+		size += sysfs_emit_at(buf, size, "%s:\n", "OD_SCLK");
+		size += sysfs_emit_at(buf, size, "0: %10uMhz\n",
+		(smu->gfx_actual_hard_min_freq > 0) ? smu->gfx_actual_hard_min_freq : smu->gfx_default_hard_min_freq);
+		size += sysfs_emit_at(buf, size, "1: %10uMhz\n",
+		(smu->gfx_actual_soft_max_freq > 0) ? smu->gfx_actual_soft_max_freq : smu->gfx_default_soft_max_freq);
 		break;
 	case SMU_OD_CCLK:
-		if (smu_dpm_ctx->dpm_level == AMD_DPM_FORCED_LEVEL_MANUAL) {
-			size += sysfs_emit_at(buf, size, "CCLK_RANGE in Core%d:\n",  smu->cpu_core_id_select);
-			size += sysfs_emit_at(buf, size, "0: %10uMhz\n",
-			(smu->cpu_actual_soft_min_freq > 0) ? smu->cpu_actual_soft_min_freq : smu->cpu_default_soft_min_freq);
-			size += sysfs_emit_at(buf, size, "1: %10uMhz\n",
-			(smu->cpu_actual_soft_max_freq > 0) ? smu->cpu_actual_soft_max_freq : smu->cpu_default_soft_max_freq);
-		}
+		size += sysfs_emit_at(buf, size, "CCLK_RANGE in Core%d:\n",  smu->cpu_core_id_select);
+		size += sysfs_emit_at(buf, size, "0: %10uMhz\n",
+		(smu->cpu_actual_soft_min_freq > 0) ? smu->cpu_actual_soft_min_freq : smu->cpu_default_soft_min_freq);
+		size += sysfs_emit_at(buf, size, "1: %10uMhz\n",
+		(smu->cpu_actual_soft_max_freq > 0) ? smu->cpu_actual_soft_max_freq : smu->cpu_default_soft_max_freq);
 		break;
 	case SMU_OD_RANGE:
-		if (smu_dpm_ctx->dpm_level == AMD_DPM_FORCED_LEVEL_MANUAL) {
-			size += sysfs_emit_at(buf, size, "%s:\n", "OD_RANGE");
-			size += sysfs_emit_at(buf, size, "SCLK: %7uMhz %10uMhz\n",
-				smu->gfx_default_hard_min_freq, smu->gfx_default_soft_max_freq);
-			size += sysfs_emit_at(buf, size, "CCLK: %7uMhz %10uMhz\n",
-				smu->cpu_default_soft_min_freq, smu->cpu_default_soft_max_freq);
-		}
+		size += sysfs_emit_at(buf, size, "%s:\n", "OD_RANGE");
+		size += sysfs_emit_at(buf, size, "SCLK: %7uMhz %10uMhz\n",
+			smu->gfx_default_hard_min_freq, smu->gfx_default_soft_max_freq);
+		size += sysfs_emit_at(buf, size, "CCLK: %7uMhz %10uMhz\n",
+			smu->cpu_default_soft_min_freq, smu->cpu_default_soft_max_freq);
 		break;
 	case SMU_SOCCLK:
 		/* the level 3 ~ 6 of socclk use the same frequency for vangogh */
-- 
2.39.5



