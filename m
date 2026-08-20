Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D224779BE;
	Thu, 20 Aug 2026 16:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244504; cv=none; b=SfFw37TotOfGMq4yTzjW8LjpH3htQWnr9BSpjgs4KCP8DDqAw3BjIolLyEyRI08J8vKolmISPl9c8I19dUZHOgpD3jGm80rI+kL9Kg16FTny8rUUp+EX5HWc6GQ+zW6kzVLTKzjFVp6vjwAlFq+rh8a5XsY0fFlqbIg6+UB3yhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244504; c=relaxed/simple;
	bh=q5xA19kKIRPUX+JBPZP9q37LoEswMD/RNbvbHq4o2Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GW7IMXGKuW8DR3wLvVYMp9DnI6KzClHPLAM3nYvKCESpm5hdVH27vMfFiXxuh52xMj8lY/bcWWT5ZbDwV1/X0KGjFYSPOkcRDBBM3R6J70A0SZsNy/PNWHf2/xfGsME4T37NDVB5oi2uHCHQsZPzywfZMMZPcBV1CcXq3Ovykco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=03+H0Zi0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="03+H0Zi0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBBB1F000E9;
	Thu, 20 Aug 2026 16:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244503;
	bh=vljDhq7JMT/P3nzYgwfCkc2uP4EF2dOq6ZmDLRR6EUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=03+H0Zi0jU5rKQK8pYXhp/8ip7v5yhHxlKYDzieyGqtdzg1dF1APSULj5QwY58uuP
	 tKRb5jJ2zGJ1WcUdLRv8bRItyrGsTeQZUV+bQ85s2/YUitABX28Z87WpJajW8Wr17T
	 akieySIEa1a1MJ6AYk5CH6hCHt8an4ssa7RT4KXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Price <gourry@gourry.net>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Mel Gorman <mgorman@techsingularity.net>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 192/235] mm/vmstat: fold stranded per-cpu node stats when a node comes online
Date: Thu, 20 Aug 2026 16:57:08 +0200
Message-ID: <20260820145222.361590007@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

From: Gregory Price <gourry@gourry.net>

[ Upstream commit ea3034b2b00fa50c8d2518d0804c9d427bbafa86 ]

A per-node vmstat counter is pgdat->vm_stat[] plus per-cpu deltas.  A
balanced counter can sit split as global=+N / per-cpu=-N.

The folds reconciling the split only walk online nodes, so when
try_offline_node() marks a node offline the per-cpu deltas are stranded.

A subsequent online resets the per-cpu area but not pgdat->vm_stat[],
orphaning the +N permanently.  All NR_VM_NODE_STAT_ITEMS are affected.

The existing code zeroes the per-cpu counters and causes a permanent skew.
Fold the stranded deltas instead, before the node rejoins the online set.
The node is not online yet and the hotplug lock is held, so the remote
access to per-cpu values is safe.

Discovered when node compaction hung for a nearly empty node, as the math
to determine throttling broke.  Reproduced by repeated memory
hotplug/unplug cycles on a node under pressure: NR_ISOLATED_ANON ratchets
up and never returns to zero.

Link: https://lore.kernel.org/20260627202243.758289-1-gourry@gourry.net
Fixes: 75ef71840539 ("mm, vmstat: add infrastructure for per-node vmstats")
Signed-off-by: Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory_hotplug.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -894,7 +894,7 @@ static pg_data_t __ref *hotadd_new_pgdat
 			alloc_percpu(struct per_cpu_nodestat);
 		arch_refresh_nodedata(nid, pgdat);
 	} else {
-		int cpu;
+		int cpu, i;
 		/*
 		 * Reset the nr_zones, order and highest_zoneidx before reuse.
 		 * Note that kswapd will init kswapd_highest_zoneidx properly
@@ -903,10 +903,17 @@ static pg_data_t __ref *hotadd_new_pgdat
 		pgdat->nr_zones = 0;
 		pgdat->kswapd_order = 0;
 		pgdat->kswapd_highest_zoneidx = 0;
-		for_each_online_cpu(cpu) {
-			struct per_cpu_nodestat *p;
+		/*
+		 * Hot-unplug can leave per-cpu vmstat deltas unfolded (folders skip
+		 * offline nodes) - reconcile this at online. Foreign access to counters
+		 * is safe: the node is not online yet and we hold the hotplug lock.
+		 */
+		for_each_possible_cpu(cpu) {
+			struct per_cpu_nodestat *p = per_cpu_ptr(pgdat->per_cpu_nodestats, cpu);
 
-			p = per_cpu_ptr(pgdat->per_cpu_nodestats, cpu);
+			for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
+				if (p->vm_node_stat_diff[i])
+					node_page_state_add(p->vm_node_stat_diff[i], pgdat, i);
 			memset(p, 0, sizeof(*p));
 		}
 	}


