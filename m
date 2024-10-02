Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BDF1D0437;
	Wed,  2 Oct 2024 13:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875803; cv=none; b=h2+uJOoDhlyQ8+cIC55Q17bhnZw5pI9gf/L+9tGyYPaMnAYiLbQoqTMbKC0S8ynlW/tbPB/d0nwVY+ediekxyvZvcjLiUQ2F7klOv2ACrYdU67pGK6nqhNsIimbOyw94ZDzEqbl9qfWYWpEPzVhNhP6VxKVM/x0TPuCAvtGaFCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875803; c=relaxed/simple;
	bh=6s3+IlaAqOMR8AO5FiDiV88jyzdhqCKwZPnlGtngMIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/4obumQcbX+D3SwAKkXH16jrAGpMz5m4a52ba9evPQbs0ddxtRvDJJ5LjluZ3oCqZovCBXP/Uk0QQXJ+S0Q2GiXUJzaDPSNeGBH+clvsLolKY/8ztCT7Z0MYUkZMhG8HKl9XEi8GS3uwhLxEcnSRN4HsDuHLM3Qf6ZzAHYtPos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BcyCboa1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BcyCboa1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37224C4CEC5;
	Wed,  2 Oct 2024 13:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875803;
	bh=6s3+IlaAqOMR8AO5FiDiV88jyzdhqCKwZPnlGtngMIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BcyCboa164F4wy20yrbUmR8Rkpn59BiojvVxRjy6vYamiHcPruhdhA0FQMiBBSJFO
	 SkGH/q863F8RKKlAtzwXFtivcVsAofjuJ4VDcV7XNd9FEEP2bI6NwI+0n0IKdGjPxi
	 jq+DaywL9ez+hSQva1qzhycEDvuZ11ro7Zz3oalI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 185/695] iommu/amd: Move allocation of the top table into v1_alloc_pgtable
Date: Wed,  2 Oct 2024 14:53:03 +0200
Message-ID: <20241002125829.855552744@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

[ Upstream commit 8d00b77a52ef4b2091696ca25753d0ab95e4d839 ]

All the page table memory should be allocated/free within the io_pgtable
struct. The v2 path is already doing this, make it consistent.

It is hard to see but the free of the root in protection_domain_free() is
a NOP on the success path because v1_free_pgtable() does
amd_iommu_domain_clr_pt_root().

The root memory is already freed because free_sub_pt() put it on the
freelist. The free path in protection_domain_free() is only used during
error unwind of protection_domain_alloc().

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/1-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: 7a41dcb52f9d ("iommu/amd: Set the pgsize_bitmap correctly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/io_pgtable.c |  8 ++++++--
 drivers/iommu/amd/iommu.c      | 21 ++-------------------
 2 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 1074ee25064d0..05aed3cb46f1b 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -574,20 +574,24 @@ static void v1_free_pgtable(struct io_pgtable *iop)
 	       pgtable->mode > PAGE_MODE_6_LEVEL);
 
 	free_sub_pt(pgtable->root, pgtable->mode, &freelist);
+	iommu_put_pages_list(&freelist);
 
 	/* Update data structure */
 	amd_iommu_domain_clr_pt_root(dom);
 
 	/* Make changes visible to IOMMUs */
 	amd_iommu_domain_update(dom);
-
-	iommu_put_pages_list(&freelist);
 }
 
 static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
 {
 	struct amd_io_pgtable *pgtable = io_pgtable_cfg_to_data(cfg);
 
+	pgtable->root = iommu_alloc_page(GFP_KERNEL);
+	if (!pgtable->root)
+		return NULL;
+	pgtable->mode = PAGE_MODE_3_LEVEL;
+
 	cfg->pgsize_bitmap  = AMD_IOMMU_PGSIZES;
 	cfg->ias            = IOMMU_IN_ADDR_BIT_SIZE;
 	cfg->oas            = IOMMU_OUT_ADDR_BIT_SIZE;
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index fc660d4b10ac8..edbd4ca1451a8 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -52,8 +52,6 @@
 #define HT_RANGE_START		(0xfd00000000ULL)
 #define HT_RANGE_END		(0xffffffffffULL)
 
-#define DEFAULT_PGTABLE_LEVEL	PAGE_MODE_3_LEVEL
-
 static DEFINE_SPINLOCK(pd_bitmap_lock);
 
 LIST_HEAD(ioapic_map);
@@ -2267,30 +2265,15 @@ void protection_domain_free(struct protection_domain *domain)
 	if (domain->iop.pgtbl_cfg.tlb)
 		free_io_pgtable_ops(&domain->iop.iop.ops);
 
-	if (domain->iop.root)
-		iommu_free_page(domain->iop.root);
-
 	if (domain->id)
 		domain_id_free(domain->id);
 
 	kfree(domain);
 }
 
-static int protection_domain_init_v1(struct protection_domain *domain, int mode)
+static int protection_domain_init_v1(struct protection_domain *domain)
 {
-	u64 *pt_root = NULL;
-
-	BUG_ON(mode < PAGE_MODE_NONE || mode > PAGE_MODE_6_LEVEL);
-
-	if (mode != PAGE_MODE_NONE) {
-		pt_root = iommu_alloc_page(GFP_KERNEL);
-		if (!pt_root)
-			return -ENOMEM;
-	}
-
 	domain->pd_mode = PD_MODE_V1;
-	amd_iommu_domain_set_pgtable(domain, pt_root, mode);
-
 	return 0;
 }
 
@@ -2343,7 +2326,7 @@ struct protection_domain *protection_domain_alloc(unsigned int type)
 
 	switch (pgtable) {
 	case AMD_IOMMU_V1:
-		ret = protection_domain_init_v1(domain, DEFAULT_PGTABLE_LEVEL);
+		ret = protection_domain_init_v1(domain);
 		break;
 	case AMD_IOMMU_V2:
 		ret = protection_domain_init_v2(domain);
-- 
2.43.0



