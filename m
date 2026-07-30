Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFC733D4E2;
	Thu, 30 Jul 2026 14:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422455; cv=none; b=ius8V1+ESZwQRJEYQk2qe7yMHiE9sKuF3gKLc89rxCZF2bR+IDHNYXYi+jC+DE5/8oD60ljVwcvMDJxMoWM9w7Gbont6SnoMhGnzFr1NfwDuiTyTBEJOzJcOq7gymJa1Axe71/6pbhjsjW28m2Wxa+kChQQg15n9bgRL9joLOGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422455; c=relaxed/simple;
	bh=L0Aa75UmQ8mw3PJzWqPM2vAmo/DzGoIk/GvRbuldWsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGF9dAEeDNUFmilMDvSYZKmuZ6zb7wRPh/OiHB7zAS8KIHTqsEKAfNYSy+0kGiYH/OM0lokjBlQcggSKCNxNYrh2gM3Mk7PDGkuWzluOPvslq/U2SKjOTqPw8KMuzj0soAxXXTay/WTqzkRASxz8H6yYPlxr5rsJAuxxo+5LSR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1vR8wB6d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1vR8wB6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773101F00A3A;
	Thu, 30 Jul 2026 14:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422454;
	bh=Auy/xqYuj+exZHt+OZgWjWWHjyzk40PyEU9nNV91dNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1vR8wB6d/BM+6przNrt6+dlrcNevrLNz/Rfj+UGnXRdngFkO8P52utfCCIC8+SGlL
	 f6xfR3tCLWpPO+Qfe87P3VvrsgBYrv/ratwFb1YYgWQylwyK5Du07tGMFoiQmZ1rqo
	 UFOKZW+/oYPbJO0OZtZevu05CTQkfV2K8YY9pxXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 443/744] drm/amd/pm: fix smu14 power limit range calculation
Date: Thu, 30 Jul 2026 16:11:56 +0200
Message-ID: <20260730141453.716248270@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1621,19 +1621,23 @@ static int smu_v14_0_2_get_power_limit(s
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
@@ -1647,15 +1651,15 @@ static int smu_v14_0_2_get_power_limit(s
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
 


