Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80AFD3B3C10;
	Sat, 12 Sep 2026 20:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243541; cv=none; b=EMzNPXHm08oaCWq70jEoNTXJ3vvjrKDCupkjkC85y2f/RERy5LuDy6vwGPq+nUTMNPkdBBuMmj8PxpFguEA8+epUOsX3YwcBOAMYkyWmWMt7txhVEXXtP1u0+quW9QmNppqzL0VE4ozr7FoH+T8tJb3snVZQEbo84QOP7FrMoy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243541; c=relaxed/simple;
	bh=1SliTD0cFPb4Lf2tirHhdQyA47yn1M6OLfq5deThFIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbJ6TVtzPgtsk3z0kdBk39ZQgD8xU26+/Fa3ITX0klIK2KRY0x9Ui8vuc+KEZUSXuWODxH05KCc1m3X2I/vP2CSUt4p8o+t2QVdBF86VtiDVy9fVtp8nVE49qI0eJvQOH4/D8/NixY2R6J4RBLuuMdMQW8a3l8CJs8UvG/Qpe+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1XsDFHjw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1XsDFHjw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BDE1F000FF;
	Sat, 12 Sep 2026 20:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243535;
	bh=KV6G4ZqWy5nMfYubpIYE9crbcYLWWKKpUEr+8WPmRuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1XsDFHjwaQ+LzNy+e/0hqiKn5xGOZgzlVqnuqB8oEe0tndMAQiTu66CozeVB88Esc
	 QjrDqC12K25L9DPXKQjZsuk1Z8FN9ua0hTQ90/PfOtVllB8JJ7a6RhNArjf6iEW8k9
	 a9MGbOiLsyuSh160vrgLGZWYe+bmU8Y9b2x4BUgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 746/798] NFSv4/pnfs: key the data server cache on the NFS version
Date: Sat, 12 Sep 2026 09:06:14 +0200
Message-ID: <20260912065534.171915505@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 13c23c5cb977f66390795437fd3837887ce1fd75 ]

nfs4_pnfs_ds_add() keys the per-net data server cache on the multipath
address set alone, and struct nfs4_pnfs_ds records no version. That
suffices for the files layout driver, which always connects with version
4, but flexfiles takes its version tuple from GETDEVICEINFO per device,
and one address can legitimately serve both NFSv3 and NFSv4.

Two deviceids on one address with different ds_versions[0].version
therefore share a single nfs4_pnfs_ds, and whichever mirror connects
first pins ds_clp to its own version. The other one is handed that
client anyway, so it selects rpc_call_ops for a version the connection
does not speak, and the mismatched sequence-slot handling dereferences
NULL.

Add the version to the cache key so the two cannot alias, giving each
version its own nfs4_pnfs_ds and connection while both mirrors stay
usable. Only the major version is compared, since that is what selects
rpc_call_ops and rpc_ops; v4.0 and v4.1 keep sharing a client. The files
layout driver passes the 4 it already hardcodes at connect time.

Fixes: d67ae825a59d ("pnfs/flexfiles: Add the FlexFile Layout Driver")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/filelayout/filelayoutdev.c         |  3 ++-
 fs/nfs/flexfilelayout/flexfilelayoutdev.c |  3 ++-
 fs/nfs/pnfs.h                             |  3 ++-
 fs/nfs/pnfs_nfs.c                         | 14 +++++++++-----
 4 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/nfs/filelayout/filelayoutdev.c b/fs/nfs/filelayout/filelayoutdev.c
index e6bf55e37521f..4391d88e78759 100644
--- a/fs/nfs/filelayout/filelayoutdev.c
+++ b/fs/nfs/filelayout/filelayoutdev.c
@@ -171,7 +171,8 @@ nfs4_fl_alloc_deviceid_node(struct nfs_server *server, struct pnfs_device *pdev,
 			goto out_err_free_deviceid;
 		}
 
-		dsaddr->ds_list[i] = nfs4_pnfs_ds_add(net, &dsaddrs, gfp_flags);
+		dsaddr->ds_list[i] = nfs4_pnfs_ds_add(net, &dsaddrs, 4,
+						      gfp_flags);
 		if (!dsaddr->ds_list[i])
 			goto out_err_drain_dsaddrs;
 
