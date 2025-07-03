Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E4C15442C;
	Thu,  3 Jul 2025 15:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555331; cv=none; b=BXA+8yDFo62DePkcPeOmK1J3i33rRRhc4tSK5h+84QCx8RIB+YjPv175Cr2+LuTKnHr/D4V4khp0uUaeTyZsab4gFa1s96c+ztbNbZOyERu9fUgOSeOlpbMnb/VvsyGnshV9HZCy+h3FuIG7Pp1XU8EDc3vHjg1zc3LNSdfxY8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555331; c=relaxed/simple;
	bh=cDgRVlLfsfqrJ6fsVofbc6v8CC4k0MyZvHDOLJ+3eaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NrZs9hvw7xB2ovVM4777swF7KmXzf6poj3xSVsJUBzZP8ycYKQYbh4p9LNjOLGFu9szCgtuCmeY+Z/41Ql2Sh6hrAoHxmOkbRcayPHL9cbe4g8hzNNCKqW2d91LygSO0vpUxVKAvFXkrcgxARoWpaJZJmvTNiquZ/diJVuyRMIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qiSmU7qR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qiSmU7qR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C03C4CEE3;
	Thu,  3 Jul 2025 15:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555331;
	bh=cDgRVlLfsfqrJ6fsVofbc6v8CC4k0MyZvHDOLJ+3eaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qiSmU7qR6kVAjOcV2gGRN4TpBDdrVYE6IQMjGz1GKKisBhiXnxAEL9gHlw10lwksf
	 9eIUDrljRUOb/nrMl62dsdrpgK9gFZLhZn/aWtAHCDkuYuTsnVP8SjKx+QwZSguxjs
	 hfUazwtEd2cPAQB5Ntr11WXTVETbaKBdAarFXQs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chen <michael.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 245/263] drm/amdgpu/mes: add missing locking in helper functions
Date: Thu,  3 Jul 2025 16:42:45 +0200
Message-ID: <20250703144014.238185357@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 40f970ba7a4ab77be2ffe6d50a70416c8876496a ]

We need to take the MES lock.

Reviewed-by: Michael Chen <michael.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
index 5590ad5e8cd76..7164948001e9d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
@@ -836,7 +836,9 @@ int amdgpu_mes_map_legacy_queue(struct amdgpu_device *adev,
 	queue_input.mqd_addr = amdgpu_bo_gpu_offset(ring->mqd_obj);
 	queue_input.wptr_addr = ring->wptr_gpu_addr;
 
+	amdgpu_mes_lock(&adev->mes);
 	r = adev->mes.funcs->map_legacy_queue(&adev->mes, &queue_input);
+	amdgpu_mes_unlock(&adev->mes);
 	if (r)
 		DRM_ERROR("failed to map legacy queue\n");
 
@@ -859,7 +861,9 @@ int amdgpu_mes_unmap_legacy_queue(struct amdgpu_device *adev,
 	queue_input.trail_fence_addr = gpu_addr;
 	queue_input.trail_fence_data = seq;
 
+	amdgpu_mes_lock(&adev->mes);
 	r = adev->mes.funcs->unmap_legacy_queue(&adev->mes, &queue_input);
+	amdgpu_mes_unlock(&adev->mes);
 	if (r)
 		DRM_ERROR("failed to unmap legacy queue\n");
 
@@ -886,7 +890,9 @@ int amdgpu_mes_reset_legacy_queue(struct amdgpu_device *adev,
 	queue_input.vmid = vmid;
 	queue_input.use_mmio = use_mmio;
 
+	amdgpu_mes_lock(&adev->mes);
 	r = adev->mes.funcs->reset_legacy_queue(&adev->mes, &queue_input);
+	amdgpu_mes_unlock(&adev->mes);
 	if (r)
 		DRM_ERROR("failed to reset legacy queue\n");
 
@@ -916,7 +922,9 @@ uint32_t amdgpu_mes_rreg(struct amdgpu_device *adev, uint32_t reg)
 		goto error;
 	}
 
+	amdgpu_mes_lock(&adev->mes);
 	r = adev->mes.funcs->misc_op(&adev->mes, &op_input);
+	amdgpu_mes_unlock(&adev->mes);
 	if (r)
 		DRM_ERROR("failed to read reg (0x%x)\n", reg);
 	else
@@ -944,7 +952,9 @@ int amdgpu_mes_wreg(struct amdgpu_device *adev,
 		goto error;
 	}
 
+	amdgpu_mes_lock(&adev->mes);
 	r = adev->mes.funcs->misc_op(&adev->mes, &op_input);
+	amdgpu_mes_unlock(&adev->mes);
 	if (r)
 		DRM_ERROR("failed to write reg (0x%x)\n", reg);
 
@@ -971,7 +981,9 @@ int amdgpu_mes_reg_write_reg_wait(struct amdgpu_device *adev,
 		goto error;
 	}
 
+	amdgpu_mes_lock(&adev->mes);
 	r = adev->mes.funcs->misc_op(&adev->mes, &op_input);
+	amdgpu_mes_unlock(&adev->mes);
 	if (r)
 		DRM_ERROR("failed to reg_write_reg_wait\n");
 
@@ -996,7 +1008,9 @@ int amdgpu_mes_reg_wait(struct amdgpu_device *adev, uint32_t reg,
 		goto error;
 	}
 
+	amdgpu_mes_lock(&adev->mes);
 	r = adev->mes.funcs->misc_op(&adev->mes, &op_input);
+	amdgpu_mes_unlock(&adev->mes);
 	if (r)
 		DRM_ERROR("failed to reg_write_reg_wait\n");
 
@@ -1687,7 +1701,9 @@ static int amdgpu_mes_set_enforce_isolation(struct amdgpu_device *adev,
 		goto error;
 	}
 
+	amdgpu_mes_lock(&adev->mes);
 	r = adev->mes.funcs->misc_op(&adev->mes, &op_input);
+	amdgpu_mes_unlock(&adev->mes);
 	if (r)
 		dev_err(adev->dev, "failed to change_config.\n");
 
-- 
2.39.5



