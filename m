Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348F33BA225;
	Tue, 21 Jul 2026 21:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667984; cv=none; b=hh8T8hDUWbFOf+NmIiDwYSQ48LZGBILOrVArG7c4vG+2HvNlAckrDK9Tk7GYfn0DBIfEXxEHudej0lvPJWfWjLIxpkbJxJVttz7TIjFqzPhNS6roNwoQgsmAiQL46Stqps7nbC9F75vxxBZ/9huiXJj/9ulMdWnvjJe3oNaFt7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667984; c=relaxed/simple;
	bh=3BitwP+KGfO1rtjEPxoc300XjkXN+1ILBCNVTP1FRHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4q5Mmc2s22Ffv/lz2hazsnCFkzSgGEBq5En1muVX5izfUpoZNv3Pz5KzGzVhiLKQwDncrBL0mpiFR1XQlDjzLrnmDKVXBykhWz67J1sOH/zOg0q9mAL39Moc4WkoqARXdI3/lRHAXkkgRAlkoQv7mHISUlSttHrc7UghsT2qPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNrLhFWx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNrLhFWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8441F000E9;
	Tue, 21 Jul 2026 21:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667983;
	bh=YEDIAaBUuXIgUoQW6uL7s9VlMPfPd1jo4twi2elOx7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TNrLhFWxq4Z1mPx1PGuqChw3puuTPHdqQ/ntWHOpSgD0BqYgk+2HFkQvvzq3RZEC6
	 KtdmVHxIo3R3eBllctZIx0J32H/tvRmyKiTmVQk6/9rSMpkpO39WgRXpAMM9hI0EhG
	 +0LIPJ/0x66SXjfTdrbO/KnI2JsREesIRw2T/Q+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rochan Avlur <rochan.avlur@gmail.com>,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1244/1266] exfat: preserve benign secondary entries during rename and move
Date: Tue, 21 Jul 2026 17:28:01 +0200
Message-ID: <20260721152509.657343809@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rochan Avlur <rochan.avlur@gmail.com>

[ Upstream commit 942296784b2a9439651750c42f540bf2579b330f ]

Commit 8258ef28001a ("exfat: handle unreconized benign secondary
entries") added cluster freeing for benign secondary entries inside
exfat_remove_entries().  However, exfat_remove_entries() is also called
from the rename and move paths (exfat_rename_file and exfat_move_file),
where the old entry set is being relocated rather than deleted.  This
causes benign secondary entries such as vendor extension entries to be
silently destroyed on rename or cross-directory move, violating the
exFAT spec requirement (section 8.2) that implementations preserve
unrecognized benign secondary entries.

Fix this by adding a free_benign parameter to exfat_remove_entries()
so callers can suppress cluster freeing during relocation, and
extending exfat_init_ext_entry() to copy trailing benign secondary
entries from the old entry set into the new one internally.  Also
clean up the error paths to delete newly allocated entries on failure.

Fixes: 8258ef28001a ("exfat: handle unreconized benign secondary entries")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-fsdevel/CAG7tbBV--waov7XVu2FHQEc6paR92dufS=em9DW5Kzsrpu3iQg@mail.gmail.com/
Signed-off-by: Rochan Avlur <rochan.avlur@gmail.com>
Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/dir.c      |   45 ++++++++++--
 fs/exfat/exfat_fs.h |    5 -
 fs/exfat/namei.c    |  191 ++++++++++++++++++++++++++++++++++------------------
 3 files changed, 169 insertions(+), 72 deletions(-)

--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -552,21 +552,43 @@ static void exfat_free_benign_secondary_
 	exfat_free_cluster(inode, &dir);
 }
 
