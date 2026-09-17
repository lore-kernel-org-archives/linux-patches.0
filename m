Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50464FDE58;
	Thu, 17 Sep 2026 17:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667374; cv=none; b=Pv63WCV0B4TZ6NtpVwml8ebpM+802oazsXnPRRimWGBmlnbpQJT+VTkZM9qQF0Kyjlq+3P4tpNqJxLItlbyYAwGEl5QbWvBG9OTJ+oDXV84j3tHftpMsnLm/JpCAVsHn5J80SmXtoBvPhivoA06qBkOm4tqHRN4sf7o1d8t7DLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667374; c=relaxed/simple;
	bh=PujYq+wMVAz90V9FQ2Geq7fQYB3npwjDSJwrUKwWuno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skZQdvrpla/mancRZTSlniTSfFWZYI7kcFV4h+7Eb0mbeQ3a2jTmkH48w+1sgSwIOBQB+KscwCoDy+XIAzEmqXT4Z3L/bYhOr8eyt4+UxHif90Vw6eFdZ1uBV0wJZjir2kiYzMO8N3zeqqMpF96+R8iFHLmXZs+GOMN8QU4Gvho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KFql8wMs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KFql8wMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA621F000FF;
	Thu, 17 Sep 2026 17:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667372;
	bh=UMg+B3P9MSLZ7SF6/u2A/Cjc1TZ/IiIFLegAgbK0W1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KFql8wMsSIbze+XKpLerIYB5wcapepOx4hgPfG7lBKh3i0ihspx3Fly27U1L3bCET
	 VuSRlD7Z8H/TEPbWR84P9u9WPkFSE8/WyoPyCwI687i14BX5MrDFhrxVKpsaV3ndtk
	 4+FRV6+HKt+qEKzl47ZQV+GsHcZ8n6QwpRj/ee90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Yangtao Li <frank.li@vivo.com>,
	linux-fsdevel@vger.kernel.org,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0071/1102] hfsplus: rework hfsplus_readdir() logic
Date: Thu, 17 Sep 2026 16:00:14 +0100
Message-ID: <20260917151541.247808314@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viacheslav Dubeyko <slava@dubeyko.com>

[ Upstream commit 4b0496432844628ad05a5b1efce329a3340174d2 ]

The xfstests' test-case generic/637 fails with error:

FSTYP -- hfsplus
PLATFORM -- Linux/x86_64 hfsplus-testing-0001 6.15.0-rc4+ #8 SMP PREEMPT_DYNAMIC Thu May 1 16:43:22 PDT 2025
MKFS_OPTIONS -- /dev/loop51
MOUNT_OPTIONS -- /dev/loop51 /mnt/scratch

