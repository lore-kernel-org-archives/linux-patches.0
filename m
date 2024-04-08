Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D8E7F498;
	Mon,  8 Apr 2024 13:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584656; cv=none; b=Oxua/4fWxBdR9QbgWLF2P9hehny2AfO81cxhoKww3Aefo3XfTQg22QG/rWN7OXv+Oa5+GVJ26rzJ8wN3Tf+VrpLOSMXoEZYqbD0PLKfOYxPMknCJgto2VnLY/apQ9og/mtPQBMICgSeNZyvCg0MDysN1QgCJ6sG7bSekERlUWlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584656; c=relaxed/simple;
	bh=4pZowBof0YkJ4HnDQSFMC0sa3qhSGyFmChrU+jD7/Y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZ+ctXAiYxW7j9J00UPwP3u2QwB4P8+3w1Bnd8zmEOSoihoy42QZlVKqvedPpU/DGvGU6W/bjmsLPxq5Ho4RMbMpNt+VcQSxpt9hfvR9K9iL2vUeJxEtZ9esjXdC+kFBpwRG7JHaG3qZbE9YBaISN+2LC+GzrDb/svvdjjKgVbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uD/oyj/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uD/oyj/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3CEC43390;
	Mon,  8 Apr 2024 13:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584656;
	bh=4pZowBof0YkJ4HnDQSFMC0sa3qhSGyFmChrU+jD7/Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uD/oyj/B6QEHmyZ/jwiz1XaC0PJIfrRGEIGBTZF0f1/fxzTdSVNB9L1F5y3jb7SK+
	 MatNiR9n1tJTWOCPhxt99KCi+sLEmlB1qeFg7ybxeSC3n1cb2aCBk62wcZFX5YFmkQ
	 7WPrjb8jxBtqAb9XgByZy2+D0PTdn+Lqp/0EP2/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 511/690] Revert "SUNRPC: Use RMW bitops in single-threaded hot paths"
Date: Mon,  8 Apr 2024 14:56:17 +0200
Message-ID: <20240408125418.163593205@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 7827c81f0248e3c2f40d438b020f3d222f002171 ]

The premise that "Once an svc thread is scheduled and executing an
RPC, no other processes will touch svc_rqst::rq_flags" is false.
svc_xprt_enqueue() examines the RQ_BUSY flag in scheduled nfsd
threads when determining which thread to wake up next.

Found via KCSAN.

Fixes: 28df0988815f ("SUNRPC: Use RMW bitops in single-threaded hot paths")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4proc.c                       | 7 +++----
 fs/nfsd/nfs4xdr.c                        | 2 +-
 net/sunrpc/auth_gss/svcauth_gss.c        | 4 ++--
 net/sunrpc/svc.c                         | 6 +++---
 net/sunrpc/svc_xprt.c                    | 2 +-
 net/sunrpc/svcsock.c                     | 8 ++++----
 net/sunrpc/xprtrdma/svc_rdma_transport.c | 2 +-
 7 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index eeff0ba0be558..5ea71af276c7b 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -937,7 +937,7 @@ nfsd4_read(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	 * the client wants us to do more in this compound:
 	 */
 	if (!nfsd4_last_compound_op(rqstp))
-		__clear_bit(RQ_SPLICE_OK, &rqstp->rq_flags);
+		clear_bit(RQ_SPLICE_OK, &rqstp->rq_flags);
 
 	/* check stateid */
 	status = nfs4_preprocess_stateid_op(rqstp, cstate, &cstate->current_fh,
@@ -2610,12 +2610,11 @@ nfsd4_proc_compound(struct svc_rqst *rqstp)
 	cstate->minorversion = args->minorversion;
 	fh_init(current_fh, NFS4_FHSIZE);
 	fh_init(save_fh, NFS4_FHSIZE);
-
 	/*
 	 * Don't use the deferral mechanism for NFSv4; compounds make it
 	 * too hard to avoid non-idempotency problems.
 	 */
-	__clear_bit(RQ_USEDEFERRAL, &rqstp->rq_flags);
+	clear_bit(RQ_USEDEFERRAL, &rqstp->rq_flags);
 
 	/*
 	 * According to RFC3010, this takes precedence over all other errors.
@@ -2737,7 +2736,7 @@ nfsd4_proc_compound(struct svc_rqst *rqstp)
 out:
 	cstate->status = status;
 	/* Reset deferral mechanism for RPC deferrals */
-	__set_bit(RQ_USEDEFERRAL, &rqstp->rq_flags);
+	set_bit(RQ_USEDEFERRAL, &rqstp->rq_flags);
 	return rpc_success;
 }
 
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 30e085f1e4797..9c9ff3bdc62a9 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2526,7 +2526,7 @@ nfsd4_decode_compound(struct nfsd4_compoundargs *argp)
 	argp->rqstp->rq_cachetype = cachethis ? RC_REPLBUFF : RC_NOCACHE;
 
 	if (readcount > 1 || max_reply > PAGE_SIZE - auth_slack)
-		__clear_bit(RQ_SPLICE_OK, &argp->rqstp->rq_flags);
+		clear_bit(RQ_SPLICE_OK, &argp->rqstp->rq_flags);
 
 	return true;
 }
diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 2381c5d1b0710..48b608cb5f5ec 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -900,7 +900,7 @@ unwrap_integ_data(struct svc_rqst *rqstp, struct xdr_buf *buf, u32 seq, struct g
 	 * rejecting the server-computed MIC in this somewhat rare case,
 	 * do not use splice with the GSS integrity service.
 	 */
-	__clear_bit(RQ_SPLICE_OK, &rqstp->rq_flags);
+	clear_bit(RQ_SPLICE_OK, &rqstp->rq_flags);
 
 	/* Did we already verify the signature on the original pass through? */
 	if (rqstp->rq_deferred)
@@ -972,7 +972,7 @@ unwrap_priv_data(struct svc_rqst *rqstp, struct xdr_buf *buf, u32 seq, struct gs
 	int pad, remaining_len, offset;
 	u32 rseqno;
 
-	__clear_bit(RQ_SPLICE_OK, &rqstp->rq_flags);
+	clear_bit(RQ_SPLICE_OK, &rqstp->rq_flags);
 
 	priv_len = svc_getnl(&buf->head[0]);
 	if (rqstp->rq_deferred) {
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 86f00019d0ebb..9177b243a949d 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1281,10 +1281,10 @@ svc_process_common(struct svc_rqst *rqstp, struct kvec *argv, struct kvec *resv)
 		goto err_short_len;
 
 	/* Will be turned off by GSS integrity and privacy services */
-	__set_bit(RQ_SPLICE_OK, &rqstp->rq_flags);
+	set_bit(RQ_SPLICE_OK, &rqstp->rq_flags);
 	/* Will be turned off only when NFSv4 Sessions are used */
-	__set_bit(RQ_USEDEFERRAL, &rqstp->rq_flags);
-	__clear_bit(RQ_DROPME, &rqstp->rq_flags);
+	set_bit(RQ_USEDEFERRAL, &rqstp->rq_flags);
+	clear_bit(RQ_DROPME, &rqstp->rq_flags);
 
 	svc_putu32(resv, rqstp->rq_xid);
 
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 39acef5134f5c..67ccf1a6459ae 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -1251,7 +1251,7 @@ static struct cache_deferred_req *svc_defer(struct cache_req *req)
 	trace_svc_defer(rqstp);
 	svc_xprt_get(rqstp->rq_xprt);
 	dr->xprt = rqstp->rq_xprt;
-	__set_bit(RQ_DROPME, &rqstp->rq_flags);
+	set_bit(RQ_DROPME, &rqstp->rq_flags);
 
 	dr->handle.revisit = svc_revisit;
 	return &dr->handle;
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 46cea0e413aeb..be7081284a098 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -298,9 +298,9 @@ static void svc_sock_setbufsize(struct svc_sock *svsk, unsigned int nreqs)
 static void svc_sock_secure_port(struct svc_rqst *rqstp)
 {
 	if (svc_port_is_privileged(svc_addr(rqstp)))
-		__set_bit(RQ_SECURE, &rqstp->rq_flags);
+		set_bit(RQ_SECURE, &rqstp->rq_flags);
 	else
-		__clear_bit(RQ_SECURE, &rqstp->rq_flags);
+		clear_bit(RQ_SECURE, &rqstp->rq_flags);
 }
 
 /*
@@ -1005,9 +1005,9 @@ static int svc_tcp_recvfrom(struct svc_rqst *rqstp)
 	rqstp->rq_xprt_ctxt   = NULL;
 	rqstp->rq_prot	      = IPPROTO_TCP;
 	if (test_bit(XPT_LOCAL, &svsk->sk_xprt.xpt_flags))
-		__set_bit(RQ_LOCAL, &rqstp->rq_flags);
+		set_bit(RQ_LOCAL, &rqstp->rq_flags);
 	else
-		__clear_bit(RQ_LOCAL, &rqstp->rq_flags);
+		clear_bit(RQ_LOCAL, &rqstp->rq_flags);
 
 	p = (__be32 *)rqstp->rq_arg.head[0].iov_base;
 	calldir = p[1];
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index ac147304fb0e9..f776f0cb471f0 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -602,7 +602,7 @@ static int svc_rdma_has_wspace(struct svc_xprt *xprt)
 
 static void svc_rdma_secure_port(struct svc_rqst *rqstp)
 {
-	__set_bit(RQ_SECURE, &rqstp->rq_flags);
+	set_bit(RQ_SECURE, &rqstp->rq_flags);
 }
 
 static void svc_rdma_kill_temp_xprt(struct svc_xprt *xprt)
-- 
2.43.0



