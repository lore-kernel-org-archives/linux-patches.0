Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB73A8F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D69AC433C7;
	Sun, 16 Jul 2023 20:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539268;
	bh=NF9WRJlqM1Nddr07LcQ3A2d250h8zo+Inhw9Uk2uR6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a7uzkA99ni5g+ddjrLFcgQHN0ndPTXBNXHCTpSW0dXWzlEeuv+kzOznG7q2H751Pt
	 b8Jh/L/NQ8azLGsEBbfDSLjpPESmgZk/rnuOWuUGZr9qYu3ixtK9D981l30WZY7aRI
	 /W+j9EO7bpqpPKzYvkCaNqJm1wLM2J9A5LonwcYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.4 747/800] Revert "f2fs: fix potential corruption when moving a directory"
Date: Sun, 16 Jul 2023 21:50:00 +0200
Message-ID: <20230716195006.471628358@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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
@@ -995,20 +995,12 @@ static int f2fs_rename(struct mnt_idmap
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
@@ -1116,9 +1108,6 @@ static int f2fs_rename(struct mnt_idmap
 
 	f2fs_unlock_op(sbi);
 
-	if (S_ISDIR(old_inode->i_mode))
-		inode_unlock(old_inode);
-
 	if (IS_DIRSYNC(old_dir) || IS_DIRSYNC(new_dir))
 		f2fs_sync_fs(sbi->sb, 1);
 
@@ -1133,9 +1122,6 @@ out_dir:
 		f2fs_put_page(old_dir_page, 0);
 out_old:
 	f2fs_put_page(old_page, 0);
-out_unlock_old:
-	if (S_ISDIR(old_inode->i_mode))
-		inode_unlock(old_inode);
 out:
 	iput(whiteout);
 	return err;


