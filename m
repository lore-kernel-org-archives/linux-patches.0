Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F7737325
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:46:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED622C433D2;
	Wed,  7 Jun 2023 20:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170813;
	bh=clTYUuMytkN+dr85e+//wymuxnRRhUaIozyPwxmHaNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ad9+EQFhfey5E2XlKk1TgC+hs8/7Zp6FTXlOdsVh0aXuaZ6mllzvO/5koDrzzwKJ7
	 9tpDQdlxNZgbvWDyXizfNk7tffDqb8EkPPPMQyQLCs/75Gc1dEvPofLNw6dhCCwuBg
	 CsDX4CGUbwWuvFQFhvg1sM25QoKUw/H1cjeAWRkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Stable@vger.kernel.org
Subject: [PATCH 6.1 217/225] iommu/amd/pgtbl_v2: Fix domain max address
Date: Wed,  7 Jun 2023 22:16:50 +0200
Message-ID: <20230607200921.466349327@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vasant Hegde <vasant.hegde@amd.com>

commit 11c439a19466e7feaccdbce148a75372fddaf4e9 upstream.

IOMMU v2 page table supports 4 level (47 bit) or 5 level (56 bit) virtual
address space. Current code assumes it can support 64bit IOVA address
space. If IOVA allocator allocates virtual address > 47/56 bit (depending
on page table level) then it will do wrong mapping and cause invalid
translation.

Hence adjust aperture size to use max address supported by the page table.

Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
Fixes: aaac38f61487 ("iommu/amd: Initial support for AMD IOMMU v2 page table")
Cc: <Stable@vger.kernel.org>  # v6.0+
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Link: https://lore.kernel.org/r/20230518054351.9626-1-vasant.hegde@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
[ Modified to work with "V2 with 4 level page table" only - Vasant ]
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/iommu.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2101,6 +2101,15 @@ out_err:
 	return NULL;
 }
 
+static inline u64 dma_max_address(void)
+{
+	if (amd_iommu_pgtable == AMD_IOMMU_V1)
+		return ~0ULL;
+
+	/* V2 with 4 level page table */
+	return ((1ULL << PM_LEVEL_SHIFT(PAGE_MODE_4_LEVEL)) - 1);
+}
+
 static struct iommu_domain *amd_iommu_domain_alloc(unsigned type)
 {
 	struct protection_domain *domain;
@@ -2117,7 +2126,7 @@ static struct iommu_domain *amd_iommu_do
 		return NULL;
 
 	domain->domain.geometry.aperture_start = 0;
-	domain->domain.geometry.aperture_end   = ~0ULL;
+	domain->domain.geometry.aperture_end   = dma_max_address();
 	domain->domain.geometry.force_aperture = true;
 
 	return &domain->domain;


