Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFC613AA50;
	Tue, 27 Feb 2024 13:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042282; cv=none; b=X3mO/booB8qeWrWJfHt2ckYXhX1/E4Xt8w9TE4jzLhJUmMgkm/JjZrLvlQZhV8o7RDXfUx6kGEv90WLx8Lp3LGcI0t2/05B/Ix+c/21MQlwPMTiBujJ5n4yt+/iOzN0CSwgJCn0CSQ5EFzbsBAoUCLRjtEza2RGmkp5D+ge80y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042282; c=relaxed/simple;
	bh=xBuKfa3G57gyAmaIR3ttE0V/Nq2DMdoKfxRmNSD4NFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDyUDsOj7HZHr+1OMwNyk8mcoFDYhJ3iePGQniF4K3Dn/1W9l8ARdJpSHUQFaOfViaKHI+8MOl9sw7ttzvVv1tijkHqUlzXB37epW23Pe9HV0ZOYX6sI4CSRJXyxXTc9lIQglCj4XIRSUQgEZbodnZDibbxEjl/eVKFHzAzleqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J+YbXh/j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J+YbXh/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B946C433F1;
	Tue, 27 Feb 2024 13:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042281;
	bh=xBuKfa3G57gyAmaIR3ttE0V/Nq2DMdoKfxRmNSD4NFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J+YbXh/jdfNbeXrAceDGcaaUzOx/5sO2728kD+0bL9d17DFQCZDZzqW/h6pOASSzu
	 awUW8M2kv1cP5fXWHQUe0pxTLT/QlwamTfcN6YtZvhkFTS99Cyx/yqVJo7IzK1V7kS
	 mKhT+5SzB1LaVHRs9sCs8fY32zWV3klzN/+APTok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 242/299] x86/numa: Fix the address overlap check in numa_fill_memblks()
Date: Tue, 27 Feb 2024 14:25:53 +0100
Message-ID: <20240227131633.518515112@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1c1072e3ca063..ed57c23f80ac2 100644
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
index 6d18485571b4a..d630f5c2bdb90 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -180,8 +180,9 @@ static inline phys_addr_t memblock_cap_size(phys_addr_t base, phys_addr_t *size)
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



