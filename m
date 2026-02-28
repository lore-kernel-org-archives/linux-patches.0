Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89593A2AEF
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302664; cv=none; b=OJUAxAz4b+kBI2AmRHWWoLraoM9XfwjKUxnIZ3nzbrI/7p+s2447xlYGwzPyCw+9ej6+u2NZe84/BRu4R5/I+9qkKGna7f5Tj/bYqmb7I+AULqLzQevhLVJUW1GirYW8pBHf/L4j5nt17+1zjvXXt6pr9leY1Hke3OZhdgGx5aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302664; c=relaxed/simple;
	bh=Ueup0raY/mwyji0dlsbfnXuo2dLf3QL58ZlotSjpYnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FnxcoDoV+mMGlZmZ1rM+AoMajH0pUvssxRGrLhZwGcrPTDUA9yNrfwUg2UWV779OjlvF5Mju+PeyZP4Yw/1jhoRjyjuu1+ZY+8M+7Uj6ASGwApSGsgiCyf5h71EFT+iJyllwT1qnuQXkUPKRWinKauuN9l4B8ag/rI41Y7JZkrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nzfjVEbh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nzfjVEbh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32795C19423;
	Sat, 28 Feb 2026 18:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302664;
	bh=Ueup0raY/mwyji0dlsbfnXuo2dLf3QL58ZlotSjpYnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nzfjVEbhaTinzMJpAlXVxp0PyoW/m4ZibCGvVwUdNdK57IIbQDkzB5uQSfBnj+qNt
	 k5xQTXNj4yS22/CHDpdJABF4Ta984l5ppUGAU0tvbsRF4WeculffEPIitorTox2toe
	 3SeXlJr1J2BkXVLBzFrSo+nB3KpziefjShUPy1SumhQ26gBL+eQex2WNv+TMnhuERx
	 RYKrhcDu3mTxsdJImllp+7XhWPY+QC9sV8JfKul24xK65ftP+Yi05mv7+xMfEkj3xM
	 vLc/Lr+Mep58Xt8+Z2R3hOewzI21gHkADBJK4TzjoJrVTV3hGCx74X2mkbp4x2QwKx
	 ff1ZH7lz6DwBg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 010/147] gfs2: Replace gfs2_lblk_to_dblk with gfs2_get_extent
Date: Sat, 28 Feb 2026 13:15:18 -0500
Message-ID: <20260228181736.1605592-10-sashal@kernel.org>
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

[ Upstream commit 152f58c9af21abf913699e671b425fd38447b170 ]

We don't need two very similar functions for mapping logical blocks to physical
blocks.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: faddeb848305 ("gfs2: Fix use-after-free in iomap inline data write path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/bmap.c | 24 ------------------------
 fs/gfs2/bmap.h |  1 -
 fs/gfs2/log.c  |  6 +++++-
 3 files changed, 5 insertions(+), 26 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 41e98499862db..4514d9a8d3cd4 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -958,30 +958,6 @@ static int __gfs2_iomap_get(struct inode *inode, loff_t pos, loff_t length,
 	goto out;
 }
 
-/**
- * gfs2_lblk_to_dblk - convert logical block to disk block
- * @inode: the inode of the file we're mapping
- * @lblock: the block relative to the start of the file
- * @dblock: the returned dblock, if no error
- *
- * This function maps a single block from a file logical block (relative to
- * the start of the file) to a file system absolute block using iomap.
- *
- * Returns: the absolute file system block, or an error
- */
-int gfs2_lblk_to_dblk(struct inode *inode, u32 lblock, u64 *dblock)
-{
-	struct iomap iomap = { };
-	loff_t pos = (loff_t)lblock << inode->i_blkbits;
-	int ret;
-
-	ret = gfs2_iomap_get(inode, pos, i_blocksize(inode), &iomap);
-	if (ret == 0)
-		*dblock = iomap.addr >> inode->i_blkbits;
-
-	return ret;
-}
-
 static int gfs2_write_lock(struct inode *inode)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
diff --git a/fs/gfs2/bmap.h b/fs/gfs2/bmap.h
index 67ef7cf7fdacc..6676d863faef0 100644
--- a/fs/gfs2/bmap.h
+++ b/fs/gfs2/bmap.h
@@ -66,6 +66,5 @@ extern int gfs2_write_alloc_required(struct gfs2_inode *ip, u64 offset,
 extern int gfs2_map_journal_extents(struct gfs2_sbd *sdp, struct gfs2_jdesc *jd);
 extern void gfs2_free_journal_extents(struct gfs2_jdesc *jd);
 extern int __gfs2_punch_hole(struct file *file, loff_t offset, loff_t length);
-extern int gfs2_lblk_to_dblk(struct inode *inode, u32 lblock, u64 *dblock);
 
 #endif /* __BMAP_DOT_H__ */
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 7473b894e3c6c..a667d315b1568 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -793,7 +793,11 @@ void gfs2_write_log_header(struct gfs2_sbd *sdp, struct gfs2_jdesc *jd,
 	if (!list_empty(&jd->extent_list))
 		dblock = gfs2_log_bmap(jd, lblock);
 	else {
-		int ret = gfs2_lblk_to_dblk(jd->jd_inode, lblock, &dblock);
+		unsigned int extlen;
+		int ret;
+
+		extlen = 1;
+		ret = gfs2_get_extent(jd->jd_inode, lblock, &dblock, &extlen);
 		if (gfs2_assert_withdraw(sdp, ret == 0))
 			return;
 	}
-- 
2.51.0

