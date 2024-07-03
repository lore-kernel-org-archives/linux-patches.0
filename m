Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48267185E7A;
	Wed,  3 Jul 2024 11:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004962; cv=none; b=K1zMXLjJ0LEcFhvrm2W3NTI4/v4D9EZ+mgqCwYM/MoA5PuvnPgJqa7UVr1mfTsy+duJzL+WinRvXEVrYq/8uQF0YHhpG/ClLzGjF46OsATcX2D3/ntqbLvMYdx7pzrzM0SIXD6dR9nTdXaSmpr3q4K1M0L4fAY6qfI8TJ2++AYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004962; c=relaxed/simple;
	bh=gOBTAZ56Fc5AKFv4NNHorWuWuKdA3Ist3bDdJNCjQwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XK6rG/Y2K28SwywprwA+54SZcTirkkaEMuWjx+Ceu8ilmm5QzfZLW6qR0XUc+AQvZn5R+tmqR1yCtAs7CSU4TwyoYLNYDJNxkLZmjZ7wqOFzQZiip9MxxJqQycJx2mGwJnRCWh4Y1Dm+eASk79gbl2H+WoHYacCVk/Ec22L9Tg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z/08tv5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z/08tv5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E26C2BD10;
	Wed,  3 Jul 2024 11:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004962;
	bh=gOBTAZ56Fc5AKFv4NNHorWuWuKdA3Ist3bDdJNCjQwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z/08tv5z3HwvxZGbfUyWDgTfKVqxoyWjKjmPCi076IIB+WGmlGfn2+SLQSNwjtqJT
	 1/erKuymh2polmBJzZNRHEjG3i2+6OsdhI/AjGVi1kJQNskg5oBHe6hIf5DsJnvAfi
	 ykVrrOj9uCpNqfmr5SbjI9Vevf4fpoc0YOmJ2uLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 214/290] SUNRPC: Fix a NULL pointer deref in trace_svc_stats_latency()
Date: Wed,  3 Jul 2024 12:39:55 +0200
Message-ID: <20240703102912.242666945@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

[ Upstream commit 5c11720767f70d34357d00a15ba5a0ad052c40fe ]

Some paths through svc_process() leave rqst->rq_procinfo set to
NULL, which triggers a crash if tracing happens to be enabled.

Fixes: 89ff87494c6e ("SUNRPC: Display RPC procedure names instead of proc numbers")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/svc.h    |  1 +
 include/trace/events/sunrpc.h |  8 ++++----
 net/sunrpc/svc.c              | 15 +++++++++++++++
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 1cf7a7799cc04..8583825c4aea2 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -498,6 +498,7 @@ void		   svc_wake_up(struct svc_serv *);
 void		   svc_reserve(struct svc_rqst *rqstp, int space);
 struct svc_pool *  svc_pool_for_cpu(struct svc_serv *serv, int cpu);
 char *		   svc_print_addr(struct svc_rqst *, char *, size_t);
+const char *	   svc_proc_name(const struct svc_rqst *rqstp);
 int		   svc_encode_result_payload(struct svc_rqst *rqstp,
 					     unsigned int offset,
 					     unsigned int length);
diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index 56e4a57d25382..5d34deca0f300 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -1578,7 +1578,7 @@ TRACE_EVENT(svc_process,
 		__field(u32, vers)
 		__field(u32, proc)
 		__string(service, name)
-		__string(procedure, rqst->rq_procinfo->pc_name)
+		__string(procedure, svc_proc_name(rqst))
 		__string(addr, rqst->rq_xprt ?
 			 rqst->rq_xprt->xpt_remotebuf : "(null)")
 	),
@@ -1588,7 +1588,7 @@ TRACE_EVENT(svc_process,
 		__entry->vers = rqst->rq_vers;
 		__entry->proc = rqst->rq_proc;
 		__assign_str(service, name);
-		__assign_str(procedure, rqst->rq_procinfo->pc_name);
+		__assign_str(procedure, svc_proc_name(rqst));
 		__assign_str(addr, rqst->rq_xprt ?
 			     rqst->rq_xprt->xpt_remotebuf : "(null)");
 	),
@@ -1854,7 +1854,7 @@ TRACE_EVENT(svc_stats_latency,
 	TP_STRUCT__entry(
 		__field(u32, xid)
 		__field(unsigned long, execute)
-		__string(procedure, rqst->rq_procinfo->pc_name)
+		__string(procedure, svc_proc_name(rqst))
 		__string(addr, rqst->rq_xprt->xpt_remotebuf)
 	),
 
@@ -1862,7 +1862,7 @@ TRACE_EVENT(svc_stats_latency,
 		__entry->xid = be32_to_cpu(rqst->rq_xid);
 		__entry->execute = ktime_to_us(ktime_sub(ktime_get(),
 							 rqst->rq_stime));
-		__assign_str(procedure, rqst->rq_procinfo->pc_name);
+		__assign_str(procedure, svc_proc_name(rqst));
 		__assign_str(addr, rqst->rq_xprt->xpt_remotebuf);
 	),
 
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index ac7b3a93d9920..f8815ae776e68 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1612,6 +1612,21 @@ u32 svc_max_payload(const struct svc_rqst *rqstp)
 }
 EXPORT_SYMBOL_GPL(svc_max_payload);
 
+/**
+ * svc_proc_name - Return RPC procedure name in string form
+ * @rqstp: svc_rqst to operate on
+ *
+ * Return value:
+ *   Pointer to a NUL-terminated string
+ */
+const char *svc_proc_name(const struct svc_rqst *rqstp)
+{
+	if (rqstp && rqstp->rq_procinfo)
+		return rqstp->rq_procinfo->pc_name;
+	return "unknown";
+}
+
+
 /**
  * svc_encode_result_payload - mark a range of bytes as a result payload
  * @rqstp: svc_rqst to operate on
-- 
2.43.0



