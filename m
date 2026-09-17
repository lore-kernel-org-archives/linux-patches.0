Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E29453B33F;
	Thu, 17 Sep 2026 17:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664742; cv=none; b=RmYbjJd3DwM9+8Dx6qMZOAwlB9ouXJb6nkdxO4Wjeak0MI0BHjZN6Hu6Du2fX5raNno7bnyPi5O0snqy+TU0/aCTGJeqwGSwDoQ2Ls82ZFK0HgaIVB31N9LIPIr+OzEmzxTMus+fn35I/oiAAtQhS50/bswwyaYq+8/8dgBvnB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664742; c=relaxed/simple;
	bh=ONAk96bblCTZ9qJT3GJwYnwgCcvY/ARh5/bsWuNuDDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TvCTIlGhADg+9tKVHXKdFCvkqXYn6y+UZfOp12PBP2VanwKBgKhePUMy2zF4CPgk5iLRZaBCj6l3mfn3p7OcWKqbYlvmjArk8nUYIGjfwLfPfq4MUpslZ/Ls8nUf0hn8YKmFz/maqIctcWpTAnOa12GkmSDitk8EqdFL4U5DFZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZjqWF//t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZjqWF//t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619591F000FF;
	Thu, 17 Sep 2026 17:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664741;
	bh=ygdlnfUI7+C/EKphSmKy+7jVUF3kqUp3V8WgMl8QXr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZjqWF//t3C+Acv9jVpXbFMP27pe2+yCVYvkt788neco0lqPbrWRI/bzyDPaH9Aqlp
	 mVf89FeiA77gUoPGboLjXZ7ULlFpLPf5IpHXYeSBRL0R6zk68FTgv1yaoSfUKuF4IL
	 mHtlIaWA9RqPN7ZoWhKOMEQiUoGtaP53E/3vPiSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0434/1250] drm/amdkfd: Let driver decide buffer size at AMDKFD_IOC_GET_DMABUF_INFO ioctl
Date: Thu, 17 Sep 2026 16:03:49 +0100
Message-ID: <20260917151603.778917451@linuxfoundation.org>
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

From: Xiaogang Chen <xiaogang.chen@amd.com>

[ Upstream commit 8242a8d9d7194d5ef8a8b38a5621ca0966a3ec15 ]

amdkfd driver needs allocate buffer to return bo metadata to user space. The
buffer size is controlled by user currently. It is a potential security issue
that hostile value (e.g. 2 GiB) lets any render-group user trigger order-MAX
allocation/OOM in kernel context.

This patch first finds bo metadata size. If the size is smaller than user
provided value drive can safely allocate buffer in kernel space and copy to
user space buffer. If not, driver will let user know, not allocate and copy.
User will redo with new buffer in user space.

This patch lets driver decide buffer allocation size to avoid potential hostile
size from user space.

Signed-off-by: Xiaogang Chen <xiaogang.chen@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f54ce9e8cbd3abe0eda3a285f54dc4f572fe589a)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c | 23 ++++++++++++++++++----
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c   | 10 ++--------
 3 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
index 1ec26be82f30e..5e8d0d6b55ab6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -528,7 +528,7 @@ uint32_t amdgpu_amdkfd_get_max_engine_clock_in_mhz(struct amdgpu_device *adev)
 
 int amdgpu_amdkfd_get_dmabuf_info(struct amdgpu_device *adev, int dma_buf_fd,
 				  struct amdgpu_device **dmabuf_adev,
-				  uint64_t *bo_size, void *metadata_buffer,
+				  uint64_t *bo_size, void **metadata_buffer,
 				  size_t buffer_size, uint32_t *metadata_size,
 				  uint32_t *flags, int8_t *xcp_id)
 {
@@ -563,9 +563,24 @@ int amdgpu_amdkfd_get_dmabuf_info(struct amdgpu_device *adev, int dma_buf_fd,
 		*dmabuf_adev = adev;
 	if (bo_size)
 		*bo_size = amdgpu_bo_size(bo);
-	if (metadata_buffer)
-		r = amdgpu_bo_get_metadata(bo, metadata_buffer, buffer_size,
-					   metadata_size, &metadata_flags);
+	if (metadata_buffer) {
+		/* first get metadata_size by buffer = NULL */
+		r = amdgpu_bo_get_metadata(bo, NULL, 0,
+					   metadata_size, NULL);
+
+		/* user buf_size is bigger than bo metadata_size
+		 * allocate a buf at kernel space and copy */
+		if (*metadata_size <= buffer_size) {
+			*metadata_buffer = kzalloc(*metadata_size, GFP_KERNEL);
+
+			if (!*metadata_buffer)
+				return -ENOMEM;
+
+			r = amdgpu_bo_get_metadata(bo, *metadata_buffer, *metadata_size,
+						   NULL, &metadata_flags);
+		} else
+			r = -EINVAL;
+	}
 	if (flags) {
 		*flags = (bo->preferred_domains & AMDGPU_GEM_DOMAIN_VRAM) ?
 				KFD_IOC_ALLOC_MEM_FLAGS_VRAM
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index 9e120c934cc17..c59b5d9cd36b6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -255,7 +255,7 @@ uint64_t amdgpu_amdkfd_get_gpu_clock_counter(struct amdgpu_device *adev);
 uint32_t amdgpu_amdkfd_get_max_engine_clock_in_mhz(struct amdgpu_device *adev);
 int amdgpu_amdkfd_get_dmabuf_info(struct amdgpu_device *adev, int dma_buf_fd,
 				  struct amdgpu_device **dmabuf_adev,
-				  uint64_t *bo_size, void *metadata_buffer,
+				  uint64_t *bo_size, void **metadata_buffer,
 				  size_t buffer_size, uint32_t *metadata_size,
 				  uint32_t *flags, int8_t *xcp_id);
 int amdgpu_amdkfd_get_pcie_bandwidth_mbytes(struct amdgpu_device *adev, bool is_min);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 5c0e93488afaf..04c2d412fa7da 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1525,16 +1525,10 @@ static int kfd_ioctl_get_dmabuf_info(struct file *filep,
 	if (!dev)
 		return -EINVAL;
 
-	if (args->metadata_ptr) {
-		metadata_buffer = kzalloc(args->metadata_size, GFP_KERNEL);
-		if (!metadata_buffer)
-			return -ENOMEM;
-	}
-
 	/* Get dmabuf info from KGD */
 	r = amdgpu_amdkfd_get_dmabuf_info(dev->adev, args->dmabuf_fd,
 					  &dmabuf_adev, &args->size,
-					  metadata_buffer, args->metadata_size,
+					  &metadata_buffer, args->metadata_size,
 					  &args->metadata_size, &flags, &xcp_id);
 	if (r)
 		goto exit;
@@ -1546,7 +1540,7 @@ static int kfd_ioctl_get_dmabuf_info(struct file *filep,
 	args->flags = flags;
 
 	/* Copy metadata buffer to user mode */
-	if (metadata_buffer) {
+	if (metadata_buffer && args->metadata_ptr) {
 		r = copy_to_user((void __user *)args->metadata_ptr,
 				 metadata_buffer, args->metadata_size);
 		if (r != 0)
-- 
2.53.0



