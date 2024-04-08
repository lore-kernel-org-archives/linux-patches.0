Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1DB7C6C8;
	Mon,  8 Apr 2024 13:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584154; cv=none; b=bDH3umThC+j4523K8cwrWJIK/FdbebxAY/TM6bwb6K3trb2oBINO8fLE1/KAGtHaNoibyE1N+Mqb8QPKd6OPsaKdjCyO5RwxLybynnhPgk7KP/J88p95mj4vYVbqfQdAi/rLsvM4iZ42PzmvmtDcoZV4LhyDtc2lhFoJE2aPCRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584154; c=relaxed/simple;
	bh=R9jQTtDJlqEcOD40B8MgNBdYjhSeDFhgv4x0SOvDUcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjQOa+eUCVlPhE0StKA1l4J+WRH0ayCX69KvAtI6/XWm+uS/d7rK256JIX8fbMm+Cq6n1pW4x06R01r3RWo/d+6nKOGjwvZJzBVTKgll3w0HOj9etF/L0mGunnS/Su3L0PWaTmkpWXxbD659UkoZfuzzdVqnQKZR1fT0ZhK5TSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o4n6drN+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o4n6drN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C631C433F1;
	Mon,  8 Apr 2024 13:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584153;
	bh=R9jQTtDJlqEcOD40B8MgNBdYjhSeDFhgv4x0SOvDUcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o4n6drN+yKpqfEPvg7SbTI+dihKPUDUVF6EpwsEU0vRtGo+XYI0X9SI8yPiSelF2v
	 EiEZpm4iww5JVw7A/9r7aPdG+PUQowsW4cfwp4KPyJpA2BdON31/AFOB4ZTp9fe62W
	 CmEcVGNRz68EDUO8Alq433e+CyL0RJFs5WOm6hJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 342/690] NFSD: Instrument fh_verify()
Date: Mon,  8 Apr 2024 14:53:28 +0200
Message-ID: <20240408125412.003210090@linuxfoundation.org>
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

[ Upstream commit 051382885552e12541cc0ebf82092be374a9ed2a ]

Capture file handles and how they map to local inodes. In particular,
NFSv4 PUTFH uses fh_verify() so we can now observe which file handles
are the target of OPEN, LOOKUP, RENAME, and so on.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfsfh.c |  5 +++--
 fs/nfsd/trace.h | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index c29baa03dfafd..5e2ed4b2a925c 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -331,8 +331,6 @@ fh_verify(struct svc_rqst *rqstp, struct svc_fh *fhp, umode_t type, int access)
 	struct dentry	*dentry;
 	__be32		error;
 
-	dprintk("nfsd: fh_verify(%s)\n", SVCFH_fmt(fhp));
-
 	if (!fhp->fh_dentry) {
 		error = nfsd_set_fh_dentry(rqstp, fhp);
 		if (error)
@@ -340,6 +338,9 @@ fh_verify(struct svc_rqst *rqstp, struct svc_fh *fhp, umode_t type, int access)
 	}
 	dentry = fhp->fh_dentry;
 	exp = fhp->fh_export;
+
+	trace_nfsd_fh_verify(rqstp, fhp, type, access);
+
 	/*
 	 * We still have to do all these permission checks, even when
 	 * fh_dentry is already set:
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 3cff3ada00a85..593218d8a54d0 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -171,6 +171,52 @@ TRACE_EVENT(nfsd_compound_encode_err,
 		__entry->opnum, __entry->status)
 );
 
+#define show_fs_file_type(x) \
+	__print_symbolic(x, \
+		{ S_IFLNK,		"LNK" }, \
+		{ S_IFREG,		"REG" }, \
+		{ S_IFDIR,		"DIR" }, \
+		{ S_IFCHR,		"CHR" }, \
+		{ S_IFBLK,		"BLK" }, \
+		{ S_IFIFO,		"FIFO" }, \
+		{ S_IFSOCK,		"SOCK" })
+
+TRACE_EVENT(nfsd_fh_verify,
+	TP_PROTO(
+		const struct svc_rqst *rqstp,
+		const struct svc_fh *fhp,
+		umode_t type,
+		int access
+	),
+	TP_ARGS(rqstp, fhp, type, access),
+	TP_STRUCT__entry(
+		__field(unsigned int, netns_ino)
+		__sockaddr(server, rqstp->rq_xprt->xpt_remotelen)
+		__sockaddr(client, rqstp->rq_xprt->xpt_remotelen)
+		__field(u32, xid)
+		__field(u32, fh_hash)
+		__field(void *, inode)
+		__field(unsigned long, type)
+		__field(unsigned long, access)
+	),
+	TP_fast_assign(
+		__entry->netns_ino = SVC_NET(rqstp)->ns.inum;
+		__assign_sockaddr(server, &rqstp->rq_xprt->xpt_local,
+		       rqstp->rq_xprt->xpt_locallen);
+		__assign_sockaddr(client, &rqstp->rq_xprt->xpt_remote,
+				  rqstp->rq_xprt->xpt_remotelen);
+		__entry->xid = be32_to_cpu(rqstp->rq_xid);
+		__entry->fh_hash = knfsd_fh_hash(&fhp->fh_handle);
+		__entry->inode = d_inode(fhp->fh_dentry);
+		__entry->type = type;
+		__entry->access = access;
+	),
+	TP_printk("xid=0x%08x fh_hash=0x%08x inode=%p type=%s access=%s",
+		__entry->xid, __entry->fh_hash, __entry->inode,
+		show_fs_file_type(__entry->type),
+		show_nfsd_may_flags(__entry->access)
+	)
+);
 
 DECLARE_EVENT_CLASS(nfsd_fh_err_class,
 	TP_PROTO(struct svc_rqst *rqstp,
-- 
2.43.0



