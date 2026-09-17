Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41014F96BB;
	Thu, 17 Sep 2026 16:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661315; cv=none; b=bFsPAfgnal8mSm01HRT/Fpoclcumxe1af+5lyImd5Optp+DIg92SeKMGulNZ0wCbh5DgvcnmBgyq9a5CuidUqZzxq0871XmCdROgwgJfTY2tFhSrVVd8kpBWIk1dBQ9uwQS/rYIgBoGmQahZPYA2Ed2JlRH8COdV26FpLnmm0tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661315; c=relaxed/simple;
	bh=xV2CqzMUNYHCYJ0o5FvnlsqiVh+RdfdCmchOD1pjKgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gMqvCUhgPRzUvl9xYs1Whw8c1oCKV7sZynZyjOxYaA/pC4U0q3QRpEUr3s8Ww3M3LfrXF0D6lbY/ne/efCY5A9Hx4i6iBKRvTP+rIEIzvs7pPtXzf+716MkpvrVVpZ6JqMri3iiYfAWUJOA/WD2s4S10komQ3SvJaCVLSjxpSvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GeQdOuGp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GeQdOuGp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381B51F000FF;
	Thu, 17 Sep 2026 16:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661314;
	bh=8jqcthXwnNV9nRqxZ5sWcv2BzdtI2K8fg+ZGBrxZMHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GeQdOuGpjTHGGhro/FVhsnRcqe7Lojyx+7ba0omoLwHhnbIyF1blEgx5AWgTOv0iz
	 jkwFqGCE489v5GRYPdnC8dOG0GBUN2awdmGX5BbqcOvRzyqVN+G+m4I2fmF8uDkxsn
	 meV1fJH+UrC8VQ55HUbl0Gu5qhh1O4/x1BIOconU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ce Sun <cesun102@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0154/1250] drm/amdgpu: avoid integer overflow in VA range check
Date: Thu, 17 Sep 2026 15:59:09 +0100
Message-ID: <20260917151556.248214403@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Ce Sun <cesun102@amd.com>

[ Upstream commit cc768f4dd0bb9083c813683eeec44fc23921f771 ]

The original addition operation in 64-bit unsigned type may encounter
overflow situations. To prevent such issues and safely reject invalid
inputs, the check_add_overflow() function is used.

Signed-off-by: Ce Sun <cesun102@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
index d3f2aa8cbdbc0..81c6003b3e794 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -839,7 +839,7 @@ int amdgpu_gem_va_ioctl(struct drm_device *dev, void *data,
 	struct dma_fence_chain *timeline_chain = NULL;
 	struct dma_fence *fence;
 	struct drm_exec exec;
-	uint64_t vm_size;
+	uint64_t vm_size, tmp;
 	int r = 0;
 
 	/* Validate virtual address range against reserved regions. */
@@ -863,7 +863,7 @@ int amdgpu_gem_va_ioctl(struct drm_device *dev, void *data,
 
 	vm_size = adev->vm_manager.max_pfn * AMDGPU_GPU_PAGE_SIZE;
 	vm_size -= AMDGPU_VA_RESERVED_TOP;
-	if (args->va_address + args->map_size > vm_size) {
+	if (check_add_overflow(args->va_address, args->map_size, &tmp) || tmp > vm_size) {
 		dev_dbg(dev->dev,
 			"va_address 0x%llx is in top reserved area 0x%llx\n",
 			args->va_address + args->map_size, vm_size);
-- 
2.53.0



