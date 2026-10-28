Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210122;
	b=1RnD+3n94Z4MkA1FnggGx7q+oY/YnlYRbyBtUBN2JzIVyDHlIyNyWMvQRDVUK4V2LUcY
	 8Bgbyr7TT055nc2/SPpx4VWDUe5EQJbZhe4CreYQ3WbJ9gJdrwE3a4suuse69Ps0tFSGw
	 m6uHQbOceafCu9EZmu+rdcXDF+GTqNCLjYCNJbHVjG2qw7cRrdJIgrxP3PhnOuEFZDY/H
	 a3Y5QCSmrXuTYISQ0sUcexvjRqYnXHsSwU+RpqVh+XLRg0Ejl2bqasUvZwVjnyPQLjs13
	 Nx2UTGYDQ1OMFEGWvl4MZGmmVt3hYre6zaxNEb5ZT+AAlM6h2IovdYVzvCP5WWGQetQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LRKD1U2692UQuyG1qrw+zYYlC1BRaw1LfMZEyFSh7qQ=;
	b=J/6PTG4OSB6ISA0NBruEzuhwbzmkkW2e2+6FKTuNqTsSG7ULcXtQcehUW2hTnsoST605
	 HFR+jHt/xUorsTDhdOGJPcSCl3+2/46weEner30D/s2rr9b7CMNuDXPxw95xhPvBORyVK
	 f97/33hxlq1wuj/AK8q3cYL8xGxyJpB53og1lRqS5nBSeV+3VwxfUIU+yxU2NUZHfg47y
	 bNOZKc/v1jqnrRNS9IWlkhaEojyO/gCfHDLy5I92tO36v7wJOn1e6ou7XAq0nYwF9xB2d
	 SyLrsalT2BPLqX2d0OUD9zAEqQdwshTk2xp7Pt1aw9rzcudVJBiKHBp9ebE2dz/1N2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EpdCtUl6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B47606A31A;
	Wed, 28 Oct 2026 17:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EpdCtUl6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5141F01825;
	Wed, 28 Oct 2026 17:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210121;
	bh=LRKD1U2692UQuyG1qrw+zYYlC1BRaw1LfMZEyFSh7qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EpdCtUl6xkTP0Smxe9TA8LRnFboSmFv+Z1CSF1KMlxRccwKUnNyw04GRFbyq3L/l1
	 OBwGPVmiqzGpW+8htAkjFiyKwg0/HQToi/wcjf3M+jaRxy0wxGQ4pIUdG6VlDWXYvI
	 g0JSPPCyF5k+Msu1uR6F+rVaMEl5bAHqHoO56P1w=
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
Subject: [PATCH 6.6 083/168] mm, madvise: fix potential workingset node list_lru leaks
Date: Wed, 28 Oct 2026 18:00:19 +0100
Message-ID: <20261028165945.051899683@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/khugepaged.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index ead6b0001524b..42330aeb76386 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -19,6 +19,7 @@
 #include <linux/page_table_check.h>
 #include <linux/swapops.h>
 #include <linux/shmem_fs.h>
+#include <linux/dax.h>
 #include <linux/ksm.h>
 
 #include <asm/tlb.h>
@@ -1800,6 +1801,8 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	if (result != SCAN_SUCCEED)
 		goto out;
 
+	mapping_set_update(&xas, mapping);
+
 	__folio_set_locked(new_folio);
 	if (is_shmem)
 		__folio_set_swapbacked(new_folio);
-- 
2.53.0



