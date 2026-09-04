Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6D134A77D;
	Fri,  4 Sep 2026 05:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499087; cv=none; b=irTbTZrLekQAaMwcEzr+Ohx9kVM+cG5gximmfkEJc4MVfRB1rYX84yp2hpzlIbaMD/j0HoyAoRUXtQiOAK8jDy+1V+V8N+Rgc3Fh1LuTifSnDxnogVgXxrC633qZNNR1wTIWBLiVgaXw6nVzd5SQCi6HesKgsnh7KiZxC85k8pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499087; c=relaxed/simple;
	bh=usx9PxFPVEeWcjP0f2ifhgm3VpWkd+9XTcp9hQ2bMVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TkkBKi8vbDO96t8OWlsx1c5m4BbsepjcfbQnUlYhBWpVDPwK11WoHs43xcxb4PNJ1NjWd+aCeev5lc9PNANvCxXAcuj/VLbcMobpCoAFzZuP3/Rvvz5/oW1u4kKgL1F1jw5Y+KmGgQiOTsfKK62h9+uVd83owGjkn2RqO10DMI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cxnlcc2z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cxnlcc2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DACED1F00A3D;
	Fri,  4 Sep 2026 05:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499086;
	bh=7DIsfObO1+PDV2NROUUhafSYElZW2QwR+BDv0ujIR7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cxnlcc2zVX3zOkL3XbVZ9LeIaIt4YuA5Am42lWA+PRox+FUx0FyR+YOCZHocvPb9S
	 EV3CvOTX0Flo+JkyDdzoX3Wit+Oxzs4jJChDkcw5GIFLsdlf5EWvW2QMa/ATez9H6x
	 /Y8L/DcwEhfArHoZw4bCFOcLKXHM8RJMAZLlPYZs=
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
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 292/713] hugetlb: only adjust reservation during unmapping if mapcount is 0
Date: Fri,  4 Sep 2026 06:54:20 +0200
Message-ID: <20260904045810.387223818@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume Morin <guillaume@morinfr.org>

commit 5120b1e048d48596ffaec1a8412012a91adba73b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5181,6 +5181,7 @@ void __unmap_hugepage_range(struct mmu_g
 	bool adjust_reservation;
 	unsigned long last_addr_mask;
 
+	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
 	WARN_ON(!is_vm_hugetlb_page(vma));
 	BUG_ON(start & ~huge_page_mask(h));
 	BUG_ON(end & ~huge_page_mask(h));
@@ -5272,7 +5273,10 @@ void __unmap_hugepage_range(struct mmu_g
 
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
@@ -5280,7 +5284,7 @@ void __unmap_hugepage_range(struct mmu_g
 
 		spin_lock_irq(&hugetlb_lock);
 		if (!h->surplus_huge_pages && __vma_private_lock(vma) &&
-		    folio_test_anon(folio)) {
+		    !folio_mapped(folio) && folio_test_anon(folio)) {
 			folio_set_hugetlb_restore_reserve(folio);
 			/* Reservation to be adjusted after the spin lock */
 			adjust_reservation = true;