+/*
+ * exfat_init_ext_entry - initialize extension entries of a dentry set
+ * @inode:       parent directory inode
+ * @p_dir:       directory the dentry set is in
+ * @entry:       index of the first entry of the dentry set
+ * @num_entries: number of entries excluding benign secondary entries
+ * @p_uniname:   filename to store
+ * @old_es:      optional source entry set with benign secondary entries, or NULL
+ * @num_extra:   number of benign secondary entries to copy from @old_es
+ *
+ * Set up the file, stream extension, and filename entries, optionally
+ * preserving @num_extra benign secondary entries from @old_es.  @old_es
+ * may refer to the same dentry set that is being initialized.
+ */
 int exfat_init_ext_entry(struct inode *inode, struct exfat_chain *p_dir,
-		int entry, int num_entries, struct exfat_uni_name *p_uniname)
+		int entry, int num_entries, struct exfat_uni_name *p_uniname,
+		struct exfat_entry_set_cache *old_es, int num_extra)
 {
 	struct super_block *sb = inode->i_sb;
-	int i;
+	int i, src_start = 0;
 	unsigned short *uniname = p_uniname->name;
 	struct exfat_dentry *ep;
 	struct buffer_head *bh;
 	int sync = IS_DIRSYNC(inode);
 
+	if (WARN_ON(num_extra < 0 || (num_extra && (!old_es ||
+		    old_es->num_entries < ES_IDX_FIRST_FILENAME + num_extra))))
+		num_extra = 0;
+
+	if (old_es && num_extra > 0)
+		src_start = old_es->num_entries - num_extra;
+
 	ep = exfat_get_dentry(sb, p_dir, entry, &bh);
 	if (!ep)
 		return -EIO;
 
-	ep->dentry.file.num_ext = (unsigned char)(num_entries - 1);
+	ep->dentry.file.num_ext = (unsigned char)(num_entries - 1 + num_extra);
 	exfat_update_bh(bh, sync);
 	brelse(bh);
 
@@ -579,6 +601,19 @@ int exfat_init_ext_entry(struct inode *i
 	exfat_update_bh(bh, sync);
 	brelse(bh);
 
+	if (old_es && num_extra > 0) {
+		for (i = 0; i < num_extra; i++) {
+			ep = exfat_get_dentry(sb, p_dir,
+					      entry + num_entries + i, &bh);
+			if (!ep)
+				return -EIO;
+
+			*ep = *exfat_get_dentry_cached(old_es, src_start + i);
+			exfat_update_bh(bh, sync);
+			brelse(bh);
+		}
+	}
+
 	for (i = EXFAT_FIRST_CLUSTER; i < num_entries; i++) {
 		ep = exfat_get_dentry(sb, p_dir, entry + i, &bh);
 		if (!ep)
@@ -595,7 +630,7 @@ int exfat_init_ext_entry(struct inode *i
 }
 
 int exfat_remove_entries(struct inode *inode, struct exfat_chain *p_dir,
-		int entry, int order, int num_entries)
+		int entry, int order, int num_entries, bool free_benign)
 {
 	struct super_block *sb = inode->i_sb;
 	int i;
@@ -607,7 +642,7 @@ int exfat_remove_entries(struct inode *i
 		if (!ep)
 			return -EIO;
 
-		if (exfat_get_entry_type(ep) & TYPE_BENIGN_SEC)
+		if (free_benign && (exfat_get_entry_type(ep) & TYPE_BENIGN_SEC))
 			exfat_free_benign_secondary_clusters(inode, ep);
 
 		exfat_set_entry_type(ep, TYPE_DELETED);
--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -480,9 +480,10 @@ int exfat_init_dir_entry(struct inode *i
 		int entry, unsigned int type, unsigned int start_clu,
 		unsigned long long size);
 int exfat_init_ext_entry(struct inode *inode, struct exfat_chain *p_dir,
-		int entry, int num_entries, struct exfat_uni_name *p_uniname);
+		int entry, int num_entries, struct exfat_uni_name *p_uniname,
+		struct exfat_entry_set_cache *old_es, int num_extra);
 int exfat_remove_entries(struct inode *inode, struct exfat_chain *p_dir,
-		int entry, int order, int num_entries);
+		int entry, int order, int num_entries, bool free_benign);
 int exfat_update_dir_chksum(struct inode *inode, struct exfat_chain *p_dir,
 		int entry);
 void exfat_update_dir_chksum_with_entry_set(struct exfat_entry_set_cache *es);
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -531,7 +531,8 @@ static int exfat_add_entry(struct inode
 	if (ret)
 		goto out;
 
-	ret = exfat_init_ext_entry(inode, p_dir, dentry, num_entries, &uniname);
+	ret = exfat_init_ext_entry(inode, p_dir, dentry, num_entries, &uniname,
+		NULL, 0);
 	if (ret)
 		goto out;
 
@@ -814,7 +815,8 @@ static int exfat_unlink(struct inode *di
 
 	exfat_set_volume_dirty(sb);
 	/* update the directory entry */
-	if (exfat_remove_entries(dir, &ei->dir, ei->entry, 0, num_entries)) {
+	if (exfat_remove_entries(dir, &ei->dir, ei->entry, 0, num_entries,
+			true)) {
 		err = -EIO;
 		goto unlock;
 	}
@@ -981,7 +983,8 @@ static int exfat_rmdir(struct inode *dir
 	brelse(bh);
 
 	exfat_set_volume_dirty(sb);
-	err = exfat_remove_entries(dir, &ei->dir, ei->entry, 0, num_entries);
+	err = exfat_remove_entries(dir, &ei->dir, ei->entry, 0, num_entries,
+			true);
 	if (err) {
 		exfat_err(sb, "failed to exfat_remove_entries : err(%d)", err);
 		goto unlock;
@@ -1007,41 +1010,67 @@ unlock:
 	return err;
 }
 
+/*
+ * Count benign secondary entries beyond the filename entries.
+ * Returns the count, or -EIO if the entry set is inconsistent.
+ */
+static int exfat_count_extra_entries(struct exfat_entry_set_cache *es)
+{
+	struct exfat_dentry *stream;
+	unsigned int name_entries;
+	int extra;
+
+	stream = exfat_get_dentry_cached(es, ES_IDX_STREAM);
+	name_entries = EXFAT_FILENAME_ENTRY_NUM(stream->dentry.stream.name_len);
+	extra = es->num_entries - (ES_IDX_FIRST_FILENAME + name_entries);
+
+	return extra >= 0 ? extra : -EIO;
+}
+
 static int exfat_rename_file(struct inode *parent_inode,
 		struct exfat_uni_name *p_uniname, struct exfat_inode_info *ei)
 {
 	int ret, num_old_entries, num_new_entries;
 	struct exfat_dentry *epold, *epnew;
 	struct super_block *sb = parent_inode->i_sb;
+	struct exfat_entry_set_cache old_es;
 	struct buffer_head *new_bh, *old_bh;
 	int sync = IS_DIRSYNC(parent_inode);
-
-	epold = exfat_get_dentry(sb, &ei->dir, ei->entry, &old_bh);
-	if (!epold)
-		return -EIO;
-
-	num_old_entries = exfat_count_ext_entries(sb, &ei->dir, ei->entry,
-		epold);
-	if (num_old_entries < 0)
-		return -EIO;
-	num_old_entries++;
+	unsigned int num_extra_entries, num_total_entries;
 
 	num_new_entries = exfat_calc_num_entries(p_uniname);
 	if (num_new_entries < 0)
 		return num_new_entries;
 
-	if (num_old_entries < num_new_entries) {
+	ret = exfat_get_dentry_set_by_ei(&old_es, sb, ei);
+	if (ret)
+		return -EIO;
+
+	num_old_entries = old_es.num_entries;
+
+	ret = exfat_count_extra_entries(&old_es);
+	if (ret < 0)
+		goto put_old_es;
+	num_extra_entries = ret;
+	num_total_entries = num_new_entries + num_extra_entries;
+
+	if (num_old_entries < num_total_entries) {
 		int newentry;
 		struct exfat_chain dir;
 
 		newentry = exfat_find_empty_entry(parent_inode, &dir,
-				num_new_entries);
-		if (newentry < 0)
-			return newentry; /* -EIO or -ENOSPC */
+				num_total_entries);
+		if (newentry < 0) {
+			ret = newentry; /* -EIO or -ENOSPC */
+			goto put_old_es;
+		}
 
+		epold = exfat_get_dentry_cached(&old_es, ES_IDX_FILE);
 		epnew = exfat_get_dentry(sb, &dir, newentry, &new_bh);
-		if (!epnew)
-			return -EIO;
+		if (!epnew) {
+			ret = -EIO;
+			goto put_old_es;
+		}
 
 		*epnew = *epold;
 		if (exfat_get_entry_type(epnew) == TYPE_FILE) {
@@ -1049,33 +1078,43 @@ static int exfat_rename_file(struct inod
 			ei->attr |= ATTR_ARCHIVE;
 		}
 		exfat_update_bh(new_bh, sync);
-		brelse(old_bh);
 		brelse(new_bh);
 
-		epold = exfat_get_dentry(sb, &ei->dir, ei->entry + 1, &old_bh);
-		if (!epold)
-			return -EIO;
+		epold = exfat_get_dentry_cached(&old_es, ES_IDX_STREAM);
 		epnew = exfat_get_dentry(sb, &dir, newentry + 1, &new_bh);
 		if (!epnew) {
-			brelse(old_bh);
-			return -EIO;
+			/* Best-effort delete to avoid duplicate entries */
+			exfat_remove_entries(parent_inode, &dir, newentry, 0,
+				num_total_entries, false);
+			ret = -EIO;
+			goto put_old_es;
 		}
 
 		*epnew = *epold;
 		exfat_update_bh(new_bh, sync);
-		brelse(old_bh);
 		brelse(new_bh);
 
 		ret = exfat_init_ext_entry(parent_inode, &dir, newentry,
-			num_new_entries, p_uniname);
-		if (ret)
-			return ret;
+			num_new_entries, p_uniname, &old_es,
+			num_extra_entries);
+		if (ret) {
+			/* Best-effort delete to avoid duplicate entries */
+			exfat_remove_entries(parent_inode, &dir, newentry, 0,
+				num_total_entries, false);
+			goto put_old_es;
+		}
 
 		exfat_remove_entries(parent_inode, &ei->dir, ei->entry, 0,
-			num_old_entries);
+			num_old_entries, false);
 		ei->dir = dir;
 		ei->entry = newentry;
 	} else {
+		epold = exfat_get_dentry(sb, &ei->dir, ei->entry, &old_bh);
+		if (!epold) {
+			ret = -EIO;
+			goto put_old_es;
+		}
+
 		if (exfat_get_entry_type(epold) == TYPE_FILE) {
 			epold->dentry.file.attr |= cpu_to_le16(ATTR_ARCHIVE);
 			ei->attr |= ATTR_ARCHIVE;
@@ -1083,15 +1122,21 @@ static int exfat_rename_file(struct inod
 		exfat_update_bh(old_bh, sync);
 		brelse(old_bh);
 
-		exfat_remove_entries(parent_inode, &ei->dir, ei->entry,
-			ES_IDX_FIRST_FILENAME + 1, num_old_entries);
-
 		ret = exfat_init_ext_entry(parent_inode, &ei->dir, ei->entry,
-			num_new_entries, p_uniname);
+			num_new_entries, p_uniname, &old_es,
+			num_extra_entries);
 		if (ret)
-			return ret;
+			goto put_old_es;
+
+		/* Mark excess old entries as deleted (in-place shrink) */
+		exfat_remove_entries(parent_inode, &ei->dir, ei->entry,
+			num_total_entries, num_old_entries, false);
 	}
-	return 0;
+	ret = 0;
+
+put_old_es:
+	exfat_put_dentry_set(&old_es, false);
+	return ret;
 }
 
 static int exfat_move_file(struct inode *parent_inode,
@@ -1100,31 +1145,40 @@ static int exfat_move_file(struct inode
 	int ret, newentry, num_new_entries, num_old_entries;
 	struct exfat_dentry *epmov, *epnew;
 	struct super_block *sb = parent_inode->i_sb;
-	struct buffer_head *mov_bh, *new_bh;
+	struct exfat_entry_set_cache mov_es;
+	struct buffer_head *new_bh;
 	struct exfat_chain newdir;
-
-	epmov = exfat_get_dentry(sb, &ei->dir, ei->entry, &mov_bh);
-	if (!epmov)
-		return -EIO;
-
-	num_old_entries = exfat_count_ext_entries(sb, &ei->dir, ei->entry,
-		epmov);
-	if (num_old_entries < 0)
-		return -EIO;
-	num_old_entries++;
+	unsigned int num_extra_entries, num_total_entries;
 
 	num_new_entries = exfat_calc_num_entries(p_uniname);
 	if (num_new_entries < 0)
 		return num_new_entries;
 
+	ret = exfat_get_dentry_set_by_ei(&mov_es, sb, ei);
+	if (ret)
+		return -EIO;
+
+	num_old_entries = mov_es.num_entries;
+
+	ret = exfat_count_extra_entries(&mov_es);
+	if (ret < 0)
+		goto put_mov_es;
+	num_extra_entries = ret;
+	num_total_entries = num_new_entries + num_extra_entries;
+
 	newentry = exfat_find_empty_entry(parent_inode, &newdir,
-			num_new_entries);
-	if (newentry < 0)
-		return newentry; /* -EIO or -ENOSPC */
+			num_total_entries);
+	if (newentry < 0) {
+		ret = newentry; /* -EIO or -ENOSPC */
+		goto put_mov_es;
+	}
 
+	epmov = exfat_get_dentry_cached(&mov_es, ES_IDX_FILE);
 	epnew = exfat_get_dentry(sb, &newdir, newentry, &new_bh);
-	if (!epnew)
-		return -EIO;
+	if (!epnew) {
+		ret = -EIO;
+		goto put_mov_es;
+	}
 
 	*epnew = *epmov;
 	if (exfat_get_entry_type(epnew) == TYPE_FILE) {
@@ -1132,34 +1186,41 @@ static int exfat_move_file(struct inode
 		ei->attr |= ATTR_ARCHIVE;
 	}
 	exfat_update_bh(new_bh, IS_DIRSYNC(parent_inode));
-	brelse(mov_bh);
 	brelse(new_bh);
 
-	epmov = exfat_get_dentry(sb, &ei->dir, ei->entry + 1, &mov_bh);
-	if (!epmov)
-		return -EIO;
+	epmov = exfat_get_dentry_cached(&mov_es, ES_IDX_STREAM);
 	epnew = exfat_get_dentry(sb, &newdir, newentry + 1, &new_bh);
 	if (!epnew) {
-		brelse(mov_bh);
-		return -EIO;
+		/* Best-effort delete to avoid duplicate entries */
+		exfat_remove_entries(parent_inode, &newdir, newentry, 0,
+			num_total_entries, false);
+		ret = -EIO;
+		goto put_mov_es;
 	}
 
 	*epnew = *epmov;
 	exfat_update_bh(new_bh, IS_DIRSYNC(parent_inode));
-	brelse(mov_bh);
 	brelse(new_bh);
 
 	ret = exfat_init_ext_entry(parent_inode, &newdir, newentry,
-		num_new_entries, p_uniname);
-	if (ret)
-		return ret;
+		num_new_entries, p_uniname, &mov_es, num_extra_entries);
+	if (ret) {
+		/* Best-effort delete to avoid duplicate entries */
+		exfat_remove_entries(parent_inode, &newdir, newentry, 0,
+			num_total_entries, false);
+		goto put_mov_es;
+	}
 
 	exfat_remove_entries(parent_inode, &ei->dir, ei->entry, 0,
-		num_old_entries);
+		num_old_entries, false);
 
 	ei->dir = newdir;
 	ei->entry = newentry;
-	return 0;
+	ret = 0;
+
+put_mov_es:
+	exfat_put_dentry_set(&mov_es, false);
+	return ret;
 }
 
 /* rename or move a old file into a new file */
@@ -1243,7 +1304,7 @@ static int __exfat_rename(struct inode *
 		brelse(new_bh);
 
 		if (exfat_remove_entries(new_inode, &new_ei->dir, new_ei->entry,
-				0, num_entries + 1)) {
+				0, num_entries + 1, true)) {
 			ret = -EIO;
 			goto del_out;
 		}


