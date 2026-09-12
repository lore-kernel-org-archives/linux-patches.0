Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F1E2D0C75;
	Sat, 12 Sep 2026 11:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213093; cv=none; b=r5DbatuSdjGZyT4AgUSXmqOyPsWwd0jdZ6fv53ZLzThlMgOJ+G9qHIJZvXgwh0NOOIdYx1nTdTfLWQhvUf2iPUU5mgtPzd9pTZiRJqoEfKxlArIPMdvy+ODv5U83d45nNUHVeoAof8tRWjrsaexAO5IJY6eHDVoTtBnssUPSVzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213093; c=relaxed/simple;
	bh=ZFx7VnL0TUQSAFLjXndPtUydnvYNbmwir3yXc1DdOUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BVwFzT2+MEOx0CbWACCRTrt2HwmFtkmb7FwLFk+PPXrhMugQVOFCsv6RTE5gOrCLHvmcPICRBVBgBRh6WfE9RtCLec1Ja2ycqr3eDwCCE7utIl4eP3a9ZOWTx1C+tNBEUW/feeNoGWCfam4jxo2H4d1hnq9hA7gE70dHa1sUvVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1sMud0kA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1sMud0kA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1B61F000FF;
	Sat, 12 Sep 2026 11:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213091;
	bh=BqB6vSRhSj61GiQPeXfa/SPZwBl774hGhS3aMTnXEz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1sMud0kAQ2Aj8UDxxH6Wc8gqaFpaT5WU0PyHE9YzZNvJJ4rQMyy/r0A+LZW5P1d6k
	 /vKEOSni02h+cD0KFYy321/Sn8fDep4i7ullWg/QEMIgItDBPiyjYFGivHT3jqnM3A
	 Sbwd0HYr2f2zLtg/1CnaUdl3TB72fBiu43WQcmLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Morin <guillaume@morinfr.org>,
	Breno Leitao <leitao@debian.org>,
	Rik van Riel <riel@surriel.com>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0009/1376] hugetlb: only adjust reservation during unmapping if mapcount is 0
Date: Sat, 12 Sep 2026 08:40:35 +0200
Message-ID: <20260912065607.758135379@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Guillaume Morin <guillaume@morinfr.org>

[ Upstream commit 5120b1e048d48596ffaec1a8412012a91adba73b ]

Since df7a6d1f6405, __unmap_hugepage_range can adjust reservations.  In
the case of folio mapped in both a parent and a child, if the parent
unmaps the range first, the reservation adjustment will result in an
underflow of the reserved count.  Once the child unmaps the range, the
count is restored.  Change __unmap_hugepage_range() to check the mapcount
before adjusting the reservation.

Link: https://lore.kernel.org/all/alEJkwn5VlTTH_ZX@bender.morinfr.org/
Link: https://lore.kernel.org/amkC_1Ya6OiUoiLZ@bender.morinfr.org
Fixes: df7a6d1f6405 ("mm/hugetlb: restore the reservation if needed")
Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e910ed0c43d0b..185faeaf5c08e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5523,6 +5523,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	bool adjust_reservation;
 	unsigned long last_addr_mask;
 
+	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
 	WARN_ON(!is_vm_hugetlb_page(vma));
 	BUG_ON(start & ~huge_page_mask(h));
 	BUG_ON(end & ~huge_page_mask(h));
@@ -5613,7 +5614,10 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 		/*
 		 * Restore the reservation for anonymous page, otherwise the
-		 * backing page could be stolen by someone.
+		 * backing page could be stolen by someone. Restore only on the
+		 * last unmap, otherwise the owner could empty its resv map
+		 * while the folio is still mapped by a child. Note that holding
+		 * i_mmap_lock_write is needed to check the number of mappings.
 		 * If there we are freeing a surplus, do not set the restore
 		 * reservation bit.
 		 */
@@ -5621,7 +5625,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 		spin_lock_irq(&hugetlb_lock);
 		if (!h->surplus_huge_pages && __vma_private_lock(vma) &&
-		    folio_test_anon(page_folio(page))) {
+		    !folio_mapped(page_folio(page)) && folio_test_anon(page_folio(page))) {
 			folio_set_hugetlb_restore_reserve(page_folio(page));
 			/* Reservation to be adjusted after the spin lock */
 			adjust_reservation = true;
-- 
2.53.0



