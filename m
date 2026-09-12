Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F9841A575;
	Sat, 12 Sep 2026 12:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214930; cv=none; b=IxZjm9531Po4RUoT84kpTY49xOA7zDRLmP/LCb9BqJpGdwuKV6cg5ZyihwDw7miPjit3EMaCUkX2/NDRlBUNcgUgDpr5FddpjXqIfIaoPDPmw3acCXs0AJ/3P/dbpTiGBee5Y+lTR0wrBkz47Q7VJIX+8ijEV/qJzPii+F1StKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214930; c=relaxed/simple;
	bh=5S8omyryFmOC2mEUVFHng0SlSWsd20+dEdIjzaRquHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPc1Kh3GIPP2q6zjQcLaYQbOIOE/dWgA3bEvbVacggwSQpwHk08jzl786aTvXLqEU144b+8HMMf3wjd3ZZShodkgRVb1LZVJ16bjnqNrDG9S2N79Wpa+pRvQz0kdOUGNsF3Q0u3TPedoWc18XxnmgYmhZqHKC/hfJR6lQvMfQh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6aOX2Pj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6aOX2Pj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7C41F000FF;
	Sat, 12 Sep 2026 12:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214928;
	bh=NQ38Uv9MfGZP3vRr9Dvde5RvsHnWYRIINxzy77zJOGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I6aOX2PjrmKjlA7B2iPuzxShSBB4fUblHqKNbPyhMiVyS8X0aUH0vKk+hk4K7AM3Y
	 3oXkW116KU2cVhYa+LAeFoY3Fnuf8oGNNB4ewYBC3mwBqn3tANOOIyiaJUB81swf7r
	 NiKeZa2je3FB2YxZgpZ7bq2Z3d17b18klxH4QNi0=
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
Subject: [PATCH 6.12 0384/1376] mm: name the anonymous MMOP enum as enum mmop
Date: Sat, 12 Sep 2026 08:46:50 +0200
Message-ID: <20260912065616.105565373@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cd1e6e15bb719..889e653781453 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -435,7 +435,7 @@ static ssize_t phys_device_show(struct device *dev,
 static int print_allowed_zone(char *buf, int len, int nid,
 			      struct memory_group *group,
 			      unsigned long start_pfn, unsigned long nr_pages,
-			      int online_type, struct zone *default_zone)
+			      enum mmop online_type, struct zone *default_zone)
 {
 	struct zone *zone;
 
diff --git a/include/linux/memory.h b/include/linux/memory.h
index a334f1382b21d..f6109556ed105 100644
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
index 0cbf14756d129..1b6b9ed7887db 100644
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
 
@@ -303,8 +303,8 @@ static inline void __remove_memory(u64 start, u64 size) {}
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 /* Default online_type (MMOP_*) when new memory blocks are added. */
-extern int mhp_get_default_online_type(void);
-extern void mhp_set_default_online_type(int online_type);
+extern enum mmop mhp_get_default_online_type(void);
+extern void mhp_set_default_online_type(enum mmop online_type);
 extern void __ref free_area_init_core_hotplug(struct pglist_data *pgdat);
 extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
 extern int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
@@ -327,8 +327,8 @@ extern void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
 				  struct dev_pagemap *pgmap);
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
index 6426be4d82995..4d764f4ec213b 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -220,7 +220,7 @@ void put_online_mems(void)
 bool movable_node_enabled = false;
 
 static int mhp_default_online_type = -1;
-int mhp_get_default_online_type(void)
+enum mmop mhp_get_default_online_type(void)
 {
 	if (mhp_default_online_type >= 0)
 		return mhp_default_online_type;
@@ -239,7 +239,7 @@ int mhp_get_default_online_type(void)
 	return mhp_default_online_type;
 }
 
-void mhp_set_default_online_type(int online_type)
+void mhp_set_default_online_type(enum mmop online_type)
 {
 	mhp_default_online_type = online_type;
 }
@@ -1060,7 +1060,7 @@ static inline struct zone *default_zone_for_pfn(int nid, unsigned long start_pfn
 	return movable_node_enabled ? movable_zone : kernel_zone;
 }
 
-struct zone *zone_for_pfn_range(int online_type, int nid,
+struct zone *zone_for_pfn_range(enum mmop online_type, int nid,
 		struct memory_group *group, unsigned long start_pfn,
 		unsigned long nr_pages)
 {
@@ -2349,7 +2349,7 @@ EXPORT_SYMBOL_GPL(remove_memory);
 
 static int try_offline_memory_block(struct memory_block *mem, void *arg)
 {
-	uint8_t online_type = MMOP_ONLINE_KERNEL;
+	enum mmop online_type = MMOP_ONLINE_KERNEL;
 	uint8_t **online_types = arg;
 	struct page *page;
 	int rc;
@@ -2382,7 +2382,7 @@ static int try_reonline_memory_block(struct memory_block *mem, void *arg)
 	int rc;
 
 	if (**online_types != MMOP_OFFLINE) {
-		mem->online_type = **online_types;
+		mem->online_type = (enum mmop)**online_types;
 		rc = device_online(&mem->dev);
 		if (rc < 0)
 			pr_warn("%s: Failed to re-online memory: %d",
-- 
2.53.0



