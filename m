Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77FB44376;
	Thu, 15 Aug 2024 14:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730878; cv=none; b=op4kOeXtlOLM7yHZe3SFSEwAJ24r6tdUO35RvoSLUYApFuoHrD2ZuKsccwkBwIaBkzSBLVuAXB+ttFoEwK0E69swNQhjqVRlndyHwGCEXRlBYOtnigMpiiC/0Au9PBSCMNW+Cb06YkPkUYYV5YRb28FuvfySYvWKzXUuhQW5Yl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730878; c=relaxed/simple;
	bh=iIfBBTsl5LscD6MkBMyOGk3jET6AQ5ozsUjGsok8Cgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CX5+jbk7P4HG65LWomGMC84ja5xcISX7Bi892jdZEqJHdLry5+9aHj6aqWPXjy4xugyOefok8TXDVBQ/QmNtFXCXoTAvdERcpi1Z5EJLt4YOUxmp34MfJ1uMhzHSek2Omjblk1a3KlFHcnKhut5OsBVyWuwBJX+2YkEKxJCPsVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HtN7Y1k/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HtN7Y1k/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55264C32786;
	Thu, 15 Aug 2024 14:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730878;
	bh=iIfBBTsl5LscD6MkBMyOGk3jET6AQ5ozsUjGsok8Cgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HtN7Y1k/tzxUWAZnjxWLoU7SJEyOLitWy4xFN2+uV2/0rY8OB1sVGqvdnwxZiPtnl
	 LtgqYY1XXg6/AC/LOzQqTgWQEi1Q5PFO+0HTk5P4NIIy02I69MZPVy5ICY+bbxPVVs
	 tQoMpnpMsnJdfpEN3TT+KIk1nVvpyLqnyKQLjmbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 07/67] sunrpc: dont change ->sv_stats if it doesnt exist
Date: Thu, 15 Aug 2024 15:25:21 +0200
Message-ID: <20240815131838.601982028@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit ab42f4d9a26f1723dcfd6c93fcf768032b2bb5e7 ]

We check for the existence of ->sv_stats elsewhere except in the core
processing code.  It appears that only nfsd actual exports these values
anywhere, everybody else just has a write only copy of sv_stats in their
svc_program.  Add a check for ->sv_stats before every adjustment to
allow us to eliminate the stats struct from all the users who don't
report the stats.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svc.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1377,7 +1377,8 @@ svc_process_common(struct svc_rqst *rqst
 		goto err_bad_proc;
 
 	/* Syntactic check complete */
-	serv->sv_stats->rpccnt++;
+	if (serv->sv_stats)
+		serv->sv_stats->rpccnt++;
 	trace_svc_process(rqstp, progp->pg_name);
 
 	aoffset = xdr_stream_pos(xdr);
@@ -1429,7 +1430,8 @@ err_short_len:
 	goto close_xprt;
 
 err_bad_rpc:
-	serv->sv_stats->rpcbadfmt++;
+	if (serv->sv_stats)
+		serv->sv_stats->rpcbadfmt++;
 	xdr_stream_encode_u32(xdr, RPC_MSG_DENIED);
 	xdr_stream_encode_u32(xdr, RPC_MISMATCH);
 	/* Only RPCv2 supported */
@@ -1440,7 +1442,8 @@ err_bad_rpc:
 err_bad_auth:
 	dprintk("svc: authentication failed (%d)\n",
 		be32_to_cpu(rqstp->rq_auth_stat));
-	serv->sv_stats->rpcbadauth++;
+	if (serv->sv_stats)
+		serv->sv_stats->rpcbadauth++;
 	/* Restore write pointer to location of reply status: */
 	xdr_truncate_encode(xdr, XDR_UNIT * 2);
 	xdr_stream_encode_u32(xdr, RPC_MSG_DENIED);
@@ -1450,7 +1453,8 @@ err_bad_auth:
 
 err_bad_prog:
 	dprintk("svc: unknown program %d\n", rqstp->rq_prog);
-	serv->sv_stats->rpcbadfmt++;
+	if (serv->sv_stats)
+		serv->sv_stats->rpcbadfmt++;
 	*rqstp->rq_accept_statp = rpc_prog_unavail;
 	goto sendit;
 
@@ -1458,7 +1462,8 @@ err_bad_vers:
 	svc_printk(rqstp, "unknown version (%d for prog %d, %s)\n",
 		       rqstp->rq_vers, rqstp->rq_prog, progp->pg_name);
 
-	serv->sv_stats->rpcbadfmt++;
+	if (serv->sv_stats)
+		serv->sv_stats->rpcbadfmt++;
 	*rqstp->rq_accept_statp = rpc_prog_mismatch;
 
 	/*
@@ -1472,19 +1477,22 @@ err_bad_vers:
 err_bad_proc:
 	svc_printk(rqstp, "unknown procedure (%d)\n", rqstp->rq_proc);
 
-	serv->sv_stats->rpcbadfmt++;
+	if (serv->sv_stats)
+		serv->sv_stats->rpcbadfmt++;
 	*rqstp->rq_accept_statp = rpc_proc_unavail;
 	goto sendit;
 
 err_garbage_args:
 	svc_printk(rqstp, "failed to decode RPC header\n");
 
-	serv->sv_stats->rpcbadfmt++;
+	if (serv->sv_stats)
+		serv->sv_stats->rpcbadfmt++;
 	*rqstp->rq_accept_statp = rpc_garbage_args;
 	goto sendit;
 
 err_system_err:
-	serv->sv_stats->rpcbadfmt++;
+	if (serv->sv_stats)
+		serv->sv_stats->rpcbadfmt++;
 	*rqstp->rq_accept_statp = rpc_system_err;
 	goto sendit;
 }
@@ -1536,7 +1544,8 @@ void svc_process(struct svc_rqst *rqstp)
 out_baddir:
 	svc_printk(rqstp, "bad direction 0x%08x, dropping request\n",
 		   be32_to_cpu(*p));
-	rqstp->rq_server->sv_stats->rpcbadfmt++;
+	if (rqstp->rq_server->sv_stats)
+		rqstp->rq_server->sv_stats->rpcbadfmt++;
 out_drop:
 	svc_drop(rqstp);
 }


