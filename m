Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2232472B4;
	Tue, 29 Apr 2025 17:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947006; cv=none; b=RH3ZFID/f3SO8UIgdptaCGG0fK+1ARujQmNk9a44e6t6zdCgvNoAqvYl3QNDLBylhHmssOiaIZLIeS7Nae91myPWshbadq5Nr4EZ0kiBOgS/4da63tkpYMKzBkx6XYXoEGy1+ZPTLqz2uw9egi8NfQmRPagO0UBvsVDZD8k/Rd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947006; c=relaxed/simple;
	bh=Dt9lzOjgQX1LOLxSNlvzsE5RNkJu5k1wmIg8AN3zwY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SNvIqgnoIEKGSXo1ncxgluaeCJUfGhhGz07dF+j8WXA/rMX6QrcaqhfBtG2X+JnLGwmRQ5DvX3K8/4dMiFJjH4/Y0KVis2jf9vAVy2dClYZmvEZZ25t5JMLkq1Tyt/xa5+KcUWo5KJ+bJGV0pkP+vfZVUVfnf5GbO40e0kKRZK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rRMfpRwt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rRMfpRwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59789C4CEE3;
	Tue, 29 Apr 2025 17:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947005;
	bh=Dt9lzOjgQX1LOLxSNlvzsE5RNkJu5k1wmIg8AN3zwY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rRMfpRwtNGNPW3vdcqzYW5jGJtCLI4op7sHXu3izkpeDK16CCA2VAY2ZmOTvCqJUs
	 4zfRgISRQL8q734BXm81m6PnFrhTe7snNrX61SMpDPpzpm7UiwaStuRXUDID5Np/8d
	 CNvTGpOSR5XeBO2frXqjZDUHZo61rv/lH/gCosP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 141/286] drm/amd/pm/powerplay/hwmgr/vega20_thermal: Prevent division by zero
Date: Tue, 29 Apr 2025 18:40:45 +0200
Message-ID: <20250429161113.672525585@linuxfoundation.org>
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
@@ -189,7 +189,7 @@ int vega20_fan_ctrl_set_fan_speed_rpm(st
 	uint32_t tach_period, crystal_clock_freq;
 	int result = 0;
 
-	if (!speed)
+	if (!speed || speed > UINT_MAX/8)
 		return -EINVAL;
 
 	if (PP_CAP(PHM_PlatformCaps_MicrocodeFanControl)) {


