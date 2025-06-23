Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E3B1EE7C6;
	Mon, 23 Jun 2025 21:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714544; cv=none; b=WmLtGXoCQWVxhv9CMqnmfaMZBuWBjSuvro4zZVtTAUvf5+1hESH2SwWGHyQvK/mhntADNP3YLc4hSQBwNNI71eNwz5bJr0xEVs/EpirjRmZKjg6fEYibRt5naiZaWDrrNfbz1BHP2lrdzUmYtOUELVyUixwx2hAfIOsw333QB+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714544; c=relaxed/simple;
	bh=u1AAgfTIpkNVxSHViYjjXm4jzeOKznoUpp2MiQIYiWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQe06LYguedWpHfvwaInfkJj1ELVSsZkNVIUS701A+K+0+s145sEvGKs320M9ePh6KB06N719q+VA5ZIKYBl30Kmn5/4TqmgCww5+UZhH3PANxcO2iI8zV5bkLK4rlUSasP2UjczI1fPnrQ/KOoI9o94B1VJoPYRruhjife5EiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZbjWNPAS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZbjWNPAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B040C4CEEA;
	Mon, 23 Jun 2025 21:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714543;
	bh=u1AAgfTIpkNVxSHViYjjXm4jzeOKznoUpp2MiQIYiWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZbjWNPAS6pJgfowl7r52zQGjCC7iROVJBSUDfHa6RYXOCHohRc8LkxViVRxLcQSzl
	 LtXi1/1Scolf50lOll1ScWVt1llgzgpM4bMipegc40vrnSzvr86a2qeBePmy/go/oY
	 sY80C+s1qIxACgQLFgTdBH5Bs/b1ClOGX79A4VAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 201/508] xfs: use consistent uid/gid when grabbing dquots for inodes
Date: Mon, 23 Jun 2025 15:04:06 +0200
Message-ID: <20250623130650.215459505@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit  24a4e1cb322e2bf0f3a1afd1978b610a23aa8f36 ]

[ 6.1: resolved conflicts in xfs_inode.c and xfs_symlink.c due to 6.1
not having switched to idmap yet ]

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
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_inode.c   | 16 ++++++++++------
 fs/xfs/xfs_symlink.c |  8 +++++---
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b26d26d29273d..88d0a088fa862 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -983,10 +983,12 @@ xfs_create(
 	prid = xfs_get_initial_prid(dp);
 
 	/*
-	 * Make sure that we have allocated dquot(s) on disk.
+	 * Make sure that we have allocated dquot(s) on disk.  The uid/gid
+	 * computation code must match what the VFS uses to assign i_[ug]id.
+	 * INHERIT adjusts the gid computation for setgid/grpid systems.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(mnt_userns, &init_user_ns),
-			mapped_fsgid(mnt_userns, &init_user_ns), prid,
+	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(mnt_userns, i_user_ns(VFS_I(dp))),
+			mapped_fsgid(mnt_userns, i_user_ns(VFS_I(dp))), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
@@ -1132,10 +1134,12 @@ xfs_create_tmpfile(
 	prid = xfs_get_initial_prid(dp);
 
 	/*
-	 * Make sure that we have allocated dquot(s) on disk.
+	 * Make sure that we have allocated dquot(s) on disk.  The uid/gid
+	 * computation code must match what the VFS uses to assign i_[ug]id.
+	 * INHERIT adjusts the gid computation for setgid/grpid systems.
 	 */
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(mnt_userns, &init_user_ns),
-			mapped_fsgid(mnt_userns, &init_user_ns), prid,
+	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(mnt_userns, i_user_ns(VFS_I(dp))),
+			mapped_fsgid(mnt_userns, i_user_ns(VFS_I(dp))), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 8389f3ef88ef2..78bd02a98aa53 100644
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
-	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(mnt_userns, &init_user_ns),
-			mapped_fsgid(mnt_userns, &init_user_ns), prid,
+	error = xfs_qm_vop_dqalloc(dp, mapped_fsuid(mnt_userns, i_user_ns(VFS_I(dp))),
+			mapped_fsgid(mnt_userns, i_user_ns(VFS_I(dp))), prid,
 			XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
 			&udqp, &gdqp, &pdqp);
 	if (error)
-- 
2.39.5



