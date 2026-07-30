Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F3E442FD3;
	Thu, 30 Jul 2026 15:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424374; cv=none; b=CwfsJ0UY6JVUB6aA/e0MduldiH5K9HX1B2gjhmZMphAjEiMj73xPZxklXaj9xUeRK2mMi2tQjDHqVd3XhgVvcDHfQ5LVAYDbYdBL/4o36OKJEdD7iNM5e/lOVixfwOje4rS24B7mxNs+frAcRIacCXVxHr4wEMRv7EXoWR9Fhd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424374; c=relaxed/simple;
	bh=rB3YOiMVXVtwBQ9m8hSDbBNGLgf/8aqkjryfR8uT474=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJkGKR7rixL5hE212jCQYzndssjW35TL8w6fJtE2a0ptKerFoDveQT0UxUr10xgabSflfQcc5sC1JXeW0twm6/defeFK8bEdtnAFTh95Owm9CH7+bKUx6JJijkqABrRCvlxHnGhrkMmaichHM8PP1Iln0TAE/M9GGqJR+3JQ7jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QKTd1I9x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKTd1I9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EC41F000E9;
	Thu, 30 Jul 2026 15:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424373;
	bh=cpm0/pDZerpbq7BN0JR2r0TY1W6o4rMsss0G/bq0M6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QKTd1I9xqOML53yTpRATtrLtY8NqbcTreRBWLpI4/NK8Aus6ezxx3MtEoiOJbEZss
	 3sj49kH7SNxK2y2lYl0wwTGy6CAOqNbrQY3PPZV7Qfu60w6JTFHfI7FN1zf5J7F/26
	 FagOXiTbJ0tspxWL9u4T0P3Tie8TC1jR4t6lAGeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 372/675] drm/amd/pm: fix smu14 power limit range calculation
Date: Thu, 30 Jul 2026 16:11:42 +0200
Message-ID: <20260730141453.041018983@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

commit e987eabc02646920cd13ab75902693e99735eca0 upstream.

SMU14 derives the default PPT limit from SocketPowerLimitAc/Dc, but
MsgLimits.Power may expose a different firmware limit for the same PPT0
throttler. Using those values independently as fixed min/max bases can
report an incorrect configurable power range.

Keep the socket power limit as the default value and as the fallback for
current-limit queries. Calculate the reported range from both firmware
values instead, using the lower value as the minimum base and the higher
value as the maximum base before applying OD percentages.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c936b8126b444401318fcbeb1828488cc5312dee)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c |   28 ++++++++++---------
 1 file changed, 16 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
@@ -1701,19 +1701,23 @@ static int smu_v14_0_2_get_power_limit(s
 		table_context->power_play_table;
 	PPTable_t *pptable = table_context->driver_pptable;
 	CustomSkuTable_t *skutable = &pptable->CustomSkuTable;
-	int16_t od_percent_upper = 0, od_percent_lower = 0;
+	uint32_t pp_limit = smu->adev->pm.ac_power ?
+		skutable->SocketPowerLimitAc[PPT_THROTTLER_PPT0] :
+		skutable->SocketPowerLimitDc[PPT_THROTTLER_PPT0];
 	uint32_t msg_limit = pptable->SkuTable.MsgLimits.Power[PPT_THROTTLER_PPT0][POWER_SOURCE_AC];
-	uint32_t power_limit;
+	uint32_t min_limit = min_t(uint32_t, pp_limit, msg_limit);
+	uint32_t max_limit = max_t(uint32_t, pp_limit, msg_limit);
+	int16_t od_percent_upper = 0, od_percent_lower = 0;
+	int ret;
 
-	if (smu_v14_0_get_current_power_limit(smu, &power_limit))
-		power_limit = smu->adev->pm.ac_power ?
-			      skutable->SocketPowerLimitAc[PPT_THROTTLER_PPT0] :
-			      skutable->SocketPowerLimitDc[PPT_THROTTLER_PPT0];
+	if (current_power_limit) {
+		ret = smu_v14_0_get_current_power_limit(smu, current_power_limit);
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
@@ -1727,15 +1731,15 @@ static int smu_v14_0_2_get_power_limit(s
 	}
 
 	dev_dbg(smu->adev->dev, "od percent upper:%d, od percent lower:%d (default power: %d)\n",
-					od_percent_upper, od_percent_lower, power_limit);
+					od_percent_upper, od_percent_lower, pp_limit);
 
 	if (max_power_limit) {
-		*max_power_limit = msg_limit * (100 + od_percent_upper);
+		*max_power_limit = max_limit * (100 + od_percent_upper);
 		*max_power_limit /= 100;
 	}
 
 	if (min_power_limit) {
-		*min_power_limit = power_limit * (100 + od_percent_lower);
+		*min_power_limit = min_limit * (100 + od_percent_lower);
 		*min_power_limit /= 100;
 	}
 