diff --git a/fs/nfs/flexfilelayout/flexfilelayoutdev.c b/fs/nfs/flexfilelayout/flexfilelayoutdev.c
index 35cac4d3f2e8a..d5aff162348ad 100644
--- a/fs/nfs/flexfilelayout/flexfilelayoutdev.c
+++ b/fs/nfs/flexfilelayout/flexfilelayoutdev.c
@@ -147,7 +147,8 @@ nfs4_ff_alloc_deviceid_node(struct nfs_server *server, struct pnfs_device *pdev,
 	new_ds->ds_versions = ds_versions;
 	new_ds->ds_versions_cnt = version_count;
 
-	new_ds->ds = nfs4_pnfs_ds_add(net, &dsaddrs, gfp_flags);
+	new_ds->ds = nfs4_pnfs_ds_add(net, &dsaddrs, ds_versions[0].version,
+				      gfp_flags);
 	if (!new_ds->ds)
 		goto out_err_drain_dsaddrs;
 
diff --git a/fs/nfs/pnfs.h b/fs/nfs/pnfs.h
index f88b0cf00f21e..bed76c18eae0d 100644
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -60,6 +60,7 @@ struct nfs4_pnfs_ds {
 	const struct net	*ds_net;
 	struct nfs_client	*ds_clp;
 	refcount_t		ds_count;
+	u32			ds_version;	/* cache key, with ds_addrs */
 	unsigned long		ds_state;
 #define NFS4DS_CONNECTING	0	/* ds is establishing connection */
 };
@@ -408,7 +409,7 @@ void pnfs_generic_write_commit_done(struct rpc_task *task, void *data);
 void nfs4_pnfs_ds_put(struct nfs4_pnfs_ds *ds);
 struct nfs4_pnfs_ds *nfs4_pnfs_ds_add(const struct net *net,
 				      struct list_head *dsaddrs,
-				      gfp_t gfp_flags);
+				      u32 version, gfp_t gfp_flags);
 void nfs4_pnfs_v3_ds_connect_unload(void);
 int nfs4_pnfs_ds_connect(struct nfs_server *mds_srv, struct nfs4_pnfs_ds *ds,
 			  struct nfs4_deviceid_node *devid, unsigned int timeo,
diff --git a/fs/nfs/pnfs_nfs.c b/fs/nfs/pnfs_nfs.c
index 6abab15ea7dcb..503d04d39bca1 100644
--- a/fs/nfs/pnfs_nfs.c
+++ b/fs/nfs/pnfs_nfs.c
@@ -649,15 +649,17 @@ _same_data_server_addrs_locked(const struct list_head *dsaddrs1,
 }
 
 /*
- * Lookup DS by addresses.  nfs4_ds_cache_lock is held
+ * Lookup DS by addresses and NFS version.  nfs4_ds_cache_lock is held
  */
 static struct nfs4_pnfs_ds *
-_data_server_lookup_locked(const struct nfs_net *nn, const struct list_head *dsaddrs)
+_data_server_lookup_locked(const struct nfs_net *nn,
+			   const struct list_head *dsaddrs, u32 version)
 {
 	struct nfs4_pnfs_ds *ds;
 
 	list_for_each_entry(ds, &nn->nfs4_data_server_cache, ds_node)
-		if (_same_data_server_addrs_locked(&ds->ds_addrs, dsaddrs))
+		if (ds->ds_version == version &&
+		    _same_data_server_addrs_locked(&ds->ds_addrs, dsaddrs))
 			return ds;
 	return NULL;
 }
@@ -751,7 +753,8 @@ nfs4_pnfs_remotestr(struct list_head *dsaddrs, gfp_t gfp_flags)
  * uncached and return cached struct nfs4_pnfs_ds.
  */
 struct nfs4_pnfs_ds *
-nfs4_pnfs_ds_add(const struct net *net, struct list_head *dsaddrs, gfp_t gfp_flags)
+nfs4_pnfs_ds_add(const struct net *net, struct list_head *dsaddrs, u32 version,
+		 gfp_t gfp_flags)
 {
 	struct nfs_net *nn = net_generic(net, nfs_net_id);
 	struct nfs4_pnfs_ds *tmp_ds, *ds = NULL;
@@ -770,7 +773,7 @@ nfs4_pnfs_ds_add(const struct net *net, struct list_head *dsaddrs, gfp_t gfp_fla
 	remotestr = nfs4_pnfs_remotestr(dsaddrs, gfp_flags);
 
 	spin_lock(&nn->nfs4_data_server_lock);
-	tmp_ds = _data_server_lookup_locked(nn, dsaddrs);
+	tmp_ds = _data_server_lookup_locked(nn, dsaddrs, version);
 	if (tmp_ds == NULL) {
 		INIT_LIST_HEAD(&ds->ds_addrs);
 		list_splice_init(dsaddrs, &ds->ds_addrs);
@@ -779,6 +782,7 @@ nfs4_pnfs_ds_add(const struct net *net, struct list_head *dsaddrs, gfp_t gfp_fla
 		INIT_LIST_HEAD(&ds->ds_node);
 		ds->ds_net = net;
 		ds->ds_clp = NULL;
+		ds->ds_version = version;
 		list_add(&ds->ds_node, &nn->nfs4_data_server_cache);
 		dprintk("%s add new data server %s\n", __func__,
 			ds->ds_remotestr);
-- 
2.53.0



