Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5477613BC35;
	Tue, 18 Jun 2024 12:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715568; cv=none; b=OhHVT9IawX3lZ9bRgBFAOIDHLuu42CiuDmxkfiRyQ3qRgkwINGOsL+R/swel5KK8CUWsoD5RRP/9tdufzDK5tFQHzBLYA1vAQmxvNvoQTEB4E8/D+pnh0xfoyvgeJv9Ut17CPMNjGN8ZcbizbDx2bOFNnI7TdphZmUqhYWXawNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715568; c=relaxed/simple;
	bh=YAbcrsZNCr/wVnZMv6nwHVe9WI3mgH6lwwrlwZg4qeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/gDN089twm7ssiVF/n+1XrV5jZpxgElyF/1YTpgTtSe8ZUW8AsJGyDcy+uBLmjmvGzmRXpwQlWuWkIHYDn1t4cUTQAD/UX3YW67u6cOEWXz2Rcil/2nNOP1c8Xo0zOuAejfY+fPytU+tVV1TzCY039XmOzGv11U14ba0HVBi/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hzxht1JK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hzxht1JK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7A0C3277B;
	Tue, 18 Jun 2024 12:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715568;
	bh=YAbcrsZNCr/wVnZMv6nwHVe9WI3mgH6lwwrlwZg4qeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hzxht1JKybqsKPpR15pm9rV2a0AxToTXESUviSXdIlphPTfU6JZCntXF4yVLKQZN/
	 eagN834ovhgqhUwzlUOspk6zvxA9QDECphxsIVvAvDey7+aRGwvIMKjwqw9GB0h0P0
	 U41WdRjaZyQpty1DtFS1T3WjdokFEjVEtSoT5VW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 353/770] SUNRPC: Add svc_rqst::rq_auth_stat
Date: Tue, 18 Jun 2024 14:33:26 +0200
Message-ID: <20240618123420.895407881@linuxfoundation.org>
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

[ Upstream commit 438623a06bacd69c40c4af633bb09a3bbb9dfc78 ]

I'd like to take commit 4532608d71c8 ("SUNRPC: Clean up generic
dispatcher code") even further by using only private local SVC
dispatchers for all kernel RPC services. This change would enable
the removal of the logic that switches between
svc_generic_dispatch() and a service's private dispatcher, and
simplify the invocation of the service's pc_release method
so that humans can visually verify that it is always invoked
properly.

All that will come later.

First, let's provide a better way to return authentication errors
from SVC dispatcher functions. Instead of overloading the dispatch
method's *statp argument, add a field to struct svc_rqst that can
hold an error value.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/svc.h        |  1 +
 include/linux/sunrpc/svcauth.h    |  4 +--
 include/trace/events/sunrpc.h     |  6 ++---
 net/sunrpc/auth_gss/svcauth_gss.c | 43 +++++++++++++++----------------
 net/sunrpc/svc.c                  | 17 ++++++------
 net/sunrpc/svcauth.c              |  8 +++---
 net/sunrpc/svcauth_unix.c         | 12 ++++-----
 7 files changed, 46 insertions(+), 45 deletions(-)

diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index ab9afbf0a0d8b..7b7bd8a0a6fbd 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -284,6 +284,7 @@ struct svc_rqst {
 	void *			rq_argp;	/* decoded arguments */
 	void *			rq_resp;	/* xdr'd results */
 	void *			rq_auth_data;	/* flavor-specific data */
+	__be32			rq_auth_stat;	/* authentication status */
 	int			rq_auth_slack;	/* extra space xdr code
 						 * should leave in head
 						 * for krb5i, krb5p.
diff --git a/include/linux/sunrpc/svcauth.h b/include/linux/sunrpc/svcauth.h
index b0003866a2497..6d9cc9080aca7 100644
--- a/include/linux/sunrpc/svcauth.h
+++ b/include/linux/sunrpc/svcauth.h
@@ -127,7 +127,7 @@ struct auth_ops {
 	char *	name;
 	struct module *owner;
 	int	flavour;
-	int	(*accept)(struct svc_rqst *rq, __be32 *authp);
+	int	(*accept)(struct svc_rqst *rq);
 	int	(*release)(struct svc_rqst *rq);
 	void	(*domain_release)(struct auth_domain *);
 	int	(*set_client)(struct svc_rqst *rq);
@@ -149,7 +149,7 @@ struct auth_ops {
 
 struct svc_xprt;
 
-extern int	svc_authenticate(struct svc_rqst *rqstp, __be32 *authp);
+extern int	svc_authenticate(struct svc_rqst *rqstp);
 extern int	svc_authorise(struct svc_rqst *rqstp);
 extern int	svc_set_client(struct svc_rqst *rqstp);
 extern int	svc_auth_register(rpc_authflavor_t flavor, struct auth_ops *aops);
diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index 657138ab1f91f..0cb9e182a1b1e 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -1547,9 +1547,9 @@ TRACE_DEFINE_ENUM(SVC_COMPLETE);
 		{ SVC_COMPLETE,	"SVC_COMPLETE" })
 
 TRACE_EVENT(svc_authenticate,
-	TP_PROTO(const struct svc_rqst *rqst, int auth_res, __be32 auth_stat),
+	TP_PROTO(const struct svc_rqst *rqst, int auth_res),
 
-	TP_ARGS(rqst, auth_res, auth_stat),
+	TP_ARGS(rqst, auth_res),
 
 	TP_STRUCT__entry(
 		__field(u32, xid)
@@ -1560,7 +1560,7 @@ TRACE_EVENT(svc_authenticate,
 	TP_fast_assign(
 		__entry->xid = be32_to_cpu(rqst->rq_xid);
 		__entry->svc_status = auth_res;
-		__entry->auth_stat = be32_to_cpu(auth_stat);
+		__entry->auth_stat = be32_to_cpu(rqst->rq_auth_stat);
 	),
 
 	TP_printk("xid=0x%08x auth_res=%s auth_stat=%s",
diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 784c8b24f1640..54303b7efde76 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -707,11 +707,11 @@ svc_safe_putnetobj(struct kvec *resv, struct xdr_netobj *o)
 /*
  * Verify the checksum on the header and return SVC_OK on success.
  * Otherwise, return SVC_DROP (in the case of a bad sequence number)
- * or return SVC_DENIED and indicate error in authp.
+ * or return SVC_DENIED and indicate error in rqstp->rq_auth_stat.
  */
 static int
 gss_verify_header(struct svc_rqst *rqstp, struct rsc *rsci,
-		  __be32 *rpcstart, struct rpc_gss_wire_cred *gc, __be32 *authp)
+		  __be32 *rpcstart, struct rpc_gss_wire_cred *gc)
 {
 	struct gss_ctx		*ctx_id = rsci->mechctx;
 	struct xdr_buf		rpchdr;
@@ -725,7 +725,7 @@ gss_verify_header(struct svc_rqst *rqstp, struct rsc *rsci,
 	iov.iov_len = (u8 *)argv->iov_base - (u8 *)rpcstart;
 	xdr_buf_from_iov(&iov, &rpchdr);
 
-	*authp = rpc_autherr_badverf;
+	rqstp->rq_auth_stat = rpc_autherr_badverf;
 	if (argv->iov_len < 4)
 		return SVC_DENIED;
 	flavor = svc_getnl(argv);
@@ -737,13 +737,13 @@ gss_verify_header(struct svc_rqst *rqstp, struct rsc *rsci,
 	if (rqstp->rq_deferred) /* skip verification of revisited request */
 		return SVC_OK;
 	if (gss_verify_mic(ctx_id, &rpchdr, &checksum) != GSS_S_COMPLETE) {
-		*authp = rpcsec_gsserr_credproblem;
+		rqstp->rq_auth_stat = rpcsec_gsserr_credproblem;
 		return SVC_DENIED;
 	}
 
 	if (gc->gc_seq > MAXSEQ) {
 		trace_rpcgss_svc_seqno_large(rqstp, gc->gc_seq);
-		*authp = rpcsec_gsserr_ctxproblem;
+		rqstp->rq_auth_stat = rpcsec_gsserr_ctxproblem;
 		return SVC_DENIED;
 	}
 	if (!gss_check_seq_num(rqstp, rsci, gc->gc_seq))
@@ -1136,7 +1136,7 @@ static void gss_free_in_token_pages(struct gssp_in_token *in_token)
 }
 
 static int gss_read_proxy_verf(struct svc_rqst *rqstp,
-			       struct rpc_gss_wire_cred *gc, __be32 *authp,
+			       struct rpc_gss_wire_cred *gc,
 			       struct xdr_netobj *in_handle,
 			       struct gssp_in_token *in_token)
 {
@@ -1145,7 +1145,7 @@ static int gss_read_proxy_verf(struct svc_rqst *rqstp,
 	int pages, i, res, pgto, pgfrom;
 	size_t inlen, to_offs, from_offs;
 
-	res = gss_read_common_verf(gc, argv, authp, in_handle);
+	res = gss_read_common_verf(gc, argv, &rqstp->rq_auth_stat, in_handle);
 	if (res)
 		return res;
 
@@ -1226,7 +1226,7 @@ gss_write_resv(struct kvec *resv, size_t size_limit,
  * Otherwise, drop the request pending an answer to the upcall.
  */
 static int svcauth_gss_legacy_init(struct svc_rqst *rqstp,
-			struct rpc_gss_wire_cred *gc, __be32 *authp)
+				   struct rpc_gss_wire_cred *gc)
 {
 	struct kvec *argv = &rqstp->rq_arg.head[0];
 	struct kvec *resv = &rqstp->rq_res.head[0];
@@ -1235,7 +1235,7 @@ static int svcauth_gss_legacy_init(struct svc_rqst *rqstp,
 	struct sunrpc_net *sn = net_generic(SVC_NET(rqstp), sunrpc_net_id);
 
 	memset(&rsikey, 0, sizeof(rsikey));
-	ret = gss_read_verf(gc, argv, authp,
+	ret = gss_read_verf(gc, argv, &rqstp->rq_auth_stat,
 			    &rsikey.in_handle, &rsikey.in_token);
 	if (ret)
 		return ret;
@@ -1338,7 +1338,7 @@ static int gss_proxy_save_rsc(struct cache_detail *cd,
 }
 
 static int svcauth_gss_proxy_init(struct svc_rqst *rqstp,
-			struct rpc_gss_wire_cred *gc, __be32 *authp)
+				  struct rpc_gss_wire_cred *gc)
 {
 	struct kvec *resv = &rqstp->rq_res.head[0];
 	struct xdr_netobj cli_handle;
@@ -1350,8 +1350,7 @@ static int svcauth_gss_proxy_init(struct svc_rqst *rqstp,
 	struct sunrpc_net *sn = net_generic(net, sunrpc_net_id);
 
 	memset(&ud, 0, sizeof(ud));
-	ret = gss_read_proxy_verf(rqstp, gc, authp,
-				  &ud.in_handle, &ud.in_token);
+	ret = gss_read_proxy_verf(rqstp, gc, &ud.in_handle, &ud.in_token);
 	if (ret)
 		return ret;
 
@@ -1524,7 +1523,7 @@ static void destroy_use_gss_proxy_proc_entry(struct net *net) {}
  * response here and return SVC_COMPLETE.
  */
 static int
-svcauth_gss_accept(struct svc_rqst *rqstp, __be32 *authp)
+svcauth_gss_accept(struct svc_rqst *rqstp)
 {
 	struct kvec	*argv = &rqstp->rq_arg.head[0];
 	struct kvec	*resv = &rqstp->rq_res.head[0];
@@ -1537,7 +1536,7 @@ svcauth_gss_accept(struct svc_rqst *rqstp, __be32 *authp)
 	int		ret;
 	struct sunrpc_net *sn = net_generic(SVC_NET(rqstp), sunrpc_net_id);
 
-	*authp = rpc_autherr_badcred;
+	rqstp->rq_auth_stat = rpc_autherr_badcred;
 	if (!svcdata)
 		svcdata = kmalloc(sizeof(*svcdata), GFP_KERNEL);
 	if (!svcdata)
@@ -1574,22 +1573,22 @@ svcauth_gss_accept(struct svc_rqst *rqstp, __be32 *authp)
 	if ((gc->gc_proc != RPC_GSS_PROC_DATA) && (rqstp->rq_proc != 0))
 		goto auth_err;
 
-	*authp = rpc_autherr_badverf;
+	rqstp->rq_auth_stat = rpc_autherr_badverf;
 	switch (gc->gc_proc) {
 	case RPC_GSS_PROC_INIT:
 	case RPC_GSS_PROC_CONTINUE_INIT:
 		if (use_gss_proxy(SVC_NET(rqstp)))
-			return svcauth_gss_proxy_init(rqstp, gc, authp);
+			return svcauth_gss_proxy_init(rqstp, gc);
 		else
-			return svcauth_gss_legacy_init(rqstp, gc, authp);
+			return svcauth_gss_legacy_init(rqstp, gc);
 	case RPC_GSS_PROC_DATA:
 	case RPC_GSS_PROC_DESTROY:
 		/* Look up the context, and check the verifier: */
-		*authp = rpcsec_gsserr_credproblem;
+		rqstp->rq_auth_stat = rpcsec_gsserr_credproblem;
 		rsci = gss_svc_searchbyctx(sn->rsc_cache, &gc->gc_ctx);
 		if (!rsci)
 			goto auth_err;
-		switch (gss_verify_header(rqstp, rsci, rpcstart, gc, authp)) {
+		switch (gss_verify_header(rqstp, rsci, rpcstart, gc)) {
 		case SVC_OK:
 			break;
 		case SVC_DENIED:
@@ -1599,7 +1598,7 @@ svcauth_gss_accept(struct svc_rqst *rqstp, __be32 *authp)
 		}
 		break;
 	default:
-		*authp = rpc_autherr_rejectedcred;
+		rqstp->rq_auth_stat = rpc_autherr_rejectedcred;
 		goto auth_err;
 	}
 
@@ -1615,13 +1614,13 @@ svcauth_gss_accept(struct svc_rqst *rqstp, __be32 *authp)
 		svc_putnl(resv, RPC_SUCCESS);
 		goto complete;
 	case RPC_GSS_PROC_DATA:
-		*authp = rpcsec_gsserr_ctxproblem;
+		rqstp->rq_auth_stat = rpcsec_gsserr_ctxproblem;
 		svcdata->verf_start = resv->iov_base + resv->iov_len;
 		if (gss_write_verf(rqstp, rsci->mechctx, gc->gc_seq))
 			goto auth_err;
 		rqstp->rq_cred = rsci->cred;
 		get_group_info(rsci->cred.cr_group_info);
-		*authp = rpc_autherr_badcred;
+		rqstp->rq_auth_stat = rpc_autherr_badcred;
 		switch (gc->gc_svc) {
 		case RPC_GSS_SVC_NONE:
 			break;
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 27f98756d1751..cbcc951639ad5 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1305,7 +1305,7 @@ svc_process_common(struct svc_rqst *rqstp, struct kvec *argv, struct kvec *resv)
 	struct svc_process_info process;
 	__be32			*statp;
 	u32			prog, vers;
-	__be32			auth_stat, rpc_stat;
+	__be32			rpc_stat;
 	int			auth_res;
 	__be32			*reply_statp;
 
@@ -1348,14 +1348,14 @@ svc_process_common(struct svc_rqst *rqstp, struct kvec *argv, struct kvec *resv)
 	 * We do this before anything else in order to get a decent
 	 * auth verifier.
 	 */
-	auth_res = svc_authenticate(rqstp, &auth_stat);
+	auth_res = svc_authenticate(rqstp);
 	/* Also give the program a chance to reject this call: */
 	if (auth_res == SVC_OK && progp) {
-		auth_stat = rpc_autherr_badcred;
+		rqstp->rq_auth_stat = rpc_autherr_badcred;
 		auth_res = progp->pg_authenticate(rqstp);
 	}
 	if (auth_res != SVC_OK)
-		trace_svc_authenticate(rqstp, auth_res, auth_stat);
+		trace_svc_authenticate(rqstp, auth_res);
 	switch (auth_res) {
 	case SVC_OK:
 		break;
@@ -1414,8 +1414,8 @@ svc_process_common(struct svc_rqst *rqstp, struct kvec *argv, struct kvec *resv)
 			goto release_dropit;
 		if (*statp == rpc_garbage_args)
 			goto err_garbage;
-		auth_stat = svc_get_autherr(rqstp, statp);
-		if (auth_stat != rpc_auth_ok)
+		rqstp->rq_auth_stat = svc_get_autherr(rqstp, statp);
+		if (rqstp->rq_auth_stat != rpc_auth_ok)
 			goto err_release_bad_auth;
 	} else {
 		dprintk("svc: calling dispatcher\n");
@@ -1472,13 +1472,14 @@ svc_process_common(struct svc_rqst *rqstp, struct kvec *argv, struct kvec *resv)
 	if (procp->pc_release)
 		procp->pc_release(rqstp);
 err_bad_auth:
-	dprintk("svc: authentication failed (%d)\n", ntohl(auth_stat));
+	dprintk("svc: authentication failed (%d)\n",
+		be32_to_cpu(rqstp->rq_auth_stat));
 	serv->sv_stats->rpcbadauth++;
 	/* Restore write pointer to location of accept status: */
 	xdr_ressize_check(rqstp, reply_statp);
 	svc_putnl(resv, 1);	/* REJECT */
 	svc_putnl(resv, 1);	/* AUTH_ERROR */
-	svc_putnl(resv, ntohl(auth_stat));	/* status */
+	svc_putu32(resv, rqstp->rq_auth_stat);	/* status */
 	goto sendit;
 
 err_bad_prog:
diff --git a/net/sunrpc/svcauth.c b/net/sunrpc/svcauth.c
index 998b196b61767..5a8b8e03fdd42 100644
--- a/net/sunrpc/svcauth.c
+++ b/net/sunrpc/svcauth.c
@@ -59,12 +59,12 @@ svc_put_auth_ops(struct auth_ops *aops)
 }
 
 int
-svc_authenticate(struct svc_rqst *rqstp, __be32 *authp)
+svc_authenticate(struct svc_rqst *rqstp)
 {
 	rpc_authflavor_t	flavor;
 	struct auth_ops		*aops;
 
-	*authp = rpc_auth_ok;
+	rqstp->rq_auth_stat = rpc_auth_ok;
 
 	flavor = svc_getnl(&rqstp->rq_arg.head[0]);
 
@@ -72,7 +72,7 @@ svc_authenticate(struct svc_rqst *rqstp, __be32 *authp)
 
 	aops = svc_get_auth_ops(flavor);
 	if (aops == NULL) {
-		*authp = rpc_autherr_badcred;
+		rqstp->rq_auth_stat = rpc_autherr_badcred;
 		return SVC_DENIED;
 	}
 
@@ -80,7 +80,7 @@ svc_authenticate(struct svc_rqst *rqstp, __be32 *authp)
 	init_svc_cred(&rqstp->rq_cred);
 
 	rqstp->rq_authop = aops;
-	return aops->accept(rqstp, authp);
+	return aops->accept(rqstp);
 }
 EXPORT_SYMBOL_GPL(svc_authenticate);
 
diff --git a/net/sunrpc/svcauth_unix.c b/net/sunrpc/svcauth_unix.c
index 60754a292589b..c20c63d651a9c 100644
--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@ -743,7 +743,7 @@ svcauth_unix_set_client(struct svc_rqst *rqstp)
 EXPORT_SYMBOL_GPL(svcauth_unix_set_client);
 
 static int
-svcauth_null_accept(struct svc_rqst *rqstp, __be32 *authp)
+svcauth_null_accept(struct svc_rqst *rqstp)
 {
 	struct kvec	*argv = &rqstp->rq_arg.head[0];
 	struct kvec	*resv = &rqstp->rq_res.head[0];
@@ -754,12 +754,12 @@ svcauth_null_accept(struct svc_rqst *rqstp, __be32 *authp)
 
 	if (svc_getu32(argv) != 0) {
 		dprintk("svc: bad null cred\n");
-		*authp = rpc_autherr_badcred;
+		rqstp->rq_auth_stat = rpc_autherr_badcred;
 		return SVC_DENIED;
 	}
 	if (svc_getu32(argv) != htonl(RPC_AUTH_NULL) || svc_getu32(argv) != 0) {
 		dprintk("svc: bad null verf\n");
-		*authp = rpc_autherr_badverf;
+		rqstp->rq_auth_stat = rpc_autherr_badverf;
 		return SVC_DENIED;
 	}
 
@@ -803,7 +803,7 @@ struct auth_ops svcauth_null = {
 
 
 static int
-svcauth_unix_accept(struct svc_rqst *rqstp, __be32 *authp)
+svcauth_unix_accept(struct svc_rqst *rqstp)
 {
 	struct kvec	*argv = &rqstp->rq_arg.head[0];
 	struct kvec	*resv = &rqstp->rq_res.head[0];
@@ -845,7 +845,7 @@ svcauth_unix_accept(struct svc_rqst *rqstp, __be32 *authp)
 	}
 	groups_sort(cred->cr_group_info);
 	if (svc_getu32(argv) != htonl(RPC_AUTH_NULL) || svc_getu32(argv) != 0) {
-		*authp = rpc_autherr_badverf;
+		rqstp->rq_auth_stat = rpc_autherr_badverf;
 		return SVC_DENIED;
 	}
 
@@ -857,7 +857,7 @@ svcauth_unix_accept(struct svc_rqst *rqstp, __be32 *authp)
 	return SVC_OK;
 
 badcred:
-	*authp = rpc_autherr_badcred;
+	rqstp->rq_auth_stat = rpc_autherr_badcred;
 	return SVC_DENIED;
 }
 
-- 
2.43.0



