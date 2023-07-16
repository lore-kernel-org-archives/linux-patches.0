Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECBA8F5D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9A9C433C8;
	Sun, 16 Jul 2023 20:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540110;
	bh=ciRjg21Q5mjTKqavzrLIz8miY8zntDsOuzxe/7xcat4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mV2pnKOqwkLXqtmpyZqkYWVYgJCBMnvlYy1KFqw1iyPJ3kS+dc/hszFKNpWKW5EIi
	 0QgK/QsLYCClpjMtHMGr9NHnfV9k+d4QHu+tvagYlbj8ZUED/LKWb3MMjx3NuW8V7G
	 S54J9tjKIMHl8pNIjLhJn6HYbMtfNdwMTDli3cZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 246/591] amdgpu: validate offset_in_bo of drm_amdgpu_gem_va
Date: Sun, 16 Jul 2023 21:46:25 +0200
Message-ID: <20230716194930.235147443@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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
index 5a8a4cda7e987..58fe7279599f0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -1427,14 +1427,14 @@ int amdgpu_vm_bo_map(struct amdgpu_device *adev,
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
 
@@ -1493,14 +1493,14 @@ int amdgpu_vm_bo_replace_map(struct amdgpu_device *adev,
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



