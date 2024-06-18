Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FABC1586DB;
	Tue, 18 Jun 2024 13:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716267; cv=none; b=TaJ0OJCs6KMOw7OGiw1eMrinLvvXtnIIveM7ZI/ANXTCICiO+jsFxlQHWehFLqMiOmzKoUBVU+B3bRTPt5N0XMwsu15tpP47Tzx0k0LetI++NnWVsDFK6GisLvTTpzuW1DPPvrEkICoWAFtQ/+LmOSJ2hs3EsJEYHm6Or6m6+lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716267; c=relaxed/simple;
	bh=rGkQw2PBRdnsSeKZBpl6mb4m/hLiNApevI3mQuQRJvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsX4fGZ1pMQsg6v2K45vdWwgfBZ6Lo47wapHUvcj3Ms9cedre6YQFfftV+rDE1HowLmw65jH8DgYGcgZcrpD36w7QdXqce7k6hjTDV4fkjge6vMeEgW3P2rK6W9lKDqHv4bnlGs2QXREtd0LikUh1DLOngtJlsxuk/EPn+fnRiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EWe/rJa4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EWe/rJa4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F0FC3277B;
	Tue, 18 Jun 2024 13:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716267;
	bh=rGkQw2PBRdnsSeKZBpl6mb4m/hLiNApevI3mQuQRJvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EWe/rJa4MokDmkD07nStzN8iW+AKCh0b56yAEa1C1TWdRWHYJ5Lz25y1tTpPKsQY/
	 4NxtjljpBNHSjep7/IV9NLQvuPK8vsv8nflxiovqNqozVr5GuJIPOnzQF1y4GVceRV
	 oWHfrUOb/HAc/e78hJHP2SLQIKVVDdu6WAeuO0e4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 581/770] NFSD: Separate tracepoints for acquire and create
Date: Tue, 18 Jun 2024 14:37:14 +0200
Message-ID: <20240618123429.721190857@linuxfoundation.org>
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

[ Upstream commit be0230069fcbf7d332d010b57c1d0cfd623a84d6 ]

These tracepoints collect different information: the create case does
not open a file, so there's no nf_file available.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c |  9 ++++----
 fs/nfsd/nfs4state.c |  1 +
 fs/nfsd/trace.h     | 54 ++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 52 insertions(+), 12 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index c6dc55c0f758b..85813affb8abf 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1039,7 +1039,7 @@ nfsd_file_is_cached(struct inode *inode)
 }
 
 static __be32
-nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
+nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		     unsigned int may_flags, struct nfsd_file **pnf, bool open)
 {
 	struct nfsd_file_lookup_key key = {
@@ -1120,7 +1120,8 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 
 out_status:
 	put_cred(key.cred);
-	trace_nfsd_file_acquire(rqstp, key.inode, may_flags, nf, status);
+	if (open)
+		trace_nfsd_file_acquire(rqstp, key.inode, may_flags, nf, status);
 	return status;
 
 open_file:
@@ -1168,7 +1169,7 @@ __be32
 nfsd_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		  unsigned int may_flags, struct nfsd_file **pnf)
 {
-	return nfsd_do_file_acquire(rqstp, fhp, may_flags, pnf, true);
+	return nfsd_file_do_acquire(rqstp, fhp, may_flags, pnf, true);
 }
 
 /**
@@ -1185,7 +1186,7 @@ __be32
 nfsd_file_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		 unsigned int may_flags, struct nfsd_file **pnf)
 {
-	return nfsd_do_file_acquire(rqstp, fhp, may_flags, pnf, false);
+	return nfsd_file_do_acquire(rqstp, fhp, may_flags, pnf, false);
 }
 
 /*
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 76ec207f5e44d..587e792346579 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5121,6 +5121,7 @@ static __be32 nfs4_get_vfs_file(struct svc_rqst *rqstp, struct nfs4_file *fp,
 				goto out_put_access;
 			nf->nf_file = open->op_filp;
 			open->op_filp = NULL;
+			trace_nfsd_file_create(rqstp, access, nf);
 		}
 
 		spin_lock(&fp->fi_lock);
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 33bd8618c20a6..ce391ba2f1ca5 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -747,10 +747,10 @@ DEFINE_NFSD_FILE_EVENT(nfsd_file_unhash_and_dispose);
 
 TRACE_EVENT(nfsd_file_acquire,
 	TP_PROTO(
-		struct svc_rqst *rqstp,
-		struct inode *inode,
+		const struct svc_rqst *rqstp,
+		const struct inode *inode,
 		unsigned int may_flags,
-		struct nfsd_file *nf,
+		const struct nfsd_file *nf,
 		__be32 status
 	),
 
@@ -758,12 +758,12 @@ TRACE_EVENT(nfsd_file_acquire,
 
 	TP_STRUCT__entry(
 		__field(u32, xid)
-		__field(void *, inode)
+		__field(const void *, inode)
 		__field(unsigned long, may_flags)
-		__field(int, nf_ref)
+		__field(unsigned int, nf_ref)
 		__field(unsigned long, nf_flags)
 		__field(unsigned long, nf_may)
-		__field(struct file *, nf_file)
+		__field(const void *, nf_file)
 		__field(u32, status)
 	),
 
@@ -778,12 +778,50 @@ TRACE_EVENT(nfsd_file_acquire,
 		__entry->status = be32_to_cpu(status);
 	),
 
-	TP_printk("xid=0x%x inode=%p may_flags=%s ref=%d nf_flags=%s nf_may=%s nf_file=%p status=%u",
+	TP_printk("xid=0x%x inode=%p may_flags=%s ref=%u nf_flags=%s nf_may=%s nf_file=%p status=%u",
 			__entry->xid, __entry->inode,
 			show_nfsd_may_flags(__entry->may_flags),
 			__entry->nf_ref, show_nf_flags(__entry->nf_flags),
 			show_nfsd_may_flags(__entry->nf_may),
-			__entry->nf_file, __entry->status)
+			__entry->nf_file, __entry->status
+	)
+);
+
+TRACE_EVENT(nfsd_file_create,
+	TP_PROTO(
+		const struct svc_rqst *rqstp,
+		unsigned int may_flags,
+		const struct nfsd_file *nf
+	),
+
+	TP_ARGS(rqstp, may_flags, nf),
+
+	TP_STRUCT__entry(
+		__field(const void *, nf_inode)
+		__field(const void *, nf_file)
+		__field(unsigned long, may_flags)
+		__field(unsigned long, nf_flags)
+		__field(unsigned long, nf_may)
+		__field(unsigned int, nf_ref)
+		__field(u32, xid)
+	),
+
+	TP_fast_assign(
+		__entry->nf_inode = nf->nf_inode;
+		__entry->nf_file = nf->nf_file;
+		__entry->may_flags = may_flags;
+		__entry->nf_flags = nf->nf_flags;
+		__entry->nf_may = nf->nf_may;
+		__entry->nf_ref = refcount_read(&nf->nf_ref);
+		__entry->xid = be32_to_cpu(rqstp->rq_xid);
+	),
+
+	TP_printk("xid=0x%x inode=%p may_flags=%s ref=%u nf_flags=%s nf_may=%s nf_file=%p",
+		__entry->xid, __entry->nf_inode,
+		show_nfsd_may_flags(__entry->may_flags),
+		__entry->nf_ref, show_nf_flags(__entry->nf_flags),
+		show_nfsd_may_flags(__entry->nf_may), __entry->nf_file
+	)
 );
 
 TRACE_EVENT(nfsd_file_insert_err,
-- 
2.43.0



