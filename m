Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3003373C02;
	Sat, 28 Feb 2026 17:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301537; cv=none; b=p9w32roV3VlI+5mSH5w0uGXYNwJKfqzf7z5WbZe1Lbqr6QPvcoJ4bgNOAJDrOJMucEuWYP28w6Vp2Oo7celBNp4hAsZiBl2JDul6A9x8Be139O7qpJuGl1KLjzUR3hUDrl+uVJUBVQypP352Ht0HfIJ2fDhNFZQXEZMh47wG37w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301537; c=relaxed/simple;
	bh=JjtGG2n/yeEkZ8iqF8FTMNX/ar1yKwTPTMTVOqLlhzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+O3y5/ULimGZ45eE4WIoBmhnZ+He0CBcy+htO0qGoJjVKUK49tHeFdoq8wnLfxBtE93+6hxyt+xKylm6q60wDQPifHc7qmHtI9r3rvDPr/10aOOGXlFZZztPXHs7wwIdMtFq1mX6XjqpEXyhRzNWJ4/rtg8hn40x5QrErQMZ0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MJRvsUIp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MJRvsUIp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4091C19425;
	Sat, 28 Feb 2026 17:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301536;
	bh=JjtGG2n/yeEkZ8iqF8FTMNX/ar1yKwTPTMTVOqLlhzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MJRvsUIpcVWaGErSpBeW42AYRoH0KvFg2FdjlKf8eKm55L5d5ACD3eWSXnZAJ0pwW
	 h6/ljzjnVvkiMWWVWaAcEEQ57dVQGYoXebuJIk9AOg1e3W8Ef+4EPPfafJFsjh3JrS
	 SKYz53dk0AE+fjTwWQU3cgeNu6alIqHw0UpeXW9H6O5Ab0cWpkhNIozN3gpMAS4Eza
	 8KjUF0INm1wFv4Cv75h1K4U2eCFuuLrlhKc8LRNg8sRcsSdCGbnRZu8sUoqvNYWlGE
	 II5+DDoXgAStcbyEk3juShO0PinzRAQwNxONE3LUbo1xXC0h6yKZVKrmH1aW7oyHrg
	 7z3G2tw+o0S1A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Cui Chao <cuichao1753@phytium.com.cn>,
	stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Gregory Price <gourry@gourry.net>,
	Dan Williams <dan.j.williams@intel.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 718/752] mm: numa_memblks: Identify the accurate NUMA ID of CFMW
Date: Sat, 28 Feb 2026 12:47:09 -0500
Message-ID: <20260228174750.1542406-718-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Cui Chao <cuichao1753@phytium.com.cn>

[ Upstream commit f043a93fff9e3e3e648b6525483f59104b0819fa ]

In some physical memory layout designs, the address space of CFMW (CXL
Fixed Memory Window) resides between multiple segments of system memory
belonging to the same NUMA node. In numa_cleanup_meminfo, these multiple
segments of system memory are merged into a larger numa_memblk. When
identifying which NUMA node the CFMW belongs to, it may be incorrectly
assigned to the NUMA node of the merged system memory.

When a CXL RAM region is created in userspace, the memory capacity of
the newly created region is not added to the CFMW-dedicated NUMA node.
Instead, it is accumulated into an existing NUMA node (e.g., NUMA0
containing RAM). This makes it impossible to clearly distinguish
between the two types of memory, which may affect memory-tiering
applications.

Example memory layout:

Physical address space:
    0x00000000 - 0x1FFFFFFF  System RAM (node0)
    0x20000000 - 0x2FFFFFFF  CXL CFMW (node2)
    0x40000000 - 0x5FFFFFFF  System RAM (node0)
    0x60000000 - 0x7FFFFFFF  System RAM (node1)

After numa_cleanup_meminfo, the two node0 segments are merged into one:
    0x00000000 - 0x5FFFFFFF  System RAM (node0) // CFMW is inside the range
    0x60000000 - 0x7FFFFFFF  System RAM (node1)

So the CFMW (0x20000000-0x2FFFFFFF) will be incorrectly assigned to node0.

To address this scenario, accurately identifying the correct NUMA node
can be achieved by checking whether the region belongs to both
numa_meminfo and numa_reserved_meminfo.

While this issue is only observed in a QEMU configuration, and no known
end users are impacted by this problem, it is likely that some firmware
implementation is leaving memory map holes in a CXL Fixed Memory Window.
CXL hotplug depends on mapping free window capacity, and it seems to be
only a coincidence to have not hit this problem yet.

Fixes: 779dd20cfb56 ("cxl/region: Add region creation support")
Signed-off-by: Cui Chao <cuichao1753@phytium.com.cn>
Cc: stable@vger.kernel.org
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Link: https://patch.msgid.link/20260213060347.2389818-2-cuichao1753@phytium.com.cn
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/numa_memblks.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
index 8f5735fda0a21..3f53464240e8d 100644
--- a/mm/numa_memblks.c
+++ b/mm/numa_memblks.c
@@ -570,15 +570,16 @@ static int meminfo_to_nid(struct numa_meminfo *mi, u64 start)
 int phys_to_target_node(u64 start)
 {
 	int nid = meminfo_to_nid(&numa_meminfo, start);
+	int reserved_nid = meminfo_to_nid(&numa_reserved_meminfo, start);
 
 	/*
-	 * Prefer online nodes, but if reserved memory might be
-	 * hot-added continue the search with reserved ranges.
+	 * Prefer online nodes unless the address is also described
+	 * by reserved ranges, in which case use the reserved nid.
 	 */
-	if (nid != NUMA_NO_NODE)
+	if (nid != NUMA_NO_NODE && reserved_nid == NUMA_NO_NODE)
 		return nid;
 
-	return meminfo_to_nid(&numa_reserved_meminfo, start);
+	return reserved_nid;
 }
 EXPORT_SYMBOL_GPL(phys_to_target_node);
 
-- 
2.51.0

