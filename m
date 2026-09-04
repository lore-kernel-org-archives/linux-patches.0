Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3441B3876B3;
	Fri,  4 Sep 2026 05:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498407; cv=none; b=iuhR9ElRFyxHFGIAVWhEbWlAxz3BrXU7FsHB/hCWXRMOyiwfcGqy8y9phmGS2XVh0pxVeaOmyMpFalhmnEkslwUUeCdqVw4Lq9/klankCorcnLSFwFjUAn1sOImX6RwxhZqmWtcrFoBhL38via/W6gFmUQAxob6nk1g9EWCBxQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498407; c=relaxed/simple;
	bh=Txz0JeLOtK1F77csgAicdCiuK3Guc+e1PNfv87gpwn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUm3nvbp/nWRr6AcUVbZ+pcRPLJrzg0csWfcRoCQpjADxaWHykMK5xWcVeMZfg/n21xgW65gpwC0QBYrTNSGAy8ZfDsabVfZ/ENxzTXdaPnsV2qBHWVbm/GkDqApx582atyj9XgnPRF3jq+fTtI3Vluzjgf9XSBT5ODxruu5OIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HaFMwK6N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HaFMwK6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0DC1F00A3D;
	Fri,  4 Sep 2026 05:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498406;
	bh=UvwE96G7ctkdBYcr7NKWqT9jbELNkvqZQ/2OlKul9rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HaFMwK6NJfEOaV+D6ahb17uMaiv9w+kbCR73l7Oxuwt5gvJN2IoVRJl/5jKWyMLO5
	 zwUNzoOEYjK0UGVNmjz3Hi+LWQLX//MoxU9eI6k7BjDK38s486oQrh/QKgdYhXY8sM
	 XRrs3hvNJd/6VIYguWxvv4gM6wPZwSW7D+HpAIno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <songmuchun@bytedance.com>,
	Oscar Salvador <osalvador@suse.de>,
	Frank van der Linden <fvdl@google.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Oscar Salvador (SUSE)" <osalvador@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 052/713] mm/hugetlb_vmemmap: fix __hugetlb_vmemmap_optimize_folios()
Date: Fri,  4 Sep 2026 06:50:20 +0200
Message-ID: <20260904045804.996619203@linuxfoundation.org>
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

From: Muchun Song <songmuchun@bytedance.com>

commit 6e25c6a9c7eff141ecfc966ecdb7801db2a8810e upstream.

__hugetlb_vmemmap_optimize_folios() uses incorrect arguments when handling
bootmem HugeTLB folios.

The section number passed to register_page_bootmem_memmap() is derived
from the vmemmap virtual address of folio->page instead of the folio PFN,
so the bootmem memmap metadata can be registered against the wrong
section.  The helper is also given HUGETLB_VMEMMAP_RESERVE_SIZE even
though it expects a page count, not a size in bytes.  In addition, the
write-protect range is based on pages_per_huge_page(h), which does not
cover the full HugeTLB vmemmap area and can leave part of the shared tail
vmemmap mapping writable.

Fix the section lookup to use folio_pfn(folio), use
HUGETLB_VMEMMAP_RESERVE_PAGES when registering the reserved memmap pages,
and use hugetlb_vmemmap_size(h) for the write-protect range.

Link: https://lore.kernel.org/20260612035903.2468601-3-songmuchun@bytedance.com
Fixes: 752fe17af693 ("mm/hugetlb: add pre-HVO framework")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Frank van der Linden <fvdl@google.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb_vmemmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -635,12 +635,12 @@ static void __hugetlb_vmemmap_optimize_f
 			 * mirrored tail page structs RO.
 			 */
 			spfn = (unsigned long)&folio->page;
-			epfn = spfn + pages_per_huge_page(h);
+			epfn = spfn + hugetlb_vmemmap_size(h);
 			vmemmap_wrprotect_hvo(spfn, epfn, folio_nid(folio),
 					HUGETLB_VMEMMAP_RESERVE_SIZE);
-			register_page_bootmem_memmap(pfn_to_section_nr(spfn),
+			register_page_bootmem_memmap(pfn_to_section_nr(folio_pfn(folio)),
 					&folio->page,
-					HUGETLB_VMEMMAP_RESERVE_SIZE);
+					HUGETLB_VMEMMAP_RESERVE_PAGES);
 			continue;
 		}
 


