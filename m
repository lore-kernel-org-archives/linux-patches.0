Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1105C50B423;
	Thu, 17 Sep 2026 17:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666703; cv=none; b=C8F0TW7lwe0nqkWVr75HWNzXZszKerfpVMODgFyJlhh1c5qjotfEmbJ7V2hfB0bcrEba7Eh3wq1LWuZPdW26aL9Tp93SlhlR5EbjIyRkMS+iaQSG6NmbVAEurRThRz08c2r9h43OuW8dFsxRCUsDHQC7Of1PBw8kJA1bZeu28co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666703; c=relaxed/simple;
	bh=shdkwxHr8v6FIfU/tbWCWU2Rd83+VCCFbkAE3yY3H1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnMMiq0fmSae5dua+Q0cHsusslCyYrOQYsFPi52SiH0zvidmbx1iokTMoTUf1brWUqXjN+ZkFbnlI4ikvC71SgjKEMZSE7iIa6P92zroxy2Htuw8Yb/w4PXwcFQnEO9im/Q2XuQWLC3cenZ27mmzuIKN7PlfjWfzLABKm5c41WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bu/FmK+Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bu/FmK+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E78F1F00893;
	Thu, 17 Sep 2026 17:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666701;
	bh=DP9tIjfv8q8XlFzKoWcK4IbRNBURyno+ykLpMU8i2eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bu/FmK+YC8kSz+aJ7sRFqtsXWE90jpY77L1QdaUvpNa9f1RBXdASVlHb6FPrsyekT
	 /PzvkTZ/iZE/qWah3anPbKopbTxgQHkMpUg5/PAJ9h+cFS8TZwe5hUBUwBUwjFFSrg
	 YBTW99WTgMe2mZ16cJSKy6o1f5GU042i9KqN0xfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1125/1250] xfs: advance the findparent inode scan cursor while holding ILOCK
Date: Thu, 17 Sep 2026 16:15:20 +0100
Message-ID: <20260917151622.733316551@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

commit ad4497a92caba4630f75c80d49cb947026213280 upstream.

LOLLM pointed out a race condition in xrep_findparent_scan -- the
directory live update hook holds the directory ILOCK when it calls the
xchk_iscan_want_live_update predicate to figure out if it needs to
remember the live update, but xrep_findparent_scan drops the directory
ILOCK before advancing the cursor.  Therefore, it's possible for a live
update to check the scan cursor after the scan drops the ILOCK but
before the scan updates its cursor.  If this happens, we'll fail to
record the live update.  Fix this by moving the cursor update logic
inside xrep_findparent_walk_directory.

Note that for non-directories it's ok to advance the cursor without
holding any ILOCK because the findparent scan only cares about directory
parents, not the children.

Cc: stable@vger.kernel.org # v6.10
Fixes: a07b45576264e7 ("xfs: scan the filesystem to repair a directory dotdot entry")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/findparent.c |   54 ++++++++++++++++++++++++++++++----------------
 1 file changed, 36 insertions(+), 18 deletions(-)

--- a/fs/xfs/scrub/findparent.c
+++ b/fs/xfs/scrub/findparent.c
@@ -139,32 +139,52 @@ xrep_findparent_dirent(
 	return 0;
 }
 
-/*
- * If this is a directory, walk the dirents looking for any that point to the
- * scrub target inode.
- */
-STATIC int
-xrep_findparent_walk_directory(
-	struct xrep_findparent_info	*fpi)
+static inline bool
+xrep_findparent_want_scan_file(
+	const struct xrep_findparent_info	*fpi)
 {
-	struct xfs_scrub		*sc = fpi->sc;
-	struct xfs_inode		*dp = fpi->dp;
-	unsigned int			lock_mode;
-	int				error = 0;
+	const struct xfs_scrub			*sc = fpi->sc;
+	const struct xfs_inode			*dp = fpi->dp;
+
+	/* Only directories can be parents */
+	if (!S_ISDIR(VFS_IC(dp)->i_mode))
+		return false;
 
 	/*
 	 * The inode being scanned cannot be its own parent, nor can any
 	 * temporary directory we created to stage this repair.
 	 */
 	if (dp == sc->ip || dp == sc->tempip)
-		return 0;
+		return false;
 
 	/*
 	 * Similarly, temporary files created to stage a repair cannot be the
 	 * parent of this inode.
 	 */
 	if (xrep_is_tempfile(dp))
+		return false;
+
+	return true;
+}
+
+/*
+ * If this is a directory, walk the dirents looking for any that point to the
+ * scrub target inode.
+ */
+STATIC int
+xrep_findparent_walk_file(
+	struct xrep_findparent_info	*fpi)
+{
+	struct xfs_scrub		*sc = fpi->sc;
+	struct xfs_inode		*dp = fpi->dp;
+	unsigned int			lock_mode;
+	int				error = 0;
+
+	if (!xrep_findparent_want_scan_file(fpi)) {
+		if (fpi->parent_scan)
+			xchk_iscan_mark_visited(&fpi->parent_scan->iscan, dp);
 		return 0;
+	}
 
 	/*
 	 * Scan the directory to see if there it contains an entry pointing to
@@ -201,6 +221,8 @@ xrep_findparent_walk_directory(
 		goto out_unlock;
 
 out_unlock:
+	if (fpi->parent_scan)
+		xchk_iscan_mark_visited(&fpi->parent_scan->iscan, dp);
 	xfs_iunlock(dp, lock_mode);
 	return error;
 }
@@ -309,11 +331,7 @@ xrep_findparent_scan(
 	ASSERT(S_ISDIR(VFS_IC(sc->ip)->i_mode));
 
 	while ((ret = xchk_iscan_iter(&pscan->iscan, &fpi.dp)) == 1) {
-		if (S_ISDIR(VFS_I(fpi.dp)->i_mode))
-			ret = xrep_findparent_walk_directory(&fpi);
-		else
-			ret = 0;
-		xchk_iscan_mark_visited(&pscan->iscan, fpi.dp);
+		ret = xrep_findparent_walk_file(&fpi);
 		xchk_irele(sc, fpi.dp);
 		if (ret)
 			break;
@@ -402,7 +420,7 @@ xrep_findparent_confirm(
 		goto out_rele;
 	}
 
-	error = xrep_findparent_walk_directory(&fpi);
+	error = xrep_findparent_walk_file(&fpi);
 	if (error)
 		goto out_rele;
 


