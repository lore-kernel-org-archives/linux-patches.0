Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C491482F5;
	Wed,  7 May 2025 18:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644313; cv=none; b=tQLppXqggumAt1SzJvpij0MzPhPtCoHl997DX5mNqmgk2S3kUBOm6F5DRIBJKtq1JQqkTd9fXxxpZd8U+RjZZ7GdqnblazFcmBS+iRJ2ILFn52XRqugrcBQ/82NMCR52CunuU5Jy1vONSuvMikukTO3/jrEJFdNM83kMUjpCj4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644313; c=relaxed/simple;
	bh=kv4s2jPId6SPRf+c/UEOiHgKWvYS3Tcs5Jcjix5rzq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9h6E34h5sY+B4VUoDGxx/QosRM76IlKAn+GkZm8cHZhpXSdmnSkMP+Qb5ZTDzTMOnxVnPW7Sudw0TFhGek7KJp0fSYE2OWESDLR5ztDYJN/eo6xa9ELouxUzWUhckUfqDIFU4JMUgiAnxz4nbVnXWOvwKDOW1dXlk70MLEE6RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xb1UD39Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xb1UD39Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F945C4CEE2;
	Wed,  7 May 2025 18:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644312;
	bh=kv4s2jPId6SPRf+c/UEOiHgKWvYS3Tcs5Jcjix5rzq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xb1UD39Zh+MAv2c3+o9lFgmT7rVvttjy4qoGTR9mGB8XKnzULUbhhIIdQRb7vciO4
	 CaFld3amcPKiQ1qhms2g9/84d3974ewcnceKBoZ9jCFko2GMsS1QK/tcf+xNBj5vUZ
	 t1WfMI9nJzzXuzyro5m6W4y5HIo7+GBeKJq+k4p4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 179/183] btrfs: pass struct btrfs_inode to btrfs_iget_locked()
Date: Wed,  7 May 2025 20:40:24 +0200
Message-ID: <20250507183832.113666517@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit 4ea2fb9c628b55929bbc380d8c18733d1d027f1d ]

Pass a struct btrfs_inode to btrfs_inode() as it's an internal
interface, allowing to remove some use of BTRFS_I.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 48c1d1bb525b ("btrfs: fix the inode leak in btrfs_iget()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6d9d1c255285d..f6fc4c9ace28c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5601,7 +5601,7 @@ static int btrfs_find_actor(struct inode *inode, void *opaque)
 		args->root == BTRFS_I(inode)->root;
 }
 
-static struct inode *btrfs_iget_locked(u64 ino, struct btrfs_root *root)
+static struct btrfs_inode *btrfs_iget_locked(u64 ino, struct btrfs_root *root)
 {
 	struct inode *inode;
 	struct btrfs_iget_args args;
@@ -5613,7 +5613,9 @@ static struct inode *btrfs_iget_locked(u64 ino, struct btrfs_root *root)
 	inode = iget5_locked_rcu(root->fs_info->sb, hashval, btrfs_find_actor,
 			     btrfs_init_locked_inode,
 			     (void *)&args);
-	return inode;
+	if (!inode)
+		return NULL;
+	return BTRFS_I(inode);
 }
 
 /*
@@ -5623,22 +5625,22 @@ static struct inode *btrfs_iget_locked(u64 ino, struct btrfs_root *root)
 struct inode *btrfs_iget_path(u64 ino, struct btrfs_root *root,
 			      struct btrfs_path *path)
 {
-	struct inode *inode;
+	struct btrfs_inode *inode;
 	int ret;
 
 	inode = btrfs_iget_locked(ino, root);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
-	if (!(inode->i_state & I_NEW))
-		return inode;
+	if (!(inode->vfs_inode.i_state & I_NEW))
+		return &inode->vfs_inode;
 
-	ret = btrfs_read_locked_inode(BTRFS_I(inode), path);
+	ret = btrfs_read_locked_inode(inode, path);
 	if (ret)
 		return ERR_PTR(ret);
 
-	unlock_new_inode(inode);
-	return inode;
+	unlock_new_inode(&inode->vfs_inode);
+	return &inode->vfs_inode;
 }
 
 /*
@@ -5646,7 +5648,7 @@ struct inode *btrfs_iget_path(u64 ino, struct btrfs_root *root,
  */
 struct inode *btrfs_iget(u64 ino, struct btrfs_root *root)
 {
-	struct inode *inode;
+	struct btrfs_inode *inode;
 	struct btrfs_path *path;
 	int ret;
 
@@ -5654,20 +5656,20 @@ struct inode *btrfs_iget(u64 ino, struct btrfs_root *root)
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
-	if (!(inode->i_state & I_NEW))
-		return inode;
+	if (!(inode->vfs_inode.i_state & I_NEW))
+		return &inode->vfs_inode;
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return ERR_PTR(-ENOMEM);
 
-	ret = btrfs_read_locked_inode(BTRFS_I(inode), path);
+	ret = btrfs_read_locked_inode(inode, path);
 	btrfs_free_path(path);
 	if (ret)
 		return ERR_PTR(ret);
 
-	unlock_new_inode(inode);
-	return inode;
+	unlock_new_inode(&inode->vfs_inode);
+	return &inode->vfs_inode;
 }
 
 static struct inode *new_simple_dir(struct inode *dir,
-- 
2.39.5



