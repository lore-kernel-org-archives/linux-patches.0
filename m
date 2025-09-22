Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A112E285C;
	Mon, 22 Sep 2025 19:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569946; cv=none; b=f7/ngnhRmn+uUaVMzY6DRcb+swgCHvCtIWZXcPhiqX+MJa09wnO5+hL2PB++VE6ZUg78/TWp0Zvx/03UQYgP/DpavyCUNwqSPkhJyfPNHIvzuRdW2AaFJ/a9am64vt6QXyFCk+Lc993AV3JEsQoITGZi+tjVb/YE09tCnThZZ8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569946; c=relaxed/simple;
	bh=azBgL02JVSHYiF0RzpkUUu0allSAduv3qHHApN7uQ9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=erZT3U/eMvrsxSgZc8sOdft/g3qOIQ2oyuGklrS+K1RTOpDGd/3AJIGosoxZ8qDnnVx61MzO65+CHXuwVZDB6eNXVUAmnO7/FJzdOu5lvrg9d+FlAL9q3EZzBiENSLW4k3y2q9gfPdPnDqhqM3nsHTWDQ2pMmvafaqY+QpXISE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YiNxmXnt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YiNxmXnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7952C4CEF0;
	Mon, 22 Sep 2025 19:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569946;
	bh=azBgL02JVSHYiF0RzpkUUu0allSAduv3qHHApN7uQ9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YiNxmXntiptafkrzFEAE/+4El41sq82tsfU46PmoqHEq1BWh2RTw5CNlmUiEpugsD
	 cFdJhkQ5T93XcJSMTY2l572MM4S+lyYsu4RSPtykgqIUHtpKLfd8NYCLJL9QZDuCug
	 5NlYgPpeQbj6V/LmIQeRiLsuvusDIB/rp25jy0yU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Koira <eugkoira@amazon.com>,
	Nicolas Saenz Julienne <nsaenz@amazon.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.12 051/105] iommu/vt-d: Fix __domain_mapping()s usage of switch_to_super_page()
Date: Mon, 22 Sep 2025 21:29:34 +0200
Message-ID: <20250922192410.251319210@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1768,6 +1768,10 @@ static void switch_to_super_page(struct
 	unsigned long lvl_pages = lvl_to_nr_pages(level);
 	struct dma_pte *pte = NULL;
 
+	if (WARN_ON(!IS_ALIGNED(start_pfn, lvl_pages) ||
+		    !IS_ALIGNED(end_pfn + 1, lvl_pages)))
+		return;
+
 	while (start_pfn <= end_pfn) {
 		if (!pte)
 			pte = pfn_to_dma_pte(domain, start_pfn, &level,
@@ -1844,7 +1848,8 @@ __domain_mapping(struct dmar_domain *dom
 				unsigned long pages_to_remove;
 
 				pteval |= DMA_PTE_LARGE_PAGE;
-				pages_to_remove = min_t(unsigned long, nr_pages,
+				pages_to_remove = min_t(unsigned long,
+							round_down(nr_pages, lvl_pages),
 							nr_pte_to_next_page(pte) * lvl_pages);
 				end_pfn = iov_pfn + pages_to_remove - 1;
 				switch_to_super_page(domain, iov_pfn, end_pfn, largepage_lvl);


