Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37563E40F3;
	Sat, 12 Sep 2026 09:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206309; cv=none; b=oEbWG4WICEyg3gLf6/k/REINPIV9MTm/WmnHrv+DA5N+VarNksSk40LfbyTgy5WRf9akMRL3Lo7wgIEjfPi6aSrJ136TxMONERf5rXrLs0nbxtPODU+kHNWRHF9FLrfnuR5GjF/krJnkusdGkb0oGOBd/iIVQ3z/0cublf3maNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206309; c=relaxed/simple;
	bh=C9rv4GiPd8QbaLXMABQFnyk343bHswMiuLK8TwFC+XY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+5L29StoLqdEvtmX2dogxwYuZwbVwQ1yL3fHYKTIdu6xBmJAQDVAkez71zsmyYqojiuWa6cfmrg98YlzHIxcl29+uGr1tbzK7NnKlle8FTBpRjIDylpmXfylfIGNmiP7vIzhhs1YL8ylnnudlI/S6q3YRGxYTq1PM628KPRKrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QryiEnn4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QryiEnn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0DC1F000FF;
	Sat, 12 Sep 2026 09:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206307;
	bh=2iRlopLp9Awb1UuGuFY3L/dT8SzqpqGUL8YAahWF83Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QryiEnn4xZKgIz0GY/RATP6iPSfwV1YVki58PuAJejSw8Bd0JS6eiYty9qIL0gMhw
	 qdMhQqrAh4+uTnPLBI6/hf5OoTXaWj351YB3QoKgKCtAobxDaTbjJPCkENx9hVrQ6W
	 HYWI8sLkbtUj+QP3ZwdUKut4klQNwkDrPTHyp46Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Price <gourry@gourry.net>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	"David Hildenbrand (arm)" <david@kernel.org>,
	Ben Cheatham <benjamin.cheatham@amd.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0178/1518] mm: name the anonymous MMOP enum as enum mmop
Date: Sat, 12 Sep 2026 08:39:07 +0200
Message-ID: <20260912065627.517581847@linuxfoundation.org>
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

[ Upstream commit c5c48345135ff04e039377020df23294d59aa59a ]

Give the MMOP enum (MMOP_OFFLINE, MMOP_ONLINE, etc) a proper type name so
the compiler can help catch invalid values being assigned to variables of
this type.

Leave the existing functions returning int alone to allow for
value-or-error pattern to remain unchanged without churn.

mmop_default_online_type is left as int because it uses the -1 sentinal
value to signal it hasn't been initialized yet.

Keep the uint8_t buffer in offline_and_remove_memory() as-is for space
efficiency, with an explicit cast when we consume the value.

Move the enum definition before the CONFIG_MEMORY_HOTPLUG guard so it is
unconditionally available for struct memory_block in memory.h.

No functional change.

