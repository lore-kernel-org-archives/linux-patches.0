Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0C92D97B8;
	Tue, 16 Dec 2025 11:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885015; cv=none; b=UIMrOQ0ImgPCmevx2zhPSXdzZmpUL1fM8TOnugwkVZEsbealA/r7Mw0NnKuxc7tmsiykCvHQ7r6YfJ8bb3A6uXjNyyhIoBcKpK4m4JqoYm3Fs6S67GP9mnK2NFZvpBHkmdEPPu2zRg+51oXlWIjJJvmgL+KOCMCVuZJNDlDIw+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885015; c=relaxed/simple;
	bh=Yf2QO+B26TOUMwUkrmy7G715BN0Q0e03HqWVshnRBhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQwOlLEAHctm3JyHtR+4Rd4Lh2NF67+fspw1Ys91tFLOsM46ukeWOuYD6IUcHcAGYMK0dda8xUuCPgmfpFyKpQx+7f0GIe621uZv29N98VBCcUZN6as2+JCz1o56SEPaVtAEtbMCb0HOCLJ+kzWxMHCgkBNGjhkBC4ze7GRZb64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/CaN+Tn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/CaN+Tn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EBE4C4CEF1;
	Tue, 16 Dec 2025 11:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885015;
	bh=Yf2QO+B26TOUMwUkrmy7G715BN0Q0e03HqWVshnRBhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/CaN+TnKw7ZLA6+JU4TnkIMTBKiw+Em4gIEJiUm3cJR8e7JSAPPJid4ksesw2aJC
	 31TBdlTJes6Ka5nnV3sI+XyLOMINr3V/M6nTSZ8rZXVFYvHfGJzKQWm0P9k17HxH+K
	 tbRNWJ50WrSHgsbBhXG0wGrxaMB7DjLji7dIyC6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 013/507] accel/ivpu: Fix page fault in ivpu_bo_unbind_all_bos_from_context()
Date: Tue, 16 Dec 2025 12:07:34 +0100
Message-ID: <20251216111346.015437518@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

[ Upstream commit 8b694b405a84696f1d964f6da7cf9721e68c4714 ]

Don't add BO to the vdev->bo_list in ivpu_gem_create_object().
When failure happens inside drm_gem_shmem_create(), the BO is not
fully created and ivpu_gem_bo_free() callback will not be called
causing a deleted BO to be left on the list.

Fixes: 8d88e4cdce4f ("accel/ivpu: Use GEM shmem helper for all buffers")
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Signed-off-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Reviewed-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://lore.kernel.org/r/20250925145114.1446283-1-maciej.falkowski@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_gem.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_gem.c b/drivers/accel/ivpu/ivpu_gem.c
index dc6d0d15cda9c..171e809575ad6 100644
--- a/drivers/accel/ivpu/ivpu_gem.c
+++ b/drivers/accel/ivpu/ivpu_gem.c
@@ -193,7 +193,6 @@ void ivpu_bo_unbind_all_bos_from_context(struct ivpu_device *vdev, struct ivpu_m
 
 struct drm_gem_object *ivpu_gem_create_object(struct drm_device *dev, size_t size)
 {
-	struct ivpu_device *vdev = to_ivpu_device(dev);
 	struct ivpu_bo *bo;
 
 	if (size == 0 || !PAGE_ALIGNED(size))
@@ -208,20 +207,17 @@ struct drm_gem_object *ivpu_gem_create_object(struct drm_device *dev, size_t siz
 
 	INIT_LIST_HEAD(&bo->bo_list_node);
 
-	mutex_lock(&vdev->bo_list_lock);
-	list_add_tail(&bo->bo_list_node, &vdev->bo_list);
-	mutex_unlock(&vdev->bo_list_lock);
-
-	ivpu_dbg(vdev, BO, " alloc: bo %8p size %9zu\n", bo, size);
 	return &bo->base.base;
 }
 
 struct drm_gem_object *ivpu_gem_prime_import(struct drm_device *dev,
 					     struct dma_buf *dma_buf)
 {
+	struct ivpu_device *vdev = to_ivpu_device(dev);
 	struct device *attach_dev = dev->dev;
 	struct dma_buf_attachment *attach;
 	struct drm_gem_object *obj;
+	struct ivpu_bo *bo;
 	int ret;
 
 	attach = dma_buf_attach(dma_buf, attach_dev);
@@ -239,6 +235,14 @@ struct drm_gem_object *ivpu_gem_prime_import(struct drm_device *dev,
 	obj->import_attach = attach;
 	obj->resv = dma_buf->resv;
 
+	bo = to_ivpu_bo(obj);
+
+	mutex_lock(&vdev->bo_list_lock);
+	list_add_tail(&bo->bo_list_node, &vdev->bo_list);
+	mutex_unlock(&vdev->bo_list_lock);
+
+	ivpu_dbg(vdev, BO, "import: bo %8p size %9zu\n", bo, ivpu_bo_size(bo));
+
 	return obj;
 
 fail_detach:
@@ -269,6 +273,12 @@ static struct ivpu_bo *ivpu_bo_alloc(struct ivpu_device *vdev, u64 size, u32 fla
 	bo->base.map_wc = flags & DRM_IVPU_BO_WC;
 	bo->flags = flags;
 
+	mutex_lock(&vdev->bo_list_lock);
+	list_add_tail(&bo->bo_list_node, &vdev->bo_list);
+	mutex_unlock(&vdev->bo_list_lock);
+
+	ivpu_dbg(vdev, BO, " alloc: bo %8p size %9llu\n", bo, size);
+
 	return bo;
 }
 
-- 
2.51.0



