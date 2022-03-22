Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E480E6453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:41:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A902AC340EC;
	Tue, 22 Mar 2022 21:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985260;
	bh=1//xFcecO7mK3EjNUbQzTa22CRQRRU9/xJu2uZX++mY=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=o4tP7Uo3TgYE6YsFCS5ii1Tmkb9eUqhwTeKkzK8C6thnqoyvsnwolM2KHKUAQ3GHZ
	 J2BAwDxgNUXiBdgWF3jm6Y35UenIHPZhtVTYOeF830jIL0Nm1/cJWkqFe7Z47SGUvq
	 WGKDLpfdNNiD8w5eDg9O5+aN6KUxXprnq8gXhwIw=
Date: Tue, 22 Mar 2022 14:41:00 -0700
To: zhengqi.arch@bytedance.com,willy@infradead.org,vdavydov.dev@gmail.com,vbabka@suse.cz,tytso@mit.edu,trond.myklebust@hammerspace.com,shy828301@gmail.com,shakeelb@google.com,roman.gushchin@linux.dev,richard.weiyang@gmail.com,mhocko@kernel.org,kari.argillander@gmail.com,jaegeuk@kernel.org,hannes@cmpxchg.org,fam.zheng@bytedance.com,duanxiongchun@bytedance.com,david@fromorbit.com,chao@kernel.org,Anna.Schumaker@Netapp.com,alexs@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 049/227] fs: introduce alloc_inode_sb() to allocate filesystems specific inode
Message-Id: <20220322214100.A902AC340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Muchun Song <songmuchun@bytedance.com>
Subject: fs: introduce alloc_inode_sb() to allocate filesystems specific inode

The allocated inode cache is supposed to be added to its memcg list_lru
which should be allocated as well in advance.  That can be done by
kmem_cache_alloc_lru() which allocates object and list_lru.  The file
systems is main user of it.  So introduce alloc_inode_sb() to allocate
file system specific inodes and set up the inode reclaim context properly.
The file system is supposed to use alloc_inode_sb() to allocate inodes. 
In the later patches, we will convert all users to the new API.

Link: https://lkml.kernel.org/r/20220228122126.37293-4-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Alex Shi <alexs@kernel.org>
Cc: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kari Argillander <kari.argillander@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/porting.rst |    6 ++++++
 fs/inode.c                            |    2 +-
 include/linux/fs.h                    |   11 +++++++++++
 3 files changed, 18 insertions(+), 1 deletion(-)

--- a/Documentation/filesystems/porting.rst~fs-introduce-alloc_inode_sb-to-allocate-filesystems-specific-inode
+++ a/Documentation/filesystems/porting.rst
@@ -45,6 +45,12 @@ typically between calling iget_locked()
 
 At some point that will become mandatory.
 
+**mandatory**
+
+The foo_inode_info should always be allocated through alloc_inode_sb() rather
+than kmem_cache_alloc() or kmalloc() related to set up the inode reclaim context
+correctly.
+
 ---
 
 **mandatory**
--- a/fs/inode.c~fs-introduce-alloc_inode_sb-to-allocate-filesystems-specific-inode
+++ a/fs/inode.c
@@ -259,7 +259,7 @@ static struct inode *alloc_inode(struct
 	if (ops->alloc_inode)
 		inode = ops->alloc_inode(sb);
 	else
-		inode = kmem_cache_alloc(inode_cachep, GFP_KERNEL);
+		inode = alloc_inode_sb(sb, inode_cachep, GFP_KERNEL);
 
 	if (!inode)
 		return NULL;
--- a/include/linux/fs.h~fs-introduce-alloc_inode_sb-to-allocate-filesystems-specific-inode
+++ a/include/linux/fs.h
@@ -42,6 +42,7 @@
 #include <linux/mount.h>
 #include <linux/cred.h>
 #include <linux/mnt_idmapping.h>
+#include <linux/slab.h>
 
 #include <asm/byteorder.h>
 #include <uapi/linux/fs.h>
@@ -3114,6 +3115,16 @@ extern void free_inode_nonrcu(struct ino
 extern int should_remove_suid(struct dentry *);
 extern int file_remove_privs(struct file *);
 
+/*
+ * This must be used for allocating filesystems specific inodes to set
+ * up the inode reclaim context correctly.
+ */
+static inline void *
+alloc_inode_sb(struct super_block *sb, struct kmem_cache *cache, gfp_t gfp)
+{
+	return kmem_cache_alloc_lru(cache, &sb->s_inode_lru, gfp);
+}
+
 extern void __insert_inode_hash(struct inode *, unsigned long hashval);
 static inline void insert_inode_hash(struct inode *inode)
 {
_
