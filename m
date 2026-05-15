Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20B83F9270;
	Fri, 15 May 2026 16:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862699; cv=none; b=lSLYpz8O42z9zaPs64IfQi96aR25oJ1t+CUuteV3Idy24wYy8U4BBodXQfuEc6TTci8gTD9+VbPYt7gQQIokl1rd24R1SQ4IHJvNNK8zUvkUgQLJ9RwKr5KsGOI/j+6TFvW4AzLGHUmqzBl3cpfj9r3/u8Pt0jQHqY0Ygim1bjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862699; c=relaxed/simple;
	bh=02+SIdtzs+wADiMShP1u0jIRPggpWSAyTTNdZ8c6cy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0MeIQVPaISmJQf7p1uWivY0X/uKRJgtop0JMKbVqIJvLWeglmyKmygmebmgAM3jYUZwHt5aiFLCVHz2WiDJ7I6J4fs5PeJhFipFxESwRP8x79Qc6Qu/Y+ktnsvSEveXJWMAWntWG0ANfAukl2pDqB6OpPFQmbvYb/AtDmeZ2fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NCK2StZi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NCK2StZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C52C2BCB3;
	Fri, 15 May 2026 16:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862699;
	bh=02+SIdtzs+wADiMShP1u0jIRPggpWSAyTTNdZ8c6cy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NCK2StZicV5HwE1r3gPjd0WhKbiV+xJ7w+cE2w9JJIfVY3MZj8qCgMvOF/rM4AvqQ
	 xZ23dHoCaj3SGi8YDRy3t+mTpWvHQfkJLJZqIBVI6jt6ClqjY6FmLjS0oepEO05UzA
	 6Wj23FqEUa5hvtkGdkuN6cYwIpRKOGW8dQHgJW+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 7.0 149/201] drm/xe: Fix bo leak in xe_dma_buf_init_obj() on allocation failure
Date: Fri, 15 May 2026 17:49:27 +0200
Message-ID: <20260515154701.799329699@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

commit 93a528f67ce5095bcab46a69839eca97f43dd352 upstream.

When drm_gpuvm_resv_object_alloc() fails, the pre-allocated storage bo
is not freed. Add xe_bo_free(storage) before returning the error.

xe_dma_buf_init_obj() calls xe_bo_init_locked(), which frees the bo on
error. Therefore, xe_dma_buf_init_obj() must also free the bo on its own
error paths. Otherwise, since xe_gem_prime_import() cannot distinguish
whether the failure originated from xe_dma_buf_init_obj() or from
xe_bo_init_locked(), it cannot safely decide whether the bo should be
freed.

Add comments documenting the ownership semantics: on success, ownership
of storage is transferred to the returned drm_gem_object; on failure,
storage is freed before returning.

v2: Add comments to explain the free logic.

Fixes: eb289a5f6cc6 ("drm/xe: Convert xe_dma_buf.c for exhaustive eviction")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4.6
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260408175255.3402838-4-shuicheng.lin@intel.com
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
(cherry picked from commit 78a6c5f899f22338bbf48b44fb8950409c5a69b9)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_dma_buf.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_dma_buf.c
+++ b/drivers/gpu/drm/xe/xe_dma_buf.c
@@ -238,6 +238,13 @@ struct dma_buf *xe_gem_prime_export(stru
 	return buf;
 }
 
+/*
+ * Takes ownership of @storage: on success it is transferred to the returned
+ * drm_gem_object; on failure it is freed before returning the error.
+ * This matches the contract of xe_bo_init_locked() which frees @storage on
+ * its error paths, so callers need not (and must not) free @storage after
+ * this call.
+ */
 static struct drm_gem_object *
 xe_dma_buf_init_obj(struct drm_device *dev, struct xe_bo *storage,
 		    struct dma_buf *dma_buf)
@@ -251,8 +258,10 @@ xe_dma_buf_init_obj(struct drm_device *d
 	int ret = 0;
 
 	dummy_obj = drm_gpuvm_resv_object_alloc(&xe->drm);
-	if (!dummy_obj)
+	if (!dummy_obj) {
+		xe_bo_free(storage);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	dummy_obj->resv = resv;
 	xe_validation_guard(&ctx, &xe->val, &exec, (struct xe_val_flags) {}, ret) {
@@ -261,6 +270,7 @@ xe_dma_buf_init_obj(struct drm_device *d
 		if (ret)
 			break;
 
+		/* xe_bo_init_locked() frees storage on error */
 		bo = xe_bo_init_locked(xe, storage, NULL, resv, NULL, dma_buf->size,
 				       0, /* Will require 1way or 2way for vm_bind */
 				       ttm_bo_type_sg, XE_BO_FLAG_SYSTEM, &exec);


