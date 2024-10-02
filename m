Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EBC1D0403;
	Wed,  2 Oct 2024 13:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875684; cv=none; b=TKddQCbhalaXhWm1hNvN+lY9LTbr5tkel7ugrlqPe5bffH0yBqCrpjFKLnLDPLN5RZD2WvqslBoHJg1njbSXHMSrsRFi6YMbmJMgxCij8UHJZExmZreOiqO6ItobS/FKauzRMIG31HxBdwAbFG9+6DaJD7NZ0cSxYe9husBqRt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875684; c=relaxed/simple;
	bh=d+cXDuR3CCMN814CMZRwZGn5p4smm1ImNX2+Nr/Q+oY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXCJ4GPZi88jjPePIra7gE0JaWCmWHS1e0hc6BnsOzN9W5RwgTveb5BgQLziBguoD6nKm3Gr2ZE/qEuNgI+5x96+pSI+Zq9jZP+WPPVtQkraUCOvDcHYnRqoslqrzHchkj0W5MQS7LGNWSX+92oKuWCvKJ+A83v9ZCga3elJQUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AjJzIggf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AjJzIggf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD170C4CEC5;
	Wed,  2 Oct 2024 13:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875684;
	bh=d+cXDuR3CCMN814CMZRwZGn5p4smm1ImNX2+Nr/Q+oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AjJzIggfdR8cWiMPimITTf5r10MVixZgMncg1vOfKb4IwgQdaCDXcCld2GyFmjfSA
	 cwr1u3aS3Rucu/OZqbyqh7faWn9pGy3y5mEJjO9OMjgW/zK7uWkZZZclCAgyj0tY5e
	 o5XrtjiESLNRVeXfjiVOZPQEPqddXSdB8p4uvEUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 184/695] iommu/amd: Allocate the page table root using GFP_KERNEL
Date: Wed,  2 Oct 2024 14:53:02 +0200
Message-ID: <20241002125829.814867174@linuxfoundation.org>
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
index 664e91c88748e..6088822180e1e 100644
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



