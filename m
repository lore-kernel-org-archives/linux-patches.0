Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE322D73AB;
	Thu, 15 Jan 2026 17:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499141; cv=none; b=YczYuS0TBl+7FY1jbI6WD/qJjC05qT0urCmUxVjTjijDgv/vTRGpb6RzbFtjkSGjBv7CJsGJkhmhG5qalSnBMIh8FJZd7CvVJmgTmvPKJ2U9q/W+SNZ9gSRVFCK15mpDESPDo/h7BRxdPUrHRi6zuUGdTUD3bLXrpIFHVQWBLXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499141; c=relaxed/simple;
	bh=WT0Bravw6lEAnBC4QgEJ9AaqshdV7Ql7KKCkE7VoPYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=raKMyRy2hkM7CV9/LLVIPEpDhGxVIOr4K//RdLIEqSfH2kBZP8lpW5uMUvZ+dWhml97yhnRzgWYbx1khbREodazJo4zU6ax8hvt3Boa/QpfRXYh0ZkgARm0m079jELCHii9tDwaW4DQW4D8crDnJn1hILbngWAMYl5XB87SjHAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rr8Bz0Nh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rr8Bz0Nh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE76DC116D0;
	Thu, 15 Jan 2026 17:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499141;
	bh=WT0Bravw6lEAnBC4QgEJ9AaqshdV7Ql7KKCkE7VoPYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rr8Bz0NhC1bCNpbnYwKj78k6lJwpZhWMt+rnGivB5QEO2r2msKtiHqGKBpvB/3IMm
	 ae3wZAOAN0nwBPH/SjPH6ju/j8Kw+ny3k78+c1meyGBHYWfp/e9TAwYfJRAqd3RC06
	 AfvBJoRRjImVUvVuelPql6/XSj32DyUH7gqZicO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/451] NFS: Fix open coded versions of nfs_set_cache_invalid()
Date: Thu, 15 Jan 2026 17:45:22 +0100
Message-ID: <20260115164235.301506503@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit ac46b3d768e4c2754f7b191b81e1bea582e11907 ]

nfs_set_cache_invalid() has code to handle delegations, and other
optimisations, so let's use it when appropriate.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Stable-dep-of: bd4928ec799b ("NFS: Avoid changing nlink when file removes and attribute updates race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c    | 20 ++++++++++----------
 fs/nfs/inode.c  |  4 ++--
 fs/nfs/unlink.c |  6 +++---
 fs/nfs/write.c  |  8 ++++----
 4 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index e38ebe8bfb169..62a614f4a64b5 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -82,8 +82,9 @@ static struct nfs_open_dir_context *alloc_nfs_open_dir_context(struct inode *dir
 		spin_lock(&dir->i_lock);
 		if (list_empty(&nfsi->open_files) &&
 		    (nfsi->cache_validity & NFS_INO_DATA_INVAL_DEFER))
-			nfsi->cache_validity |= NFS_INO_INVALID_DATA |
-				NFS_INO_REVAL_FORCED;
+			nfs_set_cache_invalid(dir,
+					      NFS_INO_INVALID_DATA |
+						      NFS_INO_REVAL_FORCED);
 		list_add(&ctx->list, &nfsi->open_files);
 		spin_unlock(&dir->i_lock);
 		return ctx;
@@ -1500,10 +1501,9 @@ static void nfs_drop_nlink(struct inode *inode)
 	if (inode->i_nlink > 0)
 		drop_nlink(inode);
 	NFS_I(inode)->attr_gencount = nfs_inc_attr_generation_counter();
-	NFS_I(inode)->cache_validity |= NFS_INO_INVALID_CHANGE
-		| NFS_INO_INVALID_CTIME
-		| NFS_INO_INVALID_OTHER
-		| NFS_INO_REVAL_FORCED;
+	nfs_set_cache_invalid(
+		inode, NFS_INO_INVALID_CHANGE | NFS_INO_INVALID_CTIME |
+			       NFS_INO_INVALID_OTHER | NFS_INO_REVAL_FORCED);
 	spin_unlock(&inode->i_lock);
 }
 
