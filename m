Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119952D9494;
	Thu, 15 Jan 2026 17:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497790; cv=none; b=WPCGMMt/qqg9DVfsL1xJGdQuy0GjjhVXVFZnhD1Ec/SOx7jNmlJfqD2iYc7koSTUUtnZT2PKYODDO2P0XpoIR33l+PTjAxSuG9KAZebiJPJ84VLlCRl7tlv7sdyli7LwWhB5DxmP0nJHw8dRtcb+yvzy5EXdZRhyrALi4E96img=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497790; c=relaxed/simple;
	bh=+7/B4VWzhzzD1LXPcbUp8lwlaTysYpH6PmcijvkOz2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlLcAFUg0lV8SPg94h53h+ZyiqCD8AdJU45Vkx2mudVtG+SAQ9uwH+FoXHBS1Q0qHs3PXeltLXT2DIe22Fv5AQdYQLVK+WaOnz1Yru8fRhR0wySDElwCJe7ILBsU7JeoiBCuFqsJdyJ5cNPLyXhZA4kOIrrvIf5skl/e/5PtXWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJMchSOY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJMchSOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F4EC116D0;
	Thu, 15 Jan 2026 17:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497790;
	bh=+7/B4VWzhzzD1LXPcbUp8lwlaTysYpH6PmcijvkOz2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJMchSOYbma5ap00JPZVXDJ2Vb8e9ITedctyYR+QCSunpscnVqXKtkhl6p56rHS50
	 xOA3MKr4osrfyTe7jp5qfOoQIjpPOJngfWGSrtmhd//OBvK5/3t6zuJJYUI/aTCS7U
	 4UK4v1ogphC6wFDSCGcAqdw1UE8RgQmcWiBgz7jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aiden Lambert <alambert48@gatech.edu>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 171/554] NFS: Avoid changing nlink when file removes and attribute updates race
Date: Thu, 15 Jan 2026 17:43:57 +0100
Message-ID: <20260115164252.456055814@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 671b427b7b97a..2a325a79327bc 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1714,13 +1714,15 @@ static int nfs_dentry_delete(const struct dentry *dentry)
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
@@ -1738,8 +1740,9 @@ static void nfs_dentry_iput(struct dentry *dentry, struct inode *inode)
 		nfs_set_cache_invalid(inode, NFS_INO_INVALID_DATA);
 
 	if (dentry->d_flags & DCACHE_NFSFS_RENAMED) {
+		unsigned long gencount = READ_ONCE(NFS_I(inode)->attr_gencount);
 		nfs_complete_unlink(dentry, inode);
-		nfs_drop_nlink(inode);
+		nfs_drop_nlink(inode, gencount);
 	}
 	iput(inode);
 }
@@ -2281,9 +2284,11 @@ static int nfs_safe_remove(struct dentry *dentry)
 
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
@@ -2475,6 +2480,7 @@ int nfs_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 {
 	struct inode *old_inode = d_inode(old_dentry);
 	struct inode *new_inode = d_inode(new_dentry);
+	unsigned long new_gencount = 0;
 	struct dentry *dentry = NULL;
 	struct rpc_task *task;
 	bool must_unblock = false;
@@ -2532,6 +2538,7 @@ int nfs_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 		} else {
 			new_dentry->d_fsdata = NFS_FSDATA_BLOCKED;
 			must_unblock = true;
+			new_gencount = NFS_I(new_inode)->attr_gencount;
 			spin_unlock(&new_dentry->d_lock);
 		}
 
@@ -2568,7 +2575,7 @@ int nfs_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
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



