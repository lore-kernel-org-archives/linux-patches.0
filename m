Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3791B3C3C;
	Fri, 27 Sep 2024 12:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440367; cv=none; b=PHgVkUOKc6jgVuL6ImOyn3V6FEmMihFxSBnvboFS6QT22TOGIria+4hnDa88I/oPepa2rXgyIR99vslL3T2+/JG1/ZkpaO4U40KfnLijO8ekjWuhS56uFUnh78yXzEB9VzlWJcMfycfmHMUcfbtTwN3Nfzv+fgV+mGEYLtHpSfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440367; c=relaxed/simple;
	bh=FhHW9cavmHNBC+hRbWPAt0GHU/82lJxutnoMloDQ74M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dcrst2PS9AU6/CSVEP1ErTIQgFaGPBY1v6VmTasdlaMbdPZTSz/Yf1BgX3VE4k4jEoYKyPY5unw0lVa8fpP+D/ASR+QGc4M7e0XG4I08POsobXUpGj3bl9US381r9Dx+qWt7Xq7S8Gi2rSKQmIgXDeCUzxZha1XBvn8eZ9mGGrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4ktQreG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4ktQreG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABADC4CEC4;
	Fri, 27 Sep 2024 12:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440367;
	bh=FhHW9cavmHNBC+hRbWPAt0GHU/82lJxutnoMloDQ74M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4ktQreGDUa0jBaFsDiwbRzF7o2xSmLV9pwIYv+ngnEiJ/FS9dg6LZRb9cPbVpZMI
	 ERT2pseqIIV6UNbwTEa4O017yPAjcVhjMG6+O28rbQiqu06/ZS59utDuobx272Z9PK
	 Ai6WgIuFqRpr+PgmmSXDPc/G821RNIDualdIFGQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 56/73] xfs: fix reloading entire unlinked bucket lists
Date: Fri, 27 Sep 2024 14:24:07 +0200
Message-ID: <20240927121722.190249350@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 537c013b140d373d1ffe6290b841dc00e67effaa ]

During review of the patcheset that provided reloading of the incore
iunlink list, Dave made a few suggestions, and I updated the copy in my
dev tree.  Unfortunately, I then got distracted by ... who even knows
what ... and forgot to backport those changes from my dev tree to my
release candidate branch.  I then sent multiple pull requests with stale
patches, and that's what was merged into -rc3.

So.

This patch re-adds the use of an unlocked iunlink list check to
determine if we want to allocate the resources to recreate the incore
list.  Since lost iunlinked inodes are supposed to be rare, this change
helps us avoid paying the transaction and AGF locking costs every time
we open any inode.

This also re-adds the shutdowns on failure, and re-applies the
restructuring of the inner loop in xfs_inode_reload_unlinked_bucket, and
re-adds a requested comment about the quotachecking code.

Retain the original RVB tag from Dave since there's no code change from
the last submission.

Fixes: 68b957f64fca1 ("xfs: load uncached unlinked inodes into memory on demand")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_export.c |   16 ++++++++++++----
 fs/xfs/xfs_inode.c  |   48 +++++++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_itable.c |    2 ++
 fs/xfs/xfs_qm.c     |   15 ++++++++++++---
 4 files changed, 61 insertions(+), 20 deletions(-)

--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -146,10 +146,18 @@ xfs_nfs_get_inode(
 		return ERR_PTR(error);
 	}
 
