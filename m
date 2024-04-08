Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87563524AF;
	Mon,  8 Apr 2024 13:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584404; cv=none; b=orYO0f7YHGvSuGCUWnup5KNcq/atNDrYZwc3jncfn2vrwznjvhkPUBHoOtlkdlVi64rlLhhjB8qhq3m8Cddflvo9m7LA+tdW4fr0+NS5HDdRhpAKQm0nHoGoRztxhlVHiZTKWd6nfeg5pvf9h6PMBGFKyMZwOFx6Yj2bmE8u4C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584404; c=relaxed/simple;
	bh=OuI2/mbQbLdL7I8ptjNmLhzHpTME7q4SOoXXePxxeVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NTpg+Tce73vDW8RzEVhdpImvL+AUSe72gPF0L/8F2xHZ6+ARZNpaSNIWCW414XxgRCoTjJgwnqPATM9VviRnsW4xZmjlVF0Q0oC4Nhq7s8dl5NmL6vU9qM+XjmPYPTMvw9jqtn3T8yROA0oxvjkmF7jJFS8ekaDtRR0LoVu04Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oNTDLktd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oNTDLktd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB33C433F1;
	Mon,  8 Apr 2024 13:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584404;
	bh=OuI2/mbQbLdL7I8ptjNmLhzHpTME7q4SOoXXePxxeVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oNTDLktdEG4cAJoqMoB03g6BMJ1mf+LhmwMzKybdfoj/D5zoAiZtSOZ7tqj9W661G
	 ictGAg+Wf+PFIxkw9ooOMuKjeh+q4KBKI1pptX75eAXQerVMWczoqx7ssI627O2ZV9
	 plnO7lwB8qhSXYN03bEE7U4p3sfFk2jApcrw8SNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.15 427/690] NFSD: Trace NFSv4 COMPOUND tags
Date: Mon,  8 Apr 2024 14:54:53 +0200
Message-ID: <20240408125415.061314207@linuxfoundation.org>
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

[ Upstream commit de29cf7e6cbbe236c3a51999c188fcd467762899 ]

The Linux NFSv4 client implementation does not use COMPOUND tags,
but the Solaris and MacOS implementations do, and so does pynfs.
Record these eye-catchers in the server's trace buffer to annotate
client requests while troubleshooting.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4proc.c |  2 +-
 fs/nfsd/trace.h    | 21 ++++++++++++++-------
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 69d3013fb1b26..e4c0dc577fe35 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -2637,7 +2637,7 @@ nfsd4_proc_compound(struct svc_rqst *rqstp)
 
 	rqstp->rq_lease_breaker = (void **)&cstate->clp;
 
-	trace_nfsd_compound(rqstp, args->client_opcnt);
+	trace_nfsd_compound(rqstp, args->tag, args->taglen, args->client_opcnt);
 	while (!status && resp->opcnt < args->opcnt) {
 		op = &args->ops[resp->opcnt++];
 
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 297bf9ddc5090..c5d4a258680c3 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -84,19 +84,26 @@ DEFINE_NFSD_XDR_ERR_EVENT(cant_encode);
 		{ NFSD_MAY_64BIT_COOKIE,	"64BIT_COOKIE" })
 
 TRACE_EVENT(nfsd_compound,
-	TP_PROTO(const struct svc_rqst *rqst,
-		 u32 args_opcnt),
-	TP_ARGS(rqst, args_opcnt),
+	TP_PROTO(
+		const struct svc_rqst *rqst,
+		const char *tag,
+		u32 taglen,
+		u32 opcnt
+	),
+	TP_ARGS(rqst, tag, taglen, opcnt),
 	TP_STRUCT__entry(
 		__field(u32, xid)
-		__field(u32, args_opcnt)
+		__field(u32, opcnt)
+		__string_len(tag, tag, taglen)
 	),
 	TP_fast_assign(
 		__entry->xid = be32_to_cpu(rqst->rq_xid);
-		__entry->args_opcnt = args_opcnt;
+		__entry->opcnt = opcnt;
+		__assign_str_len(tag, tag, taglen);
 	),
-	TP_printk("xid=0x%08x opcnt=%u",
-		__entry->xid, __entry->args_opcnt)
+	TP_printk("xid=0x%08x opcnt=%u tag=%s",
+		__entry->xid, __entry->opcnt, __get_str(tag)
+	)
 )
 
 TRACE_EVENT(nfsd_compound_status,
-- 
2.43.0



