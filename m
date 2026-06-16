Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E812D3D7D9D;
	Tue, 16 Jun 2026 19:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636566; cv=none; b=Uk80YJHkrox5DO+y7hnThTBeoM+/Ud4BBre1Vmfb0nwud7UiRzxr21RtjEzxk6CAfy8fFtk4m3opm19fCZrM0OK8Brf0LdLCyyWyNVPSoHwL1s847K/bjND+U799PHQd5HS4JuXhQpw8cg0FB0UQp+I29S2YZ+rATgp/+8gi3Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636566; c=relaxed/simple;
	bh=yh4c+7MfJ36ndHb3eURExj6TUMarhnbTt6QrIqIbD6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUeJAaDchGV3hgCpd+VrjEzzRTVoGqXpm8102wfI+lxWmVEiyqFzgidqxr9ghSGJE5Pn7iOziEDAir7Re6XMqrcGDUtsxMVzm3pUOZHlIOerTnpPHqxlWpSOFlbbvOhpv3AucBb4P6fCkC7GHr55FyQ03wt+AVABUwIA+F50Hdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GKC51MZu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GKC51MZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5E21F000E9;
	Tue, 16 Jun 2026 19:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636564;
	bh=NOoruYMdwcYdbEzj1ddg8jfBNhMcN99XMTfPVIBOwkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GKC51MZuMFMKNnWdJgroAxUG6/AmUFhd4V64LXeKnilbzxEFUeYqQhtvzFJUofEq3
	 XVvprqXcRINMoJftYdud3kPuyPlEbjRfZ/tStX4Ukw+oT/r9cjA6hqbd6Gtf6/v+DA
	 WbhrO7TNh8hdsqFJP6slT1FlmcnCQQuIwi68ptng=
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
Subject: [PATCH 5.10 264/342] mm/hugetlb_cma: round up per_node before logging it
Date: Tue, 16 Jun 2026 20:29:20 +0530
Message-ID: <20260616145100.562837094@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5842,6 +5842,7 @@ void __init hugetlb_cma_reserve(int orde
 	 * let's allocate 1 GB on first three nodes and ignore the last one.
 	 */
 	per_node = DIV_ROUND_UP(hugetlb_cma_size, nr_online_nodes);
+	per_node = round_up(per_node, PAGE_SIZE << order);
 	pr_info("hugetlb_cma: reserve %lu MiB, up to %lu MiB per node\n",
 		hugetlb_cma_size / SZ_1M, per_node / SZ_1M);
 


