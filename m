Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADA4159591;
	Mon, 29 Jan 2024 17:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548257; cv=none; b=Vh2/psfPh3soqpe5NaRKM2fQfkjQMF8K71QjYZKHP9xZtxvV+iCPPRSLJVthEE89VdMJqh+5F/bOkkFEoqSPRXPIe8vlDWFf44nh5JlwXk9xJSeRDdExiC/aA9fjGjRQ3OCgF2X1TQdWj8yYumVz5bpaLq353VhFi100zdSLLs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548257; c=relaxed/simple;
	bh=qeu8Y1q6v0A6w2pRhYd2Nk6mgJLFKWcGB/36CeobX84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K9jGKiNIaW3/USe9G0ZTiznuOM3vxAcWUTJJmj8M0zZas83cyckAtSIIJ8pZa2gaqt1PO2oN5CRrYrjn7i2auhD/sLUoMqxXNFw93ZkPbmd68LpNwvor2sLFmzxjjXAG4zluM0RWMRFtaa+BH6ScUhJ3K1l4itnp4d+QD4gK3as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ssNp7SDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ssNp7SDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047E1C43390;
	Mon, 29 Jan 2024 17:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548257;
	bh=qeu8Y1q6v0A6w2pRhYd2Nk6mgJLFKWcGB/36CeobX84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ssNp7SDgngpum7gDAohSJXZbXyvfmks2Oo2rV8qttMUdIbFF9ot8Yd5gcNAcgo4wX
	 nUx/GDuSvXciatJGABNYo6iEhLkSLyOhSyDUa/FfhMCbmWEMAyTYMa9G46hQZ7d+uX
	 j5Lq+X84mrNZ5im59/cwmC0CCFT3K1YNhPD4Ko5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 277/346] drm/amd/pm: update the power cap setting
Date: Mon, 29 Jan 2024 09:05:08 -0800
Message-ID: <20240129170024.528836048@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

From: Kenneth Feng <kenneth.feng@amd.com>

commit 30269954745c6cac730352829ac9850918457440 upstream.

