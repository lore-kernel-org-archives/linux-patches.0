Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B933230D14;
	Mon, 10 Mar 2025 17:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626674; cv=none; b=ZFMHjZp38t1KxwdEN25CZWYvqd8ILnqIb+oaOPQytSpCX85rJm3KQ8BnicvFM8aRpYUz6IkEsbj9rkJgQeGuTQ1EecjKS7K95g0hyhF3S660emX1NkK47WQ5cpCk48vsO5ynicRfIvPoJakqzGAx/1O6tBpOYolOa99dwUV/yIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626674; c=relaxed/simple;
	bh=qyssn6DFMeCEssTknjcgETP+v63N7MpYW3GNjwwtAQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G574+wioiAsTCgbkZcwI6jPPAkz+N7azQytrI9MZh8lz3XtC27AFXMkFJIRHCoq0+/HDcNxb5oP1VlX9sluckP8jK9Bg2AcLfZ7vDTYOZC1kXN9eMO5rvyH8O7758NiUmOzfEqgdcnXj0Eo1aNIR20eUBzYbZrMrVaqoKkKIwBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DEwBmNC4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DEwBmNC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882EAC4CEE5;
	Mon, 10 Mar 2025 17:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626673;
	bh=qyssn6DFMeCEssTknjcgETP+v63N7MpYW3GNjwwtAQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DEwBmNC4HLIppBL8H6PGbcnqYihZXR3W/xPRYFDtBsEO82NjrSVyuVOctuwO3W5Dl
	 lhejgSnHv5DugmwnUrNtHvZn/PkU1mSm0hJKyOzyeEArPs79RGUo1oC63qy2JOwhL/
	 68dom1VNGtg9HMad/TiQGEC72UuZyeZSQDegsXQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@suse.com>,
	Mel Gorman <mgorman@suse.de>,
	Baoquan He <bhe@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.13 041/207] Revert "mm/page_alloc.c: dont show protection in zones ->lowmem_reserve[] for empty zone"
Date: Mon, 10 Mar 2025 18:03:54 +0100
Message-ID: <20250310170449.402180229@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@suse.de>

commit eae116d1f0449ade3269ca47a67432622f5c6438 upstream.

Commit 96a5c186efff ("mm/page_alloc.c: don't show protection in zone's
->lowmem_reserve[] for empty zone") removes the protection of lower zones
from allocations targeting memory-less high zones.  This had an unintended
impact on the pattern of reclaims because it makes the high-zone-targeted
allocation more likely to succeed in lower zones, which adds pressure to
said zones.  I.e, the following corresponding checks in
zone_watermark_ok/zone_watermark_fast are less likely to trigger:

        if (free_pages <= min + z->lowmem_reserve[highest_zoneidx])
                return false;

As a result, we are observing an increase in reclaim and kswapd scans, due
to the increased pressure.  This was initially observed as increased
latency in filesystem operations when benchmarking with fio on a machine
with some memory-less zones, but it has since been associated with
increased contention in locks related to memory reclaim.  By reverting
this patch, the original performance was recovered on that machine.

The original commit was introduced as a clarification of the
/proc/zoneinfo output, so it doesn't seem there are usecases depending on
it, making the revert a simple solution.

For reference, I collected vmstat with and without this patch on a freshly
booted system running intensive randread io from an nvme for 5 minutes.  I
got:

rpm-6.12.0-slfo.1.2 ->  pgscan_kswapd 5629543865
Patched             ->  pgscan_kswapd 33580844

33M scans is similar to what we had in kernels predating this patch.
These numbers is fairly representative of the workload on this machine, as
measured in several runs.  So we are talking about a 2-order of magnitude
increase.

Link: https://lkml.kernel.org/r/20250226032258.234099-1-krisman@suse.de
Fixes: 96a5c186efff ("mm/page_alloc.c: don't show protection in zone's ->lowmem_reserve[] for empty zone")
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5858,11 +5858,10 @@ static void setup_per_zone_lowmem_reserv
 
 			for (j = i + 1; j < MAX_NR_ZONES; j++) {
 				struct zone *upper_zone = &pgdat->node_zones[j];
-				bool empty = !zone_managed_pages(upper_zone);
 
 				managed_pages += zone_managed_pages(upper_zone);
 
-				if (clear || empty)
+				if (clear)
 					zone->lowmem_reserve[j] = 0;
 				else
 					zone->lowmem_reserve[j] = managed_pages / ratio;


