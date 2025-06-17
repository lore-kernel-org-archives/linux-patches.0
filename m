Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66742E9730;
	Tue, 17 Jun 2025 15:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174669; cv=none; b=dtSMfMoDQtNMl0VCwJWGTHSfnSdu/BT08y91VnGvmm+jCU7QEK1pdSrIqYePtfOWxO7miZC6DL4YG12WJPXv3e2txwOX2hjvTN7d8EsjBUuM8M7SdsbNJQVtxu9jL9sd70ovp40th9jJMe+87VB1vXq+HD9HETGZB12GEfrI49w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174669; c=relaxed/simple;
	bh=fAqqKKUZFC0oqu0sRo6JyJMeAlTCYeJyPJDE06Ac/Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YipaSaBw97B1xgZJaX9x4cVOD1Hc2iutk3sEqcuJhkOd29TNumgz9WIK2kvz4ioomaxQAnxFf5tBpqWMStv+ye/ciE/FVjkFh59cy9VnFA1F6LAJ9+H9dG1lV5OEYbzPxYX09KVS0dvS4t1HHPY2BOcqybBOoxl298Eg6wWN1wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aps7TItQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aps7TItQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C1FC4CEE3;
	Tue, 17 Jun 2025 15:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174669;
	bh=fAqqKKUZFC0oqu0sRo6JyJMeAlTCYeJyPJDE06Ac/Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aps7TItQBLZhBzid4mXXwZFo6bHJFjpbxtZbfBwH2ib6ZnO2wxK5tRZBhqNhjZpT8
	 Xd+0edHx0IRgk0fdbSKYpAQYdX0THDJn4lDO22/rVxhtQZRIpX5pb91Xb315MtU+Rn
	 x55y5Urec1FXAxGEYYE3Y/gfdTRRZq++FK4wQgNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 100/356] iommu: Protect against overflow in iommu_pgsize()
Date: Tue, 17 Jun 2025 17:23:35 +0200
Message-ID: <20250617152342.252621034@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit e586e22974d2b7acbef3c6c3e01b2d5ce69efe33 ]

On a 32 bit system calling:
 iommu_map(0, 0x40000000)

When using the AMD V1 page table type with a domain->pgsize of 0xfffff000
causes iommu_pgsize() to miscalculate a result of:
  size=0x40000000 count=2

count should be 1. This completely corrupts the mapping process.

This is because the final test to adjust the pagesize malfunctions when
the addition overflows. Use check_add_overflow() to prevent this.

Fixes: b1d99dc5f983 ("iommu: Hook up '->unmap_pages' driver callback")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/0-v1-3ad28fc2e3a3+163327-iommu_overflow_pgsize_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index f2b3a4e2e54fc..3fa5699b9ff19 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2382,6 +2382,7 @@ static size_t iommu_pgsize(struct iommu_domain *domain, unsigned long iova,
 	unsigned int pgsize_idx, pgsize_idx_next;
 	unsigned long pgsizes;
 	size_t offset, pgsize, pgsize_next;
+	size_t offset_end;
 	unsigned long addr_merge = paddr | iova;
 
 	/* Page sizes supported by the hardware and small enough for @size */
@@ -2422,7 +2423,8 @@ static size_t iommu_pgsize(struct iommu_domain *domain, unsigned long iova,
 	 * If size is big enough to accommodate the larger page, reduce
 	 * the number of smaller pages.
 	 */
-	if (offset + pgsize_next <= size)
+	if (!check_add_overflow(offset, pgsize_next, &offset_end) &&
+	    offset_end <= size)
 		size = offset;
 
 out_set_count:
-- 
2.39.5



