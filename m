Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB542D7393;
	Thu, 30 Jul 2026 14:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423246; cv=none; b=E3h6zIiFxcTgSWbUhJgefyvsNkcWJ9rzsOLUpwchPFeBJj5eEBQVlBOuKpS9nqAne9GA+QWZH5ebhxDkR8X+atbd1wYrNl2+sKNlmfYTrLKRqCB3qF1XTs8UKfY8r//pkTDjnj4r1yCNz9kHKo7su6PUuVzLFG2TBMyi+RMAP3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423246; c=relaxed/simple;
	bh=g1PKUoyf7wz+FYpdlaDYWb2+XuD0oMyHBLzY6OlzwlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZy6DQvULg/0H2DiIPOZwPRYZYAL5WZg6vHywwJPZix/K/0bpvmk3owgjSlpGrNBAUXygKtXMG/e+lEe4mTXKyjGZlNR70Vmu+ba55+S+wCRc0v6craZRdne/+YVeglUPPRSFlCIALnklTmP+8hWAIvegdjX03W686YKMlxhGVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1mWkQt9W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1mWkQt9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6264C1F000E9;
	Thu, 30 Jul 2026 14:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423244;
	bh=gdocrZqfvl+bULvToMjuDnlSUPfAh9z+3gBr0sx7FDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1mWkQt9Wq+FJv3qzcJ/+7/oWOD1/O813MBDHLUNOxpq0hZ9vYW2miQ1RSMzchsoCC
	 66ecXWxmBNfv0Dfsjsmm64aZzdyzyY8ePfOhaom5MTy+UnMsfqu+X9zvKipjq51IPr
	 GjtK9OqF5VQkBgqF5mQmlBSEY9hNaaKQ6PVHkgWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 717/744] drm/amd/pm: fix smu13 power limit range calculation
Date: Thu, 30 Jul 2026 16:16:30 +0200
Message-ID: <20260730141459.518380961@linuxfoundation.org>
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

commit 220f22e1d66c1cfb63387eb1c4210f92a357c2d9 upstream.

SMU13 reports SocketPowerLimitAc/Dc as the default power limit, but
MsgLimits.Power may carry a different firmware bound for the same PPT
throttler. Using only the socket limit for both min and max can therefore
expose an incorrect power range.

Keep the socket limit as the default, but derive the range from both values:
use the lower value for the min base and the higher value for the max base
before applying OD percentages. Keep the current limit query independent
from the cap calculation.

Fixes: 1eaf26db9590 ("drm/amd/pm: fix smu13 power limit default/cap calculation")
Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5419
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f45bbf0f62f266ed8422d84f347d75d5fca846a7)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c |   11 +++++++----
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c |   15 ++++++++-------
 2 files changed, 15 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -2403,11 +2403,14 @@ static int smu_v13_0_0_get_power_limit(s
 	uint32_t pp_limit = smu->adev->pm.ac_power ?
 			      skutable->SocketPowerLimitAc[PPT_THROTTLER_PPT0] :
 			      skutable->SocketPowerLimitDc[PPT_THROTTLER_PPT0];
-	uint32_t power_limit = 0, od_percent_upper = 0, od_percent_lower = 0;
+	uint32_t msg_limit = skutable->MsgLimits.Power[PPT_THROTTLER_PPT0][POWER_SOURCE_AC];
+	uint32_t min_limit = min_t(uint32_t, pp_limit, msg_limit);
+	uint32_t max_limit = max_t(uint32_t, pp_limit, msg_limit);
+	uint32_t od_percent_upper = 0, od_percent_lower = 0;
 	int ret;
 
 	if (current_power_limit) {
-		ret = smu_v13_0_get_current_power_limit(smu, &power_limit);
+		ret = smu_v13_0_get_current_power_limit(smu, current_power_limit);
 		if (ret)
 			*current_power_limit = pp_limit;
 	}
@@ -2430,12 +2433,12 @@ static int smu_v13_0_0_get_power_limit(s
 		od_percent_upper, od_percent_lower, pp_limit);
 
 	if (max_power_limit) {
-		*max_power_limit = pp_limit * (100 + od_percent_upper);
+		*max_power_limit = max_limit * (100 + od_percent_upper);
 		*max_power_limit /= 100;
 	}
 
 	if (min_power_limit) {
-		*min_power_limit = pp_limit * (100 - od_percent_lower);
+		*min_power_limit = min_limit * (100 - od_percent_lower);
 		*min_power_limit /= 100;
 	}
 
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -2385,15 +2385,16 @@ static int smu_v13_0_7_get_power_limit(s
 	uint32_t pp_limit = smu->adev->pm.ac_power ?
 			      skutable->SocketPowerLimitAc[PPT_THROTTLER_PPT0] :
 			      skutable->SocketPowerLimitDc[PPT_THROTTLER_PPT0];
-	uint32_t power_limit = 0, od_percent_upper = 0, od_percent_lower = 0;
+	uint32_t msg_limit = skutable->MsgLimits.Power[PPT_THROTTLER_PPT0][POWER_SOURCE_AC];
+	uint32_t min_limit = min_t(uint32_t, pp_limit, msg_limit);
+	uint32_t max_limit = max_t(uint32_t, pp_limit, msg_limit);
+	uint32_t od_percent_upper = 0, od_percent_lower = 0;
 	int ret;
 
 	if (current_power_limit) {
-		ret = smu_v13_0_get_current_power_limit(smu, &power_limit);
+		ret = smu_v13_0_get_current_power_limit(smu, current_power_limit);
 		if (ret)
-			power_limit = pp_limit;
-
-		*current_power_limit = power_limit;
+			*current_power_limit = pp_limit;
 	}
 
 	if (default_power_limit)
@@ -2414,12 +2415,12 @@ static int smu_v13_0_7_get_power_limit(s
 		od_percent_upper, od_percent_lower, pp_limit);
 
 	if (max_power_limit) {
-		*max_power_limit = pp_limit * (100 + od_percent_upper);
+		*max_power_limit = max_limit * (100 + od_percent_upper);
 		*max_power_limit /= 100;
 	}
 
 	if (min_power_limit) {
-		*min_power_limit = pp_limit * (100 - od_percent_lower);
+		*min_power_limit = min_limit * (100 - od_percent_lower);
 		*min_power_limit /= 100;
 	}
 


