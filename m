Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF1822B581;
	Thu, 12 Dec 2024 16:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021526; cv=none; b=tDonIM2e6/+L8XTNno+CFH6q0e3EsCN6z9wkzHiVbbKW5dP00UWQkqXOrStTeBsX96r9N6MdGo6MR6OgzkYXBwPa9K09PNey35l2nmmX5CRnfh9t2c+gg+hXjj3ihyhkbU0jkx+c3iuCf8wguwfbOKtKOZ+Kuzgsr5DIjKzWUdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021526; c=relaxed/simple;
	bh=ZV8aCbQESAIyccwYQDYD7ICK5HtwOWIV5tkhDjelztE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p/hbCu8sSwQVfuE45PlCe/QV61sRFQ8ceihfJPs1medLm/AWcItHo1qntbfOC+jb1+yoOM5cfqItmESf+qVZFn2gbSWJNks0+QeQxHBY6NEZwn4JJcpX6anvaUoWzCBfCaCx7rfxGSJyiS86hAIWb4HhAusGhRz1NX8kcQlAnhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S45BnSc/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S45BnSc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD78C4CED3;
	Thu, 12 Dec 2024 16:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021526;
	bh=ZV8aCbQESAIyccwYQDYD7ICK5HtwOWIV5tkhDjelztE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S45BnSc/mY282mvbODML/CC2ukKIN0O9qiBoBMN7pbVVvkopfZH1oYSJc7Ryn7qIV
	 zyTdq+MnecFVkDpJFNgZ4scPbztObMgwbqWyRvLP6+6V2qetu+Q//l7aF/EPCesjUT
	 M/TCyemG31KZj4jpAYWdUKBBiUPjctP5KLj5DXy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 763/772] drm/amdgpu: rework resume handling for display (v2)
Date: Thu, 12 Dec 2024 16:01:48 +0100
Message-ID: <20241212144421.471292052@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3242,7 +3242,7 @@ static int amdgpu_device_ip_resume_phase
  *
  * @adev: amdgpu_device pointer
  *
- * First resume function for hardware IPs.  The list of all the hardware
+ * Second resume function for hardware IPs.  The list of all the hardware
  * IPs that make up the asic is walked and the resume callbacks are run for
  * all blocks except COMMON, GMC, and IH.  resume puts the hardware into a
  * functional state after a suspend and updates the software state as
@@ -3260,6 +3260,7 @@ static int amdgpu_device_ip_resume_phase
 		if (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_COMMON ||
 		    adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GMC ||
 		    adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_IH ||
+		    adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_DCE ||
 		    adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_PSP)
 			continue;
 		r = adev->ip_blocks[i].version->funcs->resume(adev);
@@ -3284,6 +3285,36 @@ static int amdgpu_device_ip_resume_phase
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
@@ -3313,6 +3344,13 @@ static int amdgpu_device_ip_resume(struc
 
 	r = amdgpu_device_ip_resume_phase2(adev);
 
+	if (r)
+		return r;
+
+	amdgpu_fence_driver_hw_init(adev);
+
+	r = amdgpu_device_ip_resume_phase3(adev);
+
 	return r;
 }
 
@@ -4311,7 +4349,6 @@ int amdgpu_device_resume(struct drm_devi
 		dev_err(adev->dev, "amdgpu_device_ip_resume failed (%d).\n", r);
 		return r;
 	}
-	amdgpu_fence_driver_hw_init(adev);
 
 	r = amdgpu_device_ip_late_init(adev);
 	if (r)
@@ -5065,6 +5102,10 @@ int amdgpu_do_asic_reset(struct list_hea
 				if (r)
 					goto out;
 
+				r = amdgpu_device_ip_resume_phase3(tmp_adev);
+				if (r)
+					goto out;
+
 				if (vram_lost)
 					amdgpu_device_fill_reset_magic(tmp_adev);
 


