Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F6C24BD02;
	Tue, 29 Apr 2025 17:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948974; cv=none; b=urR2WScpeosYfEqsiFTGdATxl52lEjlhK/JQyDYMxL1DVr0mDoXaqctwfsdrDyuw31bwnDo1yT0Qy2Ko+wSX7GAZhKVhThbUBpvjPpYgklQPad4qZN3jLGrKjLxwjaPo9m5JKyYabqTgSQgrg8M9yjs5EqcpKzgJy6kFyuqr9yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948974; c=relaxed/simple;
	bh=Yj885/bYaspAWzOr8BQ7sxbl9wH60TXQd2jyYWMEp6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ttbUZQNbe89sofUX2LxItRocjYzjIVJBzB9z0s+cAG77wvOUY0xbTf6HF/4kPwgtV1GFeyM895DJ5r/hIHr0XGhIPno6zWJFJ732qembdp+jBIQNuH9L9hzWAptqvohHgOtvTkSFniRSVOZtFiLGlTvbNYe4V6S2Dd88NpSUj4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJX9rva5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJX9rva5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301ADC4CEE3;
	Tue, 29 Apr 2025 17:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948973;
	bh=Yj885/bYaspAWzOr8BQ7sxbl9wH60TXQd2jyYWMEp6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cJX9rva5Pufq58N5elfXjbn3FSs6L1TnKZdRw7vjzfWKkmQRMLXN6hjJxIXZozYKm
	 XRmGCpED8BE8a4Ir+4MJzei4MUtuHaTacpudPjXfnIBhw86dPZehs1RbgOheZT5STj
	 kbFxXMQT0xuj4XM+mNt7lveP2roKoySKgw4Zhs14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 180/373] drm/amd/pm/powerplay/hwmgr/smu7_thermal: Prevent division by zero
Date: Tue, 29 Apr 2025 18:40:57 +0200
Message-ID: <20250429161130.571157181@linuxfoundation.org>
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


