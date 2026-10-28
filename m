Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207724;
	b=KTSgfgsuS4zqPXUVCItWmdLb2Upxwo96zgSYEmy3l9DkVyDBNQM9oPT09vjybE/Lyugi
	 dwpL9NcbvgVG0LwkFwHQFJyUjDogX5jPuoXEYRxpsoFQqDGG78qnKybzwbx7w5Wp3DvE5
	 yzm+uxPOSqb53sYVUvtzepZvKYVgWNFmXQqWGSrYVg4I3efWgarGyadEsiHdp1A/kQQJs
	 epIVVB27cSVKVLSxSZHRFWQnaqTNQGKOj6xk/qm8+yZHjvZLi1eo4KUAcZq3m+U6zp/0W
	 VnpYKXFKc1nsJs7oQYVkTq24gqboClZzEff9W2gFDuPqar8kJdtMZOwDT7EoNDicvyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207724;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Du1xk2RTL5yCMY5A3aYWSDSYLRHiH8NCzJTnolWGOWI=;
	b=GGly5X1O8YnwCkdEs+BJqw4SmZSkDjk+crbJilnU08LQhb0BWbrvoh4UrA6SiMoRPSdl
	 LCil8HivdlbIfV3/rjJpJ3/X0OxhxLLxG8cUMeC9AS3AhVDzQy1CAfrSaVqgzLPZoxNwr
	 w1d6zAdlgwaOqKERVk/nh4hYbuPhod5J5E521cOdYvxV5YbJGd+Hox6qujrqgN3crZ13G
	 ZGU4JlkbO+wy2erZ3fLdr1Jm8lQOljvMiY8OIAjkhIz5cqYS3L7pI0SqUmrXqxNHoTDtT
	 jSEjYrhYctveSwOn5EnfXMjCthpuIgnwtb9j4aQeYwC4PaBdCFJFy9kuTwszmPNKqDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qo35axeq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF4A606A33C;
	Wed, 28 Oct 2026 17:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qo35axeq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D231F031E4;
	Wed, 28 Oct 2026 17:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207724;
	bh=Du1xk2RTL5yCMY5A3aYWSDSYLRHiH8NCzJTnolWGOWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qo35axeqQSGicojrZ7JvtnErjlhJFbD1GVdhJ6Ap+MWA6c2tWpMtiE4+sKEj7rs2y
	 TbhY+OoAOh03s5a1nmc75y3Zdx4R+eaZiFFyeZDSBFJZ+kg3Bx8/opDsxPpE+kroN7
	 VlQizdUJFIJXah92xS4H6JnfQxti0mgiLQC0+y4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+38a0cbd267eff2d286ff@syzkaller.appspotmail.com,
	Kairui Song <kasong@tencent.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sasha Levin <sashal@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 116/247] mm, madvise: fix potential workingset node list_lru leaks
Date: Wed, 28 Oct 2026 17:58:39 +0100
Message-ID: <20261028165950.147239856@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kairui Song <kasong@tencent.com>

[ Upstream commit 62e72d2cf702a5e2fb53d9c46ed900d9384e4a06 ]

Since commit 5abc1e37afa0 ("mm: list_lru: allocate list_lru_one only when
needed"), all list_lru users need to allocate the items using the new
infrastructure that provides list_lru info for slab allocation, ensuring
that the corresponding memcg list_lru is allocated before use.

For workingset shadow nodes (which are xa_node), users are converted to
use the new infrastructure by commit 9bbdc0f32409 ("xarray: use
kmem_cache_alloc_lru to allocate xa_node").  The xas->xa_lru will be set
correctly for filemap users.  However, there is a missing case: xa_node
allocations caused by madvise(..., MADV_COLLAPSE).

madvise(..., MADV_COLLAPSE) will also read in the absent parts of file
map, and there will be xa_nodes allocated for the caller's memcg (assuming
it's not rootcg).  However, these allocations won't trigger memcg list_lru
allocation because the proper xas info was not set.

If nothing else has allocated other xa_nodes for that memcg to trigger
list_lru creation, and memory pressure starts to evict file pages,
workingset_update_node will try to add these xa_nodes to their
corresponding memcg list_lru, and it does not exist (NULL).  So they will
be added to rootcg's list_lru instead.

This shouldn't be a significant issue in practice, but it is indeed
unexpected behavior, and these xa_nodes will not be reclaimed effectively.
And may lead to incorrect counting of the list_lru->nr_items counter.

This problem wasn't exposed until recent commit 28e98022b31ef
("mm/list_lru: simplify reparenting and initial allocation") added a
sanity check: only dying memcg could have a NULL list_lru when
list_lru_{add,del} is called.  This problem triggered this WARNING.

So make madvise(..., MADV_COLLAPSE) also call xas_set_lru() to pass the
list_lru which we may want to insert xa_node into later.  And move
mapping_set_update to mm/internal.h, and turn into a macro to avoid
including extra headers in mm/internal.h.

Link: https://lkml.kernel.org/r/20241222122936.67501-1-ryncsn@gmail.com
Fixes: 9bbdc0f32409 ("xarray: use kmem_cache_alloc_lru to allocate xa_node")
Reported-by: syzbot+38a0cbd267eff2d286ff@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/675d01e9.050a0220.37aaf.00be.GAE@google.com/
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: aca1f2d5de17 ("mm/huge_memory: initialise workingset state before folio split")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/filemap.c    | 9 ---------
 mm/internal.h   | 6 ++++++
 mm/khugepaged.c | 3 +++
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index c2287a1d1c6b7..64c2325b92389 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -125,15 +125,6 @@
  *    ->private_lock		(zap_pte_range->block_dirty_folio)
  */
 
-static void mapping_set_update(struct xa_state *xas,
-		struct address_space *mapping)
-{
-	if (dax_mapping(mapping) || shmem_mapping(mapping))
-		return;
-	xas_set_update(xas, workingset_update_node);
-	xas_set_lru(xas, &shadow_nodes);
-}
-
 static void page_cache_delete(struct address_space *mapping,
 				   struct folio *folio, void *shadow)
 {
diff --git a/mm/internal.h b/mm/internal.h
index 9d277bc2c26e9..7aca909c54052 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1526,6 +1526,12 @@ static inline void shrinker_debugfs_remove(struct dentry *debugfs_entry,
 /* Only track the nodes of mappings with shadow entries */
 void workingset_update_node(struct xa_node *node);
 extern struct list_lru shadow_nodes;
+#define mapping_set_update(xas, mapping) do {			\
+	if (!dax_mapping(mapping) && !shmem_mapping(mapping)) {	\
+		xas_set_update(xas, workingset_update_node);	\
+		xas_set_lru(xas, &shadow_nodes);		\
+	}							\
+} while (0)
 
 /* mremap.c */
 unsigned long move_page_tables(struct vm_area_struct *vma,
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 84bacd7e19620..769e2f9f99920 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -20,6 +20,7 @@
 #include <linux/rcupdate_wait.h>
 #include <linux/swapops.h>
 #include <linux/shmem_fs.h>
+#include <linux/dax.h>
 #include <linux/ksm.h>
 
 #include <asm/tlb.h>
@@ -1823,6 +1824,8 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	if (result != SCAN_SUCCEED)
 		goto out;
 
+	mapping_set_update(&xas, mapping);
+
 	__folio_set_locked(new_folio);
 	if (is_shmem)
 		__folio_set_swapbacked(new_folio);
-- 
2.53.0



