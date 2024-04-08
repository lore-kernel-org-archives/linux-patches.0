Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B9A6A352;
	Mon,  8 Apr 2024 13:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583655; cv=none; b=pynWDnBNncH03VDMOmLGnEdIOHANaM++GJ+RJ+6TpI28j2b9BgMfnocSlt0jY28jFttoyxrR2TOe/E/7+p1o9atM1LpXli+yOQJ3NZFA+S1XwtXFJSZna2lBFbgW+yoH64YYuyp3JQcb4qTh233FSXXRZ/WqI+7VxMSPCt5JPXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583655; c=relaxed/simple;
	bh=3z08YCY8HIgac9K0NZ+NJGFft2ct4pl6JV25k4ZvDMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sks/3vH7wD+5ag5Hs3/I938KZFMAE3XFVZDpTO+JnfbPKYhRvcq0a4ugxId+S9tm6dzk4zut8YkUidnPYoUtjFY6SoF0sGXWSa7Tgh+tLwpup+Oy/uV3a39e/M8e8dgMOipjjaawAhmdKumgOmQQ5HAVYjy66ZUM4M8f0nf8xfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nsgsG8Ix; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nsgsG8Ix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B41BC433F1;
	Mon,  8 Apr 2024 13:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583654;
	bh=3z08YCY8HIgac9K0NZ+NJGFft2ct4pl6JV25k4ZvDMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nsgsG8IxL957peQFVK0BsM9Th1GuvjAJoRO2dAnD5kSE4lx/Hsca3/uH+ljj7JY5T
	 MKJ9jpNXEFGT+3D0jgoBi+q/T/AGqPoZZ9RVmgioe9xJ3dPiLXQ5Rfm56JjO35HNUm
	 K8Mq8Ku3W9MR1NcLwyl3VCRLsOK6JvBDNywiubi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 271/690] NFSD: Remove NFSD_PROC_ARGS_* macros
Date: Mon,  8 Apr 2024 14:52:17 +0200
Message-ID: <20240408125409.455570355@linuxfoundation.org>
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

[ Upstream commit c1a3f2ce66c80cd9f2a4376fa35a5c8d05441c73 ]

Clean up.

The PROC_ARGS macros were added when I thought that NFSD tracepoints
would be reporting endpoint information. However, tracepoints in the
RPC server now report transport endpoint information, so in general
there's no need for the upper layers to do that any more, and these
macros can be retired.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/trace.h | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index c55fd77d43605..7f3f40f6c0ff3 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -13,22 +13,6 @@
 #include "export.h"
 #include "nfsfh.h"
 
-#define NFSD_TRACE_PROC_ARG_FIELDS \
-		__field(unsigned int, netns_ino) \
-		__field(u32, xid) \
-		__array(unsigned char, server, sizeof(struct sockaddr_in6)) \
-		__array(unsigned char, client, sizeof(struct sockaddr_in6))
-
-#define NFSD_TRACE_PROC_ARG_ASSIGNMENTS \
-		do { \
-			__entry->netns_ino = SVC_NET(rqstp)->ns.inum; \
-			__entry->xid = be32_to_cpu(rqstp->rq_xid); \
-			memcpy(__entry->server, &rqstp->rq_xprt->xpt_local, \
-			       rqstp->rq_xprt->xpt_locallen); \
-			memcpy(__entry->client, &rqstp->rq_xprt->xpt_remote, \
-			       rqstp->rq_xprt->xpt_remotelen); \
-		} while (0);
-
 #define NFSD_TRACE_PROC_RES_FIELDS \
 		__field(unsigned int, netns_ino) \
 		__field(u32, xid) \
@@ -53,16 +37,22 @@ DECLARE_EVENT_CLASS(nfsd_xdr_err_class,
 	),
 	TP_ARGS(rqstp),
 	TP_STRUCT__entry(
-		NFSD_TRACE_PROC_ARG_FIELDS
-
+		__field(unsigned int, netns_ino)
+		__field(u32, xid)
 		__field(u32, vers)
 		__field(u32, proc)
+		__sockaddr(server, rqstp->rq_xprt->xpt_locallen)
+		__sockaddr(client, rqstp->rq_xprt->xpt_remotelen)
 	),
 	TP_fast_assign(
-		NFSD_TRACE_PROC_ARG_ASSIGNMENTS
+		const struct svc_xprt *xprt = rqstp->rq_xprt;
 
+		__entry->netns_ino = xprt->xpt_net->ns.inum;
+		__entry->xid = be32_to_cpu(rqstp->rq_xid);
 		__entry->vers = rqstp->rq_vers;
 		__entry->proc = rqstp->rq_proc;
+		__assign_sockaddr(server, &xprt->xpt_local, xprt->xpt_locallen);
+		__assign_sockaddr(client, &xprt->xpt_remote, xprt->xpt_remotelen);
 	),
 	TP_printk("xid=0x%08x vers=%u proc=%u",
 		__entry->xid, __entry->vers, __entry->proc
-- 
2.43.0



