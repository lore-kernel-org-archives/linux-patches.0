Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE23550DC3;
	Wed,  9 Sep 2026 13:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962083; cv=none; b=VHz2jzUG5a9Ma9KF7up+2EiNxfZYjyCryh+X0hx4G9Nfr4Ywp9MbykcCzNQGclwybp0EWLgoAy9CysxOoCAd2L1dxyjAv9RvQWWNGx0Rzw3prkvoRxExOS8qMZmsU8uWIq/kIh2WeY/VbB7gtZpgxDV3x6z71J4tkooMHnUIbq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962083; c=relaxed/simple;
	bh=m2lFc+4pXH5AMp5/ItJ+W8KaQsPuoaUGKodAEkFmMfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VNuvdnDZPiiuu6LUt0W4B0Ubp2ccofIYq71AT1NCr/DtZr3KBkaZUNSuVHoRozqH9CMQ6P5m6nLD53/5ttVNUywBxufJA3qYd4Y0X6xzN6463+2t0FcWFZYrHe80jaTvptnYPHR6M5k55DEjFg168S+ietYSMKU6p0ZpycY9Wps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zo8TkiUD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zo8TkiUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4061F00A3D;
	Wed,  9 Sep 2026 13:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962081;
	bh=tnzQEyd+cAtPNA658RGMgk4jJURkMMg1Q5vMuKkuPm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zo8TkiUDdVExFM4VUYXGzqCYXCK++z25DwS8e+rfA7thq1hToE88HUI7R66xWN6Ib
	 sAe5/pC33RctUEbz/sHg0Yka3V6vhgbJnY7sOoXS6CXCNoXsG+K1GEAwLqOaZD7r0s
	 ysf2v7oSGlRpYUMjLabaCjgnse+nn8lxXUQWFbHs=
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
Subject: [PATCH 7.2 126/556] mm/mempolicy: fix sleeping allocation in alloc_pages_bulk_weighted_interleave()
Date: Wed,  9 Sep 2026 15:36:46 +0200
Message-ID: <20260909134234.892976060@linuxfoundation.org>
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
@@ -2676,7 +2676,7 @@ static unsigned long alloc_pages_bulk_we
 	prev_node = node;
 
 	/* create a local copy of node weights to operate on outside rcu */
-	weights = kzalloc(nr_node_ids, GFP_KERNEL);
+	weights = kmalloc(nr_node_ids, gfp & GFP_RECLAIM_MASK);
 	if (!weights)
 		return total_allocated;
 


