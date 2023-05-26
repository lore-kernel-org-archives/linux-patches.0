Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0321CAD27
	for <patches@lists.linux.dev>; Fri, 26 May 2023 07:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YxL6e+4JH9PE9rFUlxHs00PcCr+DpK00UKDT/LTPvSQ=; b=Kg2LU+nCS6V/WHsqu4Zv73IGyh
	2nlfdecqYINfvpx4snQrDk/Ga8HLc6qjEXZHKcFttUQa0Y65BUtUR8e+TmZmO6URv5/RN8bEUsQ/j
	iVw45tdhtJhhQndIluIWdstGdaR+9nsXfvAtKQ1CeTUYBs4ztqd8vRK0IhC4ppv0agrsQsa34+qcK
	CjlttKCbB7H76wb16hV44vAVBPFyLRn9vqDiqklO6qjnGGh0vDSiN6Ww0sOPKz4N5DRihdbEA8IGA
	sd9KbZHM2C2FS8qRAa3UYD1HTQlEnOFaMi/2JTLsghE4DfJfxxQqGPgyrb+ljsHjBbVeaWPxQqQ6P
	ETKUWerA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1q2SIj-001WZr-2s;
	Fri, 26 May 2023 07:55:53 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: hughd@google.com,
	akpm@linux-foundation.org,
	willy@infradead.org,
	brauner@kernel.org,
	djwong@kernel.org
Cc: p.raghav@samsung.com,
	da.gomez@samsung.com,
	rohan.puri@samsung.com,
	rpuri.linux@gmail.com,
	a.manzanares@samsung.com,
	dave@stgolabs.net,
	yosryahmed@google.com,
	keescook@chromium.org,
	hare@suse.de,
	kbusch@kernel.org,
	mcgrof@kernel.org,
	patches@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC v2 4/8] shmem: add helpers to get block size
Date: Fri, 26 May 2023 00:55:48 -0700
Message-Id: <20230526075552.363524-5-mcgrof@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230526075552.363524-1-mcgrof@kernel.org>
References: <20230526075552.363524-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

Stuff the block size as a struct shmem_sb_info member as a block_order
when CONFIG_TMPFS is enabled, but keep the current static value for now,
and use helpers to get the blocksize. This will make the subsequent
change easier to read.

The static value for block order is PAGE_SHIFT and so the default block
size is PAGE_SIZE.

The struct super_block s_blocksize_bits represents the blocksize in
power of two, and that will match the shmem_sb_info block_order.

This commit introduces no functional changes other than extending the
struct shmem_sb_info with the block_order.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 include/linux/shmem_fs.h |  3 +++
 mm/shmem.c               | 34 +++++++++++++++++++++++++++++++---
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 9029abd29b1c..2d0a4311fdbf 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -36,6 +36,9 @@ struct shmem_inode_info {
 #define SHMEM_FL_INHERITED		(FS_NODUMP_FL | FS_NOATIME_FL)
 
 struct shmem_sb_info {
+#ifdef CONFIG_TMPFS
+	unsigned char block_order;
+#endif
 	unsigned long max_blocks;   /* How many blocks are allowed */
 	struct percpu_counter used_blocks;  /* How many are allocated */
 	unsigned long max_inodes;   /* How many inodes are allowed */
diff --git a/mm/shmem.c b/mm/shmem.c
index 7bea4c5cb83a..c124997f8d93 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -122,7 +122,22 @@ struct shmem_options {
 #define SHMEM_SEEN_NOSWAP 16
 };
 
+static u64 shmem_default_block_order(void)
+{
+	return PAGE_SHIFT;
+}
+
 #ifdef CONFIG_TMPFS
+static u64 shmem_block_order(struct shmem_sb_info *sbinfo)
+{
+	return sbinfo->block_order;
+}
+
+static u64 shmem_sb_blocksize(struct shmem_sb_info *sbinfo)
+{
+	return 1UL << sbinfo->block_order;
+}
+
 static unsigned long shmem_default_max_blocks(void)
 {
 	return totalram_pages() / 2;
@@ -134,6 +149,17 @@ static unsigned long shmem_default_max_inodes(void)
 
 	return min(nr_pages - totalhigh_pages(), nr_pages / 2);
 }
+#else
+static u64 shmem_block_order(struct shmem_sb_info *sbinfo)
+{
+	return PAGE_SHIFT;
+}
+
+static u64 shmem_sb_blocksize(struct shmem_sb_info *sbinfo)
+{
+	return PAGE_SIZE;
+}
+
 #endif
 
 static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
@@ -3062,7 +3088,7 @@ static int shmem_statfs(struct dentry *dentry, struct kstatfs *buf)
 	struct shmem_sb_info *sbinfo = SHMEM_SB(dentry->d_sb);
 
 	buf->f_type = TMPFS_MAGIC;
-	buf->f_bsize = PAGE_SIZE;
+	buf->f_bsize = shmem_sb_blocksize(sbinfo);
 	buf->f_namelen = NAME_MAX;
 	if (sbinfo->max_blocks) {
 		buf->f_blocks = sbinfo->max_blocks;
@@ -3972,6 +3998,7 @@ static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
 	}
 	sb->s_export_op = &shmem_export_ops;
 	sb->s_flags |= SB_NOSEC | SB_I_VERSION;
+	sbinfo->block_order = shmem_default_block_order();
 #else
 	sb->s_flags |= SB_NOUSER;
 #endif
@@ -3997,8 +4024,9 @@ static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
 	INIT_LIST_HEAD(&sbinfo->shrinklist);
 
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
-	sb->s_blocksize = PAGE_SIZE;
-	sb->s_blocksize_bits = PAGE_SHIFT;
+	sb->s_blocksize = shmem_sb_blocksize(sbinfo);
+	sb->s_blocksize_bits = shmem_block_order(sbinfo);
+	WARN_ON_ONCE(sb->s_blocksize_bits != PAGE_SHIFT);
 	sb->s_magic = TMPFS_MAGIC;
 	sb->s_op = &shmem_ops;
 	sb->s_time_gran = 1;
-- 
2.39.2

