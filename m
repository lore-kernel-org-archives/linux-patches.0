Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585594;
	b=H1462cUomdGDkyOZA3KrDgZEFCFpQ32XyRoYKVPqSXBk6rVkdYjGsqMlqHbCZ0QtwPak
	 Ev13qgJ2xOyeHWVEvpo5qG39HOrIB0lCa7rOsdYOKjGcKLvud5Kksr5fmJL2W/+LDN4Uo
	 D8Uuein1FD2pwrkURjEBN0DChKLv4XkroDvKNv2Ek43xY8YgseFH9obDh5XBtjy0GjILW
	 pq7pL3iJTFsTCsqLIsfIWXXB831uEyYuFl5j6+h+1/ZcLBEhLRWIOb78ojRhbPCq8hQOo
	 F2YrWWjMt7+5G4VHIONc8ZCQftXPvg5XGfJIwEwpsh34hLSDjjFW+is9PSOY9JGpa9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585594;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=scXohREPWtU8Q/6aOEM9Fdv2+0/zRiAA5g2EaS8S06o=;
	b=pSUWAC98gzsn32vOlNffMDj4oxbDCS4vHlU9+7wCU9lN+5yFSDz+cb43BKq+orzwdoY3
	 mOmFjYa3ll+6VrC/YtnaKwrcp3jSUleGBx6Eu51acATrU5cY6sIgRg9ip3KK+vZqsE7tO
	 qvxOdTfg3Apg/7ODqL4+ezAzraULA7zTdfGIGbPDWsIlV2W1DkV4AN4/QoITqSkYaxiEx
	 Nu13HvS24WdKFPiz6mYEzUkJHM5OlIhy1eM8qCmpBFv1i1qBeOpuIZIXq+eNBg2MRTWw2
	 A5dlO0/936TT8TD4O5s8/ORbg22TCRl8UMya6ki8VIRF08gT93/lZrVMq5fTZQvCM3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hSLGJulw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0CF606FFF4;
	Fri, 13 Nov 2026 15:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hSLGJulw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85451F000C4;
	Fri, 13 Nov 2026 15:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585594;
	bh=scXohREPWtU8Q/6aOEM9Fdv2+0/zRiAA5g2EaS8S06o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hSLGJulwm0hmd/7HMon8S/fQv7JrIsUp4ge1G1LDcmwxH+DlHsEQpRlEvDRxB839Z
	 ZEfQkK/CqSlXlvdszcb/twHGuLdJHkSJbC2RZjjPBtiBOjeu19DLZ6QrMkvO5gGg67
	 MsdheIwMwTbptyrjzLB/8A45vT/4pGs2WhZTcqJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kyle Zeng <kylebot@openai.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lance Yang <lance.yang@linux.dev>,
	Barry Song <baohua@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Ying Huang <huang.ying.caritas@gmail.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Chuanhua Han <hanchuanhua@oppo.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 222/507] mm: fix address wraparound when scanning large folio PTEs
Date: Fri, 13 Nov 2026 10:48:46 -0500
Message-ID: <20261113153802.014815707@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit f681d4580d5c3c749f623cda722a21aefd3147b3 ]

numa_rebuild_large_mapping() and do_swap_page() can be tricked into
generating an address wraparound, crashing the kernel. All that's required
is to map a tail page of a large folio close enough to the start/end of
the address space to e.g., make

	unsigned long addr_start = addr - (nr << PAGE_SHIFT);

to wrap around.

Let's fix it by providing a better helper, folio_scan_range(), that
takes care of staying within VMA and page table boundaries while
handling possible wraparounds.

There are some nasty details, like not being able to use pmd_addr_end()
in this context. Add some helpful comments for these cases.

Link: https://lore.kernel.org/20261014-folio_pte_scan_range-v2-1-00cf9bbaa364@kernel.org
Fixes: d2136d749d76 ("mm: support multi-size THP numa balancing")
Fixes: 508758960b8d ("mm: swap: entirely map large folios found in swapcache")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Kyle Zeng <kylebot@openai.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ying Huang <huang.ying.caritas@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory.c | 50 ++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 14 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 9eb7975e4a45e..ca6d7e08635ff 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4868,6 +4868,34 @@ static void check_swap_exclusive(struct folio *folio, swp_entry_t entry,
 	} while (--nr_pages);
 }
 
