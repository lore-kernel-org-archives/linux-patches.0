Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFF5339858;
	Tue, 16 Jun 2026 16:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626258; cv=none; b=ar6qSoWaqxDHyGUgT6kuf7yEswpNHeCIirc1yuJrR/zRn1jdF0IuYrbWRTQo746Z3CyUYdPB+EhifBMstgi7YNWI895Nn4NttMdZBPQy3QNs/l8rHJpACt5ZMHvTZSVdLRebDbDvOQ99oigv+6rQ08WDNxI9/Geuz4XC+4CtOG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626258; c=relaxed/simple;
	bh=JMv1W7ajB/lOFK8YE0soSlYySb4VIJyG7JmqEMkbt64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVPbupZuGtppGeogknceSLQJmOOD6bzApHJk2Kn7Zndf8KZD4HNEXy2tU2JiMnf46+S/cH7KXOZKGzXp+y6uzOGGhai3z2v21mN9AGAExHh4xoHOUh5ubtu+hkGbaek6FoLo5ylrb9HNV7salMJptLvX1ysYNYPih6LXNrI0CXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X8EBtB5Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X8EBtB5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081F41F000E9;
	Tue, 16 Jun 2026 16:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626257;
	bh=4fXgPexXcRs6W/u1qfg7AzkmSnLUQdMwvhdyqJzxG14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X8EBtB5YlbEg5/2MGzaisM6vV2zFkQ3V5eKnyDxDWHr5AEPjuij3ew3xN4hfRsK0I
	 kl4MxpNKI+hqeaGybrFqeAsCHE3G0bybH3nzjj6FCpPgJrPY8/hhHeWpozdZs6m7HY
	 r04ZpFv+kf0jAy0xj5ymmEK2TcqzlZ+BRQWyDJdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 294/325] drm/amd/pm: fix smu13 power limit default/cap calculation
Date: Tue, 16 Jun 2026 20:31:30 +0530
Message-ID: <20260616145113.472662154@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2468,28 +2468,30 @@ static int smu_v13_0_0_enable_mgpu_fan_b
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
@@ -2503,15 +2505,15 @@ static int smu_v13_0_0_get_power_limit(s
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
@@ -2429,28 +2429,32 @@ static int smu_v13_0_7_enable_mgpu_fan_b
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
@@ -2464,15 +2468,15 @@ static int smu_v13_0_7_get_power_limit(s
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
 


