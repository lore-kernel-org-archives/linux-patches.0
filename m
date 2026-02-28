Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2691638D018
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302135; cv=none; b=EoafsNA6ZDc2yCiwRjaXzGoovdp2fq7rFV4SKlgkE6Cm8XI6X54k6uAT+Q7GEl1XJul83xOdDHTAHCzMwEkEEVL7w79AVFszSds34ewvN5K2dzJrOqKJOagNUCIpXX33l62KtyBfmQtmI4h9HB9Gkui709aa4ap+jWEQuQO/49w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302135; c=relaxed/simple;
	bh=zgeeKepyN+oqJnODc6WtCgp3pbhLyXET60e3A0JXqxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5+kVSYnUyxIpzEPmfiNg7+ggXG8ZozEMzvF2Qe82y2ENuZtIKHEdZLnqfNF93I+lC7y3bnMd8ZG9giP4AqPv+bKzoR9mqIthGIFLPSid5b7mBpG5+s8HwPOMYXES/LTgshHz+jUnjeIt4DisJukRh844v7C1m//+FcWPHzux5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CYNx5vOo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CYNx5vOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345DCC19423;
	Sat, 28 Feb 2026 18:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302135;
	bh=zgeeKepyN+oqJnODc6WtCgp3pbhLyXET60e3A0JXqxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CYNx5vOoWRyzDvDoteJUiDfrCw31KiNZdEdGycxQ14jVg4LjEgdtncOPXztu/z1vi
	 lsbRjTfiqCpETixy+GvLSV+J7qDS4WFHydALWBNFg/vLlzQdVgoImYT57YkXN65eeq
	 mcZJEF+Ma6IqFHhABeIlb1yk8zim3oejU5I3GKMKZhsiu8IOVcmdQQVjQWio+owSGb
	 lY87W0UncTPvBgJ9Yg3DBs1u3ML5y3FbYNhRvhO+KrdU0nPdZdYhymHrw6zhAAqd8D
	 b2RkevP6vzhSAk3ZtlGmPMUbtukAvy+4fmWPEukcsKI8nAQrgnt/lZkXKRjmq6Vgzb
	 XyvekmyGn/MOg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zhiyu Zhang <zhiyuzhang999@gmail.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/283] fat: avoid parent link count underflow in rmdir
Date: Sat, 28 Feb 2026 13:04:28 -0500
Message-ID: <20260228180709.1583486-126-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 2116c486843b7..e189fbf95fcac 100644
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
index 3cf22a6727f1b..7d7ac30c6eff8 100644
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

