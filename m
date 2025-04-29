Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD65239072;
	Tue, 29 Apr 2025 17:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948968; cv=none; b=lTG16nc9apx/tjVtAZGDeuk/laFlXbUAnPuPRCSJ9nIRS857qVSikdA3VxrP2SsRY9LeEcs+7DXxpq1R6nepAy9B7atbj41EQ49QWXyMFMl88Zc8kwYzoB3vABO8jyjtCOWvddFqq9RLrv8R/tRq/Vcva3WZ1x317bM0mIK+j74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948968; c=relaxed/simple;
	bh=G84E59k0Sg/gaDOO8qi/F1q20fp97XS+1TlrHNd9Elw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ls25/QRvpUzrE8UR/BU1UCGelzyt7JcBmCJOnEv/L8c/w7nYKQ1lbMFzd3foXFDcCsE8TSnsHT3MEg6Di2+5839z5pcP5cTZOpQsFrethS1oxk8fMTmtoVgu+3rXhuX38wGYhA9LXDar8OZvzGfLLQ4eOP+4Qf7I0HAJDRS/RyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hx5b7A2N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hx5b7A2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FCF4C4CEE3;
	Tue, 29 Apr 2025 17:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948968;
	bh=G84E59k0Sg/gaDOO8qi/F1q20fp97XS+1TlrHNd9Elw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hx5b7A2NZJmhfkpiDZp6Xc+ZNNrlWgMHWhr7JdA+xTzLuJnp5bPXWrBUSTJyqywAA
	 OPHrno0m7pocNPch+I58lM6hwxdANZVss5+DjkWfE1y/Rqagm2XiNq0zqSTm045CmM
	 ciEqjCu9P2N0KhB+UCtOHYHKc0mJdUj47baClesI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 179/373] drm/amd/pm/powerplay: Prevent division by zero
Date: Tue, 29 Apr 2025 18:40:56 +0200
Message-ID: <20250429161130.531924349@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


