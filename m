Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D0E21ABC1;
	Tue, 29 Apr 2025 17:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948986; cv=none; b=qBajvT4PzCAp4/qocO9EQCwbzDIA9Md1mW4V475LMo9K5vbc4Kw0e0eg1YWDgZJeEDf9lsN39MG+5+WxOhAP1JP4iRYT241UGxAHIpWjTmSgsVaAbspXaNoDmDyf6EurUqlr8a0Im32OFwJdcmYPzNxw1LbwuMZl61AMaUJhYHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948986; c=relaxed/simple;
	bh=WSMwajCTIJa5pi4fhBFdCeuREMJZb0S5vS3ZcteIGnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxNBJxOVhvxxw7gjj0t7Hf62zF0oWX9V6l82jYZc97aUqg+ETPMUn1XOBw9S0+LHuHyu7E+0w+eYAZL/mSWm64d4MyLxRh2d0fmXHZCTcCR3yg/dZZilp5Q6saclMfYGCQ3wEeTzU4Lp+/GPZYnhuSbKHf/UJVBXPmcbzAa8Jfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vd/jCMEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vd/jCMEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD97C4CEE3;
	Tue, 29 Apr 2025 17:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948985;
	bh=WSMwajCTIJa5pi4fhBFdCeuREMJZb0S5vS3ZcteIGnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vd/jCMEcN64M3viQr7wlkuDDIASKNTudqSzxJ30CAbaNJ4heFaobBKSZ0904IsPtH
	 6H6/GWBGqbI+2RegwsrUDLQFTKWn/Q8sNMO58eJnr7QTKkzQrGcs2CWN77G8NevjOJ
	 bc4x5ibye7kFVtXlwXDVQH1/ygPsFEIqLqzHIrNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 182/373] drm/amd/pm/powerplay/hwmgr/vega20_thermal: Prevent division by zero
Date: Tue, 29 Apr 2025 18:40:59 +0200
Message-ID: <20250429161130.649868683@linuxfoundation.org>
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

commit 4e3d9508c056d7e0a56b58d5c81253e2a0d22b6c upstream.

The user can set any speed value.
If speed is greater than UINT_MAX/8, division by zero is possible.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 031db09017da ("drm/amd/powerplay/vega20: enable fan RPM and pwm settings V2")
Signed-off-by: Denis Arefev <arefev@swemel.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_thermal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_thermal.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_thermal.c
@@ -191,7 +191,7 @@ int vega20_fan_ctrl_set_fan_speed_rpm(st
 	uint32_t tach_period, crystal_clock_freq;
 	int result = 0;
 
-	if (!speed)
+	if (!speed || speed > UINT_MAX/8)
 		return -EINVAL;
 
 	if (PP_CAP(PHM_PlatformCaps_MicrocodeFanControl)) {


