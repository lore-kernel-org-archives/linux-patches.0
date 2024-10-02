Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CB71D0B90;
	Wed,  2 Oct 2024 14:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877823; cv=none; b=oXVyFNNuVPFKyH14Nhc/QDM6nBxk6m9ifPFFtABLYk5e5//XIrplK5mzEBOVCCxmXSSL4HDTqmHI4ZNHEBMva03vhgqx5DMfiDbEK09py/fFuJOvGkDnCeL02fOe28f5DDs54hUjX8uoALEa4UhXY+xMXtdbQ5109cIgmgMb4GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877823; c=relaxed/simple;
	bh=PtLEVSJoWZxw70scaMHKn5kg0VBeAA4VgXHH7CP3Kkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRYpqmAwR2WcSR+jSHKd+WbLkWUYTFyBbkgkekhRQ7NyW4hESM4GtHen9niUJCGRBQ5YKrIWqIGOdtLs+EpsfID3LGjQ4SWrWyPcqawgWXXGnd/Hb1usF4pG+eeEZGVITplo0Vrtvq2PhXAM0EXh3YOcp7ronaqnUKuvWIITyAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q0Nwz9rC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q0Nwz9rC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A2AC4CEC2;
	Wed,  2 Oct 2024 14:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877822;
	bh=PtLEVSJoWZxw70scaMHKn5kg0VBeAA4VgXHH7CP3Kkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q0Nwz9rC4jURRSdTotRAS9I9SskSJd5vckpuULJaDsRCjpqc2o5huy/n9YgGJbsKV
	 B7gfaHbn6DwaEMgyCy5Ky4PvYdEuawFEvJJdMteFfI9Qnm5Iw9rUrGZigO77oTTo9X
	 aUr4AkUFpF0rTVQEj82MxLcyuJcdgPdphURP4+j8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 165/634] iommu/amd: Allocate the page table root using GFP_KERNEL
Date: Wed,  2 Oct 2024 14:54:25 +0200
Message-ID: <20241002125817.624369376@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

[ Upstream commit b0a6c883bcd42eeb0850135e529b34b64d57673c ]

Domain allocation is always done under a sleepable context, the v1 path
and other drivers use GFP_KERNEL already. Fix the v2 path to also use
GFP_KERNEL.

Fixes: 0d571dcbe7c6 ("iommu/amd: Allocate page table using numa locality info")
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/2-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/io_pgtable_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index 78ac37c5ccc1e..acfe79b326293 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -362,7 +362,7 @@ static struct io_pgtable *v2_alloc_pgtable(struct io_pgtable_cfg *cfg, void *coo
 	struct protection_domain *pdom = (struct protection_domain *)cookie;
 	int ias = IOMMU_IN_ADDR_BIT_SIZE;
 
-	pgtable->pgd = iommu_alloc_page_node(pdom->nid, GFP_ATOMIC);
+	pgtable->pgd = iommu_alloc_page_node(pdom->nid, GFP_KERNEL);
 	if (!pgtable->pgd)
 		return NULL;
 
-- 
2.43.0



