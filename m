Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D8F2EA149;
	Tue, 17 Jun 2025 15:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175727; cv=none; b=YZMclNAgSEWASfdRmwHJzOZLhsaE0DL3+2QjLL29y9oGGGh5M3L020M6l5woRQUBHewK0n1PTdWk5Pmoy9hRige6M43Bvv8fpy3191xVh37om73PHlwmTu7pB4wPgRYG1ieQqm0mWuMmLQ1EkU5Dc0UdYM4KN4Od7Ip6vQ5iEYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175727; c=relaxed/simple;
	bh=5a8DjOyfJ1e7LN6IjkHeKs0vLx1UJoWnt5UgOQoq7g8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BjTXc5E2rMcEMSsQtPwwPr+OV8mYNP/RCb32zNaPiba4dL3VdP/5WQK3ePQS5tnwHHjPiY4DV2iK9cQdfWNSkNSbX0JwXsHea/Iycjh3megL5Jrs4mZ+fCgHeGEBJfoIghSuKbdfWkOHjF/TlinCmkCEiW2/BR5pQcaAFW2Ie/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F47flLpA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F47flLpA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E122DC4CEE3;
	Tue, 17 Jun 2025 15:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175726;
	bh=5a8DjOyfJ1e7LN6IjkHeKs0vLx1UJoWnt5UgOQoq7g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F47flLpARD09AFlkuJNygQ6Pb55bWMXnb+wNEkvRAiPiFx0Ztft+Qgj3cBnyXU5aY
	 qPhsBED9FB9TAkTeOqfWcewAtyEBizFyV60p1bF2TCcOsdJsB1xBT9pKD55edCVO8+
	 qwrENNt0eXvh4X/z9TGOKEO52l5GO4/dOaFZEatg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 139/512] iommu: Protect against overflow in iommu_pgsize()
Date: Tue, 17 Jun 2025 17:21:45 +0200
Message-ID: <20250617152425.231137379@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 879009adef407..0ad55649e2d00 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2394,6 +2394,7 @@ static size_t iommu_pgsize(struct iommu_domain *domain, unsigned long iova,
 	unsigned int pgsize_idx, pgsize_idx_next;
 	unsigned long pgsizes;
 	size_t offset, pgsize, pgsize_next;
+	size_t offset_end;
 	unsigned long addr_merge = paddr | iova;
 
 	/* Page sizes supported by the hardware and small enough for @size */
@@ -2434,7 +2435,8 @@ static size_t iommu_pgsize(struct iommu_domain *domain, unsigned long iova,
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



