Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B637F1E9B08;
	Tue,  8 Jul 2025 16:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993131; cv=none; b=ElidNpQ5uxgC8KTvVM9sdz2wyyPkciag5vkxqtMbpZEmQonNp07piSSSpaM7/zu23RWi3HGLJQp8wcgLjdy5VKcaIlsI0ZbD6hxKFeWGdnbUwvRMCEtBMDuoh55biNTBPp6BbJJhQMiLD2VEMJn9sHfwoHSZ6A1RXpGysLGSJXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993131; c=relaxed/simple;
	bh=fvnZsvGY8Js3sf7I72JQQYZy1QVDzpaSSVzZLKkhZeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPojuGhKF+ue2rUwc/eNGTD3nDzTwF3e5hhXCEvabyEC3ZagVuXtWM1f/7rIZtiAwQgkQIJgQxYTTASaD6BPNNQ67KKExq02GloFpHVudzznhZRdPvgdJZHgOkj1ddn7Vfx8W+QUYL0ncJ+fggh56cDT9SxFEHNypKdB4X1RBMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fOib21Rn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fOib21Rn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5BDC4CEF5;
	Tue,  8 Jul 2025 16:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993131;
	bh=fvnZsvGY8Js3sf7I72JQQYZy1QVDzpaSSVzZLKkhZeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fOib21Rn3XxAMUDWulodU8xo2YkRiiCdSPNWWchB97wb+Ua4KMyyoZ2K2a7IKtcCe
	 ZVoqwRkzZYrLjpU52hBR3BQAqgxwgUYqk9Bqh/D06T6snFPYO97PMU4TI2aCO/GvJl
	 FRKSKBOHGbxWJhAZ0qALzz4H3JxbR3CcLYkohWq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chen <michael.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 168/232] drm/amdgpu/mes: add missing locking in helper functions
Date: Tue,  8 Jul 2025 18:22:44 +0200
Message-ID: <20250708162245.834175380@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 40f970ba7a4ab77be2ffe6d50a70416c8876496a ]

We need to take the MES lock.

Reviewed-by: Michael Chen <michael.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
index 7d4b540340e02..41b88e0ea98b8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
@@ -860,7 +860,9 @@ int amdgpu_mes_map_legacy_queue(struct amdgpu_device *adev,
 	queue_input.mqd_addr = amdgpu_bo_gpu_offset(ring->mqd_obj);
 	queue_input.wptr_addr = ring->wptr_gpu_addr;
 
+	amdgpu_mes_lock(&adev->mes);
 	r = adev->mes.funcs->map_legacy_queue(&adev->mes, &queue_input);
+	amdgpu_mes_unlock(&adev->mes);
 	if (r)
 		DRM_ERROR("failed to map legacy queue\n");
 
@@ -883,7 +885,9 @@ int amdgpu_mes_unmap_legacy_queue(struct amdgpu_device *adev,
 	queue_input.trail_fence_addr = gpu_addr;
 	queue_input.trail_fence_data = seq;
 
+	amdgpu_mes_lock(&adev->mes);
 	r = adev->mes.funcs->unmap_legacy_queue(&adev->mes, &queue_input);
+	amdgpu_mes_unlock(&adev->mes);
 	if (r)
 		DRM_ERROR("failed to unmap legacy queue\n");
 
@@ -910,7 +914,9 @@ int amdgpu_mes_reset_legacy_queue(struct amdgpu_device *adev,
 	queue_input.vmid = vmid;
 	queue_input.use_mmio = use_mmio;
 
+	amdgpu_mes_lock(&adev->mes);
 	r = adev->mes.funcs->reset_legacy_queue(&adev->mes, &queue_input);
+	amdgpu_mes_unlock(&adev->mes);
 	if (r)
 		DRM_ERROR("failed to reset legacy queue\n");
 
@@ -931,7 +937,9 @@ uint32_t amdgpu_mes_rreg(struct amdgpu_device *adev, uint32_t reg)
 		goto error;
 	}
 
+	amdgpu_mes_lock(&adev->mes);
 	r = adev->mes.funcs->misc_op(&adev->mes, &op_input);
+	amdgpu_mes_unlock(&adev->mes);
 	if (r)
 		DRM_ERROR("failed to read reg (0x%x)\n", reg);
 	else
@@ -957,7 +965,9 @@ int amdgpu_mes_wreg(struct amdgpu_device *adev,
 		goto error;
 	}
 
+	amdgpu_mes_lock(&adev->mes);
 	r = adev->mes.funcs->misc_op(&adev->mes, &op_input);
+	amdgpu_mes_unlock(&adev->mes);
 	if (r)
 		DRM_ERROR("failed to write reg (0x%x)\n", reg);
 
@@ -984,7 +994,9 @@ int amdgpu_mes_reg_write_reg_wait(struct amdgpu_device *adev,
 		goto error;
 	}
 
+	amdgpu_mes_lock(&adev->mes);
 	r = adev->mes.funcs->misc_op(&adev->mes, &op_input);
+	amdgpu_mes_unlock(&adev->mes);
 	if (r)
 		DRM_ERROR("failed to reg_write_reg_wait\n");
 
@@ -1009,7 +1021,9 @@ int amdgpu_mes_reg_wait(struct amdgpu_device *adev, uint32_t reg,
 		goto error;
 	}
 
+	amdgpu_mes_lock(&adev->mes);
 	r = adev->mes.funcs->misc_op(&adev->mes, &op_input);
+	amdgpu_mes_unlock(&adev->mes);
 	if (r)
 		DRM_ERROR("failed to reg_write_reg_wait\n");
 
-- 
2.39.5



