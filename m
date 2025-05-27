Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3362E19CD07;
	Tue, 27 May 2025 17:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366987; cv=none; b=iFhoStkpF5jqQwYS+PArP1S0c7X4ZUjZDHIPlEMzzaAyHiXPLjFBtdSA3vvdd+O3y0lr5UskcT7zyRYigiEvAsCv6qW8RGGD6LiELV765W0SgWaap6oZkWzzTu86seNpZV7iIR3ETCdQqnKm6wQY1bMHp9wRXciH5GDnkLGgXv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366987; c=relaxed/simple;
	bh=Rf3waK2CcH2+8nZXOL8fwjLAtzUZebwL/lv+elM0vzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnzdMR370pRwq5Ivqkhe/bSrQ+1lbzyjXijNlibAqfjJ8WDKIPYzI9u/BrSyhMnRcD2H2txSB6E7K40LhVmydvktmbQczRWr5EDybrfKsWSLGDTyDDIvzqw8QGV1POEAkTCekeRivKuiv12J7Y1kOy4RGwDvMhZ/9YrckGqyPuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nRcWqAkX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nRcWqAkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0A2C4CEE9;
	Tue, 27 May 2025 17:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366987;
	bh=Rf3waK2CcH2+8nZXOL8fwjLAtzUZebwL/lv+elM0vzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nRcWqAkXIhVdEB2c1JAzSxU1XqPqRUXVO8/2wGxjYKSND8etOpIv2AffeJFUnIJUv
	 on+m0Xdb0VPZOL6SGhWPWIneMqeGm88cl1f3+PVET+2Z1bbME+SbXamcXFUGZViRLP
	 RO3+bdytANTJhxZILt9NFl4S9bnuBdvnF3/yFqpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 241/783] iommu/amd/pgtbl_v2: Improve error handling
Date: Tue, 27 May 2025 18:20:38 +0200
Message-ID: <20250527162522.926936790@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit 36a1cfd497435ba5e37572fe9463bb62a7b1b984 ]

Return -ENOMEM if v2_alloc_pte() fails to allocate memory.

Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20250227162320.5805-4-vasant.hegde@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/io_pgtable_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index c616de2c5926e..a56a273963059 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -254,7 +254,7 @@ static int iommu_v2_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 		pte = v2_alloc_pte(cfg->amd.nid, pgtable->pgd,
 				   iova, map_size, gfp, &updated);
 		if (!pte) {
-			ret = -EINVAL;
+			ret = -ENOMEM;
 			goto out;
 		}
 
-- 
2.39.5



