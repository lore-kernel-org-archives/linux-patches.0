Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602FB34CFDE;
	Wed, 30 Sep 2026 18:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793703; cv=none; b=s4IJRXPJ76MflKrae8J4ZeNXt6ePhRzv6kv+yHvQarLjDQWO9PScB2gt97/R3wWd/iNiInyuhr/32S64g0YHn9UyT31ryUHvp8smwI9P5K29q519rfJ1+nPsdHTR1aNEVtM3kuHhvh1nmQpLrO0Duy2ZFpEjctaFbGxvN/yj7IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793703; c=relaxed/simple;
	bh=/dhPYBn4WXMKc1yX7W7WWyHJt2pl5UnhZI1IuCzon34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqqh8hI2BDiaoZ7FA7VJzqq10fcAJN03sFDLhP//aqwbMLy28tgAuV77CNkkHAxrAcsPtul7VFHAH4r4L8cca7VDN9TwsRIhU1s04ohZ3WDIVYUupZx5SJ8vvelnD+0eGHjL55/AmPol2eUY8iELi2i6T+qc6rEm22rCVf1PQ2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G7936FFS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G7936FFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2011F000FF;
	Wed, 30 Sep 2026 18:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793702;
	bh=rIugLW99ZRuB06F0EWmS3LsCCNlQa0BCRzKOuiKgCZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G7936FFSIJ8VxcvgY7MlnkddspDefAL6w2rZ/Q0oJvkHWC1ndJgvPdgvkIDJSy7yn
	 8wW5U4OBsYw6AT3A/p9IvWW4/0KOtVjFAo0ZIlI9IynZpYoq9l9drD6MR2g6AfpoLU
	 Ia+0VmgslLqkiICpxQ4Amqb58U7CcRGl5Kf/2Dog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 347/395] xfs: fix cursor and pointer handling when recovering iunlink buckets
Date: Wed, 30 Sep 2026 17:30:09 +0200
Message-ID: <20260930152348.202844387@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 65f39d09d73718611cee40399179323b5d4ead00 upstream.

LOLLM pointed out a bug in xlog_recover_iunlink_bucket:

1. We don't null out prev_ip after releasing it, which can lead to UAF
   problems if the inodegc flush call in the loop fails.

at which point I noticed even more bugs:

2. If the inodegc flush inside the loop fails, we also leak @ip.

3. We set prev_agino to agino having already advanced agino, which
   results in inodes with i_prev_unlinked set to itself.

4. If we exit the bottom of the loop with prev_ip set, then prev_ip
   aliases ip and we also set its i_prev_unlinked to itself.

Bugs 3 and 4 introduce loops into the unlinked list, though these loops
don't surface because we immediately flush each unlinked inode after
loading it.

Fix all of these issues.

Cc: stable@vger.kernel.org # v6.0
Fixes: 04755d2e5821b3 ("xfs: refactor xlog_recover_process_iunlinks()")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_log_recover.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2736,12 +2736,13 @@ xlog_recover_iunlink_bucket(
 {
 	struct xfs_mount	*mp = pag_mount(pag);
 	struct xfs_inode	*prev_ip = NULL;
-	struct xfs_inode	*ip;
 	xfs_agino_t		prev_agino, agino;
 	int			error = 0;
 
 	agino = be32_to_cpu(agi->agi_unlinked[bucket]);
 	while (agino != NULLAGINO) {
+		struct xfs_inode	*ip;
+
 		error = xfs_iget(mp, NULL, xfs_agino_to_ino(pag, agino), 0, 0,
 				&ip);
 		if (error)
@@ -2750,11 +2751,11 @@ xlog_recover_iunlink_bucket(
 		ASSERT(VFS_I(ip)->i_nlink == 0);
 		ASSERT(VFS_I(ip)->i_mode != 0);
 		xfs_iflags_clear(ip, XFS_IRECOVERY);
-		agino = ip->i_next_unlinked;
 
 		if (prev_ip) {
 			ip->i_prev_unlinked = prev_agino;
 			xfs_irele(prev_ip);
+			prev_ip = NULL;
 
 			/*
 			 * Ensure the inode is removed from the unlinked list
@@ -2766,18 +2767,20 @@ xlog_recover_iunlink_bucket(
 			 * complete.
 			 */
 			error = xfs_inodegc_flush(mp);
-			if (error)
-				break;
+			if (error) {
+				xfs_irele(ip);
+				return error;
+			}
 		}
 
 		prev_agino = agino;
+		agino = ip->i_next_unlinked;
 		prev_ip = ip;
 	}
 
 	if (prev_ip) {
 		int	error2;
 
-		ip->i_prev_unlinked = prev_agino;
 		xfs_irele(prev_ip);
 
 		error2 = xfs_inodegc_flush(mp);


