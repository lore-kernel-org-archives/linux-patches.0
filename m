Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB6A33ADB9;
	Tue, 16 Dec 2025 11:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884799; cv=none; b=ZtZ2dedL7r9mRxVpFUDK0wCFkKxy5S401O/j2q3fYECIHQddN7BQPKx3F6j9+aTUtXSRRWGbKN96//H2k200sTtvptmyqXhI0zfARi2Pt6TT7uhmcd3IOcNP1/ZxB/9oNpF02gJRcAuNZhgtezLh04zqaYKpYq+qgGuDmi4e0KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884799; c=relaxed/simple;
	bh=u071OTc6YZ1CJ3SjpvlRiTLbQjM1bO8FnypEaHOlchc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXxTABK6Eau3YDj43UOyHbhw/uaiVIBuhe1A2OmIm1Pe/KrzmTX6uWgj6qtAt/NxCq6ahPc00XbLiU+4BHxWDHBvZwrAeD3UMiSPPnNImUWe/DRsnUhIiWNCMeZex3VJYWQx5dJvxi/Jjq0nRV9/+39CfV0EI88DWCjGul9oLgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eyS6T067; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eyS6T067"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56BCC4CEF5;
	Tue, 16 Dec 2025 11:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884799;
	bh=u071OTc6YZ1CJ3SjpvlRiTLbQjM1bO8FnypEaHOlchc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eyS6T067tLVUo6EY99s3JqAZT7BwUCb4HO95NZglcnmHiYNF6YV6hkATCWku521wI
	 2NOmhQjAq9F9YUDrD9hO6RBBh9rjzNkobaR5lQM9059zEBPkZ57oKC3NDR318u5R/p
	 vWbPU0yOIZmL6Y4WTOq30PuzAjJb28WyFfO5otL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aiden Lambert <alambert48@gatech.edu>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 302/354] NFS: Avoid changing nlink when file removes and attribute updates race
Date: Tue, 16 Dec 2025 12:14:29 +0100
Message-ID: <20251216111331.853895919@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 048ce25ebfb70..01af2bb8a7216 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1903,13 +1903,15 @@ static int nfs_dentry_delete(const struct dentry *dentry)
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
@@ -1923,8 +1925,9 @@ static void nfs_drop_nlink(struct inode *inode)
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
@@ -2523,9 +2526,11 @@ static int nfs_safe_remove(struct dentry *dentry)
 
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
@@ -2725,6 +2730,7 @@ int nfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 {
 	struct inode *old_inode = d_inode(old_dentry);
 	struct inode *new_inode = d_inode(new_dentry);
+	unsigned long new_gencount = 0;
 	struct dentry *dentry = NULL;
 	struct rpc_task *task;
 	bool must_unblock = false;
@@ -2777,6 +2783,7 @@ int nfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 		} else {
 			block_revalidate(new_dentry);
 			must_unblock = true;
+			new_gencount = NFS_I(new_inode)->attr_gencount;
 			spin_unlock(&new_dentry->d_lock);
 		}
 
@@ -2816,7 +2823,7 @@ int nfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
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



