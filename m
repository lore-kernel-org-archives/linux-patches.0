Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB1D23771C;
	Tue, 17 Jun 2025 16:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178640; cv=none; b=XU3GQLOvuswPZCssKrbe6BDZxn0kMGDmiIsCujPFZjcP5VW+b7AYgQKCcr87J2IeN14BdoUc5NC7lpFiRPpfXVUV27bCbr5iXUSm7E3lXUuot9RSvU45cEy+XaXFgzcMWnDyp3at+kTty7eCixt1BN9nqlQj170EGZcujZDB3b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178640; c=relaxed/simple;
	bh=BtxUYGRFZMS1zBEzssWH2upKQGa59DCDSz+qufQaGpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kyzX9SuQ4TFvaHA9JzWooflD6wI9DUHf3/KtW8eRGmXcAYk2srr4z+Zn1106izUtQ08EGkhr4FSDnHGK0IPwKqPuDDs8NzrQO9KrR1wYIyL02pT3FCWXV47f1KpKBsZayn30epuXP/26vgnOAFNEQrtENZZzZo2hNETVe6eosUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eG4R1xYt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eG4R1xYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8A5C4CEE3;
	Tue, 17 Jun 2025 16:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178640;
	bh=BtxUYGRFZMS1zBEzssWH2upKQGa59DCDSz+qufQaGpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eG4R1xYtE4wuSywbDQosasJ1cy20+g55u6XE1l9gDmbTnIkkYrQ/CdKHrtyAys85s
	 vIUfetFUyV/q0jZdTiIuxwvZ7gIx/jk76X/RDPXDq3cjH4UjwHpJnpYuq2zFbzqQIh
	 sZZbSmsDOlvZomH7PA+7ibECQPZWiywUFsRm3x0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	NeilBrown <neil@brown.name>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 479/780] nfs_localio: simplify interface to nfsd for getting nfsd_file
Date: Tue, 17 Jun 2025 17:23:07 +0200
Message-ID: <20250617152510.998181545@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neil@brown.name>

[ Upstream commit e6f7e1487ab528a6c653bd0d42812ff2942846cd ]

The nfsd_localio_operations structure contains nfsd_file_get() to get a
reference to an nfsd_file.  This is only used in one place, where
nfsd_open_local_fh() is also used.

This patch combines the two, calling nfsd_open_local_fh() passing a
pointer to where the nfsd_file pointer might be stored.  If there is a
pointer there an nfsd_file_get() can get a reference, that reference is
returned.  If not a new nfsd_file is acquired, stored at the pointer,
and returned.  When we store a reference we also increase the refcount
on the net, as that refcount is decrements when we clear the stored
pointer.

We now get an extra reference *before* storing the new nfsd_file at the
given location.  This avoids possible races with the nfsd_file being
freed before the final reference can be taken.

This patch moves the rcu_dereference() needed after fetching from
ro_file or rw_file into the nfsd code where the 'struct nfs_file' is
fully defined.  This avoids an error reported by older versions of gcc
such as gcc-8 which complain about rcu_dereference() use in contexts
where the structure (which will supposedly be accessed) is not fully
defined.

Reported-by: Pali Rohár <pali@kernel.org>
Reported-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Fixes: 86e00412254a ("nfs: cache all open LOCALIO nfsd_file(s) in client")
Signed-off-by: NeilBrown <neil@brown.name>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/localio.c           | 31 ++++--------------
 fs/nfs_common/nfslocalio.c |  3 +-
 fs/nfsd/localio.c          | 65 +++++++++++++++++++++++++++-----------
 3 files changed, 55 insertions(+), 44 deletions(-)

diff --git a/fs/nfs/localio.c b/fs/nfs/localio.c
index 8fb08c3ad563b..030a54c8c9d8b 100644
--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -207,11 +207,6 @@ void nfs_local_probe_async(struct nfs_client *clp)
 }
 EXPORT_SYMBOL_GPL(nfs_local_probe_async);
 
