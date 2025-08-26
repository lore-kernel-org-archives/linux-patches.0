Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF6A1E500C;
	Tue, 26 Aug 2025 14:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219453; cv=none; b=N/5rkjuGGntc0xxh68G8exR0Qy6y4OWo3LSv2EMtiq3mkLtx9MwvzGZrOtDoinNyDhz28Ew43CQy4TwnUpwKfNNA3LS/KC+d8+gRJqwo7bAFpo0lsVMcnriVGqBhmj7KPFNbheFCsVZsj5SIfjXzqiIhnqrkkAv0/ubs0ZQE3v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219453; c=relaxed/simple;
	bh=FNIqsqg+eUE2m4z9MxHW4GkZdrNOAv87nriPdPr4P2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wn3aFWpaeZ0bXmQdmllQsrKivMwIsYO4MMorIfKU7YZTYhHsQBNGUZDSBm3L4ovsegN0dNqSbkAntscTk33D6bZ9BG7M21Yjg1sa6F+uJLhy9D4aOXb2lfoqRwpq/hQj+ssPQGQKRyqua6RBo984WNoB/+YLD1BvhFiR9Vcv+/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g7lCfC+M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g7lCfC+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1202DC4CEF1;
	Tue, 26 Aug 2025 14:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219453;
	bh=FNIqsqg+eUE2m4z9MxHW4GkZdrNOAv87nriPdPr4P2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g7lCfC+M3TuMD00ZFLvwztYEKpnGiKz7zVy2aq6/s8TQseFDYiLokHHscWn8/rOAO
	 NwHYUXDz7kWfknGEYYNrYrhfdXbSrNOtk6aJwiJrNxXWg1q1GxR7RpISPXG2gFGgix
	 kjyN7IjQM4voyiAtNKsiT7QCeCncGXKR+Xy5uDHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 357/403] NFS: Fix the setting of capabilities when automounting a new filesystem
Date: Tue, 26 Aug 2025 13:11:23 +0200
Message-ID: <20250826110916.742674655@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit b01f21cacde9f2878492cf318fee61bf4ccad323 ]

Capabilities cannot be inherited when we cross into a new filesystem.
They need to be reset to the minimal defaults, and then probed for
again.

