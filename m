Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2B56EB72;
	Mon,  8 Apr 2024 13:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584410; cv=none; b=dKHj8Nm/YiTx1bm7DyF79qrD5/z7mnWs3x5sWtiM0Mn6OLqtRwl8Bh5E76QU7yJuU7PURLKXAp2CTlW+fM0tZ+DhbAtu/FvfYv6pcruS+aX0F0L+HNEks9DFZIYr5dimZieiKevUBAOXw2wefLIbWzERyyUazGe9Y2Ot+aK5yAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584410; c=relaxed/simple;
	bh=taLhaOU4tF+R17HE4kzeYFMLLuRayI7MYwPfS0faN1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7UM8bYpttkeDOWlpfdkSEWhTXbQxjHmoiDjArspf0Bt1AvsP1tkQYciNM1urskjufc508vTKiM4ASYxCp6W6GppdUrlbJfxtM0J0CjhS45qU4hvMoLpAtIQbCTxvY5GAxjV1G7wkYNMTnjA0N+baHJgdeBj8eqtNB5EcMV879c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/Z/afKl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/Z/afKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC60C433C7;
	Mon,  8 Apr 2024 13:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584410;
	bh=taLhaOU4tF+R17HE4kzeYFMLLuRayI7MYwPfS0faN1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/Z/afKlO4rgoy9Mwv5bUlk0IsMBXbvv3Y6BrkfPomjtHgGoTMnfpKxQiY/CC22rx
	 8j3RkrhmVSv4Hkyl9QHn3cwsDdvkC9EUuYpcu2rBv3zoscvW7K+caXeQNEY/dZvFcu
	 8U72rRUy8nM7wcBVryrpqRsdkmbP2Ri5usZoFRCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 429/690] NFSD: Add a mechanism to wait for a DELEGRETURN
Date: Mon,  8 Apr 2024 14:54:55 +0200
Message-ID: <20240408125415.135625578@linuxfoundation.org>
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

[ Upstream commit c035362eb935fe9381d9d1cc453bc2a37460e24c ]

Subsequent patches will use this mechanism to wake up an operation
that is waiting for a client to return a delegation.

The new tracepoint records whether the wait timed out or was
properly awoken by the expected DELEGRETURN:

            nfsd-1155  [002] 83799.493199: nfsd_delegret_wakeup: xid=0x14b7d6ef fh_hash=0xf6826792 (timed out)

Suggested-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4state.c | 30 ++++++++++++++++++++++++++++++
 fs/nfsd/nfsd.h      |  7 +++++++
 fs/nfsd/trace.h     | 23 +++++++++++++++++++++++
 3 files changed, 60 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index a0c5658599ead..6cb654e308787 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4734,6 +4734,35 @@ nfs4_share_conflict(struct svc_fh *current_fh, unsigned int deny_type)
 	return ret;
 }
 
+static bool nfsd4_deleg_present(const struct inode *inode)
+{
+	struct file_lock_context *ctx = smp_load_acquire(&inode->i_flctx);
+
+	return ctx && !list_empty_careful(&ctx->flc_lease);
+}
+
+/**
+ * nfsd_wait_for_delegreturn - wait for delegations to be returned
+ * @rqstp: the RPC transaction being executed
+ * @inode: in-core inode of the file being waited for
+ *
+ * The timeout prevents deadlock if all nfsd threads happen to be
+ * tied up waiting for returning delegations.
+ *
+ * Return values:
+ *   %true: delegation was returned
+ *   %false: timed out waiting for delegreturn
+ */
+bool nfsd_wait_for_delegreturn(struct svc_rqst *rqstp, struct inode *inode)
+{
+	long __maybe_unused timeo;
+
+	timeo = wait_var_event_timeout(inode, !nfsd4_deleg_present(inode),
+				       NFSD_DELEGRETURN_TIMEOUT);
+	trace_nfsd_delegret_wakeup(rqstp, inode, timeo);
+	return timeo > 0;
+}
+
 static void nfsd4_cb_recall_prepare(struct nfsd4_callback *cb)
 {
 	struct nfs4_delegation *dp = cb_to_delegation(cb);
@@ -6797,6 +6826,7 @@ nfsd4_delegreturn(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	if (status)
 		goto put_stateid;
 
+	wake_up_var(d_inode(cstate->current_fh.fh_dentry));
 	destroy_delegation(dp);
 put_stateid:
 	nfs4_put_stid(&dp->dl_stid);
diff --git a/fs/nfsd/nfsd.h b/fs/nfsd/nfsd.h
index 57a468ed85c35..6ab4ad41ae84e 100644
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -164,6 +164,7 @@ char * nfs4_recoverydir(void);
 bool nfsd4_spo_must_allow(struct svc_rqst *rqstp);
 int nfsd4_create_laundry_wq(void);
 void nfsd4_destroy_laundry_wq(void);
+bool nfsd_wait_for_delegreturn(struct svc_rqst *rqstp, struct inode *inode);
 #else
 static inline int nfsd4_init_slabs(void) { return 0; }
 static inline void nfsd4_free_slabs(void) { }
@@ -179,6 +180,11 @@ static inline bool nfsd4_spo_must_allow(struct svc_rqst *rqstp)
 }
 static inline int nfsd4_create_laundry_wq(void) { return 0; };
 static inline void nfsd4_destroy_laundry_wq(void) {};
+static inline bool nfsd_wait_for_delegreturn(struct svc_rqst *rqstp,
+					      struct inode *inode)
+{
+	return false;
+}
 #endif
 
 /*
@@ -343,6 +349,7 @@ void		nfsd_lockd_shutdown(void);
 #define	NFSD_COURTESY_CLIENT_TIMEOUT	(24 * 60 * 60)	/* seconds */
 #define	NFSD_CLIENT_MAX_TRIM_PER_RUN	128
 #define	NFS4_CLIENTS_PER_GB		1024
+#define NFSD_DELEGRETURN_TIMEOUT	(HZ / 34)	/* 30ms */
 
 /*
  * The following attributes are currently not supported by the NFSv4 server:
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index d832429e575e4..1229502b6e9e0 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -538,6 +538,29 @@ DEFINE_NFSD_COPY_ERR_EVENT(clone_file_range_err);
 #include "filecache.h"
 #include "vfs.h"
 
+TRACE_EVENT(nfsd_delegret_wakeup,
+	TP_PROTO(
+		const struct svc_rqst *rqstp,
+		const struct inode *inode,
+		long timeo
+	),
+	TP_ARGS(rqstp, inode, timeo),
+	TP_STRUCT__entry(
+		__field(u32, xid)
+		__field(const void *, inode)
+		__field(long, timeo)
+	),
+	TP_fast_assign(
+		__entry->xid = be32_to_cpu(rqstp->rq_xid);
+		__entry->inode = inode;
+		__entry->timeo = timeo;
+	),
+	TP_printk("xid=0x%08x inode=%p%s",
+		  __entry->xid, __entry->inode,
+		  __entry->timeo == 0 ? " (timed out)" : ""
+	)
+);
+
 DECLARE_EVENT_CLASS(nfsd_stateid_class,
 	TP_PROTO(stateid_t *stp),
 	TP_ARGS(stp),
-- 
2.43.0



