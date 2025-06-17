Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318322ED167;
	Tue, 17 Jun 2025 16:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176768; cv=none; b=B8xwnEQSGtUonDFwCIhvTSzsZqWYu+zUqx50SZF/WIK/XeNC7wkl7QSMQ2wrII93jz5jVE4IsOZ1LMT8O9ioehR4BFGvw66zqGi1f/lblkY72e36m5WlnZ27rPyHj6yLJ3eHj2qb6paXbZOfQj3ChrCQxfdUd9i+pxYsmdWyiEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176768; c=relaxed/simple;
	bh=V6WyThVk89pb5V3QZq/IGD1SFrP4RspqcfdUi+Gl9dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQ4Rf4Zrd65M7O1VX9vb4BC8oKrVfeuAbMHfgJTFwtqYqaaG1LFGELbSpJdNo916nEauOROX8kOU4O/Lzzdv1LDrP4f1Y230VuVgkuD9tAxQ6Cy7SxxGHHUdxTES96cyPgkNY+z1AL3xBpnTYfFFa5/uouX17whdfiOdkVhuq3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j34Fv5n/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j34Fv5n/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54226C4CEE3;
	Tue, 17 Jun 2025 16:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176767;
	bh=V6WyThVk89pb5V3QZq/IGD1SFrP4RspqcfdUi+Gl9dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j34Fv5n/gbSx3KTYj3UW7L9gGI8C84DsE1quUxvmVJSj42C94SpzuFP4l3eueEyxH
	 WuvgLsAzoiPwE5yorBCxElHxMk0KK4cC9GFPTiQtThPsmL2cWTbnDMVpBdEuK2/zZG
	 d0VU5yszd5A8FNsq1gDXjfQQUw4SYSdDV8XkN88Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 224/780] iommu: Protect against overflow in iommu_pgsize()
Date: Tue, 17 Jun 2025 17:18:52 +0200
Message-ID: <20250617152500.576862682@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5bc2fc969494f..e4628d9621610 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2399,6 +2399,7 @@ static size_t iommu_pgsize(struct iommu_domain *domain, unsigned long iova,
 	unsigned int pgsize_idx, pgsize_idx_next;
 	unsigned long pgsizes;
 	size_t offset, pgsize, pgsize_next;
+	size_t offset_end;
 	unsigned long addr_merge = paddr | iova;
 
 	/* Page sizes supported by the hardware and small enough for @size */
@@ -2439,7 +2440,8 @@ static size_t iommu_pgsize(struct iommu_domain *domain, unsigned long iova,
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



