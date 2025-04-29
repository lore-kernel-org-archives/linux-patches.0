Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C1E248191;
	Tue, 29 Apr 2025 17:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947000; cv=none; b=kp+A6cpUXbtmtXZ/jjZ8Y8v4fuz3wUf1pJtwBKvBoD822D3BrRITYXwDiVeuSjr0fw1HPQ+Ca+wk2Aa/hf/xoUdBGyeXmQ/oPJ+vOIhcQ1mRSF5VheK3hWlsKL5OswPKuohl7Yu0BOGi6aO/C8NR/A9wH4J7jv2iajDqJg/zado=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947000; c=relaxed/simple;
	bh=tIh6ITPi9SvjJ+M3FQqIo0ADUMoGyi3hJ0RlC0xNDro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sg5CZn2SO+8Mo8IoUvbdlcT3DWgbVJ2L9RolN3EHKC4Z3opcZ7vkpXHZTNBI7ARyh0T+demMsEG3BK4dYNyqTjTVBxYVb3qdjMaBIhr/1T8vB9oP1w68dQsvoYPcwpHUUA6X7VY/ut6u/P2MgnpQ+OJI4nHs6SIojBObKGWpqd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3i/QYKb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3i/QYKb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C41EC4CEE9;
	Tue, 29 Apr 2025 17:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947000;
	bh=tIh6ITPi9SvjJ+M3FQqIo0ADUMoGyi3hJ0RlC0xNDro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3i/QYKbGlwr4oblRzMEqQIQIIVHWS+HhjoD9nq/j0May/UegeZJQlUqiMuVwJA4B
	 Xu9nswqeJssusHN0u5SsNBMPbtMCisBajqMBFpFtFrYPHvdPL8+JbonqZR8Cgsd1Lt
	 B/Z4YfZfuEYjoMpUCYGaJzX5XoXC2UTaIvX1c+ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 139/286] drm/amd/pm/powerplay: Prevent division by zero
Date: Tue, 29 Apr 2025 18:40:43 +0200
Message-ID: <20250429161113.590889142@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -311,10 +311,10 @@ int vega10_fan_ctrl_set_fan_speed_rpm(st
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


