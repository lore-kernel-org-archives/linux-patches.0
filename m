Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E22423A85;
	Wed,  9 Sep 2026 13:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962211; cv=none; b=qYLUyCQj/+1ZRM4GqbEFweG3IOtvi6jut9eG5sbLLs0w3IrlUklurIt4KWPPNGtPnFsj/YW5N6pdKUAVAY0FwnOAe/f8Y9vXWjgeq2uZYm/U0nO/VZ5ERgKMNrrOndwetN8D5f2wOZQb1C+3rX84gRhKA/ifSwxxCwWCM7HtDVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962211; c=relaxed/simple;
	bh=/Ey/YyaDFj/Wg/eWXwgyT3gt0cd/SX8k8E1qHJBlOjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpFuhWVA/Fp32GsfAcakCQ/dS15+QcU6PG2m4pEZZwOQuRGZw9TuHXYwwKw8qEVn9yxsPbk4WSjSJ9Z5IHzqCXMreJNXBvV6lVjXp4QESpV80HEEsl6aNqWpsyIM2L3o6SwBdeHEhhFZzmaN7AznRhHuObJFFT7yEJTpLt356eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LHr8VmQa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LHr8VmQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E181F00A3A;
	Wed,  9 Sep 2026 13:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962209;
	bh=ZIK00ns2+iZPpYV+ffPO8zRdckPQZYpHoVNonJJPAUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LHr8VmQaOT8FLUPrLM5UJDa1gKXUbZO3qRIjNi0DuBh2GXB/jJSvqDpCmb9d8p8qE
	 8FiJTluCMYxndVeBfsyzW2BjW0SyE3Fq1hK1hLRfOqyse0JMe3qt47Xp/wux/Z367A
	 ULM6waI/cg4LZ7YFM6I7SeX59Dwlm2fPFvEu5of4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sourav Panda <souravpanda@google.com>,
	Muchun Song <muchun.song@linux.dev>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Frank van der Linden <fvdl@google.com>,
	Greg Thelen <gthelen@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Michal Hocko <mhocko@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	Rik van Riel <riel@surriel.com>,
	SeongJae Park <sj@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 171/556] mm/hugetlb_cma: fix null nodemask dereference in hugetlb_cma_alloc_frozen_folio
Date: Wed,  9 Sep 2026 15:37:31 +0200
Message-ID: <20260909134236.437599973@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Sourav Panda <souravpanda@google.com>

commit 7b8a8ae4dd176a232e973017d2aa3c536a7275e2 upstream.

alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
alloc_fresh_hugetlb_folio() as a fallback to allocate from all nodes.  If
order is gigantic, alloc_fresh_hugetlb_folio() propagates the NULL
nodemask down to hugetlb_cma_alloc_frozen_folio() via
alloc_gigantic_frozen_folio().

Additionally, hugetlb_cma_alloc_frozen_folio() previously attempted
allocation on hugetlb_cma[nid] without verifying if nid is included in the
caller's nodemask.  Adding a node_isset(nid, *nodemask) check ensures the
initial preferred node allocation honors the memory policy / nodemask.

However, hugetlb_cma_alloc_frozen_folio() dereferences the nodemask in
node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
leading to a null pointer dereference kernel panic when nodemask is NULL.

Fix this by checking if nodemask is NULL in
hugetlb_cma_alloc_frozen_folio() and defaulting it to
cpuset_current_mems_allowed.  Enclose the allocation attempts within the
cpuset seqcount retry loop so that if the cpuset changes concurrently
during allocation, the attempts are retried using the updated nodemask.
This ensures that the initial node check and fallback loop safely honor
the task's cpuset without violating cpuset constraints or causing NULL
pointer dereferences or unexpected allocation failures.

>From a userspace perspective, this bug allows an unprivileged user to
crash the kernel (trigger a panic) by requesting a gigantic hugepage
allocation with MPOL_PREFERRED_MANY on a system where CMA is only
configured on a subset of NUMA nodes.

This can be reproduced by booting a VM with two NUMA nodes, restricting
CMA to Node 1 (e.g., hugetlb_cma=1:1G default_hugepagesz=1G hugepagesz=1G
hugepages=0), and running a program that allocates a 1GB hugepage area
without reserving, restricts allocation to Node 0 using mbind() with
MPOL_PREFERRED_MANY, and triggers a page fault:

  void *ptr = mmap(NULL, 1UL << 30, PROT_READ | PROT_WRITE,
                   MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
                   MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
  unsigned long nodemask = 1; /* Node 0 */
  mbind(ptr, 1UL << 30, MPOL_PREFERRED_MANY, &nodemask,
        sizeof(nodemask) * 8, 0);
  memset(ptr, 0, 1UL << 30); /* Trigger fault */

This results in a NULL pointer dereference:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  Oops: Oops: 0000 [#1] SMP NOPTI
  RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
  Call Trace:
   <TASK>
   only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
   alloc_surplus_hugetlb_folio+0x6d/0x100
   alloc_hugetlb_folio+0x3c5/0x660
   hugetlb_no_page+0x3d9/0x650

Link: https://lore.kernel.org/20260811052909.475635-1-souravpanda@google.com
Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages")
Signed-off-by: Sourav Panda <souravpanda@google.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb_cma.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -3,6 +3,7 @@
 #include <linux/mm.h>
 #include <linux/cma.h>
 #include <linux/compiler.h>
+#include <linux/cpuset.h>
 #include <linux/mm_inline.h>
 
 #include <asm/page.h>
@@ -30,15 +31,25 @@ struct folio *hugetlb_cma_alloc_frozen_f
 	int node;
 	struct folio *folio;
 	struct page *page = NULL;
+	const nodemask_t *nmask;
+	unsigned int cpuset_mems_cookie;
 
 	if (!hugetlb_cma_size)
 		return NULL;
 
-	if (hugetlb_cma[nid])
+retry_cpuset:
+	if (!nodemask) {
+		cpuset_mems_cookie = read_mems_allowed_begin();
+		nmask = &cpuset_current_mems_allowed;
+	} else {
+		nmask = nodemask;
+	}
+
+	if (hugetlb_cma[nid] && node_isset(nid, *nmask))
 		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
 
 	if (!page && !(gfp_mask & __GFP_THISNODE)) {
-		for_each_node_mask(node, *nodemask) {
+		for_each_node_mask(node, *nmask) {
 			if (node == nid || !hugetlb_cma[node])
 				continue;
 
@@ -48,8 +59,12 @@ struct folio *hugetlb_cma_alloc_frozen_f
 		}
 	}
 
-	if (!page)
+	if (!page) {
+		if (!nodemask &&
+		    unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
+			goto retry_cpuset;
 		return NULL;
+	}
 
 	folio = page_folio(page);
 	folio_set_hugetlb_cma(folio);


