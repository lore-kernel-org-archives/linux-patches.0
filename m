Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BE5359FAD;
	Fri,  9 Jan 2026 12:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960024; cv=none; b=H6I5aPLy4pcvKlKRopIyIHpTFtWeNqip1oWcd7RN5cfMIScOtIwqMrTnHyzRQYeYlZX6pvW7TP8uf8ckZBwOSWxVzMWINgJq2lpwEd96bza82jm9qcRlOW4cSW2BTeLf5QNvjt/C15B1stYuATt9CJBzVshfPkvNgldwrFTjFV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960024; c=relaxed/simple;
	bh=7lclaEovQlYU3cUczFlKv1XFrgFY2BcD8WzEiGUtJHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUMBXeflvl76tNJD1dJ/oxqnlOFw7U0Jj120vAdjkzRN+r1xqOazLrBm1jHAgOHiZN5JsaeCfTNgl0Jak6jp8bSHMuYgVI7E+VeYIy3y1k77Y7BNoZWWOHSidxwN6VRioqa/BJwOlX+oGg9zC2Ot1lWQA3NQdtBMRPLF1+QMf84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EZZSf9FM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EZZSf9FM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566C8C4CEF1;
	Fri,  9 Jan 2026 12:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960024;
	bh=7lclaEovQlYU3cUczFlKv1XFrgFY2BcD8WzEiGUtJHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EZZSf9FMRSqhNQZv+KwaNaH+g81hWgusYRUmADD+YxjJr4cogAhq0MgiiiKbLXzzM
	 5s36GAfkyG9Y5MctH6wJMhFzagWza37BFIp+OG+0ql+ZImbiSjLZzMM2Xt5xQluxzB
	 dy/LeSuwGAQmg7RPa/DbKbmX/4MjdJOZVbDi5pSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aiden Lambert <alambert48@gatech.edu>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 259/737] NFS: Avoid changing nlink when file removes and attribute updates race
Date: Fri,  9 Jan 2026 12:36:38 +0100
Message-ID: <20260109112143.734550757@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit bd4928ec799b31c492eb63f9f4a0c1e0bb4bb3f7 ]

If a file removal races with another operation that updates its
attributes, then skip the change to nlink, and just mark the attributes
as being stale.

Reported-by: Aiden Lambert <alambert48@gatech.edu>
Fixes: 59a707b0d42e ("NFS: Ensure we revalidate the inode correctly after remove or rename")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 385baf871800c..70f55df9e4f95 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1901,13 +1901,15 @@ static int nfs_dentry_delete(const struct dentry *dentry)
 }
 
 /* Ensure that we revalidate inode->i_nlink */
-static void nfs_drop_nlink(struct inode *inode)
+static void nfs_drop_nlink(struct inode *inode, unsigned long gencount)
 {
+	struct nfs_inode *nfsi = NFS_I(inode);
+
 	spin_lock(&inode->i_lock);
 	/* drop the inode if we're reasonably sure this is the last link */
-	if (inode->i_nlink > 0)
+	if (inode->i_nlink > 0 && gencount == nfsi->attr_gencount)
 		drop_nlink(inode);
-	NFS_I(inode)->attr_gencount = nfs_inc_attr_generation_counter();
+	nfsi->attr_gencount = nfs_inc_attr_generation_counter();
 	nfs_set_cache_invalid(
 		inode, NFS_INO_INVALID_CHANGE | NFS_INO_INVALID_CTIME |
 			       NFS_INO_INVALID_NLINK);
@@ -1921,8 +1923,9 @@ static void nfs_drop_nlink(struct inode *inode)
 static void nfs_dentry_iput(struct dentry *dentry, struct inode *inode)
 {
 	if (dentry->d_flags & DCACHE_NFSFS_RENAMED) {
+		unsigned long gencount = READ_ONCE(NFS_I(inode)->attr_gencount);
 		nfs_complete_unlink(dentry, inode);
-		nfs_drop_nlink(inode);
+		nfs_drop_nlink(inode, gencount);
 	}
 	iput(inode);
 }
@@ -2475,9 +2478,11 @@ static int nfs_safe_remove(struct dentry *dentry)
 
 	trace_nfs_remove_enter(dir, dentry);
 	if (inode != NULL) {
+		unsigned long gencount = READ_ONCE(NFS_I(inode)->attr_gencount);
+
 		error = NFS_PROTO(dir)->remove(dir, dentry);
 		if (error == 0)
-			nfs_drop_nlink(inode);
+			nfs_drop_nlink(inode, gencount);
 	} else
 		error = NFS_PROTO(dir)->remove(dir, dentry);
 	if (error == -ENOENT)
@@ -2682,6 +2687,7 @@ int nfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 {
 	struct inode *old_inode = d_inode(old_dentry);
 	struct inode *new_inode = d_inode(new_dentry);
+	unsigned long new_gencount = 0;
 	struct dentry *dentry = NULL;
 	struct rpc_task *task;
 	bool must_unblock = false;
@@ -2734,6 +2740,7 @@ int nfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 		} else {
 			block_revalidate(new_dentry);
 			must_unblock = true;
+			new_gencount = NFS_I(new_inode)->attr_gencount;
 			spin_unlock(&new_dentry->d_lock);
 		}
 
@@ -2773,7 +2780,7 @@ int nfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 			new_dir, new_dentry, error);
 	if (!error) {
 		if (new_inode != NULL)
-			nfs_drop_nlink(new_inode);
+			nfs_drop_nlink(new_inode, new_gencount);
 		/*
 		 * The d_move() should be here instead of in an async RPC completion
 		 * handler because we need the proper locks to move the dentry.  If
-- 
2.51.0



