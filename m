Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF50D1B29A3;
	Tue, 18 Jun 2024 12:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714562; cv=none; b=P8qbPKmZ1k4wgQTfixuhrEj/5zqs7dAcwYbtVgAJdoDHK6m4IFoucjIzMNYzXhsD6NrqomngFm3D+2tdOT+Rx+ERd1S3ojYfXxVoW/dpPKLFMk/0SOOqJAOVITmjAy3uDKiR5GIGPRFh3rovi5QXz0cxib4YwS7QSBzf8aKLT2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714562; c=relaxed/simple;
	bh=swiAWeR0rDHhdY8te0hlKlYYW4H95/6qP4ImScXKP1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oca9b9FAIkFxQP5EYQk0Jq79QfssbjK1B8tWyZsUDeNrRI58MvipNo3vAVBoCAFXQWWvdq/s+uq51aGf+JSvL4ANs8Y+vTu4NNRRrkRAm00Dewkl2PG6WFxUDyIsKb2gGqijmLAdyLXrqRZhTgdxqZ2t8v3KY105xvyhM4H+COw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLrh7AYO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLrh7AYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C12C4AF48;
	Tue, 18 Jun 2024 12:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714562;
	bh=swiAWeR0rDHhdY8te0hlKlYYW4H95/6qP4ImScXKP1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLrh7AYOdw8IJLPpBZiak3nDKlbgYjNBFgtXyRwdn3IXkQ0BQPlB6tkVA0WTG7z0J
	 kvOc20gumkjtInd6gf3CUCRdoeN2loWeTK/l0ApoTQmjeWT6LC0fnzKPYRzR+RFNGb
	 Nu1ClTm+Ulgtj9BRn3g9VlROm/IsywmH/QeqSIJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/770] NFSD: Add tracepoints in nfsd4_decode/encode_compound()
Date: Tue, 18 Jun 2024 14:27:46 +0200
Message-ID: <20240618123407.806486903@linuxfoundation.org>
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

[ Upstream commit 08281341be8ebc97ee47999812bcf411942baa1e ]

For troubleshooting purposes, record failures to decode NFSv4
operation arguments and encode operation results.

trace_nfsd_compound_decode_err() replaces the dprintk() call sites
that are embedded in READ_* macros that are about to be removed.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 13 +++++++--
 fs/nfsd/trace.h   | 68 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index c176d0090f7c8..101ada3636b78 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -54,6 +54,8 @@
 #include "pnfs.h"
 #include "filecache.h"
 
+#include "trace.h"
+
 #ifdef CONFIG_NFSD_V4_SECURITY_LABEL
 #include <linux/security.h>
 #endif
@@ -2248,9 +2250,14 @@ nfsd4_decode_compound(struct nfsd4_compoundargs *argp)
 		READ_BUF(4);
 		op->opnum = be32_to_cpup(p++);
 
-		if (nfsd4_opnum_in_range(argp, op))
+		if (nfsd4_opnum_in_range(argp, op)) {
 			op->status = nfsd4_dec_ops[op->opnum](argp, &op->u);
-		else {
+			if (op->status != nfs_ok)
+				trace_nfsd_compound_decode_err(argp->rqstp,
+							       argp->opcnt, i,
+							       op->opnum,
+							       op->status);
+		} else {
 			op->opnum = OP_ILLEGAL;
 			op->status = nfserr_op_illegal;
 		}
@@ -5220,6 +5227,8 @@ nfsd4_encode_operation(struct nfsd4_compoundres *resp, struct nfsd4_op *op)
 	       !nfsd4_enc_ops[op->opnum]);
 	encoder = nfsd4_enc_ops[op->opnum];
 	op->status = encoder(resp, op->status, &op->u);
+	if (op->status)
+		trace_nfsd_compound_encode_err(rqstp, op->opnum, op->status);
 	if (opdesc && opdesc->op_release)
 		opdesc->op_release(&op->u);
 	xdr_commit_encode(xdr);
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index dbbda3e09eedd..2bc2a888f7fa8 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -28,6 +28,24 @@
 			       rqstp->rq_xprt->xpt_remotelen); \
 		} while (0);
 
+#define NFSD_TRACE_PROC_RES_FIELDS \
+		__field(unsigned int, netns_ino) \
+		__field(u32, xid) \
+		__field(unsigned long, status) \
+		__array(unsigned char, server, sizeof(struct sockaddr_in6)) \
+		__array(unsigned char, client, sizeof(struct sockaddr_in6))
+
+#define NFSD_TRACE_PROC_RES_ASSIGNMENTS(error) \
+		do { \
+			__entry->netns_ino = SVC_NET(rqstp)->ns.inum; \
+			__entry->xid = be32_to_cpu(rqstp->rq_xid); \
+			__entry->status = be32_to_cpu(error); \
+			memcpy(__entry->server, &rqstp->rq_xprt->xpt_local, \
+			       rqstp->rq_xprt->xpt_locallen); \
+			memcpy(__entry->client, &rqstp->rq_xprt->xpt_remote, \
+			       rqstp->rq_xprt->xpt_remotelen); \
+		} while (0);
+
 TRACE_EVENT(nfsd_garbage_args_err,
 	TP_PROTO(
 		const struct svc_rqst *rqstp
@@ -127,6 +145,56 @@ TRACE_EVENT(nfsd_compound_status,
 		__get_str(name), __entry->status)
 )
 
+TRACE_EVENT(nfsd_compound_decode_err,
+	TP_PROTO(
+		const struct svc_rqst *rqstp,
+		u32 args_opcnt,
+		u32 resp_opcnt,
+		u32 opnum,
+		__be32 status
+	),
+	TP_ARGS(rqstp, args_opcnt, resp_opcnt, opnum, status),
+	TP_STRUCT__entry(
+		NFSD_TRACE_PROC_RES_FIELDS
+
+		__field(u32, args_opcnt)
+		__field(u32, resp_opcnt)
+		__field(u32, opnum)
+	),
+	TP_fast_assign(
+		NFSD_TRACE_PROC_RES_ASSIGNMENTS(status)
+
+		__entry->args_opcnt = args_opcnt;
+		__entry->resp_opcnt = resp_opcnt;
+		__entry->opnum = opnum;
+	),
+	TP_printk("op=%u/%u opnum=%u status=%lu",
+		__entry->resp_opcnt, __entry->args_opcnt,
+		__entry->opnum, __entry->status)
+);
+
+TRACE_EVENT(nfsd_compound_encode_err,
+	TP_PROTO(
+		const struct svc_rqst *rqstp,
+		u32 opnum,
+		__be32 status
+	),
+	TP_ARGS(rqstp, opnum, status),
+	TP_STRUCT__entry(
+		NFSD_TRACE_PROC_RES_FIELDS
+
+		__field(u32, opnum)
+	),
+	TP_fast_assign(
+		NFSD_TRACE_PROC_RES_ASSIGNMENTS(status)
+
+		__entry->opnum = opnum;
+	),
+	TP_printk("opnum=%u status=%lu",
+		__entry->opnum, __entry->status)
+);
+
+
 DECLARE_EVENT_CLASS(nfsd_fh_err_class,
 	TP_PROTO(struct svc_rqst *rqstp,
 		 struct svc_fh	*fhp,
-- 
2.43.0



