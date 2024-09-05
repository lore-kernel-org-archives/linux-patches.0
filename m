Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061511990BB;
	Thu,  5 Sep 2024 09:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529693; cv=none; b=GOLjIIMlTghJHkEoh/eWXfsaf5ayf2A4L4upkeefYRr1t/sLG4flh6dBPjPO5U5QujB+B2b9W9a5ywkPZf9siBjfEnwo7zU/e20TEY8ky7RHmVpKvgoh5mlsxlMOFvXKPY3F4oTLJSWza8VY5wz8NBmBkT+54Zk9fZ/oInJ634U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529693; c=relaxed/simple;
	bh=FY+r0V4xcDIO/h50dSEiarT1Z7lCtOjpoE8BCPBb/tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjlcJPs0/EkBTP5Bq8i9fA9PCBS8gSEBNXE7HOqmLYznOBP0acmi57gL1CI1JcYCUwYRCg0HbZWC6ENgmyuI5EjA6ijcKUCg+G8OXSG+ULPyoK2VK+BAOAV74Qy5dHDlr/vfUdhhnCX+f5XsSlU6CJrwtv59sauMLDMWo5b0eTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mxvbZFTS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mxvbZFTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8233AC4CEC3;
	Thu,  5 Sep 2024 09:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529692;
	bh=FY+r0V4xcDIO/h50dSEiarT1Z7lCtOjpoE8BCPBb/tI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mxvbZFTSAh0w6My1L7kesozwAFA13T1S0fF9jlUQKWXitLU9xrKgwjmBXxIax0xET
	 m7qdyKUj/ftx6DoN84YnArEQoc9f4BRZtKTGMTbsDwbXfL2Wm8lkgAFN7j1LVrP8PC
	 yvmQl6VUtlkZM+lbN2EoM7x6aluncd2GY2swUe7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <Xiaogang.Chen@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 113/184] drm/kfd: Correct pinned buffer handling at kfd restore and validate process
Date: Thu,  5 Sep 2024 11:40:26 +0200
Message-ID: <20240905093736.643032425@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaogang Chen <xiaogang.chen@amd.com>

[ Upstream commit f326d7cc745683f53052b84382bd10567b45cd5d ]

This reverts commit 8a774fe912ff ("drm/amdgpu: avoid restore process run into dead loop")
since buffer got pinned is not related whether it needs mapping
And skip buffer validation at kfd driver if the buffer has been pinned.

Signed-off-by: Xiaogang Chen <Xiaogang.Chen@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 48ad0c04aa72..e675e4815650 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -415,6 +415,10 @@ static int amdgpu_amdkfd_bo_validate(struct amdgpu_bo *bo, uint32_t domain,
 		 "Called with userptr BO"))
 		return -EINVAL;
 
+	/* bo has been pinned, not need validate it */
+	if (bo->tbo.pin_count)
+		return 0;
+
 	amdgpu_bo_placement_from_domain(bo, domain);
 
 	ret = ttm_bo_validate(&bo->tbo, &bo->placement, &ctx);
@@ -2712,7 +2716,7 @@ static int confirm_valid_user_pages_locked(struct amdkfd_process_info *process_i
 
 		/* keep mem without hmm range at userptr_inval_list */
 		if (!mem->range)
-			 continue;
+			continue;
 
 		/* Only check mem with hmm range associated */
 		valid = amdgpu_ttm_tt_get_user_pages_done(
@@ -2957,9 +2961,6 @@ int amdgpu_amdkfd_gpuvm_restore_process_bos(void *info, struct dma_fence __rcu *
 			if (!attachment->is_mapped)
 				continue;
 
-			if (attachment->bo_va->base.bo->tbo.pin_count)
-				continue;
-
 			kfd_mem_dmaunmap_attachment(mem, attachment);
 			ret = update_gpuvm_pte(mem, attachment, &sync_obj);
 			if (ret) {
-- 
2.43.0



