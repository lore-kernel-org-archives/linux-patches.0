Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBB773176;
	Thu, 13 Feb 2025 15:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460123; cv=none; b=XDLX66VbQWUp23oQ++eI/47PsI+e38Wi1SViQkyCwTkoaajHU5503axvXfXdNbYdYDrbfvLuKKFIPbJwJKH5ZAik4lAVAg0pgfmrb/UnseQEbAdyEVcPGEW1UiYhR+8AVtY3HBoWKA5+c9pn2QWsXUoyw7NYzk3w88ItaI7Xmxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460123; c=relaxed/simple;
	bh=uA0IQcpx3ARR2rd7E88yWVY70X9MADQ8wOBEAkXVoD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6leOfcXmhb52gBN11dY+bEVRwBseM+b9cq1EdOzd5RN1WYd434rB7WWG59t29kDaWSpAaW96ncNT1kLUjgb0HJCPifBg1NVG/nQGnSmhbbO/AOXk0RffVGpMw/kFaV37HgiOmvwUaeu+1gR3tHfvPABMCxHe5E1TVEHpbDuM/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+W+FnWq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+W+FnWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1278C4CED1;
	Thu, 13 Feb 2025 15:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460123;
	bh=uA0IQcpx3ARR2rd7E88yWVY70X9MADQ8wOBEAkXVoD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B+W+FnWqq6m3n7aZokMXPRHD4S1smSErQeXvTCsyBSV+FfCUiHkZN487P99K4y8rp
	 yxlHPRMZsv08XEKkJUcIM5ZwbFj90j1yQZbaYq5/2IkYRqU3s5kkVovM2f7vlv7iH6
	 AMAD+8yPLjoGEC67gterQh65T5PTLtzTALe2PIrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Fangzhi Zuo <Jerry.Zuo@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/273] drm/amd/display: Fix Mode Cutoff in DSC Passthrough to DP2.1 Monitor
Date: Thu, 13 Feb 2025 15:26:33 +0100
Message-ID: <20250213142408.199345888@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

[ Upstream commit e56ad45e991128bf4db160b75a1d9f647a341d8f ]

Source --> DP2.1 MST hub --> DP1.4/2.1 monitor

When change from DP1.4 to DP2.1 from monitor manual, modes higher than
4k120 are all cutoff by mode validation. Switch back to DP1.4 gets all
the modes up to 4k240 available to be enabled by dsc passthrough.

[why]
Compared to DP1.4 link from hub to monitor, DP2.1 link has larger
full_pbn value that causes overflow in the process of doing conversion
from pbn to kbps.

[how]
Change the data type accordingly to fit into the data limit during
conversion calculation.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Signed-off-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 385a5a75fdf87..5858e288b3fd6 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1578,16 +1578,16 @@ int pre_validate_dsc(struct drm_atomic_state *state,
 	return ret;
 }
 
-static unsigned int kbps_from_pbn(unsigned int pbn)
+static uint32_t kbps_from_pbn(unsigned int pbn)
 {
-	unsigned int kbps = pbn;
+	uint64_t kbps = (uint64_t)pbn;
 
 	kbps *= (1000000 / PEAK_FACTOR_X1000);
 	kbps *= 8;
 	kbps *= 54;
 	kbps /= 64;
 
-	return kbps;
+	return (uint32_t)kbps;
 }
 
 static bool is_dsc_common_config_possible(struct dc_stream_state *stream,
-- 
2.39.5



