Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A03145B0E;
	Thu, 11 Apr 2024 10:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830257; cv=none; b=qEL7GAwNhGIZCgnzgXcuXsrGDYHSPn5cmIk1FROGQOiJRgqFSz3IZZqBDwTLvmcmtKw+4cvZniJcsd5drMh6MMuv1WqVt7e7NpWrjGa8RhqMJP1sobUWtSoMrBVjCOZfdzuaTQ9fzWIrqxS2E4XuKGxUBei9N9J8zRaD5S5L6fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830257; c=relaxed/simple;
	bh=z36qr+DRZZUEyhnT88PvzXUkxYJ6CNq1Wv/dxlGE0VY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UPEUPlTCCU3t7ioB1WffAIwdCpQcmmm0yG2T7UcS2sYKyiG7LTHqIprUxpYFS9LgBuYDQOkO1h+c1P3mR8aqR30vOItbxbagPn72O6QXr3iQLlgRZwvEKvbbfB4MDW6S8jx3RdjjiiFjVLQ6n2pomOdZjzMaOhGZ44K+p13PEQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZbuusxIk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZbuusxIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5AFC433C7;
	Thu, 11 Apr 2024 10:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830257;
	bh=z36qr+DRZZUEyhnT88PvzXUkxYJ6CNq1Wv/dxlGE0VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZbuusxIkTS3j6nTAKDSPorbVlta39muX561UF75CGebaLjgN5sN4FbroPQCPMwl8I
	 SlheJM3OAMtTEHS/2Lj8Bdifmm8bq7HAUQ+y/XNHlRg0ddcOfCw5CRcizZBXHm8YZb
	 KyIloVuxu0z7vb108HNb/NyXhAVeqOc4nHQRVNOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 087/143] drm/amd/amdgpu: Fix potential ioremap() memory leaks in amdgpu_device_init()
Date: Thu, 11 Apr 2024 11:55:55 +0200
Message-ID: <20240411095423.528781851@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit eb4f139888f636614dab3bcce97ff61cefc4b3a7 ]

This ensures that the memory mapped by ioremap for adev->rmmio, is
properly handled in amdgpu_device_init(). If the function exits early
due to an error, the memory is unmapped. If the function completes
successfully, the memory remains mapped.

Reported by smatch:
drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:4337 amdgpu_device_init() warn: 'adev->rmmio' from ioremap() not released on lines: 4035,4045,4051,4058,4068,4337

Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index d0afb9ba3789c..1eff446321bd6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4025,8 +4025,10 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 	 * early on during init and before calling to RREG32.
 	 */
 	adev->reset_domain = amdgpu_reset_create_reset_domain(SINGLE_DEVICE, "amdgpu-reset-dev");
-	if (!adev->reset_domain)
-		return -ENOMEM;
+	if (!adev->reset_domain) {
+		r = -ENOMEM;
+		goto unmap_memory;
+	}
 
 	/* detect hw virtualization here */
 	amdgpu_detect_virtualization(adev);
@@ -4036,20 +4038,20 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 	r = amdgpu_device_get_job_timeout_settings(adev);
 	if (r) {
 		dev_err(adev->dev, "invalid lockup_timeout parameter syntax\n");
-		return r;
+		goto unmap_memory;
 	}
 
 	/* early init functions */
 	r = amdgpu_device_ip_early_init(adev);
 	if (r)
-		return r;
+		goto unmap_memory;
 
 	amdgpu_device_set_mcbp(adev);
 
 	/* Get rid of things like offb */
 	r = drm_aperture_remove_conflicting_pci_framebuffers(adev->pdev, &amdgpu_kms_driver);
 	if (r)
-		return r;
+		goto unmap_memory;
 
 	/* Enable TMZ based on IP_VERSION */
 	amdgpu_gmc_tmz_set(adev);
@@ -4059,7 +4061,7 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 	if (adev->gmc.xgmi.supported) {
 		r = adev->gfxhub.funcs->get_xgmi_info(adev);
 		if (r)
-			return r;
+			goto unmap_memory;
 	}
 
 	/* enable PCIE atomic ops */
@@ -4328,6 +4330,8 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 failed:
 	amdgpu_vf_error_trans_all(adev);
 
+unmap_memory:
+	iounmap(adev->rmmio);
 	return r;
 }
 
-- 
2.43.0



