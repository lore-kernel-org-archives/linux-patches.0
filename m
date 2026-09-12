Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2FF3C1F46;
	Sat, 12 Sep 2026 07:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197087; cv=none; b=HWIgPb+Xj1M/MD0suYmufFeDWbRuzeeXTepQFXwjNjF47BoNTVgzQN5K5winexDVeTKfHGA1C8PfvYsHj8EOvSn5q7U4SL1G1OS8jn+HzlxO+/XbiOXTrzAuaFJ/tFTPZ5wimHAGdvcBNe5Nt+P9jstkU2AZKl3LIhXLSyY4E9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197087; c=relaxed/simple;
	bh=UsznuHz3pPJu2CWkaKs0sqQvc+BwlxKvcI9BE6MaUrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BxcvNubFZBSFrcDoItiyTIoOZ2R85mhBgdryftl9zIXgH+BZzIHx7lhCBKpuTAeJYlr3e4RhOTj5cQZs0xkGogfTdHSXK69q2/MWMBhLRh1SCJD5/4yQYGQ01jxGnDl/FVz7V8TAscs06CiX/FRwWx9Z/CnF8Jbr4CKREzC7k+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X8B+C9bv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X8B+C9bv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDADB1F000FF;
	Sat, 12 Sep 2026 07:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197085;
	bh=qOgwFB9IWC6YdtI1KqgAKEd80aLj8cFI+QB9imwpkaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X8B+C9bvDFJIFKdAvwvMIXt/DaBUWAxFE/caF7Ez6ZyBKTeQ99VtRG2X5UjLAQ7d+
	 Kx5lKe0ybO/ZP7izlwkjop8YiBjfp3Jnr75aoCIxQs/7SedweWhaOSifHBh8E/gwwM
	 KlFeSFs1Bz3Exli1ys69sX0z/mEmxdK8u/7LPZ34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0099/1815] mm/mm_init: fix incorrect node_spanned_pages
Date: Sat, 12 Sep 2026 08:30:49 +0200
Message-ID: <20260912065651.334238271@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index ab42850818692..d52eea4e63479 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1338,7 +1338,7 @@ static void __init calculate_node_totalpages(struct pglist_data *pgdat,
 						unsigned long node_start_pfn,
 						unsigned long node_end_pfn)
 {
-	unsigned long realtotalpages = 0, totalpages = 0;
+	unsigned long realtotalpages = 0;
 	enum zone_type i;
 
 	for (i = 0; i < MAX_NR_ZONES; i++) {
@@ -1368,11 +1368,10 @@ static void __init calculate_node_totalpages(struct pglist_data *pgdat,
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



