Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD09019D8BC;
	Sat, 12 Sep 2026 09:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206312; cv=none; b=eL28X1x5+if4FY8wlJw3aj0hNP+Pd3E1fS/I9T85Rx1yZekQykM+dkgIaRDeVEoIIFjXELXtzBUMXf5+yZ3XubUEL/NjEohlXA6FukIVN7vcmd1IsbNrq07Sh8QEf1jc9kJayDx/27XAj01gtjxpzaYcd6Qoj6RGB0GCsIIcYGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206312; c=relaxed/simple;
	bh=GbHEs2HvZS2x96eeQUeJdPQLE1+Vl38WPl/29SXibAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuIjVVcM9m6N2SwjViWP8rillXNGMWUIwrmMeMKAzwF1MOR4ZFCT5PcfyDAhcGY9IVISN4jxTzz7BP0YcpvsfYB2giVwK+qbRU4ZczZL8gx6+K9KTt8cdiBxsqjGMy0lLFyst7TjA4m3MjpUihnbxVq2GSpWgfybngFmWLtzzgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WHKHVFV2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WHKHVFV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1FDB1F000FF;
	Sat, 12 Sep 2026 09:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206311;
	bh=8W9F6dWLyMzFvqwSP5znSYvb3hpZgMMRZ/J7Xnrms78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WHKHVFV2pJSMKLT8l0kniy9k9tx7RebjtP23ogTp1RS+w9vBPzMIbSegFOrEmHlyn
	 Jan2Ak1eL6kKVXhbvS6yA8THlFsP4qDc8+T4FHouJuVa3Wi7lfVXG/+ZD+WXaPbl+3
	 QcZlbJ/DFfZ2MQcgtKxx1JIS/soZpeFlhSjox1gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0179/1518] mm/mm_init: handle alloc_percpu failure in free_area_init_core_hotplug
Date: Sat, 12 Sep 2026 08:39:08 +0200
Message-ID: <20260912065627.539860567@linuxfoundation.org>
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

From: Gregory Price <gourry@gourry.net>

[ Upstream commit 2ebce860bdd7ae5e13002811bc9bbbf33fcfc221 ]

We miss a failed allocation check for pgdat->per_cpu_nodestats, which
results in a NULL deref when we offset into the per-cpu area.

Propagate -ENOMEM up the stack and leave per_cpu_nodestats pointing
at boot_nodestats so a later online can retry the allocation.

hotadd_init_pgdat() returns NULL on failure, which __try_online_node()
already maps to -ENOMEM.

On failure nothing needs to be unwound:
  - the node is never marked online
  - per_cpu_nodestats is left pointing at boot_nodestats
  - __add_memory_resource() cleans up pending memblock resources
  - later online attempts retry the per_cpu_nodestats allocation

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260627202243.758289-1-gourry%40gourry.net
Fixes: 75ef71840539 ("mm, vmstat: add infrastructure for per-node vmstats")
Signed-off-by: Gregory Price <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Link: https://patch.msgid.link/20260701221613.2818148-1-gourry@gourry.net
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/memory_hotplug.h |  2 +-
 mm/memory_hotplug.c            |  3 ++-
 mm/mm_init.c                   | 14 +++++++++++---
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index d4d54070f77a5..bb01cd2671312 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -304,7 +304,7 @@ static inline void __remove_memory(u64 start, u64 size) {}
 /* Default online_type (MMOP_*) when new memory blocks are added. */
 extern enum mmop mhp_get_default_online_type(void);
 extern void mhp_set_default_online_type(enum mmop online_type);
-extern void __ref free_area_init_core_hotplug(struct pglist_data *pgdat);
+int __ref free_area_init_core_hotplug(struct pglist_data *pgdat);
 extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory_resource(int nid, struct resource *resource,
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index a0e9cfe208da1..9fdfb2d317654 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1279,7 +1279,8 @@ static pg_data_t *hotadd_init_pgdat(int nid)
 	pgdat = NODE_DATA(nid);
 
 	/* init node's zones as empty zones, we don't have any present pages.*/
-	free_area_init_core_hotplug(pgdat);
+	if (free_area_init_core_hotplug(pgdat))
+		return NULL;
 
 	/*
 	 * The node we allocated has no zone fallback lists. For avoiding
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 4ed5b09f4eb4f..a27ba1c1a7192 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1560,7 +1560,7 @@ void __init set_pageblock_order(void)
  * NOTE: this function is only called during memory hotplug
  */
 #ifdef CONFIG_MEMORY_HOTPLUG
-void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
+int __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
 {
 	int nid = pgdat->node_id;
 	enum zone_type z;
@@ -1568,8 +1568,14 @@ void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
 
 	pgdat_init_internals(pgdat);
 
-	if (pgdat->per_cpu_nodestats == &boot_nodestats)
-		pgdat->per_cpu_nodestats = alloc_percpu(struct per_cpu_nodestat);
+	if (pgdat->per_cpu_nodestats == &boot_nodestats) {
+		struct per_cpu_nodestat __percpu *p;
+
+		p = alloc_percpu(struct per_cpu_nodestat);
+		if (!p)
+			return -ENOMEM;
+		pgdat->per_cpu_nodestats = p;
+	}
 
 	/*
 	 * Reset the nr_zones, order and highest_zoneidx before reuse.
@@ -1607,6 +1613,8 @@ void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
 		zone->present_pages = 0;
 		zone_init_internals(zone, z, nid, 0);
 	}
+
+	return 0;
 }
 #endif
 
-- 
2.53.0



