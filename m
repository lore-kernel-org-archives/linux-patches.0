Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E9F384CCD;
	Thu, 17 Sep 2026 17:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667031; cv=none; b=Ptya8GvAsQzwYwGHQIKwS0e0izKUSJPeZG2HvoWM7SOEsPMfaJ5gY2Hu6wCYIPbfudY+GnZEZFe+8pPbXR5Yf134rD5CfPg83lqk8uzo6iXYfBQy9aIC8R7WFEOVjEKmaJ+aeGwDS8oBbZyHst6nYDaQEwmYISszDFNmONK0JW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667031; c=relaxed/simple;
	bh=IYgSry4DEIzIiMxqUJb9oTwb0NS3rEwCFrV6G2nUrq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJNjKSwDVLSgiAFtEI9aHY0DhtM2BcGu3F/8i7OQ/o2y3iRmS+MwSx2Q77dQnVI5TpOam8i9gdDcQ6mrl1pPafi5SkiBE22FAEDpieP97FSZ8jgZXgrNCcDO/e3OwZprtQnzIYzPF1ed14TDbbT07yyoI7v7lrzQOkeWeVvP1EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xEFg8Paw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xEFg8Paw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08ECF1F000FF;
	Thu, 17 Sep 2026 17:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667029;
	bh=9bbnUGLfRuEBX3PlTfWi2T3hCmeGEblZnPy+Uhz4oY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xEFg8PawZrxqUg6WDIlCj8eqITCdH16wq6kab9+v0wkYAd4LcFSRa/33Q0TejO1Z+
	 LUr/lRC2bM9/ZutHTZd+Fshz9olvtZaXObVlksbPosNTEUMcFph7riVfBb4Nryazxr
	 UXXkZClkc2lRYrr9klXHnrF573iRL7HTllGt03G8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Tia <floss@jetm.me>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Javier Tia <javier@peridio.com>
Subject: [PATCH 6.18 1205/1250] xfs: initialise args->total for parent pointer updates
Date: Thu, 17 Sep 2026 16:16:40 +0100
Message-ID: <20260917151624.943399408@linuxfoundation.org>
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

From: Javier Tia <javier@peridio.com>

commit 8e4ebb6afaa34bd2e8ce52da231003d24111c2d6 upstream.

xfs_parent_da_args_init() builds an xfs_da_args from a zeroed
xfs_parent_args (kmem_cache_zalloc), leaving args->total == 0.
xfs_da_grow_inode_int() treats that field as a running block reservation
and subtracts from it; because it is an xfs_extlen_t (uint32_t), the
first attr-fork growth wraps it to ~0U.  That defeats the free-space
check in xfs_alloc_space_available(), and when it coincides with an AG
that has exactly zero available blocks the allocation is clamped to
maxlen 0 and returns -ENOSPC, which xfs_defer_finish_noroll() escalates
to a filesystem shutdown.

Set args->total the way the log recovery path does
(xfs_attri_recover_work(), xfs_attr_item.c:706), in the add and replace
paths that can grow the fork.  Removals and lookups never grow it, so
they leave the field alone, matching that switch.

Fixes: b7c62d90c12c ("xfs: parent pointer attribute creation")
Cc: stable@vger.kernel.org # v6.10
Signed-off-by: Javier Tia <floss@jetm.me>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ Backported to 6.12.y and 6.18.y, whose fs/xfs/libxfs/xfs_parent.c are
  byte-identical.  These trees queue the operation with
  xfs_attr_defer_add() instead of calling xfs_attr_setname() and
  xfs_attr_replacename() directly, and spell the inode number
  child->i_ino rather than I_INO(child), so the upstream hunks do not
  apply as-is.  The defect is unchanged: xfs_attr_defer_add() stores a
  pointer to this same xfs_da_args, and xfs_attr_finish_item() resets
  only args->trans, so the zeroed total still reaches
  xfs_da_grow_inode_int().  The assignment therefore goes in the same
  place, before the operation is queued.  xfs_attr_calc_size() needs no
  new include: it is declared in xfs_attr.h, which xfs_parent.c already
  includes. ]
Signed-off-by: Javier Tia <javier@peridio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_parent.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -193,7 +193,7 @@ xfs_parent_addname(
 	const struct xfs_name	*parent_name,
 	struct xfs_inode	*child)
 {
-	int			error;
+	int			error, local;
 
 	error = xfs_parent_iread_extents(tp, child);
 	if (error)
@@ -202,6 +202,11 @@ xfs_parent_addname(
 	xfs_inode_to_parent_rec(&ppargs->rec, dp);
 	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
 			child->i_ino, parent_name);
+
+	/* Growing the attr fork needs a real reservation in args->total. */
+	ppargs->args.total = xfs_attr_calc_size(&ppargs->args, &local);
+	ASSERT(local);
+
 	xfs_attr_defer_add(&ppargs->args, XFS_ATTR_DEFER_SET);
 	return 0;
 }
@@ -239,7 +244,7 @@ xfs_parent_replacename(
 	const struct xfs_name	*new_name,
 	struct xfs_inode	*child)
 {
-	int			error;
+	int			error, local;
 
 	error = xfs_parent_iread_extents(tp, child);
 	if (error)
@@ -249,6 +254,10 @@ xfs_parent_replacename(
 	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
 			child->i_ino, old_name);
 
+	/* Growing the attr fork needs a real reservation in args->total. */
+	ppargs->args.total = xfs_attr_calc_size(&ppargs->args, &local);
+	ASSERT(local);
+
 	xfs_inode_to_parent_rec(&ppargs->new_rec, new_dp);
 	ppargs->args.new_name = new_name->name;
 	ppargs->args.new_namelen = new_name->len;


