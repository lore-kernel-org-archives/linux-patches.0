Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54819158DB3;
	Tue, 18 Jun 2024 13:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716414; cv=none; b=Ttb8uBZzCsiILuEJYwQzi5vmlgwhbmYd9VC6FvnkpSQ6t2WfjRGEs7hpL0P+pAVjGZHI4hi4hca6SbSebtJqaGnay7bViOOMM4Z52x9Deu+CgmyPbHqSE6DhbEDwUn6/8NTpzdh7/IEphaLsEZU2j0/+kElZkf4ceDzNdpGBBGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716414; c=relaxed/simple;
	bh=P8jcieAuHtub7m7OXhXeNdyjR8RtupS7kR1f0kgGVBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIyb/CGCBg9tmWKD85T8Cr9/wLKXusyALuWBFpRQYr/5qdySu7aVzAFJ8xNRGwS+cR2pZF/Ruitq8uCgz5FwFqiimJsqyL9g3uOo/VDnfDvgGZvOLqa5pt91/n9YACpkh6waiW2VEtNizhVLOfUjUaSSftLdvhHdAC/X2MX1sp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v3CeljUn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3CeljUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF27FC3277B;
	Tue, 18 Jun 2024 13:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716414;
	bh=P8jcieAuHtub7m7OXhXeNdyjR8RtupS7kR1f0kgGVBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v3CeljUnpml9wiVz0hzWMT7gHo+p1eZxVdeLIPt29Mzhk4pIHdqToZO/fO4VF2BnU
	 m297PG9AgT8ip78bPJVhNN2SJ6HCdkJ9AO3HZDFUWkbZ3JZ/q8fJcj4MiwdGHOBNAa
	 EJvYy9bvu6RO6zVpWKyzB/6r9UMJ+hN3+cNxDWIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bruce Fields <bfields@fieldses.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 638/770] NFSD: Fix handling of oversized NFSv4 COMPOUND requests
Date: Tue, 18 Jun 2024 14:38:11 +0200
Message-ID: <20240618123431.916267209@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 7518a3dc5ea249d4112156ce71b8b184eb786151 ]

If an NFS server returns NFS4ERR_RESOURCE on the first operation in
an NFSv4 COMPOUND, there's no way for a client to know where the
problem is and then simplify the compound to make forward progress.

So instead, make NFSD process as many operations in an oversized
COMPOUND as it can and then return NFS4ERR_RESOURCE on the first
operation it did not process.

pynfs NFSv4.0 COMP6 exercises this case, but checks only for the
COMPOUND status code, not whether the server has processed any
of the operations.

pynfs NFSv4.1 SEQ6 and SEQ7 exercise the NFSv4.1 case, which detects
too many operations per COMPOUND by checking against the limits
negotiated when the session was created.

Suggested-by: Bruce Fields <bfields@fieldses.org>
Fixes: 0078117c6d91 ("nfsd: return RESOURCE not GARBAGE_ARGS on too many ops")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 19 +++++++++++++------
 fs/nfsd/nfs4xdr.c  | 12 +++---------
 fs/nfsd/xdr4.h     |  3 ++-
 3 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 62ffcecf78f7e..c40795d1d98df 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -2623,9 +2623,6 @@ nfsd4_proc_compound(struct svc_rqst *rqstp)
 	status = nfserr_minor_vers_mismatch;
 	if (nfsd_minorversion(nn, args->minorversion, NFSD_TEST) <= 0)
 		goto out;
-	status = nfserr_resource;
-	if (args->opcnt > NFSD_MAX_OPS_PER_COMPOUND)
-		goto out;
 
 	status = nfs41_check_op_ordering(args);
 	if (status) {
@@ -2638,10 +2635,20 @@ nfsd4_proc_compound(struct svc_rqst *rqstp)
 
 	rqstp->rq_lease_breaker = (void **)&cstate->clp;
 
-	trace_nfsd_compound(rqstp, args->opcnt);
+	trace_nfsd_compound(rqstp, args->client_opcnt);
 	while (!status && resp->opcnt < args->opcnt) {
 		op = &args->ops[resp->opcnt++];
 
+		if (unlikely(resp->opcnt == NFSD_MAX_OPS_PER_COMPOUND)) {
+			/* If there are still more operations to process,
+			 * stop here and report NFS4ERR_RESOURCE. */
+			if (cstate->minorversion == 0 &&
+			    args->client_opcnt > resp->opcnt) {
+				op->status = nfserr_resource;
+				goto encode_op;
+			}
+		}
+
 		/*
 		 * The XDR decode routines may have pre-set op->status;
 		 * for example, if there is a miscellaneous XDR error
@@ -2717,8 +2724,8 @@ nfsd4_proc_compound(struct svc_rqst *rqstp)
 			status = op->status;
 		}
 
-		trace_nfsd_compound_status(args->opcnt, resp->opcnt, status,
-					   nfsd4_op_name(op->opnum));
+		trace_nfsd_compound_status(args->client_opcnt, resp->opcnt,
+					   status, nfsd4_op_name(op->opnum));
 
 		nfsd4_cstate_clear_replay(cstate);
 		nfsd4_increment_op_stats(op->opnum);
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 92e0535ddb922..b9398b7b3539a 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2359,16 +2359,10 @@ nfsd4_decode_compound(struct nfsd4_compoundargs *argp)
 
 	if (xdr_stream_decode_u32(argp->xdr, &argp->minorversion) < 0)
 		return false;
-	if (xdr_stream_decode_u32(argp->xdr, &argp->opcnt) < 0)
+	if (xdr_stream_decode_u32(argp->xdr, &argp->client_opcnt) < 0)
 		return false;
-
-	/*
-	 * NFS4ERR_RESOURCE is a more helpful error than GARBAGE_ARGS
-	 * here, so we return success at the xdr level so that
-	 * nfsd4_proc can handle this is an NFS-level error.
-	 */
-	if (argp->opcnt > NFSD_MAX_OPS_PER_COMPOUND)
-		return true;
+	argp->opcnt = min_t(u32, argp->client_opcnt,
+			    NFSD_MAX_OPS_PER_COMPOUND);
 
 	if (argp->opcnt > ARRAY_SIZE(argp->iops)) {
 		argp->ops = vcalloc(argp->opcnt, sizeof(*argp->ops));
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index 14b87141de343..2a699e8ca1baf 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -717,9 +717,10 @@ struct nfsd4_compoundargs {
 	struct svcxdr_tmpbuf		*to_free;
 	struct svc_rqst			*rqstp;
 
-	u32				taglen;
 	char *				tag;
+	u32				taglen;
 	u32				minorversion;
+	u32				client_opcnt;
 	u32				opcnt;
 	struct nfsd4_op			*ops;
 	struct nfsd4_op			iops[8];
-- 
2.43.0



