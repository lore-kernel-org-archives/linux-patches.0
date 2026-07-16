Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C47442376D;
	Thu, 16 Jul 2026 14:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211324; cv=none; b=jjdC9owd0sseXioG1nNanPeByEHnPXkYyr6/FpDk7BTWjGN97AurqNbqrf1HRHd9fRdunInY16vDC8ukbJYNeSkvT2+qpzmmSkSk53vpFrLLXZCsz68CSzmwIVMyhhS6qceiD3qfb8nCdFjs6vmJxdCRORkJoluR49cDG8lkrYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211324; c=relaxed/simple;
	bh=+22XLIsfYhtc5U3nJOZNDPLh7Q62R9q9P3/bvjYnypM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQjfWN02KaVw75hJgae9oIEPklnnSP9wKDvZkrDRly/QJraLEZ/7Y5DE5ky+9wBtiQirMYvWfclarZRXGrVdyn0aLx/Gu+b8ESKLqgPz6pyqvFCuUzmHuQUz3oT2G5J72KBjCH8fOLzRTAoRmJ2Yy/uYWZbPkgZJ1rLF/IE6Wl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ie4/Mkp5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ie4/Mkp5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E321F000E9;
	Thu, 16 Jul 2026 14:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211322;
	bh=lLNiJPfT+wYJoABwHEyrLHH2uranxStddeuZw/vI880=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ie4/Mkp5BU17pTboXRbAWgoOaGv0/MudjZxDZzXhNxsOitJF5yqiJfaaWRiEWqcnL
	 7agknUjAgPLCkXydKD59dGO4KrTKyZhdKI/HeRlXKhrrglB8MUpSLTUhsfo/RiW/zP
	 Wn7uoTIcJ6riA4fyyqJQVTV8UPKjZoCoFfLugzbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH 6.18 385/480] x86/mm: Fix freeing of PMD-sized vmemmap pages
Date: Thu, 16 Jul 2026 15:32:12 +0200
Message-ID: <20260716133053.129534983@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: David Hildenbrand (Arm) <david@kernel.org>

commit 39406c05f8f150f1685839acd38ffdd69ff92031 upstream.

Commit bf9e4e30f353 ("x86/mm: use pagetable_free()"), switched from
freeing non-boot page tables through __free_pages() to
pagetable_free().

However, the function is also called to free vmemmap pages.

Given that vmemmap pages are not page tables, already the page_ptdesc(page)
is wrong. But worse, pagetable_free() calls:

	__free_pages(page, compound_order(page));

Since vmemmap pages are not compound pages (see vmemmap_alloc_block())
-- except for HVO, which doesn't apply here -- only first page of a
PMD-sized vmemmap page is freed, leaking the other ones.

Fix it by properly decoupling pagetable and vmemmap freeing.
free_pagetable() no longer has to mess with SECTION_INFO, as only the
vmemmap is marked like that in register_page_bootmem_memmap().

The indentation in remove_pmd_table() is messed up. Fix that while
touching it.

Bootmem info handling will soon be fixed up. For now, handle it
similar to free_pagetable(), just avoiding the ifdef.

[ dhansen: changelog munging. More imperative voice ]

Fixes: bf9e4e30f353 ("x86/mm: use pagetable_free()")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Link: https://lore.kernel.org/20260429-vmemmap-v2-1-8dfcacffd877@kernel.org
Link: https://patch.msgid.link/20260429-vmemmap-v2-1-8dfcacffd877@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/init_64.c |   40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1021,7 +1021,7 @@ static void __meminit free_pagetable(str
 #ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
 		enum bootmem_type type = bootmem_type(page);
 
-		if (type == SECTION_INFO || type == MIX_SECTION_INFO) {
+		if (type == MIX_SECTION_INFO) {
 			while (nr_pages--)
 				put_page_bootmem(page++);
 		} else {
@@ -1035,13 +1035,24 @@ static void __meminit free_pagetable(str
 	}
 }
 
-static void __meminit free_hugepage_table(struct page *page,
+static void __meminit free_vmemmap_pages(struct page *page, unsigned int order,
 		struct vmem_altmap *altmap)
 {
-	if (altmap)
-		vmem_altmap_free(altmap, PMD_SIZE / PAGE_SIZE);
-	else
-		free_pagetable(page, get_order(PMD_SIZE));
+	unsigned long nr_pages = 1u << order;
+
+	if (altmap) {
+		vmem_altmap_free(altmap, nr_pages);
+	} else if (PageReserved(page)) {
+		if (IS_ENABLED(CONFIG_HAVE_BOOTMEM_INFO_NODE) &&
+		    bootmem_type(page) == SECTION_INFO) {
+			while (nr_pages--)
+				put_page_bootmem(page++);
+		} else {
+			free_reserved_pages(page, nr_pages);
+		}
+	} else {
+		__free_pages(page, order);
+	}
 }
 
 static void __meminit free_pte_table(pte_t *pte_start, pmd_t *pmd)
@@ -1125,7 +1136,8 @@ remove_pte_table(pte_t *pte_start, unsig
 			return;
 
 		if (!direct)
-			free_pagetable(pte_page(*pte), 0);
+			/* We never populate base pages from the altmap. */
+			free_vmemmap_pages(pte_page(*pte), 0, NULL);
 
 		spin_lock(&init_mm.page_table_lock);
 		pte_clear(&init_mm, addr, pte);
@@ -1160,19 +1172,19 @@ remove_pmd_table(pmd_t *pmd_start, unsig
 			if (IS_ALIGNED(addr, PMD_SIZE) &&
 			    IS_ALIGNED(next, PMD_SIZE)) {
 				if (!direct)
-					free_hugepage_table(pmd_page(*pmd),
-							    altmap);
+					free_vmemmap_pages(pmd_page(*pmd),
+							   PMD_ORDER, altmap);
 
 				spin_lock(&init_mm.page_table_lock);
 				pmd_clear(pmd);
 				spin_unlock(&init_mm.page_table_lock);
 				pages++;
 			} else if (vmemmap_pmd_is_unused(addr, next)) {
-					free_hugepage_table(pmd_page(*pmd),
-							    altmap);
-					spin_lock(&init_mm.page_table_lock);
-					pmd_clear(pmd);
-					spin_unlock(&init_mm.page_table_lock);
+				free_vmemmap_pages(pmd_page(*pmd), PMD_ORDER,
+						   altmap);
+				spin_lock(&init_mm.page_table_lock);
+				pmd_clear(pmd);
+				spin_unlock(&init_mm.page_table_lock);
 			}
 			continue;
 		}


