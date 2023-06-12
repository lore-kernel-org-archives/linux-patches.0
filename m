Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC66134A4
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2DDC433D2;
	Mon, 12 Jun 2023 10:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566488;
	bh=3Uapld8uoQVHpDD8ivr7v8oo3+EBxLbGzAbSPZ2kfzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A2QiPNzsylGG1lP7EZOsk9Gp6RlxQy4th9MeyojfZ6zbIakoMAXee8tNU48cgyRsb
	 L2IHxC+vHZYxCktb2N0R0dUV3LmlCIbqteaDSbqay8E/4as095BQ3e862m+YYoJvKK
	 bTOaNO44Wqpc6SaxV0ETouExE+ooN/UBNIHhCuig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xinhui pan <xinhui.pan@amd.com>,
	Horatio Zhang <Hongkun.Zhang@amd.com>,
	Feifei Xu <Feifei.Xu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/132] drm/amdgpu: fix Null pointer dereference error in amdgpu_device_recover_vram
Date: Mon, 12 Jun 2023 12:26:24 +0200
Message-ID: <20230612101712.544926875@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>
References: <20230612101710.279705932@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Horatio Zhang <Hongkun.Zhang@amd.com>

[ Upstream commit 2a1eb1a343208ce7d6839b73d62aece343e693ff ]

Use the function of amdgpu_bo_vm_destroy to handle the resource release
of shadow bo. During the amdgpu_mes_self_test, shadow bo released, but
vmbo->shadow_list was not, which caused a null pointer reference error
in amdgpu_device_recover_vram when GPU reset.

Fixes: 6c032c37ac3e ("drm/amdgpu: Fix vram recover doesn't work after whole GPU reset (v2)")
Signed-off-by: xinhui pan <xinhui.pan@amd.com>
Signed-off-by: Horatio Zhang <Hongkun.Zhang@amd.com>
Acked-by: Feifei Xu <Feifei.Xu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c | 10 ++++------
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c  |  1 -
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index 4feedf518a191..ad8cb9e6d1ab0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -79,9 +79,10 @@ static void amdgpu_bo_user_destroy(struct ttm_buffer_object *tbo)
 static void amdgpu_bo_vm_destroy(struct ttm_buffer_object *tbo)
 {
 	struct amdgpu_device *adev = amdgpu_ttm_adev(tbo->bdev);
-	struct amdgpu_bo *bo = ttm_to_amdgpu_bo(tbo);
+	struct amdgpu_bo *shadow_bo = ttm_to_amdgpu_bo(tbo), *bo;
 	struct amdgpu_bo_vm *vmbo;
 
+	bo = shadow_bo->parent;
 	vmbo = to_amdgpu_bo_vm(bo);
 	/* in case amdgpu_device_recover_vram got NULL of bo->parent */
 	if (!list_empty(&vmbo->shadow_list)) {
@@ -691,11 +692,6 @@ int amdgpu_bo_create_vm(struct amdgpu_device *adev,
 		return r;
 
 	*vmbo_ptr = to_amdgpu_bo_vm(bo_ptr);
-	INIT_LIST_HEAD(&(*vmbo_ptr)->shadow_list);
-	/* Set destroy callback to amdgpu_bo_vm_destroy after vmbo->shadow_list
-	 * is initialized.
-	 */
-	bo_ptr->tbo.destroy = &amdgpu_bo_vm_destroy;
 	return r;
 }
 
@@ -712,6 +708,8 @@ void amdgpu_bo_add_to_shadow_list(struct amdgpu_bo_vm *vmbo)
 
 	mutex_lock(&adev->shadow_list_lock);
 	list_add_tail(&vmbo->shadow_list, &adev->shadow_list);
+	vmbo->shadow->parent = amdgpu_bo_ref(&vmbo->bo);
+	vmbo->shadow->tbo.destroy = &amdgpu_bo_vm_destroy;
 	mutex_unlock(&adev->shadow_list_lock);
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
index 01e42bdd8e4e8..4642cff0e1a4f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
@@ -564,7 +564,6 @@ int amdgpu_vm_pt_create(struct amdgpu_device *adev, struct amdgpu_vm *vm,
 		return r;
 	}
 
-	(*vmbo)->shadow->parent = amdgpu_bo_ref(bo);
 	amdgpu_bo_add_to_shadow_list(*vmbo);
 
 	return 0;
-- 
2.39.2



