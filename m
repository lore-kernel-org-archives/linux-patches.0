Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7947828EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB59CC433EF;
	Mon, 30 Jan 2023 14:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087433;
	bh=67/+PveVQo0kseaAnuvU5gi+av7iXo0LgzJR7sULXe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ehhTs/fOItKbPqB7QfsRUE9Z8UvNQZgahvXGvZ1k7IowOgvdcZyDqfE40TueXK6tm
	 I+Ss31tJd2e0JwJsA9HmDxvAv4dZe5u326FmBNnS4L6FR0l0B/ShNkmcIomOLRsN+C
	 XquvBGJX/YEWcVs+8fNDtE4ta2znwNc/3B3NKDsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <jinhuieric.huang@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 175/313] drm/amdkfd: Fix NULL pointer error for GC 11.0.1 on mGPU
Date: Mon, 30 Jan 2023 14:50:10 +0100
Message-Id: <20230130134344.842290742@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Huang <jinhuieric.huang@amd.com>

[ Upstream commit a6941f89d7c6a6ba49316bbd7da2fb2f719119a7 ]

The point bo->kfd_bo is NULL for queue's write pointer BO
when creating queue on mGPU. To avoid using the pointer
fixes the error.

Signed-off-by: Eric Huang <jinhuieric.huang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c      | 2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 29f045079a3e..404c839683b1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -2130,7 +2130,7 @@ int amdgpu_amdkfd_map_gtt_bo_to_gart(struct amdgpu_device *adev, struct amdgpu_b
 	}
 
 	amdgpu_amdkfd_remove_eviction_fence(
-		bo, bo->kfd_bo->process_info->eviction_fence);
+		bo, bo->vm_bo->vm->process_info->eviction_fence);
 
 	amdgpu_bo_unreserve(bo);
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index ecb4c3abc629..c06ada0844ba 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -200,7 +200,7 @@ static int add_queue_mes(struct device_queue_manager *dqm, struct queue *q,
 	queue_input.wptr_addr = (uint64_t)q->properties.write_ptr;
 
 	if (q->wptr_bo) {
-		wptr_addr_off = (uint64_t)q->properties.write_ptr - (uint64_t)q->wptr_bo->kfd_bo->va;
+		wptr_addr_off = (uint64_t)q->properties.write_ptr & (PAGE_SIZE - 1);
 		queue_input.wptr_mc_addr = ((uint64_t)q->wptr_bo->tbo.resource->start << PAGE_SHIFT) + wptr_addr_off;
 	}
 
-- 
2.39.0



