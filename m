Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834292DF73;
	Mon,  8 Apr 2024 13:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584262; cv=none; b=FUYWpD30CZzxArn9FsJFUE1IGh3JXxdXyOsfyF8Ip4GD1HN48mGc+Eap0VGbMZDLoAdDAw08V+j6b7x27A0Mrk/U6MrYdjC/5l1jF/6cYrKokiymbN4GpQWV0tWZEE/KwTkWS+VUyAwVwr1dooSsFeRoDZVlohzJ2ICYXtU8JPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584262; c=relaxed/simple;
	bh=sCZCQVXWzPKOy3+4XVlXxEVqoU3dDkH3ChtujZxxQpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D1yIDw68A30ip9u9AGbfdNqdFHWWs7kTI4U5XuCQqi7WFRkD/GnBnkUtGntuD50RaKxkmJWJyFKquqDk40o2yklh1kCcFYKI2ncqnDlIqRfeWtQ8QbDin1CDeXbLqLsZwC6GNZoYUJUGI6K43ZPXghcc7r/BLR1Nqa+u9Woqe5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GnCVafmV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GnCVafmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C63C433C7;
	Mon,  8 Apr 2024 13:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584262;
	bh=sCZCQVXWzPKOy3+4XVlXxEVqoU3dDkH3ChtujZxxQpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GnCVafmV58ISpLWe69bCuRlAEWCeA54K6cwSCp51lOWVAaI+3sno2C12xILit50Jc
	 TVGIK3/t1Zv3kgiVWTcaUlmitVY7fNyMyrRcwTfdho+KfDBtvXIVc5N4mESdKwZrCO
	 aG8UX47cLrMe1iDrVmkaKD+Haxd74/g07bUE2Bs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 377/690] NFSD: keep track of the number of v4 clients in the system
Date: Mon,  8 Apr 2024 14:54:03 +0200
Message-ID: <20240408125413.213861628@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 0926c39515aa065a296e97dfc8790026f1e53f86 ]

Add counter nfs4_client_count to keep track of the total number
of v4 clients, including courtesy clients, in the system.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/netns.h     |  2 ++
 fs/nfsd/nfs4state.c | 10 ++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/netns.h b/fs/nfsd/netns.h
index 1b1a962a18041..ce864f001a3ee 100644
--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -189,6 +189,8 @@ struct nfsd_net {
 	struct nfsd_fcache_disposal *fcache_disposal;
 
 	siphash_key_t		siphash_key;
+
+	atomic_t		nfs4_client_count;
 };
 
 /* Simple check to find out if a given net was properly initialized */
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index a75f3f7c94d50..3d5ef021632b9 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2066,7 +2066,8 @@ STALE_CLIENTID(clientid_t *clid, struct nfsd_net *nn)
  * This type of memory management is somewhat inefficient, but we use it
  * anyway since SETCLIENTID is not a common operation.
  */
-static struct nfs4_client *alloc_client(struct xdr_netobj name)
+static struct nfs4_client *alloc_client(struct xdr_netobj name,
+				struct nfsd_net *nn)
 {
 	struct nfs4_client *clp;
 	int i;
@@ -2089,6 +2090,7 @@ static struct nfs4_client *alloc_client(struct xdr_netobj name)
 	atomic_set(&clp->cl_rpc_users, 0);
 	clp->cl_cb_state = NFSD4_CB_UNKNOWN;
 	clp->cl_state = NFSD4_ACTIVE;
+	atomic_inc(&nn->nfs4_client_count);
 	atomic_set(&clp->cl_delegs_in_recall, 0);
 	INIT_LIST_HEAD(&clp->cl_idhash);
 	INIT_LIST_HEAD(&clp->cl_openowners);
@@ -2196,6 +2198,7 @@ static __be32 mark_client_expired_locked(struct nfs4_client *clp)
 static void
 __destroy_client(struct nfs4_client *clp)
 {
+	struct nfsd_net *nn = net_generic(clp->net, nfsd_net_id);
 	int i;
 	struct nfs4_openowner *oo;
 	struct nfs4_delegation *dp;
@@ -2239,6 +2242,7 @@ __destroy_client(struct nfs4_client *clp)
 	nfsd4_shutdown_callback(clp);
 	if (clp->cl_cb_conn.cb_xprt)
 		svc_xprt_put(clp->cl_cb_conn.cb_xprt);
+	atomic_add_unless(&nn->nfs4_client_count, -1, 0);
 	free_client(clp);
 	wake_up_all(&expiry_wq);
 }
@@ -2865,7 +2869,7 @@ static struct nfs4_client *create_client(struct xdr_netobj name,
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 	struct dentry *dentries[ARRAY_SIZE(client_files)];
 
-	clp = alloc_client(name);
+	clp = alloc_client(name, nn);
 	if (clp == NULL)
 		return NULL;
 
@@ -4357,6 +4361,8 @@ void nfsd4_init_leases_net(struct nfsd_net *nn)
 	nn->clientid_base = prandom_u32();
 	nn->clientid_counter = nn->clientid_base + 1;
 	nn->s2s_cp_cl_id = nn->clientid_counter++;
+
+	atomic_set(&nn->nfs4_client_count, 0);
 }
 
 static void init_nfs4_replay(struct nfs4_replay *rp)
-- 
2.43.0



