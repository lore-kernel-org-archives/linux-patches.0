Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9447018BC36;
	Mon, 24 Feb 2025 14:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407789; cv=none; b=lQym6D/ZclbAgvUN8DBK42vOzCoy4ubMMeeN1mshUsrMbyJ6G4tXmzwp5wWMVN+xQAhyyjqK3+vxYse1XTlyLufQhHLMEQ/dk/miydQ1xmO8a+pk+hhlWR4A6uJENt0yv2XOsvJSYRKAbrW0tas5YcNrxQ8oyDJmVu2eCdvCHLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407789; c=relaxed/simple;
	bh=08p4jlYvoUaSy9Vize2HfA1NhPwe8Q3z13p/M6ZAhdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V46mIZGVOX1vTkwBc/0vK6QpU3z31s5qcqWWQvriCeiYe6T/4HRZf3rwKr8Y3XVG6HyragcBZONYCALLC39oGmyTIkgp9Jg5Pl7PwfzqHBXoYBNnGbL+/xq+HUAL/WdZwAVd0k5NGCSgQJUR1EeDripO3QnXftK/6rZxPpaly+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=igcq683j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="igcq683j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83E3C4CED6;
	Mon, 24 Feb 2025 14:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407789;
	bh=08p4jlYvoUaSy9Vize2HfA1NhPwe8Q3z13p/M6ZAhdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=igcq683jviTtqzWpGDf/axT8RDEgmBrnG62UusWFMz4ewH3RTKTEnlQqVTBMOpIys
	 lZlKIoqsL+DtsCfb8rZX1/1boY0qBHTCz9ZivdB9KBO1itxR0pLRgJtbSa6WDYMW5c
	 uknysaMAE6Kf6DhR3FmunRHNm6007DvpM572U5so=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xfs-stable@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 010/140] xfs: distinguish extra split from real ENOSPC from xfs_attr3_leaf_split
Date: Mon, 24 Feb 2025 15:33:29 +0100
Message-ID: <20250224142603.415404466@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

commit a5f73342abe1f796140f6585e43e2aa7bc1b7975 upstream.

xfs_attr3_leaf_split propagates the need for an extra btree split as
-ENOSPC to it's only caller, but the same return value can also be
returned from xfs_da_grow_inode when it fails to find free space.

Distinguish the two cases by returning 1 for the extra split case instead
of overloading -ENOSPC.

This can be triggered relatively easily with the pending realtime group
support and a file system with a lot of small zones that use metadata
space on the main device.  In this case every about 5-10th run of
xfs/538 runs into the following assert:

	ASSERT(oldblk->magic == XFS_ATTR_LEAF_MAGIC);

in xfs_attr3_leaf_split caused by an allocation failure.  Note that
the allocation failure is caused by another bug that will be fixed
subsequently, but this commit at least sorts out the error handling.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |    5 ++++-
 fs/xfs/libxfs/xfs_da_btree.c  |    5 +++--
 2 files changed, 7 insertions(+), 3 deletions(-)

--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1340,6 +1340,9 @@ xfs_attr3_leaf_create(
 
 /*
  * Split the leaf node, rebalance, then add the new entry.
+ *
+ * Returns 0 if the entry was added, 1 if a further split is needed or a
+ * negative error number otherwise.
  */
 int
 xfs_attr3_leaf_split(
@@ -1396,7 +1399,7 @@ xfs_attr3_leaf_split(
 	oldblk->hashval = xfs_attr_leaf_lasthash(oldblk->bp, NULL);
 	newblk->hashval = xfs_attr_leaf_lasthash(newblk->bp, NULL);
 	if (!added)
-		return -ENOSPC;
+		return 1;
 	return 0;
 }
 
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -522,9 +522,8 @@ xfs_da3_split(
 		switch (oldblk->magic) {
 		case XFS_ATTR_LEAF_MAGIC:
 			error = xfs_attr3_leaf_split(state, oldblk, newblk);
-			if ((error != 0) && (error != -ENOSPC)) {
+			if (error < 0)
 				return error;	/* GROT: attr is inconsistent */
-			}
 			if (!error) {
 				addblk = newblk;
 				break;
@@ -546,6 +545,8 @@ xfs_da3_split(
 				error = xfs_attr3_leaf_split(state, newblk,
 							    &state->extrablk);
 			}
+			if (error == 1)
+				return -ENOSPC;
 			if (error)
 				return error;	/* GROT: attr inconsistent */
 			addblk = newblk;


