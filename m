Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9CB3B71A0;
	Tue, 21 Jul 2026 21:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667966; cv=none; b=Wa6tWWcBz44rnhvzP2AdhHzZeatFialV6XKe9yv/3LQtgGxKijKOqfpdSuii/QiO1786wBNh4BsiCcwQlZ9AApTRxu5G86yuMcAknP3/CaCiUL+OKPRez6UvQIxs7ZiG7Cok/d5hev3l+MEbFJW+zzGGQtGa8UWmCjURidGtZzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667966; c=relaxed/simple;
	bh=76A7eg6tbwBtLq+vqP0xDfn9gt86IeYfmlUWijC4D7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3Z0BzGpiXUH54XKUj6QIjMvn77FF88xC9x/AccQwT8uomil4pQcC/3908Kqcw40O37ZvfmNopm1lhxbD1i37xc69yUpcu823UIev0clkKfqdgHbeyACL9pQl5P67XaJX3poZ1jfYAhZB43r1URvux13L26NO6xrCK35KIt8pVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2U1hQLjc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2U1hQLjc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2FB1F000E9;
	Tue, 21 Jul 2026 21:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667964;
	bh=jIh1OJZoQMFTSTziL8sMtjezFrLXRK/gXx+XLCVUazw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2U1hQLjc2uPXUVj71qX8/bkxjalWUty0eBeo8fA1qFZF5+mFYujezCu6ZUlZj9uP1
	 mO/kpBEErN/LdVKRS6gwoi8oFbLe+OTUJmNWNpz34Fw0QNG2iVpSMEIbLQya0OciFH
	 I9na0Gibt4gVmpU1oFOtCtJpvpSFSqs3r9yWcIIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Aoyama Wataru <wataru.aoyama@sony.com>,
	Daniel Palmer <daniel.palmer@sony.com>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1243/1266] exfat: move exfat_chain_set() out of __exfat_resolve_path()
Date: Tue, 21 Jul 2026 17:28:00 +0200
Message-ID: <20260721152509.634554155@linuxfoundation.org>
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

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit 0891c7313d87a1b6baf7162bc2f0d755ce70383f ]

__exfat_resolve_path() mixes two functions. The first one is to
resolve and check if the path is valid. The second one is to output
the cluster assigned to the directory.

The second one is only needed when need to traverse the directory
entries, and calling exfat_chain_set() so early causes p_dir to be
passed as an argument multiple times, increasing the complexity of
the code.

This commit moves the call to exfat_chain_set() before traversing
directory entries.

Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Aoyama Wataru <wataru.aoyama@sony.com>
Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: 942296784b2a ("exfat: preserve benign secondary entries during rename and move")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/namei.c |   68 ++++++++++++++++++++++++-------------------------------
 1 file changed, 30 insertions(+), 38 deletions(-)

--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -343,6 +343,9 @@ static int exfat_find_empty_entry(struct
 		ei->hint_femp.eidx = EXFAT_HINT_NONE;
 	}
 
