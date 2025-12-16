Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07646342529;
	Tue, 16 Dec 2025 12:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888496; cv=none; b=dg8ZbN1y8B/CYLy/+AliaCSHsHAWYgeHe4eLh8KEf+tElqXopbL29W5rJmhoirzLjNyh24Vpdz5STRB+jxAKT//pr6oI+ITrjwb12qUyn3W/UMXacq16GIJLQwbQFZQskQTKCg7WKAj54HciLwxXn2y5bMhN75R2PPbFXKYnydw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888496; c=relaxed/simple;
	bh=hgZe5myBtYq6Z+cmLD62mMHNTk+SqJym5p4G4b/lDhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGBWJCImdMCy/nrl7FwFpQ2xdgjvuLGECA+5B5UhA37P4bMsEfCUkcBdEH8Gv/LbaB8JkEv6hBp8HOXcdUXVl/dsyb2sZHmeYfcUxBymM6miBxA45IJ4XYkWq8TacRDHlRIJ4Wvo33oDsEjfCkutjwXvyN0uaHc3bPSHRRN/Xw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t7HKxEGN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t7HKxEGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69424C16AAE;
	Tue, 16 Dec 2025 12:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888495;
	bh=hgZe5myBtYq6Z+cmLD62mMHNTk+SqJym5p4G4b/lDhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t7HKxEGNdxhHGQMVEj+vJ4sT04MsPFGRSutW+tDqG8RiOecWVYhEOOWfA8c0hD3T4
	 HoEW0R6qsD8ORNJHsCdE3iCzO5A4XOWmqhho2EaBLPc1bKCwxlzEFBLlNI1BGw6GXr
	 7uwy4uMVMYGIhgLATh2Z/wGBLkTN7XUjXmDZx6xA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 551/614] NFS: Fix inheritance of the block sizes when automounting
Date: Tue, 16 Dec 2025 12:15:18 +0100
Message-ID: <20251216111421.343529727@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 54699299d5b16..2aaea9c98c2cd 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -784,10 +784,18 @@ static int nfs_init_server(struct nfs_server *server,
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
@@ -977,8 +985,13 @@ EXPORT_SYMBOL_GPL(nfs_probe_server);
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
index ffd382aa31ac0..2e596244799f3 100644
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
index dca055676c4f3..9e4d94f41fc67 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -190,6 +190,10 @@ struct vfsmount *nfs_d_automount(struct path *path)
 	ctx->nfs_mod		= client->cl_nfs_mod;
 	get_nfs_version(ctx->nfs_mod);
 
+	/* Inherit block sizes if they were specified as mount parameters */
+	if (server->automount_inherit & NFS_AUTOMOUNT_INHERIT_BSIZE)
+		ctx->bsize = server->bsize;
+
 	ret = client->rpc_ops->submount(fc, server);
 	if (ret < 0) {
 		mnt = ERR_PTR(ret);
@@ -289,7 +293,6 @@ int nfs_do_submount(struct fs_context *fc)
 		return -ENOMEM;
 
 	ctx->internal		= true;
-	ctx->clone_data.inherited_bsize = ctx->clone_data.sb->s_blocksize_bits;
 
 	p = nfs_devname(dentry, buffer, 4096);
 	if (IS_ERR(p)) {
diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index 3a4baed993c96..4ff0e9dd1145e 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -1174,10 +1174,20 @@ static int nfs4_init_server(struct nfs_server *server, struct fs_context *fc)
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
index 66413133b43e3..57d372db03b93 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1091,8 +1091,9 @@ static void nfs_fill_super(struct super_block *sb, struct nfs_fs_context *ctx)
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
@@ -1338,13 +1339,8 @@ int nfs_get_tree_common(struct fs_context *fc)
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
index d30c0245031c0..30ac384e011a4 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -172,6 +172,11 @@ struct nfs_server {
 #define NFS_MOUNT_FORCE_RDIRPLUS	0x20000000
 #define NFS_MOUNT_NETUNREACH_FATAL	0x40000000
 
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



