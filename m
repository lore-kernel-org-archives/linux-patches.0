Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBC814A633;
	Thu, 23 May 2024 13:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470397; cv=none; b=YyQcA/onpnvNABwm4MDYvlbWSGujU5ndICoQ5vvcT6pP9maEmBJ3V/j1JpKEYm1PG4TT2j12Gm1tiWqH/xWkYDaeZwBS0dYYdvFRFnllUiT0TwBIW4bw0RSsYphnWu8GV7Lpx1GA5NFFyxCH/8d6dXoK/pcZQ190cBEw+FJJVP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470397; c=relaxed/simple;
	bh=4+/GpNoM+ATqIdmj45tF2O3A2LfNs1ZUxy/c6LNJCG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJxMnjvBc4uZGZpql+/hWAW1YIvQ6J/wTP5RB1Y6dmGXD3RH7plFe/sShocIXbZuqB6IKwDsY7qAXdA3KSXIilUUqz09JiG2l6MGIT2TXy3p0JW8jngy0vA3CW3gLRpnt9G66WvuId6pc054GtZ2XcQxzSUciBzp5KiPztYbUoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NJkejf0N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NJkejf0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3DDC32782;
	Thu, 23 May 2024 13:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470397;
	bh=4+/GpNoM+ATqIdmj45tF2O3A2LfNs1ZUxy/c6LNJCG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NJkejf0Ng3t/xqKk2bN+QLiAZj0wHynRmAzoXD2bFqzIQ8R8O2z2JyfucPWHgs+u6
	 6Xv70idvbTwHOXaHJqFoIZwESiG1dW7O0tbi1oBpR7m133W6jUSrmVHZEV9gd76kDR
	 5y8cPm9VN4FjV324LNHG3o+atCnteBvWnwGvTnEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 22/45] xfs: fix incorrect i_nlink caused by inode racing
Date: Thu, 23 May 2024 15:13:13 +0200
Message-ID: <20240523130333.331467544@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
References: <20240523130332.496202557@linuxfoundation.org>
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

From: Long Li <leo.lilong@huawei.com>

[ Upstream commit 28b4b0596343d19d140da059eee0e5c2b5328731 ]

The following error occurred during the fsstress test:

XFS: Assertion failed: VFS_I(ip)->i_nlink >= 2, file: fs/xfs/xfs_inode.c, line: 2452

The problem was that inode race condition causes incorrect i_nlink to be
written to disk, and then it is read into memory. Consider the following
call graph, inodes that are marked as both XFS_IFLUSHING and
XFS_IRECLAIMABLE, i_nlink will be reset to 1 and then restored to original
value in xfs_reinit_inode(). Therefore, the i_nlink of directory on disk
may be set to 1.

  xfsaild
      xfs_inode_item_push
          xfs_iflush_cluster
              xfs_iflush
                  xfs_inode_to_disk

  xfs_iget
      xfs_iget_cache_hit
          xfs_iget_recycle
              xfs_reinit_inode
                  inode_init_always

xfs_reinit_inode() needs to hold the ILOCK_EXCL as it is changing internal
inode state and can race with other RCU protected inode lookups. On the
read side, xfs_iflush_cluster() grabs the ILOCK_SHARED while under rcu +
ip->i_flags_lock, and so xfs_iflush/xfs_inode_to_disk() are protected from
racing inode updates (during transactions) by that lock.

Fixes: ff7bebeb91f8 ("xfs: refactor the inode recycling code") # goes further back than this
Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_icache.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -342,6 +342,9 @@ xfs_iget_recycle(
 
 	trace_xfs_iget_recycle(ip);
 
+	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
+		return -EAGAIN;
+
 	/*
 	 * We need to make it look like the inode is being reclaimed to prevent
 	 * the actual reclaim workers from stomping over us while we recycle
@@ -355,6 +358,7 @@ xfs_iget_recycle(
 
 	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
 	error = xfs_reinit_inode(mp, inode);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	if (error) {
 		/*
 		 * Re-initializing the inode failed, and we are in deep
@@ -523,6 +527,8 @@ xfs_iget_cache_hit(
 	if (ip->i_flags & XFS_IRECLAIMABLE) {
 		/* Drops i_flags_lock and RCU read lock. */
 		error = xfs_iget_recycle(pag, ip);
+		if (error == -EAGAIN)
+			goto out_skip;
 		if (error)
 			return error;
 	} else {


