Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DBD576EC1;
	Wed,  9 Sep 2026 14:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963563; cv=none; b=c+M7wJv0jhA3hl6gvZzGMo4oLpYNHeiBfZmXR9S1IOJfpcDFoZcNHs7UDwSUpA7ScJuSgpAbCZSgCPCYurDG4iyyiaBSpEhhvoTOO5IQL6HBRH3lguyh9as8w80jCzeYaUjn+08vkXSa41h58uXXSekMyRhC/PR4TOe+EHzHGaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963563; c=relaxed/simple;
	bh=UHHhAAzVO6CfBXnyUwPKf1fWhOGR2Oj9vnYS3DmY5io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zx2Gdm+dKaytSMWT5SwQpqF5iOfinYxHLS8bLWV9u8llutQNBEDd6e8ajcv5HXd9qSscQ6BDvcziM0A1XyVPcBxjtKhxp6TSDZnEi8P2CfZUneRh/V+YD8Q8gdQSGq+xJM5oqbp+WBE7GIlL6FxZHilZ4X9iClg565ci9rA531Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ThQ46NAz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ThQ46NAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C491F00A3D;
	Wed,  9 Sep 2026 14:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963560;
	bh=TZ56gjGcWRagZmZ6NoZ1QyymeP9H0brfQIMRyhcwBuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ThQ46NAzemD/BDjDX/8pwwJmaDQhehiN2Jl/TTApeY7HEDxYVtMROCtzc38oVj+M6
	 nzqs//iLc+GUJwqDWEMrLP7gwTh0i4Y/V0z8vIXDyQfHthxx/E5HGmXeGiGIvMnYja
	 AJ0OO5HNkM9sJ6NOW/yySdff+DYk2WqaSl9iUd+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	syzbot+0dbf6d295b3350944f0b@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Alistair Popple <apopple@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH 6.18 083/583] mm/mempolicy: fix sleeping allocation in alloc_pages_bulk_weighted_interleave()
Date: Wed,  9 Sep 2026 15:36:08 +0200
Message-ID: <20260909134240.994203292@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit 540e583b66d6402bf556fde5e53c817a54c1afe5 upstream.

syzbot reported a sleeping function called from invalid context splat in
bucket_table_alloc().

When rhashtable_insert_slow() rehashes the table under rcu_read_lock(), it
calls bucket_table_alloc(..., GFP_ATOMIC | __GFP_NOWARN).  If the bucket
table allocation uses vmalloc, __vmalloc_node_range_noprof() invokes
vm_area_alloc_pages() -> alloc_pages_bulk_mempolicy_noprof() with the
passed GFP_ATOMIC flags.

If the current task has an MPOL_WEIGHTED_INTERLEAVE mempolicy,
alloc_pages_bulk_weighted_interleave() is called and currently hardcodes
GFP_KERNEL when allocating the temporary weights array, triggering a
might_alloc() splat in atomic/RCU contexts.

Pass the gfp flags (masked with GFP_RECLAIM_MASK to strip page-allocator
zone modifiers like __GFP_HIGHMEM) received by
alloc_pages_bulk_weighted_interleave() to kmalloc() instead of hardcoding
GFP_KERNEL.  Since the weights buffer is immediately initialized in full,
kmalloc() is sufficient.

Link: https://lore.kernel.org/20260821170407.3721004-1-edumazet@google.com
Fixes: fa3bea4e1f82 ("mm/mempolicy: introduce MPOL_WEIGHTED_INTERLEAVE for weighted interleaving")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot+0dbf6d295b3350944f0b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/6a88837e.ae6ddae5.3da009.0040.GAE@google.com/T/#u
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2606,7 +2606,7 @@ static unsigned long alloc_pages_bulk_we
 	prev_node = node;
 
 	/* create a local copy of node weights to operate on outside rcu */
-	weights = kzalloc(nr_node_ids, GFP_KERNEL);
+	weights = kmalloc(nr_node_ids, gfp & GFP_RECLAIM_MASK);
 	if (!weights)
 		return total_allocated;
 


