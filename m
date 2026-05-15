Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3023B9D96;
	Fri, 15 May 2026 16:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861724; cv=none; b=o4efBY+QFk97H2/UiSYua93ElqOY1ss8t3prMl6fnfWTuGm5SiT01Yr078b6l3NJl98LDIfmMsSp9TX9gGGjfci9qCIsDNAu9f38aobsjNn4uM9UVCWOEx5gvkmZFbRCH75AdUsT0ja8V7AyEnyf8iOwJiIBsTQyJtqN89Pbmg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861724; c=relaxed/simple;
	bh=WFKpJljEHpzxYOgEpCQgae1P18XW74+2Hl1gjLvRQWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETTC4Wzqw6dYcA47qLYfzp9jUqum1KvA1MIlqIbtuZAn1iN0ZFunA5KJFxGj4jaWcICfVq3H8yGLQirAekWulTQ3U/Az0EurI+psWXVbAq4ZSeaNAB1mfWcR5NdU3A8K6yygJl8pXXDqFRF4Xn1NCdogGZzwIr6Fmz6yuXbZqw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vam6o7/N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vam6o7/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A58C2BCB0;
	Fri, 15 May 2026 16:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861724;
	bh=WFKpJljEHpzxYOgEpCQgae1P18XW74+2Hl1gjLvRQWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vam6o7/Nji8aoDRUr1h8ug8U9agdrJl1nYksCUHh9u5uqFR/GAUUAijCjoiqZZD08
	 7l74xdOoNDgq1f0GJFdgcgHk2/bOSvDzxN9Yk+JSSHh72G2Py4oOXibzNW1ryA5oN4
	 MKCPI9urisa/797x18JebxYaLTqaRqVgFinjIDK4=
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
Subject: [PATCH 6.6 440/474] mm/hugetlb_cma: round up per_node before logging it
Date: Fri, 15 May 2026 17:49:09 +0200
Message-ID: <20260515154724.606073078@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7493,6 +7493,7 @@ void __init hugetlb_cma_reserve(int orde
 		 * let's allocate 1 GB on first three nodes and ignore the last one.
 		 */
 		per_node = DIV_ROUND_UP(hugetlb_cma_size, nr_online_nodes);
+		per_node = round_up(per_node, PAGE_SIZE << order);
 		pr_info("hugetlb_cma: reserve %lu MiB, up to %lu MiB per node\n",
 			hugetlb_cma_size / SZ_1M, per_node / SZ_1M);
 	}


