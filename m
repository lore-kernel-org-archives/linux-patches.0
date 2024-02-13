Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976095F54E;
	Tue, 13 Feb 2024 17:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845287; cv=none; b=F4AjFGG6rLG4yF1VjWqMTsXxh41XiYhmf+lai4TxEz1r04+m6nY3BLNHZ5/zCq3PzlfKp31uvxQpg6RFQmSFsaayhBsaqW3o1PHs6FgPkGuKcIKqX8mQRzLTxH+0AMQv4eTUkHe3ysHvZu/KySXBoH9VpoAeiZ3Jue0BegRtrTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845287; c=relaxed/simple;
	bh=Dj+NthXWLp22VvUg/igrJZFcSWlFlqvjSJeVXjIaQfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWoVmuv78Hxc0ddF5BDyYsZiE70/X8PeFD4BiWEG30/M+Qa9pW60D3WmrjWL4Ov+03P67RySyB0gT/S++QgUT5yJ8MmUeY1gDe45E4KnSqXiibT+Ihjal2ZYqL9SQk75lUybsV5IR1ifjT/LRc+kcHBu7GnXcxH2Gf514MbLdMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NEJKQPwn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NEJKQPwn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81DBC433F1;
	Tue, 13 Feb 2024 17:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845287;
	bh=Dj+NthXWLp22VvUg/igrJZFcSWlFlqvjSJeVXjIaQfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NEJKQPwnU75vr9ABl905cYfwCVnKAJMncx3fBf7ClJUPyXvRVWWsLILEUBN2y0bMM
	 9sontuq+ki7tg5WaNtvHBuSFtZKNiQE8CWAwlIeK/vIwk1NWS0XVI/mzG4CfANNfx9
	 4NNZAJB78yuDl/bKu5KoUQlJ6te/yGfzGoJl6xs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/121] xfs: respect the stable writes flag on the RT device
Date: Tue, 13 Feb 2024 18:20:46 +0100
Message-ID: <20240213171854.082664630@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 9c04138414c00ae61421f36ada002712c4bac94a upstream.

Update the per-folio stable writes flag dependening on which device an
inode resides on.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20231025141020.192413-5-hch@lst.de
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_inode.h | 8 ++++++++
 fs/xfs/xfs_ioctl.c | 8 ++++++++
 fs/xfs/xfs_iops.c  | 7 +++++++
 3 files changed, 23 insertions(+)

diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 3dc47937da5d..3beb470f1892 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -569,6 +569,14 @@ extern void xfs_setup_inode(struct xfs_inode *ip);
 extern void xfs_setup_iops(struct xfs_inode *ip);
 extern void xfs_diflags_to_iflags(struct xfs_inode *ip, bool init);
 
+static inline void xfs_update_stable_writes(struct xfs_inode *ip)
+{
+	if (bdev_stable_writes(xfs_inode_buftarg(ip)->bt_bdev))
+		mapping_set_stable_writes(VFS_I(ip)->i_mapping);
+	else
+		mapping_clear_stable_writes(VFS_I(ip)->i_mapping);
+}
+
 /*
  * When setting up a newly allocated inode, we need to call
  * xfs_finish_inode_setup() once the inode is fully instantiated at
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index be69e7be713e..535f6d38cdb5 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1149,6 +1149,14 @@ xfs_ioctl_setattr_xflags(
 	ip->i_diflags2 = i_flags2;
 
 	xfs_diflags_to_iflags(ip, false);
+
+	/*
+	 * Make the stable writes flag match that of the device the inode
+	 * resides on when flipping the RT flag.
+	 */
+	if (rtflag != XFS_IS_REALTIME_INODE(ip) && S_ISREG(VFS_I(ip)->i_mode))
+		xfs_update_stable_writes(ip);
+
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	XFS_STATS_INC(mp, xs_ig_attrchg);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 2b3b05c28e9e..b8ec045708c3 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1298,6 +1298,13 @@ xfs_setup_inode(
 	gfp_mask = mapping_gfp_mask(inode->i_mapping);
 	mapping_set_gfp_mask(inode->i_mapping, (gfp_mask & ~(__GFP_FS)));
 
+	/*
+	 * For real-time inodes update the stable write flags to that of the RT
+	 * device instead of the data device.
+	 */
+	if (S_ISREG(inode->i_mode) && XFS_IS_REALTIME_INODE(ip))
+		xfs_update_stable_writes(ip);
+
 	/*
 	 * If there is no attribute fork no ACL can exist on this inode,
 	 * and it can't have any file capabilities attached to it either.
-- 
2.43.0



