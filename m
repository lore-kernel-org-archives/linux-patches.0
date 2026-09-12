Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5926538655A;
	Sat, 12 Sep 2026 13:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218621; cv=none; b=cgpOOoT/dzfrf7WhAQB2hEZgFicMGIz6COsHbxH+vSgke0QiwhKoWTYa1eJUTjH5A5gP4eZIvYWcF5r0TY+v05NYacQUwdiIhMbDpcbnNtEck6tKG/CqU1FfD7X3DQZfrglPGPCteIoXLhfcqg0fy+Fa/+Y8rGv8sT4dcq7vMPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218621; c=relaxed/simple;
	bh=JovuicygCR/BajUelAh3EcddBkUyDOUmQw9wGaB00KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=koW3uQAmvJZGB8emLlBS6Tq5d4kKbScMFeIGXgYjqnn4kfHACPeQUpivKXdvSs/ScmeE6wLThKm8gRIklfOWMr5NpTeOH1YxGWobNAihCgIPXOWv1F79NMgst74M8skFoc+qQY9xR3l4EQOOTXjg+JyKvyoKqefK/ch8KZYXjgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7lmq/5o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7lmq/5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4559D1F000FF;
	Sat, 12 Sep 2026 13:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218620;
	bh=g5QByfWmZPezbGWxlpx7FToSYlPMNah5HyH8coyMQ+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e7lmq/5o9/jFTUbtQ905lpjavi+MEFESIcGdS/DbD1HOaAtEAgpKPZuu2s7xAM/a5
	 tg1E8Tan1dKZ3V9mG8FMbCtnsog0nXo5PdI8rfZrzJaWUanv1ZxAXjiFglbG9dEBp3
	 3JeXrEZv7345UrcC6CqnABdQVuOsgFRCAk7tHulU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1182/1376] NFSv4: remove callback IDR entry on client allocation failure
Date: Sat, 12 Sep 2026 09:00:08 +0200
Message-ID: <20260912065633.895196674@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit d05c2007b3d84ccba11dc6e9cb3202768cc72f14 ]

nfs4_alloc_client() allocates an NFSv4.0 callback identifier before it
finishes setting up the client. If any later initialization step fails,
the error path frees the nfs_client directly with nfs_free_client(). That
bypasses nfs_put_client(), which is where the callback IDR entry is
removed during normal teardown.

A failed allocation can therefore leave cb_ident_idr pointing at a freed
nfs_client. A later NFSv4.0 callback lookup by cb_ident would find the
stale pointer and take a reference to it.

Make the callback IDR removal helper callable by the allocation failure
path, and remove the callback identifier before freeing the client.

This was found by a local static-analysis checker for publish-before-free
lifetime bugs and confirmed by manual inspection.

Fixes: f4eecd5da342 ("NFS implement v4.0 callback_ident")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/client.c     | 14 +++++++++++++-
 fs/nfs/internal.h   |  1 +
 fs/nfs/nfs4client.c |  1 +
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 8bdde6cc873f1..4b9b82ddf521e 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -211,9 +211,21 @@ static void nfs_cb_idr_remove_locked(struct nfs_client *clp)
 {
 	struct nfs_net *nn = net_generic(clp->cl_net, nfs_net_id);
 
-	if (clp->cl_cb_ident)
+	if (clp->cl_cb_ident) {
 		idr_remove(&nn->cb_ident_idr, clp->cl_cb_ident);
+		clp->cl_cb_ident = 0;
+	}
+}
+
+void nfs_cb_idr_remove(struct nfs_client *clp)
+{
+	struct nfs_net *nn = net_generic(clp->cl_net, nfs_net_id);
+
+	spin_lock(&nn->nfs_client_lock);
+	nfs_cb_idr_remove_locked(clp);
+	spin_unlock(&nn->nfs_client_lock);
 }
+EXPORT_SYMBOL_GPL(nfs_cb_idr_remove);
 
 static void pnfs_init_server(struct nfs_server *server)
 {
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 4dccacf517507..7808b06f23323 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -226,6 +226,7 @@ void nfs_server_copy_userdata(struct nfs_server *, struct nfs_server *);
 
 extern void nfs_put_client(struct nfs_client *);
 extern void nfs_free_client(struct nfs_client *);
+void nfs_cb_idr_remove(struct nfs_client *clp);
 extern struct nfs_client *nfs4_find_client_ident(struct net *, int);
 extern struct nfs_client *
 nfs4_find_client_sessionid(struct net *, const struct sockaddr *,
diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index 3f31d05e87ae1..9311944a47f58 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -270,6 +270,7 @@ struct nfs_client *nfs4_alloc_client(const struct nfs_client_initdata *cl_init)
 	return clp;
 
 error:
+	nfs_cb_idr_remove(clp);
 	nfs_free_client(clp);
 	return ERR_PTR(err);
 }
-- 
2.53.0



