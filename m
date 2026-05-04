Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5337A1A6827;
	Mon,  4 May 2026 14:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904324; cv=none; b=bcd+GjiXR88ev7Sm+1XPF6amlFgb/KYSprOxNja8n2OAk7p9Fhf80kDvxOwK1SVLmZjpUehxjg69h5IE7+2DCeadfI5WXZH9569tq7OQZNlw5shpvKmXVOoyZON/foV3cvARtJiYh+mmxUQfpUCTToMVFiiiyAWNRXpgM130a0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904324; c=relaxed/simple;
	bh=FkaVUg/5RkOADjYOXddRiRWh26q/fji9q2oRE4gwnlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjZUvTggfldtp37lL6DvvPPxniut6RrCvPnD2r1Ho+6prmMuGObTgdK9mrw1iYknlUZanKiEh0k6fhVvqmME/Te75U8lQkJWTVvrg4+Gi/suZVQb7loHb2PjDT55GSKwRvLS4KG4aadisCD4+1J8Wf3/gbuLtZCS+/emlUQzuQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RUDbvWOo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RUDbvWOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8CFC2BCB8;
	Mon,  4 May 2026 14:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904324;
	bh=FkaVUg/5RkOADjYOXddRiRWh26q/fji9q2oRE4gwnlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RUDbvWOoIxVqdWEPFikBML/FygZnsM1r9ko8hjAq+Ejmon9nAC158KzE8ExNASY2+
	 NHyD7lBogJ6040jDK5M4QkUIct0slznhOoHh08MEClG5ha6kz5bn5bsvqMrVkW+XH3
	 E5cmTbyALzudA4hHIMKDDPgsxQWYIzaDZ1dXs1Po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tushar Sariya <tushar.97@hotmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 6.18 238/275] NFSv4.1: Apply session size limits on clone path
Date: Mon,  4 May 2026 15:52:58 +0200
Message-ID: <20260504135151.888526932@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Tushar Sariya <tushar.97@hotmail.com>

commit 8c787b286f39c7584440b97b92f87cbe934c13ff upstream.

nfs4_clone_server() builds a child nfs_server for same-server
automounted submounts but never calls nfs4_session_limit_rwsize()
or nfs4_session_limit_xasize() after nfs_clone_server(). This means
the child mount can end up with rsize/wsize values that exceed the
negotiated session channel limits, causing NFS4ERR_REQ_TOO_BIG and
EIO on servers that enforce tight max_request_size budgets.

Top-level mounts go through nfs4_server_common_setup() which calls
these limiters after nfs_probe_server(). Apply the same clamping on
the clone path for consistency.

Fixes: 2b092175f5e3 ("NFS: Fix inheritance of the block sizes when automounting")
Cc: stable@vger.kernel.org
Signed-off-by: Tushar Sariya <tushar.97@hotmail.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/internal.h   |    2 ++
 fs/nfs/nfs4client.c |    4 ++--
 fs/nfs/nfs4proc.c   |    3 +++
 3 files changed, 7 insertions(+), 2 deletions(-)

--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -253,6 +253,8 @@ extern struct nfs_client *nfs4_set_ds_cl
 					     u32 minor_version);
 extern struct rpc_clnt *nfs4_find_or_create_ds_client(struct nfs_client *,
 						struct inode *);
+extern void nfs4_session_limit_rwsize(struct nfs_server *server);
+extern void nfs4_session_limit_xasize(struct nfs_server *server);
 extern struct nfs_client *nfs3_set_ds_client(struct nfs_server *mds_srv,
 			const struct sockaddr_storage *ds_addr, int ds_addrlen,
 			int ds_proto, unsigned int ds_timeo,
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -1033,7 +1033,7 @@ EXPORT_SYMBOL_GPL(nfs4_set_ds_client);
  * Limit the mount rsize, wsize and dtsize using negotiated fore
  * channel attributes.
  */
-static void nfs4_session_limit_rwsize(struct nfs_server *server)
+void nfs4_session_limit_rwsize(struct nfs_server *server)
 {
 #ifdef CONFIG_NFS_V4_1
 	struct nfs4_session *sess;
@@ -1058,7 +1058,7 @@ static void nfs4_session_limit_rwsize(st
 /*
  * Limit xattr sizes using the channel attributes.
  */
-static void nfs4_session_limit_xasize(struct nfs_server *server)
+void nfs4_session_limit_xasize(struct nfs_server *server)
 {
 #ifdef CONFIG_NFS_V4_2
 	struct nfs4_session *sess;
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -11000,6 +11000,9 @@ static struct nfs_server *nfs4_clone_ser
 	if (IS_ERR(server))
 		return server;
 
+	nfs4_session_limit_rwsize(server);
+	nfs4_session_limit_xasize(server);
+
 	error = nfs4_delegation_hash_alloc(server);
 	if (error) {
 		nfs_free_server(server);


