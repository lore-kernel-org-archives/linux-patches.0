Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D6C46D2DA;
	Tue, 21 Jul 2026 17:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655458; cv=none; b=rmuhNKM0xo4c4X6Lj4Qd1V5Xk12jTwGvC1qaDILkf66Jue6+tDyA22Y4FHpJP3yxuGJFLb41bqL7mVRiJORtavnzTaiGOSFKaRkxRPsYjpebuZcXw/Yf97os64zUA1DsYBVT5mkoiQrTWKsT3tQI/1CJCWpTl5yurgZDclu+9zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655458; c=relaxed/simple;
	bh=AqLISb0BB9YfbuCRCH/n1COJhGYPrGSIJ6dFlNcFH2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/TUIU5J+Bs68Qz4b27Ys48Wj+GJqkX0ZuDlctFY+HQVK3kDi7tY2GOeJc06GaaXPUaSPhgdrc+jg/xwY49/QMei2Lu4hxPjSeDVP7SaQK9hWKea6SNfbNL3MRjSHBIPz65SRfYerB3EEb6D8FyqXIsPyzajm5OkGEa4+zs1sVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MbKj/Ox0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MbKj/Ox0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4E41F000E9;
	Tue, 21 Jul 2026 17:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655457;
	bh=LVkQQLb4/MR9G+A3oKCPzP6gIbDNPsIlQy8L7Zyna4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MbKj/Ox08KC38H+aRQGQhtMRTO3g7guhdL6hi25eVuOXhO10e2VtpTKcLyOBjQAZ0
	 ESYHSpTlRx4G6hjJqCLgUHgAp1SqfgCEfbcMqi5msRZ7WRgDO0LcxoAnNxoHS9kjYw
	 GU2ygbFstpCTttdwEvCPq9wW0R+V+dbn6ft4I1RM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rochan Avlur <rochan.avlur@gmail.com>,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0017/1611] exfat: preserve benign secondary entries during rename and move
Date: Tue, 21 Jul 2026 17:02:13 +0200
Message-ID: <20260721152515.181346382@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Rochan Avlur <rochan.avlur@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/dir.c      | 49 ++++++++++++++++++++++---
 fs/exfat/exfat_fs.h |  5 ++-
 fs/exfat/namei.c    | 89 +++++++++++++++++++++++++++++++++++----------
 3 files changed, 116 insertions(+), 27 deletions(-)

diff --git a/fs/exfat/dir.c b/fs/exfat/dir.c
index e1b28c1a7e8576..1f6cb533a48d18 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -481,31 +481,70 @@ static void exfat_free_benign_secondary_clusters(struct inode *inode,
 	exfat_free_cluster(inode, &dir);
 }
 
