Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433DE168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA402C433D2;
	Mon,  8 May 2023 10:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540808;
	bh=mo+PNlerTb58Xj4ItmhApXTN2NiPbKa7CXMmolXNwAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F+LmZtV7d1qeGbRykEBV/LDZrAO3C+7wzHidCmixv04ZOxSdmM+KMzRf+lsh/OK58
	 CEBqH1HKMWGn1St7r3Kvb0j5+roIX9QPgCJVi7qgTEIZhKKZN3YvRIycyxB57B9ANg
	 6bhp+cJcnyXBO42Sw800S35NOw1TYB4Y0K4Dbs70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Joerg Roedel <joro@8bytes.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 505/611] iommu/amd: Set page size bitmap during V2 domain allocation
Date: Mon,  8 May 2023 11:45:47 +0200
Message-Id: <20230508094438.480506783@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jerry Snitselaar <jsnitsel@redhat.com>

[ Upstream commit 8f880d19e6ad645a4b8066d5ff091c980b3231e7 ]

With the addition of the V2 page table support, the domain page size
bitmap needs to be set prior to iommu core setting up direct mappings
for reserved regions. When reserved regions are mapped, if this is not
done, it will be looking at the V1 page size bitmap when determining
the page size to use in iommu_pgsize(). When it gets into the actual
amd mapping code, a check of see if the page size is supported can
fail, because at that point it is checking it against the V2 page size
bitmap which only supports 4K, 2M, and 1G.

Add a check to __iommu_domain_alloc() to not override the
bitmap if it was already set by the iommu ops domain_alloc() code path.

Cc: Vasant Hegde <vasant.hegde@amd.com>
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>
Fixes: 4db6c41f0946 ("iommu/amd: Add support for using AMD IOMMU v2 page table for DMA-API")
Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Link: https://lore.kernel.org/r/20230404072742.1895252-1-jsnitsel@redhat.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 6 ++----
 drivers/iommu/iommu.c     | 9 +++++++--
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 20adb9b323d82..26fb78003889f 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1657,10 +1657,6 @@ static void do_attach(struct iommu_dev_data *dev_data,
 	domain->dev_iommu[iommu->index] += 1;
 	domain->dev_cnt                 += 1;
 
-	/* Override supported page sizes */
-	if (domain->flags & PD_GIOV_MASK)
-		domain->domain.pgsize_bitmap = AMD_IOMMU_PGSIZES_V2;
-
 	/* Update device table */
 	set_dte_entry(iommu, dev_data->devid, domain,
 		      ats, dev_data->iommu_v2);
@@ -2039,6 +2035,8 @@ static int protection_domain_init_v2(struct protection_domain *domain)
 
 	domain->flags |= PD_GIOV_MASK;
 
+	domain->domain.pgsize_bitmap = AMD_IOMMU_PGSIZES_V2;
+
 	if (domain_enable_v2(domain, 1)) {
 		domain_id_free(domain->id);
 		return -ENOMEM;
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index bfb2f163c6914..2bcd1f23d07d2 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1912,8 +1912,13 @@ static struct iommu_domain *__iommu_domain_alloc(struct bus_type *bus,
 		return NULL;
 
 	domain->type = type;
-	/* Assume all sizes by default; the driver may override this later */
-	domain->pgsize_bitmap = bus->iommu_ops->pgsize_bitmap;
+	/*
+	 * If not already set, assume all sizes by default; the driver
+	 * may override this later
+	 */
+	if (!domain->pgsize_bitmap)
+		domain->pgsize_bitmap = bus->iommu_ops->pgsize_bitmap;
+
 	if (!domain->ops)
 		domain->ops = bus->iommu_ops->default_domain_ops;
 
-- 
2.39.2



