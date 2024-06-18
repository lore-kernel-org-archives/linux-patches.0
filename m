Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BE515FD0B;
	Tue, 18 Jun 2024 12:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715071; cv=none; b=cFSc5IY/TNU+O7NOtKvPvIHOjNh7mTzSxC2WdmztkEUBS3iwlESKEl0AceIK/7x77oVeLH1yvnz1PyYzIX0b38MDFlY3yx+AsSRnoQ190MjUySGoYTialbXS9X2lcDeCT0RS+ZahzMpvnrh586qacivU0+jl3ktRrnCWlXHASGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715071; c=relaxed/simple;
	bh=lPwB8TcEeIuvqCHUmrUNCPm1izIov4Vtk7EjsDXVKS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cizx+q+gcc5d0B22JzrwL38GkXQkeAtfEjefmPF5Jsn5NanPU1gOLSSiglzQZFDWCH6/M87TszlZky8giEIKob/7Fx4csT0m1QLdVej6Z91tXBUlmnI07m+oxqbQjG0OHbBmnpmBk6n04hZ+l9f0ORVznCLBJUrsOt5fu/mKu5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xd860zf1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xd860zf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32699C3277B;
	Tue, 18 Jun 2024 12:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715070;
	bh=lPwB8TcEeIuvqCHUmrUNCPm1izIov4Vtk7EjsDXVKS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xd860zf1xHNLkb7OMJMjtaWmB+d/8HPriU6KutWKqpJ1Tn7NgP1VMmhfRUAHJr3X+
	 gVbfHs+6pih5IyoC+ow+RV+rsmAbIsvNBAmV9HpClsK59b59zbOsJp5CBgX7ldAoxv
	 ziPjr+SuKSpKEbP4uKVxbNR9HOtTI4w9m7mcL+Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 185/770] nfsd: simplify nfsd4_check_open_reclaim
Date: Tue, 18 Jun 2024 14:30:38 +0200
Message-ID: <20240618123414.415967747@linuxfoundation.org>
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

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 1722b04624806ced51693f546edb83e8b2297a77 ]

The set_client() was already taken care of by process_open1().

The comments here are mostly redundant with the code.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c  |  3 +--
 fs/nfsd/nfs4state.c | 18 +++---------------
 fs/nfsd/state.h     |  3 +--
 3 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 4f64d94909ec1..5d304b51914a2 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -428,8 +428,7 @@ nfsd4_open(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 				goto out;
 			break;
 		case NFS4_OPEN_CLAIM_PREVIOUS:
-			status = nfs4_check_open_reclaim(&open->op_clientid,
-							 cstate, nn);
+			status = nfs4_check_open_reclaim(cstate->clp);
 			if (status)
 				goto out;
 			open->op_openowner->oo_flags |= NFS4_OO_CONFIRMED;
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index cbec87ee6bc0e..4da8467a3570d 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7248,25 +7248,13 @@ nfsd4_find_reclaim_client(struct xdr_netobj name, struct nfsd_net *nn)
 	return NULL;
 }
 
-/*
-* Called from OPEN. Look for clientid in reclaim list.
-*/
 __be32
-nfs4_check_open_reclaim(clientid_t *clid,
-		struct nfsd4_compound_state *cstate,
-		struct nfsd_net *nn)
+nfs4_check_open_reclaim(struct nfs4_client *clp)
 {
-	__be32 status;
-
-	/* find clientid in conf_id_hashtbl */
-	status = set_client(clid, cstate, nn);
-	if (status)
-		return nfserr_reclaim_bad;
-
-	if (test_bit(NFSD4_CLIENT_RECLAIM_COMPLETE, &cstate->clp->cl_flags))
+	if (test_bit(NFSD4_CLIENT_RECLAIM_COMPLETE, &clp->cl_flags))
 		return nfserr_no_grace;
 
-	if (nfsd4_client_record_check(cstate->clp))
+	if (nfsd4_client_record_check(clp))
 		return nfserr_reclaim_bad;
 
 	return nfs_ok;
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index 9eae11a9d21ca..73deea3531699 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -649,8 +649,7 @@ void nfs4_remove_reclaim_record(struct nfs4_client_reclaim *, struct nfsd_net *)
 extern void nfs4_release_reclaim(struct nfsd_net *);
 extern struct nfs4_client_reclaim *nfsd4_find_reclaim_client(struct xdr_netobj name,
 							struct nfsd_net *nn);
-extern __be32 nfs4_check_open_reclaim(clientid_t *clid,
-		struct nfsd4_compound_state *cstate, struct nfsd_net *nn);
+extern __be32 nfs4_check_open_reclaim(struct nfs4_client *);
 extern void nfsd4_probe_callback(struct nfs4_client *clp);
 extern void nfsd4_probe_callback_sync(struct nfs4_client *clp);
 extern void nfsd4_change_callback(struct nfs4_client *clp, struct nfs4_cb_conn *);
-- 
2.43.0



