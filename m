Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB397E111;
	Mon,  8 Apr 2024 13:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583455; cv=none; b=TFbSEIdfNW5mEkmpiXDs1oAOtHiHTWZ8fy6jntP6fSMy9H9Ww2o5vlkFRFF6d5MDHBz480n522GNY5KZbB8Y+0nRH6NK4WFd4cPrDKR7+eN0Y3WucFDs0sSioNLiDD4bJ0akOrqqy/xMaXwCRXdgqL15Is9EyY5wLddlL8PlD4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583455; c=relaxed/simple;
	bh=FbwquyQ7iTzWuhIYncSLaEYxGdMKxSTtlt3yC+d3f0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOFpyaS/T5FJ+06i4PWnXem3wW3zbTucNEqNqo8ed0Wgn+Z66YjKe/TDj2T3E9vPF4VmlARvcqizH67atv38phPyn+UL5R6ftZD8zpaR3Fx3u6ca7c5Tc0kBrw/0PQM5BhMVkruT0CoMfIeKQoiRCg1U/jLYhjFSQC5AVWBW4eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+sTkq7l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+sTkq7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA432C433C7;
	Mon,  8 Apr 2024 13:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583455;
	bh=FbwquyQ7iTzWuhIYncSLaEYxGdMKxSTtlt3yC+d3f0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+sTkq7ldLbTgPXomgtdgEKnjZEX5/QrkiZ12KLtS9J2nGBmki5ubaOfULca4YZ8B
	 J3zuFtx8B0iHbscfMotCtVPRHi3WbXXokCtT5lTg02KVTrepsmIBvNO0n7jPghV3PA
	 Hi9x9zLu1s+3vVPsQinVyQRoKFQltGE51ryCaPOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 249/690] NFSD: Combine XDR error tracepoints
Date: Mon,  8 Apr 2024 14:51:55 +0200
Message-ID: <20240408125408.634681314@linuxfoundation.org>
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

[ Upstream commit 70e94d757b3e1f46486d573729d84c8955c81dce ]

Clean up: The garbage_args and cant_encode tracepoints report the
same information as each other, so combine them into a single
tracepoint class to reduce code duplication and slightly reduce the
size of trace.o.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/trace.h | 28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 61943a629cdee..1c98a0f857498 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -47,7 +47,7 @@
 			       rqstp->rq_xprt->xpt_remotelen); \
 		} while (0);
 
-TRACE_EVENT(nfsd_garbage_args_err,
+DECLARE_EVENT_CLASS(nfsd_xdr_err_class,
 	TP_PROTO(
 		const struct svc_rqst *rqstp
 	),
@@ -69,27 +69,13 @@ TRACE_EVENT(nfsd_garbage_args_err,
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



