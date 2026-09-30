Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D23A23ABBE;
	Wed, 30 Sep 2026 18:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794519; cv=none; b=lpx1/o+hXCJ4X+jzC/j1oUlvItJzbncmO7U46IYl2x8h5BLKejU4NYtuHXII3vugsXi7n5gkeH0A0fl+5MyadDyfw1cOhNdpgLwhjSO1JY8LhRPXMi2J6b2gMRKf4wJ1LH2LRKJN7+DhhHXREBANMv8gKseOmJeMArkZqpiE+Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794519; c=relaxed/simple;
	bh=cHGfaX0SHhJU8evsso7p56k0H72Yi0av7XDvYX1lSBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skbAPTcv4LX4AS5i6pbUUiZapyUczU7BzzpdJfbwyj+yVrYTBwDI/AnJDAJO/63PN3CKO/zndrBKn39TJjPZJif1uMiTnu6tlGMznigygX3ZU4j58it0K2sjqGhZPEmferirfTBpek1SBiW4yFH0L1erE+SVBnXr1ZeE3h+vO+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mWyH7zLo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mWyH7zLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670A51F000FF;
	Wed, 30 Sep 2026 18:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794517;
	bh=ZS1rmRNqQ3yz6RbC8vB2NoK5MwcwgL9JAibSD/mf+Rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mWyH7zLozUlucqnyPWpslwmeIxleWiZg66jrCcqCN8v4yWV00pyB6n2YoEJW1O9Tu
	 5fWxtB28HfQWuNZwGqKfOcrm0vKOtuat0rpF8uPiwkJCSh0zn71Prc07VK9YiCoEb1
	 kJr0slVGle0pmKBpxAt+5BRhfngNSEfjwxrgaHnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0240/1193] drm/amdkfd: Let driver decide buffer size at AMDKFD_IOC_GET_DMABUF_INFO ioctl
Date: Wed, 30 Sep 2026 17:15:24 +0200
Message-ID: <20260930152439.524551797@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 946264a87d0e8..0c5689eace67f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -469,7 +469,7 @@ uint32_t amdgpu_amdkfd_get_max_engine_clock_in_mhz(struct amdgpu_device *adev)
 
 int amdgpu_amdkfd_get_dmabuf_info(struct amdgpu_device *adev, int dma_buf_fd,
 				  struct amdgpu_device **dmabuf_adev,
-				  uint64_t *bo_size, void *metadata_buffer,
+				  uint64_t *bo_size, void **metadata_buffer,
 				  size_t buffer_size, uint32_t *metadata_size,
 				  uint32_t *flags, int8_t *xcp_id)
 {
@@ -504,9 +504,24 @@ int amdgpu_amdkfd_get_dmabuf_info(struct amdgpu_device *adev, int dma_buf_fd,
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
index ff2b8ace438b6..8fc55a6671841 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -237,7 +237,7 @@ uint64_t amdgpu_amdkfd_get_gpu_clock_counter(struct amdgpu_device *adev);
 uint32_t amdgpu_amdkfd_get_max_engine_clock_in_mhz(struct amdgpu_device *adev);
 int amdgpu_amdkfd_get_dmabuf_info(struct amdgpu_device *adev, int dma_buf_fd,
 				  struct amdgpu_device **dmabuf_adev,
-				  uint64_t *bo_size, void *metadata_buffer,
+				  uint64_t *bo_size, void **metadata_buffer,
 				  size_t buffer_size, uint32_t *metadata_size,
 				  uint32_t *flags, int8_t *xcp_id);
 uint8_t amdgpu_amdkfd_get_xgmi_hops_count(struct amdgpu_device *dst,
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 2e4a3f72b88a0..c5d77b1080a34 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1547,16 +1547,10 @@ static int kfd_ioctl_get_dmabuf_info(struct file *filep,
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
@@ -1568,7 +1562,7 @@ static int kfd_ioctl_get_dmabuf_info(struct file *filep,
 	args->flags = flags;
 
 	/* Copy metadata buffer to user mode */
-	if (metadata_buffer) {
+	if (metadata_buffer && args->metadata_ptr) {
 		r = copy_to_user((void __user *)args->metadata_ptr,
 				 metadata_buffer, args->metadata_size);
 		if (r != 0)
-- 
2.53.0



