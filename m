Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFDE395266;
	Fri,  4 Sep 2026 05:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500891; cv=none; b=Lhz7uIqSmZh/9bAeJegXUl557hwcEJl0TbXo0NwQOJhHwyrUeSiAvkMiPZ2Nh86WaYhOHetAkxUy5pqFMfj8d+0iwcwY0vnJtPcqbLAEdo9zi/DIfKMfuGpUPLde0TMYZReR4aFhjYupVvzUZkUMBtsLmQl0jNdlhOcMG78zf8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500891; c=relaxed/simple;
	bh=QQVAoSvVJg4cLdKeLzhQ5Mm2gSw6KcsreqsCcBMe2CY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D1qCjybsx4kMb2uJtF4ewiuGhmnv3oOPihZ/iMl8ZZHkm1Argx+m30KkBCJOX1oCJtgB1qcKlqB7mPJ/1I9UJrnkE8md6ejk5cC/F9hzFQ2QNv2Jzbn4gqPKR/7U9ivlkvRtOaP7ndreaankTHFEAGWrduKDTIfKoxbj2qlerFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCvpksT7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCvpksT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702BD1F00A3D;
	Fri,  4 Sep 2026 05:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500890;
	bh=5Y/k5Q67QXwkuJHqo9BhKbe0YXIQPjB3aoZqzFtQ7cI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RCvpksT7kuKojlU8ZiPBMd0D9gsXNNoNqYL7IDGxnRgoUTtMLCcDle+ZqZOi3rv/M
	 zTLFEDbjPcwrMAfg6JVTevlhTjwAPgt0SMhtgdumvRw1zAmAl37QP3U6RfYWDwmlxp
	 YD0e4/HrbgpLs51oFo5TLBNkln8mpHgQAHwKACAA=
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
Subject: [PATCH 6.18 209/552] hugetlb: only adjust reservation during unmapping if mapcount is 0
Date: Fri,  4 Sep 2026 06:56:06 +0200
Message-ID: <20260904045754.068068862@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5876,6 +5876,7 @@ void __unmap_hugepage_range(struct mmu_g
 	bool adjust_reservation;
 	unsigned long last_addr_mask;
 
+	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
 	WARN_ON(!is_vm_hugetlb_page(vma));
 	BUG_ON(start & ~huge_page_mask(h));
 	BUG_ON(end & ~huge_page_mask(h));
@@ -5967,7 +5968,10 @@ void __unmap_hugepage_range(struct mmu_g
 
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
@@ -5975,7 +5979,7 @@ void __unmap_hugepage_range(struct mmu_g
 
 		spin_lock_irq(&hugetlb_lock);
 		if (!h->surplus_huge_pages && __vma_private_lock(vma) &&
-		    folio_test_anon(folio)) {
+		    !folio_mapped(folio) && folio_test_anon(folio)) {
 			folio_set_hugetlb_restore_reserve(folio);
 			/* Reservation to be adjusted after the spin lock */
 			adjust_reservation = true;


