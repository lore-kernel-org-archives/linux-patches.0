Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741CE2F24;
	Mon, 23 Jun 2025 13:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685590; cv=none; b=YGYMiE3O79+NHdrY67ulS2/9y1193EWqTHd3FAgsQA1TLglpVjljvgxBzgVx1BQGWOE02CNIqbsCajTMb/INB68HaBjfgh8Ds5F6OpqwvCTxYBpHks36p68D4/GcAlLkAEhBPfCcIz0m48woVfzTRn6SF873uq441zJJUnk5uUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685590; c=relaxed/simple;
	bh=qjiM0sMEQ2Us99Yv9HN7z0ji/lMtsiz/Mdm0pMT4QPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pxf6cDgQLBvBlejg7fLjnujeRTRlxb69Zyyup3KnmNeHIbj+eHe3fTsf/Y1GfpMvgJPPU3OTbOpTXyGrdCLUavazeKoCiEnrbkugwEzTHACLhqVWrhKC/kfQ8RdHha7g5pYzeVP8fUJGpiUbvrMEpHRq+naHhFCWjd2rAD6BA98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lQXtQ7/r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lQXtQ7/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09472C4CEEA;
	Mon, 23 Jun 2025 13:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685590;
	bh=qjiM0sMEQ2Us99Yv9HN7z0ji/lMtsiz/Mdm0pMT4QPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lQXtQ7/r+wsImnDSJRbDgd2sY/MF5tz3KvKnO7ITvYFdLu5qfxKguqde6CX2e1IoM
	 MYUVITCHe8/UvyD5oIR/rPAwznsvv4CSOb0xDDARDOY+vo0iwLS+TFgEJUffV/rmtY
	 cQ5D7Wr4x4fzUbCKgzPJcS5UANQdEHo+moyuahsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/411] iommu: Protect against overflow in iommu_pgsize()
Date: Mon, 23 Jun 2025 15:03:09 +0200
Message-ID: <20250623130634.354510952@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d06dbf035c7c7..01e01ca760cf1 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2411,6 +2411,7 @@ static size_t iommu_pgsize(struct iommu_domain *domain, unsigned long iova,
 	unsigned int pgsize_idx, pgsize_idx_next;
 	unsigned long pgsizes;
 	size_t offset, pgsize, pgsize_next;
+	size_t offset_end;
 	unsigned long addr_merge = paddr | iova;
 
 	/* Page sizes supported by the hardware and small enough for @size */
@@ -2451,7 +2452,8 @@ static size_t iommu_pgsize(struct iommu_domain *domain, unsigned long iova,
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



