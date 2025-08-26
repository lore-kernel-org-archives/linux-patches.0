Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6682422128B;
	Tue, 26 Aug 2025 13:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216326; cv=none; b=I00fM460ShOnTAROhqXufvwGPevN9/NKEB/yHvkiS9zhwZ0ZNVixjK0CZsOEL2KHWVOiYvJeWByEpUrBXVnt43hKtwFLQg9CPcth3RabALkoOvhhQDgyRfDp7lTzqztXQBAoBzRCfoFJ5QeZ/rGN3Mqve55X3/YvKeJPZPsYYc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216326; c=relaxed/simple;
	bh=/2g4K6vprvLRNQuX6PWerLnPxYzmZCydbsMSKkFl+3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZRABpRAvPSW1EIePAPssriFKpR2QksOPvlzyRA1THO30JgSW5pv9ukTvDH0rCrSabIQoMityfqqA4s/FkYVP7EeNi/6i2Jdcw6SpwOkmVF/HxWn8nvlL6i+FiFzkm5xWxGSfm7HKGbUGQo2YSu3jL461/xNhuIKMnFKGGU4zLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X7yuaYT9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X7yuaYT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED831C4CEF1;
	Tue, 26 Aug 2025 13:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216326;
	bh=/2g4K6vprvLRNQuX6PWerLnPxYzmZCydbsMSKkFl+3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X7yuaYT9hMP7MItLr5NOnOlX661Cs2+xAMdOtihVasAm72SjU2sHzIx8FfAnnH5E6
	 a95vo1MYes6Xd6YHjv9F9p/xJWbCvck/l54vdltPLTlAGE5NNvRv8+ftZ6rQEcJ2yB
	 7TyjnDUM/7GCgbPb+SKjjLEYbU4L7FH7rUTIWyxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>,
	Vicki Pfau <vi@endrift.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 369/644] drm/amd: Allow printing VanGogh OD SCLK levels without setting dpm to manual
Date: Tue, 26 Aug 2025 13:07:40 +0200
Message-ID: <20250826110955.559932101@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5a9b47133db1..d64a0a0d5b19 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
@@ -680,7 +680,6 @@ static int vangogh_print_clk_levels(struct smu_context *smu,
 {
 	DpmClocks_t *clk_table = smu->smu_table.clocks_table;
 	SmuMetrics_t metrics;
-	struct smu_dpm_context *smu_dpm_ctx = &(smu->smu_dpm);
 	int i, idx, size = 0, ret = 0;
 	uint32_t cur_value = 0, value = 0, count = 0;
 	bool cur_value_match_level = false;
@@ -695,31 +694,25 @@ static int vangogh_print_clk_levels(struct smu_context *smu,
 
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



