Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43CC929345D;
	Wed, 23 Apr 2025 15:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422236; cv=none; b=EPdgE5+OnyCoY4S95MY91h/5ZkHr0d+KljkljLtqh7J0IJjeFQwo1gMJIQQX7K2Skf+NCOwZRR66vknuyjTGqIyofKzDXwdrgBGekbDsiIST/mNvbFgPD9Wf7FZzq/Wy3FtGu4uUb2W8yVgRxCuQEnJAR2ER2LJGzE1XwfPga6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422236; c=relaxed/simple;
	bh=BnDSPTo5bYdbX2D8jxgq079VLyu5w+ur4un3Yfxn15A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dPwSgTYA7OHYDtT8xskirRl8EhHcOaFjIKYXWHjQ4NS5isfq89ApZlrCa6Jm/81YiKNs+SE25nIwEJ/BS+Fcf2F+9Uh+vyH6U9DR6Saqtj3/kyt0WJoiL4kOL2kfqR0HjIuaTNS9gi0YEe6HG6a6IX/iq9e7f1mE/qDjFUg4D1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wZngrFRB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZngrFRB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69803C4CEE2;
	Wed, 23 Apr 2025 15:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422235;
	bh=BnDSPTo5bYdbX2D8jxgq079VLyu5w+ur4un3Yfxn15A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wZngrFRBCePErM0bvOXdkStj4no42MaziANQRjr+/oE+ThJdN53Hhh7ClmBsUKhIz
	 vMgMAW8QO3nQeR3nV9uUs+CHQYP9mkOD6YamByu0DpM0Rd0qt8uSqT/VZqd1HItjNW
	 +5lqMTaPuiGGzfOYrS4KqSjVf5Q4HXoisjhckjV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 239/291] drm/amd/pm/powerplay/hwmgr/vega20_thermal: Prevent division by zero
Date: Wed, 23 Apr 2025 16:43:48 +0200
Message-ID: <20250423142634.180841117@linuxfoundation.org>
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