+	exfat_chain_set(p_dir, ei->start_clu,
+			EXFAT_B_TO_CLU(i_size_read(inode), sbi), ei->flags);
+
 	while ((dentry = exfat_search_empty_slot(sb, &hint_femp, p_dir,
 					num_entries)) < 0) {
 		if (dentry == -EIO)
@@ -419,14 +422,11 @@ static int exfat_find_empty_entry(struct
  * Zero if it was successful; otherwise nonzero.
  */
 static int __exfat_resolve_path(struct inode *inode, const unsigned char *path,
-		struct exfat_chain *p_dir, struct exfat_uni_name *p_uniname,
-		int lookup)
+		struct exfat_uni_name *p_uniname, int lookup)
 {
 	int namelen;
 	int lossy = NLS_NAME_NO_LOSSY;
 	struct super_block *sb = inode->i_sb;
-	struct exfat_sb_info *sbi = EXFAT_SB(sb);
-	struct exfat_inode_info *ei = EXFAT_I(inode);
 	int pathlen = strlen(path);
 
 	/*
@@ -465,24 +465,19 @@ static int __exfat_resolve_path(struct i
 	if ((lossy && !lookup) || !namelen)
 		return (lossy & NLS_NAME_OVERLEN) ? -ENAMETOOLONG : -EINVAL;
 
-	exfat_chain_set(p_dir, ei->start_clu,
-		EXFAT_B_TO_CLU(i_size_read(inode), sbi), ei->flags);
-
 	return 0;
 }
 
 static inline int exfat_resolve_path(struct inode *inode,
-		const unsigned char *path, struct exfat_chain *dir,
-		struct exfat_uni_name *uni)
+		const unsigned char *path, struct exfat_uni_name *uni)
 {
-	return __exfat_resolve_path(inode, path, dir, uni, 0);
+	return __exfat_resolve_path(inode, path, uni, 0);
 }
 
 static inline int exfat_resolve_path_for_lookup(struct inode *inode,
-		const unsigned char *path, struct exfat_chain *dir,
-		struct exfat_uni_name *uni)
+		const unsigned char *path, struct exfat_uni_name *uni)
 {
-	return __exfat_resolve_path(inode, path, dir, uni, 1);
+	return __exfat_resolve_path(inode, path, uni, 1);
 }
 
 static inline loff_t exfat_make_i_pos(struct exfat_dir_entry *info)
@@ -502,7 +497,7 @@ static int exfat_add_entry(struct inode
 	int clu_size = 0;
 	unsigned int start_clu = EXFAT_FREE_CLUSTER;
 
-	ret = exfat_resolve_path(inode, path, p_dir, &uniname);
+	ret = exfat_resolve_path(inode, path, &uniname);
 	if (ret)
 		goto out;
 
@@ -623,10 +618,13 @@ static int exfat_find(struct inode *dir,
 		return -ENOENT;
 
 	/* check the validity of directory name in the given pathname */
-	ret = exfat_resolve_path_for_lookup(dir, qname->name, &cdir, &uni_name);
+	ret = exfat_resolve_path_for_lookup(dir, qname->name, &uni_name);
 	if (ret)
 		return ret;
 
+	exfat_chain_set(&cdir, ei->start_clu,
+		EXFAT_B_TO_CLU(i_size_read(dir), sbi), ei->flags);
+
 	/* check the validation of hint_stat and initialize it if required */
 	if (ei->version != (inode_peek_iversion_raw(dir) & 0xffffffff)) {
 		ei->hint_stat.clu = cdir.dir;
@@ -1010,8 +1008,7 @@ unlock:
 }
 
 static int exfat_rename_file(struct inode *parent_inode,
-		struct exfat_chain *p_dir, struct exfat_uni_name *p_uniname,
-		struct exfat_inode_info *ei)
+		struct exfat_uni_name *p_uniname, struct exfat_inode_info *ei)
 {
 	int ret, num_old_entries, num_new_entries;
 	struct exfat_dentry *epold, *epnew;
@@ -1035,13 +1032,14 @@ static int exfat_rename_file(struct inod
 
 	if (num_old_entries < num_new_entries) {
 		int newentry;
+		struct exfat_chain dir;
 
-		newentry = exfat_find_empty_entry(parent_inode, p_dir,
+		newentry = exfat_find_empty_entry(parent_inode, &dir,
 				num_new_entries);
 		if (newentry < 0)
 			return newentry; /* -EIO or -ENOSPC */
 
-		epnew = exfat_get_dentry(sb, p_dir, newentry, &new_bh);
+		epnew = exfat_get_dentry(sb, &dir, newentry, &new_bh);
 		if (!epnew)
 			return -EIO;
 
@@ -1057,7 +1055,7 @@ static int exfat_rename_file(struct inod
 		epold = exfat_get_dentry(sb, &ei->dir, ei->entry + 1, &old_bh);
 		if (!epold)
 			return -EIO;
-		epnew = exfat_get_dentry(sb, p_dir, newentry + 1, &new_bh);
+		epnew = exfat_get_dentry(sb, &dir, newentry + 1, &new_bh);
 		if (!epnew) {
 			brelse(old_bh);
 			return -EIO;
@@ -1068,14 +1066,14 @@ static int exfat_rename_file(struct inod
 		brelse(old_bh);
 		brelse(new_bh);
 
-		ret = exfat_init_ext_entry(parent_inode, p_dir, newentry,
+		ret = exfat_init_ext_entry(parent_inode, &dir, newentry,
 			num_new_entries, p_uniname);
 		if (ret)
 			return ret;
 
 		exfat_remove_entries(parent_inode, &ei->dir, ei->entry, 0,
 			num_old_entries);
-		ei->dir = *p_dir;
+		ei->dir = dir;
 		ei->entry = newentry;
 	} else {
 		if (exfat_get_entry_type(epold) == TYPE_FILE) {
@@ -1097,13 +1095,13 @@ static int exfat_rename_file(struct inod
 }
 
 static int exfat_move_file(struct inode *parent_inode,
-		struct exfat_chain *p_newdir, struct exfat_uni_name *p_uniname,
-		struct exfat_inode_info *ei)
+		struct exfat_uni_name *p_uniname, struct exfat_inode_info *ei)
 {
 	int ret, newentry, num_new_entries, num_old_entries;
 	struct exfat_dentry *epmov, *epnew;
 	struct super_block *sb = parent_inode->i_sb;
 	struct buffer_head *mov_bh, *new_bh;
+	struct exfat_chain newdir;
 
 	epmov = exfat_get_dentry(sb, &ei->dir, ei->entry, &mov_bh);
 	if (!epmov)
@@ -1119,12 +1117,12 @@ static int exfat_move_file(struct inode
 	if (num_new_entries < 0)
 		return num_new_entries;
 
-	newentry = exfat_find_empty_entry(parent_inode, p_newdir,
+	newentry = exfat_find_empty_entry(parent_inode, &newdir,
 			num_new_entries);
 	if (newentry < 0)
 		return newentry; /* -EIO or -ENOSPC */
 
-	epnew = exfat_get_dentry(sb, p_newdir, newentry, &new_bh);
+	epnew = exfat_get_dentry(sb, &newdir, newentry, &new_bh);
 	if (!epnew)
 		return -EIO;
 
@@ -1140,7 +1138,7 @@ static int exfat_move_file(struct inode
 	epmov = exfat_get_dentry(sb, &ei->dir, ei->entry + 1, &mov_bh);
 	if (!epmov)
 		return -EIO;
-	epnew = exfat_get_dentry(sb, p_newdir, newentry + 1, &new_bh);
+	epnew = exfat_get_dentry(sb, &newdir, newentry + 1, &new_bh);
 	if (!epnew) {
 		brelse(mov_bh);
 		return -EIO;
@@ -1151,7 +1149,7 @@ static int exfat_move_file(struct inode
 	brelse(mov_bh);
 	brelse(new_bh);
 
-	ret = exfat_init_ext_entry(parent_inode, p_newdir, newentry,
+	ret = exfat_init_ext_entry(parent_inode, &newdir, newentry,
 		num_new_entries, p_uniname);
 	if (ret)
 		return ret;
@@ -1159,9 +1157,7 @@ static int exfat_move_file(struct inode
 	exfat_remove_entries(parent_inode, &ei->dir, ei->entry, 0,
 		num_old_entries);
 
-	exfat_chain_set(&ei->dir, p_newdir->dir, p_newdir->size,
-		p_newdir->flags);
-
+	ei->dir = newdir;
 	ei->entry = newentry;
 	return 0;
 }
@@ -1172,7 +1168,6 @@ static int __exfat_rename(struct inode *
 		struct dentry *new_dentry)
 {
 	int ret;
-	struct exfat_chain newdir;
 	struct exfat_uni_name uni_name;
 	struct super_block *sb = old_parent_inode->i_sb;
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
@@ -1217,19 +1212,16 @@ static int __exfat_rename(struct inode *
 	}
 
 	/* check the validity of directory name in the given new pathname */
-	ret = exfat_resolve_path(new_parent_inode, new_path, &newdir,
-			&uni_name);
+	ret = exfat_resolve_path(new_parent_inode, new_path, &uni_name);
 	if (ret)
 		goto out;
 
 	exfat_set_volume_dirty(sb);
 
 	if (new_parent_inode == old_parent_inode)
-		ret = exfat_rename_file(new_parent_inode, &newdir,
-				&uni_name, ei);
+		ret = exfat_rename_file(new_parent_inode, &uni_name, ei);
 	else
-		ret = exfat_move_file(new_parent_inode, &newdir,
-				&uni_name, ei);
+		ret = exfat_move_file(new_parent_inode, &uni_name, ei);
 
 	if (!ret && new_inode) {
 		struct exfat_dentry *ep;


