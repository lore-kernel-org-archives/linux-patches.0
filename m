Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9723F196D8C;
	Thu,  6 Jun 2024 14:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683241; cv=none; b=jgfbTub4iwyEeLPS1r5XuLR7aQnfgsdczu96v24NQtXngQJN4hEWaJm4GVSbcEvfZImKBsN/AcrWSumCXxQkiXKNusQvHPaiXeb4NBnMeNCv6vuu6Hzjz08w6K+p9/8Wpx/4jjP7tie/mreG7fHlIjWUG/TvT8//LiNLs3H/gVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683241; c=relaxed/simple;
	bh=IjB5LtzpE/QblrI6UXiUfG3ozYnQ+fakhE7q5dDZpYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwnRXcfFeogsym6NjEcAeNxTrTTMvo/rpst2+bwP4OnBZHwOEwb/oRUNJeUWmr+/Xtu9HTn7GvupBC08t/GLALSa7hP6nwOWd00WGWzDWqZr+KK4dnvgNF+NYpgD9Lkimz1OVeMr03Juo3/9FVZQBMQ9Eyex5Vc8jkTQiK6al7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ybzcj8im; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ybzcj8im"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77930C2BD10;
	Thu,  6 Jun 2024 14:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683241;
	bh=IjB5LtzpE/QblrI6UXiUfG3ozYnQ+fakhE7q5dDZpYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ybzcj8imxiQLrHtVSzU/ktUSciouXrdHremoLa3bWVhlVVXY7n6u4XUkrg6JiKAAC
	 tFpnN27HgEMXsZKU19EAQxG7PD7KtRHtksfhB/3FGoyU4Mfa1YuYp7O8ce3ONnhBai
	 mrsrCWobnazhq+oGmh1stC2JnvhQ9nGocje8V5ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 186/744] gfs2: Get rid of gfs2_alloc_blocks generation parameter
Date: Thu,  6 Jun 2024 15:57:38 +0200
Message-ID: <20240606131738.394913880@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 4c7b3f7fb7c8c66d669d107e717f9de41ef81e92 ]

Get rid of the generation parameter of gfs2_alloc_blocks(): we only ever
set the generation of the current inode while creating it, so do so
directly.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: d98779e68772 ("gfs2: Fix potential glock use-after-free on unmount")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/bmap.c  |  4 ++--
 fs/gfs2/dir.c   |  2 +-
 fs/gfs2/inode.c |  2 +-
 fs/gfs2/rgrp.c  | 12 +++++++-----
 fs/gfs2/rgrp.h  |  2 +-
 fs/gfs2/xattr.c |  6 +++---
 6 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 2b578615607e4..7ed276a8f599d 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -106,7 +106,7 @@ static int __gfs2_unstuff_inode(struct gfs2_inode *ip, struct page *page)
 		   and write it out to disk */
 
 		unsigned int n = 1;
