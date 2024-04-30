Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B66612D748;
	Tue, 30 Apr 2024 10:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473863; cv=none; b=k+nOo/oRzI1+v/pMPns8ZPDQl9SFB8j305LINxyRFDF23CzZePHd7S5cJ5IgLUjfUGqO0pwnL03LgR2Hl9NJ75PXnpB4iDq5oMoeKmfHsTfXscv3rS72wj7tASEFLlwhjQTb2cIPHzFFZRxwOXRTOMnBxku1doFvhEhBPHXJWok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473863; c=relaxed/simple;
	bh=sQfc4pp9RvBIdgJBezKuKHfxU00Sq//tWdPd/6hEovo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e4aTXl2xRSaG604QqFymIDMCAgVGlT3byNxxJMtq/ZJVTcvNwHJzj8/PCn0snelOUqlYBbI+j5xC+xpYHnpk5Ji9W43GGNJ0dYNmxId1QNQKDsldYuPYWlaANI3dFk+GY9yQeoCunhSorbYdmnj2OK8OWnHi5p2CUEJvde8r7P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VKZxzcgx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VKZxzcgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B778C4AF14;
	Tue, 30 Apr 2024 10:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473862;
	bh=sQfc4pp9RvBIdgJBezKuKHfxU00Sq//tWdPd/6hEovo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VKZxzcgx4FpvjJJYNTeLFrOoNRxvSX3hgN4xz7x+bd9yyC3ckUTRvgvCDzDtIVwso
	 xaPb6B+D1kVUEJw+MG9FyJqaVLmNO0v2lH7TmyMhK1lyEh6p8foz4Mm7/39LzFoxq1
	 HmB8p5IkywFlpnok9SWP4PXB3Gy60SbFSkbaBe3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 56/77] amdgpu: validate offset_in_bo of drm_amdgpu_gem_va
Date: Tue, 30 Apr 2024 12:39:35 +0200
Message-ID: <20240430103042.792237890@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chia-I Wu <olvaffe@gmail.com>

[ Upstream commit 9f0bcf49e9895cb005d78b33a5eebfa11711b425 ]

This is motivated by OOB access in amdgpu_vm_update_range when
offset_in_bo+map_size overflows.

v2: keep the validations in amdgpu_vm_bo_map
v3: add the validations to amdgpu_vm_bo_map/amdgpu_vm_bo_replace_map
    rather than to amdgpu_gem_va_ioctl

Fixes: 9f7eb5367d00 ("drm/amdgpu: actually use the VM map parameters")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 6fef2d4c00b5 ("drm/amdgpu: validate the parameters of bo mapping operations more clearly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index acf03c716aca5..aa972448284dd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2076,14 +2076,14 @@ int amdgpu_vm_bo_map(struct amdgpu_device *adev,
 	uint64_t eaddr;
 
 	/* validate the parameters */
-	if (saddr & ~PAGE_MASK || offset & ~PAGE_MASK ||
-	    size == 0 || size & ~PAGE_MASK)
+	if (saddr & ~PAGE_MASK || offset & ~PAGE_MASK || size & ~PAGE_MASK)
+		return -EINVAL;
+	if (saddr + size <= saddr || offset + size <= offset)
 		return -EINVAL;
 
 	/* make sure object fit at this offset */
 	eaddr = saddr + size - 1;
-	if (saddr >= eaddr ||
-	    (bo && offset + size > amdgpu_bo_size(bo)) ||
+	if ((bo && offset + size > amdgpu_bo_size(bo)) ||
 	    (eaddr >= adev->vm_manager.max_pfn << AMDGPU_GPU_PAGE_SHIFT))
 		return -EINVAL;
 
@@ -2142,14 +2142,14 @@ int amdgpu_vm_bo_replace_map(struct amdgpu_device *adev,
 	int r;
 
 	/* validate the parameters */
-	if (saddr & ~PAGE_MASK || offset & ~PAGE_MASK ||
-	    size == 0 || size & ~PAGE_MASK)
+	if (saddr & ~PAGE_MASK || offset & ~PAGE_MASK || size & ~PAGE_MASK)
+		return -EINVAL;
+	if (saddr + size <= saddr || offset + size <= offset)
 		return -EINVAL;
 
 	/* make sure object fit at this offset */
 	eaddr = saddr + size - 1;
-	if (saddr >= eaddr ||
-	    (bo && offset + size > amdgpu_bo_size(bo)) ||
+	if ((bo && offset + size > amdgpu_bo_size(bo)) ||
 	    (eaddr >= adev->vm_manager.max_pfn << AMDGPU_GPU_PAGE_SHIFT))
 		return -EINVAL;
 
-- 
2.43.0



