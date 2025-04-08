Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8F525FA04;
	Tue,  8 Apr 2025 11:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110799; cv=none; b=TJOSiQi56+mNmIDXe3hNIRTkARCaAjNGsVgEVUxO2P7QU21EXSgVfeOvvGRl/8pXh2t4P9sdTIK6PQAAAwSvdA/+9AJDggeP+i16ydhOxrK2tLpCLxwb5bX5ZvZD1Gjn3tIqA6ieBd9aJ87wm4pmJUXnv3+oo1dJYXT3kseGxP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110799; c=relaxed/simple;
	bh=Kvj752RWVNYZuHgnPosVrjnGoT4VHx0z/DK24RSxbic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LsL9sO+uqy6OKAxfPiMCgv8oby6wQUlRFNuDjtLZEWdhiRjSPgrFevVikH+FSfFxDWn0DTkWPJoCEiD5awdfdXHqVSh5h6k/RPA7vUm3zzl1LlXHRjNtoSwCDtNwj0atObo56vV310ki6mhBIBvcdgxwl5oNknKB3rqp8K4oeLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ET0dXRkR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ET0dXRkR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3173C4CEE5;
	Tue,  8 Apr 2025 11:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110799;
	bh=Kvj752RWVNYZuHgnPosVrjnGoT4VHx0z/DK24RSxbic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ET0dXRkRYCt054msItx0/SxQF0pDTXN7mRe0X84ATn9EztqmKDN2fwj6R2iEj5/Mo
	 yCB0CC3xXCI88FyX9sfsoZIKm1rYIut/f/Pljj60rC3sblwFmuHgSRHKnJYTDiwECQ
	 8P8yzzvNc0EKEqsG/oPRY7u4exd/Zqobo4yzqCcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 197/731] ext4: fix out-of-bound read in ext4_xattr_inode_dec_ref_all()
Date: Tue,  8 Apr 2025 12:41:34 +0200
Message-ID: <20250408104918.862488613@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit 5701875f9609b000d91351eaa6bfd97fe2f157f4 ]

There's issue as follows:
BUG: KASAN: use-after-free in ext4_xattr_inode_dec_ref_all+0x6ff/0x790
Read of size 4 at addr ffff88807b003000 by task syz-executor.0/15172

CPU: 3 PID: 15172 Comm: syz-executor.0
Call Trace:
 __dump_stack lib/dump_stack.c:82 [inline]
 dump_stack+0xbe/0xfd lib/dump_stack.c:123
 print_address_description.constprop.0+0x1e/0x280 mm/kasan/report.c:400
 __kasan_report.cold+0x6c/0x84 mm/kasan/report.c:560
 kasan_report+0x3a/0x50 mm/kasan/report.c:585
 ext4_xattr_inode_dec_ref_all+0x6ff/0x790 fs/ext4/xattr.c:1137
 ext4_xattr_delete_inode+0x4c7/0xda0 fs/ext4/xattr.c:2896
 ext4_evict_inode+0xb3b/0x1670 fs/ext4/inode.c:323
 evict+0x39f/0x880 fs/inode.c:622
 iput_final fs/inode.c:1746 [inline]
 iput fs/inode.c:1772 [inline]
 iput+0x525/0x6c0 fs/inode.c:1758
 ext4_orphan_cleanup fs/ext4/super.c:3298 [inline]
 ext4_fill_super+0x8c57/0xba40 fs/ext4/super.c:5300
 mount_bdev+0x355/0x410 fs/super.c:1446
 legacy_get_tree+0xfe/0x220 fs/fs_context.c:611
 vfs_get_tree+0x8d/0x2f0 fs/super.c:1576
 do_new_mount fs/namespace.c:2983 [inline]
 path_mount+0x119a/0x1ad0 fs/namespace.c:3316
 do_mount+0xfc/0x110 fs/namespace.c:3329
 __do_sys_mount fs/namespace.c:3540 [inline]
 __se_sys_mount+0x219/0x2e0 fs/namespace.c:3514
 do_syscall_64+0x33/0x40 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x67/0xd1

Memory state around the buggy address:
 ffff88807b002f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88807b002f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88807b003000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                   ^
 ffff88807b003080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88807b003100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

Above issue happens as ext4_xattr_delete_inode() isn't check xattr
is valid if xattr is in inode.
To solve above issue call xattr_check_inode() check if xattr if valid
in inode. In fact, we can directly verify in ext4_iget_extra_inode(),
so that there is no divergent verification.

