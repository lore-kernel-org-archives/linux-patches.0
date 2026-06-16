Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1B743E490;
	Tue, 16 Jun 2026 16:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625714; cv=none; b=hG1KwfSpVGa5IMX94dJncxeT0tCAnf1fhU2kI1xEtcXaEuVdj895sBHPDzczKii26K8LltYgJlbqtJkVZU8aw3SxLddYv9D/7ttxgDd0FjXrYFT357tsqlFZTRLyKBjl8suhkvoxTiBHs1ZZHMgT/66KXv0+8LhUpAP6CvCyRKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625714; c=relaxed/simple;
	bh=1t1oi0SsAjKDkGyUUnfSTTVDhvudsuzebIJfI068g7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBTDQY5I/IcOqiXYjNFLwQAJZfYg6sGK4KnMIzgTtnAG1Uq3dncQsjr9dodnUAPdSRbJ0Q+EpH4PyqQ/+Oa6221WBzNFh7+rTtR5G0fenpeTeGN5ifF1M+zBsipj8YFz3NxzE5Adz//OrGH25hD9B+j8ut2FtKM2pgLZrPPl6zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Z7uzUd0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Z7uzUd0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2BF1F000E9;
	Tue, 16 Jun 2026 16:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625713;
	bh=S4fPSCCWLKUcx+QRt7W/x2MhWnvpOUQUE1PzR9NIEUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Z7uzUd0xexVnozwMdoA4amGnyui2lQT6DsTEkBa1YgBQ9rId0JoDZ9aOJh/AwNs+
	 CcKIXgzDb7FmIuGa+14DGYZWE2jMnus8+S1FeXRdrUd4D+MmDYyVFWml+uk79YG0BD
	 SgmTHBNx2hy7BNvw9HP41hSxcRmVn/PhVhvpojP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alistair Popple <apopple@nvidia.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 194/325] arm64: mm: call pagetable dtor when freeing hot-removed page tables
Date: Tue, 16 Jun 2026 20:29:50 +0530
Message-ID: <20260616145107.625844612@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Alistair Popple <apopple@nvidia.com>

commit c594b83457ccdee76d458416fb3bc9348a37592f upstream.

Since 5e8eb9aeeda3 ("arm64: mm: always call PTE/PMD ctor in
__create_pgd_mapping()") page-table allocation on ARM64 always calls
pagetable_{pte,pmd,pud,p4d}_ctor().  This sets the page_type to
PGTY_table, increments NR_PAGETABLE and possible allocates a PTL.  However
the matching pagetable_dtor() calls were never added.

With DEBUG_VM enabled on kernel versions prior to v6.17 without
2dfcd1608f3a9 ("mm/page_alloc: let page freeing clear any set page type")
this leads to the following warning when freeing these pages due to
page->page_type sharing page->_mapcount:

  BUG: Bad page state in process ... pfn:284fbb
  page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x284fbb
  flags: 0x17fffc000000000(node=0|zone=2|lastcpupid=0x1ffff)
  page_type: f2(table)
  page dumped because: nonzero mapcount
  Call trace:
   bad_page+0x13c/0x160
   __free_frozen_pages+0x6cc/0x860
   ___free_pages+0xf4/0x180
   free_pages+0x54/0x80
   free_hotplug_page_range.part.0+0x58/0x90
   free_empty_tables+0x438/0x500
   __remove_pgd_mapping.constprop.0+0x60/0xa8
   arch_remove_memory+0x48/0x80
   try_remove_memory+0x158/0x1d8
   offline_and_remove_memory+0x138/0x180

It can also lead to leaking the ptl allocation if ALLOC_SPLIT_PTLOCKS is
defined and incorrect NR_PAGETABLE stats.  Fix this by calling
pagetable_dtor() in free_hotplug_pgtable_page() prior to freeing the page
to undo the effects of calling pagetable_*_ctor().

Link: https://lore.kernel.org/20260521032730.2104017-1-apopple@nvidia.com
Fixes: 5e8eb9aeeda3 ("arm64: mm: always call PTE/PMD ctor in __create_pgd_mapping()")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/mmu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1447,6 +1447,7 @@ static void free_hotplug_page_range(stru
 
 static void free_hotplug_pgtable_page(struct page *page)
 {
+	pagetable_dtor(page_ptdesc(page));
 	free_hotplug_page_range(page, PAGE_SIZE, NULL);
 }
 


