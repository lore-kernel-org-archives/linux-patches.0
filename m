Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319A014A0B5;
	Tue, 23 Jan 2024 01:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972102; cv=none; b=OT7wI+d3tIZUdvP4XfoOdqN9Jo67IhZhaFxfzk76lS28S2uNzbUT6zpxjzFgeRS7NS1tleiIPg7t1AT0u2PI7qW09DCy5Pj3PuBIsk22gpkMRsph0PWXNZU63WXBJxpe9jcUstWwlbayAd8PxMhNO9aRwe3DbGeBWYf6AxXv7BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972102; c=relaxed/simple;
	bh=x2F03w3h0EO7EnuiM24/ncnyVO5+UpoMkDTkoBU1rdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=POBfa11ZZP+ggvwuL/asYKmM4eBm0S1auF6Q2xoV08tzoqrOvyrZM52N/O1HinguBS6sQnrRsYVtM+8YGxQV+9cK6I6OqVTe6SK4x14nwUE8eagCQ6p3tZuhsZ4cP8WBdcBiCS7s3Muvmh86eQulS4K15687XBaxF61S9Y6TM1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=veL8+8jA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="veL8+8jA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17798C43399;
	Tue, 23 Jan 2024 01:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972101;
	bh=x2F03w3h0EO7EnuiM24/ncnyVO5+UpoMkDTkoBU1rdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=veL8+8jANauTpw4w+0/4mvEWCkVIs7w9WWOfVhU7hiAqCrJJQOTOJg6srZh3tBJ9r
	 tiy+4ZgcwkE2MNPTfJumZCupsu+34VpVQQifv1Db/chI120FXpjkwxb6xqewIHMqos
	 VAIvp7h4ClRGhU8YwM3yMTfVHVHBf2LJVlLH23eQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/374] drm/amdgpu: Add NULL checks for function pointers
Date: Mon, 22 Jan 2024 15:54:37 -0800
Message-ID: <20240122235745.362171641@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 81577503efb49f4ad76af22f9941d72900ef4aab ]

Check if function is implemented before making the call.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/soc15.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index 529bb6c6ac6f..e8c0e77e1b01 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1615,9 +1615,11 @@ static void soc15_common_get_clockgating_state(void *handle, u32 *flags)
 	if (amdgpu_sriov_vf(adev))
 		*flags = 0;
 
-	adev->nbio.funcs->get_clockgating_state(adev, flags);
+	if (adev->nbio.funcs && adev->nbio.funcs->get_clockgating_state)
+		adev->nbio.funcs->get_clockgating_state(adev, flags);
 
-	adev->hdp.funcs->get_clock_gating_state(adev, flags);
+	if (adev->hdp.funcs && adev->hdp.funcs->get_clock_gating_state)
+		adev->hdp.funcs->get_clock_gating_state(adev, flags);
 
 	if (adev->asic_type != CHIP_ALDEBARAN) {
 
@@ -1633,9 +1635,11 @@ static void soc15_common_get_clockgating_state(void *handle, u32 *flags)
 	}
 
 	/* AMD_CG_SUPPORT_ROM_MGCG */
-	adev->smuio.funcs->get_clock_gating_state(adev, flags);
+	if (adev->smuio.funcs && adev->smuio.funcs->get_clock_gating_state)
+		adev->smuio.funcs->get_clock_gating_state(adev, flags);
 
-	adev->df.funcs->get_clockgating_state(adev, flags);
+	if (adev->df.funcs && adev->df.funcs->get_clockgating_state)
+		adev->df.funcs->get_clockgating_state(adev, flags);
 }
 
 static int soc15_common_set_powergating_state(void *handle,
-- 
2.43.0