+/*
+ * exfat_init_ext_entry - initialize extension entries in a directory entry set
+ * @es:          target entry set
+ * @num_entries: number of entries excluding benign secondary entries
+ * @p_uniname:   filename to store
+ * @old_es:      optional source entry set with benign secondary entries, or NULL
+ * @num_extra:   number of benign secondary entries to copy from @old_es
+ *
+ * Set up the file, stream extension, and filename entries in @es, optionally
+ * preserving @num_extra benign secondary entries from @old_es.  @es and @old_es
+ * may refer to the same entry set; excess entries are marked as deleted.
+ */
 void exfat_init_ext_entry(struct exfat_entry_set_cache *es, int num_entries,
-		struct exfat_uni_name *p_uniname)
+		struct exfat_uni_name *p_uniname,
+		struct exfat_entry_set_cache *old_es, int num_extra)
 {
-	int i;
+	int i, src_start = 0, old_num;
 	unsigned short *uniname = p_uniname->name;
 	struct exfat_dentry *ep;
 
+	if (WARN_ON(num_extra < 0 || (num_extra && (!old_es ||
+		    old_es->num_entries < ES_IDX_FIRST_FILENAME + num_extra))))
+		num_extra = 0;
+
+	/*
+	 * Save old entry count and source position before modifying
+	 * es->num_entries, since old_es and es may point to the same
+	 * entry set.
+	 */
+	old_num = es->num_entries;
+	if (old_es && num_extra > 0)
+		src_start = old_es->num_entries - num_extra;
+
+	es->num_entries = num_entries + num_extra;
 	ep = exfat_get_dentry_cached(es, ES_IDX_FILE);
-	ep->dentry.file.num_ext = (unsigned char)(num_entries - 1);
+	ep->dentry.file.num_ext = (unsigned char)(num_entries - 1 + num_extra);
 
 	ep = exfat_get_dentry_cached(es, ES_IDX_STREAM);
 	ep->dentry.stream.name_len = p_uniname->name_len;
 	ep->dentry.stream.name_hash = cpu_to_le16(p_uniname->name_hash);
 
+	if (old_es && num_extra > 0) {
+		for (i = 0; i < num_extra; i++)
+			*exfat_get_dentry_cached(es, num_entries + i) =
+				*exfat_get_dentry_cached(old_es, src_start + i);
+	}
+
 	for (i = ES_IDX_FIRST_FILENAME; i < num_entries; i++) {
 		ep = exfat_get_dentry_cached(es, i);
 		exfat_init_name_entry(ep, uniname);
 		uniname += EXFAT_FILE_NAME_LEN;
 	}
 
+	/* Mark excess old entries as deleted (in-place shrink) */
+	for (i = num_entries + num_extra; i < old_num; i++) {
+		ep = exfat_get_dentry_cached(es, i);
+		exfat_set_entry_type(ep, TYPE_DELETED);
+	}
+
 	exfat_update_dir_chksum(es);
 }
 
 void exfat_remove_entries(struct inode *inode, struct exfat_entry_set_cache *es,
-		int order)
+		int order, bool free_benign)
 {
 	int i;
 	struct exfat_dentry *ep;
@@ -513,7 +552,7 @@ void exfat_remove_entries(struct inode *inode, struct exfat_entry_set_cache *es,
 	for (i = order; i < es->num_entries; i++) {
 		ep = exfat_get_dentry_cached(es, i);
 
-		if (exfat_get_entry_type(ep) & TYPE_BENIGN_SEC)
+		if (free_benign && (exfat_get_entry_type(ep) & TYPE_BENIGN_SEC))
 			exfat_free_benign_secondary_clusters(inode, ep);
 
 		exfat_set_entry_type(ep, TYPE_DELETED);
diff --git a/fs/exfat/exfat_fs.h b/fs/exfat/exfat_fs.h
index 38210fb6901c09..9a85270f8493f9 100644
--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -496,9 +496,10 @@ void exfat_init_dir_entry(struct exfat_entry_set_cache *es,
 		unsigned int type, unsigned int start_clu,
 		unsigned long long size, struct timespec64 *ts);
 void exfat_init_ext_entry(struct exfat_entry_set_cache *es, int num_entries,
-		struct exfat_uni_name *p_uniname);
+		struct exfat_uni_name *p_uniname,
+		struct exfat_entry_set_cache *old_es, int num_extra);
 void exfat_remove_entries(struct inode *inode, struct exfat_entry_set_cache *es,
-		int order);
+		int order, bool free_benign);
 void exfat_update_dir_chksum(struct exfat_entry_set_cache *es);
 int exfat_calc_num_entries(struct exfat_uni_name *p_uniname);
 int exfat_find_dir_entry(struct super_block *sb, struct exfat_inode_info *ei,
diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index dfe957493d49ee..6b544df0a03a68 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -509,7 +509,7 @@ static int exfat_add_entry(struct inode *inode, const char *path,
 	 * the first cluster is not determined yet. (0)
 	 */
 	exfat_init_dir_entry(&es, type, start_clu, clu_size, &ts);
-	exfat_init_ext_entry(&es, num_entries, &uniname);
+	exfat_init_ext_entry(&es, num_entries, &uniname, NULL, 0);
 
 	ret = exfat_put_dentry_set(&es, IS_DIRSYNC(inode));
 	if (ret)
@@ -820,7 +820,7 @@ static int exfat_unlink(struct inode *dir, struct dentry *dentry)
 	exfat_set_volume_dirty(sb);
 
 	/* update the directory entry */
-	exfat_remove_entries(inode, &es, ES_IDX_FILE);
+	exfat_remove_entries(inode, &es, ES_IDX_FILE, true);
 
 	err = exfat_put_dentry_set(&es, IS_DIRSYNC(inode));
 	if (err)
@@ -981,7 +981,7 @@ static int exfat_rmdir(struct inode *dir, struct dentry *dentry)
 
 	exfat_set_volume_dirty(sb);
 
-	exfat_remove_entries(inode, &es, ES_IDX_FILE);
+	exfat_remove_entries(inode, &es, ES_IDX_FILE, true);
 
 	err = exfat_put_dentry_set(&es, IS_DIRSYNC(dir));
 	if (err)
@@ -1008,6 +1008,23 @@ static int exfat_rmdir(struct inode *dir, struct dentry *dentry)
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
@@ -1016,6 +1033,7 @@ static int exfat_rename_file(struct inode *parent_inode,
 	struct super_block *sb = parent_inode->i_sb;
 	struct exfat_entry_set_cache old_es, new_es;
 	int sync = IS_DIRSYNC(parent_inode);
+	unsigned int num_extra_entries, num_total_entries;
 
 	if (unlikely(exfat_forced_shutdown(sb)))
 		return -EIO;
@@ -1025,19 +1043,23 @@ static int exfat_rename_file(struct inode *parent_inode,
 		return num_new_entries;
 
 	ret = exfat_get_dentry_set_by_ei(&old_es, sb, ei);
-	if (ret) {
-		ret = -EIO;
-		return ret;
-	}
+	if (ret)
+		return -EIO;
 
 	epold = exfat_get_dentry_cached(&old_es, ES_IDX_FILE);
 
-	if (old_es.num_entries < num_new_entries) {
+	ret = exfat_count_extra_entries(&old_es);
+	if (ret < 0)
+		goto put_old_es;
+	num_extra_entries = ret;
+	num_total_entries = num_new_entries + num_extra_entries;
+
+	if (old_es.num_entries < num_total_entries) {
 		int newentry;
 		struct exfat_chain dir;
 
 		newentry = exfat_find_empty_entry(parent_inode, &dir,
-				num_new_entries, &new_es);
+				num_total_entries, &new_es);
 		if (newentry < 0) {
 			ret = newentry; /* -EIO or -ENOSPC */
 			goto put_old_es;
@@ -1054,13 +1076,23 @@ static int exfat_rename_file(struct inode *parent_inode,
 		epnew = exfat_get_dentry_cached(&new_es, ES_IDX_STREAM);
 		*epnew = *epold;
 
-		exfat_init_ext_entry(&new_es, num_new_entries, p_uniname);
+		exfat_init_ext_entry(&new_es, num_new_entries, p_uniname,
+				     &old_es, num_extra_entries);
 
 		ret = exfat_put_dentry_set(&new_es, sync);
-		if (ret)
+		if (ret) {
+			/* Best-effort delete to avoid duplicate entries */
+			if (!exfat_get_dentry_set(&new_es, sb,
+						  &dir, newentry,
+						  ES_ALL_ENTRIES)) {
+				exfat_remove_entries(parent_inode, &new_es,
+						    ES_IDX_FILE, false);
+				exfat_put_dentry_set(&new_es, false);
+			}
 			goto put_old_es;
+		}
 
-		exfat_remove_entries(parent_inode, &old_es, ES_IDX_FILE);
+		exfat_remove_entries(parent_inode, &old_es, ES_IDX_FILE, false);
 		ei->dir = dir;
 		ei->entry = newentry;
 	} else {
@@ -1069,8 +1101,8 @@ static int exfat_rename_file(struct inode *parent_inode,
 			ei->attr |= EXFAT_ATTR_ARCHIVE;
 		}
 
-		exfat_remove_entries(parent_inode, &old_es, ES_IDX_FIRST_FILENAME + 1);
-		exfat_init_ext_entry(&old_es, num_new_entries, p_uniname);
+		exfat_init_ext_entry(&old_es, num_new_entries, p_uniname,
+				     &old_es, num_extra_entries);
 	}
 	return exfat_put_dentry_set(&old_es, sync);
 
@@ -1086,6 +1118,7 @@ static int exfat_move_file(struct inode *parent_inode,
 	struct exfat_dentry *epmov, *epnew;
 	struct exfat_entry_set_cache mov_es, new_es;
 	struct exfat_chain newdir;
+	unsigned int num_extra_entries, num_total_entries;
 
 	num_new_entries = exfat_calc_num_entries(p_uniname);
 	if (num_new_entries < 0)
@@ -1095,8 +1128,14 @@ static int exfat_move_file(struct inode *parent_inode,
 	if (ret)
 		return -EIO;
 
+	ret = exfat_count_extra_entries(&mov_es);
+	if (ret < 0)
+		goto put_mov_es;
+	num_extra_entries = ret;
+	num_total_entries = num_new_entries + num_extra_entries;
+
 	newentry = exfat_find_empty_entry(parent_inode, &newdir,
-			num_new_entries, &new_es);
+			num_total_entries, &new_es);
 	if (newentry < 0) {
 		ret = newentry; /* -EIO or -ENOSPC */
 		goto put_mov_es;
@@ -1114,21 +1153,31 @@ static int exfat_move_file(struct inode *parent_inode,
 	epnew = exfat_get_dentry_cached(&new_es, ES_IDX_STREAM);
 	*epnew = *epmov;
 
-	exfat_init_ext_entry(&new_es, num_new_entries, p_uniname);
-	exfat_remove_entries(parent_inode, &mov_es, ES_IDX_FILE);
+	exfat_init_ext_entry(&new_es, num_new_entries, p_uniname,
+			     &mov_es, num_extra_entries);
+
+	exfat_remove_entries(parent_inode, &mov_es, ES_IDX_FILE, false);
 
 	ei->dir = newdir;
 	ei->entry = newentry;
 
 	ret = exfat_put_dentry_set(&new_es, IS_DIRSYNC(parent_inode));
-	if (ret)
+	if (ret) {
+		/* Best-effort delete to avoid duplicate entries */
+		if (!exfat_get_dentry_set(&new_es, parent_inode->i_sb,
+					  &newdir, newentry,
+					  ES_ALL_ENTRIES)) {
+			exfat_remove_entries(parent_inode, &new_es,
+					    ES_IDX_FILE, false);
+			exfat_put_dentry_set(&new_es, false);
+		}
 		goto put_mov_es;
+	}
 
 	return exfat_put_dentry_set(&mov_es, IS_DIRSYNC(parent_inode));
 
 put_mov_es:
 	exfat_put_dentry_set(&mov_es, false);
-
 	return ret;
 }
 
@@ -1202,7 +1251,7 @@ static int __exfat_rename(struct inode *old_parent_inode,
 			goto del_out;
 		}
 
-		exfat_remove_entries(new_inode, &es, ES_IDX_FILE);
+		exfat_remove_entries(new_inode, &es, ES_IDX_FILE, true);
 
 		ret = exfat_put_dentry_set(&es, IS_DIRSYNC(new_inode));
 		if (ret)
-- 
2.53.0



