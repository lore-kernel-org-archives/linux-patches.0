Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40BE386C3D;
	Sat, 17 Oct 2026 18:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260346; cv=none; b=cDto+tKT/PVNisQ8MugZzdd73MiTU0qqJW6Z4wTaAfSOSndRZWbKtKjiby/FLucR2ABaySHMEla73SrSJoe39wn24fjjMGD8twSK23apyIk14R/xCAWFAarFLTPwS4Q/JhlS0iix6q5VuL56B0n1esmqo/sfwTugyJvokGFU+ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260346; c=relaxed/simple;
	bh=AlLOyW0d3lnfD14UHsqaXP+PJkIeVz2D2cUNKxtTuRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwPN6GVgw69cH9OzvEcsMijoGpdG5639Ny41DNdZ96yHbXtnwId/iR81wDjcqjkoS4HL/mVIpiOAYUOXpOWO6TBhnCF1DwS7TIm/dj6Bh+S+BXfKHxJhmn6MW71Dy2McUv6HTskhUH3OM4qsO5L3qCoHP6gr7BrUuZVVBtspaVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mk6E2KzD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mk6E2KzD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74C01F000C4;
	Sat, 17 Oct 2026 18:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260344;
	bh=/ZkLH+C/ryPTWlTnHgQbYr0iHzH12yM6vCuN9qUEaOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mk6E2KzDxdMLETa9gIcATPefOKOeFUDyMnmwwu8wBsYEKzsrS1xzJ8p8G1sdvsrWP
	 +ACyBTJWAdLkDLcLxLzlV0WHzSRCRxN/fTna0kboc2++i+IQQpFGmM3R3iHCUliaX6
	 W5jkZGV7B34EZATtcGa7HoxQTssqraPVWHMmG/jY=
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
Subject: [PATCH 6.6 1497/1674] mm: name the anonymous MMOP enum as enum mmop
Date: Sat, 17 Oct 2026 18:02:49 +0200
Message-ID: <20261017160509.565478381@linuxfoundation.org>
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

Adapt to this tree: the preceding change in struct memory_block already
uses enum memory_block_state, which does not exist here, so define it
in memory.h with the existing MEM_* values in place of the macros. Drop
the mhp_get/set_default_online_type hunks, which have no counterpart
here, and keep the enum definition ahead of the CONFIG_MEMORY_HOTPLUG
guard so it is always available to struct memory_block.

Stable-dep-of: 2ebce860bdd7 ("mm/mm_init: handle alloc_percpu failure in free_area_init_core_hotplug")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/memory.c          |  2 +-
 include/linux/memory.h         | 21 ++++++++++++---------
 include/linux/memory_hotplug.h | 12 ++++++------
 mm/memory_hotplug.c            |  6 +++---
 4 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 2858a2165d960..b92690a8e2b48 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -414,7 +414,7 @@ static ssize_t phys_device_show(struct device *dev,
 static int print_allowed_zone(char *buf, int len, int nid,
 			      struct memory_group *group,
 			      unsigned long start_pfn, unsigned long nr_pages,
-			      int online_type, struct zone *default_zone)
+			      enum mmop online_type, struct zone *default_zone)
 {
 	struct zone *zone;
 
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 1028d42406cce..11dbf013b0993 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -19,6 +19,7 @@
 #include <linux/node.h>
 #include <linux/compiler.h>
 #include <linux/mutex.h>
+#include <linux/memory_hotplug.h>
 
 #define MIN_MEMORY_BLOCK_SIZE     (1UL << SECTION_SIZE_BITS)
 
@@ -64,10 +65,20 @@ struct memory_group {
 	};
 };
 