-static inline struct nfsd_file *nfs_local_file_get(struct nfsd_file *nf)
-{
-	return nfs_to->nfsd_file_get_local(nf);
-}
-
 static inline void nfs_local_file_put(struct nfsd_file *nf)
 {
 	nfs_to_nfsd_file_put_local(nf);
@@ -226,12 +221,13 @@ static inline void nfs_local_file_put(struct nfsd_file *nf)
 static struct nfsd_file *
 __nfs_local_open_fh(struct nfs_client *clp, const struct cred *cred,
 		    struct nfs_fh *fh, struct nfs_file_localio *nfl,
+		    struct nfsd_file __rcu **pnf,
 		    const fmode_t mode)
 {
 	struct nfsd_file *localio;
 
 	localio = nfs_open_local_fh(&clp->cl_uuid, clp->cl_rpcclient,
-				    cred, fh, nfl, mode);
+				    cred, fh, nfl, pnf, mode);
 	if (IS_ERR(localio)) {
 		int status = PTR_ERR(localio);
 		trace_nfs_local_open_fh(fh, mode, status);
@@ -258,7 +254,7 @@ nfs_local_open_fh(struct nfs_client *clp, const struct cred *cred,
 		  struct nfs_fh *fh, struct nfs_file_localio *nfl,
 		  const fmode_t mode)
 {
-	struct nfsd_file *nf, *new, __rcu **pnf;
+	struct nfsd_file *nf, __rcu **pnf;
 
 	if (!nfs_server_is_local(clp))
 		return NULL;
@@ -270,24 +266,9 @@ nfs_local_open_fh(struct nfs_client *clp, const struct cred *cred,
 	else
 		pnf = &nfl->ro_file;
 
-	new = NULL;
-	rcu_read_lock();
-	nf = rcu_dereference(*pnf);
-	if (!nf) {
-		rcu_read_unlock();
-		new = __nfs_local_open_fh(clp, cred, fh, nfl, mode);
-		if (IS_ERR(new))
-			return NULL;
-		rcu_read_lock();
-		/* try to swap in the pointer */
-		nf = unrcu_pointer(cmpxchg(pnf, NULL, RCU_INITIALIZER(new)));
-		if (!nf)
-			swap(nf, new);
-	}
-	nf = nfs_local_file_get(nf);
-	rcu_read_unlock();
-	if (new)
-		nfs_to_nfsd_file_put_local(new);
+	nf = __nfs_local_open_fh(clp, cred, fh, nfl, pnf, mode);
+	if (IS_ERR(nf))
+		return NULL;
 	return nf;
 }
 EXPORT_SYMBOL_GPL(nfs_local_open_fh);
diff --git a/fs/nfs_common/nfslocalio.c b/fs/nfs_common/nfslocalio.c
index f6821b2c87a2f..503f85f64b760 100644
--- a/fs/nfs_common/nfslocalio.c
+++ b/fs/nfs_common/nfslocalio.c
@@ -237,6 +237,7 @@ static void nfs_uuid_add_file(nfs_uuid_t *nfs_uuid, struct nfs_file_localio *nfl
 struct nfsd_file *nfs_open_local_fh(nfs_uuid_t *uuid,
 		   struct rpc_clnt *rpc_clnt, const struct cred *cred,
 		   const struct nfs_fh *nfs_fh, struct nfs_file_localio *nfl,
+		   struct nfsd_file __rcu **pnf,
 		   const fmode_t fmode)
 {
 	struct net *net;
@@ -261,7 +262,7 @@ struct nfsd_file *nfs_open_local_fh(nfs_uuid_t *uuid,
 	rcu_read_unlock();
 	/* We have an implied reference to net thanks to nfsd_net_try_get */
 	localio = nfs_to->nfsd_open_local_fh(net, uuid->dom, rpc_clnt,
-					     cred, nfs_fh, fmode);
+					     cred, nfs_fh, pnf, fmode);
 	nfs_to_nfsd_net_put(net);
 	if (!IS_ERR(localio))
 		nfs_uuid_add_file(uuid, nfl);
diff --git a/fs/nfsd/localio.c b/fs/nfsd/localio.c
index 2c0afd1067ea6..80d9ff6608a7b 100644
--- a/fs/nfsd/localio.c
+++ b/fs/nfsd/localio.c
@@ -24,20 +24,6 @@
 #include "filecache.h"
 #include "cache.h"
 
-static const struct nfsd_localio_operations nfsd_localio_ops = {
-	.nfsd_net_try_get  = nfsd_net_try_get,
-	.nfsd_net_put  = nfsd_net_put,
-	.nfsd_open_local_fh = nfsd_open_local_fh,
-	.nfsd_file_put_local = nfsd_file_put_local,
-	.nfsd_file_get_local = nfsd_file_get_local,
-	.nfsd_file_file = nfsd_file_file,
-};
-
-void nfsd_localio_ops_init(void)
-{
-	nfs_to = &nfsd_localio_ops;
-}
-
 /**
  * nfsd_open_local_fh - lookup a local filehandle @nfs_fh and map to nfsd_file
  *
@@ -46,6 +32,7 @@ void nfsd_localio_ops_init(void)
  * @rpc_clnt: rpc_clnt that the client established
  * @cred: cred that the client established
  * @nfs_fh: filehandle to lookup
+ * @nfp: place to find the nfsd_file, or store it if it was non-NULL
  * @fmode: fmode_t to use for open
  *
  * This function maps a local fh to a path on a local filesystem.
@@ -56,10 +43,11 @@ void nfsd_localio_ops_init(void)
  * set. Caller (NFS client) is responsible for calling nfsd_net_put and
  * nfsd_file_put (via nfs_to_nfsd_file_put_local).
  */
-struct nfsd_file *
+static struct nfsd_file *
 nfsd_open_local_fh(struct net *net, struct auth_domain *dom,
 		   struct rpc_clnt *rpc_clnt, const struct cred *cred,
-		   const struct nfs_fh *nfs_fh, const fmode_t fmode)
+		   const struct nfs_fh *nfs_fh, struct nfsd_file __rcu **pnf,
+		   const fmode_t fmode)
 {
 	int mayflags = NFSD_MAY_LOCALIO;
 	struct svc_cred rq_cred;
@@ -73,6 +61,12 @@ nfsd_open_local_fh(struct net *net, struct auth_domain *dom,
 	if (!nfsd_net_try_get(net))
 		return ERR_PTR(-ENXIO);
 
+	rcu_read_lock();
+	localio = nfsd_file_get(rcu_dereference(*pnf));
+	rcu_read_unlock();
+	if (localio)
+		return localio;
+
 	/* nfs_fh -> svc_fh */
 	fh_init(&fh, NFS4_FHSIZE);
 	fh.fh_handle.fh_size = nfs_fh->size;
@@ -94,12 +88,47 @@ nfsd_open_local_fh(struct net *net, struct auth_domain *dom,
 	if (rq_cred.cr_group_info)
 		put_group_info(rq_cred.cr_group_info);
 
-	if (IS_ERR(localio))
+	if (!IS_ERR(localio)) {
+		struct nfsd_file *new;
+		if (!nfsd_net_try_get(net)) {
+			nfsd_file_put(localio);
+			nfsd_net_put(net);
+			return ERR_PTR(-ENXIO);
+		}
+		nfsd_file_get(localio);
+	again:
+		new = unrcu_pointer(cmpxchg(pnf, NULL, RCU_INITIALIZER(localio)));
+		if (new) {
+			/* Some other thread installed an nfsd_file */
+			if (nfsd_file_get(new) == NULL)
+				goto again;
+			/*
+			 * Drop the ref we were going to install and the
+			 * one we were going to return.
+			 */
+			nfsd_file_put(localio);
+			nfsd_file_put(localio);
+			localio = new;
+		}
+	} else
 		nfsd_net_put(net);
 
 	return localio;
 }
-EXPORT_SYMBOL_GPL(nfsd_open_local_fh);
+
+static const struct nfsd_localio_operations nfsd_localio_ops = {
+	.nfsd_net_try_get  = nfsd_net_try_get,
+	.nfsd_net_put  = nfsd_net_put,
+	.nfsd_open_local_fh = nfsd_open_local_fh,
+	.nfsd_file_put_local = nfsd_file_put_local,
+	.nfsd_file_get_local = nfsd_file_get_local,
+	.nfsd_file_file = nfsd_file_file,
+};
+
+void nfsd_localio_ops_init(void)
+{
+	nfs_to = &nfsd_localio_ops;
+}
 
 /*
  * UUID_IS_LOCAL XDR functions
-- 
2.39.5



