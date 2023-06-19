Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495908C06
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85F9C433C8;
	Mon, 19 Jun 2023 10:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172317;
	bh=cEM21uNXSwfcjkspB9Ux9Si08E+g/JINtKMbx3rQ72E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Phd58tixQIymJUbrbXXEotuJc/OjoGm9ttOCb20zQhmdToRhK0SfTRIN+xKqnayrp
	 1PmEdEcKRaKswgot1tvQwdQfGn6c9W8ZGfunikp6LJroTum5dROWpvPP+k82twejGP
	 SsjrPLX+5xElgte6oFx6TI6o+zoCcJGSmeRFB/S4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xinhui pan <xinhui.pan@amd.com>,
	Horatio Zhang <Hongkun.Zhang@amd.com>,
	Feifei Xu <Feifei.Xu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/107] drm/amdgpu: fix Null pointer dereference error in amdgpu_device_recover_vram
Date: Mon, 19 Jun 2023 12:29:49 +0200
Message-ID: <20230619102141.795234604@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>
References: <20230619102141.541044823@linuxfoundation.org>
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
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c | 6 ++++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c     | 1 -
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index a0b1bf17cb74b..d03a4519f945b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -78,9 +78,10 @@ static void amdgpu_bo_user_destroy(struct ttm_buffer_object *tbo)
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
@@ -690,7 +691,6 @@ int amdgpu_bo_create_vm(struct amdgpu_device *adev,
 		return r;
 
 	*vmbo_ptr = to_amdgpu_bo_vm(bo_ptr);
-	INIT_LIST_HEAD(&(*vmbo_ptr)->shadow_list);
 	return r;
 }
 
@@ -741,6 +741,8 @@ void amdgpu_bo_add_to_shadow_list(struct amdgpu_bo_vm *vmbo)
 
 	mutex_lock(&adev->shadow_list_lock);
 	list_add_tail(&vmbo->shadow_list, &adev->shadow_list);
+	vmbo->shadow->parent = amdgpu_bo_ref(&vmbo->bo);
+	vmbo->shadow->tbo.destroy = &amdgpu_bo_vm_destroy;
 	mutex_unlock(&adev->shadow_list_lock);
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index 01710cd0d9727..924c6d5f86203 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -983,7 +983,6 @@ static int amdgpu_vm_pt_create(struct amdgpu_device *adev,
 		return r;
 	}
 
-	(*vmbo)->shadow->parent = amdgpu_bo_ref(bo);
 	amdgpu_bo_add_to_shadow_list(*vmbo);
 
 	return 0;
-- 
2.39.2



