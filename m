Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27CF24E000;
	Tue, 29 Apr 2025 17:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947003; cv=none; b=H5MVNDBVxOonTxv7hbYMBoV9jz+zPBIwE7KZy8ByuoJx61VuxVxguND5cxJoqUUEPPkXhaQKtg5x1nSsAVeDp9FWTLM1JGFNnh23e7MBavyGk7uGV0mBGD3Voyen4Kc/PR/Nn5RI1AE2/Y2MTOhNdz6BXcPdTGsSzCESLgpBI2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947003; c=relaxed/simple;
	bh=LWfhVx25MFy9utd2tANdHvAWxTtYUijOHtLuaHtAUq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OiuPSMPmKshcaOKLoPRe9tEXu8P82z2a33xFBkkW0DMSiUw3ZNjzvT7T33cKhBh18EnMlhiFk8txgwTVOeeNfeQtfwp5ql0ZljCphj62REo09yVX5nxDHEuEYMeY9eJIO+VHAyZZHy81d8eAYEsmIDYNvNH/EQBRNl+/MDti7LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Xd/WNxA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Xd/WNxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5E0C4CEE9;
	Tue, 29 Apr 2025 17:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947002;
	bh=LWfhVx25MFy9utd2tANdHvAWxTtYUijOHtLuaHtAUq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Xd/WNxAU1l8TPAc9FUyhGc0SlkUNgJYhzg3oOZ/fnMwFzIeSxCNEODQCPUSY1EPP
	 QeB4GMo9UyVoGg5kI7zYXUkjiQUSnyPn59iVrbvMHEaNDUHjKO/B6W5elLW/liHi7N
	 3V3erRoT8UCCixss/FIWluHVCMNL5l7SefQt7BYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 140/286] drm/amd/pm/powerplay/hwmgr/smu7_thermal: Prevent division by zero
Date: Tue, 29 Apr 2025 18:40:44 +0200
Message-ID: <20250429161113.630870899@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Arefev <arefev@swemel.ru>

commit 7c246a05df51c52fe0852ce56ba10c41e6ed1f39 upstream.

The user can set any speed value.
If speed is greater than UINT_MAX/8, division by zero is possible.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: c52dcf49195d ("drm/amd/pp: Avoid divide-by-zero in fan_ctrl_set_fan_speed_rpm")
Signed-off-by: Denis Arefev <arefev@swemel.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_thermal.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_thermal.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_thermal.c
@@ -261,10 +261,10 @@ int smu7_fan_ctrl_set_fan_speed_rpm(stru
 	if (hwmgr->thermal_controller.fanInfo.bNoFan ||
 			(hwmgr->thermal_controller.fanInfo.
 			ucTachometerPulsesPerRevolution == 0) ||
-			speed == 0 ||
+			(!speed || speed > UINT_MAX/8) ||
 			(speed < hwmgr->thermal_controller.fanInfo.ulMinRPM) ||
 			(speed > hwmgr->thermal_controller.fanInfo.ulMaxRPM))
-		return 0;
+		return -EINVAL;
 
 	if (PP_CAP(PHM_PlatformCaps_MicrocodeFanControl))
 		smu7_fan_ctrl_stop_smc_fan_control(hwmgr);


