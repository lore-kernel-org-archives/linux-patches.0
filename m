Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A662B8F40
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9F8C433C7;
	Sun, 16 Jul 2023 20:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539464;
	bh=YPTWu21ZpgPv2dPsqNu6vVE6vK9C54r2v9t9VsV/j+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ndaxZRY7BwzD94OwhEnaf76KSwFHA7gm+26ibKVmPgSjNcG3NmRoHKIHvB5HUIqd
	 iyEDmsatS0I8Qb67Meu3G4YP8r2EnIdwKkW1ojRQvUkXKBx/IW1An009Zn/7QACC2T
	 TRFA4rrEIWc41CUZKSPxlYJBKujnM8aYcECqfuW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Hu <huyue2@coolpad.com>,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/591] erofs: move zdata.h into zdata.c
Date: Sun, 16 Jul 2023 21:42:26 +0200
Message-ID: <20230716194924.053446521@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit a9a94d9373349e1a53f149d2015eb6f03a8517cf ]

Definitions in zdata.h are only used in zdata.c and for internal
use only.  No logic changes.

Reviewed-by: Yue Hu <huyue2@coolpad.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20230204093040.97967-4-hsiangkao@linux.alibaba.com
Stable-dep-of: 967c28b23f6c ("erofs: kill hooked chains to avoid loops on deduplicated compressed images")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 166 +++++++++++++++++++++++++++++++++++++++++++-
 fs/erofs/zdata.h | 177 -----------------------------------------------
 2 files changed, 165 insertions(+), 178 deletions(-)
 delete mode 100644 fs/erofs/zdata.h

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 3b5f73224c22a..aaddb6781465e 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -4,13 +4,177 @@
  *             https://www.huawei.com/
  * Copyright (C) 2022 Alibaba Cloud
  */
-#include "zdata.h"
 #include "compress.h"
 #include <linux/prefetch.h>
 #include <linux/psi.h>
 
 #include <trace/events/erofs.h>
 
