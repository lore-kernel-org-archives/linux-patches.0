Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5D528D833;
	Wed, 23 Apr 2025 15:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421410; cv=none; b=TD6ZpIRayIq53ZwMIUi+oSH6+pa49VfgDJGh1ixhHDZjITOQ/QjNhtjU65I4RHHnGcE7lvzwqyeJOhyVLxoXNLsCsb0JKktquvT22FAaL7GCelNcIw0vaxdQWWO/WV8YchxYOMA4sm8Gg9dXl06BqbPNBd/R1frobIO4hcSSi20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421410; c=relaxed/simple;
	bh=LbyDJDDfwyUtkretEYyOgtvJBZSPWnoQo66VpmJ5xX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvwbMetTpZaMy3G/a0Mt4hmDnIFNkt/bqezzHVq3v+LLbxr9nAKLXZKl8e2tNAd2lFYayjbF9fXOK9ZiB0crwQ9rHErKsn8XNckFR0EmV2+NzwUJjJotsaVXNFryTIaGgRS7o8Ieo/w5HKN7gx9PirZmtEVTzQ4uvrSzYiCyvwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ufiYxrkG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ufiYxrkG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCF2C4CEE2;
	Wed, 23 Apr 2025 15:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421410;
	bh=LbyDJDDfwyUtkretEYyOgtvJBZSPWnoQo66VpmJ5xX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ufiYxrkGk2VTZUIOjX1Xj7N8Oz3of0t6jEPNcX4b3a3+a3E1hLRyu3qrmujHVaHdT
	 o6XTxUtAFJrQRNIlVTb716sKlQgKCIoNrEqLsrnqbKUqapc3YHuW2w8dAUkH3wBU/D
	 M1r1NL+ApkRonOeny+Pm2lTTRczw0TzT9v0PV+JY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 187/241] drm/amd/pm/powerplay/hwmgr/vega20_thermal: Prevent division by zero
Date: Wed, 23 Apr 2025 16:44:11 +0200
Message-ID: <20250423142628.162165552@linuxfoundation.org>
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


