Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2383FFBFE
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7985EC433D2;
	Mon, 15 May 2023 17:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170696;
	bh=RQ6BuQuHAmIL9AEKKu6a96YtaIlttlKOTSKEEUeAQqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QxV337c5VfxMWKuQhrFLnbb3FW8uTbg6P4iRGl8pLHcm/7gzll6mkZOAk0k1vZ+4n
	 yunYjHqJ243Y0sBeAv06e///3rgHYesNZk3+jyFDjJt6BUMrHssiaTdy+YJDSXD13m
	 ycajzQQ7oIcKKS1IRDttOj9d1xTi1Ztsu9ItwDZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 184/239] f2fs: specify extent cache for read explicitly
Date: Mon, 15 May 2023 18:27:27 +0200
Message-Id: <20230515161727.181723175@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 12607c1ba7637e750402f555b6695c50fce77a2b ]

Let's descrbie it's read extent cache.

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 043d2d00b443 ("f2fs: factor out victim_entry usage from general rb_tree use")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/extent_cache.c |  4 ++--
 fs/f2fs/f2fs.h         | 10 +++++-----
 fs/f2fs/inode.c        |  2 +-
 fs/f2fs/node.c         |  2 +-
 fs/f2fs/node.h         |  2 +-
 fs/f2fs/segment.c      |  4 ++--
 fs/f2fs/super.c        | 12 ++++++------
 7 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/f2fs/extent_cache.c b/fs/f2fs/extent_cache.c
index 6c9e6f78a3e37..84078eda19ff1 100644
--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -383,7 +383,7 @@ static void __f2fs_init_extent_tree(struct inode *inode, struct page *ipage)
 	if (!i_ext || !i_ext->len)
 		return;
 
-	get_extent_info(&ei, i_ext);
+	get_read_extent_info(&ei, i_ext);
 
 	write_lock(&et->lock);
 	if (atomic_read(&et->node_cnt))
@@ -711,7 +711,7 @@ unsigned int f2fs_shrink_extent_tree(struct f2fs_sb_info *sbi, int nr_shrink)
 	unsigned int node_cnt = 0, tree_cnt = 0;
 	int remained;
 
-	if (!test_opt(sbi, EXTENT_CACHE))
+	if (!test_opt(sbi, READ_EXTENT_CACHE))
 		return 0;
 
 	if (!atomic_read(&sbi->total_zombie_tree))
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 4b44ca1decdd3..f2d1be26d0d05 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -91,7 +91,7 @@ extern const char *f2fs_fault_name[FAULT_MAX];
 #define F2FS_MOUNT_FLUSH_MERGE		0x00000400
 #define F2FS_MOUNT_NOBARRIER		0x00000800
 #define F2FS_MOUNT_FASTBOOT		0x00001000
-#define F2FS_MOUNT_EXTENT_CACHE		0x00002000
+#define F2FS_MOUNT_READ_EXTENT_CACHE	0x00002000
 #define F2FS_MOUNT_DATA_FLUSH		0x00008000
 #define F2FS_MOUNT_FAULT_INJECTION	0x00010000
 #define F2FS_MOUNT_USRQUOTA		0x00080000
