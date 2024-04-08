Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D253B6EB72;
	Mon,  8 Apr 2024 13:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584424; cv=none; b=oxUrnYq1BaY7JiNNDZT30GffIQ7vCe5yc547Oc53m4Z+9EDThrDVDuO9NQGzXp5Ds70Xg3q/+TWifzpxeOe4CsEDLc1+8k+dHBc6GvcrrKng98dAutdlzXIoW6pvzVDrRWLRtQLucH2G8qQ7Ai9hjiiVR3S6ptR6iCa72qluBzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584424; c=relaxed/simple;
	bh=q14isQLtueropXAEE7eWMIm3EZuj+eaOJalq2xgrKmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICECbl+ptVoqg0WYlzLeAQWzMZdRzLrGdPmDBnoj3OIwRcZunmWWNORN7Q0Y2qjOXIDChQZRXbOOFOs34hATlbK5qxTeeP/Laht/KFfQ1fO4R/tUEm6QhKmZ+EtTOloEa3S6zuceGua32U3LJizGdOHHC51Bcyxl4MwC/gNbtgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sHE/T0dq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHE/T0dq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DFD3C433C7;
	Mon,  8 Apr 2024 13:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584424;
	bh=q14isQLtueropXAEE7eWMIm3EZuj+eaOJalq2xgrKmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sHE/T0dqDbLgepKbH4CDK4K7BwttCo7aari0bXoch3DK3kNbcrpYwRt6GTQPr5gFj
	 bYdr/CI5Mf5b/9oOPWfCaK2J/BBr+pTIGGAJB99i4FId2QvKxUXpvR77xOnP1Gulij
	 EmomH32mVVAjXWTpbLHw+Eh30yl4WXNmvJRH343o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 434/690] NFSD: keep track of the number of courtesy clients in the system
Date: Mon,  8 Apr 2024 14:55:00 +0200
Message-ID: <20240408125415.333469739@linuxfoundation.org>
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

[ Upstream commit 3a4ea23d86a317c4b68b9a69d51f7e84e1e04357 ]

Add counter nfs4_courtesy_client_count to nfsd_net to keep track
of the number of courtesy clients in the system.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/netns.h     |  2 ++
 fs/nfsd/nfs4state.c | 17 ++++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/netns.h b/fs/nfsd/netns.h
index ffe17743cc74b..55c7006d6109a 100644
--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -192,6 +192,8 @@ struct nfsd_net {
 
 	atomic_t		nfs4_client_count;
 	int			nfs4_max_clients;
+
+	atomic_t		nfsd_courtesy_clients;
 };
 
 /* Simple check to find out if a given net was properly initialized */
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 6cb654e308787..6a7a99511111d 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -160,6 +160,13 @@ static bool is_client_expired(struct nfs4_client *clp)
 	return clp->cl_time == 0;
 }
 
+static void nfsd4_dec_courtesy_client_count(struct nfsd_net *nn,
+					struct nfs4_client *clp)
+{
+	if (clp->cl_state != NFSD4_ACTIVE)
+		atomic_add_unless(&nn->nfsd_courtesy_clients, -1, 0);
+}
+
 static __be32 get_client_locked(struct nfs4_client *clp)
 {
 	struct nfsd_net *nn = net_generic(clp->net, nfsd_net_id);
@@ -169,6 +176,7 @@ static __be32 get_client_locked(struct nfs4_client *clp)
 	if (is_client_expired(clp))
 		return nfserr_expired;
 	atomic_inc(&clp->cl_rpc_users);
+	nfsd4_dec_courtesy_client_count(nn, clp);
 	clp->cl_state = NFSD4_ACTIVE;
 	return nfs_ok;
 }
@@ -190,6 +198,7 @@ renew_client_locked(struct nfs4_client *clp)
 
 	list_move_tail(&clp->cl_lru, &nn->client_lru);
 	clp->cl_time = ktime_get_boottime_seconds();
+	nfsd4_dec_courtesy_client_count(nn, clp);
 	clp->cl_state = NFSD4_ACTIVE;
 }
 
@@ -2248,6 +2257,7 @@ __destroy_client(struct nfs4_client *clp)
 	if (clp->cl_cb_conn.cb_xprt)
 		svc_xprt_put(clp->cl_cb_conn.cb_xprt);
 	atomic_add_unless(&nn->nfs4_client_count, -1, 0);
+	nfsd4_dec_courtesy_client_count(nn, clp);
 	free_client(clp);
 	wake_up_all(&expiry_wq);
 }
@@ -4375,6 +4385,8 @@ void nfsd4_init_leases_net(struct nfsd_net *nn)
 	max_clients = (u64)si.totalram * si.mem_unit / (1024 * 1024 * 1024);
 	max_clients *= NFS4_CLIENTS_PER_GB;
 	nn->nfs4_max_clients = max_t(int, max_clients, NFS4_CLIENTS_PER_GB);
+
+	atomic_set(&nn->nfsd_courtesy_clients, 0);
 }
 
 static void init_nfs4_replay(struct nfs4_replay *rp)
@@ -5928,8 +5940,11 @@ nfs4_get_client_reaplist(struct nfsd_net *nn, struct list_head *reaplist,
 			goto exp_client;
 		if (!state_expired(lt, clp->cl_time))
 			break;
-		if (!atomic_read(&clp->cl_rpc_users))
+		if (!atomic_read(&clp->cl_rpc_users)) {
+			if (clp->cl_state == NFSD4_ACTIVE)
+				atomic_inc(&nn->nfsd_courtesy_clients);
 			clp->cl_state = NFSD4_COURTESY;
+		}
 		if (!client_has_state(clp))
 			goto exp_client;
 		if (!nfs4_anylock_blockers(clp))
-- 
2.43.0



