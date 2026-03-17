Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DADE320CCF;
	Tue, 17 Mar 2026 17:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768325; cv=none; b=nOm/iKN3RbPuTMDq19KD1pEOOYA9u2I6ccXtzaTdJKgDdANnhoVsjMP8kgbXwinlLmN9RCVLABaMdqw3nFcZS9p45i33x05tgBibp0RIbzWLFSMHZnbxulRTsso4CrczxrYOydL9zlyEkK0G7RhCqlwt6O9zW4kMzn8/+6oVRUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768325; c=relaxed/simple;
	bh=eREk0IN2QswGQqwahc3ukXGp2G5kCM3IQbOWveBf30k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1bmhtiXxBFmDdbCucOnRaDgQh6t4NPw6IF4XV4huB53cjd5vsZap91OlYcXfwoyn5e1no8SaBZATgv2hNJmcIGxD2hBuDiVn7gl0vo+g8M8A7bKDujZzh9+w3fEfIW2i1Y+5epqTpK8ijoeiCRWpixzxvBoypso7YsIVsn//+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zL9a/GcL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zL9a/GcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9BCC19424;
	Tue, 17 Mar 2026 17:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768325;
	bh=eREk0IN2QswGQqwahc3ukXGp2G5kCM3IQbOWveBf30k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zL9a/GcLjc7puJfblJZlI+CBongqbM6j2o4x2/RxIjrY434zPqiw/btDr1prPHEuS
	 PivxfU0I8SlM6Z0zreNLYqOhvcY/ibq3apiKYCysAyjhzQzf0mLvForZOGQqYj0G43
	 sB7uJxg7rCqwP70UXFaTjYkFO/1XPXwWIKcjgvOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alysa Liu <Alysa.Liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 251/333] drm/amdgpu: Fix use-after-free race in VM acquire
Date: Tue, 17 Mar 2026 17:34:40 +0100
Message-ID: <20260317163008.676758365@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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
@@ -1421,7 +1421,10 @@ static int init_kfd_vm(struct amdgpu_vm
 		*process_info = info;
 	}
 
-	vm->process_info = *process_info;
+	if (cmpxchg(&vm->process_info, NULL, *process_info) != NULL) {
+		ret = -EINVAL;
+		goto already_acquired;
+	}
 
 	/* Validate page directory and attach eviction fence */
 	ret = amdgpu_bo_reserve(vm->root.bo, true);
@@ -1461,6 +1464,7 @@ validate_pd_fail:
 	amdgpu_bo_unreserve(vm->root.bo);
 reserve_pd_fail:
 	vm->process_info = NULL;
+already_acquired:
 	if (info) {
 		dma_fence_put(&info->eviction_fence->base);
 		*process_info = NULL;