@@ -597,7 +597,7 @@ enum {
 #define F2FS_MIN_EXTENT_LEN	64	/* minimum extent length */
 
 /* number of extent info in extent cache we try to shrink */
-#define EXTENT_CACHE_SHRINK_NUMBER	128
+#define READ_EXTENT_CACHE_SHRINK_NUMBER	128
 
 #define RECOVERY_MAX_RA_BLOCKS		BIO_MAX_VECS
 #define RECOVERY_MIN_RA_BLOCKS		1
@@ -826,7 +826,7 @@ struct f2fs_inode_info {
 	loff_t original_i_size;		/* original i_size before atomic write */
 };
 
-static inline void get_extent_info(struct extent_info *ext,
+static inline void get_read_extent_info(struct extent_info *ext,
 					struct f2fs_extent *i_ext)
 {
 	ext->fofs = le32_to_cpu(i_ext->fofs);
@@ -834,7 +834,7 @@ static inline void get_extent_info(struct extent_info *ext,
 	ext->len = le32_to_cpu(i_ext->len);
 }
 
-static inline void set_raw_extent(struct extent_info *ext,
+static inline void set_raw_read_extent(struct extent_info *ext,
 					struct f2fs_extent *i_ext)
 {
 	i_ext->fofs = cpu_to_le32(ext->fofs);
@@ -4404,7 +4404,7 @@ static inline bool f2fs_may_extent_tree(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 
-	if (!test_opt(sbi, EXTENT_CACHE) ||
+	if (!test_opt(sbi, READ_EXTENT_CACHE) ||
 			is_inode_flag_set(inode, FI_NO_EXTENT) ||
 			(is_inode_flag_set(inode, FI_COMPRESSED_FILE) &&
 			 !f2fs_sb_has_readonly(sbi)))
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 229ddc2f7b079..896b0d5e4ee3f 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -629,7 +629,7 @@ void f2fs_update_inode(struct inode *inode, struct page *node_page)
 
 	if (et) {
 		read_lock(&et->lock);
-		set_raw_extent(&et->largest, &ri->i_ext);
+		set_raw_read_extent(&et->largest, &ri->i_ext);
 		read_unlock(&et->lock);
 	} else {
 		memset(&ri->i_ext, 0, sizeof(ri->i_ext));
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index b9ee5a1176a07..84b147966080e 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -85,7 +85,7 @@ bool f2fs_available_free_memory(struct f2fs_sb_info *sbi, int type)
 						sizeof(struct ino_entry);
 		mem_size >>= PAGE_SHIFT;
 		res = mem_size < ((avail_ram * nm_i->ram_thresh / 100) >> 1);
-	} else if (type == EXTENT_CACHE) {
+	} else if (type == READ_EXTENT_CACHE) {
 		mem_size = (atomic_read(&sbi->total_ext_tree) *
 				sizeof(struct extent_tree) +
 				atomic_read(&sbi->total_ext_node) *
diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index 3c09cae058b0a..0aa48704c77a0 100644
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -146,7 +146,7 @@ enum mem_type {
 	NAT_ENTRIES,	/* indicates the cached nat entry */
 	DIRTY_DENTS,	/* indicates dirty dentry pages */
 	INO_ENTRIES,	/* indicates inode entries */
-	EXTENT_CACHE,	/* indicates extent cache */
+	READ_EXTENT_CACHE,	/* indicates read extent cache */
 	DISCARD_CACHE,	/* indicates memory of cached discard cmds */
 	COMPRESS_PAGE,	/* indicates memory of cached compressed pages */
 	BASE_CHECK,	/* check kernel status */
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 866335db78793..426559092930d 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -452,8 +452,8 @@ void f2fs_balance_fs_bg(struct f2fs_sb_info *sbi, bool from_bg)
 		return;
 
 	/* try to shrink extent cache when there is no enough memory */
-	if (!f2fs_available_free_memory(sbi, EXTENT_CACHE))
-		f2fs_shrink_extent_tree(sbi, EXTENT_CACHE_SHRINK_NUMBER);
+	if (!f2fs_available_free_memory(sbi, READ_EXTENT_CACHE))
+		f2fs_shrink_extent_tree(sbi, READ_EXTENT_CACHE_SHRINK_NUMBER);
 
 	/* check the # of cached NAT entries */
 	if (!f2fs_available_free_memory(sbi, NAT_ENTRIES))
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 5af05411818a5..c46533d65372c 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -810,10 +810,10 @@ static int parse_options(struct super_block *sb, char *options, bool is_remount)
 			set_opt(sbi, FASTBOOT);
 			break;
 		case Opt_extent_cache:
-			set_opt(sbi, EXTENT_CACHE);
+			set_opt(sbi, READ_EXTENT_CACHE);
 			break;
 		case Opt_noextent_cache:
-			clear_opt(sbi, EXTENT_CACHE);
+			clear_opt(sbi, READ_EXTENT_CACHE);
 			break;
 		case Opt_noinline_data:
 			clear_opt(sbi, INLINE_DATA);
@@ -1939,7 +1939,7 @@ static int f2fs_show_options(struct seq_file *seq, struct dentry *root)
 		seq_puts(seq, ",nobarrier");
 	if (test_opt(sbi, FASTBOOT))
 		seq_puts(seq, ",fastboot");
-	if (test_opt(sbi, EXTENT_CACHE))
+	if (test_opt(sbi, READ_EXTENT_CACHE))
 		seq_puts(seq, ",extent_cache");
 	else
 		seq_puts(seq, ",noextent_cache");
@@ -2057,7 +2057,7 @@ static void default_options(struct f2fs_sb_info *sbi)
 	set_opt(sbi, INLINE_XATTR);
 	set_opt(sbi, INLINE_DATA);
 	set_opt(sbi, INLINE_DENTRY);
-	set_opt(sbi, EXTENT_CACHE);
+	set_opt(sbi, READ_EXTENT_CACHE);
 	set_opt(sbi, NOHEAP);
 	clear_opt(sbi, DISABLE_CHECKPOINT);
 	set_opt(sbi, MERGE_CHECKPOINT);
@@ -2198,7 +2198,7 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
 	bool need_restart_ckpt = false, need_stop_ckpt = false;
 	bool need_restart_flush = false, need_stop_flush = false;
 	bool need_restart_discard = false, need_stop_discard = false;
-	bool no_extent_cache = !test_opt(sbi, EXTENT_CACHE);
+	bool no_read_extent_cache = !test_opt(sbi, READ_EXTENT_CACHE);
 	bool enable_checkpoint = !test_opt(sbi, DISABLE_CHECKPOINT);
 	bool no_io_align = !F2FS_IO_ALIGNED(sbi);
 	bool no_atgc = !test_opt(sbi, ATGC);
@@ -2288,7 +2288,7 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
 	}
 
 	/* disallow enable/disable extent_cache dynamically */
-	if (no_extent_cache == !!test_opt(sbi, EXTENT_CACHE)) {
+	if (no_read_extent_cache == !!test_opt(sbi, READ_EXTENT_CACHE)) {
 		err = -EINVAL;
 		f2fs_warn(sbi, "switch extent_cache option is not allowed");
 		goto restore_opts;
-- 
2.39.2



