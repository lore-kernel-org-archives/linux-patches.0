Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61141D0403;
	Wed,  2 Oct 2024 13:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875739; cv=none; b=dBr5kjy2GiHFqL+aRn0BiLn5qr2APHXP6jxiDT/mPxisdCzo4URjsSNOMSVwrSnWM4/jwQ3cQv2XkVkzsrbB3l5CcaMlVTtk99NrzWC8s6oaF1qyK571u0Ylgu5QwILqyC33HKPE6OOH5+c+QIjfJMn59GqjwCgs+02tniQbMSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875739; c=relaxed/simple;
	bh=ivqNWrCXfWST40KD1DgNixEaoC7DRiLNOaIa6pFvsJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXzYwe/+ssbFL3VijeW+3vN5VNoveK25pnPfxOX/acPoRpwed583XiW2nmqAyeJu02SVIJZ6lPiT97vI4zn2tkUAsvVxKZdkszyEhgFWJXbsrYJXDRIxWIsqUj2aShh5z1gpy3UqrHKHs5S8+k06cFf+6nsWbODKFJKKldGXgZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MS0vlOov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MS0vlOov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB3EC4CEC5;
	Wed,  2 Oct 2024 13:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875739;
	bh=ivqNWrCXfWST40KD1DgNixEaoC7DRiLNOaIa6pFvsJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MS0vlOovDW3W7G3eFMJGMgASqoBQ8u9gRySvIMgh2xcNyWIoEJJk7tv3X1LlpGJYs
	 tEbfe5ubbUKiI287ZpXABbRzUpzOdN98X+BkG1b1ggQuyAooXyLNZwsDEUA3mg3130
	 DEF1yC6RKfznXqHvxY7klrp+FDDYbyMkYV2PC7tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 187/695] iommu/amd: Do not set the D bit on AMD v2 table entries
Date: Wed,  2 Oct 2024 14:53:05 +0200
Message-ID: <20241002125829.935234983@linuxfoundation.org>
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

[ Upstream commit 2910a7fa1be090fc7637cef0b2e70bcd15bf5469 ]

The manual says that bit 6 is IGN for all Page-Table Base Address
pointers, don't set it.

Fixes: aaac38f61487 ("iommu/amd: Initial support for AMD IOMMU v2 page table")
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/14-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/io_pgtable_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index 6088822180e1e..f9227cbf75dfe 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -51,7 +51,7 @@ static inline u64 set_pgtable_attr(u64 *page)
 	u64 prot;
 
 	prot = IOMMU_PAGE_PRESENT | IOMMU_PAGE_RW | IOMMU_PAGE_USER;
-	prot |= IOMMU_PAGE_ACCESS | IOMMU_PAGE_DIRTY;
+	prot |= IOMMU_PAGE_ACCESS;
 
 	return (iommu_virt_to_phys(page) | prot);
 }
-- 
2.43.0



