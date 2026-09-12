Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D14841A57D;
	Sat, 12 Sep 2026 09:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205079; cv=none; b=eel0d+9rxvoxWMZPiHj2aHKhxjWy6gmq2xwklitIz0dSsIRecxYbSS3mlw+PU7Hy+3Fux1TSF9SIm8ZrUATDNsirdL+nkBEee+bUBNxxulfTVAAcuXroz18R/dMi7ljb4avmSltCoOK+usDDXQ51967kqwADi5pbkRbAtaEDpj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205079; c=relaxed/simple;
	bh=V/qZBYwccM3WlvS3PBl6CdJrMJZSxPWbecEjFcsQU+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dz5L7/lWi9Yv9HQj33AmHTxibxCs9VSE/TWOFl8TpYQf/+er//izHU5SntjGTuVAcDvJelppIF21FW/JXg9B71o89wad/4uyuJ2yHmH6uiNv6I5BocfPC8L4r/czHZoNEFWE1o1DpbCXdTytoYoV5HFC6tHwx003jppWl1eSyB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ciFSipZ2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ciFSipZ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9231F000FF;
	Sat, 12 Sep 2026 09:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205078;
	bh=8iMnTe38kyWUVi7xk3aH1P2A+ZWB4US3Y3yci78gfKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ciFSipZ2E7e59k8sS+w1uG953kl+f5Sf1j4ZYq3fhPJFYMfyTTLCBtNj/Gi2Rnbmd
	 9YFWWNFGG1GY6pSzTLVQb8ikcWsPMpnhuh8izO7dJC5053pfcYLeTCiLCcD1tUIRKq
	 9fBBG3Ao+0F82/MrKEwRexz0f8632Kw/9hNDapiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1691/1815] NFSv4/pnfs: key the data server cache on the NFS version
Date: Sat, 12 Sep 2026 08:57:21 +0200
Message-ID: <20260912065728.679404893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 7226989ee4d53..9ddcaf86fcef0 100644
--- a/fs/nfs/filelayout/filelayoutdev.c
+++ b/fs/nfs/filelayout/filelayoutdev.c
@@ -170,7 +170,8 @@ nfs4_fl_alloc_deviceid_node(struct nfs_server *server, struct pnfs_device *pdev,
 			goto out_err_free_deviceid;
 		}
 
-		dsaddr->ds_list[i] = nfs4_pnfs_ds_add(net, &dsaddrs, gfp_flags);
+		dsaddr->ds_list[i] = nfs4_pnfs_ds_add(net, &dsaddrs, 4,
+						      gfp_flags);
 		if (!dsaddr->ds_list[i])
 			goto out_err_drain_dsaddrs;
 		trace_fl_getdevinfo(server, &pdev->dev_id, dsaddr->ds_list[i]->ds_remotestr);
diff --git a/fs/nfs/flexfilelayout/flexfilelayoutdev.c b/fs/nfs/flexfilelayout/flexfilelayoutdev.c
index 1109462a96991..c716fd99e8ef9 100644
--- a/fs/nfs/flexfilelayout/flexfilelayoutdev.c
+++ b/fs/nfs/flexfilelayout/flexfilelayoutdev.c
@@ -153,7 +153,8 @@ nfs4_ff_alloc_deviceid_node(struct nfs_server *server, struct pnfs_device *pdev,
 	new_ds->ds_versions = ds_versions;
 	new_ds->ds_versions_cnt = version_count;
 
-	new_ds->ds = nfs4_pnfs_ds_add(net, &dsaddrs, gfp_flags);
+	new_ds->ds = nfs4_pnfs_ds_add(net, &dsaddrs, ds_versions[0].version,
+				      gfp_flags);
 	if (!new_ds->ds)
 		goto out_err_drain_dsaddrs;
 
diff --git a/fs/nfs/pnfs.h b/fs/nfs/pnfs.h
index eb39859c216c9..f06a03ac4fa37 100644
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -63,6 +63,7 @@ struct nfs4_pnfs_ds {
 	const struct net	*ds_net;
 	struct nfs_client	*ds_clp;
 	refcount_t		ds_count;
+	u32			ds_version;	/* cache key, with ds_addrs */
 	unsigned long		ds_state;
 #define NFS4DS_CONNECTING	0	/* ds is establishing connection */
 };
@@ -417,7 +418,7 @@ void pnfs_generic_write_commit_done(struct rpc_task *task, void *data);
 void nfs4_pnfs_ds_put(struct nfs4_pnfs_ds *ds);
 struct nfs4_pnfs_ds *nfs4_pnfs_ds_add(const struct net *net,
 				      struct list_head *dsaddrs,
-				      gfp_t gfp_flags);
+				      u32 version, gfp_t gfp_flags);
 void nfs4_pnfs_v3_ds_connect_unload(void);
 int nfs4_pnfs_ds_connect(struct nfs_server *mds_srv, struct nfs4_pnfs_ds *ds,
 			  struct nfs4_deviceid_node *devid, unsigned int timeo,
diff --git a/fs/nfs/pnfs_nfs.c b/fs/nfs/pnfs_nfs.c
index 648c95b78eeab..49c621cde43a8 100644
--- a/fs/nfs/pnfs_nfs.c
+++ b/fs/nfs/pnfs_nfs.c
@@ -603,15 +603,17 @@ _same_data_server_addrs_locked(const struct list_head *dsaddrs1,
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
@@ -719,7 +721,8 @@ nfs4_pnfs_remotestr(struct list_head *dsaddrs, gfp_t gfp_flags)
  * uncached and return cached struct nfs4_pnfs_ds.
  */
 struct nfs4_pnfs_ds *
-nfs4_pnfs_ds_add(const struct net *net, struct list_head *dsaddrs, gfp_t gfp_flags)
+nfs4_pnfs_ds_add(const struct net *net, struct list_head *dsaddrs, u32 version,
+		 gfp_t gfp_flags)
 {
 	struct nfs_net *nn = net_generic(net, nfs_net_id);
 	struct nfs4_pnfs_ds *tmp_ds, *ds = NULL;
@@ -738,7 +741,7 @@ nfs4_pnfs_ds_add(const struct net *net, struct list_head *dsaddrs, gfp_t gfp_fla
 	remotestr = nfs4_pnfs_remotestr(dsaddrs, gfp_flags);
 
 	spin_lock(&nn->nfs4_data_server_lock);
-	tmp_ds = _data_server_lookup_locked(nn, dsaddrs);
+	tmp_ds = _data_server_lookup_locked(nn, dsaddrs, version);
 	if (tmp_ds == NULL) {
 		INIT_LIST_HEAD(&ds->ds_addrs);
 		list_splice_init(dsaddrs, &ds->ds_addrs);
@@ -747,6 +750,7 @@ nfs4_pnfs_ds_add(const struct net *net, struct list_head *dsaddrs, gfp_t gfp_fla
 		INIT_LIST_HEAD(&ds->ds_node);
 		ds->ds_net = net;
 		ds->ds_clp = NULL;
+		ds->ds_version = version;
 		list_add(&ds->ds_node, &nn->nfs4_data_server_cache);
 		dprintk("%s add new data server %s\n", __func__,
 			ds->ds_remotestr);
-- 
2.53.0



