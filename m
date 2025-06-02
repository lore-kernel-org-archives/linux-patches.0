Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6307F230BC0;
	Mon,  2 Jun 2025 14:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874991; cv=none; b=dwNrFFnHS3oQTDtq6RkAhWUGpbPV0bohTUWMIt1jpekBYkB0InnDu3QylS5JujbqIYG+Ms73i7NtbViTfCCTcCaSSjHjokpJnLdLgEReTn4vXErCZAhIStShR5pP20OvtW/yiyBff6c37e8npZha7l3Z4/kI0Vy0VveDba9C1K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874991; c=relaxed/simple;
	bh=fPKqKrfVDiyZW5VMmJLYvOQgNN4f7hIB6rulrzZIMco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6LheMkUIESIOGHjcWUom8+rFFWJgj4LU6OCy7wP1rKtJcBV1kX+lrYOrebyi6q1gfB5zzAfENlM4EJBCxA+5fhJuDkvJ+bOpa9edJSzPilCYsL/VFhyNksdWhza8Vj8/r8FL5fjVGs8fE6TqU6DgTD5Mj83kUbbiBYPoIhvoA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lUO8Ep30; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lUO8Ep30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93071C4CEF0;
	Mon,  2 Jun 2025 14:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874991;
	bh=fPKqKrfVDiyZW5VMmJLYvOQgNN4f7hIB6rulrzZIMco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lUO8Ep303+nT8r/J801UCSMcRDNoH1XWOWbJBGPt085n5RI9BjyNG1BE9uTF3s5KW
	 CHL0M5laH0Ym5DtINW590SBBnWyh7Nvw52GS60AISHSdzEVru/IVmLo+30o3xy52+l
	 FesZe5UOaQE15qtLkItnMVGGYPRqLNHi0JzXh1yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Omar Sandoval <osandov@osandov.com>,
	Sargun Dillon <sargun@sargun.me>,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 198/204] nfs: dont share pNFS DS connections between net namespaces
Date: Mon,  2 Jun 2025 15:48:51 +0200
Message-ID: <20250602134303.450017740@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 6b9785dc8b13d9fb75ceec8cf4ea7ec3f3b1edbc ]

Currently, different NFS clients can share the same DS connections, even
when they are in different net namespaces. If a containerized client
creates a DS connection, another container can find and use it. When the
first client exits, the connection will close which can lead to stalls
in other clients.

Add a net namespace pointer to struct nfs4_pnfs_ds, and compare those
value to the caller's netns in _data_server_lookup_locked() when
searching for a nfs4_pnfs_ds to match.

Reported-by: Omar Sandoval <osandov@osandov.com>
Reported-by: Sargun Dillon <sargun@sargun.me>
Closes: https://lore.kernel.org/linux-nfs/Z_ArpQC_vREh_hEA@telecaster/
Tested-by: Sargun Dillon <sargun@sargun.me>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Link: https://lore.kernel.org/r/20250410-nfs-ds-netns-v2-1-f80b7979ba80@kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/filelayout/filelayoutdev.c         | 6 +++---
 fs/nfs/flexfilelayout/flexfilelayoutdev.c | 6 +++---
 fs/nfs/pnfs.h                             | 4 +++-
 fs/nfs/pnfs_nfs.c                         | 9 +++++----
 4 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/nfs/filelayout/filelayoutdev.c b/fs/nfs/filelayout/filelayoutdev.c
