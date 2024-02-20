Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24891151CCC;
	Tue, 20 Feb 2024 21:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465001; cv=none; b=cOMelpbnXIf4l/PNWeEhiMuJyC4+564ewUBTJmSSi2vkoGLmgmBWW+R8zrKZqsAEg3wnUMuCYu1cWXdiVaV9Tn8kgBpbDCC0arGO3kvPE8F40YJieGzWvlmU5bK2DVLt8wTUgtn61FZcROaQ4LYgzQvZSvyF1tu0/I9hWYxW2+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465001; c=relaxed/simple;
	bh=fAz77AUiKHH8TcXMWI/y43DHLoiaGprRJu2JwHiNu1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAJ4r2zcFHp1xVn9KjO4fW1E5ggyrtY52p1sQR4tNNoVIOsFQAc8h8A+4zURhqGz3Gp5GIpTabfWDF+ZM4ZLCHEOqVvRvZ+HMeK/1/pR0tKqZhtKD2LX2jtJFA3bGkoziPbPZ0WmfHdRq3Oeh3baRR93OuFotFLxMCmYDpyOPWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pzT8bFOx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pzT8bFOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D12C43390;
	Tue, 20 Feb 2024 21:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465001;
	bh=fAz77AUiKHH8TcXMWI/y43DHLoiaGprRJu2JwHiNu1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pzT8bFOx/2Qul129u6wom6Vwl7oaDmXO5dfAfeDXnUMqV9+cvr9C0nh116DKEFRSS
	 5Bmj0BUdJBEc6grs1/moybdnp7zOHQbDp1G9Rz4U40WiVHW+qpnRSOkKg6U0weWE5n
	 pHCcJ4hyWXvNbXKgnWzXQBsNCrmFq++EomxzAIr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Rob Clark <robdclark@chromium.org>
Subject: [PATCH 6.7 205/309] drm/msm: Wire up tlb ops
Date: Tue, 20 Feb 2024 21:56:04 +0100
Message-ID: <20240220205639.605755030@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robdclark@chromium.org>

commit 8c7bfd8262319fd3f127a5380f593ea76f1b88a2 upstream.

The brute force iommu_flush_iotlb_all() was good enough for unmap, but
in some cases a map operation could require removing a table pte entry
to replace with a block entry.  This also requires tlb invalidation.
Missing this was resulting an obscure iova fault on what should be a
valid buffer address.

Thanks to Robin Murphy for helping me understand the cause of the fault.

Cc: Robin Murphy <robin.murphy@arm.com>
Cc: stable@vger.kernel.org
Fixes: b145c6e65eb0 ("drm/msm: Add support to create a local pagetable")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/578117/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/msm_iommu.c |   32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/msm/msm_iommu.c
+++ b/drivers/gpu/drm/msm/msm_iommu.c
@@ -21,6 +21,8 @@ struct msm_iommu_pagetable {
 	struct msm_mmu base;
 	struct msm_mmu *parent;
 	struct io_pgtable_ops *pgtbl_ops;
+	const struct iommu_flush_ops *tlb;
+	struct device *iommu_dev;
 	unsigned long pgsize_bitmap;	/* Bitmap of page sizes in use */
 	phys_addr_t ttbr;
 	u32 asid;
@@ -201,11 +203,33 @@ static const struct msm_mmu_funcs pageta
 
 static void msm_iommu_tlb_flush_all(void *cookie)
 {
+	struct msm_iommu_pagetable *pagetable = cookie;
+	struct adreno_smmu_priv *adreno_smmu;
+
+	if (!pm_runtime_get_if_in_use(pagetable->iommu_dev))
+		return;
+
+	adreno_smmu = dev_get_drvdata(pagetable->parent->dev);
+
+	pagetable->tlb->tlb_flush_all((void *)adreno_smmu->cookie);
+
+	pm_runtime_put_autosuspend(pagetable->iommu_dev);
 }
 
 static void msm_iommu_tlb_flush_walk(unsigned long iova, size_t size,
 		size_t granule, void *cookie)
 {
+	struct msm_iommu_pagetable *pagetable = cookie;
+	struct adreno_smmu_priv *adreno_smmu;
+
+	if (!pm_runtime_get_if_in_use(pagetable->iommu_dev))
+		return;
+
+	adreno_smmu = dev_get_drvdata(pagetable->parent->dev);
+
+	pagetable->tlb->tlb_flush_walk(iova, size, granule, (void *)adreno_smmu->cookie);
+
+	pm_runtime_put_autosuspend(pagetable->iommu_dev);
 }
 
 static void msm_iommu_tlb_add_page(struct iommu_iotlb_gather *gather,
@@ -213,7 +237,7 @@ static void msm_iommu_tlb_add_page(struc
 {
 }
 
-static const struct iommu_flush_ops null_tlb_ops = {
+static const struct iommu_flush_ops tlb_ops = {
 	.tlb_flush_all = msm_iommu_tlb_flush_all,
 	.tlb_flush_walk = msm_iommu_tlb_flush_walk,
 	.tlb_add_page = msm_iommu_tlb_add_page,
@@ -254,10 +278,10 @@ struct msm_mmu *msm_iommu_pagetable_crea
 
 	/* The incoming cfg will have the TTBR1 quirk enabled */
 	ttbr0_cfg.quirks &= ~IO_PGTABLE_QUIRK_ARM_TTBR1;
-	ttbr0_cfg.tlb = &null_tlb_ops;
+	ttbr0_cfg.tlb = &tlb_ops;
 
 	pagetable->pgtbl_ops = alloc_io_pgtable_ops(ARM_64_LPAE_S1,
-		&ttbr0_cfg, iommu->domain);
+		&ttbr0_cfg, pagetable);
 
 	if (!pagetable->pgtbl_ops) {
 		kfree(pagetable);
@@ -279,6 +303,8 @@ struct msm_mmu *msm_iommu_pagetable_crea
 
 	/* Needed later for TLB flush */
 	pagetable->parent = parent;
+	pagetable->tlb = ttbr1_cfg->tlb;
+	pagetable->iommu_dev = ttbr1_cfg->iommu_dev;
 	pagetable->pgsize_bitmap = ttbr0_cfg.pgsize_bitmap;
 	pagetable->ttbr = ttbr0_cfg.arm_lpae_s1_cfg.ttbr;
 


