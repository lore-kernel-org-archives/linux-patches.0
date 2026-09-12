Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C7A37F8B2;
	Sat, 12 Sep 2026 09:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206295; cv=none; b=a2/IXGY3J8NJfBrnF2UqFZKnTvdya5hHL9HOAwi9C4hfjfoDkgC/Zg3JaoiJKLnsI1ZxHC0tSYVtZfRMqwZCq5VkyPNAaH4iibRnbY370prG3O7fJAelbMC/p3eBBEuTTUrZg2eedxSBufsNzp/tdL78GOFOi0BY1Wi2w0P+YnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206295; c=relaxed/simple;
	bh=caDEQS29551wHibKxcxvwLP9pZ6DB4E/hUvUqIMp+8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YaErEQSKt7vmt7exxkN3AQI+OGS6icaHhY5ARE0LuLfEzikBF/MId+zrDpK9CLPTZAa3qbujGaSJHj7eu1JNU6/FOjGMFbkKwuMQPbf/Mbzz3b/82ZnnY9nsBW6ix8WYiE/XiK+X6Y8lEzJ2XaoFCO5AhmvuO+v8kIl0Bfsd/tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J+kfLU6o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J+kfLU6o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19FF1F000FF;
	Sat, 12 Sep 2026 09:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206293;
	bh=yR64M/2lr1voBeB78KUPgq72OesDjzVPg9leAtLHtAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J+kfLU6o34bP57+xGHpW9FvGriS9R9n1e+hQCHORfq5CKK3Gr74EJIP3rjSK/0mP9
	 D+3Xeor4aCWv1xV4az8FdusvLcuEhZBbKMYwXd7I33zAa3bT2GjsGsINkwqLxP49vK
	 tDXxKU5mAgjYlkA7S3P4iPDkr76Sw6L9766bQRYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0140/1518] mm/mm_init: fix incorrect node_spanned_pages
Date: Sat, 12 Sep 2026 08:38:29 +0200
Message-ID: <20260912065626.662278345@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Wei Yang <richard.weiyang@gmail.com>

[ Upstream commit 7783dcd79ae9c4aa48bc47bd4275772445dc4b2a ]

Current node_spanned_pages is got as a summation of all zone's spanned page
in calculate_node_totalpages(). Generally this is good, but if we use
kernelcore=mirror, it is would be wrong.

Without kernelcore=mirror:

    The test machine has below memory layout:

      memory[0x0]     [0x0000000000001000-0x000000000009efff], 0x000000000009e000 bytes on node 0 flags: 0x0
      memory[0x1]     [0x0000000000100000-0x00000000bffdefff], 0x00000000bfedf000 bytes on node 0 flags: 0x0
      memory[0x2]     [0x0000000100000000-0x00000001bfffffff], 0x00000000c0000000 bytes on node 0 flags: 0x0

    And the Zone range is:

      DMA      [mem 0x0000000000001000-0x0000000000ffffff]
      DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
      Normal   [mem 0x0000000100000000-0x00000001bfffffff]

    Then we see, with spanned_pages printed:

      On node 0 spanned_pages: 1835007 totalpages: 1572733

With kernelcore=mirror:

    The test machine has below memory layout:

      memory[0x0]     [0x0000000000001000-0x000000000009efff], 0x000000000009e000 bytes on node 0 flags: 0x2
      memory[0x1]     [0x0000000000100000-0x00000000bffdefff], 0x00000000bfedf000 bytes on node 0 flags: 0x2
      memory[0x2]     [0x0000000100000000-0x000000013fffffff], 0x0000000040000000 bytes on node 0 flags: 0x2
      memory[0x3]     [0x0000000140000000-0x00000001bfffffff], 0x0000000080000000 bytes on node 0 flags: 0x0

    And the Zone range is:

      DMA      [mem 0x0000000000001000-0x0000000000ffffff]
      DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
      Normal   [mem 0x0000000100000000-0x00000001bfffffff]
      Device   empty
    Movable zone start for each node
      Node 0: 0x0000000140000000

    Then we see, with spanned_pages printed:

      On node 0 spanned_pages: 2359295 totalpages: 1572733

The total range of memory on node 0 doesn't change, but the spanned_pages
becomes much larger.

The reason is when kernelcore=mirror is specified, the range of Zone Normal
and Zone Movable would overlap. So the overlapped range would be calculated
twice.

A wrong node_spanned_pages would effect defer_init(), since each
zone_end_pfn is less than pgdat_end_pfn().

As we already passed in node_start_pfn and node_end_pfn, fix this by get it
from (node_start_pfn - node_end_pfn) directly.

Fixes: 342332e6a925 ("mm/page_alloc.c: introduce kernelcore=mirror option")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Yuan Liu <yuan1.liu@intel.com>
Link: https://patch.msgid.link/20260622022403.16375-1-richard.weiyang@gmail.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mm_init.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 5789ad8ba9b6d..4ed5b09f4eb4f 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1351,7 +1351,7 @@ static void __init calculate_node_totalpages(struct pglist_data *pgdat,
 						unsigned long node_start_pfn,
 						unsigned long node_end_pfn)
 {
-	unsigned long realtotalpages = 0, totalpages = 0;
+	unsigned long realtotalpages = 0;
 	enum zone_type i;
 
 	for (i = 0; i < MAX_NR_ZONES; i++) {
@@ -1381,11 +1381,10 @@ static void __init calculate_node_totalpages(struct pglist_data *pgdat,
 		zone->present_early_pages = real_size;
 #endif
 
-		totalpages += spanned;
 		realtotalpages += real_size;
 	}
 
-	pgdat->node_spanned_pages = totalpages;
+	pgdat->node_spanned_pages = node_end_pfn - node_start_pfn;
 	pgdat->node_present_pages = realtotalpages;
 	pr_debug("On node %d totalpages: %lu\n", pgdat->node_id, realtotalpages);
 }
-- 
2.53.0



