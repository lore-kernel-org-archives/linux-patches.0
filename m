Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178B379DAB;
	Wed, 21 Feb 2024 13:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522240; cv=none; b=B8t6X9Dx/gvUwhKnbzZDIsxqOznKSkB2Glklp1jqpjDoT2bwtPK9oUL4Ssndt7SRFXdbV+idPTIH0CVaQKVlZzHS2jJZlmdE03akVmemnuFXQJKTVjqX4cU3APV9p38ymAPXJa3rraX6vhnKofSnwGggwem99EaRnvC57VOTVeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522240; c=relaxed/simple;
	bh=k0R/tcwwtOV765S/c85wpXJb+dkiEj4wukWW8++bGdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EvwhlYdYtl2RFuxTJZY5sTGGmwGtM9W8FBkzSJpLceTQkOFLjGcJlVuN5hTD9hEvE3pWS3O4jom/O3usPYcSR/jb9zV2k365YCl5gNB4VzrT1l1kO88Ai39Z8ycq7FG4rtJ73M8XDDtZ9oVsFcFh+7U7XYzsfd3wpH5PLDdddzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UljU3jHX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UljU3jHX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBAFC433C7;
	Wed, 21 Feb 2024 13:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522240;
	bh=k0R/tcwwtOV765S/c85wpXJb+dkiEj4wukWW8++bGdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UljU3jHXYQ4Kv3Gs99LvPUPiElpW7LnfyISqiit8e6cKsr9OuI6hSHcwcXFxy8NwB
	 SMr+XoiOizwYe+58SzNc+IACS/luCb87ddRrZaklq9b2VOJuqE0S+NPETe+tFPQmFL
	 KTy38xsHTyWmR6pGPioirIJ9qUh+GD4V2xPNXTs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 111/476] NFSD: Modernize nfsd4_release_lockowner()
Date: Wed, 21 Feb 2024 14:02:42 +0100
Message-ID: <20240221130012.081046577@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit bd8fdb6e545f950f4654a9a10d7e819ad48146e5 ]

Refactor: Use existing helpers that other lock operations use. This
change removes several automatic variables, so re-organize the
variable declarations for readability.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: edcf9725150e ("nfsd: fix RELEASE_LOCKOWNER")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 36 +++++++++++-------------------------
 1 file changed, 11 insertions(+), 25 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 9b660491f393..798063b9b96f 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7290,16 +7290,13 @@ nfsd4_release_lockowner(struct svc_rqst *rqstp,
 			union nfsd4_op_u *u)
 {
 	struct nfsd4_release_lockowner *rlockowner = &u->release_lockowner;
+	struct nfsd_net *nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
 	clientid_t *clid = &rlockowner->rl_clientid;
-	struct nfs4_stateowner *sop;
-	struct nfs4_lockowner *lo = NULL;
 	struct nfs4_ol_stateid *stp;
-	struct xdr_netobj *owner = &rlockowner->rl_owner;
-	unsigned int hashval = ownerstr_hashval(owner);
-	__be32 status;
-	struct nfsd_net *nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
+	struct nfs4_lockowner *lo;
 	struct nfs4_client *clp;
-	LIST_HEAD (reaplist);
+	LIST_HEAD(reaplist);
+	__be32 status;
 
 	dprintk("nfsd4_release_lockowner clientid: (%08x/%08x):\n",
 		clid->cl_boot, clid->cl_id);
@@ -7307,30 +7304,19 @@ nfsd4_release_lockowner(struct svc_rqst *rqstp,
 	status = set_client(clid, cstate, nn);
 	if (status)
 		return status;
-
 	clp = cstate->clp;
-	/* Find the matching lock stateowner */
-	spin_lock(&clp->cl_lock);
-	list_for_each_entry(sop, &clp->cl_ownerstr_hashtbl[hashval],
-			    so_strhash) {
 
-		if (sop->so_is_open_owner || !same_owner_str(sop, owner))
-			continue;
-
-		if (atomic_read(&sop->so_count) != 1) {
-			spin_unlock(&clp->cl_lock);
-			return nfserr_locks_held;
-		}
-
-		lo = lockowner(sop);
-		nfs4_get_stateowner(sop);
-		break;
-	}
+	spin_lock(&clp->cl_lock);
+	lo = find_lockowner_str_locked(clp, &rlockowner->rl_owner);
 	if (!lo) {
 		spin_unlock(&clp->cl_lock);
 		return status;
 	}
-
+	if (atomic_read(&lo->lo_owner.so_count) != 2) {
+		spin_unlock(&clp->cl_lock);
+		nfs4_put_stateowner(&lo->lo_owner);
+		return nfserr_locks_held;
+	}
 	unhash_lockowner_locked(lo);
 	while (!list_empty(&lo->lo_owner.so_stateids)) {
 		stp = list_first_entry(&lo->lo_owner.so_stateids,
-- 
2.43.0



