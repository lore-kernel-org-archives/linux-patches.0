Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91C36D1A9;
	Mon,  8 Apr 2024 13:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583552; cv=none; b=n/zwZFbG0jtOaqpp8JikXhEpeWvYIC47J0sKReu/M329tvkhw/wSZv+GiOQEFhdnAX4TmzggtssgbetEaIxaFFduQNika4L8SVrV5iMGtd/y37oFN/S00L6aVw3R9CQvnI8WxXdXwpmmDYwreujTyh+7EZcvblXaIw5Qqi6wDIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583552; c=relaxed/simple;
	bh=/BmD/n2xLHhjeZHzEAgyr2vMzF5367wfxHu34ridcuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8+NjklnotUf/5nWsKmSj8XY8mizYWPIbRfueYxvVK+EMJXcbiioHZCLRnh+WMlxONc8XzCj/w+vyvmTCsTguFYTCLlLRz+0/2+OhNaXEtt83zbEVyqHKAVwshsHa83jcLTSQ1OjeeSJeX40EXcTIjSsks5q1VAYcuLU9IMybtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ARerbR0q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ARerbR0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521B1C433C7;
	Mon,  8 Apr 2024 13:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583552;
	bh=/BmD/n2xLHhjeZHzEAgyr2vMzF5367wfxHu34ridcuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ARerbR0qLCVe1M7bKDXNT7Jiw1bKzo+sfZV6L6nUSl/CnS3apl9a3UHNmEIYCsYp5
	 IuxYMQx4NyS9NMpZkcRYEfcZDzwxaUmifPChRnH1FnOv8ySbOuj4a9b5KZjSz9TnYF
	 947TQPUXG8U/DEvCylJ4xfMYYoBFdX8vUBRoeOco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 259/690] nfsd: Add a tracepoint for errors in nfsd4_clone_file_range()
Date: Mon,  8 Apr 2024 14:52:05 +0200
Message-ID: <20240408125409.002586035@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit a2f4c3fa4db94ba44d32a72201927cfd132a8e82 ]

