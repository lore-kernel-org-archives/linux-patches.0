Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4637133B6D1;
	Wed, 23 Sep 2026 14:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175304; cv=none; b=NuJukc4iyuky+LtYeVYbTm08wQfaeu0Ag4gqwwmLCY5+EZ2c2DtZheoxZr2ieeU8yJSX9ClaOk1sIPCUQDrjkE5OMyh+KbtioKKdyS5Z3JRfhfq+SXGgOqZlh19lEFgCtx4K9ZHk+BBtMkhgI8HE1SyKFl+FHAHVoUYW/MnwBAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175304; c=relaxed/simple;
	bh=JwTpeVjaKbwyNeo2Itjg8psdCMcxJSAP/NjC8ytA+YY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUjJGRoTwQp5uuUklSttRTJBeRKOPo/cqvqLEUMEtIpck98FJLIYbNKMRH6JFU2NXxefhwVW+A/w6PnxnlSvnvADkcqfuL3OOcADrjVhG2omNDJ5B9PFfuqeDW09V6uUrMWWO0pQ+GZwyoOGEc1L4hKUFobTG7xwGSiEWWhyq7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wjb6jIXv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wjb6jIXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2DC1F000FF;
	Wed, 23 Sep 2026 14:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175302;
	bh=KyYgEMpcI8ikE3Xu09P/Q0I3ssRoPAve4kTyzS3JKEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wjb6jIXv/4Kg23Sf48MvG6ubv373AQCrpbJcj+gj2PVU1beaj1Pwih/iLiiMSOV4M
	 WEjJ3Q4A/iWberTR1u/3DwdRCp7OOjFzS6BgxPphe42aLB4LAq+/XqacurlDpoj5CS
	 FBDp4hry9kvP+zBG/iUS2iiRYXlHd7PkstX/S5qI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 383/398] xfs: remove the i_ino field in struct xfs_inode
Date: Wed, 23 Sep 2026 16:07:37 +0200
Message-ID: <20260923140653.391099413@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 1113a6d6d5d1336f4415fa1367aac0f853f0892d ]

Now that the VFS inode has a u64 i_ino field, there is no need to store
a copy of the inode number in the xfs_inode structure.

Introduce an I_INO() wrapper as a shortcut to the inode number so that
we don't have to propagate the VFS inode everywhere.

The only non-obvious part is the clearing of i_ino to 0 for RCU freeing
the inode.  None of this calls into VFS paths, which makes clearing the
VFS inode field here just as safe as clearing the old field in the
xfs_inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>

Stable adaptation for dependency of 4d3c07591534517c633945c8d8e6526f10e3fabc:

The stable VFS inode still has an unsigned long i_ino, so retain the
64-bit xfs_inode::i_ino and its existing initialization/reclaim handling.
Define I_INO as a macro over that field instead of adding a function.
Keep only the owner conversions in xrep_xattr_swap_prep and
xrep_dir_swap_prep, which provide the context needed for the target to
apply unchanged.  Drop the remaining conversions, including changes to
helpers and health monitoring code absent from this stable tree.

Also finish the preceding dependency's helper conversion in the stable
xchk_rtsummary error path: call xchk_ip_xref_set_corrupt(sc, rbmip)
instead of the removed xchk_ino_xref_set_corrupt.  This preserves its
cross-reference corruption reporting and fixes the allmodconfig build.

[ sashal: Reduced backport -- upstream 1113a6d6d5d13 touches 91 file(s), this
  backport carries 4. Not backported here:
  fs/xfs/libxfs/xfs_attr.c
  fs/xfs/libxfs/xfs_attr_leaf.c
  fs/xfs/libxfs/xfs_bmap_btree.c
  fs/xfs/libxfs/xfs_bmap.c
  fs/xfs/libxfs/xfs_btree.c
  fs/xfs/libxfs/xfs_btree_staging.c
  fs/xfs/libxfs/xfs_da_btree.c
  fs/xfs/libxfs/xfs_dir2.c
  ... and 80 more
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: 4d3c07591534 ("xfs: fix under-reservation of blocks when repairing sf directories")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/attr_repair.c |    2 +-
 fs/xfs/scrub/dir_repair.c  |    2 +-
 fs/xfs/scrub/rtsummary.c   |    2 +-
 fs/xfs/xfs_inode.h         |    3 +++
 4 files changed, 6 insertions(+), 3 deletions(-)

--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -1295,7 +1295,7 @@ xrep_xattr_swap_prep(
 			.whichfork	= XFS_ATTR_FORK,
 			.trans		= sc->tp,
 			.total		= 1,
-			.owner		= sc->ip->i_ino,
+			.owner		= I_INO(sc->ip),
 		};
 
 		error = xfs_attr_shortform_to_leaf(&args);
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1474,7 +1474,7 @@ xrep_dir_swap_prep(
 			.whichfork	= XFS_DATA_FORK,
 			.trans		= sc->tp,
 			.total		= 1,
-			.owner		= sc->ip->i_ino,
+			.owner		= I_INO(sc->ip),
 		};
 
 		error = xfs_dir2_sf_to_block(&args);
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -359,7 +359,7 @@ xchk_rtsummary(
 		 * EFSCORRUPTED means the rtbitmap is corrupt, which is an xref
 		 * error since we're checking the summary file.
 		 */
-		xchk_ino_xref_set_corrupt(sc, rbmip->i_ino);
+		xchk_ip_xref_set_corrupt(sc, rbmip);
 		return 0;
 	}
 	if (error)
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -184,6 +184,9 @@ static inline const struct inode *VFS_IC
 	return &ip->i_vnode;
 }
 
+/* The VFS inode number is only unsigned long on this stable branch. */
+#define I_INO(ip)	((ip)->i_ino)
+
 /*
  * For regular files we only update the on-disk filesize when actually
  * writing data back to disk.  Until then only the copy in the VFS inode


