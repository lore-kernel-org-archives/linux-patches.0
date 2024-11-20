Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8972F1AA1E6;
	Wed, 20 Nov 2024 12:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107586; cv=none; b=nQyryBjbCBMRDbWkS/kzNeX8Sv5sx5S6ZMLHEJmD+9YU8USoc3ptfEieR2tmnJgagfKOk2zyqKWA+wKV2dYpKoC7ryWTMLfSDU1fKidHdEphgvjjRwBhlHa59rOj3HRefKdN5ac4w3ohN5HmULMhZAgOGMwbI4c5PzjvWZYrAcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107586; c=relaxed/simple;
	bh=WqwHEe6rbdrNMUauHspmKiFumff52F24z2yZNL4HGQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XR260Kg6zfk3X1Oo48NW/NTyy7N/BUHZ4VqsZbZcwZKSWL9fBp4bePBfW11JL/7orAjW564PKptfqE8RC6DwPmQfMyYoJLTumCfOWkx4D9QIW0FMhtDkvbb2CHacfH/oFDZHajyuMQGHJvt2bHNk3UAgrOXY2lIb5pcqDyFjzd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b0xiubli; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b0xiubli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F35C4CECD;
	Wed, 20 Nov 2024 12:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107586;
	bh=WqwHEe6rbdrNMUauHspmKiFumff52F24z2yZNL4HGQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b0xiubliC5iGaJ2z/9jueHPlQ9D6kktv4YlKbI183liyeHo0Trz8mDxY6gU0YnFvg
	 z3Oz4+R8oGhcz6Kj8w4YrZ7OmXxg4ByWO9XwXMnqVLJCRw3GnjiDwbDQ6ANFKpT/XJ
	 tfZk+5L5RUKgg6sWuaH2hsFGKOFXDKbHVqf5LfUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjiang Tu <tujinjiang@huawei.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Alexander Lobakin <alobakin@pm.me>,
	David Hildenbrand <david@redhat.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Nanyong Sun <sunnanyong@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 29/82] mm: fix NULL pointer dereference in alloc_pages_bulk_noprof
Date: Wed, 20 Nov 2024 13:56:39 +0100
Message-ID: <20241120125630.267536136@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jinjiang Tu <tujinjiang@huawei.com>

commit 8ce41b0f9d77cca074df25afd39b86e2ee3aa68e upstream.

We triggered a NULL pointer dereference for ac.preferred_zoneref->zone in
alloc_pages_bulk_noprof() when the task is migrated between cpusets.

When cpuset is enabled, in prepare_alloc_pages(), ac->nodemask may be
&current->mems_allowed.  when first_zones_zonelist() is called to find
preferred_zoneref, the ac->nodemask may be modified concurrently if the
task is migrated between different cpusets.  Assuming we have 2 NUMA Node,
when traversing Node1 in ac->zonelist, the nodemask is 2, and when
traversing Node2 in ac->zonelist, the nodemask is 1.  As a result, the
ac->preferred_zoneref points to NULL zone.

In alloc_pages_bulk_noprof(), for_each_zone_zonelist_nodemask() finds a
allowable zone and calls zonelist_node_idx(ac.preferred_zoneref), leading
to NULL pointer dereference.

__alloc_pages_noprof() fixes this issue by checking NULL pointer in commit
ea57485af8f4 ("mm, page_alloc: fix check for NULL preferred_zone") and
commit df76cee6bbeb ("mm, page_alloc: remove redundant checks from alloc
fastpath").

To fix it, check NULL pointer for preferred_zoneref->zone.

Link: https://lkml.kernel.org/r/20241113083235.166798-1-tujinjiang@huawei.com
Fixes: 387ba26fb1cb ("mm/page_alloc: add a bulk page allocator")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4301,7 +4301,8 @@ unsigned long __alloc_pages_bulk(gfp_t g
 	gfp = alloc_gfp;
 
 	/* Find an allowed local zone that meets the low watermark. */
-	for_each_zone_zonelist_nodemask(zone, z, ac.zonelist, ac.highest_zoneidx, ac.nodemask) {
+	z = ac.preferred_zoneref;
+	for_next_zone_zonelist_nodemask(zone, z, ac.highest_zoneidx, ac.nodemask) {
 		unsigned long mark;
 
 		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&


