Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A2014D431;
	Tue, 10 Sep 2024 10:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963444; cv=none; b=SSXrrs7YlZz86jdLzNd5KsKA559gjXZrpTDegFl268tUout9MPMpvH+Tg7u02YYbQm7brJqTWp2yzOS5R5ZxVabmnm5YjdsE5jEBIgpDnBLu8VrrcUGA/ID85CjH1JVVep/+BgvNgiurrSrN7HQ3xeWX5bdZvRDEidv7l9G3f/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963444; c=relaxed/simple;
	bh=HeH9wSOhi4JCfb6IeBqFhwPA9szKaURCJeQn9dg0Bs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQST48JDiqngTZGtyYi+k1VRzLRcvPFoce1MmhBpcLuVJELcIbSsYx2xB/RVVhHdZ6XoTz+hMvSnVfznYZQfPOUuuZ4tCCyVLEtTPOv4qjSLdY478nGT/B05gPqIqqv2fDoOaaGBbnZ0fe0DKzoUx1Uw3H9qAir8F8d8eDYZagU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uSHnAVcq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uSHnAVcq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D41AC4CECF;
	Tue, 10 Sep 2024 10:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963444;
	bh=HeH9wSOhi4JCfb6IeBqFhwPA9szKaURCJeQn9dg0Bs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uSHnAVcqiYwIo7IqSdt0QsvERlXhU6++iIEThPHv6XABrZvhOjFeCo2vJ77f089JM
	 grmzNj2MqXac7/W8unDnS4LKhiuNX2HyZt7zcuwpGzlHud6YKJ0fsNYuQ/GfNLtPgm
	 SuhTbZyr9hcCQXcvyb9pKIGasxEAxp1MMI7+rSgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 032/214] drm/amdgpu/pm: Check input value for CUSTOM profile mode setting on legacy SOCs
Date: Tue, 10 Sep 2024 11:30:54 +0200
Message-ID: <20240910092600.089514283@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9c7c3c06327d..2d1f37aefdbd 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
@@ -5597,7 +5597,7 @@ static int smu7_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, uint
 	mode = input[size];
 	switch (mode) {
 	case PP_SMC_POWER_PROFILE_CUSTOM:
-		if (size < 8 && size != 0)
+		if (size != 8 && size != 0)
 			return -EINVAL;
 		/* If only CUSTOM is passed in, use the saved values. Check
 		 * that we actually have a CUSTOM profile by ensuring that
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
index b000a213a033..b55a68ce7238 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
@@ -4109,9 +4109,11 @@ static int vega20_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, ui
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
@@ -4173,6 +4175,8 @@ static int vega20_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, ui
 			activity_monitor.Fclk_PD_Data_error_coeff = input[8];
 			activity_monitor.Fclk_PD_Data_error_rate_coeff = input[9];
 			break;
+		default:
+			return -EINVAL;
 		}
 
 		result = vega20_set_activity_monitor_coeff(hwmgr,
-- 
2.43.0



