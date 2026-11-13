Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591616;
	b=rhGi+LliQsYwrmxKE+FoLCYNCjJyAMuP2wrw2U0dGFtVUS35jKjnOBE1u6SAWmpX1PfM
	 kpnhTVPdbiXV/cb2K0Ul/uTpw+8DYjmQl8saWtPqIjxUreWY5UJgV6upZmiLQ+leJ50W2
	 b1meKHFVQ9GscSWBpUl2ELjLWjgC2mH34t07tXTt8evrUaPpWxsNURGqC0Sjaf9sWxery
	 L3Zibm0Eqj+qGr9jgNFjB57qxCGvFp/oYxgT9x14ravsIHpytoHacEGjJT5buS/nf2xco
	 vPXzU+CpkUceAGcBUXboz+nz/Sw+m+puv9j8Et45D+0DfYk1sPp+/8QFy4SJHGeANMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YMtIihn1Ne7u6mNbT1fAYSE1/aWTH7pgYRTpoFCdrS8=;
	b=ujoxOrSApKuBGfW2vWe43iLtBe34niak0gk0E5J+2DLEpWQm28w0nTh8liV0CHq27c3H
	 T7vQwPfVSL1Xg8xvALncoDUk+19bv5sXL9GfRxYEIY9sNVNN8Iyy0IzTlzehtPtI3Q1uM
	 hHmQPg7Lq8GiGEYAEG4LYPoyzMk5S3gw5QW/f2hoMD0Yky+fQqorPL9Z5Fx41NNkv7Zvn
	 ksr6drYn6bilskl3TwM7KGpZerrpb8gs/TEijZV6uOlI8eT9wJ2EepQisGaM/vANOiuWx
	 9EHOF5ZWFPXgEisNfqwoGHJiP9ORByOyQORjTSQo3OWDqAlXe5SdINut5VUat7J0gpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d8Ojn8Ml;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE18C606F716;
	Fri, 13 Nov 2026 17:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d8Ojn8Ml
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 695071F000C4;
	Fri, 13 Nov 2026 17:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591616;
	bh=YMtIihn1Ne7u6mNbT1fAYSE1/aWTH7pgYRTpoFCdrS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d8Ojn8MlNrycmEnI59ct/Tfuybr9Fou4ddd4z/MdM+DAEQY2tjsWsQVo43bBARJA/
	 6F9tC1UtwF/Vi42tSj/ZSq4zXVk/nnSLO33mzT7h2PJzzN2hYJSXEq6qBz0mPahSo6
	 rGXkW9mJF8icgNJfRtOxKM+inek8Tx0xw115v9ZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Phillips <daniel.phillips@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 605/670] amdkfd: Fix memory availability double accounting of kfd pinned objects
Date: Fri, 13 Nov 2026 10:52:49 -0500
Message-ID: <20261113153832.331023915@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted indentation to fit the unconditional VRAM availability calculation without the upstream APU-specific conditional ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h       |  1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index d79c431de2234..b921587d428cc 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -103,6 +103,7 @@ struct amdgpu_kfd_dev {
 	struct kfd_dev *dev;
 	int64_t vram_used[MAX_XCP];
 	uint64_t vram_used_aligned[MAX_XCP];
+	atomic64_t vram_pinned;
 	bool init_complete;
 	struct work_struct reset_work;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index ef4d8dca3c7af..55834719e9848 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1500,6 +1500,11 @@ static int amdgpu_amdkfd_gpuvm_pin_bo(struct amdgpu_bo *bo, u32 domain)
 		pr_err("Error in Pinning BO to domain: %d\n", domain);
 
 	amdgpu_bo_sync_wait(bo, AMDGPU_FENCE_OWNER_KFD, false);
+
+	if (!ret && bo->tbo.resource->mem_type == TTM_PL_VRAM)
+		atomic64_add(amdgpu_bo_size(bo),
+			&amdgpu_ttm_adev(bo->tbo.bdev)->kfd.vram_pinned);
+
 out:
 	amdgpu_bo_unreserve(bo);
 	return ret;
@@ -1522,6 +1527,11 @@ static void amdgpu_amdkfd_gpuvm_unpin_bo(struct amdgpu_bo *bo)
 		return;
 
 	amdgpu_bo_unpin(bo);
+
+	if (bo->tbo.resource->mem_type == TTM_PL_VRAM)
+		atomic64_sub(amdgpu_bo_size(bo),
+			&amdgpu_ttm_adev(bo->tbo.bdev)->kfd.vram_pinned);
+
 	amdgpu_bo_unreserve(bo);
 }
 
@@ -1681,6 +1691,7 @@ size_t amdgpu_amdkfd_get_available_memory(struct amdgpu_device *adev,
 	vram_available = KFD_XCP_MEMORY_SIZE(adev, xcp_id)
 		- adev->kfd.vram_used_aligned[xcp_id]
 		- atomic64_read(&adev->vram_pin_size)
+		+ atomic64_read(&adev->kfd.vram_pinned)
 		- reserved_for_pt
 		- reserved_for_ras;
 
-- 
2.53.0



