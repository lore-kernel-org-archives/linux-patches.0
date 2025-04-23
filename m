Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510D829B76A;
	Wed, 23 Apr 2025 15:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422551; cv=none; b=sffy4PZS1yQbUtumfyomcRCz7ZMCKiwvbw1fEuynT1HvmqqbqTXDAXk+sFUMqOEqHnrDb2k8OA6zg9uxqoIlmkoU3Ncq0kN0CRxJBAS5zWJ+G+gjaofLIOmz4p4GeO5ljvYAIyvZ6EG1Ifm6goT7kUT5xIVCdxP3UtfwvdHlCf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422551; c=relaxed/simple;
	bh=NcAp+v54+vdMUXC4vYLJd3nJskzjzKvG3sKAkTAH90E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AwSUNR6QC1MxJqYDdmIR9jaGi7y/0l72RyrI+fM3FNbvjOJQ5hNBKXtx7z9Zko+P5fVE+wTNK45+q/SL4gLk6AGzEXcLl1oc7dya5ngONow41YAq0tsr347lK8KgLy19tHsrO2gILk4LcDn65/Br5XErzZrfCHqtwiJ0mP2CEu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pLEF/QOQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pLEF/QOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BB5C4CEE3;
	Wed, 23 Apr 2025 15:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422550;
	bh=NcAp+v54+vdMUXC4vYLJd3nJskzjzKvG3sKAkTAH90E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLEF/QOQKMYBGPL8PJli4HtQncT+A3dV4F03R6UUkDmjnkPHSMVbfRuOzMXVOs1/m
	 1EGOKpaXIrv+W9+qEUz/7gUZU5NrLLmRgimmh3VzXU3PzWXse/6WC4vh5UH+87jj0r
	 dd84oql+J12lWGFUS5MQJk2hc+OSfDVUj9/TKEYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 352/393] drm/amd/pm/powerplay/hwmgr/smu7_thermal: Prevent division by zero
Date: Wed, 23 Apr 2025 16:44:08 +0200
Message-ID: <20250423142657.874273883@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


