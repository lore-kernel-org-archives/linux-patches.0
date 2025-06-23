Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5233A217668;
	Mon, 23 Jun 2025 21:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712864; cv=none; b=EuJm28Cl07I/24Ww2lMAI+oKSWjD3koiTir5XLlDp73gewdOx/rRf2bj8Rw1UuR42PcwjqaMP1UVH3/XHFrnzGGPhT3H4jj2RVGLxY7326L2zqx2EfwRN8yHE/Vx5ADeQaU7CoULqFmtfCIMDNibRGC/QsIX81ioZaETqTDDS4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712864; c=relaxed/simple;
	bh=wkYXNEIH4QtGEPoeg5FQQIyG8wPtJI6cghDJTRdOtmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTCiWfYi/bEWZwWXvfWYpcDJbaSgBM7X/pEA1Tg03/3xZhPZRvQxRae1SO83GYyrJV50nC/IGOKkfZ9DMjpDdR0w7Cmjiroeyjcqg9equhQvDlEQlpe+4mdrWGKugOpzcAGTnwZPN9y6slS5n2Hp1Xl3KuLjXMyTT9N28O9O3RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ngp/4nSQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ngp/4nSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88767C4CEEA;
	Mon, 23 Jun 2025 21:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712863;
	bh=wkYXNEIH4QtGEPoeg5FQQIyG8wPtJI6cghDJTRdOtmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ngp/4nSQ7G5UNP6NvAq3CpNREBd6wAFoJgszSQdhwifzp5DZXOvu/ovzbQeaa2wv5
	 NB9Kp+BD2pF+Sh0cGzo3aNxgCBOnprXtjAlIlNH6AwwXOyQSYQZd2maoLYgdsmh7Xo
	 Fo0nRs/LXC9KZIgaMy8NPtw22wNMxV5wfMo9/P1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/508] iommu: Protect against overflow in iommu_pgsize()
Date: Mon, 23 Jun 2025 15:01:49 +0200
Message-ID: <20250623130646.818235068@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 83736824f17d1..ae9ca0700ad22 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2202,6 +2202,7 @@ static size_t iommu_pgsize(struct iommu_domain *domain, unsigned long iova,
 	unsigned int pgsize_idx, pgsize_idx_next;
 	unsigned long pgsizes;
 	size_t offset, pgsize, pgsize_next;
+	size_t offset_end;
 	unsigned long addr_merge = paddr | iova;
 
 	/* Page sizes supported by the hardware and small enough for @size */
@@ -2242,7 +2243,8 @@ static size_t iommu_pgsize(struct iommu_domain *domain, unsigned long iova,
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