update the power cap setting for smu_v13.0.0/smu_v13.0.7

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2356
Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c |   54 ++++++++++++++++++-
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c |   54 ++++++++++++++++++-
 2 files changed, 104 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -2352,6 +2352,7 @@ static int smu_v13_0_0_get_power_limit(s
 	PPTable_t *pptable = table_context->driver_pptable;
 	SkuTable_t *skutable = &pptable->SkuTable;
 	uint32_t power_limit, od_percent_upper, od_percent_lower;
+	uint32_t msg_limit = skutable->MsgLimits.Power[PPT_THROTTLER_PPT0][POWER_SOURCE_AC];
 
 	if (smu_v13_0_get_current_power_limit(smu, &power_limit))
 		power_limit = smu->adev->pm.ac_power ?
@@ -2375,7 +2376,7 @@ static int smu_v13_0_0_get_power_limit(s
 					od_percent_upper, od_percent_lower, power_limit);
 
 	if (max_power_limit) {
-		*max_power_limit = power_limit * (100 + od_percent_upper);
+		*max_power_limit = msg_limit * (100 + od_percent_upper);
 		*max_power_limit /= 100;
 	}
 
@@ -2970,6 +2971,55 @@ static ssize_t smu_v13_0_0_get_ecc_info(
 	return ret;
 }
 
+static int smu_v13_0_0_set_power_limit(struct smu_context *smu,
+				       enum smu_ppt_limit_type limit_type,
+				       uint32_t limit)
+{
+	PPTable_t *pptable = smu->smu_table.driver_pptable;
+	SkuTable_t *skutable = &pptable->SkuTable;
+	uint32_t msg_limit = skutable->MsgLimits.Power[PPT_THROTTLER_PPT0][POWER_SOURCE_AC];
+	struct smu_table_context *table_context = &smu->smu_table;
+	OverDriveTableExternal_t *od_table =
+		(OverDriveTableExternal_t *)table_context->overdrive_table;
+	int ret = 0;
+
+	if (limit_type != SMU_DEFAULT_PPT_LIMIT)
+		return -EINVAL;
+
+	if (limit <= msg_limit) {
+		if (smu->current_power_limit > msg_limit) {
+			od_table->OverDriveTable.Ppt = 0;
+			od_table->OverDriveTable.FeatureCtrlMask |= 1U << PP_OD_FEATURE_PPT_BIT;
+
+			ret = smu_v13_0_0_upload_overdrive_table(smu, od_table);
+			if (ret) {
+				dev_err(smu->adev->dev, "Failed to upload overdrive table!\n");
+				return ret;
+			}
+		}
+		return smu_v13_0_set_power_limit(smu, limit_type, limit);
+	} else if (smu->od_enabled) {
+		ret = smu_v13_0_set_power_limit(smu, limit_type, msg_limit);
+		if (ret)
+			return ret;
+
+		od_table->OverDriveTable.Ppt = (limit * 100) / msg_limit - 100;
+		od_table->OverDriveTable.FeatureCtrlMask |= 1U << PP_OD_FEATURE_PPT_BIT;
+
+		ret = smu_v13_0_0_upload_overdrive_table(smu, od_table);
+		if (ret) {
+		  dev_err(smu->adev->dev, "Failed to upload overdrive table!\n");
+		  return ret;
+		}
+
+		smu->current_power_limit = limit;
+	} else {
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static const struct pptable_funcs smu_v13_0_0_ppt_funcs = {
 	.get_allowed_feature_mask = smu_v13_0_0_get_allowed_feature_mask,
 	.set_default_dpm_table = smu_v13_0_0_set_default_dpm_table,
@@ -3024,7 +3074,7 @@ static const struct pptable_funcs smu_v1
 	.set_fan_control_mode = smu_v13_0_set_fan_control_mode,
 	.enable_mgpu_fan_boost = smu_v13_0_0_enable_mgpu_fan_boost,
 	.get_power_limit = smu_v13_0_0_get_power_limit,
-	.set_power_limit = smu_v13_0_set_power_limit,
+	.set_power_limit = smu_v13_0_0_set_power_limit,
 	.set_power_source = smu_v13_0_set_power_source,
 	.get_power_profile_mode = smu_v13_0_0_get_power_profile_mode,
 	.set_power_profile_mode = smu_v13_0_0_set_power_profile_mode,
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -2316,6 +2316,7 @@ static int smu_v13_0_7_get_power_limit(s
 	PPTable_t *pptable = table_context->driver_pptable;
 	SkuTable_t *skutable = &pptable->SkuTable;
 	uint32_t power_limit, od_percent_upper, od_percent_lower;
+	uint32_t msg_limit = skutable->MsgLimits.Power[PPT_THROTTLER_PPT0][POWER_SOURCE_AC];
 
 	if (smu_v13_0_get_current_power_limit(smu, &power_limit))
 		power_limit = smu->adev->pm.ac_power ?
@@ -2339,7 +2340,7 @@ static int smu_v13_0_7_get_power_limit(s
 					od_percent_upper, od_percent_lower, power_limit);
 
 	if (max_power_limit) {
-		*max_power_limit = power_limit * (100 + od_percent_upper);
+		*max_power_limit = msg_limit * (100 + od_percent_upper);
 		*max_power_limit /= 100;
 	}
 
@@ -2567,6 +2568,55 @@ static int smu_v13_0_7_set_df_cstate(str
 					       NULL);
 }
 
+static int smu_v13_0_7_set_power_limit(struct smu_context *smu,
+				       enum smu_ppt_limit_type limit_type,
+				       uint32_t limit)
+{
+	PPTable_t *pptable = smu->smu_table.driver_pptable;
+	SkuTable_t *skutable = &pptable->SkuTable;
+	uint32_t msg_limit = skutable->MsgLimits.Power[PPT_THROTTLER_PPT0][POWER_SOURCE_AC];
+	struct smu_table_context *table_context = &smu->smu_table;
+	OverDriveTableExternal_t *od_table =
+		(OverDriveTableExternal_t *)table_context->overdrive_table;
+	int ret = 0;
+
+	if (limit_type != SMU_DEFAULT_PPT_LIMIT)
+		return -EINVAL;
+
+	if (limit <= msg_limit) {
+		if (smu->current_power_limit > msg_limit) {
+			od_table->OverDriveTable.Ppt = 0;
+			od_table->OverDriveTable.FeatureCtrlMask |= 1U << PP_OD_FEATURE_PPT_BIT;
+
+			ret = smu_v13_0_7_upload_overdrive_table(smu, od_table);
+			if (ret) {
+				dev_err(smu->adev->dev, "Failed to upload overdrive table!\n");
+				return ret;
+			}
+		}
+		return smu_v13_0_set_power_limit(smu, limit_type, limit);
+	} else if (smu->od_enabled) {
+		ret = smu_v13_0_set_power_limit(smu, limit_type, msg_limit);
+		if (ret)
+			return ret;
+
+		od_table->OverDriveTable.Ppt = (limit * 100) / msg_limit - 100;
+		od_table->OverDriveTable.FeatureCtrlMask |= 1U << PP_OD_FEATURE_PPT_BIT;
+
+		ret = smu_v13_0_7_upload_overdrive_table(smu, od_table);
+		if (ret) {
+		  dev_err(smu->adev->dev, "Failed to upload overdrive table!\n");
+		  return ret;
+		}
+
+		smu->current_power_limit = limit;
+	} else {
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static const struct pptable_funcs smu_v13_0_7_ppt_funcs = {
 	.get_allowed_feature_mask = smu_v13_0_7_get_allowed_feature_mask,
 	.set_default_dpm_table = smu_v13_0_7_set_default_dpm_table,
@@ -2618,7 +2668,7 @@ static const struct pptable_funcs smu_v1
 	.set_fan_control_mode = smu_v13_0_set_fan_control_mode,
 	.enable_mgpu_fan_boost = smu_v13_0_7_enable_mgpu_fan_boost,
 	.get_power_limit = smu_v13_0_7_get_power_limit,
-	.set_power_limit = smu_v13_0_set_power_limit,
+	.set_power_limit = smu_v13_0_7_set_power_limit,
 	.set_power_source = smu_v13_0_set_power_source,
 	.get_power_profile_mode = smu_v13_0_7_get_power_profile_mode,
 	.set_power_profile_mode = smu_v13_0_7_set_power_profile_mode,


