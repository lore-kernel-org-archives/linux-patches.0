Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CD21ED4D
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:42:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8765C433C8;
	Tue, 25 Jul 2023 11:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285342;
	bh=C8OuGycvnWXUDIiqrf6UwJJLn52A8Mt08ICyXRyl75M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fs4mBghaDmuavbPKyYzzefT4ZADNTi2eqWW5xnNSOHXvBoyoBOh29aEzjqkJBuP/d
	 PQaNZBe0lfEmFQGlCfJwgiHNDgwJnCVfIWI5FKZ68l9qBYrqsdkoogPJHs/lhlAT8E
	 l/D55d5xCRRdfe7zwizXdw46lAXZO/iAmM/kxzpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.4 171/313] Revert "f2fs: fix potential corruption when moving a directory"
Date: Tue, 25 Jul 2023 12:45:24 +0200
Message-ID: <20230725104528.348702616@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jan Kara <jack@suse.cz>

commit cde3c9d7e2a359e337216855dcb333a19daaa436 upstream.

This reverts commit d94772154e524b329a168678836745d2773a6e02. The
locking is going to be provided by VFS.

CC: Jaegeuk Kim <jaegeuk@kernel.org>
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Message-Id: <20230601105830.13168-3-jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/namei.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -892,20 +892,12 @@ static int f2fs_rename(struct inode *old
 			goto out;
 	}
 
-	/*
-	 * Copied from ext4_rename: we need to protect against old.inode
-	 * directory getting converted from inline directory format into
-	 * a normal one.
-	 */
-	if (S_ISDIR(old_inode->i_mode))
-		inode_lock_nested(old_inode, I_MUTEX_NONDIR2);
-
 	err = -ENOENT;
 	old_entry = f2fs_find_entry(old_dir, &old_dentry->d_name, &old_page);
 	if (!old_entry) {
 		if (IS_ERR(old_page))
 			err = PTR_ERR(old_page);
-		goto out_unlock_old;
+		goto out;
 	}
 
 	if (S_ISDIR(old_inode->i_mode)) {
@@ -1033,9 +1025,6 @@ static int f2fs_rename(struct inode *old
 
 	f2fs_unlock_op(sbi);
 
-	if (S_ISDIR(old_inode->i_mode))
-		inode_unlock(old_inode);
-
 	if (IS_DIRSYNC(old_dir) || IS_DIRSYNC(new_dir))
 		f2fs_sync_fs(sbi->sb, 1);
 
@@ -1051,9 +1040,6 @@ out_dir:
 		f2fs_put_page(old_dir_page, 0);
 out_old:
 	f2fs_put_page(old_page, 0);
-out_unlock_old:
-	if (S_ISDIR(old_inode->i_mode))
-		inode_unlock(old_inode);
 out:
 	if (whiteout)
 		iput(whiteout);


