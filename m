Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1E0423A85;
	Wed,  9 Sep 2026 14:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964910; cv=none; b=ZmnhoJvaCJlj6PJERiVW29cCso/H51fA70RUjT9qjpKSlkk3XbjLMzxwk6YpQ8JXmN1EnG4kwhvT+dOyKvr4ngvN8mIfoK721u8kAefINJvmaHZXIGxs3hK/2k1GRtsQnzHEuJ2+VgRbOACj7e/qko/YugJiVPM7EMlLtncX//c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964910; c=relaxed/simple;
	bh=Gs9WClKIN4Le7vzgUgPjhvrUFNPmTZ587yPmJplK+DY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HnuaofL7R/yg2WcuB1zb+CtvKU2mSeEyV47NWYy3xN4QMcCyh22g/k148mnt0nu1Jya+QKSGoz3K1teomh46UHKsTRvmB3thDg9mJ0utWhYk5N078cgvTrpJk+0raM07Pdgtd9AZYG5gaRWjMfM9XrckADXQpXy0q0hBOKUpo38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fI+SEGAq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fI+SEGAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7670C1F00A3A;
	Wed,  9 Sep 2026 14:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964909;
	bh=M0pzTVlwghKxdkveLMY54ASKGi0e1K7c0GxEkCneW+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fI+SEGAqzXx3KVdlp3eLb0H0OyOTXDrxygT7mVaUoz5czmKaQfbuBdeski+bhHlm1
	 VtCnxzBiEb4zLRr0gjOuasvVEFUe3Xkvt7ucW1+cQLoDRQn61ANGMe89a0rj/umvDX
	 H3EgLiYME7z8FcIL6OVDDI92Li1QcwyX69D2Ce7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiryl Shutsemau <kas@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Baoquan He <bhe@redhat.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Frank van der Linden <fvdl@google.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	WANG Xuerui <kernel@xen0n.name>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 560/583] mm: rework compound_head() for power-of-2 sizeof(struct page)
Date: Wed,  9 Sep 2026 15:44:05 +0200
Message-ID: <20260909134257.082447399@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Kiryl Shutsemau <kas@kernel.org>

[ Upstream commit 8c846c879e226c312c2c7a7bc1e323779903530f ]

For tail pages, the kernel uses the 'compound_info' field to get to the
head page.  The bit 0 of the field indicates whether the page is a tail
page, and if set, the remaining bits represent a pointer to the head page.

For cases when size of struct page is power-of-2, change the encoding of
compound_info to store a mask that can be applied to the virtual address
of the tail page in order to access the head page.  It is possible because
struct page of the head page is naturally aligned with regards to order of
the page.

The significant impact of this modification is that all tail pages of the
same order will now have identical 'compound_info', regardless of the
compound page they are associated with.  This paves the way for
eliminating fake heads.

The HugeTLB Vmemmap Optimization (HVO) creates fake heads and it is only
applied when the sizeof(struct page) is power-of-2.  Having identical tail
pages allows the same page to be mapped into the vmemmap of all pages,
maintaining memory savings without fake heads.

If sizeof(struct page) is not power-of-2, there is no functional changes.

Limit mask usage to HugeTLB vmemmap optimization (HVO) where it makes a
difference.  The approach with mask would work in the wider set of
conditions, but it requires validating that struct pages are naturally
aligned for all orders up to the MAX_FOLIO_ORDER, which can be tricky.

Link: https://lkml.kernel.org/r/20260227194302.274384-8-kas@kernel.org
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

[ stable: Drop the original compound_info conversion, which depends on
  preparatory interface changes absent from this tree and is not needed by
  the target fix.  Move the stable-only HVO static-key increment ahead of
  the target's context without changing its behavior. ]

For tail pages, the kernel uses the 'compound_info' field to get to the
head page.  The bit 0 of the field indicates whether the page is a tail
page, and if set, the remaining bits represent a pointer to the head page.

For cases when size of struct page is power-of-2, change the encoding of
compound_info to store a mask that can be applied to the virtual address
of the tail page in order to access the head page.  It is possible because
struct page of the head page is naturally aligned with regards to order of
the page.

The significant impact of this modification is that all tail pages of the
same order will now have identical 'compound_info', regardless of the
compound page they are associated with.  This paves the way for
eliminating fake heads.

The HugeTLB Vmemmap Optimization (HVO) creates fake heads and it is only
applied when the sizeof(struct page) is power-of-2.  Having identical tail
pages allows the same page to be mapped into the vmemmap of all pages,
maintaining memory savings without fake heads.

If sizeof(struct page) is not power-of-2, there is no functional changes.

Limit mask usage to HugeTLB vmemmap optimization (HVO) where it makes a
difference.  The approach with mask would work in the wider set of
conditions, but it requires validating that struct pages are naturally
aligned for all orders up to the MAX_FOLIO_ORDER, which can be tricky.

[ sashal: Reduced backport -- upstream 8c846c879e226 touches 3 file(s), this
  backport carries 1. Not backported here:
  include/linux/page-flags.h
  mm/slab.h
  mm/util.c
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: 6e25c6a9c7ef ("mm/hugetlb_vmemmap: fix __hugetlb_vmemmap_optimize_folios()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb_vmemmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -618,6 +618,8 @@ static void __hugetlb_vmemmap_optimize_f
 		unsigned long spfn, epfn;
 
 		if (boot && folio_test_hugetlb_vmemmap_optimized(folio)) {
+			static_branch_inc(&hugetlb_optimize_vmemmap_key);
+
 			/*
 			 * Already optimized by pre-HVO, just map the
 			 * mirrored tail page structs RO.
@@ -629,7 +631,6 @@ static void __hugetlb_vmemmap_optimize_f
 			register_page_bootmem_memmap(pfn_to_section_nr(spfn),
 					&folio->page,
 					HUGETLB_VMEMMAP_RESERVE_SIZE);
-			static_branch_inc(&hugetlb_optimize_vmemmap_key);
 			continue;
 		}
 


