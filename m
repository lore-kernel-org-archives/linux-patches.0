Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EE14BEE52;
	Sat, 12 Sep 2026 16:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231882; cv=none; b=P4bRqoxhbqWiVV5QfaBjaYMQKEDCkiyXYzaylRuLmt8gQMSCs4yhWCI7BUXFGPBBV2fQ35j88ySBXaLtjRIUL4cv1Iw0IY2naVphSEuHt7xHVIJW7VmxCfyGcpS1KXSsP2xjJxwpNZnQZKcxPL9hsTSOoiEzBtzc85r3jWgIm8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231882; c=relaxed/simple;
	bh=tI/dC0ru6lKp/52jBWICboi6H4p+81x1gEwvTanzs9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKFkZCHI4nk5XySOQbld3QWMuSK/bhBSJAdA9GD3YiVZgzaQ6XC45kzsSzdAGd8S2s0Zx42YUlOxtY7A9a35z4dhzwvpz86tSGmN3R45LYlNcPDaP95IkgIaBGQwa0Uk8HSeI5UNLq29cJgAOTj4dpEK6cRrhRjPadlzy9KdAtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CY1WkfBJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CY1WkfBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DFA01F000FF;
	Sat, 12 Sep 2026 16:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231880;
	bh=orc6ZT0uW9WRjlTGuykF3Gvmdczyup0CvQGVDmZHAP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CY1WkfBJuwhdyISZpZ/x+f0JZVReVsrNqTG8zmjwO5Tn7hQft4r/V3bRH242lBSLn
	 arBsovazaeAM6D1Pcahj2VMkd0osqMb6S4jgoxQPC5IQop5K9HwBtRFz6ilPDozn2x
	 DMIrV9O4x4FQjYM0M5T6VmukFvU6Z45s5C4LLni0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sargun Dillon <sargun@sargun.me>,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1088/1191] nfs: move the nfs4_data_server_cache into struct nfs_net
Date: Sat, 12 Sep 2026 09:03:36 +0200
Message-ID: <20260912065612.601253095@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit d5fb22a7c585b12ec3e6cef150689f7386e8cfd0 ]

Since struct nfs4_pnfs_ds should not be shared between net namespaces,
move from a global list of objects to a per-netns list and spinlock.

Tested-by: Sargun Dillon <sargun@sargun.me>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Link: https://lore.kernel.org/r/20250410-nfs-ds-netns-v2-2-f80b7979ba80@kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: 13c23c5cb977 ("NFSv4/pnfs: key the data server cache on the NFS version")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/client.c   |  7 +++++++
 fs/nfs/netns.h    |  6 +++++-
 fs/nfs/pnfs_nfs.c | 31 +++++++++++++++++--------------
 3 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 38354f70f885c..40e4a3b350466 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -1210,6 +1210,10 @@ void nfs_clients_init(struct net *net)
 	INIT_LIST_HEAD(&nn->nfs_volume_list);
 #if IS_ENABLED(CONFIG_NFS_V4)
 	idr_init(&nn->cb_ident_idr);
+#endif
+#if IS_ENABLED(CONFIG_NFS_V4_1)
+	INIT_LIST_HEAD(&nn->nfs4_data_server_cache);
+	spin_lock_init(&nn->nfs4_data_server_lock);
 #endif
 	spin_lock_init(&nn->nfs_client_lock);
 	nn->boot_time = ktime_get_real();
@@ -1227,6 +1231,9 @@ void nfs_clients_exit(struct net *net)
 	nfs_cleanup_cb_ident_idr(net);
 	WARN_ON_ONCE(!list_empty(&nn->nfs_client_list));
 	WARN_ON_ONCE(!list_empty(&nn->nfs_volume_list));
+#if IS_ENABLED(CONFIG_NFS_V4_1)
+	WARN_ON_ONCE(!list_empty(&nn->nfs4_data_server_cache));
+#endif
 }
 
 #ifdef CONFIG_PROC_FS
