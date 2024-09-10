Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23707188A1E;
	Tue, 10 Sep 2024 10:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964955; cv=none; b=sjFC4MwcxpKEE1kqTXUAEKsGbB29qHKX51hGU16kEm0yWVHZgqC4d0E8uQL/SPBw90wOe9AKYxUzCg5NS9SctGJ82Ow8cCQ3aQsiWFFezj73GCr43Vn2jNdDi/O3AnSykMnrSfaCwKJ+JTwwKAjI5KX5Oac3wfSyMljQIoSPgoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964955; c=relaxed/simple;
	bh=IclfAMoejm09CWpS6eiCcXiTi8fjHiKLxUOGnd01Uts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IUUM6EHOxlpEgLNUm2568+d9w+3Z7k2jAC+TM4FIRrbzlwkTUprGD1vTVVe340JCNXFH8eRo+BzZjnncxYJ9XRG3yXtYSmG7Yk0+gTsNVOxJkCI95ohHhdyOO0plF04o83CVfQo8DoQtZGAmO2IunzKy56TfFvXlAZS7k4pT6Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6C2Mpv8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6C2Mpv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45939C4CEC3;
	Tue, 10 Sep 2024 10:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964954;
	bh=IclfAMoejm09CWpS6eiCcXiTi8fjHiKLxUOGnd01Uts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6C2Mpv8pXDf5aJGnAG4fp8QMnYToFTe6X6+aiDIH0Ajk9Tc8f4RvlWXueaSqbTvR
	 N+icCSAq7tisjEh7XxMsHEYHMPx5UJ4MMLaE+2LKLTjCZkeOt707WIcd+pKI0jU6xN
	 cvfKzU51X+nTtf3oA8ddH1Px6nOQr0XdTvNbHgng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 087/186] sunrpc: dont change ->sv_stats if it doesnt exist
Date: Tue, 10 Sep 2024 11:33:02 +0200
Message-ID: <20240910092558.093461088@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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
[ cel: adjusted to apply to v5.10.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svc.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1355,7 +1355,8 @@ svc_process_common(struct svc_rqst *rqst
 		goto err_bad_proc;
 
 	/* Syntactic check complete */
-	serv->sv_stats->rpccnt++;
+	if (serv->sv_stats)
+		serv->sv_stats->rpccnt++;
 	trace_svc_process(rqstp, progp->pg_name);
 
 	/* Build the reply header. */
@@ -1421,7 +1422,8 @@ err_short_len:
 	goto close_xprt;
 
 err_bad_rpc:
-	serv->sv_stats->rpcbadfmt++;
+	if (serv->sv_stats)
+		serv->sv_stats->rpcbadfmt++;
 	svc_putnl(resv, 1);	/* REJECT */
 	svc_putnl(resv, 0);	/* RPC_MISMATCH */
 	svc_putnl(resv, 2);	/* Only RPCv2 supported */
@@ -1434,7 +1436,8 @@ err_release_bad_auth:
 err_bad_auth:
 	dprintk("svc: authentication failed (%d)\n",
 		be32_to_cpu(rqstp->rq_auth_stat));
-	serv->sv_stats->rpcbadauth++;
+	if (serv->sv_stats)
+		serv->sv_stats->rpcbadauth++;
 	/* Restore write pointer to location of accept status: */
 	xdr_ressize_check(rqstp, reply_statp);
 	svc_putnl(resv, 1);	/* REJECT */
@@ -1444,7 +1447,8 @@ err_bad_auth:
 
 err_bad_prog:
 	dprintk("svc: unknown program %d\n", prog);
-	serv->sv_stats->rpcbadfmt++;
+	if (serv->sv_stats)
+		serv->sv_stats->rpcbadfmt++;
 	svc_putnl(resv, RPC_PROG_UNAVAIL);
 	goto sendit;
 
@@ -1452,7 +1456,8 @@ err_bad_vers:
 	svc_printk(rqstp, "unknown version (%d for prog %d, %s)\n",
 		       rqstp->rq_vers, rqstp->rq_prog, progp->pg_name);
 
-	serv->sv_stats->rpcbadfmt++;
+	if (serv->sv_stats)
+		serv->sv_stats->rpcbadfmt++;
 	svc_putnl(resv, RPC_PROG_MISMATCH);
 	svc_putnl(resv, process.mismatch.lovers);
 	svc_putnl(resv, process.mismatch.hivers);
@@ -1461,7 +1466,8 @@ err_bad_vers:
 err_bad_proc:
 	svc_printk(rqstp, "unknown procedure (%d)\n", rqstp->rq_proc);
 
-	serv->sv_stats->rpcbadfmt++;
+	if (serv->sv_stats)
+		serv->sv_stats->rpcbadfmt++;
 	svc_putnl(resv, RPC_PROC_UNAVAIL);
 	goto sendit;
 
@@ -1470,7 +1476,8 @@ err_garbage:
 
 	rpc_stat = rpc_garbage_args;
 err_bad:
-	serv->sv_stats->rpcbadfmt++;
+	if (serv->sv_stats)
+		serv->sv_stats->rpcbadfmt++;
 	svc_putnl(resv, ntohl(rpc_stat));
 	goto sendit;
 }
@@ -1505,7 +1512,8 @@ svc_process(struct svc_rqst *rqstp)
 	if (dir != 0) {
 		/* direction != CALL */
 		svc_printk(rqstp, "bad direction %d, dropping request\n", dir);
-		serv->sv_stats->rpcbadfmt++;
+		if (serv->sv_stats)
+			serv->sv_stats->rpcbadfmt++;
 		goto out_drop;
 	}
 


