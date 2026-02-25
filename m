Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9F327FD44;
	Wed, 25 Feb 2026 01:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983726; cv=none; b=ch8kA/+WviQ/2ryDB78JrGZGbyjcsvq0qGxzREODObzhB4XvrWRHanEu167cVII/Tu/Vj98itG11apnD641GlZtX1MjJtP/dhPIsNoTp19VuiNIPYT8EJHfgmgUw803yHrU7fvQthlt9UXjp2O6Y+yerrE7oBgwHMtGaSEQzcPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983726; c=relaxed/simple;
	bh=/YpiUaLYefOGA7IyauUn1DBgHuWkdglSihNsqV3OoIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6jXNmOIFTjxdI+gNc7K3qM8CdWwpZAwlunTVXOfe02i1Vzh8LrzYxDQQkYeW+Wh/WRrnZM7oPLZa3nYhWQNrKd1cq7SSaBzOsKJZbGR+Y6jWoSKyeWlofTB9CCQj1IV/i/EX5DOkoUPihitWKEqwlH3eT5Wjqn1VGqIyfqC65E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dfkvjK2R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dfkvjK2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 195D0C2BC86;
	Wed, 25 Feb 2026 01:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983726;
	bh=/YpiUaLYefOGA7IyauUn1DBgHuWkdglSihNsqV3OoIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dfkvjK2RLPF6Tp46mY1jYuPtZ/3Tb/5xQKlBpQ35qHoz2mzPmA4dIjRCKZomLAEk7
	 qiZ68L5/KnOS5sehULQLg1254vqf1UoPvTfSzIhNv2Ip2uFy0tHd/XnrVabPrfSu5y
	 F0ef6ftQ5khGOrXpXH+lw+w3SD7lgIVxWNC66r5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 022/641] btrfs: headers cleanup to remove unnecessary local includes
Date: Tue, 24 Feb 2026 17:15:48 -0800
Message-ID: <20260225012349.513732615@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit c5667f9c8eb90293dfa4e52c65eb89fe39f5652d ]

[BUG]
When I tried to remove btrfs_bio::fs_info and use btrfs_bio::inode to
grab the fs_info, the header "btrfs_inode.h" is needed to access the
full btrfs_inode structure.

Then btrfs will fail to compile.

[CAUSE]
There is a recursive including chain:

  "bio.h" -> "btrfs_inode.h" -> "extent_map.h" -> "compression.h" ->
  "bio.h"

That recursive including is causing problems for btrfs.

[ENHANCEMENT]
To reduce the risk of recursive including:

- Remove unnecessary local includes from btrfs headers
  Either the included header is pulled in by other headers, or is
  completely unnecessary.

- Remove btrfs local includes if the header only requires a pointer
  In that case let the implementing C file to pull the required header.

  This is especially important for headers like "btrfs_inode.h" which
  pulls in a lot of other btrfs headers, thus it's a mine field of
  recursive including.

- Remove unnecessary temporary structure definition
  Either if we have included the header defining the structure, or
  completely unused.

Now including "btrfs_inode.h" inside "bio.h" is completely fine,
although "btrfs_inode.h" still includes "extent_map.h", but that header
only includes "fs.h", no more chain back to "bio.h".

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: b39b26e017c7 ("btrfs: zoned: don't zone append to conventional zone")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/accessors.h   | 1 +
 fs/btrfs/btrfs_inode.h | 8 ++++----
 fs/btrfs/compression.h | 3 ---
 fs/btrfs/ctree.h       | 2 --
 fs/btrfs/defrag.c      | 1 +
 fs/btrfs/dir-item.c    | 1 +
 fs/btrfs/direct-io.c   | 2 ++
 fs/btrfs/disk-io.c     | 1 +
 fs/btrfs/disk-io.h     | 3 ++-
 fs/btrfs/extent-tree.c | 1 +
 fs/btrfs/extent_io.h   | 1 -
 fs/btrfs/extent_map.h  | 3 +--
 fs/btrfs/file-item.h   | 2 +-
 fs/btrfs/inode.c       | 1 +
 fs/btrfs/space-info.c  | 1 +
 fs/btrfs/subpage.h     | 1 -
 fs/btrfs/transaction.c | 2 ++
 fs/btrfs/transaction.h | 4 ----
 fs/btrfs/tree-log.c    | 1 +
 fs/btrfs/tree-log.h    | 3 +--
 fs/btrfs/zoned.h       | 1 -
 21 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/accessors.h b/fs/btrfs/accessors.h
