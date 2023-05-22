Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E21E171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09F5C433D2;
	Mon, 22 May 2023 19:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784829;
	bh=m7ZESt81aCuiB8oS/X/hL/XQE3NJGdiY1nELCwjXRLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nBRXsuqq+VqCaDnIJ1iZiONsYWnH9+CmDJXhW3JqEUqWiKpT9dDeqd4TBwCCdeeuE
	 9dkG3HZk/SVvoYzE8l1qxG+IpZt7urThRI7dqUr8MfH6wc+UGuRNyclEPrL02ICxhK
	 pu5WFrIcCZZpnKawxOJoTx/JoBxDTK4YQ3nHeUMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 215/364] SUNRPC: Fix encoding of accepted but unsuccessful RPC replies
Date: Mon, 22 May 2023 20:08:40 +0100
Message-Id: <20230522190418.091359707@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 29cd2927fb914cc53b5ba4f67d2b74695c994ba4 ]

Jiri Slaby says:
> I bisected to this ... as it breaks nfs3-only servers in 6.3.
> I.e. /etc/nfs.conf containing:
> [nfsd]
> vers4=no
>
> The client sees:
>  mount("10.0.2.15:/tmp", "/mnt", "nfs", 0, "vers=4.2,addr=10.0.2.15,clientad"...) = -1 EIO (Input/output error)
>  write(2, "mount.nfs: mount system call fai"..., 45
>  mount.nfs: mount system call failed for /mnt
>
> And the kernel says:
>  nfs4_discover_server_trunking unhandled error -5. Exiting with error EIO

Reported-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://bugzilla.suse.com/show_bug.cgi?id=1210995
Fixes: 4bcf0343e8a6 ("SUNRPC: Set rq_accept_statp inside ->accept methods")
Tested-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svc.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index fea7ce8fba14e..9874a6de1de3c 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1382,7 +1382,7 @@ svc_process_common(struct svc_rqst *rqstp)
 	/* Only RPCv2 supported */
 	xdr_stream_encode_u32(xdr, RPC_VERSION);
 	xdr_stream_encode_u32(xdr, RPC_VERSION);
-	goto sendit;
+	return 1;	/* don't wrap */
 
 err_bad_auth:
 	dprintk("svc: authentication failed (%d)\n",
@@ -1398,7 +1398,7 @@ svc_process_common(struct svc_rqst *rqstp)
 err_bad_prog:
 	dprintk("svc: unknown program %d\n", rqstp->rq_prog);
 	serv->sv_stats->rpcbadfmt++;
-	xdr_stream_encode_u32(xdr, RPC_PROG_UNAVAIL);
+	*rqstp->rq_accept_statp = rpc_prog_unavail;
 	goto sendit;
 
 err_bad_vers:
@@ -1406,7 +1406,12 @@ svc_process_common(struct svc_rqst *rqstp)
 		       rqstp->rq_vers, rqstp->rq_prog, progp->pg_name);
 
 	serv->sv_stats->rpcbadfmt++;
-	xdr_stream_encode_u32(xdr, RPC_PROG_MISMATCH);
+	*rqstp->rq_accept_statp = rpc_prog_mismatch;
+
+	/*
+	 * svc_authenticate() has already added the verifier and
+	 * advanced the stream just past rq_accept_statp.
+	 */
 	xdr_stream_encode_u32(xdr, process.mismatch.lovers);
 	xdr_stream_encode_u32(xdr, process.mismatch.hivers);
 	goto sendit;
@@ -1415,19 +1420,19 @@ svc_process_common(struct svc_rqst *rqstp)
 	svc_printk(rqstp, "unknown procedure (%d)\n", rqstp->rq_proc);
 
 	serv->sv_stats->rpcbadfmt++;
-	xdr_stream_encode_u32(xdr, RPC_PROC_UNAVAIL);
+	*rqstp->rq_accept_statp = rpc_proc_unavail;
 	goto sendit;
 
 err_garbage_args:
 	svc_printk(rqstp, "failed to decode RPC header\n");
 
 	serv->sv_stats->rpcbadfmt++;
-	xdr_stream_encode_u32(xdr, RPC_GARBAGE_ARGS);
+	*rqstp->rq_accept_statp = rpc_garbage_args;
 	goto sendit;
 
 err_system_err:
 	serv->sv_stats->rpcbadfmt++;
-	xdr_stream_encode_u32(xdr, RPC_SYSTEM_ERR);
+	*rqstp->rq_accept_statp = rpc_system_err;
 	goto sendit;
 }
 
-- 
2.39.2



