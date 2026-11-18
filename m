Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047109;
	b=sEyuwlQvhjspfkSV2W96EgGgWym5jzvs5Q8UU9hHk8hSEB/bzHEO2nTH6IqhFV8Ykaty
	 hMxgKEeGd7XJKwMMAzFgVhZCd9kvFCRr1SEoruq95PDiUjjUlpqGjYsLc+Uwb0Hp7Tm+G
	 keIDAWKlJFDzsUV5OjpNHdTzFLnPRALVaN4YkPC92yPL+ZGu1xBvqFo1mfsLH+squboF6
	 brwLh+9g9nt9tJQ+zTM2TC5psoB0xwbcZcog+KwrySa9C0cgeM+1IBKlyCAQP7YaPQ5Lr
	 jIBSr6CT3lb1NO+e3tqK4NpWva9k4EgDHH7fHT8OQFs5JxPNWaYJpK/7hc7w/cgBySQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047109;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qIlRFSo7+gmbevVbD86kP+UvB/to1YOdRxRKbkNjVv0=;
	b=FKJgstQFOy/dTSF/L5BAt4/z8ZWArFsVYZ8aXe1ac7DTbb+M4PUYVJtqZEC6RANLLGEx
	 96XYNYUPrWB5QI5SldhzOl34bczw6URNN+/3Zm84KK0zser56HL2So9upfM5Mw78olBjx
	 ndpU9TUGZ0T0prBxOjA67aYFORZBZNFEOT562xBdYS1Qyg594WsN6GVaDnWuWtwgxM1nn
	 /l1IRtsG+aKA1SpMzBoTjI5oYhZxgxWf/KaYDx3WSesyxRpY4zbwlaLtuY/KqwUEXXMmy
	 twDepSRZQsF4UAcOoPELIcaympHcxwvtMrNft/Bpnszqc55ohieQR+SX6SkXL/L8M7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k6mHB0MY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CCA606A320;
	Thu, 19 Nov 2026 00:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k6mHB0MY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADAED1F000C4;
	Thu, 19 Nov 2026 00:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047109;
	bh=qIlRFSo7+gmbevVbD86kP+UvB/to1YOdRxRKbkNjVv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k6mHB0MYcHLf4+G5ifjsuHboNWIAvMq9VgXvB57J2n4H/atVKIkm5pVCjzvuF7Rdl
	 bWfY58fLrbzo+dR4VGqNFwS5kCRqME7QhsoyS/nEZqYakTTHcfKNJRyDlhOOIhdlWY
	 LfrPrSONrYcV/MEYxmLw1wQMR5zDtGmM4BcZ1V2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Phillips <daniel.phillips@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1522/2857] amdkfd: Fix memory availability double accounting of kfd pinned objects
Date: Wed, 18 Nov 2026 15:42:36 +0100
Message-ID: <20261118150256.126598828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted context for scalar VRAM accounting fields instead of MAX_XCP arrays. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h       |  1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index 86a3315098a20..ba065f7887aad 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -97,6 +97,7 @@ struct amdgpu_kfd_dev {
 	struct kfd_dev *dev;
 	int64_t vram_used;
 	uint64_t vram_used_aligned;
+	atomic64_t vram_pinned;
 	bool init_complete;
 	struct work_struct reset_work;
 };
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 59ea50b0962e5..dd18be88e1b84 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1451,6 +1451,11 @@ static int amdgpu_amdkfd_gpuvm_pin_bo(struct amdgpu_bo *bo, u32 domain)
 		pr_err("Error in Pinning BO to domain: %d\n", domain);
 
 	amdgpu_bo_sync_wait(bo, AMDGPU_FENCE_OWNER_KFD, false);
+
+	if (!ret && bo->tbo.resource->mem_type == TTM_PL_VRAM)
+		atomic64_add(amdgpu_bo_size(bo),
+			&amdgpu_ttm_adev(bo->tbo.bdev)->kfd.vram_pinned);
+
 	amdgpu_bo_unreserve(bo);
 
 	return ret;
@@ -1473,6 +1478,11 @@ static void amdgpu_amdkfd_gpuvm_unpin_bo(struct amdgpu_bo *bo)
 		return;
 
 	amdgpu_bo_unpin(bo);
+
+	if (bo->tbo.resource->mem_type == TTM_PL_VRAM)
+		atomic64_sub(amdgpu_bo_size(bo),
+			&amdgpu_ttm_adev(bo->tbo.bdev)->kfd.vram_pinned);
+
 	amdgpu_bo_unreserve(bo);
 }
 
@@ -1638,6 +1648,7 @@ size_t amdgpu_amdkfd_get_available_memory(struct amdgpu_device *adev)
 	available = adev->gmc.real_vram_size
 		- adev->kfd.vram_used_aligned
 		- atomic64_read(&adev->vram_pin_size)
+		+ atomic64_read(&adev->kfd.vram_pinned)
 		- reserved_for_pt;
 	spin_unlock(&kfd_mem_limit.mem_limit_lock);
 
-- 
2.53.0



