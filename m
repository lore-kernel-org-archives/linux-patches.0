Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCA83FF1DA;
	Fri, 15 May 2026 15:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860506; cv=none; b=o/fWGSRG6CN/fe3YL3hpfQDYg+EQfCNTHUADohK/8FPR+zCCBFJPYPXqMm8Qk17pP8C5oVQZFDuh8z/PxiW87dnQGWyg77b6DAeDdYDYzT4vhoY+xzNgC3GksVl9oeTj6NoZpD+xW/r9uV+yNZDBWw21q7d93WOBEZi8AR2EgGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860506; c=relaxed/simple;
	bh=L+q6n9R4thrNLpzNdahdRiuVm6yq7GPgmzQDKMuC/48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfddHkFm+yLXM850h87LRJ+dWBqHWgAOiQz+NilZ0D/IFVClcCKcmK/rpx0ueegW3VZBhEPLqKNChdwZf6f7+0E1gyl9gsmgIU6eYBunkPCJtr5DEHWLKoCbhzYbiVUmJpm7bSS/MNyrIRKkLkaUS/AcUIMJzfGYNFFppKr0SSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mw0Y788z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mw0Y788z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B076CC2BCB0;
	Fri, 15 May 2026 15:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860506;
	bh=L+q6n9R4thrNLpzNdahdRiuVm6yq7GPgmzQDKMuC/48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mw0Y788zZBB5IICGKRWR938TQNecxw5XcmgVagWloDDQgT2uKIYoAMsIIRVuuliZH
	 XLhnbYcg2PdSRCQbVEQL0s+1Wp+6KbJBt15dKmd0hOMJonzmFGJqfRcedURRWqVU1+
	 Cd5zgXN7RQej7kwk+RoAGsEfHpokPJFxRq3O4UIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 116/144] mm/hugetlb_cma: round up per_node before logging it
Date: Fri, 15 May 2026 17:49:02 +0200
Message-ID: <20260515154656.185265963@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

From: Sang-Heon Jeon <ekffu200098@gmail.com>

[ Upstream commit 8f5ce56b76303c55b78a87af996e2e0f8535f979 ]

When the user requests a total hugetlb CMA size without per-node
specification, hugetlb_cma_reserve() computes per_node from
hugetlb_cma_size and the number of nodes that have memory

        per_node = DIV_ROUND_UP(hugetlb_cma_size,
                                nodes_weight(hugetlb_bootmem_nodes));

The reservation loop later computes

        size = round_up(min(per_node, hugetlb_cma_size - reserved),
                          PAGE_SIZE << order);

So the actually reserved per_node size is multiple of (PAGE_SIZE <<
order), but the logged per_node is not rounded up, so it may be smaller
than the actual reserved size.

For example, as the existing comment describes, if a 3 GB area is
requested on a machine with 4 NUMA nodes that have memory, 1 GB is
allocated on the first three nodes, but the printed log is

        hugetlb_cma: reserve 3072 MiB, up to 768 MiB per node

Round per_node up to (PAGE_SIZE << order) before logging so that the
printed log always matches the actual reserved size.  No functional change
to the actual reservation size, as the following case analysis shows

1. remaining (hugetlb_cma_size - reserved) >= rounded per_node
 - AS-IS: min() picks unrounded per_node;
    round_up() returns rounded per_node
 - TO-BE: min() picks rounded per_node;
    round_up() returns rounded per_node (no-op)
2. remaining < unrounded per_node
 - AS-IS: min() picks remaining;
    round_up() returns round_up(remaining)
 - TO-BE: min() picks remaining;
    round_up() returns round_up(remaining)
3. unrounded per_node <= remaining < rounded per_node
 - AS-IS: min() picks unrounded per_node;
    round_up() returns rounded per_node
 - TO-BE: min() picks remaining;
    round_up() returns round_up(remaining) equals rounded per_node

Link: https://lore.kernel.org/20260422143353.852257-1-ekffu200098@gmail.com
Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma") # 5.7
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ applied the single-line addition to mm/hugetlb.c since mm/hugetlb_cma.c didn't exist yet in 6.12 ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7689,6 +7689,7 @@ void __init hugetlb_cma_reserve(int orde
 		 * let's allocate 1 GB on first three nodes and ignore the last one.
 		 */
 		per_node = DIV_ROUND_UP(hugetlb_cma_size, nr_online_nodes);
+		per_node = round_up(per_node, PAGE_SIZE << order);
 		pr_info("hugetlb_cma: reserve %lu MiB, up to %lu MiB per node\n",
 			hugetlb_cma_size / SZ_1M, per_node / SZ_1M);
 	}


