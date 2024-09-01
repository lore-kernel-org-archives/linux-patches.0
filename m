Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EE21C68C;
	Sun,  1 Sep 2024 16:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208576; cv=none; b=Muh1F65kipPIQm1LG4TSclqvnzMyOVFNfQacDcYSr8FQBRMAqLEAUHk/UpVwRopKfppp3IHQAjh3JCTyGfjmn7xxz86n1ysFnRlwU9pcc22WAycv9Tn81+oGNggAfzFRguGftuLZl15GB3pUxT1PcUY2McXshMVILtD2Dc8HZcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208576; c=relaxed/simple;
	bh=obPE+7EkYCRrwKs0fLcyL22xmeoP9CytV/qXhDeqTfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0Nuijs8yeO67frT2hPllXLVnFiG5WYwkmcWKzY1O1MJiDCEgB7TJqOsGCOFXR50m2pLZ4AbS/fhyf/S7jIaJqI6qnIax6TtuD0hs1uBNhccG+269+ujl3POuPAIGTvQVszYHQS9rQ7dW1AQFhi7dbUfRcQ4JOVPUJtEmbfQ3v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n7DOwiZi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n7DOwiZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E37C4CEC3;
	Sun,  1 Sep 2024 16:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208576;
	bh=obPE+7EkYCRrwKs0fLcyL22xmeoP9CytV/qXhDeqTfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n7DOwiZiLDbWStOjyg17CwasEvII31qBCqTmu4yqxpEF4BSac8PhRMSDcpfRWa0/T
	 5HrEUuvQn9y0Jxjr8fYXW54dtN/zUDTJqeRkx5h7XLNysDe6pmZeWMlWOHKO2DmOGy
	 MfhHW35BJ4wBuw4gmc2CVKVjXfUdAgqcmMl3eL6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 093/149] iommu: Do not return 0 from map_pages if it doesnt do anything
Date: Sun,  1 Sep 2024 18:16:44 +0200
Message-ID: <20240901160820.961381827@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 6093cd582f8e027117a8d4ad5d129a1aacdc53d2 ]

These three implementations of map_pages() all succeed if a mapping is
requested with no read or write. Since they return back to __iommu_map()
leaving the mapped output as 0 it triggers an infinite loop. Therefore
nothing is using no-access protection bits.

Further, VFIO and iommufd rely on iommu_iova_to_phys() to get back PFNs
stored by map, if iommu_map() succeeds but iommu_iova_to_phys() fails that
will create serious bugs.

Thus remove this never used "nothing to do" concept and just fail map
immediately.

Fixes: e5fc9753b1a8 ("iommu/io-pgtable: Add ARMv7 short descriptor support")
Fixes: e1d3c0fd701d ("iommu: add ARM LPAE page table allocator")
Fixes: 745ef1092bcf ("iommu/io-pgtable: Move Apple DART support to its own file")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/2-v1-1211e1294c27+4b1-iommu_no_prot_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/io-pgtable-arm-v7s.c | 3 +--
 drivers/iommu/io-pgtable-arm.c     | 3 +--
 drivers/iommu/io-pgtable-dart.c    | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/io-pgtable-arm-v7s.c b/drivers/iommu/io-pgtable-arm-v7s.c
index 75f244a3e12df..06ffc683b28fe 100644
--- a/drivers/iommu/io-pgtable-arm-v7s.c
+++ b/drivers/iommu/io-pgtable-arm-v7s.c
@@ -552,9 +552,8 @@ static int arm_v7s_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 		    paddr >= (1ULL << data->iop.cfg.oas)))
 		return -ERANGE;
 
-	/* If no access, then nothing to do */
 	if (!(prot & (IOMMU_READ | IOMMU_WRITE)))
-		return 0;
+		return -EINVAL;
 
 	while (pgcount--) {
 		ret = __arm_v7s_map(data, iova, paddr, pgsize, prot, 1, data->pgd,
diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 3d23b924cec16..07c9b90eab2ed 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -495,9 +495,8 @@ static int arm_lpae_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 	if (WARN_ON(iaext || paddr >> cfg->oas))
 		return -ERANGE;
 
-	/* If no access, then nothing to do */
 	if (!(iommu_prot & (IOMMU_READ | IOMMU_WRITE)))
-		return 0;
+		return -EINVAL;
 
 	prot = arm_lpae_prot_to_pte(data, iommu_prot);
 	ret = __arm_lpae_map(data, iova, paddr, pgsize, pgcount, prot, lvl,
diff --git a/drivers/iommu/io-pgtable-dart.c b/drivers/iommu/io-pgtable-dart.c
index ad28031e1e93d..c004640640ee5 100644
--- a/drivers/iommu/io-pgtable-dart.c
+++ b/drivers/iommu/io-pgtable-dart.c
@@ -245,9 +245,8 @@ static int dart_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 	if (WARN_ON(paddr >> cfg->oas))
 		return -ERANGE;
 
-	/* If no access, then nothing to do */
 	if (!(iommu_prot & (IOMMU_READ | IOMMU_WRITE)))
-		return 0;
+		return -EINVAL;
 
 	tbl = dart_get_table(data, iova);
 
-- 
2.43.0



