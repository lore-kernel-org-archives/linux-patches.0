Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C142304BD3;
	Mon, 27 Oct 2025 19:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593370; cv=none; b=no3bgj/QgvnCv1ZjCjOFmoxHB9Xlv8ft9yXQ/IuN7tQWsiecbsiK6ntMEvO/8yoItkAfdDG7AI6Q+DBSksmsNdnZC4udP1fh4HQR4WCbXG/hzVPj51aUsHWXl7regezHwylS2UUvQSIS+RHFZIx80zlJus+cQPmHKEgKiUwRuNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593370; c=relaxed/simple;
	bh=8Nc/20Uv/Ki8kabok6cq8tHwpe97n6DpVU+47N4uAaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwxWZeZtY1dlq9CyybTs+XHFvtBkGsNQx664ISim6jDWsAoPzlnAnJJ3hToHkMcq2zqptGoQMJgZ9j4tkZKuOw/hOxRdZZKLbDedMuAh6PCiwdda/3Z3a4daboTZrrJvetoKK8+XLJM7Yb4AmqsnHwCZPg0stZeUX98miH2WQR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LJvIEzLR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LJvIEzLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D765DC4CEF1;
	Mon, 27 Oct 2025 19:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593370;
	bh=8Nc/20Uv/Ki8kabok6cq8tHwpe97n6DpVU+47N4uAaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LJvIEzLRbbMlgOhzZALmKHMpICj/PIstd6EitbU1IxFEViZ7KOAjRhB38AJxlxs9K
	 wvSm4xsak6UmbzJxeMBUHq2WRkyR6zv64xHHP5cbQ6n1NKI9KOAtshZ+HE8l36biKt
	 dxHrUMafnbnjAxUVbXGKlntVEGZFdYg3twwal6tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.17 076/184] xfs: fix locking in xchk_nlinks_collect_dir
Date: Mon, 27 Oct 2025 19:35:58 +0100
Message-ID: <20251027183516.946172338@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit f477af0cfa0487eddec66ffe10fd9df628ba6f52 upstream.

On a filesystem with parent pointers, xchk_nlinks_collect_dir walks both
the directory entries (data fork) and the parent pointers (attr fork) to
determine the correct link count.  Unfortunately I forgot to update the
lock mode logic to handle the case of a directory whose attr fork is in
btree format and has not yet been loaded *and* whose data fork doesn't
need loading.

This leads to a bunch of assertions from xfs/286 in xfs_iread_extents
because we only took ILOCK_SHARED, not ILOCK_EXCL.  You'd need the rare
happenstance of a directory with a large number of non-pptr extended
attributes set and enough memory pressure to cause the directory to be
evicted and partially reloaded from disk.

I /think/ this only started in 6.18-rc1 because I've started seeing OOM
errors with the maple tree slab using 70% of memory, and this didn't
happen in 6.17.  Yay dynamic systems!

Cc: stable@vger.kernel.org # v6.10
Fixes: 77ede5f44b0d86 ("xfs: walk directory parent pointers to determine backref count")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/nlinks.c |   34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -376,6 +376,36 @@ out_incomplete:
 	return error;
 }
 
+static uint
+xchk_nlinks_ilock_dir(
+	struct xfs_inode	*ip)
+{
+	uint			lock_mode = XFS_ILOCK_SHARED;
+
+	/*
+	 * We're going to scan the directory entries, so we must be ready to
+	 * pull the data fork mappings into memory if they aren't already.
+	 */
+	if (xfs_need_iread_extents(&ip->i_df))
+		lock_mode = XFS_ILOCK_EXCL;
+
+	/*
+	 * We're going to scan the parent pointers, so we must be ready to
+	 * pull the attr fork mappings into memory if they aren't already.
+	 */
+	if (xfs_has_parent(ip->i_mount) && xfs_inode_has_attr_fork(ip) &&
+	    xfs_need_iread_extents(&ip->i_af))
+		lock_mode = XFS_ILOCK_EXCL;
+
+	/*
+	 * Take the IOLOCK so that other threads cannot start a directory
+	 * update while we're scanning.
+	 */
+	lock_mode |= XFS_IOLOCK_SHARED;
+	xfs_ilock(ip, lock_mode);
+	return lock_mode;
+}
+
 /* Walk a directory to bump the observed link counts of the children. */
 STATIC int
 xchk_nlinks_collect_dir(
@@ -394,8 +424,7 @@ xchk_nlinks_collect_dir(
 		return 0;
 
 	/* Prevent anyone from changing this directory while we walk it. */
-	xfs_ilock(dp, XFS_IOLOCK_SHARED);
-	lock_mode = xfs_ilock_data_map_shared(dp);
+	lock_mode = xchk_nlinks_ilock_dir(dp);
 
 	/*
 	 * The dotdot entry of an unlinked directory still points to the last
@@ -452,7 +481,6 @@ out_abort:
 	xchk_iscan_abort(&xnc->collect_iscan);
 out_unlock:
 	xfs_iunlock(dp, lock_mode);
-	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
 	return error;
 }
 


