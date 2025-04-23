Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AEA92BE7D3;
	Wed, 23 Apr 2025 15:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422441; cv=none; b=Z1R5sNaHvX/p4v++DwSHHH7W5tfWLE6c6uHso0gqlJa8xD2DY1eQyDy9gkGFF6Y10tiFib+bcJVrtXz4Lxox0dQKAnnpq40Rcep4eAEODeprCF08DnKPqp8Z2nXVBi3e73duXOvtlZHAPN7EjzL9WdRiZRrDAUbiE/BicXAGsFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422441; c=relaxed/simple;
	bh=po44SUmFkm/NmVTbandtsrLVLFdXot1O5+4STaVEAmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vxry118hBMLWJWnp7UULFDDJ6RB6GC19sB0obJzNMzNRxzHTSiK+P9c06aPrlX4n98SxJGKHu2XjskggxE6vb9d1n1F2CF/F9lui0FT+SL/SirFa2DQxY5oRVbcOxeQyChgSsb4Fsmsgxrk7AXN2oLxWuYfjlHymH526ofYXCRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hHJdLu3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hHJdLu3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5506C4CEE2;
	Wed, 23 Apr 2025 15:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422441;
	bh=po44SUmFkm/NmVTbandtsrLVLFdXot1O5+4STaVEAmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hHJdLu3kBMy3xQMhOhtavJNuMYqWpHGx9JMvvQQnU9r1MxZnYw7q7ZcJCDGEKBTVr
	 SddemnxvAyqR4vJ8xr1cHG4xiMlii/9kRHBlRaxZzbzN9prDlWIoy902nSdDh89bcq
	 xkh7LQfuTii2trNbJE2IdnbFCPHazLBU2h7huRCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 350/393] drm/amd/pm/powerplay: Prevent division by zero
Date: Wed, 23 Apr 2025 16:44:06 +0200
Message-ID: <20250423142657.795477687@linuxfoundation.org>
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


