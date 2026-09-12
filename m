Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8E82D0C75;
	Sat, 12 Sep 2026 11:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213183; cv=none; b=CwyZ4ra+CznuZ74rAWHzsD8JWF5FggnRd9IrFBt7SMFIwwx7V0eSIHaoIuhdLeY9mSw0qIOPaZ8pyRS+ccDRMMZxC3X4HIJGT73+o48rJwjpTqJ3OQO3yYsbSOl9c87D12/H4/8hyoSS7mFW83q1/8mOerIcV9G2oUiHdSVhwhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213183; c=relaxed/simple;
	bh=InKI4FHaSOJUhJ5G9X2wykanD5uQQfobNXc8nl5Tedc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISlY9AzZ6/h0IXyTH0q7RTwzbHFp5wWjmfbcb2VYBP5uDWCSRrdm5bn9JQ4//4M+7qiq3fE9s1pwCjfu/62XmBG6da3Fx+tQ12ZWKWWGqmSG3CGmGCfN2GKjZZcQmvZwOIOPru8m33L5LrkqiPPd/Z8Oow6J4emq6KANryAjVlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ckmF089t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ckmF089t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA2A1F000FF;
	Sat, 12 Sep 2026 11:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213181;
	bh=mw/7IGkJ4QN7qIPJgxpWrHFlr07OgyncdBR9rz77vIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ckmF089tFRvDx6BB5ExttgdNVm70ZOdCjgGvXq06Q2Iahp+xd3zjeJT3jiAuKPGsH
	 yfGugn5ONCLzaWcrZXd9rRDGDgVgtmLaGfDzEjn5uWRUqW5JEaG+4nBPUHdS+hwEjP
	 3WaV+cOBRYR11WHG/oOWtlmCCGUjPpJ7WQKkMKE0=
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
Subject: [PATCH 6.12 0069/1376] mm/mempolicy: fix sleeping allocation in alloc_pages_bulk_weighted_interleave()
Date: Sat, 12 Sep 2026 08:41:35 +0200
Message-ID: <20260912065609.097044562@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2438,7 +2438,7 @@ static unsigned long alloc_pages_bulk_ar
 	prev_node = node;
 
 	/* create a local copy of node weights to operate on outside rcu */
-	weights = kzalloc(nr_node_ids, GFP_KERNEL);
+	weights = kmalloc(nr_node_ids, gfp & GFP_RECLAIM_MASK);
 	if (!weights)
 		return total_allocated;
 


