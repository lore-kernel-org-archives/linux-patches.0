Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F061B1501;
	Tue, 18 Jun 2024 12:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714559; cv=none; b=FGKmYRjN/mzAK8X77E78LkCHkct6gfr/TsrxVNF4X+3dCzxoX6K+2QSXFC6K0MiCcqCEDRu15GCvDk52p/ceTgTPsHdaihWXejJQCUxKyiHOZSqW3Egm9Ktdtqr1RsBtw0BRSWhJj1S/Ug797JRq/HfyMS+oqVQvWug+l3FWpR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714559; c=relaxed/simple;
	bh=lkXf+RQw32aGEfXWxOui9VfhPfnSlRTwF+JWvZ0r7eU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwPKLKyyvUJbACdh8yJG9LPgAXlgzmvx4zWPBuco0UBThdN555aFPbyJDvF3+DqZlGpyP3dSW/CjMhJICgOQdA+dCAg+8D9y2lSHT5kF+SCXy0EwhtocdyawnkuD1cuopZXDu++ncP2iqohtNbrSzZ+SBrtIOsFMpAffE9mZ1FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GaScsrrR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GaScsrrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE29BC4AF49;
	Tue, 18 Jun 2024 12:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714559;
	bh=lkXf+RQw32aGEfXWxOui9VfhPfnSlRTwF+JWvZ0r7eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GaScsrrRg8Z05/x+zD70Op5pYEUUVDVZdpwpoAivkQHISDjH7q2w2OxPrNmmX7hl8
	 xKfCCMjf/wSvsZqzh4DDMxOZ9okV50tJXxLtzNukXUX9l7y4JhwGejW3FHqfs7hgVC
	 BqXcLLFLzin25CEKYwAmmT/wq7W/r0EtHSDSZ27o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/770] NFSD: Add tracepoints in nfsd_dispatch()
Date: Tue, 18 Jun 2024 14:27:45 +0200
Message-ID: <20240618123407.766125114@linuxfoundation.org>
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

[ Upstream commit 0dfdad1c1d1b77b9b085f4da390464dd0ac5647a ]

For troubleshooting purposes, record GARBAGE_ARGS and CANT_ENCODE
failures.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfssvc.c | 17 ++++----------
 fs/nfsd/trace.h  | 60 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+), 12 deletions(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index c81d49b07971c..3fb9607d67a37 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -29,6 +29,8 @@
 #include "netns.h"
 #include "filecache.h"
 
+#include "trace.h"
+
 #define NFSDDBG_FACILITY	NFSDDBG_SVC
 
 bool inter_copy_offload_enable;
@@ -1041,11 +1043,8 @@ int nfsd_dispatch(struct svc_rqst *rqstp, __be32 *statp)
 	struct kvec *resv = &rqstp->rq_res.head[0];
 	__be32 *p;
 
-	dprintk("nfsd_dispatch: vers %d proc %d\n",
-				rqstp->rq_vers, rqstp->rq_proc);
-
 	if (nfs_request_too_big(rqstp, proc))
-		goto out_too_large;
+		goto out_decode_err;
 
 	/*
 	 * Give the xdr decoder a chance to change this if it wants
@@ -1084,24 +1083,18 @@ int nfsd_dispatch(struct svc_rqst *rqstp, __be32 *statp)
 out_cached_reply:
 	return 1;
 
-out_too_large:
-	dprintk("nfsd: NFSv%d argument too large\n", rqstp->rq_vers);
-	*statp = rpc_garbage_args;
-	return 1;
-
 out_decode_err:
-	dprintk("nfsd: failed to decode arguments!\n");
+	trace_nfsd_garbage_args_err(rqstp);
 	*statp = rpc_garbage_args;
 	return 1;
 
 out_update_drop:
-	dprintk("nfsd: Dropping request; may be revisited later\n");
 	nfsd_cache_update(rqstp, RC_NOCACHE, NULL);
 out_dropit:
 	return 0;
 
 out_encode_err:
-	dprintk("nfsd: failed to encode result!\n");
+	trace_nfsd_cant_encode_err(rqstp);
 	nfsd_cache_update(rqstp, RC_NOCACHE, NULL);
 	*statp = rpc_system_err;
 	return 1;
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 9239d97b682c7..dbbda3e09eedd 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -12,6 +12,66 @@
 #include "export.h"
 #include "nfsfh.h"
 
+#define NFSD_TRACE_PROC_ARG_FIELDS \
+		__field(unsigned int, netns_ino) \
+		__field(u32, xid) \
+		__array(unsigned char, server, sizeof(struct sockaddr_in6)) \
+		__array(unsigned char, client, sizeof(struct sockaddr_in6))
+
+#define NFSD_TRACE_PROC_ARG_ASSIGNMENTS \
+		do { \
+			__entry->netns_ino = SVC_NET(rqstp)->ns.inum; \
+			__entry->xid = be32_to_cpu(rqstp->rq_xid); \
+			memcpy(__entry->server, &rqstp->rq_xprt->xpt_local, \
+			       rqstp->rq_xprt->xpt_locallen); \
+			memcpy(__entry->client, &rqstp->rq_xprt->xpt_remote, \
+			       rqstp->rq_xprt->xpt_remotelen); \
+		} while (0);
+
+TRACE_EVENT(nfsd_garbage_args_err,
+	TP_PROTO(
+		const struct svc_rqst *rqstp
+	),
+	TP_ARGS(rqstp),
+	TP_STRUCT__entry(
+		NFSD_TRACE_PROC_ARG_FIELDS
+
+		__field(u32, vers)
+		__field(u32, proc)
+	),
+	TP_fast_assign(
+		NFSD_TRACE_PROC_ARG_ASSIGNMENTS
+
+		__entry->vers = rqstp->rq_vers;
+		__entry->proc = rqstp->rq_proc;
+	),
+	TP_printk("xid=0x%08x vers=%u proc=%u",
+		__entry->xid, __entry->vers, __entry->proc
+	)
+);
+
+TRACE_EVENT(nfsd_cant_encode_err,
+	TP_PROTO(
+		const struct svc_rqst *rqstp
+	),
+	TP_ARGS(rqstp),
+	TP_STRUCT__entry(
+		NFSD_TRACE_PROC_ARG_FIELDS
+
+		__field(u32, vers)
+		__field(u32, proc)
+	),
+	TP_fast_assign(
+		NFSD_TRACE_PROC_ARG_ASSIGNMENTS
+
+		__entry->vers = rqstp->rq_vers;
+		__entry->proc = rqstp->rq_proc;
+	),
+	TP_printk("xid=0x%08x vers=%u proc=%u",
+		__entry->xid, __entry->vers, __entry->proc
+	)
+);
+
 #define show_nfsd_may_flags(x)						\
 	__print_flags(x, "|",						\
 		{ NFSD_MAY_EXEC,		"EXEC" },		\
-- 
2.43.0



