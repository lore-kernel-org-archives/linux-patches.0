Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5EB285C92;
	Mon, 22 Sep 2025 19:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569730; cv=none; b=cHUAM05SIL+8eSJNuvD0W+xy9E0Q2yNdueTXNJcuzcAEhOgvvlGy9TAv5FGrLbD+HGHhuefv1P3VllPLlUgfT7MOyinx1sYzCqgKMV8cr9VRSwlyEqnd1F7iHedWAFfC+xr0z7RNk1d60W5zMPA/OcCQQ5mrePBXwIR02p6jq4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569730; c=relaxed/simple;
	bh=w4RSo0Cz1aClUIVaPcF2CfUxSdsSLw9zQmp1Crn2Nfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PzVAnsMDKYi4KZ5cWa/hFyklcbjeYGA/wVjM7lD+7qbJbU6zp6dRkSKr1jOZUAiFOk26kcjcVp8H2k7g3Y8mEO2rPYWCE7Sx3DzlwbUDmor+eiVjlsLrUtU0ISa9cv882x/BxOQbddyLzoGMGEDmvL+Vk2yFqlGkt7GcgHvnC40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+QW/HsP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+QW/HsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A20C4CEF0;
	Mon, 22 Sep 2025 19:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569730;
	bh=w4RSo0Cz1aClUIVaPcF2CfUxSdsSLw9zQmp1Crn2Nfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+QW/HsPukNqTpxvqFV2JNkJ4b2XFFyQJKY0v4pf+iK/ttrdfZJ0FaE3bCBpUz1Di
	 rP71JnTsEl+f+Riy6g81ybJ4yQM/sfjEq/+ShxBha/3XQLzmtxrvb/AuNk+7GSUiy7
	 DxzPdCb8kYEwaukbnFJg8h5EVtHgl3PjppX3O6Yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Koira <eugkoira@amazon.com>,
	Nicolas Saenz Julienne <nsaenz@amazon.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.6 35/70] iommu/vt-d: Fix __domain_mapping()s usage of switch_to_super_page()
Date: Mon, 22 Sep 2025 21:29:35 +0200
Message-ID: <20250922192405.551794743@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugene Koira <eugkoira@amazon.com>

commit dce043c07ca1ac19cfbe2844a6dc71e35c322353 upstream.

switch_to_super_page() assumes the memory range it's working on is aligned
to the target large page level. Unfortunately, __domain_mapping() doesn't
take this into account when using it, and will pass unaligned ranges
ultimately freeing a PTE range larger than expected.

Take for example a mapping with the following iov_pfn range [0x3fe400,
0x4c0600), which should be backed by the following mappings:

   iov_pfn [0x3fe400, 0x3fffff] covered by 2MiB pages
   iov_pfn [0x400000, 0x4bffff] covered by 1GiB pages
   iov_pfn [0x4c0000, 0x4c05ff] covered by 2MiB pages

Under this circumstance, __domain_mapping() will pass [0x400000, 0x4c05ff]
to switch_to_super_page() at a 1 GiB granularity, which will in turn
free PTEs all the way to iov_pfn 0x4fffff.

Mitigate this by rounding down the iov_pfn range passed to
switch_to_super_page() in __domain_mapping()
to the target large page level.

Additionally add range alignment checks to switch_to_super_page.

Fixes: 9906b9352a35 ("iommu/vt-d: Avoid duplicate removing in __domain_mapping()")
Signed-off-by: Eugene Koira <eugkoira@amazon.com>
Cc: stable@vger.kernel.org
Reviewed-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
Link: https://lore.kernel.org/r/20250826143816.38686-1-eugkoira@amazon.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/iommu.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2168,6 +2168,10 @@ static void switch_to_super_page(struct
 	struct dma_pte *pte = NULL;
 	unsigned long i;
 
+	if (WARN_ON(!IS_ALIGNED(start_pfn, lvl_pages) ||
+		    !IS_ALIGNED(end_pfn + 1, lvl_pages)))
+		return;
+
 	while (start_pfn <= end_pfn) {
 		if (!pte)
 			pte = pfn_to_dma_pte(domain, start_pfn, &level,
@@ -2241,7 +2245,8 @@ __domain_mapping(struct dmar_domain *dom
 				unsigned long pages_to_remove;
 
 				pteval |= DMA_PTE_LARGE_PAGE;
-				pages_to_remove = min_t(unsigned long, nr_pages,
+				pages_to_remove = min_t(unsigned long,
+							round_down(nr_pages, lvl_pages),
 							nr_pte_to_next_page(pte) * lvl_pages);
 				end_pfn = iov_pfn + pages_to_remove - 1;
 				switch_to_super_page(domain, iov_pfn, end_pfn, largepage_lvl);


