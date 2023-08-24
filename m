Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6FD11C86
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33FCC433C7;
	Thu, 24 Aug 2023 14:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692889109;
	bh=o2IqFnUcWgwXaNrTe6YVXa6Uxkksg/fyQ6w2Ge9kjdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PpteXMJqGLZ2XVnTZrpS4HYcmV9DxvwIadD9MMeySuNN8Rf+f8CSKb/0Gnm6c7ISA
	 zVEG6Pj9/Lf/93D9y6mLaPx9caNof7N8fiJmLOeCPa5CFhB++SdaqIPh70G+ynaZ6f
	 KmGQ5EsAnIFV/CpDCdoZtwG6xHNfP1xyB1Zj+f7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Lang Yu <Lang.Yu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 018/135] drm/amdgpu: install stub fence into potential unused fence pointers
Date: Thu, 24 Aug 2023 16:49:21 +0200
Message-ID: <20230824145027.741846128@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145027.008282920@linuxfoundation.org>
References: <20230824145027.008282920@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lang Yu <Lang.Yu@amd.com>

[ Upstream commit 187916e6ed9d0c3b3abc27429f7a5f8c936bd1f0 ]

When using cpu to update page tables, vm update fences are unused.
Install stub fence into these fence pointers instead of NULL
to avoid NULL dereference when calling dma_fence_wait() on them.

Suggested-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Lang Yu <Lang.Yu@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index 8445bb7ae06ab..3b4724d60868f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2155,6 +2155,7 @@ struct amdgpu_bo_va *amdgpu_vm_bo_add(struct amdgpu_device *adev,
 	amdgpu_vm_bo_base_init(&bo_va->base, vm, bo);
 
 	bo_va->ref_count = 1;
+	bo_va->last_pt_update = dma_fence_get_stub();
 	INIT_LIST_HEAD(&bo_va->valids);
 	INIT_LIST_HEAD(&bo_va->invalids);
 
@@ -2867,7 +2868,8 @@ int amdgpu_vm_init(struct amdgpu_device *adev, struct amdgpu_vm *vm,
 		vm->update_funcs = &amdgpu_vm_cpu_funcs;
 	else
 		vm->update_funcs = &amdgpu_vm_sdma_funcs;
-	vm->last_update = NULL;
+
+	vm->last_update = dma_fence_get_stub();
 	vm->last_unlocked = dma_fence_get_stub();
 
 	mutex_init(&vm->eviction_lock);
@@ -3042,7 +3044,7 @@ int amdgpu_vm_make_compute(struct amdgpu_device *adev, struct amdgpu_vm *vm,
 		vm->update_funcs = &amdgpu_vm_sdma_funcs;
 	}
 	dma_fence_put(vm->last_update);
-	vm->last_update = NULL;
+	vm->last_update = dma_fence_get_stub();
 	vm->is_compute_context = true;
 
 	if (vm->pasid) {
-- 
2.40.1



