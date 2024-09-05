Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B317718D65E;
	Thu,  5 Sep 2024 09:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530176; cv=none; b=ZvG1QAV7NzYApZ2ibeQNMzfLD7F0y7gd8h/hHfwDyzVpbf991cNAt4knSS2hkArdNA7o0tqLpd2UNuuQtwgbynCPh8qZlc19HMokp/G+75jVINmwGLfNeORmQt0cnGlnIQmFqcbK//FJR96wi3CmHGmmNpoLY+CRVU+qDZpN7A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530176; c=relaxed/simple;
	bh=lUNVN6EhO0pVYIIcTgJzDk1BgjQ1c5DWCNPhcv8FeZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGhlB7ubP5AyquTPVj5U/GlgqPCtf5t2InqQXTNjmShdztzyM1btcchAf/p9m+5TBuFbZSEWZYKUWOZ5Z7hH6jK4wIxbnsKrRbstM+54DJqjZjaxjb/fA8APGggsG7NMgEROSRB2UdwKB6ddA4+SlMptid22N0S7omu46+IrPRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zhZj9NM+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zhZj9NM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AAD9C4CEC3;
	Thu,  5 Sep 2024 09:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530176;
	bh=lUNVN6EhO0pVYIIcTgJzDk1BgjQ1c5DWCNPhcv8FeZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zhZj9NM+oQorJFjd8yVK8p01HgQ7PyZIzo1gulvtq7e2z4Ata8bSGxU7lMic27/2y
	 yQU/Kj0N4ekHn8drCcd8JSaHGnA7ZJCfX3p5SfrGcaDvBD2wRQNNCxXh1yVbyI7Bf8
	 j0m7qwkQH9tjTTjHxfPmONVb+x4KJbTQ5shqFRl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/132] drm/amdgpu/pm: Check input value for CUSTOM profile mode setting on legacy SOCs
Date: Thu,  5 Sep 2024 11:41:05 +0200
Message-ID: <20240905093725.284331820@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit df0a9bd92fbbd3fcafcb2bce6463c9228a3e6868 ]

Check the input value for CUSTOM profile mode setting on legacy
SOCs. Otherwise we may use uninitalized value of input[]

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c   | 2 +-
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c | 8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
index 163864bd51c3..53849fd3615f 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
@@ -5641,7 +5641,7 @@ static int smu7_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, uint
 	mode = input[size];
 	switch (mode) {
 	case PP_SMC_POWER_PROFILE_CUSTOM:
-		if (size < 8 && size != 0)
+		if (size != 8 && size != 0)
 			return -EINVAL;
 		/* If only CUSTOM is passed in, use the saved values. Check
 		 * that we actually have a CUSTOM profile by ensuring that
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
index f97ac4b79d8b..9fdb9990d188 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
@@ -4102,9 +4102,11 @@ static int vega20_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, ui
 	if (power_profile_mode == PP_SMC_POWER_PROFILE_CUSTOM) {
 		struct vega20_hwmgr *data =
 			(struct vega20_hwmgr *)(hwmgr->backend);
-		if (size == 0 && !data->is_custom_profile_set)
+
+		if (size != 10 && size != 0)
 			return -EINVAL;
-		if (size < 10 && size != 0)
+
+		if (size == 0 && !data->is_custom_profile_set)
 			return -EINVAL;
 
 		result = vega20_get_activity_monitor_coeff(hwmgr,
@@ -4166,6 +4168,8 @@ static int vega20_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, ui
 			activity_monitor.Fclk_PD_Data_error_coeff = input[8];
 			activity_monitor.Fclk_PD_Data_error_rate_coeff = input[9];
 			break;
+		default:
+			return -EINVAL;
 		}
 
 		result = vega20_set_activity_monitor_coeff(hwmgr,
-- 
2.43.0



