Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E1C2FB08C;
	Wed, 25 Feb 2026 06:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002755; cv=none; b=TAsrmCaNBRwPvcC/bDfmsPvG1qlDsiE14aIo+lxsxyulzavPRro2AYTbp+1D7dfSX52gOLhD/UvzzTzJvOqvFQhOMfIYiIeOfbPObiY1wIk2AiOeu/iv1itDJFV/a3o/MOYh0aOLBftjvIrtUPiN+QghFoWmrQd9R5i1lUoOFCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002755; c=relaxed/simple;
	bh=WKwKvwfs97ltYn/0QGajo0MMLcEJODkldhj2/tz4F2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGX+PKTkKbjSPyLKYXIKmjwu89kQuQnPfQA65QHx+SOtDhxODfGyRpnrNSh6031AL0OaPoYl7LxYM3Qh4mSPHETxspUbOnH5KSJPF41RK2SMQRf3w4bV8IVTvECeoma4WPkkomqUGA1SlKXeADTKnPIIyBsiKFKnx0HOmIZW1zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WsHnvpu9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WsHnvpu9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFA8C116D0;
	Wed, 25 Feb 2026 06:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002755;
	bh=WKwKvwfs97ltYn/0QGajo0MMLcEJODkldhj2/tz4F2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WsHnvpu9G4ZzhWn464/38kGl9mDR+SqxgxgA393aCe/hbbvUg4KzTRohbfdZyDLMB
	 Wbr2lX+EuaIDS5yIJ2dzYrx/noCghqcAQZPhzyMrCtS+2bA0Qsro8Q8WxPec/WZbW4
	 kPXp9uMl/JbZv2iO1XQ1bwB+LNDT/QlJax9OLbOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	"Jesse.Zhang" <Jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 582/641] drm/amdgpu/sdma5: enable queue resets unconditionally
Date: Tue, 24 Feb 2026 17:25:08 -0800
Message-ID: <20260225012402.612978845@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 46a2cb7d24f21132e970cab52359210c3f5ea3c6 ]

There is no firmware version dependency.

Fixes: 59fd50b8663b ("drm/amdgpu: Add sysfs interface for sdma reset mask")
Cc: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Jesse.Zhang <Jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
index 8ddc4df06a1fd..45e2933214a80 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
@@ -1424,18 +1424,9 @@ static int sdma_v5_0_sw_init(struct amdgpu_ip_block *ip_block)
 
 	adev->sdma.supported_reset =
 		amdgpu_get_soft_full_reset_mask(&adev->sdma.instance[0].ring);
-	switch (amdgpu_ip_version(adev, SDMA0_HWIP, 0)) {
-	case IP_VERSION(5, 0, 0):
-	case IP_VERSION(5, 0, 2):
-	case IP_VERSION(5, 0, 5):
-		if ((adev->sdma.instance[0].fw_version >= 35) &&
-		    !amdgpu_sriov_vf(adev) &&
-		    !adev->debug_disable_gpu_ring_reset)
-			adev->sdma.supported_reset |= AMDGPU_RESET_TYPE_PER_QUEUE;
-		break;
-	default:
-		break;
-	}
+	if (!amdgpu_sriov_vf(adev) &&
+	    !adev->debug_disable_gpu_ring_reset)
+		adev->sdma.supported_reset |= AMDGPU_RESET_TYPE_PER_QUEUE;
 
 	/* Allocate memory for SDMA IP Dump buffer */
 	ptr = kcalloc(adev->sdma.num_instances * reg_count, sizeof(uint32_t), GFP_KERNEL);
-- 
2.51.0



