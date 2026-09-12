Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073AE2DB7B8;
	Sat, 12 Sep 2026 14:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222665; cv=none; b=lAEU2tFiKMCEDWrloxB4oSxc+SuCZ+F9m4BI77cweVkCzIgna/iDXzQQYMLvPFQBaD4EU3CN1iGmA8a/hCK/19zTML6jfgen7en4FP7dYtihTUa/LlDo/IXTh5X2b95xLmdITdJFQQmShewhzutYPe0F4h3dnzc3LwQN1m6PWBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222665; c=relaxed/simple;
	bh=de39cut7mKzxsj2VWQ1Bltjx4N9U+rk2SB0VdkzBTxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DsLf1XlxOXFRMWcQrIJ+DayfUlQgaa3ND+MhDzEJpP8FinDtO+suOlWkEAEcw5vzj4UdyfoT0+nIEaC7l5ESlP315zYRLMD5LnB2Tg39620wm1V+ehhEbIMlnBnLYYzrvCIsl8qsR8R90aP3EoO/byc32ogo62Qbm6xkpx4SgGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+mZMI43; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+mZMI43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390391F00893;
	Sat, 12 Sep 2026 14:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222662;
	bh=LeWriisVT67kkCBRZfNvA3E1NY++LrhuIVLBkYwvyfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f+mZMI432lu5Vq5bFtuYaEDT+JzR5mTfp5a9ZuY0J5E9+hvY4RswUmuNSdg4FAVID
	 Vv0RF6qcU/53ERN57MTrOSX9LAj9HgtyJ4br1/JzVchEI6ERnyaPWjecOK4SXzKGXG
	 7wLncM1aKPfgiblxBrZT+hmj3CbqyFJVOurxa0uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0589/1424] mm/mm_init: fix incorrect node_spanned_pages
Date: Sat, 12 Sep 2026 08:50:21 +0200
Message-ID: <20260912065620.482609124@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 1aba3e8737d88..45c5a7ca96097 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1279,7 +1279,7 @@ static void __init calculate_node_totalpages(struct pglist_data *pgdat,
 						unsigned long node_start_pfn,
 						unsigned long node_end_pfn)
 {
-	unsigned long realtotalpages = 0, totalpages = 0;
+	unsigned long realtotalpages = 0;
 	enum zone_type i;
 
 	for (i = 0; i < MAX_NR_ZONES; i++) {
@@ -1309,11 +1309,10 @@ static void __init calculate_node_totalpages(struct pglist_data *pgdat,
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



