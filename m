Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493433C0091;
	Thu, 15 Jan 2026 17:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499354; cv=none; b=bEemMHsgZ65ZL4WDIf2QWFtUDleGk4E1xuDiLZC/xroB+attjWE/ZgckCJa90r5k1x3KTfBdmQ2REmZf6VuMqWGhF+n7T245NLdW3NaNgknRC6KZ2m8RDHGY7IYvnlxfM5FxUCI/jLiR0GTHps39elux5A5QX6i9q64zBFiwyyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499354; c=relaxed/simple;
	bh=iF1iNor81klozqIxnmAo7xwx2Jz18hiLh6UZmLmUu/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SMBXwiPJbsoR2zU5/ggIc6jKRUy8EZe0PaIZD3Zxep1nhWzQqt92IqLPWs8WZlgdJMnfwCCJ8T4H3hpGMH4YUP7pTSQby2vYVt0QQlO5d5vVYI6I2FugCDlzX7LJw9ZtRDj2h6K5uc+yzzJb0c52EWkSsFyEkcaXlgnrZLuALSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eprCYDNV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eprCYDNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C26C116D0;
	Thu, 15 Jan 2026 17:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499354;
	bh=iF1iNor81klozqIxnmAo7xwx2Jz18hiLh6UZmLmUu/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eprCYDNVwE454EXVclapgyYy15EjfZJp2O/zl5eL9U7p4Ve8/dMBVsGEIdh2KUrgv
	 uSLo1Fp5D2iJB3SslifCpt0t3aFExwMKh/q0qjM9VfdO8H+X6iPKOc/G0amqxQYq1H
	 5xTQKyKxMKlWuYnd9AZNYOCVGGRLDKI07F1mjnAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 164/451] hfsplus: Verify inode mode when loading from disk
Date: Thu, 15 Jan 2026 17:46:05 +0100
Message-ID: <20260115164236.842271051@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 005d4b0d33f6b4a23d382b7930f7a96b95b01f39 ]

syzbot is reporting that S_IFMT bits of inode->i_mode can become bogus when
the S_IFMT bits of the 16bits "mode" field loaded from disk are corrupted.

According to [1], the permissions field was treated as reserved in Mac OS
8 and 9. According to [2], the reserved field was explicitly initialized
with 0, and that field must remain 0 as long as reserved. Therefore, when
the "mode" field is not 0 (i.e. no longer reserved), the file must be
S_IFDIR if dir == 1, and the file must be one of S_IFREG/S_IFLNK/S_IFCHR/
S_IFBLK/S_IFIFO/S_IFSOCK if dir == 0.

Reported-by: syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=895c23f6917da440ed0d
Link: https://developer.apple.com/library/archive/technotes/tn/tn1150.html#HFSPlusPermissions [1]
Link: https://developer.apple.com/library/archive/technotes/tn/tn1150.html#ReservedAndPadFields [2]
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/04ded9f9-73fb-496c-bfa5-89c4f5d1d7bb@I-love.SAKURA.ne.jp
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/inode.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 7e1d889dcc07a..0ba324ee7dffb 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -178,13 +178,29 @@ const struct dentry_operations hfsplus_dentry_operations = {
 	.d_compare    = hfsplus_compare_dentry,
 };
 
-static void hfsplus_get_perms(struct inode *inode,
-		struct hfsplus_perm *perms, int dir)
+static int hfsplus_get_perms(struct inode *inode,
+			     struct hfsplus_perm *perms, int dir)
 {
 	struct hfsplus_sb_info *sbi = HFSPLUS_SB(inode->i_sb);
 	u16 mode;
 
 	mode = be16_to_cpu(perms->mode);
+	if (dir) {
+		if (mode && !S_ISDIR(mode))
+			goto bad_type;
+	} else if (mode) {
+		switch (mode & S_IFMT) {
+		case S_IFREG:
+		case S_IFLNK:
+		case S_IFCHR:
+		case S_IFBLK:
+		case S_IFIFO:
+		case S_IFSOCK:
+			break;
+		default:
+			goto bad_type;
+		}
+	}
 
 	i_uid_write(inode, be32_to_cpu(perms->owner));
 	if ((test_bit(HFSPLUS_SB_UID, &sbi->flags)) || (!i_uid_read(inode) && !mode))
@@ -210,6 +226,10 @@ static void hfsplus_get_perms(struct inode *inode,
 		inode->i_flags |= S_APPEND;
 	else
 		inode->i_flags &= ~S_APPEND;
+	return 0;
+bad_type:
+	pr_err("invalid file type 0%04o for inode %lu\n", mode, inode->i_ino);
+	return -EIO;
 }
 
 static int hfsplus_file_open(struct inode *inode, struct file *file)
@@ -504,7 +524,9 @@ int hfsplus_cat_read_inode(struct inode *inode, struct hfs_find_data *fd)
 		}
 		hfs_bnode_read(fd->bnode, &entry, fd->entryoffset,
 					sizeof(struct hfsplus_cat_folder));
-		hfsplus_get_perms(inode, &folder->permissions, 1);
+		res = hfsplus_get_perms(inode, &folder->permissions, 1);
+		if (res)
+			goto out;
 		set_nlink(inode, 1);
 		inode->i_size = 2 + be32_to_cpu(folder->valence);
 		inode->i_atime = hfsp_mt2ut(folder->access_date);
@@ -531,7 +553,9 @@ int hfsplus_cat_read_inode(struct inode *inode, struct hfs_find_data *fd)
 
 		hfsplus_inode_read_fork(inode, HFSPLUS_IS_RSRC(inode) ?
 					&file->rsrc_fork : &file->data_fork);
-		hfsplus_get_perms(inode, &file->permissions, 0);
+		res = hfsplus_get_perms(inode, &file->permissions, 0);
+		if (res)
+			goto out;
 		set_nlink(inode, 1);
 		if (S_ISREG(inode->i_mode)) {
 			if (file->permissions.dev)
-- 
2.51.0



