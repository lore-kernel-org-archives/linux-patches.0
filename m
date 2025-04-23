Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8D628CF61;
	Wed, 23 Apr 2025 15:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420737; cv=none; b=L6HhVAFYqQf9Ow44fWJnCGEzr2+jv4rz0LhLNXQI1WLHbNYp/qGJ2zCwOttnk3ujgHMZLtbd9r4rqD2/0KJaXUBuNDls2agbn/meary5I+n85slsR087e3khYrcOEEl9dqImNq6ms4LfPjpnEzQ1f4siq1sFkKKof/m3F+3ekCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420737; c=relaxed/simple;
	bh=bkv/24m11SQBpYpjlkdd14z9jrR8vqq5zrCVOqMQupo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4kFEABjmdtdhI6rcYlLuLJBJPHmtTtdkb/Tg3ArGguy9awuzvT1S1J2Fz9/XlfpIyV4F4TUeaJDTr9DYFXInw9GeB1z5WdNcTREn9HY9zMbsv1PUKXwYEuFnElNvs65w2dcCz4eEp5Sh4twP/schhVChIk6vn9tfrrhc8bf4/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c7iBL/aS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c7iBL/aS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2B5C4CEE2;
	Wed, 23 Apr 2025 15:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420737;
	bh=bkv/24m11SQBpYpjlkdd14z9jrR8vqq5zrCVOqMQupo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c7iBL/aS9bqtCiAB1QWgtnBJ5YAdcwSKslQXUnisRoDtIrIqbx3E44T5ePA6yBHvL
	 PwnB/dktStY9/6b01+kG7mmoK84qnfWBQvOiJ12W063L02r7FPclo/QxdP54+K3UbC
	 3Pba3vGfG8JiGlPhXWIYOhQJ18ZZZItOwVpD533Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 158/223] drm/amd/pm/powerplay: Prevent division by zero
Date: Wed, 23 Apr 2025 16:43:50 +0200
Message-ID: <20250423142623.607770276@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Arefev <arefev@swemel.ru>

commit 4b8c3c0d17c07f301011e2908fecd2ebdcfe3d1c upstream.

The user can set any speed value.
If speed is greater than UINT_MAX/8, division by zero is possible.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: c52dcf49195d ("drm/amd/pp: Avoid divide-by-zero in fan_ctrl_set_fan_speed_rpm")
Signed-off-by: Denis Arefev <arefev@swemel.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_thermal.c
@@ -307,10 +307,10 @@ int vega10_fan_ctrl_set_fan_speed_rpm(st
 	int result = 0;
 
 	if (hwmgr->thermal_controller.fanInfo.bNoFan ||
-	    speed == 0 ||
+	    (!speed || speed > UINT_MAX/8) ||
 	    (speed < hwmgr->thermal_controller.fanInfo.ulMinRPM) ||
 	    (speed > hwmgr->thermal_controller.fanInfo.ulMaxRPM))
-		return -1;
+		return -EINVAL;
 
 	if (PP_CAP(PHM_PlatformCaps_MicrocodeFanControl))
 		result = vega10_fan_ctrl_stop_smc_fan_control(hwmgr);


