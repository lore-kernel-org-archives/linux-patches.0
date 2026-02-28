Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5373A2AE1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302664; cv=none; b=nRcLkVV9eyoalD7ipqdmme9IVCuFyeCdzxls9vtITlvnYbBysTR3SzpG9OKI3P+aA6ZMJkdJsCxS7tQMXx76ZGqxoTWcHpDOPmsp2wsaxltoT8UW4a+ajISLSgEdZj1iJdRghB4I1hesCODIruPojN+m33YKxnzb4IH9JX1achg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302664; c=relaxed/simple;
	bh=IYpztofmuAThepboPbrskmyvVQ7kjZgaCX2xskHHu5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJKpCVARtZfsILee/upr+y38ebqWvrbYKpoHnEsoCOG05eci56frtV7pdpB3DR4sPm+bJScFwAU32u8IvuG3yHKAarlioXmm2x8d5pQmQZxptl3UMeB5ihuwx1Ie9ROXGGBCjbdwXf+aLt96nV8MqVkltLTl37mSxbu7AfT5HlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GW/IYd4Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GW/IYd4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE4CC116D0;
	Sat, 28 Feb 2026 18:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302663;
	bh=IYpztofmuAThepboPbrskmyvVQ7kjZgaCX2xskHHu5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GW/IYd4ZemVtuT5sKbLMD3vAZECrHO39958e6GGoPcBONrrIHgrCpmeWS3apfkw1I
	 1FzADKnrQNl1M4WumUXMwO9E2x4+036ZPb2FJDp+UkXigojZBexhjReh9c0aRsQFi8
	 F0vbLtyTS8NrFmS3RFGN/93YU8o/W3/O9A2m5h6EDKPzXcmzoK+uU9aMKKr9AZlJpc
	 v+IeEcHQ5pIzK1Q00LS2ksen4YvisVO+l5qWiOP+Nts+o5vAvVyZtchtzGaHJJiLHk
	 Vo2nqd4h2Egv30c3hrbs/ivBuCcH9S9Rq5h63HXmevqVTLv53xCHqEAJ0XuqbcjWSA
	 Tf1Rw75+dL0Xw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 009/147] gfs2: Turn gfs2_extent_map into gfs2_{get,alloc}_extent
Date: Sat, 28 Feb 2026 13:15:17 -0500
Message-ID: <20260228181736.1605592-9-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 9153dac13a6966b63183bac450d5cd39b07cc85c ]

