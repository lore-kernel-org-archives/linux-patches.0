Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D2B380FD6;
	Thu, 30 Jul 2026 15:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426528; cv=none; b=brpeP8vbu5tUWOB+Hs0J0s+deQ+b/PIa5ywnJBDUFpAhDY3zheVlv7I3cke7XGXcB3srKa5HZDIfmVGQ0k4PqUDegb9MCrv5e3dVW0A1zW0rOg/tq4d+LJ7s+IWntu1jdWaC2VYJoFsrmT6OzCpAcxmBtmd53+ZqxrcWolsQWRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426528; c=relaxed/simple;
	bh=pWKVNXF3QygkC/EMpVGsMqc+MBMEq22Zina8NF3h810=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uO3nzDEytqd6DebO5f07ytfmfhw/yKkScnFwufYcpkMYpcTQN7ExaQmB3ulSc1d42hlr6ooz5BZSW+L9l7bWYm+Vv4QpnUnu+5QK9Uh4Vi0lJVJBqIzMc7B/s631rnYeYi6RwjhozE9idjrNJGWB4nm2wWmljDBrHnMzuemBjIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KpQTuZQa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KpQTuZQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17901F000E9;
	Thu, 30 Jul 2026 15:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426527;
	bh=wybnFPbOv/UnBb7r24bwNX36xzdw9159KnzZ/sW1A0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KpQTuZQaLzNnx8DxIAyWsJWrCXQYxfsUsMy4/6C62Uotf+AOxqwzVm/iFryKjlOpC
	 0RBSIDZ7YSdUWhQHKO5+vetHhmQ5IbmQbeuiy3HzOjFOsoJSGSXquaJP6FUz8pjC7F
	 1iYCwGMmzv4zpWRVw/ibrQG3NJKS5dWRxG1U7WA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 450/602] drm/amd/pm: fix smu13 power limit range calculation
Date: Thu, 30 Jul 2026 16:14:02 +0200
Message-ID: <20260730141445.416362163@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
@@ -2396,11 +2396,14 @@ static int smu_v13_0_0_get_power_limit(s
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
@@ -2423,12 +2426,12 @@ static int smu_v13_0_0_get_power_limit(s
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
@@ -2357,15 +2357,16 @@ static int smu_v13_0_7_get_power_limit(s
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
@@ -2386,12 +2387,12 @@ static int smu_v13_0_7_get_power_limit(s
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
 


