Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4593F54BE;
	Tue, 17 Mar 2026 16:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766699; cv=none; b=Skiur1kPe3u/MhBHYNBLqEPvn6+cUTS3s5svus/6o/US7BmBlJruO8e/3OXubiqXBbMyOkoaUhUSbvjQQvK/prGZy/A6PCQSuIa9Vd9R0yDKDa0Tbn0fUjD2sKtG5pbQ9XXukf7VVqqsWzeENhG1tD5sC06raocBSsytNODtXsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766699; c=relaxed/simple;
	bh=7eyUsU6ZRtujYl8+2X3/6LftD2a3JpyAE4LEgeTt84c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdtEFiKt3C9spytippJqqJ0a1CXf3pLE/gvKoo3vWeuNBtqjwB1m0lW5sOH5c2Zhzf7PTUJA7l3XUL4UU0jSsNLcmCedCSfDNzSYmUGT9nD5INymQQkWccatQVyx1GJX6TZ6JFUCy9lD8BYH1VIp/rjzd9oGuF2fKUykQlWVDHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7kOmK00; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7kOmK00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D90C4CEF7;
	Tue, 17 Mar 2026 16:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766699;
	bh=7eyUsU6ZRtujYl8+2X3/6LftD2a3JpyAE4LEgeTt84c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N7kOmK00FI8i9GYog/3BgCjYJhKpo6JNMDKTOutXvNsNSRQURduIUyegy9ggRm9/W
	 kodcgJmDtcVqAhKCZJeSB45EN8Qy1Bpc6kmL/UR7bMQWjj4lF2KROnCEvz6ANiFTwM
	 7nTCA29+saFm5d6qJ/Nlx2L3ToJ6j2+UM+nupYEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alysa Liu <Alysa.Liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.19 301/378] drm/amdgpu: Fix use-after-free race in VM acquire
Date: Tue, 17 Mar 2026 17:34:18 +0100
Message-ID: <20260317163018.079264233@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1428,7 +1428,10 @@ static int init_kfd_vm(struct amdgpu_vm
 		*process_info = info;
 	}
 
-	vm->process_info = *process_info;
+	if (cmpxchg(&vm->process_info, NULL, *process_info) != NULL) {
+		ret = -EINVAL;
+		goto already_acquired;
+	}
 
 	/* Validate page directory and attach eviction fence */
 	ret = amdgpu_bo_reserve(vm->root.bo, true);
@@ -1468,6 +1471,7 @@ validate_pd_fail:
 	amdgpu_bo_unreserve(vm->root.bo);
 reserve_pd_fail:
 	vm->process_info = NULL;
+already_acquired:
 	if (info) {
 		dma_fence_put(&info->eviction_fence->base);
 		*process_info = NULL;


