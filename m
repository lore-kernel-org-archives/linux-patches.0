Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062626;
	b=cW0r8JHZRGQxb1BQ96xevzhMJqgEakHprcJ0/8MUJcI7r6RKUNeXxGR8y8sctpuelpy7
	 5Rd3Vvugcff5hELdX+ReDwY66WE0DMjmnW2GscwNC488i+k1f4Z8uEfWttRePH7AsCvjA
	 5U/zCfEHl7e4F7GgGzP/63eae1zuqXOUThR3XYvaGX4r3BPeA0ZMVaYQkD8RgTIFz2XeI
	 cl61y4anqxH2HUN+BOezxM33j2Nh9dXzAIj9raw6R4nJ1Nz/hH+NNFSg3JUZIU7MFv2lp
	 bIwy54fF28XOw5jPbbuZZMaJQf5rvvSqVA6e24vt7rvfwDYrFER36cr1CEHzq7UJrDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wZ7zQN4CoKPeK/2wp2hy0Yxn6MZtvHFq5zDqoT1n6EA=;
	b=4+h5Tyu/HqzP/iUSwVtch9e4eqav6/PEUcWym6wdIUvLnSwVw1OVHSRsW2CXIHOyFFfD
	 +ddDQLpG5PFRzLyMYH23PkkTU9ppimpKdREaNO2c/yoO6w3V8WJMnIC4+kmuko8Si1pfE
	 7zLi2YMHxll4ffC72M9HOA65/F0MwrW7fAUYMlGdjv/dL2AnKg3w9rOigb0ztsLp+vgdQ
	 COQPaUB6sP59tvD5pdVElIe/op1Uk2kH0D6j/mKkt8TKxZK5LuJTkCgWBU/iEffgiebtj
	 dwYRBSlr4rLjjShG3liZpnBPbDRf6DmuYI9cvROXkfIJftpDrKTLC3sOtQrb/pZEJkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=soN2UstY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245FD606A659;
	Sat,  7 Nov 2026 14:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=soN2UstY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48ED1F0089F;
	Sat,  7 Nov 2026 14:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062626;
	bh=wZ7zQN4CoKPeK/2wp2hy0Yxn6MZtvHFq5zDqoT1n6EA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=soN2UstYhqZa/C3E5ZnH4aizWOeEQEE9xa8LjBiMW9Mx1KRywJNSGSSWd+AM7i3ki
	 lSyy/Gv1fmIa4eKZ+AKKarWrbk0e6Luyuo7DS7ziN/jo8BhEPTh2fU4se14+TjHsgk
	 OAnql93BhHiX9YG5kpkSniZjmHd8yowuM+PNB9a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <philip.yang@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1497/1536] drm/amdkfd: split vram_pages of SVM ranges prefetched without a GPU mapping
Date: Sat,  7 Nov 2026 08:58:33 -0500
Message-ID: <20261107135039.910062550@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit 52957e813f2f025c86e4aa6e86cb4963ef94fd00 ]

When an SVM range is split, svm_range_split_pages() gives the new range
the number of VRAM pages counted in its part of the dma_addr arrays and
subtracts it from the old range. Pages migrated to VRAM by a prefetch
have no dma_addr entries until the range is mapped on a GPU, e.g. with
no ACCESS attribute, or with XNACK off before the delayed restore worker
mapped it, so the new range gets 0 and the old one keeps the count for
both.

Migrating the parts back to system memory then gets the accounting
wrong: the old part keeps a VRAM page count after all its pages are
gone, so its svm_bo is never freed, and the new part underflows. On
navi31, as an unprivileged process: prefetch 4 MiB to the GPU, prefetch
the upper 2 MiB and then the lower 2 MiB back to system memory:

  Recorded vram pages(0x0) should not be less than migration pages(0x200).
  WARNING: ../amdkfd/kfd_migrate.c:922 at svm_migrate_vram_to_ram+0xbdc/0xcd0 [amdgpu]

and /sys/class/kfd/kfd/proc/<pid>/vram_<gpu_id> stays at 4194304 until
the process exits.

Without dma_addr arrays, the split is still exact when the old range is
completely in VRAM, which is what a prefetch of the whole range leaves.
Give the new range all its pages in that case. The warning is gone and
the VRAM usage drops back to 0.

This doesn't cover a range that is only partly in VRAM without dma_addr
arrays, e.g. after a partial migration, since svm_migrate_ram_to_vram()
only counts the pages it actually migrated. That would need VRAM
residency to be tracked per page independently of dma_addr.

v2:
- Rename counted to has_dma_addr and compare against old->npages (Philip)
- Mention the XNACK off case and the partial migration limitation (Philip)

Fixes: 006ad514a50c ("drm/amdkfd: Use partial hmm page walk during buffer validation in SVM")
Reviewed-by: Philip Yang <philip.yang@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7ca6f3359b557a267c7b07a2fd748b1473395e10)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 27085694697a2..7bbeb9768a56f 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -986,9 +986,12 @@ svm_range_split_pages(struct svm_range *new, struct svm_range *old,
 		      uint64_t start, uint64_t last)
 {
 	uint64_t npages = last - start + 1;
+	bool has_dma_addr = false;
 	int i, r;
 
 	for (i = 0; i < MAX_GPU_INSTANCE; i++) {
+		if (old->dma_addr[i])
+			has_dma_addr = true;
 		r = svm_range_split_array(&new->dma_addr[i], &old->dma_addr[i],
 					  sizeof(*old->dma_addr[i]), old->start,
 					  npages, new->start, new->npages,
@@ -996,8 +999,16 @@ svm_range_split_pages(struct svm_range *new, struct svm_range *old,
 		if (r)
 			return r;
 	}
-	if (old->actual_loc)
+	if (old->actual_loc) {
+		/*
+		 * Pages migrated by prefetch have no dma_addr until they are
+		 * mapped on a GPU. A fully resident range still splits exactly,
+		 * old->npages isn't adjusted yet here.
+		 */
+		if (!has_dma_addr && old->vram_pages == old->npages)
+			new->vram_pages = new->npages;
 		old->vram_pages -= new->vram_pages;
+	}
 
 	return 0;
 }
-- 
2.53.0



