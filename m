Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C573A8C9;
	Fri, 24 Nov 2023 18:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kmH+Hray"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1006BC433C8;
	Fri, 24 Nov 2023 18:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850115;
	bh=LOP6YgebK1q5GX1BwywZ2K6e2YLwK81Q7x+8Ea7Zf5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kmH+HrayY99COuWZrxOvzAcwT8/bytiI/5CIRIiaXDd1ZK5BezMbinx9g62Da9xzQ
	 n2q5161EMP3lrJoUgjpOG5nlPIZuDVu51sC6PetuLUMBlRMswWYfTxyieoWgapd0Lj
	 qKG2qHc+icA9WexWpDb4qSyZzMAC2a4wOXlAxuY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.6 450/530] f2fs: do not return EFSCORRUPTED, but try to run online repair
Date: Fri, 24 Nov 2023 17:50:16 +0000
Message-ID: <20231124172041.793445133@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit 50a472bbc79ff9d5a88be8019a60e936cadf9f13 upstream.

If we return the error, there's no way to recover the status as of now, since
fsck does not fix the xattr boundary issue.

Cc: stable@vger.kernel.org
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/node.c  |    4 +++-
 fs/f2fs/xattr.c |   20 +++++++++++++-------
 2 files changed, 16 insertions(+), 8 deletions(-)

--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2751,7 +2751,9 @@ recover_xnid:
 	f2fs_update_inode_page(inode);
 
 	/* 3: update and set xattr node page dirty */
-	memcpy(F2FS_NODE(xpage), F2FS_NODE(page), VALID_XATTR_BLOCK_SIZE);
+	if (page)
+		memcpy(F2FS_NODE(xpage), F2FS_NODE(page),
+				VALID_XATTR_BLOCK_SIZE);
 
 	set_page_dirty(xpage);
 	f2fs_put_page(xpage, 1);
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -364,10 +364,10 @@ static int lookup_all_xattrs(struct inod
 
 	*xe = __find_xattr(cur_addr, last_txattr_addr, NULL, index, len, name);
 	if (!*xe) {
-		f2fs_err(F2FS_I_SB(inode), "inode (%lu) has corrupted xattr",
+		f2fs_err(F2FS_I_SB(inode), "lookup inode (%lu) has corrupted xattr",
 								inode->i_ino);
 		set_sbi_flag(F2FS_I_SB(inode), SBI_NEED_FSCK);
-		err = -EFSCORRUPTED;
+		err = -ENODATA;
 		f2fs_handle_error(F2FS_I_SB(inode),
 					ERROR_CORRUPTED_XATTR);
 		goto out;
@@ -584,13 +584,12 @@ ssize_t f2fs_listxattr(struct dentry *de
 
 		if ((void *)(entry) + sizeof(__u32) > last_base_addr ||
 			(void *)XATTR_NEXT_ENTRY(entry) > last_base_addr) {
-			f2fs_err(F2FS_I_SB(inode), "inode (%lu) has corrupted xattr",
+			f2fs_err(F2FS_I_SB(inode), "list inode (%lu) has corrupted xattr",
 						inode->i_ino);
 			set_sbi_flag(F2FS_I_SB(inode), SBI_NEED_FSCK);
-			error = -EFSCORRUPTED;
 			f2fs_handle_error(F2FS_I_SB(inode),
 						ERROR_CORRUPTED_XATTR);
-			goto cleanup;
+			break;
 		}
 
 		if (!prefix)
@@ -650,7 +649,7 @@ static int __f2fs_setxattr(struct inode
 
 	if (size > MAX_VALUE_LEN(inode))
 		return -E2BIG;
-
+retry:
 	error = read_all_xattrs(inode, ipage, &base_addr);
 	if (error)
 		return error;
@@ -660,7 +659,14 @@ static int __f2fs_setxattr(struct inode
 	/* find entry with wanted name. */
 	here = __find_xattr(base_addr, last_base_addr, NULL, index, len, name);
 	if (!here) {
-		f2fs_err(F2FS_I_SB(inode), "inode (%lu) has corrupted xattr",
+		if (!F2FS_I(inode)->i_xattr_nid) {
+			f2fs_notice(F2FS_I_SB(inode),
+				"recover xattr in inode (%lu)", inode->i_ino);
+			f2fs_recover_xattr_data(inode, NULL);
+			kfree(base_addr);
+			goto retry;
+		}
+		f2fs_err(F2FS_I_SB(inode), "set inode (%lu) has corrupted xattr",
 								inode->i_ino);
 		set_sbi_flag(F2FS_I_SB(inode), SBI_NEED_FSCK);
 		error = -EFSCORRUPTED;


