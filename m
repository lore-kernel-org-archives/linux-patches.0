Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3A7355049
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301031; cv=none; b=pJ+RUtJj+cANhzGNeqKh5UIL8psmuYX+XCdEPhA5V6kON1112C0qqWfVMdhisWU5Fnk6Zrgzx7HRyKxZ/XpjQsy6SddNhFe3h9hwN5dlH2O2VODT888im00jeqz8L58mrsRpmEAtQI3oiOix5hLDTPJQMznJNlOLRKCYlALacyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301031; c=relaxed/simple;
	bh=cW6h37vc1Blkw8+wg70LvG34prFAa822qIi5ciIZLqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d7Mte4ET/YeY0EXS4xkZeFus8f9I4d4ywXyUmh79TpsZDxS8mjz2uLTFl43SI+ieJtnuSvfgJhN/EKVzLzBMZkcWJukWfR9750F4AuOO62EfpDXIlAudkzFFEYisCX63hGscmE6orQF0e32y93ZDU38mlWqjACoF8lbqRHCqIy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BxFkHnCi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BxFkHnCi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E407EC116D0;
	Sat, 28 Feb 2026 17:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301030;
	bh=cW6h37vc1Blkw8+wg70LvG34prFAa822qIi5ciIZLqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BxFkHnCi1ofYNuiR5nSGzE4dYCdZNawlTN+Q7ZOvgo4QUVKXojIspjDJSrg1P0wQM
	 pYKsSuPRiLtOkPD4DLdD5imwEw8RVssNKp7T/Fi49Kb+2oVBDTjCWvZdPMivBQ54Mj
	 mGN7P+Uw7nvUSBx4rGhsXErK4/o4TatajdARJAveHdrGsaf4OMzHzat2ert2yfcuSs
	 CfwtN1GO6u5nvM1i1pTO2nbqNa+ovvLFu7yuF88cO0yUNOzPZzMPkO6ihhHAr0jS4t
	 KB0u4l1OhFHrLHj/Qv5dJd7DZbzgTvnEu1tZyRZY+eEVsMnqV28pe84neyRNbVRhUD
	 Edka9P/KdlQag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Donet Tom <donettom@linux.ibm.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Philip Yang <Philip.Yang@amd.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 168/752] drm/amdkfd: Fix GART PTE for non-4K pagesize in svm_migrate_gart_map()
Date: Sat, 28 Feb 2026 12:37:59 -0500
Message-ID: <20260228174750.1542406-168-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index 59a5a3fea65df..ea8377071c390 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -62,7 +62,7 @@ svm_migrate_gart_map(struct amdgpu_ring *ring, u64 npages,
 	*gart_addr = adev->gmc.gart_start;
 
 	num_dw = ALIGN(adev->mman.buffer_funcs->copy_num_dw, 8);
-	num_bytes = npages * 8;
+	num_bytes = npages * 8 * AMDGPU_GPU_PAGES_IN_CPU_PAGE;
 
 	r = amdgpu_job_alloc_with_ib(adev, &adev->mman.high_pr,
 				     AMDGPU_FENCE_OWNER_UNDEFINED,
-- 
2.51.0

