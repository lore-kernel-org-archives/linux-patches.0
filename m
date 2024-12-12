Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C357A217F29;
	Thu, 12 Dec 2024 15:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017413; cv=none; b=Z03n5PVj2GAEBZjelqPBbxUv91EVkho5eet8/ICpQ4vwzHc97HxToakW8xMvNHdxv3e92jhrfbjeseFSjo96pOfH8IgPL+MNiBeEAmUJQwRsqUgKbR4s/XSm5SywXP0XUMMpdpTpvQMk9iW5Msgeqc4iWKlFSub7eAxpKiDuGYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017413; c=relaxed/simple;
	bh=8VSSiezTJ+CGseyN7fCqou2pCfH4YVW8y8umHLCbXAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OJtesK+X2iXDhaubGg6bL+P/rGA2ATKHjRfjP1d+Lmmg8uWG+A0uWHXSd8mHmgfsZf3qObk804gApIbiAnN612xHjOKhfYjpyPvyD5SGD1HUIWSrFyBoVBIzGTMJcpf6bStU2y2cf/Udq/oZfPRoi1cCFSO/lUsRAFYnR0OKbhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oWCM/LrM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oWCM/LrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A28BC4CECE;
	Thu, 12 Dec 2024 15:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017413;
	bh=8VSSiezTJ+CGseyN7fCqou2pCfH4YVW8y8umHLCbXAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oWCM/LrMp7i+qAxosE4HkzAUiUHJO244y4+ZHbLLiFC+4NdFUb7TJGRTQ8zN4yO7d
	 oWI9rkJJKUu1EPYIY1fEKr789FXBu0eBkTj0/aX3N7KnOwggeDL8/Er1kuQxCeh8d+
	 An5dWjK0LKJP5kpu8beuZdoAsD3j8nnfFUZ+2RN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 461/466] drm/amdgpu: rework resume handling for display (v2)
Date: Thu, 12 Dec 2024 16:00:30 +0100
Message-ID: <20241212144325.081964604@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 73dae652dcac776296890da215ee7dec357a1032 upstream.

Split resume into a 3rd step to handle displays when DCC is
enabled on DCN 4.0.1.  Move display after the buffer funcs
have been re-enabled so that the GPU will do the move and
properly set the DCC metadata for DCN.

v2: fix fence irq resume ordering

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.11.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |   45 +++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3666,7 +3666,7 @@ static int amdgpu_device_ip_resume_phase
  *
  * @adev: amdgpu_device pointer
  *
- * First resume function for hardware IPs.  The list of all the hardware
+ * Second resume function for hardware IPs.  The list of all the hardware
  * IPs that make up the asic is walked and the resume callbacks are run for
  * all blocks except COMMON, GMC, and IH.  resume puts the hardware into a
  * functional state after a suspend and updates the software state as
@@ -3684,6 +3684,7 @@ static int amdgpu_device_ip_resume_phase
 		if (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_COMMON ||
 		    adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GMC ||
 		    adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_IH ||
+		    adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_DCE ||
 		    adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_PSP)
 			continue;
 		r = adev->ip_blocks[i].version->funcs->resume(adev);
@@ -3699,6 +3700,36 @@ static int amdgpu_device_ip_resume_phase
 }
 
 /**
+ * amdgpu_device_ip_resume_phase3 - run resume for hardware IPs
+ *
+ * @adev: amdgpu_device pointer
+ *
+ * Third resume function for hardware IPs.  The list of all the hardware
+ * IPs that make up the asic is walked and the resume callbacks are run for
+ * all DCE.  resume puts the hardware into a functional state after a suspend
+ * and updates the software state as necessary.  This function is also used
+ * for restoring the GPU after a GPU reset.
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+static int amdgpu_device_ip_resume_phase3(struct amdgpu_device *adev)
+{
+	int i, r;
+
+	for (i = 0; i < adev->num_ip_blocks; i++) {
+		if (!adev->ip_blocks[i].status.valid || adev->ip_blocks[i].status.hw)
+			continue;
+		if (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_DCE) {
+			r = adev->ip_blocks[i].version->funcs->resume(adev);
+			if (r)
+				return r;
+		}
+	}
+
+	return 0;
+}
+
+/**
  * amdgpu_device_ip_resume - run resume for hardware IPs
  *
  * @adev: amdgpu_device pointer
@@ -3727,6 +3758,13 @@ static int amdgpu_device_ip_resume(struc
 	if (adev->mman.buffer_funcs_ring->sched.ready)
 		amdgpu_ttm_set_buffer_funcs_status(adev, true);
 
+	if (r)
+		return r;
+
+	amdgpu_fence_driver_hw_init(adev);
+
+	r = amdgpu_device_ip_resume_phase3(adev);
+
 	return r;
 }
 
@@ -4809,7 +4847,6 @@ int amdgpu_device_resume(struct drm_devi
 		dev_err(adev->dev, "amdgpu_device_ip_resume failed (%d).\n", r);
 		goto exit;
 	}
-	amdgpu_fence_driver_hw_init(adev);
 
 	if (!adev->in_s0ix) {
 		r = amdgpu_amdkfd_resume(adev, adev->in_runpm);
@@ -5431,6 +5468,10 @@ int amdgpu_do_asic_reset(struct list_hea
 				if (tmp_adev->mman.buffer_funcs_ring->sched.ready)
 					amdgpu_ttm_set_buffer_funcs_status(tmp_adev, true);
 
+				r = amdgpu_device_ip_resume_phase3(tmp_adev);
+				if (r)
+					goto out;
+
 				if (vram_lost)
 					amdgpu_device_fill_reset_magic(tmp_adev);
 


