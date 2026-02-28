Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDCB36C9F0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302378; cv=none; b=C7R104j+82VKqk0P6/Uvgk5wZitAWpMWZGtIQNnzGn5i1/PZrzGpULG9jKoG0mUtxZn7bdIS23idvSpwdg5lxnHTS7/xQzmn09tg1VGjiYhELOLHxjsd1xOezgS9cjK1eKc0yMs8LVPGsGhV0Lm0TUhUur7haDTIZDA39zO+oH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302378; c=relaxed/simple;
	bh=oH3+oIg4c3Tu/pMLhXmEvOUQ7RVrSvG5C/mgvusaJak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qXpGLw0NWSgo0z+mHOmQGclUFwzMTljI0g+0H5lGzFJXP/+5RNR/jSRBhK5bSuSwQlbnC22mY8h3sV8olCdz6iDfEsaOAVOJRuSVTq6Xu/1w871SDZzCSs30Em4zc6u965CWE9ukj6Ls9IQGEOTyGiex1yWyr/T3iqaoOwZEZkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g13vVdZY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g13vVdZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4D7C19425;
	Sat, 28 Feb 2026 18:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302378;
	bh=oH3+oIg4c3Tu/pMLhXmEvOUQ7RVrSvG5C/mgvusaJak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g13vVdZYOqO1OBkapIewJTaFcxDBv2SjuP7ivRBHK4KtvX/S2RJ5bkKr03tN83XaW
	 8JabbtAbheNBoAePbwXpljWRqlAuwQolulw30Fp2dybixYfw3iEkbvT+4mWVBEOIB1
	 GdpUV1wMIiN3AeuKO6S/NQdOarflOZV5eY00vQ+b2ae6NOvyknzJtYrARjiIXWjAOg
	 uZ5auCbvYwxNqKqP6+pmBz9qBxoUoSd5TD/NLwzrA8HqINRYQvf1ZtP/pSFaxsvaj1
	 0W3ybGETHdRaMD1Uo8fZVGsRRGh92A3lc3cn3Wo81LFczwmyz7LLVs5rKi4U3l25VZ
	 hCMggd513Kbjw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zhiyu Zhang <zhiyuzhang999@gmail.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 106/232] fat: avoid parent link count underflow in rmdir
Date: Sat, 28 Feb 2026 13:09:19 -0500
Message-ID: <20260228181127.1592657-106-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index efba301d68aec..fba3a07d39478 100644
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
index 93fa8ddcf4145..3a9a849bc7885 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -806,7 +806,12 @@ static int vfat_rmdir(struct inode *dir, struct dentry *dentry)
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

