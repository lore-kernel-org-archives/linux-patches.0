Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EC71DDF5;
	Tue, 16 Jul 2024 15:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144640; cv=none; b=Fei0wjI64vYh/H95jSt3LcsHMjpLvE6X1+uO4qMQO/XXnw9FQE2L1cULKDWF8dYA0w2BjleU/p9e/DXOybqtL6dtdlMZV2SFrfmUNnuOWo6lQITB2ps+pbwIAd9zOtHxSGM/FJRFAcvGbWUqiBAViA89tXW+/QxD8mpbX4w6bZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144640; c=relaxed/simple;
	bh=IhVZ08qq/67jTEwaFYd8tjMTZM6c0YJupWHY5JYFh90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IV1Z/7ybP8RxMln3mJjPCLev42ukMF1Z8dqjhkohtpV+9fuxKHiulEn6itE44JKIBzqk1oTkS8L7gm5fIbFOzczJd+TDPoZoHYwF1uRlfTW/7xcTlDBj7Ruka+vT9irVlpTxbojPU1bO+Y4PuU4h41vuEawfEEhMGxPuKeuQGZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4mF/nSX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4mF/nSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB09C116B1;
	Tue, 16 Jul 2024 15:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144639;
	bh=IhVZ08qq/67jTEwaFYd8tjMTZM6c0YJupWHY5JYFh90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4mF/nSXo/cn0fVT0Y5TR2ijtZfezLKdZ+fcApyyEz037aYvBlU1F/t8YALRyM92v
	 P4s5ceWCGytWMCBrkhRN7ad/QpIyPwpyg7bK2Kx81a3X3mduL2gl2CJEVuJO5GrFmA
	 klyJ79jjuc2vN0q5DPVJC0UIDCQqyRJ09225Q10A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Hillf Danton <hdanton@sina.com>,
	Jan Kara <jack@suse.cz>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 057/108] nilfs2: fix incorrect inode allocation from reserved inodes
Date: Tue, 16 Jul 2024 17:31:12 +0200
Message-ID: <20240716152748.176249571@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 93aef9eda1cea9e84ab2453fcceb8addad0e46f1 upstream.

If the bitmap block that manages the inode allocation status is corrupted,
nilfs_ifile_create_inode() may allocate a new inode from the reserved
inode area where it should not be allocated.

