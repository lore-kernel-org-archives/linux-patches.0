Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEEB160790;
	Tue, 18 Jun 2024 12:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715073; cv=none; b=CaWXaLfDlLzRIW7Rlsv0hu9aqKSNdOYQMVTJXFG6+EdVsIPinHYS466x+/d/6LZHRYpgqHwVpnEILZ9bzsqjREe75nRRMjgG6jV9qPDR0uGrKAkBkcgHMlo0bjdWTh/Oa1+oC5g3qVty4vZgWhM2Gu2ClC1QjQ3r2HCjb6JHFS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715073; c=relaxed/simple;
	bh=rMWiJkn1a0dU+PSlnInNZtPuAQP4+/QDKnnuVJzDoEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjnUk2Aull3QpOu+o+LUfXPnOisD2MhLET+LHpQIa/2AK/QOARdHVDIZOc+2FUK2Jbnf1C2XEzk8ZpKZebLHqoBselvYIFsGnwND1yaanfB2a3YHLVTe7JbpnzJNggPKYi8aktwEVdaXkH2ddCgd8m/d3OE2z1CdmFq0d7fU4pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qO9y+eTm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qO9y+eTm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F98C3277B;
	Tue, 18 Jun 2024 12:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715073;
	bh=rMWiJkn1a0dU+PSlnInNZtPuAQP4+/QDKnnuVJzDoEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qO9y+eTmEXQz6tIepMGMZFQLt5M1YX/8u5sIIKPSdOrAXeE7PG6YeWtrkaHPhtTQf
	 J/E4IICGtD6juSY4NuUu9SD5pMb3EQSgOp3jI9MR1uIMRoNJCcpRJu46oymjJIlL+3
	 qVBBzwvx/Uo7oSgL4pT35NoLvc8FhRgOf0sjIboE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 186/770] nfsd: cstate->session->se_client -> cstate->clp
Date: Tue, 18 Jun 2024 14:30:39 +0200
Message-ID: <20240618123414.454515389@linuxfoundation.org>
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

[ Upstream commit ec59659b4972ec25851aa03b4b5baba6764a62e4 ]

I'm not sure why we're writing this out the hard way in so many places.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c  |  5 ++---
 fs/nfsd/nfs4state.c | 16 ++++++++--------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 5d304b51914a2..0acf7af9aab8f 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -378,8 +378,7 @@ nfsd4_open(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	 * Before RECLAIM_COMPLETE done, server should deny new lock
 	 */
 	if (nfsd4_has_session(cstate) &&
-	    !test_bit(NFSD4_CLIENT_RECLAIM_COMPLETE,
-		      &cstate->session->se_client->cl_flags) &&
+	    !test_bit(NFSD4_CLIENT_RECLAIM_COMPLETE, &cstate->clp->cl_flags) &&
 	    open->op_claim_type != NFS4_OPEN_CLAIM_PREVIOUS)
 		return nfserr_grace;
 
@@ -1881,7 +1880,7 @@ nfsd4_getdeviceinfo(struct svc_rqst *rqstp,
 	nfserr = nfs_ok;
 	if (gdp->gd_maxcount != 0) {
 		nfserr = ops->proc_getdeviceinfo(exp->ex_path.mnt->mnt_sb,
-				rqstp, cstate->session->se_client, gdp);
+				rqstp, cstate->clp, gdp);
 	}
 
 	gdp->gd_notify_types &= ops->notify_types;
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 4da8467a3570d..c2eba93ab5138 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3923,6 +3923,7 @@ nfsd4_reclaim_complete(struct svc_rqst *rqstp,
 		struct nfsd4_compound_state *cstate, union nfsd4_op_u *u)
 {
 	struct nfsd4_reclaim_complete *rc = &u->reclaim_complete;
+	struct nfs4_client *clp = cstate->clp;
 	__be32 status = 0;
 
 	if (rc->rca_one_fs) {
@@ -3936,12 +3937,11 @@ nfsd4_reclaim_complete(struct svc_rqst *rqstp,
 	}
 
 	status = nfserr_complete_already;
-	if (test_and_set_bit(NFSD4_CLIENT_RECLAIM_COMPLETE,
-			     &cstate->session->se_client->cl_flags))
+	if (test_and_set_bit(NFSD4_CLIENT_RECLAIM_COMPLETE, &clp->cl_flags))
 		goto out;
 
 	status = nfserr_stale_clientid;
-	if (is_client_expired(cstate->session->se_client))
+	if (is_client_expired(clp))
 		/*
 		 * The following error isn't really legal.
 		 * But we only get here if the client just explicitly
@@ -3952,8 +3952,8 @@ nfsd4_reclaim_complete(struct svc_rqst *rqstp,
 		goto out;
 
 	status = nfs_ok;
-	nfsd4_client_record_create(cstate->session->se_client);
-	inc_reclaim_complete(cstate->session->se_client);
+	nfsd4_client_record_create(clp);
+	inc_reclaim_complete(clp);
 out:
 	return status;
 }
@@ -5938,7 +5938,7 @@ nfsd4_test_stateid(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 {
 	struct nfsd4_test_stateid *test_stateid = &u->test_stateid;
 	struct nfsd4_test_stateid_id *stateid;
-	struct nfs4_client *cl = cstate->session->se_client;
+	struct nfs4_client *cl = cstate->clp;
 
 	list_for_each_entry(stateid, &test_stateid->ts_stateid_list, ts_id_list)
 		stateid->ts_id_status =
@@ -5984,7 +5984,7 @@ nfsd4_free_stateid(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	stateid_t *stateid = &free_stateid->fr_stateid;
 	struct nfs4_stid *s;
 	struct nfs4_delegation *dp;
-	struct nfs4_client *cl = cstate->session->se_client;
+	struct nfs4_client *cl = cstate->clp;
 	__be32 ret = nfserr_bad_stateid;
 
 	spin_lock(&cl->cl_lock);
@@ -6716,7 +6716,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		if (nfsd4_has_session(cstate))
 			/* See rfc 5661 18.10.3: given clientid is ignored: */
 			memcpy(&lock->lk_new_clientid,
-				&cstate->session->se_client->cl_clientid,
+				&cstate->clp->cl_clientid,
 				sizeof(clientid_t));
 
 		/* validate and update open stateid and open seqid */
-- 
2.43.0



