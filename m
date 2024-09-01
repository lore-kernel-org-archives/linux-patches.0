Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CB417ADE1;
	Sun,  1 Sep 2024 17:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210196; cv=none; b=sK909D8FbF9Cl8uD/fKIdcHHena3wEW6aaEZl4H7/d6oO1LWfzDpQ/OXXV54Kexojf9xh1BuECA/+pjmsY3ueEJhsF3Do3Vme0UmwyCcIFmWw4a+bCC90Khx+A9nfkC+icjPWwqAA1L3J4dJnfNMQ7pChG5LyuY4MiOiSLaJVow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210196; c=relaxed/simple;
	bh=IISw7pSuLBqfadd0Ui2XWBES67P7y91KBMOsQY8iVvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igDb/J6px3nDvlAX30ih/8ZWN3ws5bVJ24uQngUGQHKtWtCzNHDLIoWaFfyxktubgpJyQcovd7PNVUwA0oabDPrq+9FRpsFlqZIXUTz8RUEDTy2cQEa5OeZmZp6bZklB8FbMRRAWdcMXc9Iwgw2dhljKh3FlxnUqCOuuDIRL2vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IKjfzX1/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IKjfzX1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84AB9C4CEC3;
	Sun,  1 Sep 2024 17:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210196;
	bh=IISw7pSuLBqfadd0Ui2XWBES67P7y91KBMOsQY8iVvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IKjfzX1/F9PyKiLOVBCQTEVweni9SM/IiynMp19V1MbljvSuDO7qXXvh9TG13EBxY
	 BQHsPVZdgmFioDFHz1vNSlL48B/s7gvLmAjpMfy9zdb3BpH1SbDHEmrpQ4GbWvP2U/
	 kiivZ4pYlBAw8QpfT75z65XtbNFTGrBbe0DdXIVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 118/215] sunrpc: dont change ->sv_stats if it doesnt exist
Date: Sun,  1 Sep 2024 18:17:10 +0200
Message-ID: <20240901160827.814175386@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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
[ cel: adjusted to apply to v5.15.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svc.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1357,7 +1357,8 @@ svc_process_common(struct svc_rqst *rqst
 		goto err_bad_proc;
 
 	/* Syntactic check complete */
-	serv->sv_stats->rpccnt++;
+	if (serv->sv_stats)
+		serv->sv_stats->rpccnt++;
 	trace_svc_process(rqstp, progp->pg_name);
 
 	/* Build the reply header. */
@@ -1423,7 +1424,8 @@ err_short_len:
 	goto close_xprt;
 
 err_bad_rpc:
-	serv->sv_stats->rpcbadfmt++;
+	if (serv->sv_stats)
+		serv->sv_stats->rpcbadfmt++;
 	svc_putnl(resv, 1);	/* REJECT */
 	svc_putnl(resv, 0);	/* RPC_MISMATCH */
 	svc_putnl(resv, 2);	/* Only RPCv2 supported */
@@ -1436,7 +1438,8 @@ err_release_bad_auth:
 err_bad_auth:
 	dprintk("svc: authentication failed (%d)\n",
 		be32_to_cpu(rqstp->rq_auth_stat));
-	serv->sv_stats->rpcbadauth++;
+	if (serv->sv_stats)
+		serv->sv_stats->rpcbadauth++;
 	/* Restore write pointer to location of accept status: */
 	xdr_ressize_check(rqstp, reply_statp);
 	svc_putnl(resv, 1);	/* REJECT */
@@ -1446,7 +1449,8 @@ err_bad_auth:
 
 err_bad_prog:
 	dprintk("svc: unknown program %d\n", prog);
-	serv->sv_stats->rpcbadfmt++;
+	if (serv->sv_stats)
+		serv->sv_stats->rpcbadfmt++;
 	svc_putnl(resv, RPC_PROG_UNAVAIL);
 	goto sendit;
 
@@ -1454,7 +1458,8 @@ err_bad_vers:
 	svc_printk(rqstp, "unknown version (%d for prog %d, %s)\n",
 		       rqstp->rq_vers, rqstp->rq_prog, progp->pg_name);
 
-	serv->sv_stats->rpcbadfmt++;
+	if (serv->sv_stats)
+		serv->sv_stats->rpcbadfmt++;
 	svc_putnl(resv, RPC_PROG_MISMATCH);
 	svc_putnl(resv, process.mismatch.lovers);
 	svc_putnl(resv, process.mismatch.hivers);
@@ -1463,7 +1468,8 @@ err_bad_vers:
 err_bad_proc:
 	svc_printk(rqstp, "unknown procedure (%d)\n", rqstp->rq_proc);
 
-	serv->sv_stats->rpcbadfmt++;
+	if (serv->sv_stats)
+		serv->sv_stats->rpcbadfmt++;
 	svc_putnl(resv, RPC_PROC_UNAVAIL);
 	goto sendit;
 
@@ -1472,7 +1478,8 @@ err_garbage:
 
 	rpc_stat = rpc_garbage_args;
 err_bad:
-	serv->sv_stats->rpcbadfmt++;
+	if (serv->sv_stats)
+		serv->sv_stats->rpcbadfmt++;
 	svc_putnl(resv, ntohl(rpc_stat));
 	goto sendit;
 }
@@ -1513,7 +1520,8 @@ svc_process(struct svc_rqst *rqstp)
 	if (dir != 0) {
 		/* direction != CALL */
 		svc_printk(rqstp, "bad direction %d, dropping request\n", dir);
-		serv->sv_stats->rpcbadfmt++;
+		if (serv->sv_stats)
+			serv->sv_stats->rpcbadfmt++;
 		goto out_drop;
 	}
 


