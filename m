Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D893D8902;
	Tue, 16 Jun 2026 18:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634729; cv=none; b=FWoXgtCo50J/Q9HcSF2dnL1/GOiuPElnjyNa9crLydlfwcf+B1N3tPNIZegt7DMtJIXm+3Pc9C7LInkz+qZ2Cb4KH9oCFlL7MRS36Fr6AaJdcaYrRcgds9ut7Yq3Neik8kMo4Fyeiz8peQTqKIIgrqafrsyHYeoukc+YbMt2cS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634729; c=relaxed/simple;
	bh=0uhuX9siFuthTSlLt3dPm/5urdlCd5GTcMwZAHaSs2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8vjMrnHIeqhGkQ9aGM6h+6m9FPi21ggl9+nRFiW9pICGWAUFcT8+/f6dCAZXDitShVFYy9nRuJAYaBpakS1OiyagK/JZN3PN/VZAQfqRRSsDffP+6AiC6nlpPhpNzfjJ2jKYBGDVUG0w4pVXUeUrMqPjF+Flv6Lx6Gw9JJP+xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZKoy1UU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZKoy1UU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0AE21F000E9;
	Tue, 16 Jun 2026 18:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634728;
	bh=N81na260pTduIe/zLURRqZ603iwjUGVJM14damwYM6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hZKoy1UU9BkwNTJ+OHlPPNsGmSQRBaCT16CSmAe/v8zqUBp491fi6ogKIveldgcKL
	 cAzvJTo5D7z58q+4Jy9b4i9nFAO/5Ny1tZ5wX9edpVTGOhfjOBlWFYEnhI5ss6C6Qv
	 uLPIhe17FNu0zgaunaykHX7BnykyELTfzYOyeP2U=
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
Subject: [PATCH 5.15 320/411] mm/hugetlb_cma: round up per_node before logging it
Date: Tue, 16 Jun 2026 20:29:18 +0530
Message-ID: <20260616145118.163347003@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ applied the one-line `round_up` to `mm/hugetlb.c` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6493,6 +6493,7 @@ void __init hugetlb_cma_reserve(int orde
 	 * let's allocate 1 GB on first three nodes and ignore the last one.
 	 */
 	per_node = DIV_ROUND_UP(hugetlb_cma_size, nr_online_nodes);
+	per_node = round_up(per_node, PAGE_SIZE << order);
 	pr_info("hugetlb_cma: reserve %lu MiB, up to %lu MiB per node\n",
 		hugetlb_cma_size / SZ_1M, per_node / SZ_1M);
 


