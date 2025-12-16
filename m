Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91578342CA1;
	Tue, 16 Dec 2025 11:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884981; cv=none; b=pgVK9LPscT9zqWbFXVYdwSSu26uzIe+wnQJrHVVmEb5jCvAS5D9yyCYepQ8Ihuwwe+y0MVKXCAdyVyD6oOqct+a4VnQefLFrLt0ehqIbVPDCBg01zVLURgbl0cfMucpw+eo2Fm5b/7Jb96kAhFSIYd+VY1GyNjKp7TR9qgaq4Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884981; c=relaxed/simple;
	bh=WaEIc7CX494pD8pGltNHjpoDO92xu44dvchbtsLV2Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZwdmnze6A58fIU+lGrBfs5Fpc+YBWIw620iCjnanUSbcpTNTdLYX2+TXhRYtEOMfgsw6c4yYu4jeqHMEFyn535ChEtc6ZhDxPU6CVW55R22TanZ0lqa4jYe1g/WRXnbYxxVxQ89PHUPZaTywEVptCxjX0zuDMg6EeSDphJui7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOmfDclW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOmfDclW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17412C4CEF1;
	Tue, 16 Dec 2025 11:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884981;
	bh=WaEIc7CX494pD8pGltNHjpoDO92xu44dvchbtsLV2Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sOmfDclWENFnEuEdjdMw0Qwdzw+qyzzjPtEHKqJ02n66jRZB5gJE7aKRbh3VNiv4M
	 meczapm+MsgT+7Lctq6c1dKSMUdhrVmOU4UMIbdb2V2i7MkCE38+Nz4qEIo9C5Unda
	 yYBIro4hAlp8To2Gm6oetqteTuSLs6Tbkq5vj54w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 314/354] NFS: Fix inheritance of the block sizes when automounting
Date: Tue, 16 Dec 2025 12:14:41 +0100
Message-ID: <20251216111332.287093878@linuxfoundation.org>
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

[ Upstream commit 2b092175f5e301cdaa935093edfef2be9defb6df ]

Only inherit the block sizes that were actually specified as mount
parameters for the parent mount.

