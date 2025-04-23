Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A8428CF78;
	Wed, 23 Apr 2025 15:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421406; cv=none; b=sQ04TJIS2MW98SxkTOKoIa0/o5Fn54ta7gsONPQ5SgCMNj5WlP5xMHHABz/uSWx0WS45sIPidC19k26ML8HZBgJxwQT71X00DOtxz6Y0OQObsb2TiZVwbyoq3LDtzHnn6/o+k6ij8mkRSqqXhYBBLb2M79OKBtXMWUuyOmIGXaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421406; c=relaxed/simple;
	bh=oiih+jNRUkMwEMID8lxECPTE395amBKMzN0mCIXj0NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MxNviJt0KqeVtxKK3EtsyYF1I2wCLy7XjFfFPS+/3nLf0qWUmReftee1U2G3HsKooo/iYmLgGFlgsunl51uJRwECvmDJm6mAA+X8szrPDzsqdGiGZIXYD5CaiVeMFENiiiOlIKdonT/3jH3lxfIlum5hLjtvqBPLmvc39i/XV4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+la/RTt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+la/RTt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF444C4CEE2;
	Wed, 23 Apr 2025 15:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421405;
	bh=oiih+jNRUkMwEMID8lxECPTE395amBKMzN0mCIXj0NY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+la/RTtRUFIVnQNHfpCGtF7llyl66AZUXYIyprnZegyUGbRbz464fgGlfS2W/SS+
	 w4mZ/5ylNxCw2up58xsGGlXar7xmoJpMsz1lh4skC/ZaX5wH5H7B0W34m4rph/M8hj
	 PoC4Cb7IeqkNvMWhAEaN4uwHeVnfCNWTsNtMAGVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 182/241] drm/amd/pm/powerplay: Prevent division by zero
Date: Wed, 23 Apr 2025 16:44:06 +0200
Message-ID: <20250423142627.954628301@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


