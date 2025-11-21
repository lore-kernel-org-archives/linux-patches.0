Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF5D54763;
	Fri, 21 Nov 2025 13:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731361; cv=none; b=Gl++ZYD1I2eOPnwskQzyxR2LoRP2c+auYu7D4UOAYXxdmAAs+AweXfmkVbg71NmoA5urmwTmo9082XP3dE1AfFhSISqfL46QrIAhZ7tbBl8l1QiM/RIzpI4EJNk3t5pNwJ7O+/lKYiEEAqQGyAW4NpG5w7JoA1nlF8jFZPPHRq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731361; c=relaxed/simple;
	bh=Y4/fPPodj75Iuv7whpf7nwnZVs/z74V/u9mhFYt6c+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNDwKJ6+uqfmFklA4P31ym4MQ3HtpJTDghk1W6BOlKCeiMFyh9tn6kS8Yvc6vqkjQVAg6+QST5zkoOzcJql6DSY7OfyWpaXwLniHaKOVfeZ3OeUXJQAwZqvJD5/YSdpPBmA2615KMwQRa4FQuY0nJrKEZvj/MevbqLMf7gLy9Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hcGaTwHK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hcGaTwHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23565C4CEF1;
	Fri, 21 Nov 2025 13:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731361;
	bh=Y4/fPPodj75Iuv7whpf7nwnZVs/z74V/u9mhFYt6c+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hcGaTwHKH9pk/O69WIt8OZK80jms4HeRszpP1ESd3lae2P3iIVSM2MpsSB+IgrJlw
	 ifPX2nA4Ai4K4bVqN5hMxwiPVMstfLbH7lHYUCCMOLrvzNqnfxG2mZ8d1khAt+LhfV
	 MXbpxPWKYUEQ8BATJuXrCrZA70BUGgY+A5Ns9hvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Pankaj Raghav <kernel@pankajraghav.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Jane Chu <jane.chu@oracle.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Luis Chamberalin <mcgrof@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 181/247] mm/huge_memory: preserve PG_has_hwpoisoned if a folio is split to >0 order
Date: Fri, 21 Nov 2025 14:12:08 +0100
Message-ID: <20251121130201.219084291@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zi Yan <ziy@nvidia.com>

commit fa5a061700364bc28ee1cb1095372f8033645dcb upstream.

folio split clears PG_has_hwpoisoned, but the flag should be preserved in
after-split folios containing pages with PG_hwpoisoned flag if the folio
is split to >0 order folios.  Scan all pages in a to-be-split folio to
determine which after-split folios need the flag.

An alternatives is to change PG_has_hwpoisoned to PG_maybe_hwpoisoned to
avoid the scan and set it on all after-split folios, but resulting false
positive has undesirable negative impact.  To remove false positive,
caller of folio_test_has_hwpoisoned() and folio_contain_hwpoisoned_page()
needs to do the scan.  That might be causing a hassle for current and
future callers and more costly than doing the scan in the split code.
More details are discussed in [1].

This issue can be exposed via:
1. splitting a has_hwpoisoned folio to >0 order from debugfs interface;
2. truncating part of a has_hwpoisoned folio in
   truncate_inode_partial_folio().

And later accesses to a hwpoisoned page could be possible due to the
missing has_hwpoisoned folio flag.  This will lead to MCE errors.

Link: https://lore.kernel.org/all/CAHbLzkoOZm0PXxE9qwtF4gKR=cpRXrSrJ9V9Pm2DJexs985q4g@mail.gmail.com/ [1]
Link: https://lkml.kernel.org/r/20251023030521.473097-1-ziy@nvidia.com
Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yang Shi <yang@os.amperecomputing.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Pankaj Raghav <kernel@pankajraghav.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3271,6 +3271,14 @@ bool can_split_folio(struct folio *folio
 					caller_pins;
 }
 
+static bool page_range_has_hwpoisoned(struct page *page, long nr_pages)
+{
+	for (; nr_pages; page++, nr_pages--)
+		if (PageHWPoison(page))
+			return true;
+	return false;
+}
+
 /*
  * It splits @folio into @new_order folios and copies the @folio metadata to
  * all the resulting folios.
@@ -3278,17 +3286,24 @@ bool can_split_folio(struct folio *folio
 static void __split_folio_to_order(struct folio *folio, int old_order,
 		int new_order)
 {
+	/* Scan poisoned pages when split a poisoned folio to large folios */
+	const bool handle_hwpoison = folio_test_has_hwpoisoned(folio) && new_order;
 	long new_nr_pages = 1 << new_order;
 	long nr_pages = 1 << old_order;
 	long i;
 
+	folio_clear_has_hwpoisoned(folio);
+
+	/* Check first new_nr_pages since the loop below skips them */
+	if (handle_hwpoison &&
+	    page_range_has_hwpoisoned(folio_page(folio, 0), new_nr_pages))
+		folio_set_has_hwpoisoned(folio);
 	/*
 	 * Skip the first new_nr_pages, since the new folio from them have all
 	 * the flags from the original folio.
 	 */
 	for (i = new_nr_pages; i < nr_pages; i += new_nr_pages) {
 		struct page *new_head = &folio->page + i;
-
 		/*
 		 * Careful: new_folio is not a "real" folio before we cleared PageTail.
 		 * Don't pass it around before clear_compound_head().
@@ -3330,6 +3345,10 @@ static void __split_folio_to_order(struc
 				 (1L << PG_dirty) |
 				 LRU_GEN_MASK | LRU_REFS_MASK));
 
+		if (handle_hwpoison &&
+		    page_range_has_hwpoisoned(new_head, new_nr_pages))
+			folio_set_has_hwpoisoned(new_folio);
+
 		new_folio->mapping = folio->mapping;
 		new_folio->index = folio->index + i;
 
@@ -3430,8 +3449,6 @@ static int __split_unmapped_folio(struct
 	if (folio_test_anon(folio))
 		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
 
-	folio_clear_has_hwpoisoned(folio);
-
 	/*
 	 * split to new_order one order at a time. For uniform split,
 	 * folio is split to new_order directly.


