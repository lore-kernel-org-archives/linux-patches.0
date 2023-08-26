Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DD9F9D5
	for <patches@lists.linux.dev>; Sat, 26 Aug 2023 15:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA26C433C9;
	Sat, 26 Aug 2023 15:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693064902;
	bh=7BTngXWl7+U/mJhFVGLF5M2nLN+bgMZmVFhN+KziU5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gok8qqzgEGsM34v7LwmfNHbE9Jp2ORIkCfdM2s9aNi2B6AxJssvPJ4ByJCY48Wu5J
	 P0DM5y77tOmn6osmY6rfFdPyF5cStWchnYZ+DK+Qc19PeYpkg1jJFf6VswlNkwjeks
	 idZOCkPOV8vzlAJHyZdsMnBEZ1diDV5viIMT1QFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.1 4/4] Revert "f2fs: fix to do sanity check on direct node in truncate_dnode()"
Date: Sat, 26 Aug 2023 17:48:00 +0200
Message-ID: <20230826154625.665847814@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230826154625.450325166@linuxfoundation.org>
References: <20230826154625.450325166@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit a78a8bcdc26de5ef3a0ee27c9c6c512e54a6051c which is
commit a6ec83786ab9f13f25fb18166dee908845713a95 upstream.

Something is currently broken in the f2fs code, Guenter has reported
boot problems with it for a few releases now, so revert the most recent
f2fs changes in the hope to get this back to a working filesystem.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/b392e1a8-b987-4993-bd45-035db9415a6e@roeck-us.net
Cc: Chao Yu <chao@kernel.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/f2fs.h          |    1 +
 fs/f2fs/file.c          |    5 +++++
 fs/f2fs/node.c          |   14 ++------------
 include/linux/f2fs_fs.h |    1 -
 4 files changed, 8 insertions(+), 13 deletions(-)

--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3431,6 +3431,7 @@ static inline bool __is_valid_data_blkad
  * file.c
  */
 int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync);
+void f2fs_truncate_data_blocks(struct dnode_of_data *dn);
 int f2fs_do_truncate_blocks(struct inode *inode, u64 from, bool lock);
 int f2fs_truncate_blocks(struct inode *inode, u64 from, bool lock);
 int f2fs_truncate(struct inode *inode);
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -628,6 +628,11 @@ void f2fs_truncate_data_blocks_range(str
 					 dn->ofs_in_node, nr_free);
 }
 
+void f2fs_truncate_data_blocks(struct dnode_of_data *dn)
+{
+	f2fs_truncate_data_blocks_range(dn, ADDRS_PER_BLOCK(dn->inode));
+}
+
 static int truncate_partial_data_page(struct inode *inode, u64 from,
 								bool cache_only)
 {
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -923,7 +923,6 @@ static int truncate_node(struct dnode_of
 
 static int truncate_dnode(struct dnode_of_data *dn)
 {
-	struct f2fs_sb_info *sbi = F2FS_I_SB(dn->inode);
 	struct page *page;
 	int err;
 
@@ -931,25 +930,16 @@ static int truncate_dnode(struct dnode_o
 		return 1;
 
 	/* get direct node */
-	page = f2fs_get_node_page(sbi, dn->nid);
+	page = f2fs_get_node_page(F2FS_I_SB(dn->inode), dn->nid);
 	if (PTR_ERR(page) == -ENOENT)
 		return 1;
 	else if (IS_ERR(page))
 		return PTR_ERR(page);
 
-	if (IS_INODE(page) || ino_of_node(page) != dn->inode->i_ino) {
-		f2fs_err(sbi, "incorrect node reference, ino: %lu, nid: %u, ino_of_node: %u",
-				dn->inode->i_ino, dn->nid, ino_of_node(page));
-		set_sbi_flag(sbi, SBI_NEED_FSCK);
-		f2fs_handle_error(sbi, ERROR_INVALID_NODE_REFERENCE);
-		f2fs_put_page(page, 1);
-		return -EFSCORRUPTED;
-	}
-
 	/* Make dnode_of_data for parameter */
 	dn->node_page = page;
 	dn->ofs_in_node = 0;
-	f2fs_truncate_data_blocks_range(dn, ADDRS_PER_BLOCK(dn->inode));
+	f2fs_truncate_data_blocks(dn);
 	err = truncate_node(dn);
 	if (err) {
 		f2fs_put_page(page, 1);
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -104,7 +104,6 @@ enum f2fs_error {
 	ERROR_INCONSISTENT_SIT,
 	ERROR_CORRUPTED_VERITY_XATTR,
 	ERROR_CORRUPTED_XATTR,
-	ERROR_INVALID_NODE_REFERENCE,
 	ERROR_MAX,
 };
 


