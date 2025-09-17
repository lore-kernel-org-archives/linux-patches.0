Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C263330D39;
	Wed, 17 Sep 2025 12:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113562; cv=none; b=DybNBI99LtcEpjjA2enZ2YGafnMIMWnS3ZtxT77PrsSNt6T0mxi5SYrgbEEluf6xzNJeDJsoZMjXTTAhwDP/KPrPWp/cGfOgi+oLuvfcv2IMJIYaN8Q/HfQy6pXEu4SYuoVBSl2xWSjIjK0/u4zAXRoqRKg9sBdV2Aq8zadhWTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113562; c=relaxed/simple;
	bh=gPgVoiwBMCKhfmEVTATk8UJ4v6sWz+EcBF00SG0nt3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6LoxC8mDWcAicUYKMZCMY5XAgWFPmFIYuHvrducYZ7/DprhQ86hjjesSClxgqqtc1qNztP6J2pec1tnKMgkXH8ZZQtB+Y4+qou/RKpbqw5npSXrCFl21t35xMRfaYVZIxt1v5BQUm8rSftfg3YR9x/gqGqMOHkbOawd+ZipLJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PDLGWMnM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PDLGWMnM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E508C4CEF0;
	Wed, 17 Sep 2025 12:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113562;
	bh=gPgVoiwBMCKhfmEVTATk8UJ4v6sWz+EcBF00SG0nt3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PDLGWMnMogC87/z8GN4V79wZ37afmBHkTmKmueaEAAKAqr2IL9hCjiQaO921aHUq5
	 FqHEFR4EfceyBCaX/7ze3UbOX/r/CxSGqMxjW9bYZ2hPrUGcqeovtx8qdjDsuOhZkP
	 eDV3EJoU6Hkd4Qd9csufQTp7RjfDpisSAl4MUt1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	syzbot+417aeb05fd190f3a6da9@syzkaller.appspotmail.com,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Breno Leitao <leitao@debian.org>,
	David Hildenbrand <david@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 081/140] mm/hugetlb: add missing hugetlb_lock in __unmap_hugepage_range()
Date: Wed, 17 Sep 2025 14:34:13 +0200
Message-ID: <20250917123346.291198113@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

From: Jeongjun Park <aha310510@gmail.com>

[ Upstream commit 21cc2b5c5062a256ae9064442d37ebbc23f5aef7 ]

When restoring a reservation for an anonymous page, we need to check to
freeing a surplus.  However, __unmap_hugepage_range() causes data race
because it reads h->surplus_huge_pages without the protection of
hugetlb_lock.

And adjust_reservation is a boolean variable that indicates whether
reservations for anonymous pages in each folio should be restored.
Therefore, it should be initialized to false for each round of the loop.
However, this variable is not initialized to false except when defining
the current adjust_reservation variable.

This means that once adjust_reservation is set to true even once within
the loop, reservations for anonymous pages will be restored
unconditionally in all subsequent rounds, regardless of the folio's state.

To fix this, we need to add the missing hugetlb_lock, unlock the
page_table_lock earlier so that we don't lock the hugetlb_lock inside the
page_table_lock lock, and initialize adjust_reservation to false on each
round within the loop.

Link: https://lkml.kernel.org/r/20250823182115.1193563-1-aha310510@gmail.com
Fixes: df7a6d1f6405 ("mm/hugetlb: restore the reservation if needed")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Reported-by: syzbot+417aeb05fd190f3a6da9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=417aeb05fd190f3a6da9
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ Page vs folio differences ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5512,7 +5512,7 @@ void __unmap_hugepage_range(struct mmu_g
 	struct page *page;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
-	bool adjust_reservation = false;
+	bool adjust_reservation;
 	unsigned long last_addr_mask;
 	bool force_flush = false;
 
@@ -5604,6 +5604,7 @@ void __unmap_hugepage_range(struct mmu_g
 					sz);
 		hugetlb_count_sub(pages_per_huge_page(h), mm);
 		hugetlb_remove_rmap(page_folio(page));
+		spin_unlock(ptl);
 
 		/*
 		 * Restore the reservation for anonymous page, otherwise the
@@ -5611,14 +5612,16 @@ void __unmap_hugepage_range(struct mmu_g
 		 * If there we are freeing a surplus, do not set the restore
 		 * reservation bit.
 		 */
+		adjust_reservation = false;
+
+		spin_lock_irq(&hugetlb_lock);
 		if (!h->surplus_huge_pages && __vma_private_lock(vma) &&
 		    folio_test_anon(page_folio(page))) {
 			folio_set_hugetlb_restore_reserve(page_folio(page));
 			/* Reservation to be adjusted after the spin lock */
 			adjust_reservation = true;
 		}
-
-		spin_unlock(ptl);
+		spin_unlock_irq(&hugetlb_lock);
 
 		/*
 		 * Adjust the reservation for the region that will have the