Since a clone error commit can cause the boot verifier to change,
we should trace those errors.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
[ cel: Addressed a checkpatch.pl splat in fs/nfsd/vfs.h ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4proc.c |  2 +-
 fs/nfsd/trace.h    | 50 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/nfsd/vfs.c      | 18 +++++++++++++++--
 fs/nfsd/vfs.h      |  3 ++-
 4 files changed, 69 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 002473c59fc6f..861af46ebc6cf 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1108,7 +1108,7 @@ nfsd4_clone(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	if (status)
 		goto out;
 
-	status = nfsd4_clone_file_range(src, clone->cl_src_pos,
+	status = nfsd4_clone_file_range(rqstp, src, clone->cl_src_pos,
 			dst, clone->cl_dst_pos, clone->cl_count,
 			EX_ISSYNC(cstate->current_fh.fh_export));
 
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 1c98a0f857498..52c4a4e001729 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -399,6 +399,56 @@ TRACE_EVENT(nfsd_dirent,
 	)
 )
 
+DECLARE_EVENT_CLASS(nfsd_copy_err_class,
+	TP_PROTO(struct svc_rqst *rqstp,
+		 struct svc_fh	*src_fhp,
+		 loff_t		src_offset,
+		 struct svc_fh	*dst_fhp,
+		 loff_t		dst_offset,
+		 u64		count,
+		 int		status),
+	TP_ARGS(rqstp, src_fhp, src_offset, dst_fhp, dst_offset, count, status),
+	TP_STRUCT__entry(
+		__field(u32, xid)
+		__field(u32, src_fh_hash)
+		__field(loff_t, src_offset)
+		__field(u32, dst_fh_hash)
+		__field(loff_t, dst_offset)
+		__field(u64, count)
+		__field(int, status)
+	),
+	TP_fast_assign(
+		__entry->xid = be32_to_cpu(rqstp->rq_xid);
+		__entry->src_fh_hash = knfsd_fh_hash(&src_fhp->fh_handle);
+		__entry->src_offset = src_offset;
+		__entry->dst_fh_hash = knfsd_fh_hash(&dst_fhp->fh_handle);
+		__entry->dst_offset = dst_offset;
+		__entry->count = count;
+		__entry->status = status;
+	),
+	TP_printk("xid=0x%08x src_fh_hash=0x%08x src_offset=%lld "
+			"dst_fh_hash=0x%08x dst_offset=%lld "
+			"count=%llu status=%d",
+		  __entry->xid, __entry->src_fh_hash, __entry->src_offset,
+		  __entry->dst_fh_hash, __entry->dst_offset,
+		  (unsigned long long)__entry->count,
+		  __entry->status)
+)
+
+#define DEFINE_NFSD_COPY_ERR_EVENT(name)		\
+DEFINE_EVENT(nfsd_copy_err_class, nfsd_##name,		\
+	TP_PROTO(struct svc_rqst	*rqstp,		\
+		 struct svc_fh		*src_fhp,	\
+		 loff_t			src_offset,	\
+		 struct svc_fh		*dst_fhp,	\
+		 loff_t			dst_offset,	\
+		 u64			count,		\
+		 int			status),	\
+	TP_ARGS(rqstp, src_fhp, src_offset, dst_fhp, dst_offset, \
+		count, status))
+
+DEFINE_NFSD_COPY_ERR_EVENT(clone_file_range_err);
+
 #include "state.h"
 #include "filecache.h"
 #include "vfs.h"
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 17985d868887a..721cf315551ad 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -40,6 +40,7 @@
 #include "../internal.h"
 #include "acl.h"
 #include "idmap.h"
+#include "xdr4.h"
 #endif /* CONFIG_NFSD_V4 */
 
 #include "nfsd.h"
@@ -523,8 +524,15 @@ __be32 nfsd4_set_nfs4_label(struct svc_rqst *rqstp, struct svc_fh *fhp,
 }
 #endif
 
-__be32 nfsd4_clone_file_range(struct nfsd_file *nf_src, u64 src_pos,
-		struct nfsd_file *nf_dst, u64 dst_pos, u64 count, bool sync)
+static struct nfsd4_compound_state *nfsd4_get_cstate(struct svc_rqst *rqstp)
+{
+	return &((struct nfsd4_compoundres *)rqstp->rq_resp)->cstate;
+}
+
+__be32 nfsd4_clone_file_range(struct svc_rqst *rqstp,
+		struct nfsd_file *nf_src, u64 src_pos,
+		struct nfsd_file *nf_dst, u64 dst_pos,
+		u64 count, bool sync)
 {
 	struct file *src = nf_src->nf_file;
 	struct file *dst = nf_dst->nf_file;
@@ -551,6 +559,12 @@ __be32 nfsd4_clone_file_range(struct nfsd_file *nf_src, u64 src_pos,
 		if (!status)
 			status = commit_inode_metadata(file_inode(src));
 		if (status < 0) {
+			trace_nfsd_clone_file_range_err(rqstp,
+					&nfsd4_get_cstate(rqstp)->save_fh,
+					src_pos,
+					&nfsd4_get_cstate(rqstp)->current_fh,
+					dst_pos,
+					count, status);
 			nfsd_reset_boot_verifier(net_generic(nf_dst->nf_net,
 						 nfsd_net_id));
 			ret = nfserrno(status);
diff --git a/fs/nfsd/vfs.h b/fs/nfsd/vfs.h
index 3cf5a8a13da50..2c43d10e3cab4 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -57,7 +57,8 @@ __be32          nfsd4_set_nfs4_label(struct svc_rqst *, struct svc_fh *,
 		    struct xdr_netobj *);
 __be32		nfsd4_vfs_fallocate(struct svc_rqst *, struct svc_fh *,
 				    struct file *, loff_t, loff_t, int);
-__be32		nfsd4_clone_file_range(struct nfsd_file *nf_src, u64 src_pos,
+__be32		nfsd4_clone_file_range(struct svc_rqst *rqstp,
+				       struct nfsd_file *nf_src, u64 src_pos,
 				       struct nfsd_file *nf_dst, u64 dst_pos,
 				       u64 count, bool sync);
 #endif /* CONFIG_NFSD_V4 */
-- 
2.43.0



