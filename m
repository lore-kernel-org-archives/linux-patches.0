Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5742EF672;
	Thu,  3 Jul 2025 15:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555564; cv=none; b=j4kpytXZGv3A4DZyLBgx+4IUzlT3FH259OwloncfIr8HNP+pWQ1bu+2pFj9qkJ/CPCT6TNTcLAhBxmkAOtsxs7PknKkPA+60MQfn2zu5buIItZQtcCQSlHtLHPdkZ+6Fig8eFlx1zsnQCOKMZnRV+V+TSFrndmsSaOQHieEsesg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555564; c=relaxed/simple;
	bh=GipkuSzoJFwRhSWaVkOEglBq/uZFGKnpcM69ENxhgvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omPEfdb9yG4RYWFHsG+RixiKMPTzLE1C2h9N0lVYm+pb8MRu73M25OOFJN+DJW2rSz0iFzAj8qo+HfyAqQtzzLp5eDO4xlYJcPkH44heQDWKLNTiN016N4L9GMYvXEsjkwbbKryECGGJPQqkKeG69oiY3vaXObU5LPPnRH3AEvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HC9+jwCV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HC9+jwCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E540C4CEE3;
	Thu,  3 Jul 2025 15:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555563;
	bh=GipkuSzoJFwRhSWaVkOEglBq/uZFGKnpcM69ENxhgvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HC9+jwCV+d1Xlg7d7M9Ztowv+CHSGfNUdLtOFCG/EBZPBJjSXA93+vONcwu8ZZ6st
	 D2JqSRbxY8FHdQggUMH4m8s3s7k4AirnJBVUE8ec3jfg21jYBheYtonYv+0rFTBjGG
	 Sgh3xFB/FjwgwSUmvsWPzoMaURLmPerpSL2/R3vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/139] f2fs: dont over-report free space or inodes in statvfs
Date: Thu,  3 Jul 2025 16:41:55 +0200
Message-ID: <20250703143943.201972437@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit a9201960623287927bf5776de3f70fb2fbde7e02 ]

This fixes an analogus bug that was fixed in modern filesystems:
a) xfs in commit 4b8d867ca6e2 ("xfs: don't over-report free space or
inodes in statvfs")
b) ext4 in commit f87d3af74193 ("ext4: don't over-report free space
or inodes in statvfs")
where statfs can report misleading / incorrect information where
project quota is enabled, and the free space is less than the
remaining quota.

This commit will resolve a test failure in generic/762 which tests
for this bug.

generic/762       - output mismatch (see /share/git/fstests/results//generic/762.out.bad)
#    --- tests/generic/762.out   2025-04-15 10:21:53.371067071 +0800
#    +++ /share/git/fstests/results//generic/762.out.bad 2025-05-13 16:13:37.000000000 +0800
#    @@ -6,8 +6,10 @@
#     root blocks2 is in range
#     dir blocks2 is in range
#     root bavail2 is in range
#    -dir bavail2 is in range
#    +dir bavail2 has value of 1539066
#    +dir bavail2 is NOT in range 304734.87 .. 310891.13
#     root blocks3 is in range
#    ...
#    (Run 'diff -u /share/git/fstests/tests/generic/762.out /share/git/fstests/results//generic/762.out.bad'  to see the entire diff)

HINT: You _MAY_ be missing kernel fix:
      XXXXXXXXXXXXXX xfs: don't over-report free space or inodes in statvfs

Cc: stable@kernel.org
Fixes: ddc34e328d06 ("f2fs: introduce f2fs_statfs_project")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 702137eafaa67..b9913ab526fd1 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1774,26 +1774,32 @@ static int f2fs_statfs_project(struct super_block *sb,
 
 	limit = min_not_zero(dquot->dq_dqb.dqb_bsoftlimit,
 					dquot->dq_dqb.dqb_bhardlimit);
-	if (limit)
-		limit >>= sb->s_blocksize_bits;
+	limit >>= sb->s_blocksize_bits;
+
+	if (limit) {
+		uint64_t remaining = 0;
 
-	if (limit && buf->f_blocks > limit) {
 		curblock = (dquot->dq_dqb.dqb_curspace +
 			    dquot->dq_dqb.dqb_rsvspace) >> sb->s_blocksize_bits;
-		buf->f_blocks = limit;
-		buf->f_bfree = buf->f_bavail =
-			(buf->f_blocks > curblock) ?
-			 (buf->f_blocks - curblock) : 0;
+		if (limit > curblock)
+			remaining = limit - curblock;
+
+		buf->f_blocks = min(buf->f_blocks, limit);
+		buf->f_bfree = min(buf->f_bfree, remaining);
+		buf->f_bavail = min(buf->f_bavail, remaining);
 	}
 
 	limit = min_not_zero(dquot->dq_dqb.dqb_isoftlimit,
 					dquot->dq_dqb.dqb_ihardlimit);
 
-	if (limit && buf->f_files > limit) {
-		buf->f_files = limit;
-		buf->f_ffree =
-			(buf->f_files > dquot->dq_dqb.dqb_curinodes) ?
-			 (buf->f_files - dquot->dq_dqb.dqb_curinodes) : 0;
+	if (limit) {
+		uint64_t remaining = 0;
+
+		if (limit > dquot->dq_dqb.dqb_curinodes)
+			remaining = limit - dquot->dq_dqb.dqb_curinodes;
+
+		buf->f_files = min(buf->f_files, limit);
+		buf->f_ffree = min(buf->f_ffree, remaining);
 	}
 
 	spin_unlock(&dquot->dq_dqb_lock);
-- 
2.39.5