QA output created by 637
entries 7 and 8 have duplicate d_off 8
Found unlinked files in open dir (see xfstests-dev/results//generic/637.full for details)

Debugging of the hfsplus_readdir() logic showed this:

hfsplus: hfsplus_readdir(): 163 ctx->pos 0
hfsplus: hfsplus_readdir(): 189 ctx->pos 1
hfsplus: hfsplus_readdir(): 264 ctx->pos 2, ino 18
hfsplus: hfsplus_readdir(): 264 ctx->pos 3, ino 19
hfsplus: hfsplus_readdir(): 264 ctx->pos 4, ino 28
hfsplus: hfsplus_readdir(): 264 ctx->pos 5, ino 118
hfsplus: hfsplus_readdir(): 264 ctx->pos 6, ino 29
hfsplus: hfsplus_readdir(): 264 ctx->pos 7, ino 30
hfsplus: hfsplus_readdir(): 264 ctx->pos 8, ino 31
hfsplus: hfsplus_readdir(): 304 ctx->pos 8
hfsplus: hfsplus_unlink():420 dir->i_ino 17, inode->i_ino 28
hfsplus: hfsplus_readdir(): 141 ctx->pos 7
hfsplus: hfsplus_readdir(): 264 ctx->pos 7, ino 31
hfsplus: hfsplus_readdir(): 264 ctx->pos 8, ino 32
hfsplus: hfsplus_readdir(): 264 ctx->pos 9, ino 33

It means that hfsplus_readdir() stopped the processing of
folder's items on ctx->pos 8, then, item with ino 28 has
been deleted and hfsplus_readdir() re-started the logic
from ctx->pos 7. As a result, previous and new sets of
folder's items have overlapping values for the case of
d_off 8.

Currently, HFS+ has very complicated and fragile logic
of rd->file->f_pos correction in hfsplus_delete_cat().
This patch removes this logic and it stores the current
pos into hfsplus_readdir_data. Finally, if rd->pos == ctx->pos
then hfsplus_readdir() tries to find the position in
b-tree's node by means of hfsplus_cat_key. This position is
used to re-start the folder's content traversal.

sudo ./check generic/637
FSTYP         -- hfsplus
PLATFORM      -- Linux/x86_64 hfsplus-testing-0001 7.1.0-rc1+ #44 SMP PREEMPT_DYNAMIC Mon May  4 15:58:45 PDT 2026
MKFS_OPTIONS  -- /dev/loop51
MOUNT_OPTIONS -- /dev/loop51 /mnt/scratch

generic/637  22s ...  22s
Ran: generic/637
Passed all 1 tests

Closes: https://github.com/hfs-linux-kernel/hfs-linux-kernel/issues/198
cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
cc: Yangtao Li <frank.li@vivo.com>
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20260505220051.2854696-2-slava@dubeyko.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/catalog.c    | 11 -----------
 fs/hfsplus/dir.c        | 28 +++++++++++-----------------
 fs/hfsplus/hfsplus_fs.h |  5 +----
 fs/hfsplus/inode.c      |  2 --
 fs/hfsplus/super.c      |  2 --
 5 files changed, 12 insertions(+), 36 deletions(-)

diff --git a/fs/hfsplus/catalog.c b/fs/hfsplus/catalog.c
index 7a9c72e4e4f2a..ed42def477c39 100644
--- a/fs/hfsplus/catalog.c
+++ b/fs/hfsplus/catalog.c
@@ -332,7 +332,6 @@ int hfsplus_delete_cat(u32 cnid, struct inode *dir, const struct qstr *str)
 	struct super_block *sb = dir->i_sb;
 	struct hfs_find_data fd;
 	struct hfsplus_fork_raw fork;
-	struct list_head *pos;
 	int err, off;
 	u16 type;
 
@@ -390,16 +389,6 @@ int hfsplus_delete_cat(u32 cnid, struct inode *dir, const struct qstr *str)
 		hfsplus_free_fork(sb, cnid, &fork, HFSPLUS_TYPE_RSRC);
 	}
 
-	/* we only need to take spinlock for exclusion with ->release() */
-	spin_lock(&HFSPLUS_I(dir)->open_dir_lock);
-	list_for_each(pos, &HFSPLUS_I(dir)->open_dir_list) {
-		struct hfsplus_readdir_data *rd =
-			list_entry(pos, struct hfsplus_readdir_data, list);
-		if (fd.tree->keycmp(fd.search_key, (void *)&rd->key) < 0)
-			rd->file->f_pos--;
-	}
-	spin_unlock(&HFSPLUS_I(dir)->open_dir_lock);
-
 	err = hfs_brec_remove(&fd);
 	if (err)
 		goto out;
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index eecb72c800d04..aba85e23d9861 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -185,7 +185,15 @@ static int hfsplus_readdir(struct file *file, struct dir_context *ctx)
 	}
 	if (ctx->pos >= inode->i_size)
 		goto out;
