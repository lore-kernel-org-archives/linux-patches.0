Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704E83BB12D;
	Fri, 15 May 2026 16:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862726; cv=none; b=R/GBCQCbTdFZxj3Uf+blCzrbxdbIbMYCaj2E0WjwgPJRZ1AY4d88XhMv3gb+/A05i6MLnMBHMaVsal4IDU1/6T2SFnhuk+5rbn3+eKNfkAUNldpS5JmigiqSTAbvPlun/yjPyP4enPq3jgZXuf6aKKvcgVTHdQGkhXMibPSsmGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862726; c=relaxed/simple;
	bh=P4kuDXCh6aQ71bCeu4QeFP6W9TUvWpMFgGWhSUQt//s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=joIsrmqVpJSdmL0KUoJ6pdiNj500wWN5fU+9zM/USIP41YsVppx3Rhx6syqJ/t1SUVFlpcjyvC4eBQNvZnC/CdXdMOBUdX3l4EPK2d84wUGL/NGAtESEhU8Yx+HYkOXkNeYi3Pwvhhm76uN6VQIruHKsQqMnYr3UKo5XCZszC90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mSRNXbOd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSRNXbOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06DD5C2BCB0;
	Fri, 15 May 2026 16:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862726;
	bh=P4kuDXCh6aQ71bCeu4QeFP6W9TUvWpMFgGWhSUQt//s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mSRNXbOdsq+etnM3uLCyIetunpwutw7YhMFgWQUrw/QHAgpfRTzTLBv3GtMORSkcl
	 4FaUpxgKUSAVFGPAmrV7GxnpAX5AWIXCA6jVAYucJGqASAm5sAQqqSRSah5J+UIg61
	 VgKV9tZFoiM+lMVEErC7Up8E73CLccxggOVr1BW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 158/201] drm/amdgpu/userq: fix access to stale wptr mapping
Date: Fri, 15 May 2026 17:49:36 +0200
Message-ID: <20260515154701.997524510@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunil Khatri <sunil.khatri@amd.com>

commit 6da7b1242da4455b11c24ce667d1cab1a348c8ea upstream.

Use drm_exec to take both locks i.e vm root bo and
wptr_obj bo to access the mapping data properly.

This fixes the security issue of unmap the wptr_obj while
a queue creation is in progress and passing other
bo at same address.

Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1fc6c8ab45dbee096469c08c13f6099d57a52d6c)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_userqueue.c |   95 +++++++++++------------------
 1 file changed, 37 insertions(+), 58 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/mes_userqueue.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_userqueue.c
@@ -31,89 +31,68 @@
 #define AMDGPU_USERQ_GANG_CTX_SZ PAGE_SIZE
 
 static int