index d913e818858f3..82bba1ede717c 100644
--- a/fs/nfs/filelayout/filelayoutdev.c
+++ b/fs/nfs/filelayout/filelayoutdev.c
@@ -75,6 +75,7 @@ nfs4_fl_alloc_deviceid_node(struct nfs_server *server, struct pnfs_device *pdev,
 	struct page *scratch;
 	struct list_head dsaddrs;
 	struct nfs4_pnfs_ds_addr *da;
+	struct net *net = server->nfs_client->cl_net;
 
 	/* set up xdr stream */
 	scratch = alloc_page(gfp_flags);
@@ -160,8 +161,7 @@ nfs4_fl_alloc_deviceid_node(struct nfs_server *server, struct pnfs_device *pdev,
 
 		mp_count = be32_to_cpup(p); /* multipath count */
 		for (j = 0; j < mp_count; j++) {
-			da = nfs4_decode_mp_ds_addr(server->nfs_client->cl_net,
-						    &stream, gfp_flags);
+			da = nfs4_decode_mp_ds_addr(net, &stream, gfp_flags);
 			if (da)
 				list_add_tail(&da->da_node, &dsaddrs);
 		}
@@ -171,7 +171,7 @@ nfs4_fl_alloc_deviceid_node(struct nfs_server *server, struct pnfs_device *pdev,
 			goto out_err_free_deviceid;
 		}
 
-		dsaddr->ds_list[i] = nfs4_pnfs_ds_add(&dsaddrs, gfp_flags);
+		dsaddr->ds_list[i] = nfs4_pnfs_ds_add(net, &dsaddrs, gfp_flags);
 		if (!dsaddr->ds_list[i])
 			goto out_err_drain_dsaddrs;
 
diff --git a/fs/nfs/flexfilelayout/flexfilelayoutdev.c b/fs/nfs/flexfilelayout/flexfilelayoutdev.c
index 1f12297109b41..e6d7473e1a32a 100644
--- a/fs/nfs/flexfilelayout/flexfilelayoutdev.c
+++ b/fs/nfs/flexfilelayout/flexfilelayoutdev.c
@@ -49,6 +49,7 @@ nfs4_ff_alloc_deviceid_node(struct nfs_server *server, struct pnfs_device *pdev,
 	struct nfs4_pnfs_ds_addr *da;
 	struct nfs4_ff_layout_ds *new_ds = NULL;
 	struct nfs4_ff_ds_version *ds_versions = NULL;
+	struct net *net = server->nfs_client->cl_net;
 	u32 mp_count;
 	u32 version_count;
 	__be32 *p;
@@ -80,8 +81,7 @@ nfs4_ff_alloc_deviceid_node(struct nfs_server *server, struct pnfs_device *pdev,
 
 	for (i = 0; i < mp_count; i++) {
 		/* multipath ds */
-		da = nfs4_decode_mp_ds_addr(server->nfs_client->cl_net,
-					    &stream, gfp_flags);
+		da = nfs4_decode_mp_ds_addr(net, &stream, gfp_flags);
 		if (da)
 			list_add_tail(&da->da_node, &dsaddrs);
 	}
@@ -147,7 +147,7 @@ nfs4_ff_alloc_deviceid_node(struct nfs_server *server, struct pnfs_device *pdev,
 	new_ds->ds_versions = ds_versions;
 	new_ds->ds_versions_cnt = version_count;
 
-	new_ds->ds = nfs4_pnfs_ds_add(&dsaddrs, gfp_flags);
+	new_ds->ds = nfs4_pnfs_ds_add(net, &dsaddrs, gfp_flags);
 	if (!new_ds->ds)
 		goto out_err_drain_dsaddrs;
 
diff --git a/fs/nfs/pnfs.h b/fs/nfs/pnfs.h
index b0f91a4592cb5..7976886a47db9 100644
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -57,6 +57,7 @@ struct nfs4_pnfs_ds {
 	struct list_head	ds_node;  /* nfs4_pnfs_dev_hlist dev_dslist */
 	char			*ds_remotestr;	/* comma sep list of addrs */
 	struct list_head	ds_addrs;
+	const struct net	*ds_net;
 	struct nfs_client	*ds_clp;
 	refcount_t		ds_count;
 	unsigned long		ds_state;
@@ -378,7 +379,8 @@ int pnfs_generic_commit_pagelist(struct inode *inode,
 int pnfs_generic_scan_commit_lists(struct nfs_commit_info *cinfo, int max);
 void pnfs_generic_write_commit_done(struct rpc_task *task, void *data);
 void nfs4_pnfs_ds_put(struct nfs4_pnfs_ds *ds);
-struct nfs4_pnfs_ds *nfs4_pnfs_ds_add(struct list_head *dsaddrs,
+struct nfs4_pnfs_ds *nfs4_pnfs_ds_add(const struct net *net,
+				      struct list_head *dsaddrs,
 				      gfp_t gfp_flags);
 void nfs4_pnfs_v3_ds_connect_unload(void);
 int nfs4_pnfs_ds_connect(struct nfs_server *mds_srv, struct nfs4_pnfs_ds *ds,
diff --git a/fs/nfs/pnfs_nfs.c b/fs/nfs/pnfs_nfs.c
index aff44a7b98f86..e2d90239d042d 100644
--- a/fs/nfs/pnfs_nfs.c
+++ b/fs/nfs/pnfs_nfs.c
@@ -414,12 +414,12 @@ _same_data_server_addrs_locked(const struct list_head *dsaddrs1,
  * Lookup DS by addresses.  nfs4_ds_cache_lock is held
  */
 static struct nfs4_pnfs_ds *
-_data_server_lookup_locked(const struct list_head *dsaddrs)
+_data_server_lookup_locked(const struct net *net, const struct list_head *dsaddrs)
 {
 	struct nfs4_pnfs_ds *ds;
 
 	list_for_each_entry(ds, &nfs4_data_server_cache, ds_node)
-		if (_same_data_server_addrs_locked(&ds->ds_addrs, dsaddrs))
+		if (ds->ds_net == net && _same_data_server_addrs_locked(&ds->ds_addrs, dsaddrs))
 			return ds;
 	return NULL;
 }
@@ -512,7 +512,7 @@ nfs4_pnfs_remotestr(struct list_head *dsaddrs, gfp_t gfp_flags)
  * uncached and return cached struct nfs4_pnfs_ds.
  */
 struct nfs4_pnfs_ds *
-nfs4_pnfs_ds_add(struct list_head *dsaddrs, gfp_t gfp_flags)
+nfs4_pnfs_ds_add(const struct net *net, struct list_head *dsaddrs, gfp_t gfp_flags)
 {
 	struct nfs4_pnfs_ds *tmp_ds, *ds = NULL;
 	char *remotestr;
@@ -530,13 +530,14 @@ nfs4_pnfs_ds_add(struct list_head *dsaddrs, gfp_t gfp_flags)
 	remotestr = nfs4_pnfs_remotestr(dsaddrs, gfp_flags);
 
 	spin_lock(&nfs4_ds_cache_lock);
-	tmp_ds = _data_server_lookup_locked(dsaddrs);
+	tmp_ds = _data_server_lookup_locked(net, dsaddrs);
 	if (tmp_ds == NULL) {
 		INIT_LIST_HEAD(&ds->ds_addrs);
 		list_splice_init(dsaddrs, &ds->ds_addrs);
 		ds->ds_remotestr = remotestr;
 		refcount_set(&ds->ds_count, 1);
 		INIT_LIST_HEAD(&ds->ds_node);
+		ds->ds_net = net;
 		ds->ds_clp = NULL;
 		list_add(&ds->ds_node, &nfs4_data_server_cache);
 		dprintk("%s add new data server %s\n", __func__,
-- 
2.39.5



