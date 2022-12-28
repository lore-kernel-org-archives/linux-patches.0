Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B731863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:38:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D66C433D2;
	Wed, 28 Dec 2022 15:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241910;
	bh=+BcBWFIfmpfxX+bozeJww/U2XiKBWratuyo/4KW339o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ze8Gn9UHGJaDMDvLL7bF5jYvs8zLfDbSKellXUqVHRZpmmmXyoPoyRP09FAs6+b5d
	 6eQcWzhlVG4rooTNS7KThuEBzsObE6K7GW8jYscJVNFL0YLBetBL+LMdbqrulAbGK2
	 Dd6hC5aSlQSI1cthol3ann8SjBIGAaA55+ohwPY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Riesch <michael.riesch@wolfvision.net>,
	Heiko Stuebner <heiko@sntech.de>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 532/731] iommu/rockchip: fix permission bits in page table entries v2
Date: Wed, 28 Dec 2022 15:40:39 +0100
Message-Id: <20221228144311.963677707@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Riesch <michael.riesch@wolfvision.net>

[ Upstream commit 7eb99841f340b80be0d0973b0deb592d75fb8928 ]

As pointed out in the corresponding downstream fix [0], the permission bits
of the page table entries are compatible between v1 and v2 of the IOMMU.
This is in contrast to the current mainline code that incorrectly assumes
that the read and write permission bits are switched. Fix the permission
bits by reusing the v1 bit defines.

[0] https://github.com/rockchip-linux/kernel/commit/e3bc123a2260145e34b57454da3db0edd117eb8e

Fixes: c55356c534aa ("iommu: rockchip: Add support for iommu v2")
Signed-off-by: Michael Riesch <michael.riesch@wolfvision.net>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20221102063553.2464161-1-michael.riesch@wolfvision.net
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/rockchip-iommu.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/rockchip-iommu.c b/drivers/iommu/rockchip-iommu.c
index 7f23ad61c094..823f1a7d8c6e 100644
--- a/drivers/iommu/rockchip-iommu.c
+++ b/drivers/iommu/rockchip-iommu.c
@@ -280,19 +280,17 @@ static u32 rk_mk_pte(phys_addr_t page, int prot)
  *  11:9 - Page address bit 34:32
  *   8:4 - Page address bit 39:35
  *     3 - Security
- *     2 - Readable
- *     1 - Writable
+ *     2 - Writable
+ *     1 - Readable
  *     0 - 1 if Page @ Page address is valid
  */
-#define RK_PTE_PAGE_READABLE_V2      BIT(2)
-#define RK_PTE_PAGE_WRITABLE_V2      BIT(1)
 
 static u32 rk_mk_pte_v2(phys_addr_t page, int prot)
 {
 	u32 flags = 0;
 
-	flags |= (prot & IOMMU_READ) ? RK_PTE_PAGE_READABLE_V2 : 0;
-	flags |= (prot & IOMMU_WRITE) ? RK_PTE_PAGE_WRITABLE_V2 : 0;
+	flags |= (prot & IOMMU_READ) ? RK_PTE_PAGE_READABLE : 0;
+	flags |= (prot & IOMMU_WRITE) ? RK_PTE_PAGE_WRITABLE : 0;
 
 	return rk_mk_dte_v2(page) | flags;
 }
-- 
2.35.1



