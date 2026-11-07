Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063582;
	b=BcRy7N3bSX+A9i3csr2D0FkVrxCtGY87DHTRSkhtlWFS/DN/3JZ4K10Ky8V2ANjSYPob
	 jpyUegWTlvTSYU1a69LVjpLYJilHJLbzPnnyHoi89XzxVDoqdzzN6KEBPxYQme+vaaO/d
	 yMtZzBBJBpvvNUmB5OVwyAg+fxHGxH9Zm3UtHLKQos5AXHp+bBNDrVioIVU0/DlHzjGQW
	 5ff3eJJRhYDoRGYBD1QmynjHWNjyaNzF/nN9FuRYKNUW82/QAWw0cqd4JrrNDOrh9nYrA
	 6scCPLWRGRZjZd3q5FaBbJ19/vj6JBf3H3pm8EIzeiVE/yszI+EBPVSJ6IIBODDArsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063582;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fKRf2uXzIHiSUJJZPfxMayh15wiTg710pkSeVwGzlt8=;
	b=vER+Q7bujXEMnvYsd4zlzj6Egkd1CVQNN9TvvCgDLPgkEyPiJ/vGpjUZxogqv/p9YTJA
	 Demgv3KS3UO2ducktBnZCKHeO7o6ii79gIyf21ljVFvzNWQ44TpIdJMtg2LdK3Aynf6AA
	 PqOtgo5Ne3QeIftfhmB1iUoP+m3TiIScGVa8xWWvKdQZfkZsbqUzjWHtQ0aHuBnaa97K4
	 38k8X8Gsq7+VGpOR2jsEwHVozVYEbTIXI5PncuKEvuv715xqwQmmYr4G7IK8jgP51Crmz
	 hHWHDAU/iyhx1O2dikjSUv/hiXzSqlWmPaDG5RZkev1n3DNH4eoCHRic3zie8O+u7vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VJsk1XBz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003C960A263F;
	Sat,  7 Nov 2026 14:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VJsk1XBz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F02D1F008A3;
	Sat,  7 Nov 2026 14:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063581;
	bh=fKRf2uXzIHiSUJJZPfxMayh15wiTg710pkSeVwGzlt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VJsk1XBzLl47+VPgHluQqPKaoHDdxQjXA6gAoJCoBojoayL3/zUFRuBSSpUPBsvvb
	 jreySN09katYoq+v2SVIdyPAdhENAL0UBwC5WYztLya4WjBTdPG1ExsCcbdFXihl77
	 ZVY5zeu44aaKL+mutujw3wbL3mLFhtPDkX72HAvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Phillips <daniel.phillips@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 683/869] amdkfd: Fix memory availability double accounting of kfd pinned objects
Date: Sat,  7 Nov 2026 08:56:05 -0500
Message-ID: <20261107134916.210387104@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h       |  1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index c59b5d9cd36b6..b15798489af0c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -104,6 +104,7 @@ struct amdgpu_kfd_dev {
 	struct kfd_dev *dev;
 	int64_t vram_used[MAX_XCP];
 	uint64_t vram_used_aligned[MAX_XCP];
+	atomic64_t vram_pinned;
 	bool init_complete;
 	struct work_struct reset_work;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index d56728b257f49..bf4cea36d3ad4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1518,6 +1518,11 @@ static int amdgpu_amdkfd_gpuvm_pin_bo(struct amdgpu_bo *bo, u32 domain)
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
@@ -1540,6 +1545,11 @@ static void amdgpu_amdkfd_gpuvm_unpin_bo(struct amdgpu_bo *bo)
 		return;
 
 	amdgpu_bo_unpin(bo);
+
+	if (bo->tbo.resource->mem_type == TTM_PL_VRAM)
+		atomic64_sub(amdgpu_bo_size(bo),
+			&amdgpu_ttm_adev(bo->tbo.bdev)->kfd.vram_pinned);
+
 	amdgpu_bo_unreserve(bo);
 }
 
@@ -1661,6 +1671,7 @@ size_t amdgpu_amdkfd_get_available_memory(struct amdgpu_device *adev,
 		vram_available = KFD_XCP_MEMORY_SIZE(adev, xcp_id)
 			- adev->kfd.vram_used_aligned[xcp_id]
 			- atomic64_read(&adev->vram_pin_size)
+			+ atomic64_read(&adev->kfd.vram_pinned)
 			- reserved_for_pt
 			- reserved_for_ras;
 
-- 
2.53.0