-		error = gfs2_alloc_blocks(ip, &block, &n, 0, NULL);
+		error = gfs2_alloc_blocks(ip, &block, &n, 0);
 		if (error)
 			goto out_brelse;
 		if (isdir) {
@@ -702,7 +702,7 @@ static int __gfs2_iomap_alloc(struct inode *inode, struct iomap *iomap,
 	i = mp->mp_aheight;
 	do {
 		n = blks - alloced;
-		ret = gfs2_alloc_blocks(ip, &bn, &n, 0, NULL);
+		ret = gfs2_alloc_blocks(ip, &bn, &n, 0);
 		if (ret)
 			goto out;
 		alloced += n;
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 1a2afa88f8bea..3a2a10d6d43d1 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -868,7 +868,7 @@ static struct gfs2_leaf *new_leaf(struct inode *inode, struct buffer_head **pbh,
 	struct gfs2_dirent *dent;
 	struct timespec64 tv = current_time(inode);
 
-	error = gfs2_alloc_blocks(ip, &bn, &n, 0, NULL);
+	error = gfs2_alloc_blocks(ip, &bn, &n, 0);
 	if (error)
 		return NULL;
 	bh = gfs2_meta_new(ip->i_gl, bn);
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 4e63fbb63151c..587e5bf885c1b 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -417,7 +417,7 @@ static int alloc_dinode(struct gfs2_inode *ip, u32 flags, unsigned *dblocks)
 	if (error)
 		goto out_ipreserv;
 
-	error = gfs2_alloc_blocks(ip, &ip->i_no_addr, dblocks, 1, &ip->i_generation);
+	error = gfs2_alloc_blocks(ip, &ip->i_no_addr, dblocks, 1);
 	if (error)
 		goto out_trans_end;
 
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 307b952a41f8f..396d0f4a259d5 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -2411,13 +2411,12 @@ static void gfs2_set_alloc_start(struct gfs2_rbm *rbm,
  * @bn: Used to return the starting block number
  * @nblocks: requested number of blocks/extent length (value/result)
  * @dinode: 1 if we're allocating a dinode block, else 0
- * @generation: the generation number of the inode
  *
  * Returns: 0 or error
  */
 
 int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *nblocks,
-		      bool dinode, u64 *generation)
+		      bool dinode)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct buffer_head *dibh;
@@ -2477,10 +2476,13 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *nblocks,
 	rbm.rgd->rd_free -= *nblocks;
 	spin_unlock(&rbm.rgd->rd_rsspin);
 	if (dinode) {
+		u64 generation;
+
 		rbm.rgd->rd_dinodes++;
-		*generation = rbm.rgd->rd_igeneration++;
-		if (*generation == 0)
-			*generation = rbm.rgd->rd_igeneration++;
+		generation = rbm.rgd->rd_igeneration++;
+		if (generation == 0)
+			generation = rbm.rgd->rd_igeneration++;
+		ip->i_generation = generation;
 	}
 
 	gfs2_trans_add_meta(rbm.rgd->rd_gl, rbm.rgd->rd_bits[0].bi_bh);
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index 00b30cf893af2..507c914f039b0 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -42,7 +42,7 @@ extern int gfs2_inplace_reserve(struct gfs2_inode *ip,
 extern void gfs2_inplace_release(struct gfs2_inode *ip);
 
 extern int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *n,
-			     bool dinode, u64 *generation);
+			     bool dinode);
 
 extern void gfs2_rs_deltree(struct gfs2_blkreserv *rs);
 extern void gfs2_rs_delete(struct gfs2_inode *ip);
diff --git a/fs/gfs2/xattr.c b/fs/gfs2/xattr.c
index 4fea70c0fe3d1..2117011c8c577 100644
--- a/fs/gfs2/xattr.c
+++ b/fs/gfs2/xattr.c
@@ -639,7 +639,7 @@ static int ea_alloc_blk(struct gfs2_inode *ip, struct buffer_head **bhp)
 	u64 block;
 	int error;
 
-	error = gfs2_alloc_blocks(ip, &block, &n, 0, NULL);
+	error = gfs2_alloc_blocks(ip, &block, &n, 0);
 	if (error)
 		return error;
 	gfs2_trans_remove_revoke(sdp, block, 1);
@@ -701,7 +701,7 @@ static int ea_write(struct gfs2_inode *ip, struct gfs2_ea_header *ea,
 			int mh_size = sizeof(struct gfs2_meta_header);
 			unsigned int n = 1;
 
-			error = gfs2_alloc_blocks(ip, &block, &n, 0, NULL);
+			error = gfs2_alloc_blocks(ip, &block, &n, 0);
 			if (error)
 				return error;
 			gfs2_trans_remove_revoke(sdp, block, 1);
@@ -1002,7 +1002,7 @@ static int ea_set_block(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 	} else {
 		u64 blk;
 		unsigned int n = 1;
-		error = gfs2_alloc_blocks(ip, &blk, &n, 0, NULL);
+		error = gfs2_alloc_blocks(ip, &blk, &n, 0);
 		if (error)
 			return error;
 		gfs2_trans_remove_revoke(sdp, blk, 1);
-- 
2.43.0



