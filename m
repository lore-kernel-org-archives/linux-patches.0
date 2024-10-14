Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33621AB6D8;
	Mon, 14 Oct 2024 14:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916406; cv=none; b=F/DLa5VDA7GFELWd2vOa+Us7guAIb9KQqZAut2DSP1jD2eZssAbKrdYlK1Z2EkF/P2MtwYbYv+xRGVi3Beu955jXJvNigqlXwvuWMNGZvSdXLSeYeLlW2QTMQIyURwYGwYBUc0XsQ4kieACEm0cTCYK14ob7enjZ/FKYezrgWrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916406; c=relaxed/simple;
	bh=HbnGTA4yZ1lHFqUMdBCqwtcQT1F/6QvfpKRkr92CurY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXOWA6zR/5X1lqCV+o/sYqSjCCiru9gEhU8E6xxN0G8OElhsDhKhzs+0uZHsU1PKf5XpvroSrFwExY/b9Vn9FO5OCeA1VsbZZRWyf6B0djRdPUoNLYtltF8HQC3DiWym7tKNGT6zVIIFaQABJ2Fu4Xc/iWQUtD0XPWcJ4f8nBLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZVOEF53; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZVOEF53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5F6C4CEC3;
	Mon, 14 Oct 2024 14:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916406;
	bh=HbnGTA4yZ1lHFqUMdBCqwtcQT1F/6QvfpKRkr92CurY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZVOEF534SvwOgF6Om9CjzFW4K7kP5ZL94eQzv+/g8Bu2si+C5QMa7oSvt3Gt/RRp
	 z90bwKB8jg2/28Dp6zaI5yIzcIZ5f08xQG2j0JhOp48QtsR9Kvh6NzdLH8ZpTbtEMD
	 /Ntg4YPYSg9uodLu22rPiLN62ot90REdyRUpY4C8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Lang Yu <lang.yu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 175/214] drm/amdkfd: Fix an eviction fence leak
Date: Mon, 14 Oct 2024 16:20:38 +0200
Message-ID: <20241014141051.809455136@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lang Yu <lang.yu@amd.com>

commit d7d7b947a4fa6d0a82ff2bf0db413edc63738e3a upstream.

Only creating a new reference for each process instead of each VM.

Fixes: 9a1c1339abf9 ("drm/amdkfd: Run restore_workers on freezable WQs")
Suggested-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Lang Yu <lang.yu@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5fa436289483ae56427b0896c31f72361223c758)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |    4 ++--
 drivers/gpu/drm/amd/amdkfd/kfd_process.c         |    7 +++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1438,8 +1438,8 @@ static int init_kfd_vm(struct amdgpu_vm
 	list_add_tail(&vm->vm_list_node,
 			&(vm->process_info->vm_list_head));
 	vm->process_info->n_vms++;
-
-	*ef = dma_fence_get(&vm->process_info->eviction_fence->base);
+	if (ef)
+		*ef = dma_fence_get(&vm->process_info->eviction_fence->base);
 	mutex_unlock(&vm->process_info->lock);
 
 	return 0;
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -1676,12 +1676,15 @@ int kfd_process_device_init_vm(struct kf
 
 	ret = amdgpu_amdkfd_gpuvm_acquire_process_vm(dev->adev, avm,
 						     &p->kgd_process_info,
-						     &ef);
+						     p->ef ? NULL : &ef);
 	if (ret) {
 		dev_err(dev->adev->dev, "Failed to create process VM object\n");
 		return ret;
 	}
-	RCU_INIT_POINTER(p->ef, ef);
+
+	if (!p->ef)
+		RCU_INIT_POINTER(p->ef, ef);
+
 	pdd->drm_priv = drm_file->private_data;
 
 	ret = kfd_process_device_reserve_ib_mem(pdd);


