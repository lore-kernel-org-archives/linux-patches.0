Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5315813BC0C;
	Mon, 23 Dec 2024 16:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970228; cv=none; b=qPpTCeUAnM1fUxcupYOqPuQE4VzsTF5z1HxPFm9CNKEwSKNMIazArNrYCcG8qSrlcX875LxPvWHC6IV64MbERqf0UmC+p90opD25u2lwsJahSgfrGWMAqEXIk2cxt3+chCmwEdQP82j+5xVGUL41DMHty9+Jb54y/Rjed+juAs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970228; c=relaxed/simple;
	bh=K1rKnZPHyntkAiBdGtI63CwiQZMUvsQwia/SJlpGeJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGtIPI3ny2yfT2/chOmv7yIMU+/eUiQ5elQyZVEA7AFAbpppJKUiLSZYhTTF4/E7ZBYy1GIOKUzSIFqgnxoQtEYcHvT2sXl8fhDJvXHoloOFkdJEJVXlivof2o8Pp5Rzo07gqNMCPwomxXtSBi/dKTGsoC0sNOAUqzZIWeVlPo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hVxySnUI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hVxySnUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB40C4CED3;
	Mon, 23 Dec 2024 16:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970228;
	bh=K1rKnZPHyntkAiBdGtI63CwiQZMUvsQwia/SJlpGeJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hVxySnUIrI256oHXW6ZPaS1DymzW22UKKXu9JD8FGPxcXZt8kvVJUzEDfxQzSjU17
	 5zXu8SHsFV5C7HOu+/Zi4AvfxccenqLKX7EKtBR1yH0hhHJhI/tYy2KkPfag3iklU5
	 /keCGm65xBfnzJexFtpV8qqEPSQnrl3WzQYWR0Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/116] xfs: use consistent uid/gid when grabbing dquots for inodes
Date: Mon, 23 Dec 2024 16:58:11 +0100
Message-ID: <20241223155400.387736628@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 24a4e1cb322e2bf0f3a1afd1978b610a23aa8f36 upstream.

I noticed that callers of xfs_qm_vop_dqalloc use the following code to
compute the anticipated uid of the new file:

	mapped_fsuid(idmap, &init_user_ns);

whereas the VFS uses a slightly different computation for actually
assigning i_uid:

	mapped_fsuid(idmap, i_user_ns(inode));

Technically, these are not the same things.  According to Christian
Brauner, the only time that inode->i_sb->s_user_ns != &init_user_ns is
when the filesystem was mounted in a new mount namespace by an
unpriviledged user.  XFS does not allow this, which is why we've never
seen bug reports about quotas being incorrect or the uid checks in
xfs_qm_vop_create_dqattach tripping debug assertions.

However, this /is/ a logic bomb, so let's make the code consistent.

Link: https://lore.kernel.org/linux-fsdevel/20240617-weitblick-gefertigt-4a41f37119fa@brauner/
Fixes: c14329d39f2d ("fs: port fs{g,u}id helpers to mnt_idmap")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_inode.c   | 16 ++++++++++------
 fs/xfs/xfs_symlink.c |  8 +++++---
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7aa73855fab6..1e50cc9a29db 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -982,10 +982,12 @@ xfs_create(
 	prid = xfs_get_initial_prid(dp);
 
 	/*
-	 * Make sure that we have allocated dquot(s) on disk.
+	 * Make sure that we have allocated dquot(s) on disk.  The uid/gid
+	 * computation code must match what the VFS uses to assign i_[ug]id.
+	 * INHERIT adjusts the gid computation for setgid/grpid systems.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, &init_user_ns),
-			mapped_fsgid(idmap, &init_user_ns), prid,
+	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, i_user_ns(VFS_I(dp))),
+			mapped_fsgid(idmap, i_user_ns(VFS_I(dp))), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
@@ -1131,10 +1133,12 @@ xfs_create_tmpfile(
 	prid = xfs_get_initial_prid(dp);
 
 	/*
-	 * Make sure that we have allocated dquot(s) on disk.
+	 * Make sure that we have allocated dquot(s) on disk.  The uid/gid
+	 * computation code must match what the VFS uses to assign i_[ug]id.
+	 * INHERIT adjusts the gid computation for setgid/grpid systems.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, &init_user_ns),
-			mapped_fsgid(idmap, &init_user_ns), prid,
+	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, i_user_ns(VFS_I(dp))),
+			mapped_fsgid(idmap, i_user_ns(VFS_I(dp))), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 85e433df6a3f..b08be64dd10b 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -191,10 +191,12 @@ xfs_symlink(
 	prid = xfs_get_initial_prid(dp);
 
 	/*
-	 * Make sure that we have allocated dquot(s) on disk.
+	 * Make sure that we have allocated dquot(s) on disk.  The uid/gid
+	 * computation code must match what the VFS uses to assign i_[ug]id.
+	 * INHERIT adjusts the gid computation for setgid/grpid systems.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, &init_user_ns),
-			mapped_fsgid(idmap, &init_user_ns), prid,
+	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(idmap, i_user_ns(VFS_I(dp))),
+			mapped_fsgid(idmap, i_user_ns(VFS_I(dp))), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
-- 
2.39.5



