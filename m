Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BA734D93C;
	Fri, 21 Nov 2025 13:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732975; cv=none; b=lZsTsvppq12C6KVQrpHGxnQOlL0kwzsEys7cG23wkyP21hLUt5ubwOrBOr+2fFXytZgJ2Wq2hAlUup8BXVpn8LByqYWfpmPM7k5jczXSIvvR96hDCJAw8dlAzZMLp1dLMvMKKawiVZR6xADljrqRBzVWC1sI7t0unkc11V+WdDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732975; c=relaxed/simple;
	bh=D0/kkjOnYnsMiDTbhR5fYY1ri0Xd9Tyvbpn8pZfQzTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHOWnfizFuylimw8pq0umLIlJi3tf1br8aoj8lMEa3axiPGkVzYFdWzWp1fouAeLjW0kbP4mVCfh2hRjeKR3ThITKjCzXEJpacyO9g5hX/EJVN+rJubOsIqmJjvX4ODU0CUqKjiVgBhQj9M6S7BBEokYO/tGoF3jFm2OAf8dafE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nsKtybmi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nsKtybmi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF08C4CEFB;
	Fri, 21 Nov 2025 13:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732975;
	bh=D0/kkjOnYnsMiDTbhR5fYY1ri0Xd9Tyvbpn8pZfQzTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nsKtybmi4W/soVrl/PyfTd26sgGnZh9YSXBPqVZ6AqFbaikpm1lCdSSh0KZY2lrnJ
	 I777/DIHG392AkV3IuzWP83Ka3/ajbSOjJVZbV23cosqAni+QfP0KDPLVUIoI/QjhX
	 Wxb8cxrxd7j2iqGyCSBjtkzAC7m8iPQgLZhHelkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yikang Yue <yikangy2@illinois.edu>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 306/529] fs/hpfs: Fix error code for new_inode() failure in mkdir/create/mknod/symlink
Date: Fri, 21 Nov 2025 14:10:05 +0100
Message-ID: <20251121130241.911727143@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f4eb8d6f59894..6cf17fe239c9a 100644
--- a/fs/hpfs/namei.c
+++ b/fs/hpfs/namei.c
@@ -52,8 +52,10 @@ static int hpfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
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
@@ -153,9 +155,10 @@ static int hpfs_create(struct mnt_idmap *idmap, struct inode *dir,
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
@@ -239,9 +242,10 @@ static int hpfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
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
@@ -314,8 +318,10 @@ static int hpfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
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



