Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7935A256C88;
	Tue, 11 Nov 2025 00:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822117; cv=none; b=L4u8uV8V0b5D/QjMN5ENpK5eTida4+jzabHk6lnxRGgDIwb1Hf60w4kirAeksbUnNBcm3lIzTESAGP+BF/vcM5B8u8AmpKE3IPsENeK+eCdVrgw23CP36TD/Tt0crlB6FtRRMvz4cok8xCP+dDX/mYylzEu7tzyX9IGr7CJ6u/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822117; c=relaxed/simple;
	bh=ITwVk2bMf3bWJRT1qtW/+mN4oXdjdYJRM4q6hMMSDeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twR4nDu0gu4OSWY15qTZ27nirmbTanUWXsoA7Z10YAACRl7WaREmDOD1UIkQwv523Dmyiaips8KJ3RizYZ+HFSBFR4kJhQVJmLoDWooz2P2YetwKfnxtCgGTJDBN0CI19bsg+DnTQWx70PjhaH8hxsJyAWsP4E0KVpj6D8sICtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nX5GgQKv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nX5GgQKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1685AC116B1;
	Tue, 11 Nov 2025 00:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822117;
	bh=ITwVk2bMf3bWJRT1qtW/+mN4oXdjdYJRM4q6hMMSDeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nX5GgQKvHfbWIAh1oP+wj+8kT3/ViikGewYCYX1TxJgzfTORjr972UCSfqs7ZqOFL
	 rqcv35mDigRCH9UnVaO+b8Gu0hxq1QqUY0Z7JqO0zSUt5OLBa8fj4mmzRPgFU5whw4
	 HQ8pupOJb91wWbDA4fSJIu/iV/G7lf/wtdLbYeJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	tianshuo han <hantianshuo233@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.17 005/849] Revert "NFSD: Remove the cap on number of operations per NFSv4 COMPOUND"
Date: Tue, 11 Nov 2025 09:32:55 +0900
Message-ID: <20251111004536.593564653@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit 3e7f011c255582d7c914133785bbba1990441713 upstream.

I've found that pynfs COMP6 now leaves the connection or lease in a
strange state, which causes CLOSE9 to hang indefinitely. I've dug
into it a little, but I haven't been able to root-cause it yet.
However, I bisected to commit 48aab1606fa8 ("NFSD: Remove the cap on
number of operations per NFSv4 COMPOUND").

Tianshuo Han also reports a potential vulnerability when decoding
an NFSv4 COMPOUND. An attacker can place an arbitrarily large op
count in the COMPOUND header, which results in:

[   51.410584] nfsd: vmalloc error: size 1209533382144, exceeds total
pages, mode:0xdc0(GFP_KERNEL|__GFP_ZERO),
nodemask=(null),cpuset=/,mems_allowed=0

when NFSD attempts to allocate the COMPOUND op array.

Let's restore the operation-per-COMPOUND limit, but increased to 200
for now.

Reported-by: tianshuo han <hantianshuo233@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Cc: stable@vger.kernel.org
Tested-by: Tianshuo Han <hantianshuo233@gmail.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c  |   14 ++++++++++++--
 fs/nfsd/nfs4state.c |    1 +
 fs/nfsd/nfs4xdr.c   |    4 +++-
 fs/nfsd/nfsd.h      |    3 +++
 fs/nfsd/xdr4.h      |    1 +
 5 files changed, 20 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -2859,10 +2859,20 @@ nfsd4_proc_compound(struct svc_rqst *rqs
 
 	rqstp->rq_lease_breaker = (void **)&cstate->clp;
 
-	trace_nfsd_compound(rqstp, args->tag, args->taglen, args->opcnt);
+	trace_nfsd_compound(rqstp, args->tag, args->taglen, args->client_opcnt);
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
@@ -2939,7 +2949,7 @@ encode_op:
 			status = op->status;
 		}
 
-		trace_nfsd_compound_status(args->opcnt, resp->opcnt,
+		trace_nfsd_compound_status(args->client_opcnt, resp->opcnt,
 					   status, nfsd4_op_name(op->opnum));
 
 		nfsd4_cstate_clear_replay(cstate);
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3865,6 +3865,7 @@ static __be32 check_forechannel_attrs(st
 	ca->headerpadsz = 0;
 	ca->maxreq_sz = min_t(u32, ca->maxreq_sz, maxrpc);
 	ca->maxresp_sz = min_t(u32, ca->maxresp_sz, maxrpc);
+	ca->maxops = min_t(u32, ca->maxops, NFSD_MAX_OPS_PER_COMPOUND);
 	ca->maxresp_cached = min_t(u32, ca->maxresp_cached,
 			NFSD_SLOT_CACHE_SIZE + NFSD_MIN_HDR_SEQ_SZ);
 	ca->maxreqs = min_t(u32, ca->maxreqs, NFSD_MAX_SLOTS_PER_SESSION);
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2488,8 +2488,10 @@ nfsd4_decode_compound(struct nfsd4_compo
 
 	if (xdr_stream_decode_u32(argp->xdr, &argp->minorversion) < 0)
 		return false;
-	if (xdr_stream_decode_u32(argp->xdr, &argp->opcnt) < 0)
+	if (xdr_stream_decode_u32(argp->xdr, &argp->client_opcnt) < 0)
 		return false;
+	argp->opcnt = min_t(u32, argp->client_opcnt,
+			    NFSD_MAX_OPS_PER_COMPOUND);
 
 	if (argp->opcnt > ARRAY_SIZE(argp->iops)) {
 		argp->ops = vcalloc(argp->opcnt, sizeof(*argp->ops));
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -57,6 +57,9 @@ struct readdir_cd {
 	__be32			err;	/* 0, nfserr, or nfserr_eof */
 };
 
+/* Maximum number of operations per session compound */
+#define NFSD_MAX_OPS_PER_COMPOUND	200
+
 struct nfsd_genl_rqstp {
 	struct sockaddr		rq_daddr;
 	struct sockaddr		rq_saddr;
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -903,6 +903,7 @@ struct nfsd4_compoundargs {
 	char *				tag;
 	u32				taglen;
 	u32				minorversion;
+	u32				client_opcnt;
 	u32				opcnt;
 	bool				splice_ok;
 	struct nfsd4_op			*ops;


