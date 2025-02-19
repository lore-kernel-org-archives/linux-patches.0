Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE201E102A;
	Wed, 19 Feb 2025 09:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956628; cv=none; b=GE7xSU1tdcjlK6Gpja4fGSaj4FSxb4f8jYOx1wZW/5zyMCDVxklVSL3xJVnF5FZdCZ+GTPbzaHwIm+V7tIT5tIam9iNN8H5gsuHayI6Gfy32ONVA0EtfxtOZ8ySHw85PpbWJ6pHJzWRQkRC7WwJCkBa5QELy9iWgvaJjIdQCdUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956628; c=relaxed/simple;
	bh=my6+mdjX3QnBUbf8Buu4/3nloMohav2TV4+4Iu1ruOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dKXtF3fyfSyfy1vZlTFCQiKYXpzwUaypAYNtGE12UjGP7ooRsN4uiKOetRFj839mcYe8zQWGn3fK9q6nTI77wp/E09ZtTReShWrMKwuC8rNWz9MyqxBEXhOjf2MhhfSBU+1/kUvXzAQpaFvPzZN5zwCq/5NFo2rjr7aklo1zHBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QmBlrsZ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QmBlrsZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C7FC4CED1;
	Wed, 19 Feb 2025 09:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956628;
	bh=my6+mdjX3QnBUbf8Buu4/3nloMohav2TV4+4Iu1ruOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QmBlrsZ61fVxjUZ3XjdLyju4Yd2FUyVwl6E9W98cVsNBen0MFLFqeEDpCnh9LnILm
	 Q3FjSDUN8XkbFZINOlihnMIqzist1o0Jpoo6B3pT1B8JAbaWA58GcQYgvq/P7R+GXf
	 y/JCgbsWOTpN8zeAZnwZa8uhxDLXZcLRyRoqMq4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Lee <chullee@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Daniel Rosenberg <drosen@google.com>
Subject: [PATCH 6.1 243/578] f2fs: Introduce linear search for dentries
Date: Wed, 19 Feb 2025 09:24:07 +0100
Message-ID: <20250219082702.594909479@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Daniel Lee <chullee@google.com>

commit 91b587ba79e1b68bb718d12b0758dbcdab4e9cb7 upstream.

This patch addresses an issue where some files in case-insensitive
directories become inaccessible due to changes in how the kernel function,
utf8_casefold(), generates case-folded strings from the commit 5c26d2f1d3f5
("unicode: Don't special case ignorable code points").

F2FS uses these case-folded names to calculate hash values for locating
dentries and stores them on disk. Since utf8_casefold() can produce
different output across kernel versions, stored hash values and newly
calculated hash values may differ. This results in affected files no
longer being found via the hash-based lookup.

To resolve this, the patch introduces a linear search fallback.
If the initial hash-based search fails, F2FS will sequentially scan the
directory entries.

Fixes: 5c26d2f1d3f5 ("unicode: Don't special case ignorable code points")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219586
Signed-off-by: Daniel Lee <chullee@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Daniel Rosenberg <drosen@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/dir.c    |   53 ++++++++++++++++++++++++++++++++++++++---------------
 fs/f2fs/f2fs.h   |    6 ++++--
 fs/f2fs/inline.c |    5 +++--
 3 files changed, 45 insertions(+), 19 deletions(-)

--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -199,7 +199,8 @@ static unsigned long dir_block_index(uns
 static struct f2fs_dir_entry *find_in_block(struct inode *dir,
 				struct page *dentry_page,
 				const struct f2fs_filename *fname,
-				int *max_slots)
+				int *max_slots,
+				bool use_hash)
 {
 	struct f2fs_dentry_block *dentry_blk;
 	struct f2fs_dentry_ptr d;
@@ -207,7 +208,7 @@ static struct f2fs_dir_entry *find_in_bl
 	dentry_blk = (struct f2fs_dentry_block *)page_address(dentry_page);
 
 	make_dentry_ptr_block(dir, &d, dentry_blk);
-	return f2fs_find_target_dentry(&d, fname, max_slots);
+	return f2fs_find_target_dentry(&d, fname, max_slots, use_hash);
 }
 
 #if IS_ENABLED(CONFIG_UNICODE)
@@ -284,7 +285,8 @@ static inline int f2fs_match_name(const
 }
 
 struct f2fs_dir_entry *f2fs_find_target_dentry(const struct f2fs_dentry_ptr *d,
-			const struct f2fs_filename *fname, int *max_slots)
+			const struct f2fs_filename *fname, int *max_slots,
+			bool use_hash)
 {
 	struct f2fs_dir_entry *de;
 	unsigned long bit_pos = 0;
@@ -307,7 +309,7 @@ struct f2fs_dir_entry *f2fs_find_target_
 			continue;
 		}
 
