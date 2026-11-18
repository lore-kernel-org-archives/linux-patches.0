Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038660;
	b=yc6HQg6LLH9ES9OGI+5sR3NMq3GtCqTEYJIixnL6jUoLgN+t1f9PamG46c2L+E+xZwV9
	 b0ogvvhGCaHjg6AJNfXX3R75levxyXb7JHOI1u4Z1enhIscnEYkp70sNeWkYPMlV5q9k+
	 Dhw7OuQagszIo4XxmmioUtUFXW4o9rf3uULt0B9069ImWU7UiBSrDmlO+tRmvZpnsEsoA
	 tZo1SN3aKOMwJi3H01ibcgtTFJqsXkgXNpinfvpf/efr3EjMvB0REXC+M3GHPdwaBGgzn
	 609Lqk9G564k9nrRE04l+uz4EzZtaoXhE49+zMU3qhZsxvEc6KzoySLfZoH5iD79dkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038660;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z/7+MT5bkzJwGugg4sQqBU9AmB4tH6CkqU2iw/dGrLg=;
	b=YdnjXLnq4rYLg9iSLYsVf3z2pRfch2nwt0z08FAmUHjeL6YxSu8UUgi9WYq5au7cutXh
	 FAOF1qOBzt/i+9YTM5BkIAwggRumAJKLYf3uF1QLUyjTM8iQL0vSx7w0p3YXJ+vvyoRak
	 k2lGbBjO9btWjj7y90Zvz76ck74JqGrf+KDtcwj+7U4HpN9StlOHgS2KYwaewpEVRMkj3
	 jY40Nzz5J8FLQCm90aqeTLEQ0Y1OEVIBz2oiJNA70R+W5tQQ2IHpA9pYqC6G1fePWhLRu
	 adM7msGp+A7I9xyCiaPyDUJsR7LrdXmsfkhuTwbini6NA/UqfmA1SnmQ7SNLf0DA2Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s7V5gqx8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E4A606A31C;
	Wed, 18 Nov 2026 21:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s7V5gqx8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4B81F000C4;
	Wed, 18 Nov 2026 21:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038660;
	bh=z/7+MT5bkzJwGugg4sQqBU9AmB4tH6CkqU2iw/dGrLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s7V5gqx8qPQVdGMc+KvERFhXQPEKFd9RhnU8buPIiiMM1ypQDk2zGct2VJXOFyH3k
	 NCggxXgKNaRh7BEGvoUPXwVhpeUbAUUD6HcHtNBLHq7hgzIaAWCrkmqyazeNofoyUy
	 /d8wyp4rn6Ealz7zXhkaS5tVgwgKRzVzP2hA+zD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Phillips <daniel.phillips@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1785/3318] amdkfd: Fix memory availability double accounting of kfd pinned objects
Date: Wed, 18 Nov 2026 15:40:07 +0100
Message-ID: <20261118150415.407029760@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Phillips <daniel.phillips@amd.com>

[ Upstream commit 16df12d7158fb55f20d6e985abd1996cbabab9f8 ]

Pinned objects that are not kfd objects reduce the total vram available
to kfd, so we subtract the total size of pinned objects from kdf vram
availability. However this double counts objects pinned by kfd itself,
because they are counted both as used and pinned. So track the total
size of objects pinned by kfd and add it back to kfd availability to
remove the double accounting.

Signed-off-by: Daniel Phillips <daniel.phillips@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b8257bdb26ca5d9a75f4b81f629422f17afa221b)
Cc: stable@vger.kernel.org
[ sashal: Adjusted context for the missing out label and the simpler VRAM calculation without APU branching or RAS accounting. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h       |  1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index 8fc55a6671841..1be8c4a676096 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -100,6 +100,7 @@ struct amdgpu_kfd_dev {
 	struct kfd_dev *dev;
 	int64_t vram_used[MAX_XCP];
 	uint64_t vram_used_aligned[MAX_XCP];
+	atomic64_t vram_pinned;
 	bool init_complete;
 	struct work_struct reset_work;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index b2c5f99b2e57a..8237772ca9426 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1432,6 +1432,11 @@ static int amdgpu_amdkfd_gpuvm_pin_bo(struct amdgpu_bo *bo, u32 domain)
 		pr_err("Error in Pinning BO to domain: %d\n", domain);
 
 	amdgpu_bo_sync_wait(bo, AMDGPU_FENCE_OWNER_KFD, false);
+
+	if (!ret && bo->tbo.resource->mem_type == TTM_PL_VRAM)
+		atomic64_add(amdgpu_bo_size(bo),
+			&amdgpu_ttm_adev(bo->tbo.bdev)->kfd.vram_pinned);
+
 	amdgpu_bo_unreserve(bo);
 
 	return ret;
@@ -1454,6 +1459,11 @@ static void amdgpu_amdkfd_gpuvm_unpin_bo(struct amdgpu_bo *bo)
 		return;
 
 	amdgpu_bo_unpin(bo);
+
+	if (bo->tbo.resource->mem_type == TTM_PL_VRAM)
+		atomic64_sub(amdgpu_bo_size(bo),
+			&amdgpu_ttm_adev(bo->tbo.bdev)->kfd.vram_pinned);
+
 	amdgpu_bo_unreserve(bo);
 }
 
@@ -1610,6 +1620,7 @@ size_t amdgpu_amdkfd_get_available_memory(struct amdgpu_device *adev,
 	vram_available = KFD_XCP_MEMORY_SIZE(adev, xcp_id)
 		- adev->kfd.vram_used_aligned[xcp_id]
 		- atomic64_read(&adev->vram_pin_size)
+		+ atomic64_read(&adev->kfd.vram_pinned)
 		- reserved_for_pt;
 
 	if (adev->gmc.is_app_apu) {
-- 
2.53.0