Fixes: 62a55d088cd8 ("NFS: Additional refactoring for fs_context conversion")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/client.c           | 21 +++++++++++++++++----
 fs/nfs/internal.h         |  1 -
 fs/nfs/namespace.c        |  5 ++++-
 fs/nfs/nfs4client.c       | 18 ++++++++++++++----
 fs/nfs/super.c            | 10 +++-------
 include/linux/nfs_fs_sb.h |  5 +++++
 6 files changed, 43 insertions(+), 17 deletions(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 035474f3fb8f3..5fe20936e1455 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -767,10 +767,18 @@ static int nfs_init_server(struct nfs_server *server,
 		server->fattr_valid = NFS_ATTR_FATTR_V4;
 	}
 
-	if (ctx->rsize)
+	if (ctx->bsize) {
+		server->bsize = ctx->bsize;
+		server->automount_inherit |= NFS_AUTOMOUNT_INHERIT_BSIZE;
+	}
+	if (ctx->rsize) {
 		server->rsize = nfs_io_size(ctx->rsize, clp->cl_proto);
-	if (ctx->wsize)
+		server->automount_inherit |= NFS_AUTOMOUNT_INHERIT_RSIZE;
+	}
+	if (ctx->wsize) {
 		server->wsize = nfs_io_size(ctx->wsize, clp->cl_proto);
+		server->automount_inherit |= NFS_AUTOMOUNT_INHERIT_WSIZE;
+	}
 
 	server->acregmin = ctx->acregmin * HZ;
 	server->acregmax = ctx->acregmax * HZ;
@@ -962,8 +970,13 @@ EXPORT_SYMBOL_GPL(nfs_probe_server);
 void nfs_server_copy_userdata(struct nfs_server *target, struct nfs_server *source)
 {
 	target->flags = source->flags;
-	target->rsize = source->rsize;
-	target->wsize = source->wsize;
+	target->automount_inherit = source->automount_inherit;
+	if (source->automount_inherit & NFS_AUTOMOUNT_INHERIT_BSIZE)
+		target->bsize = source->bsize;
+	if (source->automount_inherit & NFS_AUTOMOUNT_INHERIT_RSIZE)
+		target->rsize = source->rsize;
+	if (source->automount_inherit & NFS_AUTOMOUNT_INHERIT_WSIZE)
+		target->wsize = source->wsize;
 	target->acregmin = source->acregmin;
 	target->acregmax = source->acregmax;
 	target->acdirmin = source->acdirmin;
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 63ee469d6c8f7..b0ab79894544f 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -152,7 +152,6 @@ struct nfs_fs_context {
 		struct super_block	*sb;
 		struct dentry		*dentry;
 		struct nfs_fattr	*fattr;
-		unsigned int		inherited_bsize;
 	} clone_data;
 };
 
diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index 40d7163bca870..923b5c1eb47e9 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -190,6 +190,10 @@ struct vfsmount *nfs_d_automount(struct path *path)
 	ctx->nfs_mod		= client->cl_nfs_mod;
 	__module_get(ctx->nfs_mod->owner);
 
+	/* Inherit block sizes if they were specified as mount parameters */
+	if (server->automount_inherit & NFS_AUTOMOUNT_INHERIT_BSIZE)
+		ctx->bsize = server->bsize;
+
 	ret = client->rpc_ops->submount(fc, server);
 	if (ret < 0) {
 		mnt = ERR_PTR(ret);
@@ -290,7 +294,6 @@ int nfs_do_submount(struct fs_context *fc)
 		return -ENOMEM;
 
 	ctx->internal		= true;
-	ctx->clone_data.inherited_bsize = ctx->clone_data.sb->s_blocksize_bits;
 
 	p = nfs_devname(dentry, buffer, 4096);
 	if (IS_ERR(p)) {
diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index b14688da814d6..3f31d05e87ae1 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -1176,10 +1176,20 @@ static int nfs4_init_server(struct nfs_server *server, struct fs_context *fc)
 	if (error < 0)
 		return error;
 
-	if (ctx->rsize)
-		server->rsize = nfs_io_size(ctx->rsize, server->nfs_client->cl_proto);
-	if (ctx->wsize)
-		server->wsize = nfs_io_size(ctx->wsize, server->nfs_client->cl_proto);
+	if (ctx->bsize) {
+		server->bsize = ctx->bsize;
+		server->automount_inherit |= NFS_AUTOMOUNT_INHERIT_BSIZE;
+	}
+	if (ctx->rsize) {
+		server->rsize =
+			nfs_io_size(ctx->rsize, server->nfs_client->cl_proto);
+		server->automount_inherit |= NFS_AUTOMOUNT_INHERIT_RSIZE;
+	}
+	if (ctx->wsize) {
+		server->wsize =
+			nfs_io_size(ctx->wsize, server->nfs_client->cl_proto);
+		server->automount_inherit |= NFS_AUTOMOUNT_INHERIT_WSIZE;
+	}
 
 	server->acregmin = ctx->acregmin * HZ;
 	server->acregmax = ctx->acregmax * HZ;
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index fbd5ed4639862..079393dc10956 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1086,8 +1086,9 @@ static void nfs_fill_super(struct super_block *sb, struct nfs_fs_context *ctx)
 	sb->s_blocksize = 0;
 	sb->s_xattr = server->nfs_client->cl_nfs_mod->xattr;
 	sb->s_op = server->nfs_client->cl_nfs_mod->sops;
-	if (ctx->bsize)
-		sb->s_blocksize = nfs_block_size(ctx->bsize, &sb->s_blocksize_bits);
+	if (server->bsize)
+		sb->s_blocksize =
+			nfs_block_size(server->bsize, &sb->s_blocksize_bits);
 
 	switch (server->nfs_client->rpc_ops->version) {
 	case 2:
@@ -1333,13 +1334,8 @@ int nfs_get_tree_common(struct fs_context *fc)
 	}
 
 	if (!s->s_root) {
-		unsigned bsize = ctx->clone_data.inherited_bsize;
 		/* initial superblock/root creation */
 		nfs_fill_super(s, ctx);
-		if (bsize) {
-			s->s_blocksize_bits = bsize;
-			s->s_blocksize = 1U << bsize;
-		}
 		error = nfs_get_cache_cookie(s, ctx);
 		if (error < 0)
 			goto error_splat_super;
diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
index 97edf7b583d5e..9b06695c79665 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -169,6 +169,11 @@ struct nfs_server {
 #define NFS_MOUNT_SHUTDOWN			0x08000000
 #define NFS_MOUNT_NO_ALIGNWRITE		0x10000000
 
+	unsigned int		automount_inherit; /* Properties inherited by automount */
+#define NFS_AUTOMOUNT_INHERIT_BSIZE	0x0001
+#define NFS_AUTOMOUNT_INHERIT_RSIZE	0x0002
+#define NFS_AUTOMOUNT_INHERIT_WSIZE	0x0004
+
 	unsigned int		caps;		/* server capabilities */
 	__u64			fattr_valid;	/* Valid attributes */
 	unsigned int		rsize;		/* read size */
-- 
2.51.0



