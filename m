Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CC4342CB2;
	Sat, 28 Feb 2026 17:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301426; cv=none; b=n4oNd9hvhaJ7tNWc7ZnwCJ+yFdGK1tEjOcAOQIifNLkBYbheJiJZ1zEd2O5X+JAWdIVG2elff8KMmiJYbug578NtcNiPwSrrzr4LMLvs+x0L1jSu0JEPQVp/U4SrAUjap1bAOPebegP3yuk4DWUXUgv2lTx97ooBEE6cXK7/Em0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301426; c=relaxed/simple;
	bh=cuz0HrJojVSCVZxXgiwczN+3ALnzoM2hqpMUZbMXo5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ttkavRBp2v/sGntpufO0oqQ/qmRet/at9VlYHws70VRrX81WV6CjajTnPa9W8iRKVNXCGzkhGGHUcnPubAxAZkvht9uTpl7CI1Elk6L3qsn/dO3PglGI6Sa2wzegItDry/zQ/vtI+mIQn2JAJss6C+lI+eReypq7ApNgzQuM+wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BEZj0Pa7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BEZj0Pa7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E08C116D0;
	Sat, 28 Feb 2026 17:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301426;
	bh=cuz0HrJojVSCVZxXgiwczN+3ALnzoM2hqpMUZbMXo5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BEZj0Pa74DUMIz0FChNSyQDomwBsvPdrOTxOiJmho0W3pPSneE9AIZnUeeG79IcaC
	 0WQvdJ9+FraPO2E8GgaTkDZ3ZUxpVjtk0p9aY8hJkdUecE+X6454rmSx51ttrCrRQI
	 xazvQtXy6OMq0yehaZ2OIFtWVsSquQNJ2HbK0KRX5MACPrqWVRxbffKIyHO5Wvejz/
	 8P8KgMbQTK16g2Oa0skPKK9F6NoTupOjg9xHbTpTBj6Kh9PaMw9v9HZ0Chno3u4P6u
	 sK9BQ6vFO1pEMjtTAewmoHb1cTUO6QkoW3xXuurcEyKTJoIRQIin8hSWG15ZOvkvO2
	 8im+ekhJQc9cg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	r772577952@gmail.com,
	stable@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 616/752] xfs: only call xf{array,blob}_destroy if we have a valid pointer
Date: Sat, 28 Feb 2026 12:45:27 -0500
Message-ID: <20260228174750.1542406-616-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit ba408d299a3bb3c5309f40c5326e4fb83ead4247 ]

Only call the xfarray and xfblob destructor if we have a valid pointer,
and be sure to null out that pointer afterwards.  Note that this patch
fixes a large number of commits, most of which were merged between 6.9
and 6.10.

Cc: r772577952@gmail.com
Cc: <stable@vger.kernel.org> # v6.12
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Jiaming Zhang <r772577952@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/agheader_repair.c | 8 ++++++--
 fs/xfs/scrub/attr_repair.c     | 6 ++++--
 fs/xfs/scrub/dir_repair.c      | 8 ++++++--
 fs/xfs/scrub/dirtree.c         | 8 ++++++--
 fs/xfs/scrub/nlinks.c          | 3 ++-
 5 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index a2f6a7f71d839..6e3fef36d6614 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -837,8 +837,12 @@ xrep_agi_buf_cleanup(
 {
 	struct xrep_agi	*ragi = buf;
 
-	xfarray_destroy(ragi->iunlink_prev);
-	xfarray_destroy(ragi->iunlink_next);
+	if (ragi->iunlink_prev)
+		xfarray_destroy(ragi->iunlink_prev);
+	ragi->iunlink_prev = NULL;
+	if (ragi->iunlink_next)
+		xfarray_destroy(ragi->iunlink_next);
+	ragi->iunlink_next = NULL;
 	xagino_bitmap_destroy(&ragi->iunlink_bmp);
 }
 
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index eded354dec11e..dd24044c44efd 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -1516,8 +1516,10 @@ xrep_xattr_teardown(
 		xfblob_destroy(rx->pptr_names);
 	if (rx->pptr_recs)
 		xfarray_destroy(rx->pptr_recs);
-	xfblob_destroy(rx->xattr_blobs);
-	xfarray_destroy(rx->xattr_records);
+	if (rx->xattr_blobs)
+		xfblob_destroy(rx->xattr_blobs);
+	if (rx->xattr_records)
+		xfarray_destroy(rx->xattr_records);
 	mutex_destroy(&rx->lock);
 	kfree(rx);
 }
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 7a21b688a4715..d5a55eabf6801 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -172,8 +172,12 @@ xrep_dir_teardown(
 	struct xrep_dir		*rd = sc->buf;
 
 	xrep_findparent_scan_teardown(&rd->pscan);
-	xfblob_destroy(rd->dir_names);
-	xfarray_destroy(rd->dir_entries);
+	if (rd->dir_names)
+		xfblob_destroy(rd->dir_names);
+	rd->dir_names = NULL;
+	if (rd->dir_entries)
+		xfarray_destroy(rd->dir_entries);
+	rd->dir_names = NULL;
 }
 
 /* Set up for a directory repair. */
diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index f9c85b8b194fa..3e0bbe75c44cf 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -81,8 +81,12 @@ xchk_dirtree_buf_cleanup(
 		kfree(path);
 	}
 
-	xfblob_destroy(dl->path_names);
-	xfarray_destroy(dl->path_steps);
+	if (dl->path_names)
+		xfblob_destroy(dl->path_names);
+	dl->path_names = NULL;
+	if (dl->path_steps)
+		xfarray_destroy(dl->path_steps);
+	dl->path_steps = NULL;
 	mutex_destroy(&dl->lock);
 }
 
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index 2ba686e4de8bc..dec3b9b47453e 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -971,7 +971,8 @@ xchk_nlinks_teardown_scan(
 
 	xfs_dir_hook_del(xnc->sc->mp, &xnc->dhook);
 
-	xfarray_destroy(xnc->nlinks);
+	if (xnc->nlinks)
+		xfarray_destroy(xnc->nlinks);
 	xnc->nlinks = NULL;
 
 	xchk_iscan_teardown(&xnc->collect_iscan);
-- 
2.51.0

