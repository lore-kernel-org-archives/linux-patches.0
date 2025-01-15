Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8AA1DB151;
	Wed, 15 Jan 2025 10:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938499; cv=none; b=YdOEDJgXw+nJdMc6cbFsqKyTni6YKWW9M93u2AadQ1VFUgZ68+fQtsCqtQfdO7jXL0uwNN/rxmHMnzWF83rwsqshu2rqXis34webWwBMlZ8dcNypf+d1uQMR4y3Q6cXlNfa1NJ8dunzkXQlmax7glZDURl3+jqKm57NS0LVAAyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938499; c=relaxed/simple;
	bh=9K2QoTwgo15k0ggJhgx+JhXBJ8t09+UsNjaXeVeEurE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LE3/47jt0NcZR1UiGuEpsC3aOvW3eS/o+ag8IrHG6cq3VPXEGZI2FLol8TgGlOANpo/bazkKZIYNmG+nkSVvGGFo1ZvaS1VyuQ5wCZNvdRUsQgNOIOY7T90a46G3Sg1ttjJpWEbw8fy6kbA4lEiz5gEfARyNqcNKj8p9odc2JRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HPMTIiHH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HPMTIiHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81082C4CEE4;
	Wed, 15 Jan 2025 10:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938499;
	bh=9K2QoTwgo15k0ggJhgx+JhXBJ8t09+UsNjaXeVeEurE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HPMTIiHHvrtFMo5at5QaCkEee5dJgINRt3joh60qo8fXeTCF6CXwLiBq8NpYM61LA
	 qiPhUJyKACIRY08fBF5/lD5NI5UcoQaKIIKPdKgvQvL2w2EMspJJIzHcnPM/YzKKpC
	 Cql7KQAdIPh4agveXSRgHPJrIrmzkMZlRtC+8EPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: [PATCH 6.6 002/129] memblock: use numa_valid_node() helper to check for invalid node ID
Date: Wed, 15 Jan 2025 11:36:17 +0100
Message-ID: <20250115103554.457474714@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Rapoport (IBM) <rppt@kernel.org>

commit 8043832e2a123fd9372007a29192f2f3ba328cd6 upstream.

Introduce numa_valid_node(nid) that verifies that nid is a valid node ID
and use that instead of comparing nid parameter with either NUMA_NO_NODE
or MAX_NUMNODES.

This makes the checks for valid node IDs consistent and more robust and
allows to get rid of multiple WARNings.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/numa.h |    5 +++++
 mm/memblock.c        |   28 +++++++---------------------
 2 files changed, 12 insertions(+), 21 deletions(-)

--- a/include/linux/numa.h
+++ b/include/linux/numa.h
@@ -15,6 +15,11 @@
 #define	NUMA_NO_NODE	(-1)
 #define	NUMA_NO_MEMBLK	(-1)
 
+static inline bool numa_valid_node(int nid)
+{
+	return nid >= 0 && nid < MAX_NUMNODES;
+}
+
 /* optionally keep NUMA memory info available post init */
 #ifdef CONFIG_NUMA_KEEP_MEMINFO
 #define __initdata_or_meminfo
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -754,7 +754,7 @@ bool __init_memblock memblock_validate_n
 
 	/* calculate lose page */
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
-		if (nid == NUMA_NO_NODE)
+		if (!numa_valid_node(nid))
 			nr_pages += end_pfn - start_pfn;
 	}
 
@@ -1043,7 +1043,7 @@ static bool should_skip_region(struct me
 		return false;
 
 	/* only memory regions are associated with nodes, check it */
-	if (nid != NUMA_NO_NODE && nid != m_nid)
+	if (numa_valid_node(nid) && nid != m_nid)
 		return true;
 
 	/* skip hotpluggable memory regions if needed */
@@ -1100,10 +1100,6 @@ void __next_mem_range(u64 *idx, int nid,
 	int idx_a = *idx & 0xffffffff;
 	int idx_b = *idx >> 32;
 
-	if (WARN_ONCE(nid == MAX_NUMNODES,
-	"Usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE instead\n"))
-		nid = NUMA_NO_NODE;
-
 	for (; idx_a < type_a->cnt; idx_a++) {
 		struct memblock_region *m = &type_a->regions[idx_a];
 
@@ -1197,9 +1193,6 @@ void __init_memblock __next_mem_range_re
 	int idx_a = *idx & 0xffffffff;
 	int idx_b = *idx >> 32;
 
-	if (WARN_ONCE(nid == MAX_NUMNODES, "Usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE instead\n"))
-		nid = NUMA_NO_NODE;
-
 	if (*idx == (u64)ULLONG_MAX) {
 		idx_a = type_a->cnt - 1;
 		if (type_b != NULL)
@@ -1285,7 +1278,7 @@ void __init_memblock __next_mem_pfn_rang
 
 		if (PFN_UP(r->base) >= PFN_DOWN(r->base + r->size))
 			continue;
-		if (nid == MAX_NUMNODES || nid == r_nid)
+		if (!numa_valid_node(nid) || nid == r_nid)
 			break;
 	}
 	if (*idx >= type->cnt) {
@@ -1321,10 +1314,6 @@ int __init_memblock memblock_set_node(ph
 	int start_rgn, end_rgn;
 	int i, ret;
 
-	if (WARN_ONCE(nid == MAX_NUMNODES,
-		      "Usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE instead\n"))
-		nid = NUMA_NO_NODE;
-
 	ret = memblock_isolate_range(type, base, size, &start_rgn, &end_rgn);
 	if (ret)
 		return ret;
@@ -1434,9 +1423,6 @@ phys_addr_t __init memblock_alloc_range_
 	enum memblock_flags flags = choose_memblock_flags();
 	phys_addr_t found;
 
-	if (WARN_ONCE(nid == MAX_NUMNODES, "Usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE instead\n"))
-		nid = NUMA_NO_NODE;
-
 	if (!align) {
 		/* Can't use WARNs this early in boot on powerpc */
 		dump_stack();
@@ -1449,7 +1435,7 @@ again:
 	if (found && !memblock_reserve(found, size))
 		goto done;
 
-	if (nid != NUMA_NO_NODE && !exact_nid) {
+	if (numa_valid_node(nid) && !exact_nid) {
 		found = memblock_find_in_range_node(size, align, start,
 						    end, NUMA_NO_NODE,
 						    flags);
@@ -1969,7 +1955,7 @@ static void __init_memblock memblock_dum
 		end = base + size - 1;
 		flags = rgn->flags;
 #ifdef CONFIG_NUMA
-		if (memblock_get_region_node(rgn) != MAX_NUMNODES)
+		if (numa_valid_node(memblock_get_region_node(rgn)))
 			snprintf(nid_buf, sizeof(nid_buf), " on node %d",
 				 memblock_get_region_node(rgn));
 #endif
@@ -2158,7 +2144,7 @@ static void __init memmap_init_reserved_
 		start = region->base;
 		end = start + region->size;
 
-		if (nid == NUMA_NO_NODE || nid >= MAX_NUMNODES)
+		if (!numa_valid_node(nid))
 			nid = early_pfn_to_nid(PFN_DOWN(start));
 
 		reserve_bootmem_region(start, end, nid);
@@ -2247,7 +2233,7 @@ static int memblock_debug_show(struct se
 
 		seq_printf(m, "%4d: ", i);
 		seq_printf(m, "%pa..%pa ", &reg->base, &end);
-		if (nid != MAX_NUMNODES)
+		if (numa_valid_node(nid))
 			seq_printf(m, "%4d ", nid);
 		else
 			seq_printf(m, "%4c ", 'x');