-		if (de->hash_code == fname->hash) {
+		if (!use_hash || de->hash_code == fname->hash) {
 			res = f2fs_match_name(d->inode, fname,
 					      d->filename[bit_pos],
 					      le16_to_cpu(de->name_len));
@@ -334,11 +336,12 @@ found:
 static struct f2fs_dir_entry *find_in_level(struct inode *dir,
 					unsigned int level,
 					const struct f2fs_filename *fname,
-					struct page **res_page)
+					struct page **res_page,
+					bool use_hash)
 {
 	int s = GET_DENTRY_SLOTS(fname->disk_name.len);
 	unsigned int nbucket, nblock;
-	unsigned int bidx, end_block;
+	unsigned int bidx, end_block, bucket_no;
 	struct page *dentry_page;
 	struct f2fs_dir_entry *de = NULL;
 	pgoff_t next_pgofs;
@@ -348,8 +351,11 @@ static struct f2fs_dir_entry *find_in_le
 	nbucket = dir_buckets(level, F2FS_I(dir)->i_dir_level);
 	nblock = bucket_blocks(level);
 
+	bucket_no = use_hash ? le32_to_cpu(fname->hash) % nbucket : 0;
+
+start_find_bucket:
 	bidx = dir_block_index(level, F2FS_I(dir)->i_dir_level,
-			       le32_to_cpu(fname->hash) % nbucket);
+			       bucket_no);
 	end_block = bidx + nblock;
 
 	while (bidx < end_block) {
@@ -366,7 +372,7 @@ static struct f2fs_dir_entry *find_in_le
 			}
 		}
 
-		de = find_in_block(dir, dentry_page, fname, &max_slots);
+		de = find_in_block(dir, dentry_page, fname, &max_slots, use_hash);
 		if (IS_ERR(de)) {
 			*res_page = ERR_CAST(de);
 			de = NULL;
@@ -383,12 +389,18 @@ static struct f2fs_dir_entry *find_in_le
 		bidx++;
 	}
 
-	if (!de && room && F2FS_I(dir)->chash != fname->hash) {
-		F2FS_I(dir)->chash = fname->hash;
-		F2FS_I(dir)->clevel = level;
-	}
+	if (de)
+		return de;
 
-	return de;
+	if (likely(use_hash)) {
+		if (room && F2FS_I(dir)->chash != fname->hash) {
+			F2FS_I(dir)->chash = fname->hash;
+			F2FS_I(dir)->clevel = level;
+		}
+	} else if (++bucket_no < nbucket) {
+		goto start_find_bucket;
+	}
+	return NULL;
 }
 
 struct f2fs_dir_entry *__f2fs_find_entry(struct inode *dir,
@@ -399,11 +411,15 @@ struct f2fs_dir_entry *__f2fs_find_entry
 	struct f2fs_dir_entry *de = NULL;
 	unsigned int max_depth;
 	unsigned int level;
+	bool use_hash = true;
 
 	*res_page = NULL;
 
+#if IS_ENABLED(CONFIG_UNICODE)
+start_find_entry:
+#endif
 	if (f2fs_has_inline_dentry(dir)) {
-		de = f2fs_find_in_inline_dir(dir, fname, res_page);
+		de = f2fs_find_in_inline_dir(dir, fname, res_page, use_hash);
 		goto out;
 	}
 
@@ -419,11 +435,18 @@ struct f2fs_dir_entry *__f2fs_find_entry
 	}
 
 	for (level = 0; level < max_depth; level++) {
-		de = find_in_level(dir, level, fname, res_page);
+		de = find_in_level(dir, level, fname, res_page, use_hash);
 		if (de || IS_ERR(*res_page))
 			break;
 	}
+
 out:
+#if IS_ENABLED(CONFIG_UNICODE)
+	if (IS_CASEFOLDED(dir) && !de && use_hash) {
+		use_hash = false;
+		goto start_find_entry;
+	}
+#endif
 	/* This is to increase the speed of f2fs_create */
 	if (!de)
 		F2FS_I(dir)->task = current;
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3487,7 +3487,8 @@ int f2fs_prepare_lookup(struct inode *di
 			struct f2fs_filename *fname);
 void f2fs_free_filename(struct f2fs_filename *fname);
 struct f2fs_dir_entry *f2fs_find_target_dentry(const struct f2fs_dentry_ptr *d,
-			const struct f2fs_filename *fname, int *max_slots);
+			const struct f2fs_filename *fname, int *max_slots,
+			bool use_hash);
 int f2fs_fill_dentries(struct dir_context *ctx, struct f2fs_dentry_ptr *d,
 			unsigned int start_pos, struct fscrypt_str *fstr);
 void f2fs_do_make_empty_dir(struct inode *inode, struct inode *parent,
@@ -4100,7 +4101,8 @@ int f2fs_write_inline_data(struct inode
 int f2fs_recover_inline_data(struct inode *inode, struct page *npage);
 struct f2fs_dir_entry *f2fs_find_in_inline_dir(struct inode *dir,
 					const struct f2fs_filename *fname,
-					struct page **res_page);
+					struct page **res_page,
+					bool use_hash);
 int f2fs_make_empty_inline_dir(struct inode *inode, struct inode *parent,
 			struct page *ipage);
 int f2fs_add_inline_entry(struct inode *dir, const struct f2fs_filename *fname,
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -336,7 +336,8 @@ process_inline:
 
 struct f2fs_dir_entry *f2fs_find_in_inline_dir(struct inode *dir,
 					const struct f2fs_filename *fname,
-					struct page **res_page)
+					struct page **res_page,
+					bool use_hash)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
 	struct f2fs_dir_entry *de;
@@ -353,7 +354,7 @@ struct f2fs_dir_entry *f2fs_find_in_inli
 	inline_dentry = inline_data_addr(dir, ipage);
 
 	make_dentry_ptr_inline(dir, &d, inline_dentry);
-	de = f2fs_find_target_dentry(&d, fname, NULL);
+	de = f2fs_find_target_dentry(&d, fname, NULL, use_hash);
 	unlock_page(ipage);
 	if (IS_ERR(de)) {
 		*res_page = ERR_CAST(de);


