Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063715;
	b=cdPEVKAa5bYxPFkazcwdFB3P5ipglqSF7ZYdeucKxU2Qs4I+vqGm2+HaeEbRNPu2okgj
	 dauMoJhZ9ANfp6pyOdIZVItx1ysidpcq+dwzbk12EdlYCWEeuX+SBDnEwqkHm5F5LHuPZ
	 p43GJrFQXYug56p5sIHXu9uVbtbRzkPgW4T3Wk6BhzZU4umprlqH16AdrOZtuwUUI7q2A
	 xW+dVwSUMYbv3gPtyMA/sc8G3i6jggDIdpB37J16313MSxyo3RGWJGZCDhjIi8Cl4qcpi
	 lTt7UcFd8kVoOZVI8javCY74/n9mG5G8opmbq9KfX4zY5cILL2h2x0tbRxuX/IaR+ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063715;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8D1IBU/vnBy/AgR0vMHSuoC6mP5HUfvxQMFQIc42Wyo=;
	b=Ij4cC24mCX4Z+OA+Mp5LAAsG1+Dkn6XUlaLNTxPqvXlMrq5C+RcN71FmEm98EtlUPBeu
	 Zs4PP9u4DVvO4VkOJRO2np37Ys81905OdRLAMCubC46151iRlg+ia9G0YaQf8RSbF1DsR
	 /owKpKp3rnDS/UREQlXQukLXoGYZ2di/Wu+EV8KhABbgw4xCxcIWEXI19Tc7I0T9tcA98
	 62Gw/uKGSyGFhl8dIl3biBO4m0GYeXmtEmwIONI6YVx9p6LV+CLfNm5YMliOtGjDAkx7B
	 CDS/lUPp23wwVt2yVZ/LQTz8h9Uo592t1iTvzlYql1CMraaPRY1Z/XheXNJY9quVjeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PRbDWWNO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B064606A32E;
	Sat,  7 Nov 2026 15:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PRbDWWNO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D671F0089F;
	Sat,  7 Nov 2026 15:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063715;
	bh=8D1IBU/vnBy/AgR0vMHSuoC6mP5HUfvxQMFQIc42Wyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PRbDWWNOxYCn+U9LyJw4Udzx6S5lyCr9/vpaJ4vDWfmnKOe0izyJ978JIB/XINjwu
	 vtDMZ1AcKGKO0c8i6allvmV+sOUUt49o9niAlg72Il20u6oCeYIj2o/fJ5c8Bw+O8w
	 mazpaB5UoE/hkFRLdEAZT85bg8cFh4wcP+H+khO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <philip.yang@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 816/869] drm/amdkfd: split vram_pages of SVM ranges prefetched without a GPU mapping
Date: Sat,  7 Nov 2026 08:58:18 -0500
Message-ID: <20261107134920.672693624@linuxfoundation.org>
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
index 366b31191ac1e..cd2cfb9a3bae2 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -987,9 +987,12 @@ svm_range_split_pages(struct svm_range *new, struct svm_range *old,
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
@@ -997,8 +1000,16 @@ svm_range_split_pages(struct svm_range *new, struct svm_range *old,
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



