Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F52F158DC1;
	Tue, 18 Jun 2024 13:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716426; cv=none; b=qJSuepgGmq7pP3WILxAkBMIT74744bXStDUtpJG31tIdD6H2gi5SOw6KLqoU3KYAzdrxmFvdxlagucwo38fJ3gb2Uv1hYW1U9Zg3y11wva0j9O29wvqfqY0oF91PNZ8+MPj2RUBV6tcBol9GZoV5KSmb1bUfXwCVkDWVKWihPRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716426; c=relaxed/simple;
	bh=9PS6vKVTsOASLywKoXIWFBYq75Iwx4PzAgq9YkCkaqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PD/H6q1cEDyzqrNspHuzA1+ohvya6KuknQbGC/lWWrDZeltJtfFGXtMZQUqbQw2i9V95c5UQoabDoVyr2F1etQTroi0k2UedWR9LGBonlG/xppVOeLgOZ92aSLx+Lm2IvEUEHz9iqehXSJQpbBRY1pkr02gUUKIvA+5r7eH5Llo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wlXhOJCh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wlXhOJCh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF85C3277B;
	Tue, 18 Jun 2024 13:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716425;
	bh=9PS6vKVTsOASLywKoXIWFBYq75Iwx4PzAgq9YkCkaqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wlXhOJCh3BU71ktRokUmBtkKBxUaNqeqGnUiGAhDvGPkZcoUKVRQNbp8a8k0MulJw
	 UMR5YlbN5PFVFJcZlNYAlFIqOALV0jlwXCHx/Pq/hb4aRuwYf9C5jtCI6Sme2IVF8b
	 2HGn07+t4hyem3uOTzZC4eS1SqUZN0O8bZtbnWOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 642/770] NFSD: Add a mechanism to wait for a DELEGRETURN
Date: Tue, 18 Jun 2024 14:38:15 +0200
Message-ID: <20240618123432.070445398@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 30 ++++++++++++++++++++++++++++++
 fs/nfsd/nfsd.h      |  7 +++++++
 fs/nfsd/trace.h     | 23 +++++++++++++++++++++++
 3 files changed, 60 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 8bbff388e4f03..2bb78ab4f6c31 100644
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
@@ -6811,6 +6840,7 @@ nfsd4_delegreturn(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
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
index 0ee4220a289a0..6803ac877ff70 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -454,6 +454,29 @@ DEFINE_NFSD_COPY_ERR_EVENT(clone_file_range_err);
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



