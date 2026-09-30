Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB01221FB6;
	Wed, 30 Sep 2026 16:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784333; cv=none; b=RszrTgMpEEjRyWbyMr9KMYpL8Y2+b6qYLZ6+vZ889xwws0nftzcdGQ1VfRlAG9KrGgBzkwo4Ytjx0kbqDimvWAnRbYfF2xehJMwL+nm+v47N1iZqHdtkvi391HVQAIsq8dVXY/Gh86feszlF+zgNOPNsB1Dc+UycxQKNqtwdJw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784333; c=relaxed/simple;
	bh=hLiQ8Bg3UGyroy9GrW1HmxKx/GPxgMu1AdUBeErX0t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nP7BI5sDCpImTVIkJrhsOakCbzXgqX3M7FJp76rF0IWqoF0NdGYENnOZJgO5LO+cZRghm1ujTMFSwfGs5BKSxihAapbmiWjQh13BNJjlCgEAnl0+NSZAVbuS9L4yENT1Ijfpd7HHPg07zuFzvqygDDnBFaCoouvTu3e02E1pWTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SedDSQma; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SedDSQma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6FE1F00898;
	Wed, 30 Sep 2026 16:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784326;
	bh=LHXX4jMuu7UN0bq2j9k/GpUXC0Dycm8yBHAXyZJzwv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SedDSQmaKSHdR2UqCEzveYoTjZOaNmZTt+0cK1TQhuuahWZXfoyTEEj2ysFgnbo4/
	 9IMY+g7rKaTzZBPTL48PLfrQJr/kPM71hZORGZ4M6ITXSwm2QIBMtKV5dQvFdjB4CC
	 +ufVqxTleQdwJRVPjrKiYKA51Wy7CJR20ooLg+4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Yangtao Li <frank.li@vivo.com>,
	linux-fsdevel@vger.kernel.org,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/982] hfs: rework hfsplus_readdir() logic
Date: Wed, 30 Sep 2026 17:14:10 +0200
Message-ID: <20260930152419.264162422@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viacheslav Dubeyko <slava@dubeyko.com>

[ Upstream commit 7fde7e806657fbe0d33f489521b488eed94f9b39 ]

The xfstests' test-case generic/637 fails with error:

FSTYP -- hfs
PLATFORM -- Linux/x86_64 kvm-xfstests 6.15.0-rc4-xfstests-g00b827f0cffa #1 SMP PREEMPT_DYNAMIC Fri May 25
MKFS_OPTIONS -- /dev/vdc
MOUNT_OPTIONS -- /dev/vdc /vdc

QA output created by 637
entries 7 and 8 have duplicate d_off 8
Found unlinked files in open dir (see xfstests-dev/results//generic/637.full for details)

Likewise HFS+, currently, HFS has very complicated and
fragile logic of rd->file->f_pos correction in hfs_delete_cat().
This patch removes this logic and it stores the current
pos into hfs_readdir_data. Finally, if rd->pos == ctx->pos
then hfs_readdir() tries to find the position in
b-tree's node by means of hfs_cat_key. This position is
used to re-start the folder's content traversal.

sudo ./check generic/637
FSTYP         -- hfs
PLATFORM      -- Linux/x86_64 hfsplus-testing-0001 7.1.0-rc1+ #55 SMP PREEMPT_DYNAMIC Tue May 19 15:18:02 PDT 2026
MKFS_OPTIONS  -- /dev/loop51
MOUNT_OPTIONS -- /dev/loop51 /mnt/scratch

generic/637  32s ...  31s
Ran: generic/637
Passed all 1 tests

Closes: https://github.com/hfs-linux-kernel/hfs-linux-kernel/issues/65
cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
cc: Yangtao Li <frank.li@vivo.com>
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20260519222811.1311071-2-slava@dubeyko.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfs/catalog.c |  9 ---------
 fs/hfs/dir.c     | 28 +++++++++++-----------------
 fs/hfs/hfs.h     |  3 +--
 fs/hfs/hfs_fs.h  |  2 --
 fs/hfs/inode.c   |  4 ----
 5 files changed, 12 insertions(+), 34 deletions(-)

diff --git a/fs/hfs/catalog.c b/fs/hfs/catalog.c
index d365bf0b8c77d..41e09f209f745 100644
--- a/fs/hfs/catalog.c
+++ b/fs/hfs/catalog.c
@@ -222,7 +222,6 @@ int hfs_cat_delete(u32 cnid, struct inode *dir, const struct qstr *str)
 {
 	struct super_block *sb;
 	struct hfs_find_data fd;
-	struct hfs_readdir_data *rd;
 	int res, type;
 
 	hfs_dbg(CAT_MOD, "delete_cat: %s,%u\n", str ? str->name : NULL, cnid);
@@ -248,14 +247,6 @@ int hfs_cat_delete(u32 cnid, struct inode *dir, const struct qstr *str)
 		}
 	}
 
