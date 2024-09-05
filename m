Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8385D19413B;
	Thu,  5 Sep 2024 09:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530208; cv=none; b=hkIsxZVb6QsKpZEDjPxLmwajsxT1i+Q8qzPrMa3NVX1PY/JL8b0YrpuhOAuewtsD/TnVZN2dX5TSQv3g7Lpy5d06I8tJ2YVOoFa96SKAYcR8m3BGXxC/Pkf7/kBKvlYKVN8hGjoyCFCmtPf8HYbNvW3JJWr+VuXSNrvX2gutBhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530208; c=relaxed/simple;
	bh=3v2dATf8EPapVefMfZmqadW7I7OrcciaIZXvqGwA0uY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHPlnuxKTCLv7DSP272o2XHm3K96V86X974K1PBPdqPCBCi+2AAremXGZ9dcfO0bHXvKVRYPeLimPvyGgLjr/JkrKUlSbhoNlC1YQyOjvRnE8WhbARfrtPJh7FecPvoh4/DkuSMHzoBSumB+Nis/zlO64m1r1lglt5jv1stYvsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBkiowxc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBkiowxc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0560FC4CEC3;
	Thu,  5 Sep 2024 09:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530208;
	bh=3v2dATf8EPapVefMfZmqadW7I7OrcciaIZXvqGwA0uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBkiowxcVNgDLHAfE6xz75Oq8DWqD5/N5a+I9F8nhL/EUfN9L5bUwkun0mP4Z+2ob
	 7Jyl43wiSsEiJZHeUSGvonL/vBsaignomMTMv0L/6hIpP8NJOrFAWsTBLcLYKYgiKH
	 qsYeQ6yqpj2oTE9vJe4sAYW4cINZHllAz/PlOf5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <Xiaogang.Chen@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/132] drm/kfd: Correct pinned buffer handling at kfd restore and validate process
Date: Thu,  5 Sep 2024 11:41:14 +0200
Message-ID: <20240905093725.631398585@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9d72bb0a0eae..a1f35510d539 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -407,6 +407,10 @@ static int amdgpu_amdkfd_bo_validate(struct amdgpu_bo *bo, uint32_t domain,
 		 "Called with userptr BO"))
 		return -EINVAL;
 
+	/* bo has been pinned, not need validate it */
+	if (bo->tbo.pin_count)
+		return 0;
+
 	amdgpu_bo_placement_from_domain(bo, domain);
 
 	ret = ttm_bo_validate(&bo->tbo, &bo->placement, &ctx);
@@ -2631,7 +2635,7 @@ static int confirm_valid_user_pages_locked(struct amdkfd_process_info *process_i
 
 		/* keep mem without hmm range at userptr_inval_list */
 		if (!mem->range)
-			 continue;
+			continue;
 
 		/* Only check mem with hmm range associated */
 		valid = amdgpu_ttm_tt_get_user_pages_done(
@@ -2848,9 +2852,6 @@ int amdgpu_amdkfd_gpuvm_restore_process_bos(void *info, struct dma_fence **ef)
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