index 99b3ced12805b..78721412951c5 100644
--- a/fs/btrfs/accessors.h
+++ b/fs/btrfs/accessors.h
@@ -12,6 +12,7 @@
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <uapi/linux/btrfs_tree.h>
+#include "fs.h"
 #include "extent_io.h"
 
 struct extent_buffer;
diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index af373d50a901f..a66ca5531b5c5 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -18,20 +18,20 @@
 #include <linux/lockdep.h>
 #include <uapi/linux/btrfs_tree.h>
 #include <trace/events/btrfs.h>
+#include "ctree.h"
 #include "block-rsv.h"
 #include "extent_map.h"
-#include "extent_io.h"
 #include "extent-io-tree.h"
-#include "ordered-data.h"
-#include "delayed-inode.h"
 
-struct extent_state;
 struct posix_acl;
 struct iov_iter;
 struct writeback_control;
 struct btrfs_root;
 struct btrfs_fs_info;
 struct btrfs_trans_handle;
+struct btrfs_bio;
+struct btrfs_file_extent;
+struct btrfs_delayed_node;
 
 /*
  * Since we search a directory based on f_pos (struct dir_context::pos) we have
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index eba188a9e3bb5..c6812d5fcab79 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -14,14 +14,11 @@
 #include <linux/pagemap.h>
 #include "bio.h"
 #include "fs.h"
-#include "messages.h"
 
 struct address_space;
-struct page;
 struct inode;
 struct btrfs_inode;
 struct btrfs_ordered_extent;
-struct btrfs_bio;
 
 /*
  * We want to make sure that amount of RAM required to uncompress an extent is
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index fe70b593c7cd9..16dd11c485313 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -17,9 +17,7 @@
 #include <linux/refcount.h>
 #include <uapi/linux/btrfs_tree.h>
 #include "locking.h"
-#include "fs.h"
 #include "accessors.h"
-#include "extent-io-tree.h"
 
 struct extent_buffer;
 struct btrfs_block_rsv;
diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index 7b277934f66f9..a4cc1bc635622 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -15,6 +15,7 @@
 #include "defrag.h"
 #include "file-item.h"
 #include "super.h"
+#include "compression.h"
 
 static struct kmem_cache *btrfs_inode_defrag_cachep;
 
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 69863e398e223..77e1bcb2a74bf 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -9,6 +9,7 @@
 #include "transaction.h"
 #include "accessors.h"
 #include "dir-item.h"
+#include "delayed-inode.h"
 
 /*
  * insert a name into a directory, doing overflow properly if there is a hash
diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 802d4dbe5b381..8888ef4ae6064 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -10,6 +10,8 @@
 #include "fs.h"
 #include "transaction.h"
 #include "volumes.h"
+#include "bio.h"
+#include "ordered-data.h"
 
 struct btrfs_dio_data {
 	ssize_t submitted;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 745ae698bbc8a..3fd5d6a27d4c0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -50,6 +50,7 @@
 #include "relocation.h"
 #include "scrub.h"
 #include "super.h"
+#include "delayed-inode.h"
 
 #define BTRFS_SUPER_FLAG_SUPP	(BTRFS_HEADER_FLAG_WRITTEN |\
 				 BTRFS_HEADER_FLAG_RELOC |\
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 57920f2c6fe4e..5320da83d0cf8 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -9,7 +9,8 @@
 #include <linux/sizes.h>
 #include <linux/compiler_types.h>
 #include "ctree.h"
-#include "fs.h"
+#include "bio.h"
+#include "ordered-data.h"
 
 struct block_device;
 struct super_block;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index dc4ca98c37800..01337e3f2879c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -40,6 +40,7 @@
 #include "orphan.h"
 #include "tree-checker.h"
 #include "raid-stripe-tree.h"
+#include "delayed-inode.h"
 
 #undef SCRAMBLE_DELAYED_REFS
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 559bec44a7a8e..73571d5d3d5ad 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -12,7 +12,6 @@
 #include <linux/rwsem.h>
 #include <linux/list.h>
 #include <linux/slab.h>
-#include "compression.h"
 #include "messages.h"
 #include "ulist.h"
 #include "misc.h"
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index d4b81ee4d97bd..6f685f3c93272 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -8,8 +8,7 @@
 #include <linux/rbtree.h>
 #include <linux/list.h>
 #include <linux/refcount.h>
-#include "misc.h"
-#include "compression.h"
+#include "fs.h"
 
 struct btrfs_inode;
 struct btrfs_fs_info;
diff --git a/fs/btrfs/file-item.h b/fs/btrfs/file-item.h
index 63216c43676de..0d59e830018a6 100644
--- a/fs/btrfs/file-item.h
+++ b/fs/btrfs/file-item.h
@@ -7,7 +7,7 @@
 #include <linux/list.h>
 #include <uapi/linux/btrfs_tree.h>
 #include "ctree.h"
-#include "accessors.h"
+#include "ordered-data.h"
 
 struct extent_map;
 struct btrfs_file_extent_item;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 76a66c74249a2..b261dbeb29040 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -71,6 +71,7 @@
 #include "backref.h"
 #include "raid-stripe-tree.h"
 #include "fiemap.h"
+#include "delayed-inode.h"
 
 #define COW_FILE_RANGE_KEEP_LOCKED	(1UL << 0)
 #define COW_FILE_RANGE_NO_INLINE	(1UL << 1)
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index a6f94e9f55915..e5c18a29eb7e6 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -15,6 +15,7 @@
 #include "accessors.h"
 #include "extent-tree.h"
 #include "zoned.h"
+#include "delayed-inode.h"
 
 /*
  * HOW DOES SPACE RESERVATION WORK
diff --git a/fs/btrfs/subpage.h b/fs/btrfs/subpage.h
index ad0552db7c7dc..d81a0ade559fd 100644
--- a/fs/btrfs/subpage.h
+++ b/fs/btrfs/subpage.h
@@ -7,7 +7,6 @@
 #include <linux/atomic.h>
 #include <linux/sizes.h>
 #include "btrfs_inode.h"
-#include "fs.h"
 
 struct address_space;
 struct folio;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index c457316c2788b..041f4781956cf 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -32,6 +32,8 @@
 #include "ioctl.h"
 #include "relocation.h"
 #include "scrub.h"
+#include "ordered-data.h"
+#include "delayed-inode.h"
 
 static struct kmem_cache *btrfs_trans_handle_cachep;
 
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 9f7c777af6356..18ef069197e5b 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -14,10 +14,6 @@
 #include <linux/wait.h>
 #include "btrfs_inode.h"
 #include "delayed-ref.h"
-#include "extent-io-tree.h"
-#include "block-rsv.h"
-#include "messages.h"
-#include "misc.h"
 
 struct dentry;
 struct inode;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index ae2e035d013e2..6c5db73c3e85f 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -29,6 +29,7 @@
 #include "orphan.h"
 #include "print-tree.h"
 #include "tree-checker.h"
+#include "delayed-inode.h"
 
 #define MAX_CONFLICT_INODES 10
 
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index dc313e6bb2faa..4f149d7d4fdee 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -8,8 +8,7 @@
 
 #include <linux/list.h>
 #include <linux/fs.h>
-#include "messages.h"
-#include "ctree.h"
+#include <linux/fscrypt.h>
 #include "transaction.h"
 
 struct inode;
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 17c5656580dd9..2b807a02d1a8a 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -15,7 +15,6 @@
 #include "disk-io.h"
 #include "block-group.h"
 #include "btrfs_inode.h"
-#include "fs.h"
 
 struct block_device;
 struct extent_buffer;
-- 
2.51.0



