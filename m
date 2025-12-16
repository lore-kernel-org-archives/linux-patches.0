Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C807934EEF0;
	Tue, 16 Dec 2025 12:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887213; cv=none; b=uc0r18hxLxCEpqh7SlS92Gyjm8RFYaDgXxnu7zgj5CImEvg1D27V9gbwDf3E3V+/nZzGc8BHXbAIITg6dBxXNjG4XBga7rupquYmZfEuA+0GHKdgC02pvspiMJ66iA1UF6KYNYOOttb9z96qRqZwgJ9JZwbOJM/qJNtZ0nXgXik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887213; c=relaxed/simple;
	bh=8bigxs6OLyZ3Mb+IJbvCXshuYhPPs5o9O84ImqFnGxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RaHKoLzDvm8dkaOJ91SLSNdprbTE2KEu7bIKWnyWhGXh0UdbB72nRQyLOjfuzwAJIWYVhUzC4jD/cUTF+Ui8k69Z3tjCSfRQ8XqO77l+RBHqPEvvcOsVn7oCLSNn8pp00FjGABeqz0FK8nhBwETWj513yIjwMshM4Pm4pSwQWnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OD+Ddi6o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OD+Ddi6o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4785CC4CEF5;
	Tue, 16 Dec 2025 12:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887213;
	bh=8bigxs6OLyZ3Mb+IJbvCXshuYhPPs5o9O84ImqFnGxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OD+Ddi6o0bMlrs6u2xRl/2lGvxwlhnnNTMIwDaIvd7Tre4+vk68oVX30b/MJbeANj
	 Owwp8Xcjjf5flR7PFLOTZ91yHCKVViJPOkz3wJYtqDA0PvQ0rYMqFxWnz1V9GhRd3y
	 J4y1PhvqqzEnczfwvoXCuE01MN6owdOh99aRxhN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 134/614] drm/amdgpu/userq: fix SDMA and compute validation
Date: Tue, 16 Dec 2025 12:08:21 +0100
Message-ID: <20251216111406.191486876@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5c63480dda9c4..f5aa83ff57f35 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_userqueue.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_userqueue.c
@@ -254,7 +254,6 @@ static int mes_userq_mqd_create(struct amdgpu_userq_mgr *uq_mgr,
 	struct amdgpu_mqd *mqd_hw_default = &adev->mqds[queue->queue_type];
 	struct drm_amdgpu_userq_in *mqd_user = args_in;
 	struct amdgpu_mqd_prop *userq_props;
-	struct amdgpu_gfx_shadow_info shadow_info;
 	int r;
 
 	/* Structure to initialize MQD for userqueue using generic MQD init function */
@@ -280,8 +279,6 @@ static int mes_userq_mqd_create(struct amdgpu_userq_mgr *uq_mgr,
 	userq_props->doorbell_index = queue->doorbell_index;
 	userq_props->fence_address = queue->fence_drv->gpu_addr;
 
-	if (adev->gfx.funcs->get_gfx_shadow_info)
-		adev->gfx.funcs->get_gfx_shadow_info(adev, &shadow_info, true);
 	if (queue->queue_type == AMDGPU_HW_IP_COMPUTE) {
 		struct drm_amdgpu_userq_mqd_compute_gfx11 *compute_mqd;
 
@@ -299,7 +296,7 @@ static int mes_userq_mqd_create(struct amdgpu_userq_mgr *uq_mgr,
 		}
 
 		r = amdgpu_userq_input_va_validate(queue, compute_mqd->eop_va,
-						   max_t(u32, PAGE_SIZE, AMDGPU_GPU_PAGE_SIZE));
+						   2048);
 		if (r)
 			goto free_mqd;
 
@@ -312,6 +309,14 @@ static int mes_userq_mqd_create(struct amdgpu_userq_mgr *uq_mgr,
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
@@ -335,6 +340,10 @@ static int mes_userq_mqd_create(struct amdgpu_userq_mgr *uq_mgr,
 						   shadow_info.shadow_size);
 		if (r)
 			goto free_mqd;
+		r = amdgpu_userq_input_va_validate(queue, mqd_gfx_v11->csa_va,
+						   shadow_info.csa_size);
+		if (r)
+			goto free_mqd;
 
 		kfree(mqd_gfx_v11);
 	} else if (queue->queue_type == AMDGPU_HW_IP_DMA) {
@@ -353,7 +362,7 @@ static int mes_userq_mqd_create(struct amdgpu_userq_mgr *uq_mgr,
 			goto free_mqd;
 		}
 		r = amdgpu_userq_input_va_validate(queue, mqd_sdma_v11->csa_va,
-						   shadow_info.csa_size);
+						   32);
 		if (r)
 			goto free_mqd;
 
-- 
2.51.0



