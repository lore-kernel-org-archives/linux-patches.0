Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC24200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB1EC433C7;
	Fri, 21 Jul 2023 19:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966015;
	bh=p8WikBRdLNSavubgV3UB/u+/jf7y7krXhptXqG6D9ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3K0wnOaD8dap7lfAVXS2XVgaPxXLRZJXZrEkGshIvEsnjCek0Kk+xg6Hz/k80Vc1
	 W0HdTf7toboTuNVFzO3A8KzLiIcJxGfrrYw9p01rVBI3qE9rBVVe2OgtqhI47szcC2
	 Kuo04+tFZzWj91ZYED4HPanWka2h7n1ssquJlL/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 167/532] amdgpu: validate offset_in_bo of drm_amdgpu_gem_va
Date: Fri, 21 Jul 2023 18:01:11 +0200
Message-ID: <20230721160623.457440947@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index 8da5cc8fcc6c0..86914bd3e09e1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2334,14 +2334,14 @@ int amdgpu_vm_bo_map(struct amdgpu_device *adev,
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
 
@@ -2400,14 +2400,14 @@ int amdgpu_vm_bo_replace_map(struct amdgpu_device *adev,
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
2.39.2



