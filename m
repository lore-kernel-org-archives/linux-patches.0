Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF241E48A;
	Mon, 18 Aug 2025 13:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524799; cv=none; b=naTVDXjFaGqbUl41OGpaEy0SMQJZqIkIWpOVV/nr5E1+mkPOHQn9MmNch2r32YY2KzMi/eo6AC29a4q+f+J5ZSAJAiZ9Bj9zZuwcSkZUynOutRRfzGtdoNfEE+yBEaosDiAPsVNop1tkRkSWPaxAXyYuPv/o9mOeWqaOkp+ik4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524799; c=relaxed/simple;
	bh=FADtj2+phmyAPu1oY4oo8OSlNRDISpzmNPAwGJ+j7PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwHP++4f7+UxsTAokTAqAYvzO8KD7RRxZgVWsFRJBeF4j7wzXWOULXsing1SNxlNDH5SU7fjQo6/htYZ8KeRsAUfNG7UBNYxb0V0OSG5vwX677PU+0EqbpZEZ0YVSMj/BPEQMfDPLtUJ1V/Saf0JPDDWHtCUai6f2iJ9nwcANbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bqneO01Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bqneO01Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A030C4CEEB;
	Mon, 18 Aug 2025 13:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524799;
	bh=FADtj2+phmyAPu1oY4oo8OSlNRDISpzmNPAwGJ+j7PA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bqneO01Z1lA0x0bTxXRGq2zM8m2SZ3lqLnVAxO3qf5RYS90pSbiVGo7NNRQRl7b3P
	 Qks+HGjKYWJ2DJs3zsj+kK6PJuBqXjZQP/4i9TbE54wBX5eFFe+GJ+pLAkSn/Omaz1
	 A5CV6+9o32ToXaCAbZTtqkIxxcR4Y8/Rhz0Z8XKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 6.16 034/570] NFS: Fix the setting of capabilities when automounting a new filesystem
Date: Mon, 18 Aug 2025 14:40:21 +0200
Message-ID: <20250818124507.127852500@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit b01f21cacde9f2878492cf318fee61bf4ccad323 upstream.

Capabilities cannot be inherited when we cross into a new filesystem.
They need to be reset to the minimal defaults, and then probed for
again.

Fixes: 54ceac451598 ("NFS: Share NFS superblocks per-protocol per-server per-FSID")
Cc: stable@vger.kernel.org
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/client.c     |   44 ++++++++++++++++++++++++++++++++++++++++++--
 fs/nfs/internal.h   |    2 +-
 fs/nfs/nfs4client.c |   20 +-------------------
 fs/nfs/nfs4proc.c   |    2 +-
 4 files changed, 45 insertions(+), 23 deletions(-)

--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -682,6 +682,44 @@ struct nfs_client *nfs_init_client(struc
 }
 EXPORT_SYMBOL_GPL(nfs_init_client);
 
+static void nfs4_server_set_init_caps(struct nfs_server *server)
+{
+#if IS_ENABLED(CONFIG_NFS_V4)
+	/* Set the basic capabilities */
+	server->caps = server->nfs_client->cl_mvops->init_caps;
+	if (server->flags & NFS_MOUNT_NORDIRPLUS)
+		server->caps &= ~NFS_CAP_READDIRPLUS;
+	if (server->nfs_client->cl_proto == XPRT_TRANSPORT_RDMA)
+		server->caps &= ~NFS_CAP_READ_PLUS;
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
@@ -726,7 +764,6 @@ static int nfs_init_server(struct nfs_se
 	/* Initialise the client representation from the mount data */
 	server->flags = ctx->flags;
 	server->options = ctx->options;
-	server->caps |= NFS_CAP_HARDLINKS | NFS_CAP_SYMLINKS;
 
 	switch (clp->rpc_ops->version) {
 	case 2:
@@ -762,6 +799,8 @@ static int nfs_init_server(struct nfs_se
 	if (error < 0)
 		goto error;
 
+	nfs_server_set_init_caps(server);
+
 	/* Preserve the values of mount_server-related mount options */
 	if (ctx->mount_server.addrlen) {
 		memcpy(&server->mountd_address, &ctx->mount_server.address,
@@ -936,7 +975,6 @@ void nfs_server_copy_userdata(struct nfs
 	target->acregmax = source->acregmax;
 	target->acdirmin = source->acdirmin;
 	target->acdirmax = source->acdirmax;
-	target->caps = source->caps;
 	target->options = source->options;
 	target->auth_info = source->auth_info;
 	target->port = source->port;
@@ -1170,6 +1208,8 @@ struct nfs_server *nfs_clone_server(stru
 	if (error < 0)
 		goto out_free_server;
 
+	nfs_server_set_init_caps(server);
+
 	/* probe the filesystem info for this server filesystem */
 	error = nfs_probe_server(server, fh);
 	if (error < 0)
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -232,7 +232,7 @@ extern struct nfs_client *
 nfs4_find_client_sessionid(struct net *, const struct sockaddr *,
 				struct nfs4_sessionid *, u32);
 extern struct nfs_server *nfs_create_server(struct fs_context *);
-extern void nfs4_server_set_init_caps(struct nfs_server *);
+extern void nfs_server_set_init_caps(struct nfs_server *);
 extern struct nfs_server *nfs4_create_server(struct fs_context *);
 extern struct nfs_server *nfs4_create_referral_server(struct fs_context *);
 extern int nfs4_update_server(struct nfs_server *server, const char *hostname,
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -1088,24 +1088,6 @@ static void nfs4_session_limit_xasize(st
 #endif
 }
 
-void nfs4_server_set_init_caps(struct nfs_server *server)
-{
-	/* Set the basic capabilities */
-	server->caps |= server->nfs_client->cl_mvops->init_caps;
-	if (server->flags & NFS_MOUNT_NORDIRPLUS)
-			server->caps &= ~NFS_CAP_READDIRPLUS;
-	if (server->nfs_client->cl_proto == XPRT_TRANSPORT_RDMA)
-		server->caps &= ~NFS_CAP_READ_PLUS;
-
-	/*
-	 * Don't use NFS uid/gid mapping if we're using AUTH_SYS or lower
-	 * authentication.
-	 */
-	if (nfs4_disable_idmapping &&
-			server->client->cl_auth->au_flavor == RPC_AUTH_UNIX)
-		server->caps |= NFS_CAP_UIDGID_NOMAP;
-}
-
 static int nfs4_server_common_setup(struct nfs_server *server,
 		struct nfs_fh *mntfh, bool auth_probe)
 {
@@ -1120,7 +1102,7 @@ static int nfs4_server_common_setup(stru
 	if (error < 0)
 		goto out;
 
-	nfs4_server_set_init_caps(server);
+	nfs_server_set_init_caps(server);
 
 	/* Probe the root fh to retrieve its FSID and filehandle */
 	error = nfs4_get_rootfh(server, mntfh, auth_probe);
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4082,7 +4082,7 @@ int nfs4_server_capabilities(struct nfs_
 	};
 	int err;
 
-	nfs4_server_set_init_caps(server);
+	nfs_server_set_init_caps(server);
 	do {
 		err = nfs4_handle_exception(server,
 				_nfs4_server_capabilities(server, fhandle),