diff --git a/fs/nfs/netns.h b/fs/nfs/netns.h
index a68b21603ea9a..6ba3ea39e928c 100644
--- a/fs/nfs/netns.h
+++ b/fs/nfs/netns.h
@@ -31,7 +31,11 @@ struct nfs_net {
 	unsigned short nfs_callback_tcpport;
 	unsigned short nfs_callback_tcpport6;
 	int cb_users[NFS4_MAX_MINOR_VERSION + 1];
-#endif
+#endif /* CONFIG_NFS_V4 */
+#if IS_ENABLED(CONFIG_NFS_V4_1)
+	struct list_head nfs4_data_server_cache;
+	spinlock_t nfs4_data_server_lock;
+#endif /* CONFIG_NFS_V4_1 */
 	struct nfs_netns_client *nfs_client;
 	spinlock_t nfs_client_lock;
 	ktime_t boot_time;
diff --git a/fs/nfs/pnfs_nfs.c b/fs/nfs/pnfs_nfs.c
index 08634d97746fa..a4aceeeafd620 100644
--- a/fs/nfs/pnfs_nfs.c
+++ b/fs/nfs/pnfs_nfs.c
@@ -16,6 +16,7 @@
 #include "nfs4session.h"
 #include "internal.h"
 #include "pnfs.h"
+#include "netns.h"
 
 #define NFSDBG_FACILITY		NFSDBG_PNFS
 
@@ -551,14 +552,14 @@ EXPORT_SYMBOL_GPL(pnfs_generic_commit_pagelist);
 /*
  * Data server cache
  *
- * Data servers can be mapped to different device ids.
- * nfs4_pnfs_ds reference counting
+ * Data servers can be mapped to different device ids, but should
+ * never be shared between net namespaces.
+ *
+ * nfs4_pnfs_ds reference counting:
  *   - set to 1 on allocation
  *   - incremented when a device id maps a data server already in the cache.
  *   - decremented when deviceid is removed from the cache.
  */
-static DEFINE_SPINLOCK(nfs4_ds_cache_lock);
-static LIST_HEAD(nfs4_data_server_cache);
 
 /* Debug routines */
 static void
@@ -651,12 +652,12 @@ _same_data_server_addrs_locked(const struct list_head *dsaddrs1,
  * Lookup DS by addresses.  nfs4_ds_cache_lock is held
  */
 static struct nfs4_pnfs_ds *
-_data_server_lookup_locked(const struct net *net, const struct list_head *dsaddrs)
+_data_server_lookup_locked(const struct nfs_net *nn, const struct list_head *dsaddrs)
 {
 	struct nfs4_pnfs_ds *ds;
 
-	list_for_each_entry(ds, &nfs4_data_server_cache, ds_node)
-		if (ds->ds_net == net && _same_data_server_addrs_locked(&ds->ds_addrs, dsaddrs))
+	list_for_each_entry(ds, &nn->nfs4_data_server_cache, ds_node)
+		if (_same_data_server_addrs_locked(&ds->ds_addrs, dsaddrs))
 			return ds;
 	return NULL;
 }
@@ -700,10 +701,11 @@ static void destroy_ds(struct nfs4_pnfs_ds *ds)
 
 void nfs4_pnfs_ds_put(struct nfs4_pnfs_ds *ds)
 {
-	if (refcount_dec_and_lock(&ds->ds_count,
-				&nfs4_ds_cache_lock)) {
+	struct nfs_net *nn = net_generic(ds->ds_net, nfs_net_id);
+
+	if (refcount_dec_and_lock(&ds->ds_count, &nn->nfs4_data_server_lock)) {
 		list_del_init(&ds->ds_node);
-		spin_unlock(&nfs4_ds_cache_lock);
+		spin_unlock(&nn->nfs4_data_server_lock);
 		destroy_ds(ds);
 	}
 }
@@ -765,6 +767,7 @@ nfs4_pnfs_remotestr(struct list_head *dsaddrs, gfp_t gfp_flags)
 struct nfs4_pnfs_ds *
 nfs4_pnfs_ds_add(const struct net *net, struct list_head *dsaddrs, gfp_t gfp_flags)
 {
+	struct nfs_net *nn = net_generic(net, nfs_net_id);
 	struct nfs4_pnfs_ds *tmp_ds, *ds = NULL;
 	char *remotestr;
 
@@ -780,8 +783,8 @@ nfs4_pnfs_ds_add(const struct net *net, struct list_head *dsaddrs, gfp_t gfp_fla
 	/* this is only used for debugging, so it's ok if its NULL */
 	remotestr = nfs4_pnfs_remotestr(dsaddrs, gfp_flags);
 
-	spin_lock(&nfs4_ds_cache_lock);
-	tmp_ds = _data_server_lookup_locked(net, dsaddrs);
+	spin_lock(&nn->nfs4_data_server_lock);
+	tmp_ds = _data_server_lookup_locked(nn, dsaddrs);
 	if (tmp_ds == NULL) {
 		INIT_LIST_HEAD(&ds->ds_addrs);
 		list_splice_init(dsaddrs, &ds->ds_addrs);
@@ -790,7 +793,7 @@ nfs4_pnfs_ds_add(const struct net *net, struct list_head *dsaddrs, gfp_t gfp_fla
 		INIT_LIST_HEAD(&ds->ds_node);
 		ds->ds_net = net;
 		ds->ds_clp = NULL;
-		list_add(&ds->ds_node, &nfs4_data_server_cache);
+		list_add(&ds->ds_node, &nn->nfs4_data_server_cache);
 		dprintk("%s add new data server %s\n", __func__,
 			ds->ds_remotestr);
 	} else {
@@ -802,7 +805,7 @@ nfs4_pnfs_ds_add(const struct net *net, struct list_head *dsaddrs, gfp_t gfp_fla
 			refcount_read(&tmp_ds->ds_count));
 		ds = tmp_ds;
 	}
-	spin_unlock(&nfs4_ds_cache_lock);
+	spin_unlock(&nn->nfs4_data_server_lock);
 out:
 	return ds;
 }
-- 
2.53.0