@@ -1515,7 +1515,7 @@ static void nfs_dentry_iput(struct dentry *dentry, struct inode *inode)
 {
 	if (S_ISDIR(inode->i_mode))
 		/* drop any readdir cache as it could easily be old */
-		NFS_I(inode)->cache_validity |= NFS_INO_INVALID_DATA;
+		nfs_set_cache_invalid(inode, NFS_INO_INVALID_DATA);
 
 	if (dentry->d_flags & DCACHE_NFSFS_RENAMED) {
 		nfs_complete_unlink(dentry, inode);
@@ -2290,9 +2290,9 @@ int nfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (error == 0) {
 		spin_lock(&old_inode->i_lock);
 		NFS_I(old_inode)->attr_gencount = nfs_inc_attr_generation_counter();
-		NFS_I(old_inode)->cache_validity |= NFS_INO_INVALID_CHANGE
-			| NFS_INO_INVALID_CTIME
-			| NFS_INO_REVAL_FORCED;
+		nfs_set_cache_invalid(old_inode, NFS_INO_INVALID_CHANGE |
+							 NFS_INO_INVALID_CTIME |
+							 NFS_INO_REVAL_FORCED);
 		spin_unlock(&old_inode->i_lock);
 	}
 out:
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index e04739bf59261..6b800df1df29e 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1065,8 +1065,8 @@ void nfs_inode_attach_open_context(struct nfs_open_context *ctx)
 	spin_lock(&inode->i_lock);
 	if (list_empty(&nfsi->open_files) &&
 	    (nfsi->cache_validity & NFS_INO_DATA_INVAL_DEFER))
-		nfsi->cache_validity |= NFS_INO_INVALID_DATA |
-			NFS_INO_REVAL_FORCED;
+		nfs_set_cache_invalid(inode, NFS_INO_INVALID_DATA |
+						     NFS_INO_REVAL_FORCED);
 	list_add_tail_rcu(&ctx->list, &nfsi->open_files);
 	spin_unlock(&inode->i_lock);
 }
diff --git a/fs/nfs/unlink.c b/fs/nfs/unlink.c
index b27ebdccef703..5fa11e1aca4c2 100644
--- a/fs/nfs/unlink.c
+++ b/fs/nfs/unlink.c
@@ -500,9 +500,9 @@ nfs_sillyrename(struct inode *dir, struct dentry *dentry)
 		nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
 		spin_lock(&inode->i_lock);
 		NFS_I(inode)->attr_gencount = nfs_inc_attr_generation_counter();
-		NFS_I(inode)->cache_validity |= NFS_INO_INVALID_CHANGE
-			| NFS_INO_INVALID_CTIME
-			| NFS_INO_REVAL_FORCED;
+		nfs_set_cache_invalid(inode, NFS_INO_INVALID_CHANGE |
+						     NFS_INO_INVALID_CTIME |
+						     NFS_INO_REVAL_FORCED);
 		spin_unlock(&inode->i_lock);
 		d_move(dentry, sdentry);
 		break;
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 0b05a40a21f3d..a95a747fbc8df 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -260,9 +260,9 @@ static void nfs_set_pageerror(struct address_space *mapping)
 	nfs_zap_mapping(mapping->host, mapping);
 	/* Force file size revalidation */
 	spin_lock(&inode->i_lock);
-	NFS_I(inode)->cache_validity |= NFS_INO_REVAL_FORCED |
-					NFS_INO_REVAL_PAGECACHE |
-					NFS_INO_INVALID_SIZE;
+	nfs_set_cache_invalid(inode, NFS_INO_REVAL_FORCED |
+					     NFS_INO_REVAL_PAGECACHE |
+					     NFS_INO_INVALID_SIZE);
 	spin_unlock(&inode->i_lock);
 }
 
@@ -1614,7 +1614,7 @@ static int nfs_writeback_done(struct rpc_task *task,
 	/* Deal with the suid/sgid bit corner case */
 	if (nfs_should_remove_suid(inode)) {
 		spin_lock(&inode->i_lock);
-		NFS_I(inode)->cache_validity |= NFS_INO_INVALID_OTHER;
+		nfs_set_cache_invalid(inode, NFS_INO_INVALID_OTHER);
 		spin_unlock(&inode->i_lock);
 	}
 	return 0;
-- 
2.51.0



