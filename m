Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4264A2FC4E;
	Fri, 24 Nov 2023 18:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H0W3i9os"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C322CC433C7;
	Fri, 24 Nov 2023 18:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852340;
	bh=FIQX1zuBoGumYgQx5pPK0zk5h/KnwrJJvJK3dFUBapg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H0W3i9os+PvR9AdBLaznU3HPLBXzRF/QrIbWIR6H2I+dAblehCKZQ+R+Nmm91OQ9A
	 pwRmx9S7qsiCDsP8hZin6HkJWdgX35FSFo5NJIwuribEoiXRSYOnsr4gVge/AcJC2s
	 H7QIz6RnU6SDweLKxGQD0mk+JMqFiF4PsmUJCQPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.1 316/372] f2fs: do not return EFSCORRUPTED, but try to run online repair
Date: Fri, 24 Nov 2023 17:51:43 +0000
Message-ID: <20231124172020.920764285@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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
@@ -2738,7 +2738,9 @@ recover_xnid:
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
@@ -363,10 +363,10 @@ static int lookup_all_xattrs(struct inod
 
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
@@ -583,13 +583,12 @@ ssize_t f2fs_listxattr(struct dentry *de
 
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
 
 		if (!handler || (handler->list && !handler->list(dentry)))
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


