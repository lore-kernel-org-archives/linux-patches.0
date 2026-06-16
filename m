Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859044779BB;
	Tue, 16 Jun 2026 16:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627746; cv=none; b=glmxqLSMZLNyQTUb4XWGpLrmie5zxClUcf4EEIT0V7xUHpShmeHa8E3BGGQjiDIGrz2cshQnjM9VNAKXyGtrEzJJNb2JQx4NtOqsnAOMyxpt67nyRqczJyC4eNHKuEdytzxAsEwosBfhEIRVQFrkUSTsaAtyKEndQA4QL4oPar0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627746; c=relaxed/simple;
	bh=q8bmkkW5qTWP1Of8p4ZBqT//Rqb87xrHjCmAKBenMuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4rxYFNNmOs8kkDI6uJ/6aPiFBqwe+/mTLrV5E4l6d4LbLZuUxCT5qpI7RtzIggcW6rVetjueQuxyBFdswyMisjiewL2lTyWk7wFw72DP7KhQgmfAEUedGWUFNTl/a1YkLQAPrpgLoACO0bN3Ei8T3Kj/5eOO5S7906klr2LVQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CQwqHRvU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CQwqHRvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F411F000E9;
	Tue, 16 Jun 2026 16:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627745;
	bh=cbP2Nlxb9ViV+zsickKph2fPhYW8utio8l9SyunPS0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CQwqHRvUTkT6rcOMF9JoCuntBTFVBOTb/8xSbBhDSjUUbVoNYHb8W/HnnIUr/taGi
	 9KX3HpjrGekNC7YBZ3aMQ6lm0U5Lssq4QFcOs80PTP6THiX1upBaBZKTXqYc8Ob8zd
	 +5isz4Kok/+lNGul/ZQVNXZJqk3jI+K3DHXMDKb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 220/261] drm/amd/pm: fix smu13 power limit default/cap calculation
Date: Tue, 16 Jun 2026 20:30:58 +0530
Message-ID: <20260616145055.219477044@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

commit bb204f19e4a115f094a6a3c4d82fcf48862d0766 upstream.

smu_v13_0_0_get_power_limit() and smu_v13_0_7_get_power_limit() mix
runtime power_limit with PP table limits when reporting default/min/max.

When current power limit query succeeds, default_power_limit was set to the
runtime value instead of the PP table default, and min/max could be derived
from inconsistent bases (MsgLimits/runtime), leading to incorrect cap info.