-	error = xfs_inode_reload_unlinked(ip);
-	if (error) {
-		xfs_irele(ip);
-		return ERR_PTR(error);
+	/*
+	 * Reload the incore unlinked list to avoid failure in inodegc.
+	 * Use an unlocked check here because unrecovered unlinked inodes
+	 * should be somewhat rare.
+	 */
+	if (xfs_inode_unlinked_incomplete(ip)) {
+		error = xfs_inode_reload_unlinked(ip);
+		if (error) {
+			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+			xfs_irele(ip);
+			return ERR_PTR(error);
+		}
 	}
 
 	if (VFS_I(ip)->i_generation != generation) {
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1744,6 +1744,14 @@ xfs_inactive(
 		truncate = 1;
 
 	if (xfs_iflags_test(ip, XFS_IQUOTAUNCHECKED)) {
+		/*
+		 * If this inode is being inactivated during a quotacheck and
+		 * has not yet been scanned by quotacheck, we /must/ remove
+		 * the dquots from the inode before inactivation changes the
+		 * block and inode counts.  Most probably this is a result of
+		 * reloading the incore iunlinked list to purge unrecovered
+		 * unlinked inodes.
+		 */
 		xfs_qm_dqdetach(ip);
 	} else {
 		error = xfs_qm_dqattach(ip);
@@ -3657,6 +3665,16 @@ xfs_inode_reload_unlinked_bucket(
 	if (error)
 		return error;
 
+	/*
+	 * We've taken ILOCK_SHARED and the AGI buffer lock to stabilize the
+	 * incore unlinked list pointers for this inode.  Check once more to
+	 * see if we raced with anyone else to reload the unlinked list.
+	 */
+	if (!xfs_inode_unlinked_incomplete(ip)) {
+		foundit = true;
+		goto out_agibp;
+	}
+
 	bucket = agino % XFS_AGI_UNLINKED_BUCKETS;
 	agi = agibp->b_addr;
 
@@ -3671,25 +3689,27 @@ xfs_inode_reload_unlinked_bucket(
 	while (next_agino != NULLAGINO) {
 		struct xfs_inode	*next_ip = NULL;
 
+		/* Found this caller's inode, set its backlink. */
 		if (next_agino == agino) {
-			/* Found this inode, set its backlink. */
 			next_ip = ip;
 			next_ip->i_prev_unlinked = prev_agino;
 			foundit = true;
+			goto next_inode;
 		}
-		if (!next_ip) {
-			/* Inode already in memory. */
-			next_ip = xfs_iunlink_lookup(pag, next_agino);
-		}
-		if (!next_ip) {
-			/* Inode not in memory, reload. */
-			error = xfs_iunlink_reload_next(tp, agibp, prev_agino,
-					next_agino);
-			if (error)
-				break;
 
-			next_ip = xfs_iunlink_lookup(pag, next_agino);
-		}
+		/* Try in-memory lookup first. */
+		next_ip = xfs_iunlink_lookup(pag, next_agino);
+		if (next_ip)
+			goto next_inode;
+
+		/* Inode not in memory, try reloading it. */
+		error = xfs_iunlink_reload_next(tp, agibp, prev_agino,
+				next_agino);
+		if (error)
+			break;
+
+		/* Grab the reloaded inode. */
+		next_ip = xfs_iunlink_lookup(pag, next_agino);
 		if (!next_ip) {
 			/* No incore inode at all?  We reloaded it... */
 			ASSERT(next_ip != NULL);
@@ -3697,10 +3717,12 @@ xfs_inode_reload_unlinked_bucket(
 			break;
 		}
 
+next_inode:
 		prev_agino = next_agino;
 		next_agino = next_ip->i_next_unlinked;
 	}
 
+out_agibp:
 	xfs_trans_brelse(tp, agibp);
 	/* Should have found this inode somewhere in the iunlinked bucket. */
 	if (!error && !foundit)
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -80,10 +80,12 @@ xfs_bulkstat_one_int(
 	if (error)
 		goto out;
 
+	/* Reload the incore unlinked list to avoid failure in inodegc. */
 	if (xfs_inode_unlinked_incomplete(ip)) {
 		error = xfs_inode_reload_unlinked_bucket(tp, ip);
 		if (error) {
 			xfs_iunlock(ip, XFS_ILOCK_SHARED);
+			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 			xfs_irele(ip);
 			return error;
 		}
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1160,9 +1160,18 @@ xfs_qm_dqusage_adjust(
 	if (error)
 		return error;
 
-	error = xfs_inode_reload_unlinked(ip);
-	if (error)
-		goto error0;
+	/*
+	 * Reload the incore unlinked list to avoid failure in inodegc.
+	 * Use an unlocked check here because unrecovered unlinked inodes
+	 * should be somewhat rare.
+	 */
+	if (xfs_inode_unlinked_incomplete(ip)) {
+		error = xfs_inode_reload_unlinked(ip);
+		if (error) {
+			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+			goto error0;
+		}
+	}
 
 	ASSERT(ip->i_delayed_blks == 0);
 