Fixes: 54ceac451598 ("NFS: Share NFS superblocks per-protocol per-server per-FSID")
Cc: stable@vger.kernel.org
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
[ adapted to older fs_context-less API structures ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/client.c     |   44 ++++++++++++++++++++++++++++++++++++++++----
 fs/nfs/internal.h   |    1 +
 fs/nfs/nfs4client.c |   13 +------------
 fs/nfs/nfs4proc.c   |    2 ++
 4 files changed, 44 insertions(+), 16 deletions(-)

--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -646,6 +646,42 @@ struct nfs_client *nfs_init_client(struc
 }
 EXPORT_SYMBOL_GPL(nfs_init_client);
 
+static void nfs4_server_set_init_caps(struct nfs_server *server)
+{
+#if IS_ENABLED(CONFIG_NFS_V4)
+	/* Set the basic capabilities */
+	server->caps = server->nfs_client->cl_mvops->init_caps;
+	if (server->flags & NFS_MOUNT_NORDIRPLUS)
+		server->caps &= ~NFS_CAP_READDIRPLUS;
+
+	/*
+	 * Don't use NFS uid/gid mapping if we're using AUTH_SYS or lower
+	 * authentication.
+	 */
+	if (nfs4_disable_idmapping &&
+	    server->client->cl_auth->au_flavor == RPC_AUTH_UNIX)
+		server->caps |= NFS_CAP_UIDGID_NOMAP;
+#endif
+}
+
+void nfs_server_set_init_caps(struct nfs_server *server)
+{
+	switch (server->nfs_client->rpc_ops->version) {
+	case 2:
+		server->caps = NFS_CAP_HARDLINKS | NFS_CAP_SYMLINKS;
+		break;
+	case 3:
+		server->caps = NFS_CAP_HARDLINKS | NFS_CAP_SYMLINKS;
+		if (!(server->flags & NFS_MOUNT_NORDIRPLUS))
+			server->caps |= NFS_CAP_READDIRPLUS;
+		break;
+	default:
+		nfs4_server_set_init_caps(server);
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(nfs_server_set_init_caps);
+
 /*
  * Create a version 2 or 3 client
  */
@@ -683,9 +719,6 @@ static int nfs_init_server(struct nfs_se
 	/* Initialise the client representation from the mount data */
 	server->flags = data->flags;
 	server->options = data->options;
-	server->caps |= NFS_CAP_HARDLINKS|NFS_CAP_SYMLINKS|NFS_CAP_FILEID|
-		NFS_CAP_MODE|NFS_CAP_NLINK|NFS_CAP_OWNER|NFS_CAP_OWNER_GROUP|
-		NFS_CAP_ATIME|NFS_CAP_CTIME|NFS_CAP_MTIME;
 
 	if (data->rsize)
 		server->rsize = nfs_block_size(data->rsize, NULL);
@@ -710,6 +743,8 @@ static int nfs_init_server(struct nfs_se
 	if (error < 0)
 		goto error;
 
+	nfs_server_set_init_caps(server);
+
 	/* Preserve the values of mount_server-related mount options */
 	if (data->mount_server.addrlen) {
 		memcpy(&server->mountd_address, &data->mount_server.address,
@@ -834,7 +869,6 @@ void nfs_server_copy_userdata(struct nfs
 	target->acregmax = source->acregmax;
 	target->acdirmin = source->acdirmin;
 	target->acdirmax = source->acdirmax;
-	target->caps = source->caps;
 	target->options = source->options;
 	target->auth_info = source->auth_info;
 	target->port = source->port;
@@ -1042,6 +1076,8 @@ struct nfs_server *nfs_clone_server(stru
 	if (error < 0)
 		goto out_free_server;
 
+	nfs_server_set_init_caps(server);
+
 	/* probe the filesystem info for this server filesystem */
 	error = nfs_probe_fsinfo(server, fh, fattr_fsinfo);
 	if (error < 0)
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -172,6 +172,7 @@ nfs4_find_client_sessionid(struct net *,
 				struct nfs4_sessionid *, u32);
 extern struct nfs_server *nfs_create_server(struct nfs_mount_info *,
 					struct nfs_subversion *);
+extern void nfs_server_set_init_caps(struct nfs_server *);
 extern struct nfs_server *nfs4_create_server(
 					struct nfs_mount_info *,
 					struct nfs_subversion *);
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -1011,18 +1011,7 @@ static int nfs4_server_common_setup(stru
 	if (error < 0)
 		goto out;
 
-	/* Set the basic capabilities */
-	server->caps |= server->nfs_client->cl_mvops->init_caps;
-	if (server->flags & NFS_MOUNT_NORDIRPLUS)
-			server->caps &= ~NFS_CAP_READDIRPLUS;
-	/*
-	 * Don't use NFS uid/gid mapping if we're using AUTH_SYS or lower
-	 * authentication.
-	 */
-	if (nfs4_disable_idmapping &&
-			server->client->cl_auth->au_flavor == RPC_AUTH_UNIX)
-		server->caps |= NFS_CAP_UIDGID_NOMAP;
-
+	nfs_server_set_init_caps(server);
 
 	/* Probe the root fh to retrieve its FSID and filehandle */
 	error = nfs4_get_rootfh(server, mntfh, auth_probe);
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3884,6 +3884,8 @@ int nfs4_server_capabilities(struct nfs_
 		.interruptible = true,
 	};
 	int err;
+
+	nfs_server_set_init_caps(server);
 	do {
 		err = nfs4_handle_exception(server,
 				_nfs4_server_capabilities(server, fhandle),


