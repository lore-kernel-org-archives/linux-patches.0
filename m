Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6A2288C80;
	Wed, 23 Apr 2025 15:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421492; cv=none; b=ZOrwX7WjVF7HCePQgsuae/5qu3+o1Mp0h4nb0CBsem5E4VxPOeOsyhgFyFyb2hk28ozeu5kT7NBrmQJrLhFWM1M3KuujTNgIZpaDR9ckls9aQ4mQG3nyNmyHccb0c+Yi1yrU752ttgc893cZmV5rHtxQojV99Iii8mnF0gd1wfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421492; c=relaxed/simple;
	bh=gZo2uE7A9OvkwRIVCu1hIKObwWkMF4jT61Yh6JUmkJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ju1zeI1jJ3LTnRUGRA+B4g4i1T1XfsucuXCbc3r2ZgzwEhRViS8Dak7Fo2E7jI6L44TPZsmGDbiGXXpbRtuRP3OQcALftRLJBOXHT8i/7OgfgFptUvXgxW73y+POgQq0bDQPJLco8Ck6YFo/e+BlY4xE03YFAkH/DMntW6afj+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qpsqW5pQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qpsqW5pQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E4DC4CEE2;
	Wed, 23 Apr 2025 15:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421492;
	bh=gZo2uE7A9OvkwRIVCu1hIKObwWkMF4jT61Yh6JUmkJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qpsqW5pQdBEKtWkAM3NDSpQaYaNtJFdltN/p2PORS+iX44B188KZnkdqXYK3qmMYD
	 21B6j59erdI8lZTWrQDnmAT+kOjI5WHVFY/bvLF9Uo7/ZqH0tedXJ5tHUH9tOemybL
	 +cKD7W+mGVmN4c2kjSgZLotoSllxgCnRijelnnAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 185/241] drm/amd/pm/powerplay/hwmgr/smu7_thermal: Prevent division by zero
Date: Wed, 23 Apr 2025 16:44:09 +0200
Message-ID: <20250423142628.076114638@linuxfoundation.org>
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


