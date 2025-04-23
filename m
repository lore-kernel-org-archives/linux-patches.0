Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E592F279906;
	Wed, 23 Apr 2025 15:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422121; cv=none; b=hrwKIVQJQU5klkDPZQQzzjvWVBObRZ8jOpRaKDlmwmerc6mDelcbd8vVf/9HrQKCwUATkBRMwoEbQSatKlbseSOR+UuoO7gglUgr07G96uNRfo4NdKnF9rYt/BkbGdXSFu4h9OMO0NfsEucwXKOhcEfScjsSzo9o+0QnBgYx/ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422121; c=relaxed/simple;
	bh=uCXTZf/K3l02Zp8OAX5eFLM9j/DpaPCFoe09gtLASxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swv18zvRcTDbUxN8SnXAo75AIfTumhU2VLN1JFYYQe8gTnu0EksQCH4zMFJpMQyKHAsQBCqm3fLQhNS3jlXpdeT3rizELBOoa9V3k/oWJN8Dx7FfxLDYnSHTprxPDmsYL7JpaYvWbLTW9flWkWtj/CG7BGv6C4W7q8BZENMrYNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uVS1WImo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uVS1WImo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F53AC4CEE2;
	Wed, 23 Apr 2025 15:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422120;
	bh=uCXTZf/K3l02Zp8OAX5eFLM9j/DpaPCFoe09gtLASxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uVS1WImoNhyU17Dw0FlP8WdlrAW6Y09fU0WLijkPwRWqWQz3KN8jyP3rKZNjbTZg8
	 L+wEV2syISewe9n6IITVbGslss3J7V4kzKuo1+pwLH9HRunmEObZAtPSUrrPp37qyV
	 iRSzZLhb0bYqp+Q0pW3Q81YQar1kBO9xXt60JFNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 235/291] drm/amd/pm/powerplay: Prevent division by zero
Date: Wed, 23 Apr 2025 16:43:44 +0200
Message-ID: <20250423142634.021414177@linuxfoundation.org>
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


