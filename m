Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F429215060;
	Tue, 29 Apr 2025 16:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945520; cv=none; b=SOCQpNjEVv96UmCMAFK32KA6v46siIwCMN4mtDg0HvcR9CETbrLHAOTYVNKoqFKE9oFfAkvuXcEK9P3X7Duk7xXRMwhjqVWdECYfycoq+Dl3jVmqThieBTvWyV1KepkrtLDjDGgRVjwLt3UyO+EFHSEThoOZTJvp0BJw2ZsItAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945520; c=relaxed/simple;
	bh=1D2jm8fEyMDydKCml+pvyezdVihBKOEEwhAk9wwsDtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L3KWFkyBZsCVjzY/1gqoXCrVrZjpFOFZVx5OdPsG/S71YiOb/wZjSeFlyv2mVNaHWqfKHA9u6cX8vDXT6C0mU47aYx6SxLnzH+Rv//wnXdd+aoODQRqxsceRvtHgGOIhMgob3egr5emUZdah7izi7XOgll5X8o0bacAg07R8bps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oKU/O+r+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oKU/O+r+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA82C4CEE3;
	Tue, 29 Apr 2025 16:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945519;
	bh=1D2jm8fEyMDydKCml+pvyezdVihBKOEEwhAk9wwsDtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oKU/O+r+qJm1ag67fsd1VTmonFC3KJk0MaVqqjC2sEQ/p9ppXPPJj2UWhDvaxv48F
	 GnhNm0+Rioc607ZwZrKSWOQxEXbtbqGqjOaDOebSMDQKcKsDKjJPd3T2hKJPWE7qzt
	 TZCrjGFqJXlzmx+QHoN01LssqAfeNNOEONWMOcnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 140/179] drm/amd/pm: Prevent division by zero
Date: Tue, 29 Apr 2025 18:41:21 +0200
Message-ID: <20250429161055.060706324@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Arefev <arefev@swemel.ru>

[ Upstream commit 4e3d9508c056d7e0a56b58d5c81253e2a0d22b6c ]

The user can set any speed value.
If speed is greater than UINT_MAX/8, division by zero is possible.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 031db09017da ("drm/amd/powerplay/vega20: enable fan RPM and pwm settings V2")
Signed-off-by: Denis Arefev <arefev@swemel.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/hwmgr/vega20_thermal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/vega20_thermal.c b/drivers/gpu/drm/amd/powerplay/hwmgr/vega20_thermal.c
index ce56b93871e8f..d057c6f7e1fce 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/vega20_thermal.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/vega20_thermal.c
@@ -189,7 +189,7 @@ int vega20_fan_ctrl_set_fan_speed_rpm(struct pp_hwmgr *hwmgr, uint32_t speed)
 	uint32_t tach_period, crystal_clock_freq;
 	int result = 0;
 
-	if (!speed)
+	if (!speed || speed > UINT_MAX/8)
 		return -EINVAL;
 
 	if (PP_CAP(PHM_PlatformCaps_MicrocodeFanControl)) {
-- 
2.39.5



