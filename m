Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE943B27C9;
	Sat, 17 Oct 2026 18:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260379; cv=none; b=hBldXLh8ki4dW/5OoPed5nDNU5ApQpTfAwmpMHQY1ZAAHRmmfLS+WssLifjwN6zlpp7QVFqTWT67c6vmQ68RnhHwEWTnYIA/ExtdkV2DGLmj4eB/nuTlK+K2XjlmiT8DQSWxXqkxSU9lIgh1JLKYqf+h5uw8r9mlXY9MR174jK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260379; c=relaxed/simple;
	bh=+tYxXbASFJdoXzgq3Egef70FgDtECDzjLij4mRHSP9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZwfNk8Wxq+HbffsyO6hK8jcCza7F2RG4laxLp2fcZT0PZ69Rt+A/IZkZYPig9+gvG+KrWdOpQXV1npZ7MshmyOEukLDGMllf4Xs2yAIv/eylE3/DRu3eyMGIV8fV3IWDuzz1Hv5T46zDHqjpsbzm/9/q/ZZ+1abbNvW1bcQXFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nxZvAAES; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nxZvAAES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A891F000C4;
	Sat, 17 Oct 2026 18:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260377;
	bh=HivVZmkCBr1j7OAMMULe0mzKxtyXtSUmShk0Xw1BgPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nxZvAAESQOUVije0Szjk7kUL7kPrLdY+9H6oCXQ/vFKvyUEWx3Fz1aT23gv5ceXuK
	 I0a6ltYS8khr/BCBKVJeAIxu7TYwB1bgztzmibwM7v4w0BRLgx/CNM70ow/+KoJZ5m
	 GdJ2ttsrM+1zXh/8I8PGV4mM37X275QXbsym327Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1498/1674] mm/mm_init: handle alloc_percpu failure in free_area_init_core_hotplug
Date: Sat, 17 Oct 2026 18:02:50 +0200
Message-ID: <20261017160509.590639491@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index 3777d10038c52..41abb2624eb8e 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -329,7 +329,7 @@ static inline void __remove_memory(u64 start, u64 size) {}
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-extern void __ref free_area_init_core_hotplug(struct pglist_data *pgdat);
+int __ref free_area_init_core_hotplug(struct pglist_data *pgdat);
 extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory_resource(int nid, struct resource *resource,
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 349e34b924af6..08444c40ed650 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1237,7 +1237,8 @@ static pg_data_t __ref *hotadd_init_pgdat(int nid)
 	pgdat = NODE_DATA(nid);
 
 	/* init node's zones as empty zones, we don't have any present pages.*/
-	free_area_init_core_hotplug(pgdat);
+	if (free_area_init_core_hotplug(pgdat))
+		return NULL;
 
 	/*
 	 * The node we allocated has no zone fallback lists. For avoiding
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 45c5a7ca96097..27451dfc2fc04 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1509,7 +1509,7 @@ void __init set_pageblock_order(void)
  * NOTE: this function is only called during memory hotplug
  */
 #ifdef CONFIG_MEMORY_HOTPLUG
-void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
+int __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
 {
 	int nid = pgdat->node_id;
 	enum zone_type z;
@@ -1517,8 +1517,14 @@ void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
 
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
@@ -1556,6 +1562,8 @@ void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
 		zone->present_pages = 0;
 		zone_init_internals(zone, z, nid, 0);
 	}
+
+	return 0;
 }
 #endif
 
-- 
2.53.0