Previous fix commit d325dc6eb763 ("nilfs2: fix use-after-free bug of
struct nilfs_root"), fixed the problem that reserved inodes with inode
numbers less than NILFS_USER_INO (=11) were incorrectly reallocated due to
bitmap corruption, but since the start number of non-reserved inodes is
read from the super block and may change, in which case inode allocation
may occur from the extended reserved inode area.

If that happens, access to that inode will cause an IO error, causing the
file system to degrade to an error state.

Fix this potential issue by adding a wraparound option to the common
metadata object allocation routine and by modifying
nilfs_ifile_create_inode() to disable the option so that it only allocates
inodes with inode numbers greater than or equal to the inode number read
in "nilfs->ns_first_ino", regardless of the bitmap status of reserved
inodes.

Link: https://lkml.kernel.org/r/20240623051135.4180-4-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/alloc.c |   18 ++++++++++++++----
 fs/nilfs2/alloc.h |    4 ++--
 fs/nilfs2/dat.c   |    2 +-
 fs/nilfs2/ifile.c |    7 ++-----
 4 files changed, 19 insertions(+), 12 deletions(-)

--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -377,11 +377,12 @@ void *nilfs_palloc_block_get_entry(const
  * @target: offset number of an entry in the group (start point)
  * @bsize: size in bits
  * @lock: spin lock protecting @bitmap
+ * @wrap: whether to wrap around
  */
 static int nilfs_palloc_find_available_slot(unsigned char *bitmap,
 					    unsigned long target,
 					    unsigned int bsize,
-					    spinlock_t *lock)
+					    spinlock_t *lock, bool wrap)
 {
 	int pos, end = bsize;
 
@@ -397,6 +398,8 @@ static int nilfs_palloc_find_available_s
 
 		end = target;
 	}
+	if (!wrap)
+		return -ENOSPC;
 
 	/* wrap around */
 	for (pos = 0; pos < end; pos++) {
@@ -495,9 +498,10 @@ int nilfs_palloc_count_max_entries(struc
  * nilfs_palloc_prepare_alloc_entry - prepare to allocate a persistent object
  * @inode: inode of metadata file using this allocator
  * @req: nilfs_palloc_req structure exchanged for the allocation
+ * @wrap: whether to wrap around
  */
 int nilfs_palloc_prepare_alloc_entry(struct inode *inode,
-				     struct nilfs_palloc_req *req)
+				     struct nilfs_palloc_req *req, bool wrap)
 {
 	struct buffer_head *desc_bh, *bitmap_bh;
 	struct nilfs_palloc_group_desc *desc;
@@ -516,7 +520,7 @@ int nilfs_palloc_prepare_alloc_entry(str
 	entries_per_group = nilfs_palloc_entries_per_group(inode);
 
 	for (i = 0; i < ngroups; i += n) {
-		if (group >= ngroups) {
+		if (group >= ngroups && wrap) {
 			/* wrap around */
 			group = 0;
 			maxgroup = nilfs_palloc_group(inode, req->pr_entry_nr,
@@ -541,7 +545,13 @@ int nilfs_palloc_prepare_alloc_entry(str
 				bitmap = bitmap_kaddr + bh_offset(bitmap_bh);
 				pos = nilfs_palloc_find_available_slot(
 					bitmap, group_offset,
-					entries_per_group, lock);
+					entries_per_group, lock, wrap);
+				/*
+				 * Since the search for a free slot in the
+				 * second and subsequent bitmap blocks always
+				 * starts from the beginning, the wrap flag
+				 * only has an effect on the first search.
+				 */
 				if (pos >= 0) {
 					/* found a free entry */
 					nilfs_palloc_group_desc_add_entries(
--- a/fs/nilfs2/alloc.h
+++ b/fs/nilfs2/alloc.h
@@ -50,8 +50,8 @@ struct nilfs_palloc_req {
 	struct buffer_head *pr_entry_bh;
 };
 
-int nilfs_palloc_prepare_alloc_entry(struct inode *,
-				     struct nilfs_palloc_req *);
+int nilfs_palloc_prepare_alloc_entry(struct inode *inode,
+				     struct nilfs_palloc_req *req, bool wrap);
 void nilfs_palloc_commit_alloc_entry(struct inode *,
 				     struct nilfs_palloc_req *);
 void nilfs_palloc_abort_alloc_entry(struct inode *, struct nilfs_palloc_req *);
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -75,7 +75,7 @@ int nilfs_dat_prepare_alloc(struct inode
 {
 	int ret;
 
-	ret = nilfs_palloc_prepare_alloc_entry(dat, req);
+	ret = nilfs_palloc_prepare_alloc_entry(dat, req, true);
 	if (ret < 0)
 		return ret;
 
--- a/fs/nilfs2/ifile.c
+++ b/fs/nilfs2/ifile.c
@@ -55,13 +55,10 @@ int nilfs_ifile_create_inode(struct inod
 	struct nilfs_palloc_req req;
 	int ret;
 
-	req.pr_entry_nr = 0;  /*
-			       * 0 says find free inode from beginning
-			       * of a group. dull code!!
-			       */
+	req.pr_entry_nr = NILFS_FIRST_INO(ifile->i_sb);
 	req.pr_entry_bh = NULL;
 
-	ret = nilfs_palloc_prepare_alloc_entry(ifile, &req);
+	ret = nilfs_palloc_prepare_alloc_entry(ifile, &req, false);
 	if (!ret) {
 		ret = nilfs_palloc_get_entry_block(ifile, req.pr_entry_nr, 1,
 						   &req.pr_entry_bh);