-mes_userq_map_gtt_bo_to_gart(struct amdgpu_bo *bo)
-{
-	int ret;
-
-	ret = amdgpu_bo_reserve(bo, true);
-	if (ret) {
-		DRM_ERROR("Failed to reserve bo. ret %d\n", ret);
-		goto err_reserve_bo_failed;
-	}
-
-	ret = amdgpu_ttm_alloc_gart(&bo->tbo);
-	if (ret) {
-		DRM_ERROR("Failed to bind bo to GART. ret %d\n", ret);
-		goto err_map_bo_gart_failed;
-	}
-
-	amdgpu_bo_unreserve(bo);
-	bo = amdgpu_bo_ref(bo);
-
-	return 0;
-
-err_map_bo_gart_failed:
-	amdgpu_bo_unreserve(bo);
-err_reserve_bo_failed:
-	return ret;
-}
-
-static int
 mes_userq_create_wptr_mapping(struct amdgpu_device *adev,
 			      struct amdgpu_userq_mgr *uq_mgr,
 			      struct amdgpu_usermode_queue *queue,
 			      uint64_t wptr)
 {
 	struct amdgpu_bo_va_mapping *wptr_mapping;
-	struct amdgpu_vm *wptr_vm;
 	struct amdgpu_userq_obj *wptr_obj = &queue->wptr_obj;
+	struct amdgpu_bo *obj;
+	struct amdgpu_vm *vm = queue->vm;
+	struct drm_exec exec;
 	int ret;
 
-	wptr_vm = queue->vm;
-	ret = amdgpu_bo_reserve(wptr_vm->root.bo, false);
-	if (ret)
-		return ret;
-
 	wptr &= AMDGPU_GMC_HOLE_MASK;
-	wptr_mapping = amdgpu_vm_bo_lookup_mapping(wptr_vm, wptr >> PAGE_SHIFT);
-	amdgpu_bo_unreserve(wptr_vm->root.bo);
-	if (!wptr_mapping) {
-		DRM_ERROR("Failed to lookup wptr bo\n");
-		return -EINVAL;
-	}
 
-	wptr_obj->obj = wptr_mapping->bo_va->base.bo;
-	if (wptr_obj->obj->tbo.base.size > PAGE_SIZE) {
-		DRM_ERROR("Requested GART mapping for wptr bo larger than one page\n");
-		return -EINVAL;
+	drm_exec_init(&exec, DRM_EXEC_IGNORE_DUPLICATES, 2);
+	drm_exec_until_all_locked(&exec) {
+		ret = amdgpu_vm_lock_pd(vm, &exec, 1);
+		drm_exec_retry_on_contention(&exec);
+		if (unlikely(ret))
+			goto fail_lock;
+
+		wptr_mapping = amdgpu_vm_bo_lookup_mapping(vm, wptr >> PAGE_SHIFT);
+		if (!wptr_mapping) {
+			ret = -EINVAL;
+			goto fail_lock;
+		}
+
+		obj = wptr_mapping->bo_va->base.bo;
+		ret = drm_exec_lock_obj(&exec, &obj->tbo.base);
+		drm_exec_retry_on_contention(&exec);
+		if (unlikely(ret))
+			goto fail_lock;
 	}
 
-	ret = mes_userq_map_gtt_bo_to_gart(wptr_obj->obj);
-	if (ret) {
-		DRM_ERROR("Failed to map wptr bo to GART\n");
-		return ret;
+	wptr_obj->obj = amdgpu_bo_ref(wptr_mapping->bo_va->base.bo);
+	if (wptr_obj->obj->tbo.base.size > PAGE_SIZE) {
+		ret = -EINVAL;
+		goto fail_map;
 	}
 
-	ret = amdgpu_bo_reserve(wptr_obj->obj, true);
+	/* TODO use eviction fence instead of pinning. */
+	ret = amdgpu_bo_pin(wptr_obj->obj, AMDGPU_GEM_DOMAIN_GTT);
 	if (ret) {
-		DRM_ERROR("Failed to reserve wptr bo\n");
-		return ret;
+		DRM_ERROR("Failed to pin wptr bo. ret %d\n", ret);
+		goto fail_map;
 	}
 
-	/* TODO use eviction fence instead of pinning. */
-	ret = amdgpu_bo_pin(wptr_obj->obj, AMDGPU_GEM_DOMAIN_GTT);
+	ret = amdgpu_ttm_alloc_gart(&wptr_obj->obj->tbo);
 	if (ret) {
-		drm_file_err(uq_mgr->file, "[Usermode queues] Failed to pin wptr bo\n");
-		goto unresv_bo;
+		DRM_ERROR("Failed to bind bo to GART. ret %d\n", ret);
+		goto fail_map;
 	}
 
 	queue->wptr_obj.gpu_addr = amdgpu_bo_gpu_offset(wptr_obj->obj);
-	amdgpu_bo_unreserve(wptr_obj->obj);
 
+	drm_exec_fini(&exec);
 	return 0;
 
-unresv_bo:
-	amdgpu_bo_unreserve(wptr_obj->obj);
+fail_map:
+	amdgpu_bo_unref(&wptr_obj->obj);
+fail_lock:
+	drm_exec_fini(&exec);
 	return ret;
 
 }