-	err = hfs_brec_goto(&fd, ctx->pos - 1);
+	rd = file->private_data;
+	if (rd && rd->pos == ctx->pos) {
+		memcpy(fd.search_key, &rd->key, sizeof(struct hfsplus_cat_key));
+		err = hfs_brec_find(&fd, hfs_find_rec_by_key);
+		if (err == -ENOENT)
+			err = hfs_brec_goto(&fd, 1);
+	} else {
+		err = hfs_brec_goto(&fd, ctx->pos - 1);
+	}
 	if (err)
 		goto out;
 	for (;;) {
@@ -261,7 +269,6 @@ static int hfsplus_readdir(struct file *file, struct dir_context *ctx)
 		if (err)
 			goto out;
 	}
-	rd = file->private_data;
 	if (!rd) {
 		rd = kmalloc(sizeof(struct hfsplus_readdir_data), GFP_KERNEL);
 		if (!rd) {
@@ -269,15 +276,8 @@ static int hfsplus_readdir(struct file *file, struct dir_context *ctx)
 			goto out;
 		}
 		file->private_data = rd;
-		rd->file = file;
-		spin_lock(&HFSPLUS_I(inode)->open_dir_lock);
-		list_add(&rd->list, &HFSPLUS_I(inode)->open_dir_list);
-		spin_unlock(&HFSPLUS_I(inode)->open_dir_lock);
 	}
-	/*
-	 * Can be done after the list insertion; exclusion with
-	 * hfsplus_delete_cat() is provided by directory lock.
-	 */
+	rd->pos = ctx->pos;
 	memcpy(&rd->key, fd.key, sizeof(struct hfsplus_cat_key));
 out:
 	kfree(strbuf);
@@ -287,13 +287,7 @@ static int hfsplus_readdir(struct file *file, struct dir_context *ctx)
 
 static int hfsplus_dir_release(struct inode *inode, struct file *file)
 {
-	struct hfsplus_readdir_data *rd = file->private_data;
-	if (rd) {
-		spin_lock(&HFSPLUS_I(inode)->open_dir_lock);
-		list_del(&rd->list);
-		spin_unlock(&HFSPLUS_I(inode)->open_dir_lock);
-		kfree(rd);
-	}
+	kfree(file->private_data);
 	return 0;
 }
 
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index f4b9c7e2491c9..8d78cd3e5cf0f 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -247,8 +247,6 @@ struct hfsplus_inode_info {
 	sector_t fs_blocks;
 	u8 userflags;		/* BSD user file flags */
 	u32 subfolders;		/* Subfolder count (HFSX only) */
-	struct list_head open_dir_list;
-	spinlock_t open_dir_lock;
 	loff_t phys_size;
 
 	struct inode vfs_inode;
@@ -298,8 +296,7 @@ struct hfs_find_data {
 };
 
 struct hfsplus_readdir_data {
-	struct list_head list;
-	struct file *file;
+	loff_t pos;
 	struct hfsplus_cat_key key;
 };
 
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 8184518f5cf4e..0ba8d90736af6 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -445,8 +445,6 @@ struct inode *hfsplus_new_inode(struct super_block *sb, struct inode *dir,
 	simple_inode_init_ts(inode);
 
 	hip = HFSPLUS_I(inode);
-	INIT_LIST_HEAD(&hip->open_dir_list);
-	spin_lock_init(&hip->open_dir_lock);
 	mutex_init(&hip->extents_lock);
 	atomic_set(&hip->opencnt, 0);
 	hip->extent_state = 0;
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index 3f7576d38ade9..8a74ecd8c771c 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -90,8 +90,6 @@ struct inode *hfsplus_iget(struct super_block *sb, unsigned long ino)
 	HFSPLUS_I(inode)->fs_blocks = 0;
 	HFSPLUS_I(inode)->userflags = 0;
 	HFSPLUS_I(inode)->subfolders = 0;
-	INIT_LIST_HEAD(&HFSPLUS_I(inode)->open_dir_list);
-	spin_lock_init(&HFSPLUS_I(inode)->open_dir_lock);
 	HFSPLUS_I(inode)->phys_size = 0;
 
 	if (inode->i_ino >= HFSPLUS_FIRSTUSER_CNID ||
-- 
2.53.0