+enum memory_block_state {
+	/* These states are exposed to userspace as text strings in sysfs */
+	MEM_ONLINE		= (1<<0), /* exposed to userspace */
+	MEM_GOING_OFFLINE	= (1<<1), /* exposed to userspace */
+	MEM_OFFLINE		= (1<<2), /* exposed to userspace */
+	MEM_GOING_ONLINE	= (1<<3),
+	MEM_CANCEL_ONLINE	= (1<<4),
+	MEM_CANCEL_OFFLINE	= (1<<5),
+};
+
 struct memory_block {
 	unsigned long start_section_nr;
 	enum memory_block_state state;	/* serialized by the dev->lock */
-	int online_type;		/* for passing data to online routine */
+	enum mmop online_type;	/* for passing data to online routine */
 	int nid;			/* NID for this memory block */
 	/*
 	 * The single zone of this memory block if all PFNs of this memory block
@@ -89,14 +100,6 @@ int arch_get_memory_phys_device(unsigned long start_pfn);
 unsigned long memory_block_size_bytes(void);
 int set_memory_block_size_order(unsigned int order);
 
-/* These states are exposed to userspace as text strings in sysfs */
-#define	MEM_ONLINE		(1<<0) /* exposed to userspace */
-#define	MEM_GOING_OFFLINE	(1<<1) /* exposed to userspace */
-#define	MEM_OFFLINE		(1<<2) /* exposed to userspace */
-#define	MEM_GOING_ONLINE	(1<<3)
-#define	MEM_CANCEL_ONLINE	(1<<4)
-#define	MEM_CANCEL_OFFLINE	(1<<5)
-
 struct memory_notify {
 	unsigned long start_pfn;
 	unsigned long nr_pages;
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 7d20765834941..3777d10038c52 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -64,11 +64,8 @@ static inline void arch_refresh_nodedata(int nid, pg_data_t *pgdat)
 #endif /* CONFIG_NUMA */
 #endif /* CONFIG_HAVE_ARCH_NODEDATA_EXTENSION */
 
-#ifdef CONFIG_MEMORY_HOTPLUG
-struct page *pfn_to_online_page(unsigned long pfn);
-
 /* Types for control the zone type of onlined and offlined memory */
-enum {
+enum mmop {
 	/* Offline the memory. */
 	MMOP_OFFLINE = 0,
 	/* Online the memory. Zone depends, see default_zone_for_pfn(). */
@@ -79,6 +76,9 @@ enum {
 	MMOP_ONLINE_MOVABLE,
 };
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+struct page *pfn_to_online_page(unsigned long pfn);
+
 /* Flags for add_memory() and friends to specify memory hotplug details. */
 typedef int __bitwise mhp_t;
 
@@ -350,8 +350,8 @@ extern void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
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
index 4498855daed8f..349e34b924af6 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1044,7 +1044,7 @@ static inline struct zone *default_zone_for_pfn(int nid, unsigned long start_pfn
 	return movable_node_enabled ? movable_zone : kernel_zone;
 }
 
-struct zone *zone_for_pfn_range(int online_type, int nid,
+struct zone *zone_for_pfn_range(enum mmop online_type, int nid,
 		struct memory_group *group, unsigned long start_pfn,
 		unsigned long nr_pages)
 {
@@ -2267,7 +2267,7 @@ EXPORT_SYMBOL_GPL(remove_memory);
 
 static int try_offline_memory_block(struct memory_block *mem, void *arg)
 {
-	uint8_t online_type = MMOP_ONLINE_KERNEL;
+	enum mmop online_type = MMOP_ONLINE_KERNEL;
 	uint8_t **online_types = arg;
 	struct page *page;
 	int rc;
@@ -2300,7 +2300,7 @@ static int try_reonline_memory_block(struct memory_block *mem, void *arg)
 	int rc;
 
 	if (**online_types != MMOP_OFFLINE) {
-		mem->online_type = **online_types;
+		mem->online_type = (enum mmop)**online_types;
 		rc = device_online(&mem->dev);
 		if (rc < 0)
 			pr_warn("%s: Failed to re-online memory: %d",
-- 
2.53.0



