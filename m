Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA5634D3BE;
	Tue, 16 Dec 2025 11:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885342; cv=none; b=Rc1gywVF4x2cbx3J16bh/GTjTupCPGHx+nT1baX3TAsdTGLKsGd08yiVGYMzNJoEwoGVOSP7pJC37OWvGNrWb/WRAD7zQAYlgfWPT8WsHcyNLnsmiAVTVYK/h+OVMpMAno4TMiMFrz4B3XnYAh0YwK3XiGqVp9KCDM2yo2XdKNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885342; c=relaxed/simple;
	bh=gsE9t0jzLKIKvmedJvte0Ys/c4im5FxBl5HHs9U6D2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBd1WqwuLYSUkbXZKq4tZKQvawTkvNg2Q7sVS0sPITIihDJcYfbS2c8v6Z7iiGhlEC4quyEEFhjR4T8Slmvc4pc/1ZkVB6jTlRc4q/KkhncAHyecqqq7Je7lB2QIiSlnLdbMxLiK9M4zVvrNV3mnyQTVItjyHnauoVJK0BWIrQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dp74aSRe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dp74aSRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C109C4CEF1;
	Tue, 16 Dec 2025 11:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885341;
	bh=gsE9t0jzLKIKvmedJvte0Ys/c4im5FxBl5HHs9U6D2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dp74aSReQzL3f1NJTBQiGAC/JMa1dhe6Vp0phH7d7jUuJ1VfjBUw3Q7/GK6E9mGim
	 4qi5DHFh661DFHu4silPsMEbAQteEIdQgWOqeHJvCz0lochuLGKY7YIdWmbVmb9slJ
	 Bh0tcE2X7/l8BzMClZF8X9az6qaVKQi00OaPVnNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 111/507] drm/amdgpu/userq: fix SDMA and compute validation
Date: Tue, 16 Dec 2025 12:09:12 +0100
Message-ID: <20251216111349.557065655@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit a0559012a18a5a6ad87516e982892765a403b8ab ]

The CSA and EOP buffers have different alignement requirements.
Hardcode them for now as a bug fix.  A proper query will be added in
a subsequent patch.

v2: verify gfx shadow helper callback (Prike)

Fixes: 9e46b8bb0539 ("drm/amdgpu: validate userq buffer virtual address and size")
Reviewed-by: Prike Liang <Prike.Liang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_userqueue.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/mes_userqueue.c b/drivers/gpu/drm/amd/amdgpu/mes_userqueue.c
index 00dd5f37f4374..1cd1fdec9cc97 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_userqueue.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_userqueue.c
@@ -206,7 +206,6 @@ static int mes_userq_mqd_create(struct amdgpu_userq_mgr *uq_mgr,
 	struct amdgpu_mqd *mqd_hw_default = &adev->mqds[queue->queue_type];
 	struct drm_amdgpu_userq_in *mqd_user = args_in;
 	struct amdgpu_mqd_prop *userq_props;
-	struct amdgpu_gfx_shadow_info shadow_info;
 	int r;
 
 	/* Structure to initialize MQD for userqueue using generic MQD init function */
@@ -232,8 +231,6 @@ static int mes_userq_mqd_create(struct amdgpu_userq_mgr *uq_mgr,
 	userq_props->doorbell_index = queue->doorbell_index;
 	userq_props->fence_address = queue->fence_drv->gpu_addr;
 
-	if (adev->gfx.funcs->get_gfx_shadow_info)
-		adev->gfx.funcs->get_gfx_shadow_info(adev, &shadow_info, true);
 	if (queue->queue_type == AMDGPU_HW_IP_COMPUTE) {
 		struct drm_amdgpu_userq_mqd_compute_gfx11 *compute_mqd;
 
@@ -251,7 +248,7 @@ static int mes_userq_mqd_create(struct amdgpu_userq_mgr *uq_mgr,
 		}
 
 		r = amdgpu_userq_input_va_validate(queue, compute_mqd->eop_va,
-						   max_t(u32, PAGE_SIZE, AMDGPU_GPU_PAGE_SIZE));
+						   2048);
 		if (r)
 			goto free_mqd;
 
@@ -264,6 +261,14 @@ static int mes_userq_mqd_create(struct amdgpu_userq_mgr *uq_mgr,
 		kfree(compute_mqd);
 	} else if (queue->queue_type == AMDGPU_HW_IP_GFX) {
 		struct drm_amdgpu_userq_mqd_gfx11 *mqd_gfx_v11;
+		struct amdgpu_gfx_shadow_info shadow_info;
+
+		if (adev->gfx.funcs->get_gfx_shadow_info) {
+			adev->gfx.funcs->get_gfx_shadow_info(adev, &shadow_info, true);
+		} else {
+			r = -EINVAL;
+			goto free_mqd;
+		}
 
 		if (mqd_user->mqd_size != sizeof(*mqd_gfx_v11) || !mqd_user->mqd) {
 			DRM_ERROR("Invalid GFX MQD\n");
@@ -287,6 +292,10 @@ static int mes_userq_mqd_create(struct amdgpu_userq_mgr *uq_mgr,
 						   shadow_info.shadow_size);
 		if (r)
 			goto free_mqd;
+		r = amdgpu_userq_input_va_validate(queue, mqd_gfx_v11->csa_va,
+						   shadow_info.csa_size);
+		if (r)
+			goto free_mqd;
 
 		kfree(mqd_gfx_v11);
 	} else if (queue->queue_type == AMDGPU_HW_IP_DMA) {
@@ -305,7 +314,7 @@ static int mes_userq_mqd_create(struct amdgpu_userq_mgr *uq_mgr,
 			goto free_mqd;
 		}
 		r = amdgpu_userq_input_va_validate(queue, mqd_sdma_v11->csa_va,
-						   shadow_info.csa_size);
+						   32);
 		if (r)
 			goto free_mqd;
 
-- 
2.51.0