Fixes: e50e5129f384 ("ext4: xattr-in-inode support")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20250208063141.1539283-3-yebin@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c |  5 +++++
 fs/ext4/xattr.c | 26 +-------------------------
 fs/ext4/xattr.h |  7 +++++++
 3 files changed, 13 insertions(+), 25 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 64e280fed9119..891bd1e2d19f8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4674,6 +4674,11 @@ static inline int ext4_iget_extra_inode(struct inode *inode,
 	    *magic == cpu_to_le32(EXT4_XATTR_MAGIC)) {
 		int err;
 
+		err = xattr_check_inode(inode, IHDR(inode, raw_inode),
+					ITAIL(inode, raw_inode));
+		if (err)
+			return err;
+
 		ext4_set_inode_state(inode, EXT4_STATE_XATTR);
 		err = ext4_find_inline_data_nolock(inode);
 		if (!err && ext4_has_inline_data(inode))
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 0e4494863d153..a10fb8a9d02dc 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -308,7 +308,7 @@ __ext4_xattr_check_block(struct inode *inode, struct buffer_head *bh,
 	__ext4_xattr_check_block((inode), (bh),  __func__, __LINE__)
 
 
-static inline int
+int
 __xattr_check_inode(struct inode *inode, struct ext4_xattr_ibody_header *header,
 			 void *end, const char *function, unsigned int line)
 {
@@ -316,9 +316,6 @@ __xattr_check_inode(struct inode *inode, struct ext4_xattr_ibody_header *header,
 			    function, line);
 }
 
-#define xattr_check_inode(inode, header, end) \
-	__xattr_check_inode((inode), (header), (end), __func__, __LINE__)
-
 static int
 xattr_find_entry(struct inode *inode, struct ext4_xattr_entry **pentry,
 		 void *end, int name_index, const char *name, int sorted)
@@ -650,9 +647,6 @@ ext4_xattr_ibody_get(struct inode *inode, int name_index, const char *name,
 	raw_inode = ext4_raw_inode(&iloc);
 	header = IHDR(inode, raw_inode);
 	end = ITAIL(inode, raw_inode);
-	error = xattr_check_inode(inode, header, end);
-	if (error)
-		goto cleanup;
 	entry = IFIRST(header);
 	error = xattr_find_entry(inode, &entry, end, name_index, name, 0);
 	if (error)
@@ -783,7 +777,6 @@ ext4_xattr_ibody_list(struct dentry *dentry, char *buffer, size_t buffer_size)
 	struct ext4_xattr_ibody_header *header;
 	struct ext4_inode *raw_inode;
 	struct ext4_iloc iloc;
-	void *end;
 	int error;
 
 	if (!ext4_test_inode_state(inode, EXT4_STATE_XATTR))
@@ -793,14 +786,9 @@ ext4_xattr_ibody_list(struct dentry *dentry, char *buffer, size_t buffer_size)
 		return error;
 	raw_inode = ext4_raw_inode(&iloc);
 	header = IHDR(inode, raw_inode);
-	end = ITAIL(inode, raw_inode);
-	error = xattr_check_inode(inode, header, end);
-	if (error)
-		goto cleanup;
 	error = ext4_xattr_list_entries(dentry, IFIRST(header),
 					buffer, buffer_size);
 
-cleanup:
 	brelse(iloc.bh);
 	return error;
 }
@@ -868,7 +856,6 @@ int ext4_get_inode_usage(struct inode *inode, qsize_t *usage)
 	struct ext4_xattr_ibody_header *header;
 	struct ext4_xattr_entry *entry;
 	qsize_t ea_inode_refs = 0;
-	void *end;
 	int ret;
 
 	lockdep_assert_held_read(&EXT4_I(inode)->xattr_sem);
@@ -879,10 +866,6 @@ int ext4_get_inode_usage(struct inode *inode, qsize_t *usage)
 			goto out;
 		raw_inode = ext4_raw_inode(&iloc);
 		header = IHDR(inode, raw_inode);
-		end = ITAIL(inode, raw_inode);
-		ret = xattr_check_inode(inode, header, end);
-		if (ret)
-			goto out;
 
 		for (entry = IFIRST(header); !IS_LAST_ENTRY(entry);
 		     entry = EXT4_XATTR_NEXT(entry))
@@ -2237,9 +2220,6 @@ int ext4_xattr_ibody_find(struct inode *inode, struct ext4_xattr_info *i,
 	is->s.here = is->s.first;
 	is->s.end = ITAIL(inode, raw_inode);
 	if (ext4_test_inode_state(inode, EXT4_STATE_XATTR)) {
-		error = xattr_check_inode(inode, header, is->s.end);
-		if (error)
-			return error;
 		/* Find the named attribute. */
 		error = xattr_find_entry(inode, &is->s.here, is->s.end,
 					 i->name_index, i->name, 0);
@@ -2790,10 +2770,6 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 	min_offs = end - base;
 	total_ino = sizeof(struct ext4_xattr_ibody_header) + sizeof(u32);
 
-	error = xattr_check_inode(inode, header, end);
-	if (error)
-		goto cleanup;
-
 	ifree = ext4_xattr_free_space(base, &min_offs, base, &total_ino);
 	if (ifree >= isize_diff)
 		goto shift;
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 5197f17ffd9a2..1fedf44d4fb65 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -209,6 +209,13 @@ extern int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
 extern struct mb_cache *ext4_xattr_create_cache(void);
 extern void ext4_xattr_destroy_cache(struct mb_cache *);
 
+extern int
+__xattr_check_inode(struct inode *inode, struct ext4_xattr_ibody_header *header,
+		    void *end, const char *function, unsigned int line);
+
+#define xattr_check_inode(inode, header, end) \
+	__xattr_check_inode((inode), (header), (end), __func__, __LINE__)
+
 #ifdef CONFIG_EXT4_FS_SECURITY
 extern int ext4_init_security(handle_t *handle, struct inode *inode,
 			      struct inode *dir, const struct qstr *qstr);
-- 
2.39.5



