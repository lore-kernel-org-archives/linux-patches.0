Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584F14FDA6F;
	Tue, 13 Oct 2026 12:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893487; cv=none; b=phQ5ET1cFNcc7BWYyg5taDp6PBbLjdhXgFpurFFjLHu4Pwq1tCTpoMoF1IAOTfUbU3r0El+xbesV47sKZNZlHqacZ3HiHwFJcc5hPy+tso1lD6XGcJ3NTR2N3InNg+ueRtqzWiu9OGnlj6JukSBpdaqEFWhjMikBiJH7s1K2rMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893487; c=relaxed/simple;
	bh=qzMkrMyMQVKKZw9nmRJuU5L10cbYQvjTJtOHzkGg1PQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nJ3kIW4m8SCJq/AJytVVCV1OzpXD2H+s7V8XtNtPFB1EMNxvUI1PKOEJWAdNISkar6RAZV4DwkwpaXxYXZhmjXhIg4D5EkFd7ESr2wmY27gTzweVZRmykYi1dzzPZEi/2gf6fAjrwjrKZSv+lD03CrOl+IWxcQhuRg42wjbOkeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nc9Yf1v/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nc9Yf1v/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09391F000FF;
	Tue, 13 Oct 2026 12:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893486;
	bh=wumFFS16jMm5xfrGfwFayRLEb5Bd5jbjfxNrETGJOpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nc9Yf1v/4cSE7BnTZp34Sx2txLQ474lR1xna7vW7USRUGVjF9Risn8A1jWzL7Er44
	 zVap2dYjw8dWDhDSm/DSolKAQoYzR6PPMldE7E2ph35NMdF4h0K4WfrD6HEXqku1zb
	 EhRmfqKucm7gdzESmyJCZI9qJ3J3G9WTxJ9h3NjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 205/621] drm/amdgpu/userq: fix access to stale wptr mapping
Date: Tue, 13 Oct 2026 13:33:20 +0200
Message-ID: <20261013112925.726239007@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunil Khatri <sunil.khatri@amd.com>

[ Upstream commit 6da7b1242da4455b11c24ce667d1cab1a348c8ea ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_userqueue.c | 82 ++++++++++------------
 1 file changed, 37 insertions(+), 45 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/mes_userqueue.c b/drivers/gpu/drm/amd/amdgpu/mes_userqueue.c
index 5b42497947cd8..15bcbe9118e5f 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_userqueue.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_userqueue.c
@@ -30,71 +30,63 @@
 #define AMDGPU_USERQ_PROC_CTX_SZ PAGE_SIZE
 #define AMDGPU_USERQ_GANG_CTX_SZ PAGE_SIZE
 
-static int
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
 static int
 mes_userq_create_wptr_mapping(struct amdgpu_userq_mgr *uq_mgr,
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
+
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
 
-	wptr_obj->obj = wptr_mapping->bo_va->base.bo;
+	wptr_obj->obj = amdgpu_bo_ref(wptr_mapping->bo_va->base.bo);
 	if (wptr_obj->obj->tbo.base.size > PAGE_SIZE) {
-		DRM_ERROR("Requested GART mapping for wptr bo larger than one page\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto fail_map;
 	}
 
-	ret = mes_userq_map_gtt_bo_to_gart(wptr_obj->obj);
+	ret = amdgpu_ttm_alloc_gart(&wptr_obj->obj->tbo);
 	if (ret) {
-		DRM_ERROR("Failed to map wptr bo to GART\n");
-		return ret;
+		DRM_ERROR("Failed to bind bo to GART. ret %d\n", ret);
+		goto fail_map;
 	}
 
 	queue->wptr_obj.gpu_addr = amdgpu_bo_gpu_offset_no_check(wptr_obj->obj);
+
+	drm_exec_fini(&exec);
 	return 0;
+
+fail_map:
+	amdgpu_bo_unref(&wptr_obj->obj);
+fail_lock:
+	drm_exec_fini(&exec);
+	return ret;
+
 }
 
 static int convert_to_mes_priority(int priority)
-- 
2.53.0



