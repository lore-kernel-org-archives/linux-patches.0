Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A6C22C339;
	Mon,  2 Jun 2025 14:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872960; cv=none; b=qh4qkInZkBVIqsZXx3c3SfeXJ/ZgWQstY3J1OYoFSn9+LgeKdYgcJNV+ysLhS6lmY8muRTO3BZN6B2V4pp4E32xX/RgvvS9qjhQG7xcS0euX/CqDKeTCt7MdIFOqq+oLnqBR7bnZ87znwDyXD+2K5l+l6u1gRL+7OCnx8D4MVf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872960; c=relaxed/simple;
	bh=no6cJIbSEL2tcRVZ6Qmd6IgxNQmJ2Xh5IlzzVgj95RM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQR27WAdEdrrARG5kXycWgzQZs8JKu+6VgJYGld4V/if6q4Rd3Nfl9XhIuv+P6f05okasJiD3/CSUMvgs/Qjj3SXtFAdqh8qwLVeAfjduJgCMj5dsTdBibX14EjUqewk18QSL7+EGcAYZDtxbEwZMaJm3NNEorWM5gCEOQEwG60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TrL84YVH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TrL84YVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4DABC4CEF0;
	Mon,  2 Jun 2025 14:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872960;
	bh=no6cJIbSEL2tcRVZ6Qmd6IgxNQmJ2Xh5IlzzVgj95RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TrL84YVHgq0m0YRMzohAu0rX0CNJC9y8STP88nS5+XCLkCgYMB8vtvk3qmlfQ9viZ
	 7mNmSMiLz1VFonBhS6mwbsyQ6vSXvQl0Y/1QiuvAwr5oBrdfp6S27kQnkon2wyqqGF
	 SyeQPKjTCl4mUF/ocntv+FJxfTTaV+5AJ4j/eLec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 50/55] NFS: Avoid flushing data while holding directory locks in nfs_rename()
Date: Mon,  2 Jun 2025 15:48:07 +0200
Message-ID: <20250602134240.247985573@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
References: <20250602134238.271281478@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit dcd21b609d4abc7303f8683bce4f35d78d7d6830 ]

The Linux client assumes that all filehandles are non-volatile for
renames within the same directory (otherwise sillyrename cannot work).
However, the existence of the Linux 'subtree_check' export option has
meant that nfs_rename() has always assumed it needs to flush writes
before attempting to rename.

Since NFSv4 does allow the client to query whether or not the server
exhibits this behaviour, and since knfsd does actually set the
appropriate flag when 'subtree_check' is enabled on an export, it
should be OK to optimise away the write flushing behaviour in the cases
where it is clearly not needed.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/client.c           |  2 ++
 fs/nfs/dir.c              | 15 ++++++++++++++-
 include/linux/nfs_fs_sb.h | 12 +++++++++---
 3 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 03ecc77656151..4503758e9594b 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -1096,6 +1096,8 @@ struct nfs_server *nfs_create_server(struct fs_context *fc)
 		if (server->namelen == 0 || server->namelen > NFS2_MAXNAMLEN)
 			server->namelen = NFS2_MAXNAMLEN;
 	}
+	/* Linux 'subtree_check' borkenness mandates this setting */
+	server->fh_expire_type = NFS_FH_VOL_RENAME;
 
 	if (!(fattr->valid & NFS_ATTR_FATTR)) {
 		error = ctx->nfs_mod->rpc_ops->getattr(server, ctx->mntfh,
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 492cffd9d3d84..f9f4a92f63e92 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2690,6 +2690,18 @@ nfs_unblock_rename(struct rpc_task *task, struct nfs_renamedata *data)
 	unblock_revalidate(new_dentry);
 }
 
+static bool nfs_rename_is_unsafe_cross_dir(struct dentry *old_dentry,
+					   struct dentry *new_dentry)
+{
+	struct nfs_server *server = NFS_SB(old_dentry->d_sb);
+
+	if (old_dentry->d_parent != new_dentry->d_parent)
+		return false;
+	if (server->fh_expire_type & NFS_FH_RENAME_UNSAFE)
+		return !(server->fh_expire_type & NFS_FH_NOEXPIRE_WITH_OPEN);
+	return true;
+}
+
 /*
  * RENAME
  * FIXME: Some nfsds, like the Linux user space nfsd, may generate a
@@ -2777,7 +2789,8 @@ int nfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 
 	}
 
-	if (S_ISREG(old_inode->i_mode))
+	if (S_ISREG(old_inode->i_mode) &&
+	    nfs_rename_is_unsafe_cross_dir(old_dentry, new_dentry))
 		nfs_sync_inode(old_inode);
 	task = nfs_async_rename(old_dir, new_dir, old_dentry, new_dentry,
 				must_unblock ? nfs_unblock_rename : NULL);
diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
index 81ab18658d72d..2cff5cafbaa78 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -211,6 +211,15 @@ struct nfs_server {
 	char			*fscache_uniq;	/* Uniquifier (or NULL) */
 #endif
 
+	/* The following #defines numerically match the NFSv4 equivalents */
+#define NFS_FH_NOEXPIRE_WITH_OPEN (0x1)
+#define NFS_FH_VOLATILE_ANY (0x2)
+#define NFS_FH_VOL_MIGRATION (0x4)
+#define NFS_FH_VOL_RENAME (0x8)
+#define NFS_FH_RENAME_UNSAFE (NFS_FH_VOLATILE_ANY | NFS_FH_VOL_RENAME)
+	u32			fh_expire_type;	/* V4 bitmask representing file
+						   handle volatility type for
+						   this filesystem */
 	u32			pnfs_blksize;	/* layout_blksize attr */
 #if IS_ENABLED(CONFIG_NFS_V4)
 	u32			attr_bitmask[3];/* V4 bitmask representing the set
@@ -234,9 +243,6 @@ struct nfs_server {
 	u32			acl_bitmask;	/* V4 bitmask representing the ACEs
 						   that are supported on this
 						   filesystem */
-	u32			fh_expire_type;	/* V4 bitmask representing file
-						   handle volatility type for
-						   this filesystem */
 	struct pnfs_layoutdriver_type  *pnfs_curr_ld; /* Active layout driver */
 	struct rpc_wait_queue	roc_rpcwaitq;
 	void			*pnfs_ld_data;	/* per mount point data */
-- 
2.39.5