Convert gfs2_extent_map to iomap and split it into gfs2_get_extent and
gfs2_alloc_extent.  Instead of hardcoding the extent size, pass it in
via the extlen parameter.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: faddeb848305 ("gfs2: Fix use-after-free in iomap inline data write path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/bmap.c     | 59 ++++++++++++++++++++++++++++++----------------
 fs/gfs2/bmap.h     |  6 +++--
 fs/gfs2/dir.c      | 13 +++++-----
 fs/gfs2/quota.c    |  4 ++--
 fs/gfs2/recovery.c |  4 ++--
 5 files changed, 53 insertions(+), 33 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 8ec1114ab452c..41e98499862db 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1316,28 +1316,47 @@ int gfs2_block_map(struct inode *inode, sector_t lblock,
 	return ret;
 }
 
-/*
- * Deprecated: do not use in new code
- */
-int gfs2_extent_map(struct inode *inode, u64 lblock, int *new, u64 *dblock, unsigned *extlen)
+int gfs2_get_extent(struct inode *inode, u64 lblock, u64 *dblock,
+		    unsigned int *extlen)
 {
-	struct buffer_head bh = { .b_state = 0, .b_blocknr = 0 };
+	unsigned int blkbits = inode->i_blkbits;
+	struct iomap iomap = { };
+	unsigned int len;
 	int ret;
-	int create = *new;
-
-	BUG_ON(!extlen);
-	BUG_ON(!dblock);
-	BUG_ON(!new);
-
-	bh.b_size = BIT(inode->i_blkbits + (create ? 0 : 5));
-	ret = gfs2_block_map(inode, lblock, &bh, create);
-	*extlen = bh.b_size >> inode->i_blkbits;
-	*dblock = bh.b_blocknr;
-	if (buffer_new(&bh))
-		*new = 1;
-	else
-		*new = 0;
-	return ret;
+
+	ret = gfs2_iomap_get(inode, lblock << blkbits, *extlen << blkbits,
+			     &iomap);
+	if (ret)
+		return ret;
+	if (iomap.type != IOMAP_MAPPED)
+		return -EIO;
+	*dblock = iomap.addr >> blkbits;
+	len = iomap.length >> blkbits;
+	if (len < *extlen)
+		*extlen = len;
+	return 0;
+}
+
+int gfs2_alloc_extent(struct inode *inode, u64 lblock, u64 *dblock,
+		      unsigned int *extlen, bool *new)
+{
+	unsigned int blkbits = inode->i_blkbits;
+	struct iomap iomap = { };
+	unsigned int len;
+	int ret;
+
+	ret = gfs2_iomap_alloc(inode, lblock << blkbits, *extlen << blkbits,
+			       &iomap);
+	if (ret)
+		return ret;
+	if (iomap.type != IOMAP_MAPPED)
+		return -EIO;
+	*dblock = iomap.addr >> blkbits;
+	len = iomap.length >> blkbits;
+	if (len < *extlen)
+		*extlen = len;
+	*new = iomap.flags & IOMAP_F_NEW;
+	return 0;
 }
 
 /*
diff --git a/fs/gfs2/bmap.h b/fs/gfs2/bmap.h
index c63efee8aaa43..67ef7cf7fdacc 100644
--- a/fs/gfs2/bmap.h
+++ b/fs/gfs2/bmap.h
@@ -53,8 +53,10 @@ extern int gfs2_iomap_get(struct inode *inode, loff_t pos, loff_t length,
 			  struct iomap *iomap);
 extern int gfs2_iomap_alloc(struct inode *inode, loff_t pos, loff_t length,
 			    struct iomap *iomap);
-extern int gfs2_extent_map(struct inode *inode, u64 lblock, int *new,
-			   u64 *dblock, unsigned *extlen);
+extern int gfs2_get_extent(struct inode *inode, u64 lblock, u64 *dblock,
+			   unsigned int *extlen);
+extern int gfs2_alloc_extent(struct inode *inode, u64 lblock, u64 *dblock,
+			     unsigned *extlen, bool *new);
 extern int gfs2_setattr_size(struct inode *inode, u64 size);
 extern void gfs2_trim_blocks(struct inode *inode);
 extern int gfs2_truncatei_resume(struct gfs2_inode *ip);
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index c0f2875c946c9..4517ffb7c13d2 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -159,7 +159,7 @@ static int gfs2_dir_write_data(struct gfs2_inode *ip, const char *buf,
 	unsigned int o;
 	int copied = 0;
 	int error = 0;
-	int new = 0;
+	bool new = false;
 
 	if (!size)
 		return 0;
@@ -189,9 +189,9 @@ static int gfs2_dir_write_data(struct gfs2_inode *ip, const char *buf,
 			amount = sdp->sd_sb.sb_bsize - o;
 
 		if (!extlen) {
-			new = 1;
-			error = gfs2_extent_map(&ip->i_inode, lblock, &new,
-						&dblock, &extlen);
+			extlen = 1;
+			error = gfs2_alloc_extent(&ip->i_inode, lblock, &dblock,
+						  &extlen, &new);
 			if (error)
 				goto fail;
 			error = -EIO;
@@ -286,15 +286,14 @@ static int gfs2_dir_read_data(struct gfs2_inode *ip, __be64 *buf,
 	while (copied < size) {
 		unsigned int amount;
 		struct buffer_head *bh;
-		int new;
 
 		amount = size - copied;
 		if (amount > sdp->sd_sb.sb_bsize - o)
 			amount = sdp->sd_sb.sb_bsize - o;
 
 		if (!extlen) {
-			new = 0;
-			error = gfs2_extent_map(&ip->i_inode, lblock, &new,
+			extlen = 32;
+			error = gfs2_get_extent(&ip->i_inode, lblock,
 						&dblock, &extlen);
 			if (error || !dblock)
 				goto fail;
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 8c226aa286336..984ca5057d9d5 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1394,8 +1394,8 @@ int gfs2_quota_init(struct gfs2_sbd *sdp)
 		unsigned int y;
 
 		if (!extlen) {
-			int new = 0;
-			error = gfs2_extent_map(&ip->i_inode, x, &new, &dblock, &extlen);
+			extlen = 32;
+			error = gfs2_get_extent(&ip->i_inode, x, &dblock, &extlen);
 			if (error)
 				goto fail;
 		}
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index 8f9c6480a5df4..b925ba068af50 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -34,12 +34,12 @@ int gfs2_replay_read_block(struct gfs2_jdesc *jd, unsigned int blk,
 {
 	struct gfs2_inode *ip = GFS2_I(jd->jd_inode);
 	struct gfs2_glock *gl = ip->i_gl;
-	int new = 0;
 	u64 dblock;
 	u32 extlen;
 	int error;
 
-	error = gfs2_extent_map(&ip->i_inode, blk, &new, &dblock, &extlen);
+	extlen = 32;
+	error = gfs2_get_extent(&ip->i_inode, blk, &dblock, &extlen);
 	if (error)
 		return error;
 	if (!dblock) {
-- 
2.51.0