+#define Z_EROFS_PCLUSTER_MAX_PAGES	(Z_EROFS_PCLUSTER_MAX_SIZE / PAGE_SIZE)
+#define Z_EROFS_INLINE_BVECS		2
+
+/*
+ * let's leave a type here in case of introducing
+ * another tagged pointer later.
+ */
+typedef void *z_erofs_next_pcluster_t;
+
+struct z_erofs_bvec {
+	struct page *page;
+	int offset;
+	unsigned int end;
+};
+
+#define __Z_EROFS_BVSET(name, total) \
+struct name { \
+	/* point to the next page which contains the following bvecs */ \
+	struct page *nextpage; \
+	struct z_erofs_bvec bvec[total]; \
+}
+__Z_EROFS_BVSET(z_erofs_bvset,);
+__Z_EROFS_BVSET(z_erofs_bvset_inline, Z_EROFS_INLINE_BVECS);
+
+/*
+ * Structure fields follow one of the following exclusion rules.
+ *
+ * I: Modifiable by initialization/destruction paths and read-only
+ *    for everyone else;
+ *
+ * L: Field should be protected by the pcluster lock;
+ *
+ * A: Field should be accessed / updated in atomic for parallelized code.
+ */
+struct z_erofs_pcluster {
+	struct erofs_workgroup obj;
+	struct mutex lock;
+
+	/* A: point to next chained pcluster or TAILs */
+	z_erofs_next_pcluster_t next;
+
+	/* L: the maximum decompression size of this round */
+	unsigned int length;
+
+	/* L: total number of bvecs */
+	unsigned int vcnt;
+
+	/* I: page offset of start position of decompression */
+	unsigned short pageofs_out;
+
+	/* I: page offset of inline compressed data */
+	unsigned short pageofs_in;
+
+	union {
+		/* L: inline a certain number of bvec for bootstrap */
+		struct z_erofs_bvset_inline bvset;
+
+		/* I: can be used to free the pcluster by RCU. */
+		struct rcu_head rcu;
+	};
+
+	union {
+		/* I: physical cluster size in pages */
+		unsigned short pclusterpages;
+
+		/* I: tailpacking inline compressed size */
+		unsigned short tailpacking_size;
+	};
+
+	/* I: compression algorithm format */
+	unsigned char algorithmformat;
+
+	/* L: whether partial decompression or not */
+	bool partial;
+
+	/* L: indicate several pageofs_outs or not */
+	bool multibases;
+
+	/* A: compressed bvecs (can be cached or inplaced pages) */
+	struct z_erofs_bvec compressed_bvecs[];
+};
+
+/* let's avoid the valid 32-bit kernel addresses */
+
+/* the chained workgroup has't submitted io (still open) */
+#define Z_EROFS_PCLUSTER_TAIL           ((void *)0x5F0ECAFE)
+/* the chained workgroup has already submitted io */
+#define Z_EROFS_PCLUSTER_TAIL_CLOSED    ((void *)0x5F0EDEAD)
+
+#define Z_EROFS_PCLUSTER_NIL            (NULL)
+
+struct z_erofs_decompressqueue {
+	struct super_block *sb;
+	atomic_t pending_bios;
+	z_erofs_next_pcluster_t head;
+
+	union {
+		struct completion done;
+		struct work_struct work;
+	} u;
+	bool eio, sync;
+};
+
+static inline bool z_erofs_is_inline_pcluster(struct z_erofs_pcluster *pcl)
+{
+	return !pcl->obj.index;
+}
+
+static inline unsigned int z_erofs_pclusterpages(struct z_erofs_pcluster *pcl)
+{
+	if (z_erofs_is_inline_pcluster(pcl))
+		return 1;
+	return pcl->pclusterpages;
+}
+
+/*
+ * bit 30: I/O error occurred on this page
+ * bit 0 - 29: remaining parts to complete this page
+ */
+#define Z_EROFS_PAGE_EIO			(1 << 30)
+
+static inline void z_erofs_onlinepage_init(struct page *page)
+{
+	union {
+		atomic_t o;
+		unsigned long v;
+	} u = { .o = ATOMIC_INIT(1) };
+
+	set_page_private(page, u.v);
+	smp_wmb();
+	SetPagePrivate(page);
+}
+
+static inline void z_erofs_onlinepage_split(struct page *page)
+{
+	atomic_inc((atomic_t *)&page->private);
+}
+
+static inline void z_erofs_page_mark_eio(struct page *page)
+{
+	int orig;
+
+	do {
+		orig = atomic_read((atomic_t *)&page->private);
+	} while (atomic_cmpxchg((atomic_t *)&page->private, orig,
+				orig | Z_EROFS_PAGE_EIO) != orig);
+}
+
+static inline void z_erofs_onlinepage_endio(struct page *page)
+{
+	unsigned int v;
+
+	DBG_BUGON(!PagePrivate(page));
+	v = atomic_dec_return((atomic_t *)&page->private);
+	if (!(v & ~Z_EROFS_PAGE_EIO)) {
+		set_page_private(page, 0);
+		ClearPagePrivate(page);
+		if (!(v & Z_EROFS_PAGE_EIO))
+			SetPageUptodate(page);
+		unlock_page(page);
+	}
+}
+
+#define Z_EROFS_ONSTACK_PAGES		32
+
 /*
  * since pclustersize is variable for big pcluster feature, introduce slab
  * pools implementation for different pcluster sizes.
diff --git a/fs/erofs/zdata.h b/fs/erofs/zdata.h
deleted file mode 100644
index f196a729c7e85..0000000000000
--- a/fs/erofs/zdata.h
+++ /dev/null
@@ -1,177 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright (C) 2018 HUAWEI, Inc.
- *             https://www.huawei.com/
- */
-#ifndef __EROFS_FS_ZDATA_H
-#define __EROFS_FS_ZDATA_H
-
-#include "internal.h"
-
-#define Z_EROFS_PCLUSTER_MAX_PAGES	(Z_EROFS_PCLUSTER_MAX_SIZE / PAGE_SIZE)
-#define Z_EROFS_INLINE_BVECS		2
-
-/*
- * let's leave a type here in case of introducing
- * another tagged pointer later.
- */
-typedef void *z_erofs_next_pcluster_t;
-
-struct z_erofs_bvec {
-	struct page *page;
-	int offset;
-	unsigned int end;
-};
-
-#define __Z_EROFS_BVSET(name, total) \
-struct name { \
-	/* point to the next page which contains the following bvecs */ \
-	struct page *nextpage; \
-	struct z_erofs_bvec bvec[total]; \
-}
-__Z_EROFS_BVSET(z_erofs_bvset,);
-__Z_EROFS_BVSET(z_erofs_bvset_inline, Z_EROFS_INLINE_BVECS);
-
-/*
- * Structure fields follow one of the following exclusion rules.
- *
- * I: Modifiable by initialization/destruction paths and read-only
- *    for everyone else;
- *
- * L: Field should be protected by the pcluster lock;
- *
- * A: Field should be accessed / updated in atomic for parallelized code.
- */
-struct z_erofs_pcluster {
-	struct erofs_workgroup obj;
-	struct mutex lock;
-
-	/* A: point to next chained pcluster or TAILs */
-	z_erofs_next_pcluster_t next;
-
-	/* L: the maximum decompression size of this round */
-	unsigned int length;
-
-	/* L: total number of bvecs */
-	unsigned int vcnt;
-
-	/* I: page offset of start position of decompression */
-	unsigned short pageofs_out;
-
-	/* I: page offset of inline compressed data */
-	unsigned short pageofs_in;
-
-	union {
-		/* L: inline a certain number of bvec for bootstrap */
-		struct z_erofs_bvset_inline bvset;
-
-		/* I: can be used to free the pcluster by RCU. */
-		struct rcu_head rcu;
-	};
-
-	union {
-		/* I: physical cluster size in pages */
-		unsigned short pclusterpages;
-
-		/* I: tailpacking inline compressed size */
-		unsigned short tailpacking_size;
-	};
-
-	/* I: compression algorithm format */
-	unsigned char algorithmformat;
-
-	/* L: whether partial decompression or not */
-	bool partial;
-
-	/* L: indicate several pageofs_outs or not */
-	bool multibases;
-
-	/* A: compressed bvecs (can be cached or inplaced pages) */
-	struct z_erofs_bvec compressed_bvecs[];
-};
-
-/* let's avoid the valid 32-bit kernel addresses */
-
-/* the chained workgroup has't submitted io (still open) */
-#define Z_EROFS_PCLUSTER_TAIL           ((void *)0x5F0ECAFE)
-/* the chained workgroup has already submitted io */
-#define Z_EROFS_PCLUSTER_TAIL_CLOSED    ((void *)0x5F0EDEAD)
-
-#define Z_EROFS_PCLUSTER_NIL            (NULL)
-
-struct z_erofs_decompressqueue {
-	struct super_block *sb;
-	atomic_t pending_bios;
-	z_erofs_next_pcluster_t head;
-
-	union {
-		struct completion done;
-		struct work_struct work;
-	} u;
-
-	bool eio, sync;
-};
-
-static inline bool z_erofs_is_inline_pcluster(struct z_erofs_pcluster *pcl)
-{
-	return !pcl->obj.index;
-}
-
-static inline unsigned int z_erofs_pclusterpages(struct z_erofs_pcluster *pcl)
-{
-	if (z_erofs_is_inline_pcluster(pcl))
-		return 1;
-	return pcl->pclusterpages;
-}
-
-/*
- * bit 30: I/O error occurred on this page
- * bit 0 - 29: remaining parts to complete this page
- */
-#define Z_EROFS_PAGE_EIO			(1 << 30)
-
-static inline void z_erofs_onlinepage_init(struct page *page)
-{
-	union {
-		atomic_t o;
-		unsigned long v;
-	} u = { .o = ATOMIC_INIT(1) };
-
-	set_page_private(page, u.v);
-	smp_wmb();
-	SetPagePrivate(page);
-}
-
-static inline void z_erofs_onlinepage_split(struct page *page)
-{
-	atomic_inc((atomic_t *)&page->private);
-}
-
-static inline void z_erofs_page_mark_eio(struct page *page)
-{
-	int orig;
-
-	do {
-		orig = atomic_read((atomic_t *)&page->private);
-	} while (atomic_cmpxchg((atomic_t *)&page->private, orig,
-				orig | Z_EROFS_PAGE_EIO) != orig);
-}
-
-static inline void z_erofs_onlinepage_endio(struct page *page)
-{
-	unsigned int v;
-
-	DBG_BUGON(!PagePrivate(page));
-	v = atomic_dec_return((atomic_t *)&page->private);
-	if (!(v & ~Z_EROFS_PAGE_EIO)) {
-		set_page_private(page, 0);
-		ClearPagePrivate(page);
-		if (!(v & Z_EROFS_PAGE_EIO))
-			SetPageUptodate(page);
-		unlock_page(page);
-	}
-}
-
-#define Z_EROFS_ONSTACK_PAGES		32
-
-#endif
-- 
2.39.2



