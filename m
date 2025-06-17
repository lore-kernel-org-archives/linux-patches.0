Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBAB235071;
	Tue, 17 Jun 2025 16:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178630; cv=none; b=t5Y9oYsGFQB1lJJEUxl+JqxKgDNw/PzQ47LrGMM6Ot+jjpaI+88BwV4iu7HELM0K4PoAwhCfxMl3zxHusqWmZaMWeD008MhIaFAbJrlrMTr/DOt9iqcaISIlyfOePDewCbCvcjXxnpxgvAPs5x3QWjTm5wXwAjgBKYqx+p+enSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178630; c=relaxed/simple;
	bh=ZHaurgGNDU9AAgCwBh6f0ogMBvG8gTNWj1lUtmrfyw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giOPEE8i/0ZNzImzSTcMKVYiyWYNN5iFklX4dUuN12UpQsh9iQHntsIvKSzsH6emygLtx3dQo+VBUX718y+qNVotGIxiC9tGusN8I1T07EA68Ingwve0D+eAFi+bUL/79T3fdQriwwg2PqPdHi6b4j5LaceTSG4kGfKGecBEKUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKNSHwOJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKNSHwOJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85F2C4CEE3;
	Tue, 17 Jun 2025 16:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178630;
	bh=ZHaurgGNDU9AAgCwBh6f0ogMBvG8gTNWj1lUtmrfyw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wKNSHwOJO7b3SPgy6SygBqDb3+xDphLDpNlV1VanlZTWSTGgwkCDfR9WvavZTlNzx
	 BEiw4zzASk8Oc9L4RZIxDkAlcmLlrVkUsfBzxciJfi5z6JSf7/y1nGpnohyMHM2gNK
	 pOtwwBAi33tblAMzwCmuhn3OPj3Vg6541REToN2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 478/780] nfs_localio: always hold nfsd net ref with nfsd_file ref
Date: Tue, 17 Jun 2025 17:23:06 +0200
Message-ID: <20250617152510.952480233@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neil@brown.name>

[ Upstream commit 77e82fb2c6c27c122e785f543ae0062f7783c886 ]

Having separate nfsd_file_put and nfsd_file_put_local in struct
nfsd_localio_operations doesn't make much sense.  The difference is that
nfsd_file_put doesn't drop a reference to the nfs_net which is what
keeps nfsd from shutting down.

Currently, if nfsd tries to shutdown it will invalidate the files stored
in the list from the nfs_uuid and this will drop all references to the
nfsd net that the client holds.  But the client could still hold some
references to nfsd_files for active IO.  So nfsd might think is has
completely shut down local IO, but hasn't and has no way to wait for
those active IO requests to complete.

So this patch changes nfsd_file_get to nfsd_file_get_local and has it
increase the ref count on the nfsd net and it replaces all calls to
->nfsd_put_file to ->nfsd_put_file_local.

It also changes ->nfsd_open_local_fh to return with the refcount on the
net elevated precisely when a valid nfsd_file is returned.

This means that whenever the client holds a valid nfsd_file, there will
be an associated count on the nfsd net, and so the count can only reach
zero when all nfsd_files have been returned.

nfs_local_file_put() is changed to call nfs_to_nfsd_file_put_local()
instead of replacing calls to one with calls to the other because this
will help a later patch which changes nfs_to_nfsd_file_put_local() to
take an __rcu pointer while nfs_local_file_put() doesn't.

Fixes: 86e00412254a ("nfs: cache all open LOCALIO nfsd_file(s) in client")
Signed-off-by: NeilBrown <neil@brown.name>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/localio.c           |  4 ++--
 fs/nfs_common/nfslocalio.c |  5 ++---
 fs/nfsd/filecache.c        | 21 +++++++++++++++++++++
 fs/nfsd/filecache.h        |  1 +
 fs/nfsd/localio.c          |  9 +++++++--
 include/linux/nfslocalio.h |  3 +--
 6 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/fs/nfs/localio.c b/fs/nfs/localio.c
index 595903c215235..8fb08c3ad563b 100644
--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -209,12 +209,12 @@ EXPORT_SYMBOL_GPL(nfs_local_probe_async);
 
 static inline struct nfsd_file *nfs_local_file_get(struct nfsd_file *nf)
 {
-	return nfs_to->nfsd_file_get(nf);
+	return nfs_to->nfsd_file_get_local(nf);
 }
 
 static inline void nfs_local_file_put(struct nfsd_file *nf)
 {
-	nfs_to->nfsd_file_put(nf);
+	nfs_to_nfsd_file_put_local(nf);
 }
 
 /*
diff --git a/fs/nfs_common/nfslocalio.c b/fs/nfs_common/nfslocalio.c
index bdf251332b6b8..f6821b2c87a2f 100644
--- a/fs/nfs_common/nfslocalio.c
+++ b/fs/nfs_common/nfslocalio.c
@@ -262,9 +262,8 @@ struct nfsd_file *nfs_open_local_fh(nfs_uuid_t *uuid,
 	/* We have an implied reference to net thanks to nfsd_net_try_get */
 	localio = nfs_to->nfsd_open_local_fh(net, uuid->dom, rpc_clnt,
 					     cred, nfs_fh, fmode);
