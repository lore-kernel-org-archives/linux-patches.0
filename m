Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930AF314A80;
	Wed,  3 Dec 2025 15:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776317; cv=none; b=Z2nAYYpRef+iHE8b4tXeFKyuc4iHhIYSs+ox1NYjZBI8bkfXfoTkYKK4Mls4C3Gm9+U1UMqq4yP1eOUNJ2R0Lg0d5U3jAO1JX1MtpI9csOIBisVTcOi1WD52CYozwP+7VWhFs5diIcGjjrbNOcFCzow3fQQH4U3H77HcV7Y8huQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776317; c=relaxed/simple;
	bh=6eBfr+jhhWpwshEiuubEJ9ISNEbWuD728cL3lfOrWHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VILDTi9tePM5p45aL1tEt4a6fKM7UkPKFearYJbKVQDRk2GfuI9two+ntkHRGOor3BBp40KmqjdU3yahQBIAFQufwdBZBuLV4mL4SKi9nUFNsSr3PV5u1kiM1fDwBXf1zgcmicS5OllIBT672+VpUEX+Vx96fI32UpURqPq6Wzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dj0NbDRB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dj0NbDRB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3BD7C4CEF5;
	Wed,  3 Dec 2025 15:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776317;
	bh=6eBfr+jhhWpwshEiuubEJ9ISNEbWuD728cL3lfOrWHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dj0NbDRBzhiA+2xvjV3Tl3KX7/RYRuxauc+KWJ2czJLa+CzBVjxh7xlt04dbSuc+p
	 8GZwdGAHljzIzcPy8RBvaznpoZmh+arifR9MWXwLkjFWXyT4+H/DVDBDMlNz4oXA0U
	 Cab0wDi2CtJpjyezlFRO0tyRX8FmvmrgqUP5W8SA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yikang Yue <yikangy2@illinois.edu>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 147/300] fs/hpfs: Fix error code for new_inode() failure in mkdir/create/mknod/symlink
Date: Wed,  3 Dec 2025 16:25:51 +0100
Message-ID: <20251203152406.063984762@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yikang Yue <yikangy2@illinois.edu>

[ Upstream commit 32058c38d3b79a28963a59ac0353644dc24775cd ]

The function call new_inode() is a primitive for allocating an inode in memory,
rather than planning disk space for it. Therefore, -ENOMEM should be returned
as the error code rather than -ENOSPC.

To be specific, new_inode()'s call path looks like this:
new_inode
  new_inode_pseudo
    alloc_inode
      ops->alloc_inode (hpfs_alloc_inode)
        alloc_inode_sb
          kmem_cache_alloc_lru

Therefore, the failure of new_inode() indicates a memory presure issue (-ENOMEM),
not a lack of disk space. However, the current implementation of
hpfs_mkdir/create/mknod/symlink incorrectly returns -ENOSPC when new_inode() fails.
This patch fix this by set err to -ENOMEM before the goto statement.

BTW, we also noticed that other nested calls within these four functions,
like hpfs_alloc_f/dnode and hpfs_add_dirent, might also fail due to memory presure.
But similarly, only -ENOSPC is returned. Addressing these will involve code
modifications in other functions, and we plan to submit dedicated patches for these
issues in the future. For this patch, we focus on new_inode().

Signed-off-by: Yikang Yue <yikangy2@illinois.edu>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hpfs/namei.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/hpfs/namei.c b/fs/hpfs/namei.c
index 1aee39160ac5b..bc1309ef4cfa5 100644
--- a/fs/hpfs/namei.c
+++ b/fs/hpfs/namei.c
@@ -52,8 +52,10 @@ static int hpfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	dee.fnode = cpu_to_le32(fno);
 	dee.creation_date = dee.write_date = dee.read_date = cpu_to_le32(local_get_seconds(dir->i_sb));
 	result = new_inode(dir->i_sb);
-	if (!result)
+	if (!result) {
+		err = -ENOMEM;
 		goto bail2;
+	}
 	hpfs_init_inode(result);
 	result->i_ino = fno;
 	hpfs_i(result)->i_parent_dir = dir->i_ino;
@@ -154,9 +156,10 @@ static int hpfs_create(struct inode *dir, struct dentry *dentry, umode_t mode, b
 	dee.creation_date = dee.write_date = dee.read_date = cpu_to_le32(local_get_seconds(dir->i_sb));
 
 	result = new_inode(dir->i_sb);
-	if (!result)
+	if (!result) {
+		err = -ENOMEM;
 		goto bail1;
-	
+	}
 	hpfs_init_inode(result);
 	result->i_ino = fno;
 	result->i_mode |= S_IFREG;
@@ -241,9 +244,10 @@ static int hpfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, de
 	dee.creation_date = dee.write_date = dee.read_date = cpu_to_le32(local_get_seconds(dir->i_sb));
 
 	result = new_inode(dir->i_sb);
-	if (!result)
+	if (!result) {
+		err = -ENOMEM;
 		goto bail1;
-
+	}
 	hpfs_init_inode(result);
 	result->i_ino = fno;
 	hpfs_i(result)->i_parent_dir = dir->i_ino;
@@ -317,8 +321,10 @@ static int hpfs_symlink(struct inode *dir, struct dentry *dentry, const char *sy
 	dee.creation_date = dee.write_date = dee.read_date = cpu_to_le32(local_get_seconds(dir->i_sb));
 
 	result = new_inode(dir->i_sb);
-	if (!result)
+	if (!result) {
+		err = -ENOMEM;
 		goto bail1;
+	}
 	result->i_ino = fno;
 	hpfs_init_inode(result);
 	hpfs_i(result)->i_parent_dir = dir->i_ino;
-- 
2.51.0



