Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E43828152D;
	Wed, 23 Apr 2025 15:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422178; cv=none; b=AHBr6IFky3MSp3vL1aptkWwkb4SC32n799TO1WCwYGN962wCffqjse+iiRhXaemSmKg3ALkBPGcI8ienoE09CIZ2/Codc54syZT/m2ex0A8Zjs6Ztvp/3rXG6WHbPv2XQgD77r+AYLl+Dpw3TaBomKohAc1t7xNpKfkHWYQz+LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422178; c=relaxed/simple;
	bh=LPqZ5Q7hUUJV0bBkrP8H0xLU5zpoCqI/YJXzeaFe1Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6NXVpp5qbvPyc6pxuMZhQCCigGZ1c1zHgSYjm/fFrUTdIlWQVd/SoaX2G7WR59ANMsbtQtN2NgxR0WSupw4WsJxjLO9Umixc+Hyh90MPxA30yXzC9ePxltqqmelLZcrDaQsgIWiAn6YFLSmn1cwvJedz3CrNLB4y5opBVXQXT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6uDJbb7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6uDJbb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DF2C4CEE3;
	Wed, 23 Apr 2025 15:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422177;
	bh=LPqZ5Q7hUUJV0bBkrP8H0xLU5zpoCqI/YJXzeaFe1Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d6uDJbb7yZakaLgQCR20ydGTF2POEQFW1HJv9g50PvkvjI5yF64KlTp/+mAeagEJI
	 Xvpv0qKgyGGUogGEVE6/Bv/GrVtET5igLQO+Xcx1brzvxzCeuYMbzbtajFvliZYXDP
	 gKylFm3zYN1I5axo5WdkYwRGCVDYKizcepszwZok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 237/291] drm/amd/pm/powerplay/hwmgr/smu7_thermal: Prevent division by zero
Date: Wed, 23 Apr 2025 16:43:46 +0200
Message-ID: <20250423142634.100748840@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -267,10 +267,10 @@ int smu7_fan_ctrl_set_fan_speed_rpm(stru
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


