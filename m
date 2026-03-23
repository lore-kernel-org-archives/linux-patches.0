Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DBB26B742;
	Mon, 23 Mar 2026 15:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278519; cv=none; b=Gtew6KJnb2wlng0KW0puZTIkrHsiiItGvj6/Q8ynB1D3TRRN0S7ZBKWj3vrIDL6Q5VprZ9aO7UUGZX5M+x4nE9ATSmQFMCCwlQ+RzohZFuF3fBQM8SD5Rg9kjWcDE25Y7OYvNWTAWI03/dSua6k6eMcw6bKy3MH98G/4Odgk+oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278519; c=relaxed/simple;
	bh=/ZC7g5KJ08ibVLlLmP2Ro8wnlt84oYV3M1pMMyTYoGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+bpIQg7pyHpdWb6BcCMJF1wBdMxowx1hPjyBPAV5bpwcjx30LdsHkgc4KbdN0DiwNVqa5AE9B3ygSShIbd/w2WoClhDPF6KVx59hmpk3AvrHYu4KfcZGTp/z54FBFYi4sZION1ADCnahODqm4fYjI9FhibIAdC9a9t9cdaPdu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hGjy6zf/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hGjy6zf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78606C4CEF7;
	Mon, 23 Mar 2026 15:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278518;
	bh=/ZC7g5KJ08ibVLlLmP2Ro8wnlt84oYV3M1pMMyTYoGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hGjy6zf/OpWfxMk14kP/SGVYDntuvH4kA9XpIM/d7qFevYdKq6cM3G7hLwfUeF/z6
	 U1WxODayXAByEadVrpq/G1o7a5TdT3Hr7r0YTvGCOxUM3g14uS6d7oOQUNVTYtm+ft
	 2Ipih93Att+duHRyrVH7G2G5M/hlTHHG6sFJgk5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alysa Liu <Alysa.Liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 334/567] drm/amdgpu: Fix use-after-free race in VM acquire
Date: Mon, 23 Mar 2026 14:44:14 +0100
Message-ID: <20260323134542.094939410@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1351,7 +1351,10 @@ static int init_kfd_vm(struct amdgpu_vm
 		*ef = dma_fence_get(&info->eviction_fence->base);
 	}
 
-	vm->process_info = *process_info;
+	if (cmpxchg(&vm->process_info, NULL, *process_info) != NULL) {
+		ret = -EINVAL;
+		goto already_acquired;
+	}
 
 	/* Validate page directory and attach eviction fence */
 	ret = amdgpu_bo_reserve(vm->root.bo, true);
@@ -1389,6 +1392,7 @@ validate_pd_fail:
 	amdgpu_bo_unreserve(vm->root.bo);
 reserve_pd_fail:
 	vm->process_info = NULL;
+already_acquired:
 	if (info) {
 		/* Two fence references: one in info and one in *ef */
 		dma_fence_put(&info->eviction_fence->base);


