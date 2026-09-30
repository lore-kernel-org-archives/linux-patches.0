Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AAC524AED;
	Wed, 30 Sep 2026 17:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790453; cv=none; b=C35v7gyEdtlawt302+GmFdUS03gvbJpZikHmEr5OtLfQWcmdIIUpVEpDkSKUOaShujKHqLT7TkJM6qCfr7TmP1gOrlDZh1kDBb3k2Ikk8s93gfU5zhU1GHY7ze7ZnDyqWxeHJ4gQITbcw7PreNqL4/1+iPWYt14BArQtXm5TUNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790453; c=relaxed/simple;
	bh=WDJXDY+/PVb+cfp35t5jyXqUz+vAhbPZk7S2G3TJKQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEa542tKksMs69oDlpIByp4Ay+7XTWJiFFtbHLHSMaEldwkitETOWQhDE92H6kFB8xBwsrtOGo3hJ74upQz/d7dKH456EDxrjzCq84kRUYmBo5i2N1k92ZTI8us2h890jUxigG5E4yQgTuCrAXzQ0iIFbGcA6Y36JTDKK2uaVkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWtAxFnS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWtAxFnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB021F000FF;
	Wed, 30 Sep 2026 17:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790452;
	bh=T55WiVa3nAvWKuoyXQYyRJpPdejNh4q5VqYCqa/VKVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dWtAxFnSGseHU8fdMeSWI7YNNfb3vkh912gobZ0K8CQVImD1YEP6zNiQzUv2mqheM
	 RkG1gBOSFFOZQZROJBbwgfKHj8ebyi+WExYz6j92ahhit5Ssg9Zc5DK4HM2iyOn7Ql
	 5So4/Eshuu91WznHC+3EHAWBX14wDQkKtId+fb0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 780/877] xfs: remove the i_ino field in struct xfs_inode
Date: Wed, 30 Sep 2026 17:28:11 +0200
Message-ID: <20260930152431.545774483@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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

[6.12 dependency adaptation]

Keep only the inode-number accessor spelling needed for the attr and
directory repair hunks of 4d3c07591534517c633945c8d8e6526f10e3fabc to
apply cleanly.  Define I_INO as a macro over xfs_inode.i_ino and convert
only the two xfs_da_args.owner initializers in xrep_xattr_swap_prep and
xrep_dir_swap_prep.  No functions are added.

Unlike upstream, this stable tree still has an unsigned long VFS i_ino.
Retain the separate 64-bit XFS inode number and all existing allocation,
reinitialization, reclaim, and VFS setup behavior to avoid truncation on
32-bit systems.  Drop the remaining tree-wide conversions, including
changes to metadata-directory, realtime, and health-monitor files that
do not exist in this tree.  The accessor and the two substitutions are
behavior preserving; the reservation fix remains in the target commit.

Original upstream rationale follows:

Now that the VFS inode has a u64 i_ino field, there is no need to store
a copy of the inode number in the xfs_inode structure.

Introduce an I_INO() wrapper as a shortcut to the inode number so that
we don't have to propagate the VFS inode everywhere.

The only non-obvious part is the clearing of i_ino to 0 for RCU freeing
the inode.  None of this calls into VFS paths, which makes clearing the
VFS inode field here just as safe as clearing the old field in the
xfs_inode.

[ sashal: Reduced backport -- upstream 1113a6d6d5d13 touches 91 file(s), this
  backport carries 3. Not backported here:
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
 fs/xfs/xfs_inode.h         |    3 +++
 3 files changed, 5 insertions(+), 2 deletions(-)

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
@@ -1487,7 +1487,7 @@ xrep_dir_swap_prep(
 			.whichfork	= XFS_DATA_FORK,
 			.trans		= sc->tp,
 			.total		= 1,
-			.owner		= sc->ip->i_ino,
+			.owner		= I_INO(sc->ip),
 		};
 
 		error = xfs_dir2_sf_to_block(&args);
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -178,6 +178,9 @@ static inline const struct inode *VFS_IC
 	return &ip->i_vnode;
 }
 
+/* Keep the full inode number on systems with a 32-bit VFS i_ino. */
+#define I_INO(ip)	((ip)->i_ino)
+
 /*
  * For regular files we only update the on-disk filesize when actually
  * writing data back to disk.  Until then only the copy in the VFS inode


