Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8571DA60C;
	Tue,  8 Oct 2024 12:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391002; cv=none; b=Ced9KPS/bF+o0xVUw19RrZ4kNcrTMnza2wNHnnlXAksRAMOaK2m/DoGpV9ZfwxklTWlVotNfKBkxnhxqFN+zr+5M0VqFLnNgsbWVr9kKzt7UC0dvGKmfKNeF/bAIhBU1SbsEli7/M/1Ddod4pxWo9GzWE7JxASWXjfHzoUtXdq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391002; c=relaxed/simple;
	bh=o2foW+hte8pAfblKBAD7Y9awikx5j1W2pgA2+PHmSkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZlYPrciuLgBxo8Vl+bJT9Z/gfIjGde0Jp27kJCe/RJqPiC/4A1NqIHz0cM/69i74JOweSCMoGCKJPrC0vzoX5ZhdrmNRZOkiieUx/gzMypKnin+Miqn66pY0u8i0ksa81h6ls0y/gUY7ag5o/5hrs0gsHNPwpAz8D5EwU3VKFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZPGe1h3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZPGe1h3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6C4C4CEC7;
	Tue,  8 Oct 2024 12:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391001;
	bh=o2foW+hte8pAfblKBAD7Y9awikx5j1W2pgA2+PHmSkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZPGe1h3fr7ZokLRUUt0BnaZY+mK5+aiG05NlCodSNHIZUYugmbN7C8vfP1lJnUsh
	 4ZcpHilgC3nMTo+1mBqXeVDAuMxAfzwTUMInldbv1zBc1GU14aW7re0M+veYUeaBaT
	 XBmpg5/Fdo7bCCuHjg587rv+jySVYWjrE8hJd4oE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 459/482] NFSD: Async COPY result needs to return a write verifier
Date: Tue,  8 Oct 2024 14:08:42 +0200
Message-ID: <20241008115706.578307425@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 9ed666eba4e0a2bb8ffaa3739d830b64d4f2aaad ]

Currently, when NFSD handles an asynchronous COPY, it returns a
zero write verifier, relying on the subsequent CB_OFFLOAD callback
to pass the write verifier and a stable_how4 value to the client.

However, if the CB_OFFLOAD never arrives at the client (for example,
if a network partition occurs just as the server sends the
CB_OFFLOAD operation), the client will never receive this verifier.
Thus, if the client sends a follow-up COMMIT, there is no way for
the client to assess the COMMIT result.

The usual recovery for a missing CB_OFFLOAD is for the client to
send an OFFLOAD_STATUS operation, but that operation does not carry
a write verifier in its result. Neither does it carry a stable_how4
value, so the client /must/ send a COMMIT in this case -- which will
always fail because currently there's still no write verifier in the
COPY result.

Thus the server needs to return a normal write verifier in its COPY
result even if the COPY operation is to be performed asynchronously.

If the server recognizes the callback stateid in subsequent
OFFLOAD_STATUS operations, then obviously it has not restarted, and
the write verifier the client received in the COPY result is still
valid and can be used to assess a COMMIT of the copied data, if one
is needed.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: aadc3bbea163 ("NFSD: Limit the number of concurrent async COPY operations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 2e39cf2e502a3..60c526adc27c6 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -751,15 +751,6 @@ nfsd4_access(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 			   &access->ac_supported);
 }
 
-static void gen_boot_verifier(nfs4_verifier *verifier, struct net *net)
-{
-	__be32 *verf = (__be32 *)verifier->data;
-
-	BUILD_BUG_ON(2*sizeof(*verf) != sizeof(verifier->data));
-
-	nfsd_copy_write_verifier(verf, net_generic(net, nfsd_net_id));
-}
-
 static __be32
 nfsd4_commit(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	     union nfsd4_op_u *u)
@@ -1630,7 +1621,6 @@ static void nfsd4_init_copy_res(struct nfsd4_copy *copy, bool sync)
 		test_bit(NFSD4_COPY_F_COMMITTED, &copy->cp_flags) ?
 			NFS_FILE_SYNC : NFS_UNSTABLE;
 	nfsd4_copy_set_sync(copy, sync);
-	gen_boot_verifier(&copy->cp_res.wr_verifier, copy->cp_clp->net);
 }
 
 static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy,
@@ -1803,9 +1793,11 @@ static __be32
 nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		union nfsd4_op_u *u)
 {
+	struct nfsd_net *nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
+	struct nfsd4_copy *async_copy = NULL;
 	struct nfsd4_copy *copy = &u->copy;
+	struct nfsd42_write_res *result;
 	__be32 status;
-	struct nfsd4_copy *async_copy = NULL;
 
 	/*
 	 * Currently, async COPY is not reliable. Force all COPY
@@ -1814,6 +1806,9 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	 */
 	nfsd4_copy_set_sync(copy, true);
 
+	result = &copy->cp_res;
+	nfsd_copy_write_verifier((__be32 *)&result->wr_verifier.data, nn);
+
 	copy->cp_clp = cstate->clp;
 	if (nfsd4_ssc_is_inter(copy)) {
 		trace_nfsd_copy_inter(copy);
@@ -1838,8 +1833,6 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	memcpy(&copy->fh, &cstate->current_fh.fh_handle,
 		sizeof(struct knfsd_fh));
 	if (nfsd4_copy_is_async(copy)) {
-		struct nfsd_net *nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
-
 		status = nfserrno(-ENOMEM);
 		async_copy = kzalloc(sizeof(struct nfsd4_copy), GFP_KERNEL);
 		if (!async_copy)
@@ -1851,8 +1844,8 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 			goto out_err;
 		if (!nfs4_init_copy_state(nn, copy))
 			goto out_err;
-		memcpy(&copy->cp_res.cb_stateid, &copy->cp_stateid.cs_stid,
-			sizeof(copy->cp_res.cb_stateid));
+		memcpy(&result->cb_stateid, &copy->cp_stateid.cs_stid,
+			sizeof(result->cb_stateid));
 		dup_copy_fields(copy, async_copy);
 		async_copy->copy_task = kthread_create(nfsd4_do_async_copy,
 				async_copy, "%s", "copy thread");
-- 
2.43.0



