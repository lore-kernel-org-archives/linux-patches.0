Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE35E35AC39
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302711; cv=none; b=oTzUCa/Fe+KB+fKvZFgqS+rc+FYfUgPVZVLgmBsUnqmTRtw2YQM8NP768a/kXkVIDc36LdAc7+s3M2MlND0Si1lVHld4iBn9gBA0On3QbjobE4MH180ivWaPAAkZJhqWfV/Iu6C5AqHQh4R9CNOuv4WFFiHb25fCeROwDt4pPkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302711; c=relaxed/simple;
	bh=znWDv0DewUBTbzuMHh7lx9JpuNZA2RrVQIgEdyn/tBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gp44Wee4WbG9WOwt3GT2lzJasMkXfmHILEJLjqwgqoNw6lXzzbaJye1gltBE0WXLoMdzWIp0fqU/AWbhShveYX0NCgwGy9KbPKAMcidRwGqRpGbEtpnxKU527meRzIGGBbVITnISGiDAFasPTyXkSo4in/TT/tq6D/6echjKACg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xg0vbOiV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xg0vbOiV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF68EC19424;
	Sat, 28 Feb 2026 18:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302711;
	bh=znWDv0DewUBTbzuMHh7lx9JpuNZA2RrVQIgEdyn/tBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xg0vbOiVrZzI9J5pJR0q1R8DEQi5lI+3gwW3zHALQFo6rWBxhwq09bAlYy+0l0Gxl
	 qb2/pewA0OdCI1N6wY3FRKKNaFqfwMEuk4fvOvnEUcL81r9lPdkph9a5jRXFSrNbMS
	 /KSgofJ2L/bYA7DVt470vadj8ldj3nuDUgu/rPpVLpl8sXeX97uZxp83AcgFVCMPzZ
	 ql3vEg/q2IhWBTvjgGdS6b+26mLsMfu6H6UuMJNtA0Aqn569P2B3Ug6a1lUNU+aUtQ
	 DW3L6KbWqI/g004aX6/FBDM3dU+2vPzUpuhTrmHCAR2U+FvwbWAFsP/fQQCRplfqSW
	 sMpzffdMId6uQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zhiyu Zhang <zhiyuzhang999@gmail.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/147] fat: avoid parent link count underflow in rmdir
Date: Sat, 28 Feb 2026 13:16:18 -0500
Message-ID: <20260228181736.1605592-70-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 9d062886fbc19..63a323be9179d 100644
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
index 9bc7d1602c15b..2a0d9a9c2c8f7 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -808,7 +808,12 @@ static int vfat_rmdir(struct inode *dir, struct dentry *dentry)
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

