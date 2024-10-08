Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEEE1DE8BA;
	Tue,  8 Oct 2024 12:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390242; cv=none; b=bTLS28ynnsYxp8Dq3DahMDQAEuqx20fIcRIyo+UNEDDqCq3hOuhFzOsEH6NGaf2VA5eVT9EwoKNhuSd+5gI+F2jd+kRWL8XZr59rjeOLO9BdU2viBxShZONpdJM4L2m2hcM6MqK8vKV2rCd6bN8ZIudQdG7WXEuWbpV4nQ3LY2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390242; c=relaxed/simple;
	bh=jadj8la7FUeESH9qdo8bFm2L1jtl+0X6hXsuK/xHIEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VgvzJOS/no9ZVHH4UK7oSVnP1/pSWAgVUpwy2/djTjGo94l2ZYjxYH2NEc/ZJ0LOwsXq9ukYkmlqAJ2GeyAzWJUFTSMeqfM9GmLMVo7yzJvUoz3KCSiIwSKo5kzlTlYXUwxfohNPArWNe7wxof6yo7oW7EUOnqqk+5xNu8YgE1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJDVaacu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJDVaacu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99CDC4CEC7;
	Tue,  8 Oct 2024 12:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390242;
	bh=jadj8la7FUeESH9qdo8bFm2L1jtl+0X6hXsuK/xHIEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJDVaacud5/qbjR40f3N7VTeDRBKQjg/IAK8QcRfmtn4XX7+/b68LtceOAO0IxrE9
	 PIsDM5UYpkn3Zb9TiC3wIwQAWrXF6B46oeS6gQaFFZT3FAlcJvWZfIoG8AK464RiGV
	 dodu3/EH21QA1uUX49uaOtvtK1JXSgTXLbN8/738=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 233/482] drm/amdgpu/gfx11: enter safe mode before touching CP_INT_CNTL
Date: Tue,  8 Oct 2024 14:04:56 +0200
Message-ID: <20241008115657.470360189@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit b5be054c585110b2c5c1b180136800e8c41c7bb4 ]

Need to enter safe mode before touching GC MMIO.

Acked-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index 4ba8eb45ac174..0bcdcb2101577 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -4497,6 +4497,8 @@ static int gfx_v11_0_soft_reset(void *handle)
 	int r, i, j, k;
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
+	gfx_v11_0_set_safe_mode(adev, 0);
+
 	tmp = RREG32_SOC15(GC, 0, regCP_INT_CNTL);
 	tmp = REG_SET_FIELD(tmp, CP_INT_CNTL, CMP_BUSY_INT_ENABLE, 0);
 	tmp = REG_SET_FIELD(tmp, CP_INT_CNTL, CNTX_BUSY_INT_ENABLE, 0);
@@ -4504,8 +4506,6 @@ static int gfx_v11_0_soft_reset(void *handle)
 	tmp = REG_SET_FIELD(tmp, CP_INT_CNTL, GFX_IDLE_INT_ENABLE, 0);
 	WREG32_SOC15(GC, 0, regCP_INT_CNTL, tmp);
 
-	gfx_v11_0_set_safe_mode(adev, 0);
-
 	mutex_lock(&adev->srbm_mutex);
 	for (i = 0; i < adev->gfx.mec.num_mec; ++i) {
 		for (j = 0; j < adev->gfx.mec.num_queue_per_pipe; j++) {
-- 
2.43.0



