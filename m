Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9B92F0C52;
	Mon, 22 Sep 2025 19:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570257; cv=none; b=nY+GxRXMNAHsVMsqgOWS8OwMtw9Khhf+JeCJYhI2OLr0CG1SffDP3lWsb+mZYJAHBroPsKUbTtnxlFuBIaTW2nIGvs7KM6FraVrTbpwXUT+cS1PToaxOfbkhQNTpU2QuAaWS0bZXfedvW5IRXNhFVEX6OXcmng7uxUU7EZ6sf6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570257; c=relaxed/simple;
	bh=X5uYsqRYzicbobVkpzBZT9FvOUKPeXKjTqallLbWvrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCjwGmaBF+ThsgZU85lcXp7Q+LhJv1Oest/hiq+NnfzWXTTXBhTi2iVrlCEPEGSqTkvG86zSuRJMcNhyZsnYgVEj5CMrewj07NsBC6UCqMngAlvBGmfTS6jMFSjTW8ZQETGcBQZxGIo4HjQFF0Bz4sGWmLkkxcILIPU3LabFRAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jL0xpL6O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jL0xpL6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A97C4CEF0;
	Mon, 22 Sep 2025 19:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570256;
	bh=X5uYsqRYzicbobVkpzBZT9FvOUKPeXKjTqallLbWvrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jL0xpL6Ow3mpvhOSuSo+GbXFL5in2ElCVYb4s3MPhRLOIfg/zW8D5wreTV2yE0dRH
	 sj9Me5ubJJqzN/aREOR3cieqPkIacEYaqJaplbA47oa/u39hGQEBt0zGLVzHrvsZCY
	 0RdlDPoxg3Ie43mu0nO3NC12r5TwIgPOCJnGaL3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Koira <eugkoira@amazon.com>,
	Nicolas Saenz Julienne <nsaenz@amazon.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.16 078/149] iommu/vt-d: Fix __domain_mapping()s usage of switch_to_super_page()
Date: Mon, 22 Sep 2025 21:29:38 +0200
Message-ID: <20250922192414.850962300@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1592,6 +1592,10 @@ static void switch_to_super_page(struct
 	unsigned long lvl_pages = lvl_to_nr_pages(level);
 	struct dma_pte *pte = NULL;
 
+	if (WARN_ON(!IS_ALIGNED(start_pfn, lvl_pages) ||
+		    !IS_ALIGNED(end_pfn + 1, lvl_pages)))
+		return;
+
 	while (start_pfn <= end_pfn) {
 		if (!pte)
 			pte = pfn_to_dma_pte(domain, start_pfn, &level,
@@ -1667,7 +1671,8 @@ __domain_mapping(struct dmar_domain *dom
 				unsigned long pages_to_remove;
 
 				pteval |= DMA_PTE_LARGE_PAGE;
-				pages_to_remove = min_t(unsigned long, nr_pages,
+				pages_to_remove = min_t(unsigned long,
+							round_down(nr_pages, lvl_pages),
 							nr_pte_to_next_page(pte) * lvl_pages);
 				end_pfn = iov_pfn + pages_to_remove - 1;
 				switch_to_super_page(domain, iov_pfn, end_pfn, largepage_lvl);