+/*
+ * Get the address range in which a folio might be mapped, assuming its pages
+ * are mapped consecutively and the folio page at the given idx is mapped at
+ * the given address.
+ */
+static void folio_pte_range(const struct folio *folio,
+		const struct vm_area_struct *vma, unsigned long addr,
+		unsigned long idx, unsigned long *start, unsigned long *end)
+{
+	/* Stay within the page table and VMA boundaries. */
+	const unsigned long pmd_start = addr & PMD_MASK;
+	const unsigned long pmd_end = pmd_start + PMD_SIZE;
+	const unsigned long lower = max(pmd_start, vma->vm_start);
+	/*
+	 * We cannot use pmd_addr_end(), as it does not clamp reliably. To
+	 * avoid wraparounds, compute using the inclusive end.
+	 */
+	const unsigned long upper = min(pmd_end - 1, vma->vm_end - 1) + 1;
+	const unsigned long offset = idx << PAGE_SHIFT;
+
+	/*
+	 * Avoid start/end addresses wrapping by not adding/subtracting more
+	 * than the lower/upper limits would allow.
+	 */
+	*start = addr - min(addr - lower, offset);
+	*end = addr + min(upper - addr, folio_size(folio) - offset);
+}
+
 /*
  * We enter with either the VMA lock or the mmap_lock held (see
  * FAULT_FLAG_VMA_LOCK), and pte mapped but not yet locked.
@@ -5050,16 +5078,15 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	address = vmf->address;
 	ptep = vmf->pte;
 	if (folio_test_large(folio) && folio_test_swapcache(folio)) {
-		int nr = folio_nr_pages(folio);
-		unsigned long idx = folio_page_idx(folio, page);
-		unsigned long folio_start = address - idx * PAGE_SIZE;
-		unsigned long folio_end = folio_start + nr * PAGE_SIZE;
+		const int nr = folio_nr_pages(folio);
+		const unsigned long idx = folio_page_idx(folio, page);
+		unsigned long folio_start, folio_end;
 		pte_t *folio_ptep;
 		pte_t folio_pte;
 
-		if (unlikely(folio_start < max(address & PMD_MASK, vma->vm_start)))
-			goto check_folio;
-		if (unlikely(folio_end > pmd_addr_end(address, vma->vm_end)))
+		folio_pte_range(folio, vma, address, idx, &folio_start,
+				&folio_end);
+		if (unlikely((folio_end - folio_start) >> PAGE_SHIFT != nr))
 			goto check_folio;
 
 		folio_ptep = vmf->pte - idx;
@@ -6209,16 +6236,11 @@ static void numa_rebuild_large_mapping(struct vm_fault *vmf, struct vm_area_stru
 				       struct folio *folio, pte_t fault_pte,
 				       bool ignore_writable, bool pte_write_upgrade)
 {
-	int nr = pte_pfn(fault_pte) - folio_pfn(folio);
+	const unsigned long idx = pte_pfn(fault_pte) - folio_pfn(folio);
 	unsigned long start, end, addr = vmf->address;
-	unsigned long addr_start = addr - (nr << PAGE_SHIFT);
-	unsigned long pt_start = ALIGN_DOWN(addr, PMD_SIZE);
 	pte_t *start_ptep;
 
-	/* Stay within the VMA and within the page table. */
-	start = max3(addr_start, pt_start, vma->vm_start);
-	end = min3(addr_start + folio_size(folio), pt_start + PMD_SIZE,
-		   vma->vm_end);
+	folio_pte_range(folio, vma, addr, idx, &start, &end);
 	start_ptep = vmf->pte - ((addr - start) >> PAGE_SHIFT);
 
 	/* Restore all PTEs' mapping of the large folio */
-- 
2.53.0



