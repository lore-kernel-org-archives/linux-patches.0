Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A10328B517;
	Wed, 23 Apr 2025 15:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422493; cv=none; b=T/ohgl5mu4E94B8PjTd2kuYsJcjIijbYrw4QtZzacS6/+j18AXn5qjr0N4l2xSmjKtg2QPKAAGO59JaXki+E9Bvee5NEeHBMN3gz2iiphj6mukETymAu0w6tBX8HCtCU6nyi/Aqv7R4J3USPTHEvKJ0hI2kxZpbM7obbeeBRyZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422493; c=relaxed/simple;
	bh=3e1jiKpVraQV4JDmaqWNOF612ERj89S0yzEGeQQFLdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwd4sCpD33r3KQi6ClMVttzdRoY2tNkMzXgW9+CBgjmJfHFIlOSbBKUPAWIrjxHdi6THkT4qttyZNE1l5In1x83gFgJE/KMuW9ofG/fTxWEy7JT7EfQ7LSOIsKuZKp9SnjMRQ3eEBTVubQ0tsTWjsVBIECHFR+Am5nP7Sq399Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gb6umj4k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gb6umj4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC22C4CEEC;
	Wed, 23 Apr 2025 15:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422493;
	bh=3e1jiKpVraQV4JDmaqWNOF612ERj89S0yzEGeQQFLdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gb6umj4k+3woR0Exmqn9QJx4YKNS8lCPhcWWlh4mCDEk627/i02C6fhqCl7hAcFOc
	 u/Se8RZI1jPwyOV+VC4cg0qkJ3NxurPJSWvSnVBEfNWNELOTnSzvRI61bQHmzxlUL/
	 ECIrGzjOFss/JT5AGEnknldDYZ/FJ9brTRXkhMC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 354/393] drm/amd/pm/powerplay/hwmgr/vega20_thermal: Prevent division by zero
Date: Wed, 23 Apr 2025 16:44:10 +0200
Message-ID: <20250423142657.960716166@linuxfoundation.org>
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