-	/* we only need to take spinlock for exclusion with ->release() */
-	spin_lock(&HFS_I(dir)->open_dir_lock);
-	list_for_each_entry(rd, &HFS_I(dir)->open_dir_list, list) {
-		if (fd.tree->keycmp(fd.search_key, (void *)&rd->key) < 0)
-			rd->file->f_pos--;
-	}
-	spin_unlock(&HFS_I(dir)->open_dir_lock);
-
 	res = hfs_brec_remove(&fd);
 	if (res)
 		goto out;
diff --git a/fs/hfs/dir.c b/fs/hfs/dir.c
index 527f6e46cbe81..f392aee79f422 100644
--- a/fs/hfs/dir.c
+++ b/fs/hfs/dir.c
@@ -97,7 +97,15 @@ static int hfs_readdir(struct file *file, struct dir_context *ctx)
 	}
 	if (ctx->pos >= inode->i_size)
 		goto out;
-	err = hfs_brec_goto(&fd, ctx->pos - 1);
+	rd = file->private_data;
+	if (rd && rd->pos == ctx->pos) {
+		memcpy(fd.search_key, &rd->key, sizeof(struct hfs_cat_key));
+		err = hfs_brec_find(&fd);
+		if (err == -ENOENT)
+			err = hfs_brec_goto(&fd, 1);
+	} else {
+		err = hfs_brec_goto(&fd, ctx->pos - 1);
+	}
 	if (err)
 		goto out;
 
@@ -146,7 +154,6 @@ static int hfs_readdir(struct file *file, struct dir_context *ctx)
 		if (err)
 			goto out;
 	}
-	rd = file->private_data;
 	if (!rd) {
 		rd = kmalloc(sizeof(struct hfs_readdir_data), GFP_KERNEL);
 		if (!rd) {
@@ -154,15 +161,8 @@ static int hfs_readdir(struct file *file, struct dir_context *ctx)
 			goto out;
 		}
 		file->private_data = rd;
-		rd->file = file;
-		spin_lock(&HFS_I(inode)->open_dir_lock);
-		list_add(&rd->list, &HFS_I(inode)->open_dir_list);
-		spin_unlock(&HFS_I(inode)->open_dir_lock);
 	}
-	/*
-	 * Can be done after the list insertion; exclusion with
-	 * hfs_delete_cat() is provided by directory lock.
-	 */
+	rd->pos = ctx->pos;
 	memcpy(&rd->key, &fd.key->cat, sizeof(struct hfs_cat_key));
 out:
 	hfs_find_exit(&fd);
@@ -171,13 +171,7 @@ static int hfs_readdir(struct file *file, struct dir_context *ctx)
 
 static int hfs_dir_release(struct inode *inode, struct file *file)
 {
-	struct hfs_readdir_data *rd = file->private_data;
-	if (rd) {
-		spin_lock(&HFS_I(inode)->open_dir_lock);
-		list_del(&rd->list);
-		spin_unlock(&HFS_I(inode)->open_dir_lock);
-		kfree(rd);
-	}
+	kfree(file->private_data);
 	return 0;
 }
 
diff --git a/fs/hfs/hfs.h b/fs/hfs/hfs.h
index 6f194d0768b6f..f46d12ce04a3f 100644
--- a/fs/hfs/hfs.h
+++ b/fs/hfs/hfs.h
@@ -281,8 +281,7 @@ struct hfs_mdb {
 /*======== Data structures kept in memory ========*/
 
 struct hfs_readdir_data {
-	struct list_head list;
-	struct file *file;
+	loff_t pos;
 	struct hfs_cat_key key;
 };
 
diff --git a/fs/hfs/hfs_fs.h b/fs/hfs/hfs_fs.h
index 1bce2ec271d4d..203757a273ac3 100644
--- a/fs/hfs/hfs_fs.h
+++ b/fs/hfs/hfs_fs.h
@@ -68,8 +68,6 @@ struct hfs_inode_info {
 
 	struct hfs_cat_key cat_key;
 
-	struct list_head open_dir_list;
-	spinlock_t open_dir_lock;
 	struct inode *rsrc_inode;
 
 	struct mutex extents_lock;
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index e45cc396dc004..e4530fdd93de0 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -193,8 +193,6 @@ struct inode *hfs_new_inode(struct inode *dir, const struct qstr *name, umode_t
 		return NULL;
 
 	mutex_init(&HFS_I(inode)->extents_lock);
-	INIT_LIST_HEAD(&HFS_I(inode)->open_dir_list);
-	spin_lock_init(&HFS_I(inode)->open_dir_lock);
 	hfs_cat_build_key(sb, (btree_key *)&HFS_I(inode)->cat_key, dir->i_ino, name);
 	inode->i_ino = HFS_SB(sb)->next_id++;
 	inode->i_mode = mode;
@@ -328,8 +326,6 @@ static int hfs_read_inode(struct inode *inode, void *data)
 	HFS_I(inode)->flags = 0;
 	HFS_I(inode)->rsrc_inode = NULL;
 	mutex_init(&HFS_I(inode)->extents_lock);
-	INIT_LIST_HEAD(&HFS_I(inode)->open_dir_list);
-	spin_lock_init(&HFS_I(inode)->open_dir_lock);
 
 	/* Initialize the inode */
 	inode->i_uid = hsb->s_uid;
-- 
2.53.0



