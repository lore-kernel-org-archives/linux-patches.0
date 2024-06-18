Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFB51A2C04;
	Tue, 18 Jun 2024 13:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716352; cv=none; b=gQP7euxuejhsPYGoaXg7/9Ih8t44hFyhCcLZdYDfujqcLSE0RI3+Hx3dfwLRZ5gihbWTCn9qPg747N6m9yiqWhluUeoCvl+ayFUx9UWtYboZdLSxEzB2/9r5sCCRZPyQUL3Dy3i/gZucW7Fj3Tu9tv+lDBL/wET7soLRNmBgLdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716352; c=relaxed/simple;
	bh=gkqS3+OUGJUYFFazj1TQA9LXDfh+Ka4D1vhQUVgLmVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Il/6Qn/KGnA5BBCuyW1qvPTMSSYkUf7RGREiqLw3FqQhFRcQIcpsmpnz07IzrDkrXasNSvkKu9LJbHQy7H9JNG1CAVC0yf+8uUhZOAjfwvBsTpC7+keWPudydbZvfknBt0ZqshcuQlOlGMfyhXknr7ZfrqnfjqewbsKh6gzmmdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hC/enqn1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hC/enqn1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2288FC3277B;
	Tue, 18 Jun 2024 13:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716352;
	bh=gkqS3+OUGJUYFFazj1TQA9LXDfh+Ka4D1vhQUVgLmVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hC/enqn1VLz6WVFskIELEkj3Nvng6zx+rXRVqSKO37TQ7qp0ndLFGPUj2Tvnb85jP
	 m9wcWxOKXa+WJNWNidOPqlehzaiNkA6XbFTh+POtgfRK1DmIYrerwRgQvSmNDDRxKQ
	 FYRLE7D71uole9BLMMZeQQAcYVNQQVBzkNHv3MDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 586/770] NFSD: keep track of the number of v4 clients in the system
Date: Tue, 18 Jun 2024 14:37:19 +0200
Message-ID: <20240618123429.914106007@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 0926c39515aa065a296e97dfc8790026f1e53f86 ]

Add counter nfs4_client_count to keep track of the total number
of v4 clients, including courtesy clients, in the system.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
index 76a77329cf368..5003d73fa9287 100644
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



