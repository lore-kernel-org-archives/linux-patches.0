Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA30433A014
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301796; cv=none; b=IA/KmjyPCq4wmCJ1wpFLRRXeQs+4vH4g/eIDbCoEX8TVs4aR6Np32EkgprdgUqOSnurkOMYDhKU8PTb4DqqQZ665T2Dsc3mDsFNOADNxpNX0yfWsfOMY7/IixPeSfSxykGZLemxY+oCgFxv0wmgheNHLe19/D6jpd4y4i7Xd6sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301796; c=relaxed/simple;
	bh=aKabhdStAFMUn/XjaiQHp7GO70ALNUJxpM1ql6gntlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVPIRe5DYJnOTjFdtlzK44jiZrLNcBBDR7hd9kxtNQRzLMWeVLsMeIOCd8DdkhWFnJLd2sWXhsEprXzbkCShFvbZY23IdMYUK6JUqTTBwJee4id3rFWem2xz4y6toRWnogVVD3JVz7WJPuXxFeJnacqt7AtZerrwl1PW2x13tCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GP2GqLAt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GP2GqLAt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77C6C19423;
	Sat, 28 Feb 2026 18:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301796;
	bh=aKabhdStAFMUn/XjaiQHp7GO70ALNUJxpM1ql6gntlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GP2GqLAtWEYDtM6YbLktt0h1SscIPonB2D5u6iXmQCe07yHdshfV0nHb8WYBCpImm
	 fVALkFUgHm7BgHkSVOhR302G15H0EK8LMNynkL1AsVumKiM3p2ilqngbiAxDdmXUDr
	 iYDW1ma/IzXNAC+Gmz26R9Lp4jTAiO2qczmTHR95FLGDbmNi6DKFr1Eq83UC1cciPY
	 9fORA4bicUdCUV2Z0SsB5Tq+8AJNkPMuDHtE9q5DVycQpdAQK5wNwu4bImZ7+pgqnR
	 NUx5uCfb90+SAxF/b+25Pfk6XHbb+qcWpqurKAJh3ddeQjM+hbvGklIhJ5UMaV54sO
	 j6lBLfiYVorFg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zhiyu Zhang <zhiyuzhang999@gmail.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 207/385] fat: avoid parent link count underflow in rmdir
Date: Sat, 28 Feb 2026 12:57:09 -0500
Message-ID: <20260228180011.1568201-207-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index f06f6ba643cc8..c75e3791514a2 100644
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
index 15bf32c21ac0d..31d37e2b4f679 100644
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

