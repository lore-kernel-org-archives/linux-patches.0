Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B663EBF2C;
	Sat, 14 Feb 2026 01:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771030989; cv=none; b=n72P4BcmNsq+SDLV5V66C88RVvjLYOiJuMdIAgv5ng/HT0Eyp+vwOZMAMJWAHZ6yPafh3uvyg4myuUtQES2H1khALzBdKFlICK+2kppAWuj/kPPrCvhHwxintgrUl1RLg9hpW4BGuCofi9U9ITXKuQTI2xmTLyhsYyHakzb2V6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771030989; c=relaxed/simple;
	bh=PLayDhKqDcanYXVlN+N4aQogtWC6XliezDBW70sXeuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B04pXhxyzXmtovZoyKUxC+VuqiEdmDFz45GsxWnueikhbqtW5RcjHe0su1NwCpJpUdkghzF1OrmY3oycBMmHB40O3vtSSZE3Ys31Q7NG4yI5lc1MSxYeCWgttQ6pTiNs92EmVH8OamgTAN+hUHeNDVHH5jj+OKxLcLAlJRgBARU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E1xuw1AG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E1xuw1AG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4795EC16AAE;
	Sat, 14 Feb 2026 01:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771030989;
	bh=PLayDhKqDcanYXVlN+N4aQogtWC6XliezDBW70sXeuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E1xuw1AGsiVSw7oa3qGWgn4Jt+DCPsGjANoz3nQA4J9LOgDfwH+MGlydsN0uHshfw
	 xXNkczADqlYv9HX6qo3iRj+1WOgofNuTp/EX+qAJQ0D55QOp5MZ5RLDLPtAD7LZkNb
	 d0/L/yejMHdkQ65eDP7VfZatue6Uc1aTNzKypNyWhUQemQ+/pN1nqxYfe3ROOD1NFE
	 yzLqZGXn9sZiBfcyEg/3bCov7RlmbW2eobPBPOIQ5LeILqMnkKjfTpUKlB8gIPGu9z
	 n6KdPdtQv9hez13XdGiVR89gixzmSCBDqfUYWLkh/wNUYuJU7dlLwiBljBZbr6klTr
	 pgj05BPBlmdgg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Donet Tom <donettom@linux.ibm.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Philip Yang <Philip.Yang@amd.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	amd-gfx@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.19-5.15] drm/amdkfd: Fix GART PTE for non-4K pagesize in svm_migrate_gart_map()
Date: Fri, 13 Feb 2026 19:58:14 -0500
Message-ID: <20260214010245.3671907-14-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Donet Tom <donettom@linux.ibm.com>

[ Upstream commit 6c160001661b6c4e20f5c31909c722741e14c2d8 ]

In svm_migrate_gart_map(), while migrating GART mapping, the number of
bytes copied for the GART table only accounts for CPU pages. On non-4K
systems, each CPU page can contain multiple GPU pages, and the GART
requires one 8-byte PTE per GPU page. As a result, an incorrect size was
passed to the DMA, causing only a partial update of the GART table.

Fix this function to work correctly on non-4K page-size systems by
accounting for the number of GPU pages per CPU page when calculating the
number of bytes to be copied.

Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Philip Yang <Philip.Yang@amd.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Felix Kuehling <felix.kuehling@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This confirms the issue. At line 362, `amdgpu_gart_map` already
correctly iterates `AMDGPU_GPU_PAGES_IN_CPU_PAGE` times per CPU page
(inner loop `j`). So it generates `npages *
AMDGPU_GPU_PAGES_IN_CPU_PAGE` PTEs (each 8 bytes), totaling `npages * 8
* AMDGPU_GPU_PAGES_IN_CPU_PAGE` bytes. But the DMA copy was only copying
`npages * 8` bytes — a mismatch that results in partial GART updates on
non-4K systems.

### 3. Classification

This is a clear **bug fix** for incorrect DMA size calculation. On
non-4K page systems (common on aarch64 and POWER architectures), only a
fraction of the GART PTEs would be DMA-copied to the GPU page table,
leading to:
- **GPU page faults** when accessing unmapped entries
- **Potential data corruption** if stale GART entries point to wrong
  memory
- **GPU hangs** or crashes during SVM (Shared Virtual Memory) migration

### 4. Scope and Risk Assessment

- **Lines changed**: 1 line (minimal)
- **Files changed**: 1 file
- **Risk**: Very low. On 4K page systems (x86),
  `AMDGPU_GPU_PAGES_IN_CPU_PAGE` = 1, so the behavior is unchanged. The
  fix only affects non-4K systems where it was broken.
- **Subsystem**: AMD KFD (Kernel Fusion Driver) — GPU compute path, used
  for HPC and AI workloads on AMD GPUs

### 5. User Impact

This affects users running:
- AMD GPUs with KFD/ROCm on **aarch64 or POWER** systems (which commonly
  use 64K pages)
- SVM (Shared Virtual Memory) migration operations
- Without this fix, GPU compute workloads would be broken or unreliable
  on non-4K page systems

### 6. Stability Indicators

- Reviewed and acked by 3 AMD DRM maintainers/developers
- The fix is mathematically obvious — the existing `amdgpu_gart_map`
  function already generates `AMDGPU_GPU_PAGES_IN_CPU_PAGE` PTEs per CPU
  page, so the copy size must match
- No-op on 4K page systems, so zero risk of regression for x86

### 7. Dependency Check

The fix uses `AMDGPU_GPU_PAGES_IN_CPU_PAGE` which has been defined in
`amdgpu_gart.h` for a long time. The `svm_migrate_gart_map` function and
the surrounding code exist in all recent stable trees. No additional
dependencies needed.

### Summary

This is a textbook stable backport candidate:
- **Obviously correct**: One-line fix that aligns DMA copy size with the
  actual number of PTEs generated
- **Fixes a real bug**: Partial GART table update on non-4K page systems
- **Small and contained**: Single line change in a single file
- **No new features**: Pure bug fix
- **Low risk**: No-op on 4K (x86) systems; fixes broken behavior on
  non-4K systems
- **Well-reviewed**: Multiple AMD maintainer acks/reviews

**YES**

 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index 6ada7b4af7c68..5086caac3fd06 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -61,7 +61,7 @@ svm_migrate_gart_map(struct amdgpu_ring *ring, u64 npages,
 	*gart_addr = adev->gmc.gart_start;
 
 	num_dw = ALIGN(adev->mman.buffer_funcs->copy_num_dw, 8);
-	num_bytes = npages * 8;
+	num_bytes = npages * 8 * AMDGPU_GPU_PAGES_IN_CPU_PAGE;
 
 	r = amdgpu_job_alloc_with_ib(adev, &adev->mman.high_pr,
 				     AMDGPU_FENCE_OWNER_UNDEFINED,
-- 
2.51.0

