Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E22124DCF6;
	Mon, 13 Apr 2026 16:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097530; cv=none; b=nUHw6yuyFCzP9+c2k2E2gJfIrqXC7DMN3jGt7n/ZmeCPKPWmVBMhNLR82S4UMe568jAKqT9K/wdr/eUTD1V9IDIt95W1rJhI/CjTbl0IyFBXv+2YuNBoH3k4oNxaE93zvtTF2Xt7INjDPlVNhtEmwT+Z274J1rAZY2fSiIj0QRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097530; c=relaxed/simple;
	bh=Nl43DGo1ZVtpUHDIjBmRNjk5IxEyoT2prxHfPkEhcss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enZ0AHzThIIe/XcWNUT+8MibmoQAYVGNUkqmQqZUSwiOnSoA1VCIU0U/vmz2SxdJZZHYg5aFaSKTA3G1es2Mp4VTzks/pTct4Mkp9XgSrITj/v1DH3QLoMAZhbXln7f5GcDnWb3mOV8REUF/ucFa/OmunPR5NxvSzFg6mGpzZIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STwzWS+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STwzWS+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15776C2BCAF;
	Mon, 13 Apr 2026 16:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097530;
	bh=Nl43DGo1ZVtpUHDIjBmRNjk5IxEyoT2prxHfPkEhcss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STwzWS+68Kk/NHk3RJnQ4vnPtF1dkeD9rmXnezOmUlB1/a6vQtU+u+WXSwtoofPYj
	 EpBJyULm0zh650xzCsjKjnKcRMTQB2DPxQel8kJkfxrFMoriEYS+i4B9SdGmvgn5ca
	 KlezmI6sdmDMqGLgbfOxmw5pwo5IxFQOzQYeojh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alysa Liu <Alysa.Liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 173/570] drm/amdgpu: Fix use-after-free race in VM acquire
Date: Mon, 13 Apr 2026 17:55:04 +0200
Message-ID: <20260413155836.934727791@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alysa Liu <Alysa.Liu@amd.com>

commit 2c1030f2e84885cc58bffef6af67d5b9d2e7098f upstream.

Replace non-atomic vm->process_info assignment with cmpxchg()
to prevent race when parent/child processes sharing a drm_file
both try to acquire the same VM after fork().

Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alysa Liu <Alysa.Liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c7c573275ec20db05be769288a3e3bb2250ec618)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1218,7 +1218,10 @@ static int init_kfd_vm(struct amdgpu_vm
 		*ef = dma_fence_get(&info->eviction_fence->base);
 	}
 
-	vm->process_info = *process_info;
+	if (cmpxchg(&vm->process_info, NULL, *process_info) != NULL) {
+		ret = -EINVAL;
+		goto already_acquired;
+	}
 
 	/* Validate page directory and attach eviction fence */
 	ret = amdgpu_bo_reserve(vm->root.bo, true);
@@ -1255,6 +1258,7 @@ validate_pd_fail:
 	amdgpu_bo_unreserve(vm->root.bo);
 reserve_pd_fail:
 	vm->process_info = NULL;
+already_acquired:
 	if (info) {
 		/* Two fence references: one in info and one in *ef */
 		dma_fence_put(&info->eviction_fence->base);


