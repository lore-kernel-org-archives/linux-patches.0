Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D06047F796;
	Thu, 20 Aug 2026 17:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248475; cv=none; b=XAIEaK7APT7V0Gp/XXkYEGWBfm88LBSj8k6XsLA0/gS4rSYBLCl9sNzMKEnAr6TcwGbQ6XqKxTtP8ETMTxgsDtUyJ/ycosiSEdsJlQZLh6dgL8Vu1U+a5QcYXVq/bAu9PhaKi29SWueHKt7gKTqLZNY+ZJ4aaKd51UXQ15KI8AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248475; c=relaxed/simple;
	bh=MobdE5b2M2B5I0Z9/WzNN9Fhl6YW6rnvcMwEE/DSrKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k01uM1oBd9meIEJy9bFLFAMOkd6nytrZIkavVyRP6mWu6JxyHROTL0MnyaFmDDeujInP9bD6FRD6e7N65EDj7MLox+R9Z4GHWox9UQ6ik4sQRJW6zc31AWie+2/K/oQRFLZeW79Chl9FEItc6X/NhnFYYkwumtlOCbGEgd+9S0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ltHZrAfn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ltHZrAfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DDED1F000E9;
	Thu, 20 Aug 2026 17:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248473;
	bh=Ksy8ZHEWPTXf9rTQIeZvksS0YlmdGbzp3vOmdEq/wSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ltHZrAfnA6Ygn5dqvVsz8Jq/rOygoYeFtVsYu0j9olkg9TK7CqExQTM/QDDRTvpdS
	 o1LOHROVc7gGJwWnJujCXd9Zgs7+Tl+3ncLHVHBXrpwAm6LO7wHbwFfqoirZZ1N3QR
	 SNF6R7wNIQ5HfW2ctlV0Bw7tPm1v3MyB48S61P3g=
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
Subject: [PATCH 6.1 241/303] mm/vmstat: fold stranded per-cpu node stats when a node comes online
Date: Thu, 20 Aug 2026 16:56:17 +0200
Message-ID: <20260820145300.691133884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 mm/page_alloc.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7734,7 +7734,7 @@ void __ref free_area_init_core_hotplug(s
 {
 	int nid = pgdat->node_id;
 	enum zone_type z;
-	int cpu;
+	int cpu, i;
 
 	pgdat_init_internals(pgdat);
 
@@ -7750,10 +7750,18 @@ void __ref free_area_init_core_hotplug(s
 	pgdat->kswapd_order = 0;
 	pgdat->kswapd_highest_zoneidx = 0;
 	pgdat->node_start_pfn = 0;
-	for_each_online_cpu(cpu) {
-		struct per_cpu_nodestat *p;
 
-		p = per_cpu_ptr(pgdat->per_cpu_nodestats, cpu);
+	/*
+	 * Hot-unplug can leave per-cpu vmstat deltas unfolded (folders skip
+	 * offline nodes) - reconcile this at online. Foreign access to counters
+	 * is safe: the node is not online yet and we hold the hotplug lock.
+	 */
+	for_each_possible_cpu(cpu) {
+		struct per_cpu_nodestat *p = per_cpu_ptr(pgdat->per_cpu_nodestats, cpu);
+
+		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
+			if (p->vm_node_stat_diff[i])
+				node_page_state_add(p->vm_node_stat_diff[i], pgdat, i);
 		memset(p, 0, sizeof(*p));
 	}
 