Use SocketPowerLimitAc/Dc as the PP default base (pp_limit), keep
current_power_limit as runtime value, and derive min/max from pp_limit with
OD percentages.

Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5227
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1eaf26db95901ca70737503a89b831dd763c8453)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c |   32 ++++++++++---------
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c |   32 ++++++++++---------
 2 files changed, 35 insertions(+), 29 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -2383,28 +2383,30 @@ static int smu_v13_0_0_enable_mgpu_fan_b
 }
 
 static int smu_v13_0_0_get_power_limit(struct smu_context *smu,
-						uint32_t *current_power_limit,
-						uint32_t *default_power_limit,
-						uint32_t *max_power_limit,
-						uint32_t *min_power_limit)
+				       uint32_t *current_power_limit,
+				       uint32_t *default_power_limit,
+				       uint32_t *max_power_limit,
+				       uint32_t *min_power_limit)
 {
 	struct smu_table_context *table_context = &smu->smu_table;
 	struct smu_13_0_0_powerplay_table *powerplay_table =
 		(struct smu_13_0_0_powerplay_table *)table_context->power_play_table;
 	PPTable_t *pptable = table_context->driver_pptable;
 	SkuTable_t *skutable = &pptable->SkuTable;
-	uint32_t power_limit, od_percent_upper = 0, od_percent_lower = 0;
-	uint32_t msg_limit = skutable->MsgLimits.Power[PPT_THROTTLER_PPT0][POWER_SOURCE_AC];
-
-	if (smu_v13_0_get_current_power_limit(smu, &power_limit))
-		power_limit = smu->adev->pm.ac_power ?
+	uint32_t pp_limit = smu->adev->pm.ac_power ?
 			      skutable->SocketPowerLimitAc[PPT_THROTTLER_PPT0] :
 			      skutable->SocketPowerLimitDc[PPT_THROTTLER_PPT0];
+	uint32_t power_limit = 0, od_percent_upper = 0, od_percent_lower = 0;
+	int ret;
+
+	if (current_power_limit) {
+		ret = smu_v13_0_get_current_power_limit(smu, &power_limit);
+		if (ret)
+			*current_power_limit = pp_limit;
+	}
 
-	if (current_power_limit)
-		*current_power_limit = power_limit;
 	if (default_power_limit)
-		*default_power_limit = power_limit;
+		*default_power_limit = pp_limit;
 
 	if (powerplay_table) {
 		if (smu->od_enabled &&
@@ -2418,15 +2420,15 @@ static int smu_v13_0_0_get_power_limit(s
 	}
 
 	dev_dbg(smu->adev->dev, "od percent upper:%d, od percent lower:%d (default power: %d)\n",
-					od_percent_upper, od_percent_lower, power_limit);
+		od_percent_upper, od_percent_lower, pp_limit);
 
 	if (max_power_limit) {
-		*max_power_limit = msg_limit * (100 + od_percent_upper);
+		*max_power_limit = pp_limit * (100 + od_percent_upper);
 		*max_power_limit /= 100;
 	}
 
 	if (min_power_limit) {
-		*min_power_limit = power_limit * (100 - od_percent_lower);
+		*min_power_limit = pp_limit * (100 - od_percent_lower);
 		*min_power_limit /= 100;
 	}
 
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -2344,28 +2344,32 @@ static int smu_v13_0_7_enable_mgpu_fan_b
 }
 
 static int smu_v13_0_7_get_power_limit(struct smu_context *smu,
-						uint32_t *current_power_limit,
-						uint32_t *default_power_limit,
-						uint32_t *max_power_limit,
-						uint32_t *min_power_limit)
+				       uint32_t *current_power_limit,
+				       uint32_t *default_power_limit,
+				       uint32_t *max_power_limit,
+				       uint32_t *min_power_limit)
 {
 	struct smu_table_context *table_context = &smu->smu_table;
 	struct smu_13_0_7_powerplay_table *powerplay_table =
 		(struct smu_13_0_7_powerplay_table *)table_context->power_play_table;
 	PPTable_t *pptable = table_context->driver_pptable;
 	SkuTable_t *skutable = &pptable->SkuTable;
-	uint32_t power_limit, od_percent_upper = 0, od_percent_lower = 0;
-	uint32_t msg_limit = skutable->MsgLimits.Power[PPT_THROTTLER_PPT0][POWER_SOURCE_AC];
-
-	if (smu_v13_0_get_current_power_limit(smu, &power_limit))
-		power_limit = smu->adev->pm.ac_power ?
+	uint32_t pp_limit = smu->adev->pm.ac_power ?
 			      skutable->SocketPowerLimitAc[PPT_THROTTLER_PPT0] :
 			      skutable->SocketPowerLimitDc[PPT_THROTTLER_PPT0];
+	uint32_t power_limit = 0, od_percent_upper = 0, od_percent_lower = 0;
+	int ret;
+
+	if (current_power_limit) {
+		ret = smu_v13_0_get_current_power_limit(smu, &power_limit);
+		if (ret)
+			power_limit = pp_limit;
 
-	if (current_power_limit)
 		*current_power_limit = power_limit;
+	}
+
 	if (default_power_limit)
-		*default_power_limit = power_limit;
+		*default_power_limit = pp_limit;
 
 	if (powerplay_table) {
 		if (smu->od_enabled &&
@@ -2379,15 +2383,15 @@ static int smu_v13_0_7_get_power_limit(s
 	}
 
 	dev_dbg(smu->adev->dev, "od percent upper:%d, od percent lower:%d (default power: %d)\n",
-					od_percent_upper, od_percent_lower, power_limit);
+		od_percent_upper, od_percent_lower, pp_limit);
 
 	if (max_power_limit) {
-		*max_power_limit = msg_limit * (100 + od_percent_upper);
+		*max_power_limit = pp_limit * (100 + od_percent_upper);
 		*max_power_limit /= 100;
 	}
 
 	if (min_power_limit) {
-		*min_power_limit = power_limit * (100 - od_percent_lower);
+		*min_power_limit = pp_limit * (100 - od_percent_lower);
 		*min_power_limit /= 100;
 	}
 


