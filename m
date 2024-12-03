Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CF31F7548;
	Tue,  3 Dec 2024 15:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238900; cv=none; b=NaBoWuS8vEDVKEYv4I/YoV1adgUjQc0lh2LD3BabIFYR7JVFlQs59Fpf29/BajHrW1cnz6jDcxxiCchq4gAgrd/nLNfFtf4Fu31ByLOMqNXs65wcE+MvvyPb2BFU1Z07ofH1a1yD2PbCE8+yqEkz1ImHAub9PL7BT03+PEPMiD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238900; c=relaxed/simple;
	bh=NYISJDHITQfqFmoCifGznaJ6bp/lvIMg56iD6LHAeFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSSMYWB/Qg/kn75s4TLKeiO0fjQ477zJE9yRWq2Mip1S3Kc6hbFscBMIflkh3hCGT+aDtqlmVGocowQrrzIHrDgYiTylcne8vj1r0PZlxXs1eJPpwxiNGzrl/quTotNCP/44S8KwHF0dqdXimYg3ICNZ5FqIEG86P1LWDB+L6dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kr8n0EDc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kr8n0EDc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EAC4C4CECF;
	Tue,  3 Dec 2024 15:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238900;
	bh=NYISJDHITQfqFmoCifGznaJ6bp/lvIMg56iD6LHAeFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kr8n0EDcBuWNMeag89AoFlZ8dJ+5AzkFcpYTOv5I0qaIUhz2SUKI9OsJXJ8CGiBjq
	 9jqmFM1XnBV7556L43BGbPWI2VuryLXrD2jTMQrtDg7Hz1H+lt5dXdXGLGO12BXR4w
	 e9R1vTiagy+UQ6UX5yVrmjDMZs8RjzLZnlQ3nVsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 408/817] iommu/amd: Remove the amd_iommu_domain_set_pt_root() and related
Date: Tue,  3 Dec 2024 15:39:40 +0100
Message-ID: <20241203144011.805207926@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 1ed2d21d471caf2e4351c2e8bb14143bc8062092 ]

Looks like many refactorings here have left this confused. There is only
one storage of the root/mode, it is in the iop struct.

increase_address_space() calls amd_iommu_domain_set_pgtable() with values
that it already stored in iop a few lines above.

amd_iommu_domain_clr_pt_root() is zero'ing memory we are about to free. It
used to protect against a double free of root, but that is gone now.

Remove amd_iommu_domain_set_pgtable(), amd_iommu_domain_set_pt_root(),
amd_iommu_domain_clr_pt_root() as they are all pointless.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/5-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: 016991606aa0 ("iommu/amd/pgtbl_v2: Take protection domain lock before invalidating TLB")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/amd_iommu.h  | 13 -------------
 drivers/iommu/amd/io_pgtable.c | 24 ------------------------
 2 files changed, 37 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 2d5945c982bde..5a050080d2e81 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -143,19 +143,6 @@ static inline void *iommu_phys_to_virt(unsigned long paddr)
 	return phys_to_virt(__sme_clr(paddr));
 }
 
-static inline
-void amd_iommu_domain_set_pt_root(struct protection_domain *domain, u64 root)
-{
-	domain->iop.root = (u64 *)(root & PAGE_MASK);
-	domain->iop.mode = root & 7; /* lowest 3 bits encode pgtable mode */
-}
-
-static inline
-void amd_iommu_domain_clr_pt_root(struct protection_domain *domain)
-{
-	amd_iommu_domain_set_pt_root(domain, 0);
-}
-
 static inline int get_pci_sbdf_id(struct pci_dev *pdev)
 {
 	int seg = pci_domain_nr(pdev->bus);
diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index b3991ad1ae8ea..5278ba3f676c4 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -132,18 +132,6 @@ static void free_sub_pt(u64 *root, int mode, struct list_head *freelist)
 	}
 }
 
-void amd_iommu_domain_set_pgtable(struct protection_domain *domain,
-				  u64 *root, int mode)
-{
-	u64 pt_root;
-
-	/* lowest 3 bits encode pgtable mode */
-	pt_root = mode & 7;
-	pt_root |= (u64)root;
-
-	amd_iommu_domain_set_pt_root(domain, pt_root);
-}
-
 /*
  * This function is used to add another level to an IO page table. Adding
  * another level increases the size of the address space by 9 bits to a size up
@@ -177,12 +165,6 @@ static bool increase_address_space(struct protection_domain *domain,
 	amd_iommu_update_and_flush_device_table(domain);
 	amd_iommu_domain_flush_complete(domain);
 
-	/*
-	 * Device Table needs to be updated and flushed before the new root can
-	 * be published.
-	 */
-	amd_iommu_domain_set_pgtable(domain, pte, domain->iop.mode);
-
 	pte = NULL;
 	ret = true;
 
@@ -561,23 +543,17 @@ static int iommu_v1_read_and_clear_dirty(struct io_pgtable_ops *ops,
 static void v1_free_pgtable(struct io_pgtable *iop)
 {
 	struct amd_io_pgtable *pgtable = container_of(iop, struct amd_io_pgtable, iop);
-	struct protection_domain *dom;
 	LIST_HEAD(freelist);
 
 	if (pgtable->mode == PAGE_MODE_NONE)
 		return;
 
-	dom = container_of(pgtable, struct protection_domain, iop);
-
 	/* Page-table is not visible to IOMMU anymore, so free it */
 	BUG_ON(pgtable->mode < PAGE_MODE_NONE ||
 	       pgtable->mode > PAGE_MODE_6_LEVEL);
 
 	free_sub_pt(pgtable->root, pgtable->mode, &freelist);
 	iommu_put_pages_list(&freelist);
-
-	/* Update data structure */
-	amd_iommu_domain_clr_pt_root(dom);
 }
 
 static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
-- 
2.43.0