Link: https://lore.kernel.org/linux-mm/3424eba7-523b-4351-abd0-3a888a3e5e61@kernel.org/
Link: https://lkml.kernel.org/r/20260211215447.2194189-1-gourry@gourry.net
Signed-off-by: Gregory Price <gourry@gourry.net>
Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Suggested-by: "David Hildenbrand (arm)" <david@kernel.org>
Reviewed-by: Ben Cheatham <benjamin.cheatham@amd.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 2ebce860bdd7 ("mm/mm_init: handle alloc_percpu failure in free_area_init_core_hotplug")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/memory.c          |  2 +-
 include/linux/memory.h         |  3 ++-
 include/linux/memory_hotplug.h | 16 ++++++++--------
 mm/memory_hotplug.c            | 10 +++++-----
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index c7d2323133e70..8adee0e8c753d 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -473,7 +473,7 @@ static ssize_t phys_device_show(struct device *dev,
 static int print_allowed_zone(char *buf, int len, int nid,
 			      struct memory_group *group,
 			      unsigned long start_pfn, unsigned long nr_pages,
-			      int online_type, struct zone *default_zone)
+			      enum mmop online_type, struct zone *default_zone)
 {
 	struct zone *zone;
 
diff --git a/include/linux/memory.h b/include/linux/memory.h
index ca20cbdd71f25..1c0c8f3c35fbb 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -19,6 +19,7 @@
 #include <linux/node.h>
 #include <linux/compiler.h>
 #include <linux/mutex.h>
+#include <linux/memory_hotplug.h>
 
 #define MIN_MEMORY_BLOCK_SIZE     (1UL << SECTION_SIZE_BITS)
 
@@ -79,7 +80,7 @@ enum memory_block_state {
 struct memory_block {
 	unsigned long start_section_nr;
 	enum memory_block_state state;	/* serialized by the dev->lock */
-	int online_type;		/* for passing data to online routine */
+	enum mmop online_type;	/* for passing data to online routine */
 	int nid;			/* NID for this memory block */
 	/*
 	 * The single zone of this memory block if all PFNs of this memory block
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 23f038a162319..d4d54070f77a5 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -16,11 +16,8 @@ struct resource;
 struct vmem_altmap;
 struct dev_pagemap;
 
-#ifdef CONFIG_MEMORY_HOTPLUG
-struct page *pfn_to_online_page(unsigned long pfn);
-
 /* Types for control the zone type of onlined and offlined memory */
-enum {
+enum mmop {
 	/* Offline the memory. */
 	MMOP_OFFLINE = 0,
 	/* Online the memory. Zone depends, see default_zone_for_pfn(). */
@@ -31,6 +28,9 @@ enum {
 	MMOP_ONLINE_MOVABLE,
 };
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+struct page *pfn_to_online_page(unsigned long pfn);
+
 /* Flags for add_memory() and friends to specify memory hotplug details. */
 typedef int __bitwise mhp_t;
 
@@ -302,8 +302,8 @@ static inline void __remove_memory(u64 start, u64 size) {}
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 /* Default online_type (MMOP_*) when new memory blocks are added. */
-extern int mhp_get_default_online_type(void);
-extern void mhp_set_default_online_type(int online_type);
+extern enum mmop mhp_get_default_online_type(void);
+extern void mhp_set_default_online_type(enum mmop online_type);
 extern void __ref free_area_init_core_hotplug(struct pglist_data *pgdat);
 extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
@@ -326,8 +326,8 @@ extern void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
 				  struct vmem_altmap *altmap);
 extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
 					  unsigned long pnum);
-extern struct zone *zone_for_pfn_range(int online_type, int nid,
-		struct memory_group *group, unsigned long start_pfn,
+extern struct zone *zone_for_pfn_range(enum mmop online_type,
+		int nid, struct memory_group *group, unsigned long start_pfn,
 		unsigned long nr_pages);
 extern int arch_create_linear_mapping(int nid, u64 start, u64 size,
 				      struct mhp_params *params);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index b7030bcd9b03e..a0e9cfe208da1 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -221,7 +221,7 @@ void put_online_mems(void)
 bool movable_node_enabled = false;
 
 static int mhp_default_online_type = -1;
-int mhp_get_default_online_type(void)
+enum mmop mhp_get_default_online_type(void)
 {
 	if (mhp_default_online_type >= 0)
 		return mhp_default_online_type;
@@ -240,7 +240,7 @@ int mhp_get_default_online_type(void)
 	return mhp_default_online_type;
 }
 
-void mhp_set_default_online_type(int online_type)
+void mhp_set_default_online_type(enum mmop online_type)
 {
 	mhp_default_online_type = online_type;
 }
@@ -1046,7 +1046,7 @@ static inline struct zone *default_zone_for_pfn(int nid, unsigned long start_pfn
 	return movable_node_enabled ? movable_zone : kernel_zone;
 }
 
-struct zone *zone_for_pfn_range(int online_type, int nid,
+struct zone *zone_for_pfn_range(enum mmop online_type, int nid,
 		struct memory_group *group, unsigned long start_pfn,
 		unsigned long nr_pages)
 {
@@ -2338,7 +2338,7 @@ EXPORT_SYMBOL_GPL(remove_memory);
 
 static int try_offline_memory_block(struct memory_block *mem, void *arg)
 {
-	uint8_t online_type = MMOP_ONLINE_KERNEL;
+	enum mmop online_type = MMOP_ONLINE_KERNEL;
 	uint8_t **online_types = arg;
 	struct page *page;
 	int rc;
@@ -2371,7 +2371,7 @@ static int try_reonline_memory_block(struct memory_block *mem, void *arg)
 	int rc;
 
 	if (**online_types != MMOP_OFFLINE) {
-		mem->online_type = **online_types;
+		mem->online_type = (enum mmop)**online_types;
 		rc = device_online(&mem->dev);
 		if (rc < 0)
 			pr_warn("%s: Failed to re-online memory: %d",
-- 
2.53.0



