Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C5518B0A;
	Wed, 25 Feb 2026 01:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983220; cv=none; b=L0eTFrDVrWJQJ2wn9f83PHpdHJ3cNpjQ12VFAgA2H8HsvbV9JeRbRzwR6zgAIdxhlXsx9TPRnOmKY20JpOzwWcb70U+FVzTvHuU1EHfJexF8tXNBULNvAwvmbrat2BtL5zcWSIQhpyEWrgEBdb5/ytLa6X7w8CPOI8N+JHnJNMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983220; c=relaxed/simple;
	bh=jb+DUACeMBI/jkp6mQzfy+9BxQ9Dc6kQhiq2hUj4Sew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QfQXfzwCVMuoLTVSQlTPPPZoVFxionH2RLdwguoQEeCg9ygQCEYMrD2w6bkcWeb6LOjNJkk5R/DL/kQlQjSW/wDS3XvU2RU7xbO2LAFj3pDS86xd19cFJAmFJzIhILX46jlR16HG1FEmjKeL6FKfqMnmj8tUT0SE4/2WZr155WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MzLOtQFX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MzLOtQFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1635EC116D0;
	Wed, 25 Feb 2026 01:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983220;
	bh=jb+DUACeMBI/jkp6mQzfy+9BxQ9Dc6kQhiq2hUj4Sew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MzLOtQFXRh2t3upgpxkOlobdvxrrqVl5Nu0/TkzzcY1FGCUSyb12FQSTGxrrFafQJ
	 h00AtSXmIAgTka2Yo0prRmMpRKRh6OnkYtKvW1g7PABnZx0HyGJFrDS1PpUhJxBep8
	 Y5UUOEIoLN8BZAMgjrFnkbfOLb2ydg7sNGtB01Jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiyu Zhang <zhiyuzhang999@gmail.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 367/781] fat: avoid parent link count underflow in rmdir
Date: Tue, 24 Feb 2026 17:17:56 -0800
Message-ID: <20260225012408.682599257@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiyu Zhang <zhiyuzhang999@gmail.com>

[ Upstream commit 8cafcb881364af5ef3a8b9fed4db254054033d8a ]

Corrupted FAT images can leave a directory inode with an incorrect
i_nlink (e.g. 2 even though subdirectories exist). rmdir then
unconditionally calls drop_nlink(dir) and can drive i_nlink to 0,
triggering the WARN_ON in drop_nlink().

Add a sanity check in vfat_rmdir() and msdos_rmdir(): only drop the
parent link count when it is at least 3, otherwise report a filesystem
error.

Link: https://lkml.kernel.org/r/20260101111148.1437-1-zhiyuzhang999@gmail.com
Fixes: 9a53c3a783c2 ("[PATCH] r/o bind mounts: unlink: monitor i_nlink")
Signed-off-by: Zhiyu Zhang <zhiyuzhang999@gmail.com>
Reported-by: Zhiyu Zhang <zhiyuzhang999@gmail.com>
Closes: https://lore.kernel.org/linux-fsdevel/aVN06OKsKxZe6-Kv@casper.infradead.org/T/#t
Tested-by: Zhiyu Zhang <zhiyuzhang999@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fat/namei_msdos.c | 7 ++++++-
 fs/fat/namei_vfat.c  | 7 ++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index 0b920ee40a7f9..262ec1b790b56 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -325,7 +325,12 @@ static int msdos_rmdir(struct inode *dir, struct dentry *dentry)
 	err = fat_remove_entries(dir, &sinfo);	/* and releases bh */
 	if (err)
 		goto out;
-	drop_nlink(dir);
+	if (dir->i_nlink >= 3)
+		drop_nlink(dir);
+	else {
+		fat_fs_error(sb, "parent dir link count too low (%u)",
+			dir->i_nlink);
+	}
 
 	clear_nlink(inode);
 	fat_truncate_time(inode, NULL, S_CTIME);
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 5dbc4cbb8fce3..47ff083cfc7e6 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -803,7 +803,12 @@ static int vfat_rmdir(struct inode *dir, struct dentry *dentry)
 	err = fat_remove_entries(dir, &sinfo);	/* and releases bh */
 	if (err)
 		goto out;
-	drop_nlink(dir);
+	if (dir->i_nlink >= 3)
+		drop_nlink(dir);
+	else {
+		fat_fs_error(sb, "parent dir link count too low (%u)",
+			dir->i_nlink);
+	}
 
 	clear_nlink(inode);
 	fat_truncate_time(inode, NULL, S_ATIME|S_MTIME);
-- 
2.51.0



