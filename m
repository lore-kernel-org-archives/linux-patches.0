Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88FA43E4B5;
	Thu, 30 Jul 2026 15:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425001; cv=none; b=YesUuhloGTFQl5lhqw+B7229x0ub9Q85vf9n56dg79N08Poxv25moIqecotA6fCUffoB4QT3n28ccK1xsUUUUAX8sv5VxZiC8WdmjHEKGBB78NGVpRNdtzRQB/wcCoURCyz99WIEaHqvePSMUiRS5E1HKNXo1AmknrmYNefLBRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425001; c=relaxed/simple;
	bh=G1x9JR5PyzSOkQteGINAEt+DsETE3Cs6BW3E1oeEif0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yf4zjZ9/k+cF9+YF0fKk6iTQROop/Zvh/mwaIbMkzYSwuzz07bI1CTCy8r0vEoetlRxwRqMp6pOQyRAUjrmezhzgOBTNPehUy/Bz1QelG0TTRcXgBMB9VJiJCvQq/k6H63T9U3niiLjpvCZHbndYakkoWUKqXGhAF40S5G9sk9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o51wa8j8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o51wa8j8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A08B1F000E9;
	Thu, 30 Jul 2026 15:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424999;
	bh=N73PS1g8VnQPMTq8c2Rr2lfQJIj98Zq4bF0RiF809eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o51wa8j8cKG74Oth5kJS2LG0nhINwi3vrt0KOlN9Xziizg5w18KtwY8SDHQzyS945
	 AQGZRcEFVP9yF8j7V4v3dofFcl0sFpGTVu6b5pVJCXklpAtFoeD/4/6AYGdYBNnT9t
	 cCjfrBj0MHAvorKnnnzPvZCgtqMItBJHIqAbZHkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 589/675] drm/amd/pm: fix smu13 power limit range calculation
Date: Thu, 30 Jul 2026 16:15:19 +0200
Message-ID: <20260730141457.642521650@linuxfoundation.org>
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
@@ -2481,11 +2481,14 @@ static int smu_v13_0_0_get_power_limit(s
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
@@ -2508,12 +2511,12 @@ static int smu_v13_0_0_get_power_limit(s
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
@@ -2442,15 +2442,16 @@ static int smu_v13_0_7_get_power_limit(s
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
@@ -2471,12 +2472,12 @@ static int smu_v13_0_7_get_power_limit(s
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
 


