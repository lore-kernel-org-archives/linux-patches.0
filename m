Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD0F13B2B8;
	Tue, 27 Feb 2024 14:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043558; cv=none; b=KVMtoAWLR+alp8KHeot9WTGtizAy0q+bQqWyM1hbz/cAktPbEg0V4Q+igLA4NxDblOc6MEqzPLgKiL5Ww59tQNlZxh3ZiJJYdii+cfgqClgI+DqsVTDk6H93Wn7rBBINnnl4I2O9KGcUCqJ56ySLg7AcEzrNiy/u8ubzTWoeMPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043558; c=relaxed/simple;
	bh=UvNo9Iu+8/sF+/sfHt9RjyvXUdJVf/Vm+z2fWlC5Ol4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfjlMdHP7VESNNWBI3ebfOebhLCwqKCMV27ssPGkk0TK+R23l457RNvX+yXhPG9QGf/OU+6VBAyxpLYSwyF0suxEIxpSgNQqzD2xV+4Us12ksNFnCiK+7f8TKl+aBx0sE60tEck0HiewMFQAkIhKq30ZZAurZb4Z38neJz1g8o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CPjb9uZd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CPjb9uZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D111CC43390;
	Tue, 27 Feb 2024 14:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043558;
	bh=UvNo9Iu+8/sF+/sfHt9RjyvXUdJVf/Vm+z2fWlC5Ol4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CPjb9uZdq/Pi7QSYBArUXHHxacaNeuWts9wDhD6mVim3ba3VdOl+oS5S5y+/UvtTC
	 dLQRVKX9fz7PC5Z0rIKNFKaLq4w3S/4A8lvE+0m2fM6K4fERabeRRYsL8MXb4iz+AB
	 irdPc2oSkqW3gn56ZFpk8g3bStNmzaWT2Vpg51iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 151/195] x86/numa: Fix the address overlap check in numa_fill_memblks()
Date: Tue, 27 Feb 2024 14:26:52 +0100
Message-ID: <20240227131615.403884675@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alison Schofield <alison.schofield@intel.com>

[ Upstream commit 9b99c17f7510bed2adbe17751fb8abddba5620bc ]

numa_fill_memblks() fills in the gaps in numa_meminfo memblks over a
physical address range. To do so, it first creates a list of existing
memblks that overlap that address range. The issue is that it is off
by one when comparing to the end of the address range, so memblks
that do not overlap are selected.

The impact of selecting a memblk that does not actually overlap is
that an existing memblk may be filled when the expected action is to
do nothing and return NUMA_NO_MEMBLK to the caller. The caller can
then add a new NUMA node and memblk.

Replace the broken open-coded search for address overlap with the
memblock helper memblock_addrs_overlap(). Update the kernel doc
and in code comments.

Suggested by: "Huang, Ying" <ying.huang@intel.com>

Fixes: 8f012db27c95 ("x86/numa: Introduce numa_fill_memblks()")
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Link: https://lore.kernel.org/r/10a3e6109c34c21a8dd4c513cf63df63481a2b07.1705085543.git.alison.schofield@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/numa.c       | 19 +++++++------------
 include/linux/memblock.h |  2 ++
 mm/memblock.c            |  5 +++--
 3 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index aa39d678fe81d..e60c61b8bbc61 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -971,14 +971,12 @@ static struct numa_memblk *numa_memblk_list[NR_NODE_MEMBLKS] __initdata;
  * @start: address to begin fill
  * @end: address to end fill
  *
- * Find and extend numa_meminfo memblks to cover the @start-@end
- * physical address range, such that the first memblk includes
- * @start, the last memblk includes @end, and any gaps in between
- * are filled.
+ * Find and extend numa_meminfo memblks to cover the physical
+ * address range @start-@end
  *
  * RETURNS:
  * 0		  : Success
- * NUMA_NO_MEMBLK : No memblk exists in @start-@end range
+ * NUMA_NO_MEMBLK : No memblks exist in address range @start-@end
  */
 
 int __init numa_fill_memblks(u64 start, u64 end)
@@ -990,17 +988,14 @@ int __init numa_fill_memblks(u64 start, u64 end)
 
 	/*
 	 * Create a list of pointers to numa_meminfo memblks that
-	 * overlap start, end. Exclude (start == bi->end) since
-	 * end addresses in both a CFMWS range and a memblk range
-	 * are exclusive.
-	 *
-	 * This list of pointers is used to make in-place changes
-	 * that fill out the numa_meminfo memblks.
+	 * overlap start, end. The list is used to make in-place
+	 * changes that fill out the numa_meminfo memblks.
 	 */
 	for (int i = 0; i < mi->nr_blks; i++) {
 		struct numa_memblk *bi = &mi->blk[i];
 
-		if (start < bi->end && end >= bi->start) {
+		if (memblock_addrs_overlap(start, end - start, bi->start,
+					   bi->end - bi->start)) {
 			blk[count] = &mi->blk[i];
 			count++;
 		}
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 50ad19662a322..6790f08066b72 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -118,6 +118,8 @@ int memblock_reserve(phys_addr_t base, phys_addr_t size);
 int memblock_physmem_add(phys_addr_t base, phys_addr_t size);
 #endif
 void memblock_trim_memory(phys_addr_t align);
+unsigned long memblock_addrs_overlap(phys_addr_t base1, phys_addr_t size1,
+				     phys_addr_t base2, phys_addr_t size2);
 bool memblock_overlaps_region(struct memblock_type *type,
 			      phys_addr_t base, phys_addr_t size);
 int memblock_mark_hotplug(phys_addr_t base, phys_addr_t size);
diff --git a/mm/memblock.c b/mm/memblock.c
index 511d4783dcf1d..516efec80851a 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -175,8 +175,9 @@ static inline phys_addr_t memblock_cap_size(phys_addr_t base, phys_addr_t *size)
 /*
  * Address comparison utilities
  */
-static unsigned long __init_memblock memblock_addrs_overlap(phys_addr_t base1, phys_addr_t size1,
-				       phys_addr_t base2, phys_addr_t size2)
+unsigned long __init_memblock
+memblock_addrs_overlap(phys_addr_t base1, phys_addr_t size1, phys_addr_t base2,
+		       phys_addr_t size2)
 {
 	return ((base1 < (base2 + size2)) && (base2 < (base1 + size1)));
 }
-- 
2.43.0



