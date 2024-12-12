Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74BD231A23;
	Thu, 12 Dec 2024 16:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021705; cv=none; b=TN5wGcGA2Tn1srgdHzNEOUbatW5G+desJ+URyVH/heqi+PVdNGkDIdlKp8zSngftLENn5rCbqcodTIg7j7J+VFDGr1+0t7QxstG9wTse9xQmsGLzi6J1HTafvuPnYmcaYly3wOeALjaoC7eifzS00r4HlqCXY8MExVTFYbtpMgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021705; c=relaxed/simple;
	bh=81VKSHEz7BiFE+3WYC9DP6KA4hM4sOwqJWZZGLi23V8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3qimRncQ7iNJ3P/tBqS7Ae1fNWN1grLt1LyLc+V/R8DoRK0StKPRFJ34eByYRufApnoM0wfhV4AKEh1yC9D6WwdxElzQZD1lnNVwQ21Pd/mDoa9pgdcbIov6OkYS57mZvdTHDO9wHUBixpDB8hGfgzdCfTfcjkdjtQN90UG+gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tgF3UjJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tgF3UjJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9BCC4CECE;
	Thu, 12 Dec 2024 16:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021705;
	bh=81VKSHEz7BiFE+3WYC9DP6KA4hM4sOwqJWZZGLi23V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tgF3UjJro71uIF7Kyw+Q6SvZohO69u5PncRalToLBEUSgyUihHny1vrXWl1nKwQik
	 BQ44GIYkvAkGkOQcKW1XlFbLV6K12h6o7ZFW42GT2ztRoLCQEdRamo4rUQNwHFKhD7
	 YC/isRzc24ueoTup986+IE25Z/LABkirItMfA5rM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 040/565] NFSD: Async COPY result needs to return a write verifier
Date: Thu, 12 Dec 2024 15:53:55 +0100
Message-ID: <20241212144313.044618822@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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
[ cel: adjusted to apply to origin/linux-5.15.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |   23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -718,15 +718,6 @@ nfsd4_access(struct svc_rqst *rqstp, str
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
@@ -1594,7 +1585,6 @@ static void nfsd4_init_copy_res(struct n
 		test_bit(NFSD4_COPY_F_COMMITTED, &copy->cp_flags) ?
 			NFS_FILE_SYNC : NFS_UNSTABLE;
 	nfsd4_copy_set_sync(copy, sync);
-	gen_boot_verifier(&copy->cp_res.wr_verifier, copy->cp_clp->net);
 }
 
 static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy,
@@ -1765,9 +1755,14 @@ static __be32
 nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		union nfsd4_op_u *u)
 {
+	struct nfsd_net *nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
+	struct nfsd4_copy *async_copy = NULL;
 	struct nfsd4_copy *copy = &u->copy;
+	struct nfsd42_write_res *result;
 	__be32 status;
-	struct nfsd4_copy *async_copy = NULL;
+
+	result = &copy->cp_res;
+	nfsd_copy_write_verifier((__be32 *)&result->wr_verifier.data, nn);
 
 	copy->cp_clp = cstate->clp;
 	if (nfsd4_ssc_is_inter(copy)) {
@@ -1787,8 +1782,6 @@ nfsd4_copy(struct svc_rqst *rqstp, struc
 	memcpy(&copy->fh, &cstate->current_fh.fh_handle,
 		sizeof(struct knfsd_fh));
 	if (nfsd4_copy_is_async(copy)) {
-		struct nfsd_net *nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
-
 		status = nfserrno(-ENOMEM);
 		async_copy = kzalloc(sizeof(struct nfsd4_copy), GFP_KERNEL);
 		if (!async_copy)
@@ -1800,8 +1793,8 @@ nfsd4_copy(struct svc_rqst *rqstp, struc
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


