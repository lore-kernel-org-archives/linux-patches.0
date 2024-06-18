Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A3913BAFB;
	Tue, 18 Jun 2024 13:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715838; cv=none; b=YRDFR1/Y1Ia+uMT/QCkFnMLDHebY+3Tu4Y0ajFquvmSICOQ6O9zdDXuq5XFJtV+e1MLXmz5PCde/uN1Nfyq1vSRQNZJVcs4+gFTVd85emr2Mz/vpYXrz9Lmm6uAvs73Inz/3aQRknopz5aCZYmftAMChIwP0YzrpteF7qEDSQKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715838; c=relaxed/simple;
	bh=Z7MPO9HX3D2pW5o01PStIt8DoqKxYBDKn4hsVcnOknk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JSbMRIE5ftjVAV+JA76gXA53RIZbsDtzCfs1vpjWC8n+OIgJAxEX0U/PqpFCG6TrJFpcSTAV6nyqdwnrNfwCx4xT06bLo2hMTqVtrDG/zMXSIGUfDQaFNXcnzoA1CXdYjGXF89RogAg8ytQ2bsVCrfPxoqo4kjMp+yhtsXrH28E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZhqMvCYK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZhqMvCYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905D9C3277B;
	Tue, 18 Jun 2024 13:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715838;
	bh=Z7MPO9HX3D2pW5o01PStIt8DoqKxYBDKn4hsVcnOknk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZhqMvCYK8G9nc3Q/cL7xWZnQWH9p+8xAKkcqMakMZ1iPqCySyQIn81gc7/8PSvMgR
	 rVbRMX6PpLCRMqy9Ebx3HLQnBJTAEqlIlTk55yKZIyYaM2Dwro9iss7OCgf6TXIhCl
	 r/fSgmiW1FJ14ehfryKPvegUSm9dFwofL0h2wkm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 442/770] NFSD: Combine XDR error tracepoints
Date: Tue, 18 Jun 2024 14:34:55 +0200
Message-ID: <20240618123424.349387090@linuxfoundation.org>
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

[ Upstream commit 70e94d757b3e1f46486d573729d84c8955c81dce ]

Clean up: The garbage_args and cant_encode tracepoints report the
same information as each other, so combine them into a single
tracepoint class to reduce code duplication and slightly reduce the
size of trace.o.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/trace.h | 28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index de245f433392d..cba38e0b204b9 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -46,7 +46,7 @@
 			       rqstp->rq_xprt->xpt_remotelen); \
 		} while (0);
 
-TRACE_EVENT(nfsd_garbage_args_err,
+DECLARE_EVENT_CLASS(nfsd_xdr_err_class,
 	TP_PROTO(
 		const struct svc_rqst *rqstp
 	),
@@ -68,27 +68,13 @@ TRACE_EVENT(nfsd_garbage_args_err,
 	)
 );
 
-TRACE_EVENT(nfsd_cant_encode_err,
-	TP_PROTO(
-		const struct svc_rqst *rqstp
-	),
-	TP_ARGS(rqstp),
-	TP_STRUCT__entry(
-		NFSD_TRACE_PROC_ARG_FIELDS
+#define DEFINE_NFSD_XDR_ERR_EVENT(name) \
+DEFINE_EVENT(nfsd_xdr_err_class, nfsd_##name##_err, \
+	TP_PROTO(const struct svc_rqst *rqstp), \
+	TP_ARGS(rqstp))
 
-		__field(u32, vers)
-		__field(u32, proc)
-	),
-	TP_fast_assign(
-		NFSD_TRACE_PROC_ARG_ASSIGNMENTS
-
-		__entry->vers = rqstp->rq_vers;
-		__entry->proc = rqstp->rq_proc;
-	),
-	TP_printk("xid=0x%08x vers=%u proc=%u",
-		__entry->xid, __entry->vers, __entry->proc
-	)
-);
+DEFINE_NFSD_XDR_ERR_EVENT(garbage_args);
+DEFINE_NFSD_XDR_ERR_EVENT(cant_encode);
 
 #define show_nfsd_may_flags(x)						\
 	__print_flags(x, "|",						\
-- 
2.43.0