-	if (IS_ERR(localio))
-		nfs_to_nfsd_net_put(net);
-	else
+	nfs_to_nfsd_net_put(net);
+	if (!IS_ERR(localio))
 		nfs_uuid_add_file(uuid, nfl);
 
 	return localio;
diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index ab85e6a2454f4..eedf2af8ee6ec 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -386,6 +386,27 @@ nfsd_file_put_local(struct nfsd_file *nf)
 	return net;
 }
 
+/**
+ * nfsd_file_get_local - get nfsd_file reference and reference to net
+ * @nf: nfsd_file of which to put the reference
+ *
+ * Get reference to both the nfsd_file and nf->nf_net.
+ */
+struct nfsd_file *
+nfsd_file_get_local(struct nfsd_file *nf)
+{
+	struct net *net = nf->nf_net;
+
+	if (nfsd_net_try_get(net)) {
+		nf = nfsd_file_get(nf);
+		if (!nf)
+			nfsd_net_put(net);
+	} else {
+		nf = NULL;
+	}
+	return nf;
+}
+
 /**
  * nfsd_file_file - get the backing file of an nfsd_file
  * @nf: nfsd_file of which to access the backing file.
diff --git a/fs/nfsd/filecache.h b/fs/nfsd/filecache.h
index 5865f9c727121..cd02f91aaef13 100644
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -63,6 +63,7 @@ int nfsd_file_cache_start_net(struct net *net);
 void nfsd_file_cache_shutdown_net(struct net *net);
 void nfsd_file_put(struct nfsd_file *nf);
 struct net *nfsd_file_put_local(struct nfsd_file *nf);
+struct nfsd_file *nfsd_file_get_local(struct nfsd_file *nf);
 struct nfsd_file *nfsd_file_get(struct nfsd_file *nf);
 struct file *nfsd_file_file(struct nfsd_file *nf);
 void nfsd_file_close_inode_sync(struct inode *inode);
diff --git a/fs/nfsd/localio.c b/fs/nfsd/localio.c
index 238647fa379e3..2c0afd1067ea6 100644
--- a/fs/nfsd/localio.c
+++ b/fs/nfsd/localio.c
@@ -29,8 +29,7 @@ static const struct nfsd_localio_operations nfsd_localio_ops = {
 	.nfsd_net_put  = nfsd_net_put,
 	.nfsd_open_local_fh = nfsd_open_local_fh,
 	.nfsd_file_put_local = nfsd_file_put_local,
-	.nfsd_file_get = nfsd_file_get,
-	.nfsd_file_put = nfsd_file_put,
+	.nfsd_file_get_local = nfsd_file_get_local,
 	.nfsd_file_file = nfsd_file_file,
 };
 
@@ -71,6 +70,9 @@ nfsd_open_local_fh(struct net *net, struct auth_domain *dom,
 	if (nfs_fh->size > NFS4_FHSIZE)
 		return ERR_PTR(-EINVAL);
 
+	if (!nfsd_net_try_get(net))
+		return ERR_PTR(-ENXIO);
+
 	/* nfs_fh -> svc_fh */
 	fh_init(&fh, NFS4_FHSIZE);
 	fh.fh_handle.fh_size = nfs_fh->size;
@@ -92,6 +94,9 @@ nfsd_open_local_fh(struct net *net, struct auth_domain *dom,
 	if (rq_cred.cr_group_info)
 		put_group_info(rq_cred.cr_group_info);
 
+	if (IS_ERR(localio))
+		nfsd_net_put(net);
+
 	return localio;
 }
 EXPORT_SYMBOL_GPL(nfsd_open_local_fh);
diff --git a/include/linux/nfslocalio.h b/include/linux/nfslocalio.h
index 9aa8a43843d71..c3f34bae60e13 100644
--- a/include/linux/nfslocalio.h
+++ b/include/linux/nfslocalio.h
@@ -66,8 +66,7 @@ struct nfsd_localio_operations {
 						const struct nfs_fh *,
 						const fmode_t);
 	struct net *(*nfsd_file_put_local)(struct nfsd_file *);
-	struct nfsd_file *(*nfsd_file_get)(struct nfsd_file *);
-	void (*nfsd_file_put)(struct nfsd_file *);
+	struct nfsd_file *(*nfsd_file_get_local)(struct nfsd_file *);
 	struct file *(*nfsd_file_file)(struct nfsd_file *);
 } ____cacheline_aligned;
 
-- 
2.39.5



