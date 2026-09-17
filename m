Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C334D259C80;
	Thu, 17 Sep 2026 17:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665818; cv=none; b=kbh/V5YlqFZ4i5UzSAMt1h5WTn8Cccyq7sEnPMxEnKDXdty4/MBz2sBRLJP1ZpfSiwm/pRLyeLveC3U+I/9QN94Ws66KPqsIPtm/a34YVnd8RFb8qQGtBQ7qatlwv563Xt48fdy3zGxhlcqFl0b6FxN2b61KK/6MPkKpi1WVgkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665818; c=relaxed/simple;
	bh=gvPPyIBfMfgbnAI/xDcvpw1TCTxUGZc0xaN8+hzFpww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/8FKJEZ6HvrSZPStJT5wwIMZR1Lek5jp3SnG73RS3RoUWUBoka1fYXpSheFljj8Yn6JMkM9zOls9zEuUpBk4xrlFZYd23FSV8yMgYqCI2WGtQa1x2INpFYM0yEhFQryvIwP00C1Dk9O5twAfQLAkEM6Y1eCz4k7cfcemViyxR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SsjDnRSP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SsjDnRSP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5DF1F000FF;
	Thu, 17 Sep 2026 17:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665816;
	bh=85J98I2qU3h/nDEDwFQHX0lTOuyVQQ9JzY/V++zqJ48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SsjDnRSPjAVICaZ2ThRBvX4B8DaaMVepFapR6rZN8FlbRGs/ZS/2RgolmLqPP/Yzr
	 EVaYdV+6rL5DhGvtWBYy/mymwTr9eQOdjzYE6jD5JXOtn8ft06CZSqaU0kpvyyMaDF
	 lsfO5diRUcfggTc1wYPkhR1IMK1pDi5AClK5GB7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Chen <vincent.chen@sifive.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.18 0831/1250] iommu/riscv: Disable SADE
Date: Thu, 17 Sep 2026 16:10:26 +0100
Message-ID: <20260917151614.467129870@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit e93e4a6363b8f812cb89f2b2d97cbaf017a3d7f8 ]

In terms of the iommu subystem the SADE/GADE feature "3.4. IOMMU updating
of PTE accessed (A) and dirty (D) updates" is called dirty tracking.

There is no reason to enable HW support for this, and the HW cost
associated with it, unless dirty tracking is actually enabled through
iommufd. It should be a dynamic feature linked to user request.

Further, without implementing the read dirty ops the whole thing is
pointless.

Do not set DC.tc.SADE just because the HW has support for dirty tracking.

Tested-by: Vincent Chen <vincent.chen@sifive.com>
Acked-by: Paul Walmsley <pjw@kernel.org> # arch/riscv
Reviewed-by: Tomasz Jeznach <tjeznach@rivosinc.com>
Tested-by: Tomasz Jeznach <tjeznach@rivosinc.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Stable-dep-of: ca58afa40946 ("iommu/riscv: Serialize command queue publishing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/riscv/iommu.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index d5611dcc162a8..1f7b8e46812c9 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -813,7 +813,6 @@ struct riscv_iommu_domain {
 	struct list_head bonds;
 	spinlock_t lock;		/* protect bonds list updates. */
 	int pscid;
-	bool amo_enabled;
 	int numa_node;
 	unsigned int pgd_mode;
 	unsigned long *pgd_root;
@@ -1275,8 +1274,6 @@ static int riscv_iommu_map_pages(struct iommu_domain *iommu_domain,
 
 	if (!(prot & IOMMU_WRITE))
 		pte_prot = _PAGE_BASE | _PAGE_READ;
-	else if (domain->amo_enabled)
-		pte_prot = _PAGE_BASE | _PAGE_READ | _PAGE_WRITE;
 	else
 		pte_prot = _PAGE_BASE | _PAGE_READ | _PAGE_WRITE | _PAGE_DIRTY;
 
@@ -1460,7 +1457,6 @@ static struct iommu_domain *riscv_iommu_alloc_paging_domain(struct device *dev)
 	INIT_LIST_HEAD_RCU(&domain->bonds);
 	spin_lock_init(&domain->lock);
 	domain->numa_node = dev_to_node(iommu->dev);
-	domain->amo_enabled = !!(iommu->caps & RISCV_IOMMU_CAPABILITIES_AMO_HWAD);
 	domain->pgd_mode = pgd_mode;
 	domain->pgd_root = iommu_alloc_pages_node_sz(domain->numa_node,
 						     GFP_KERNEL_ACCOUNT, SZ_4K);
@@ -1583,8 +1579,6 @@ static struct iommu_device *riscv_iommu_probe_device(struct device *dev)
 	 * the device directory. Do not mark the context valid yet.
 	 */
 	tc = 0;
-	if (iommu->caps & RISCV_IOMMU_CAPABILITIES_AMO_HWAD)
-		tc |= RISCV_IOMMU_DC_TC_SADE;
 	for (i = 0; i < fwspec->num_ids; i++) {
 		dc = riscv_iommu_get_dc(iommu, fwspec->ids[i]);
 		if (!dc) {
-- 
2.53.0



