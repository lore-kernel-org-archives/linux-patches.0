Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E78C6EB72;
	Mon,  8 Apr 2024 13:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584407; cv=none; b=A6BUcnaYD8OWyDO08m4wFp4Z24VoSEkVEXa380BolIHxezbUuvgGzlzbLmd3QIMiHqTy0jAFaZbzZKYCInxLOrPNeB4PGYWgIocZkpybTaIByDM5hg+W0gC6CVlCYShhRPFwzSVqjiYdBbsbSYCZrg7WeTFXckIrVx43NMjaQeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584407; c=relaxed/simple;
	bh=cWOjhagEYoWrzQbWynYvpFEjMCicnDmYYVVI0LIejh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YiyVyu3psF0qoEFU+QRKTkZPE76RJoVxr45praCSTMhTSY0iKQKG9TyvdOA31Ev+ARab3UdkJHTNNUIS/+Hb9gTdsmySKyDVbeLm1ckEKv4axP0qiYMoA6mqPKDEBCb3kpDNJfO2cWUZSRw/Jgi7pmdh6nGRAajndn88Sr/o6DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZiiNs7mK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZiiNs7mK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4EAC433C7;
	Mon,  8 Apr 2024 13:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584407;
	bh=cWOjhagEYoWrzQbWynYvpFEjMCicnDmYYVVI0LIejh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZiiNs7mK4v93bbuwb0G2ZO8Vs5omhsFRLA9p8bn/KTlvoJkWawDpYaiPn++bG7yyz
	 d/OUGn+j1Td0P4r4fQpn5ZRHiw8WM10GuIvfbp+n5w/jzvp+2dvd7x4zaO3GWW5KBr
	 K5MioR0XQHzit2t8mc83QreWhG3aujtC6zafAfvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.15 428/690] NFSD: Add tracepoints to report NFSv4 callback completions
Date: Mon,  8 Apr 2024 14:54:54 +0200
Message-ID: <20240408125415.099637969@linuxfoundation.org>
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

[ Upstream commit 1035d65446a018ca2dd179e29a2fcd6d29057781 ]

Wireshark has always been lousy about dissecting NFSv4 callbacks,
especially NFSv4.0 backchannel requests. Add tracepoints so we
can surgically capture these events in the trace log.

Tracepoints are time-stamped and ordered so that we can now observe
the timing relationship between a CB_RECALL Reply and the client's
DELEGRETURN Call. Example:

            nfsd-1153  [002]   211.986391: nfsd_cb_recall:       addr=192.168.1.67:45767 client 62ea82e4:fee7492a stateid 00000003:00000001

            nfsd-1153  [002]   212.095634: nfsd_compound:        xid=0x0000002c opcnt=2
            nfsd-1153  [002]   212.095647: nfsd_compound_status: op=1/2 OP_PUTFH status=0
            nfsd-1153  [002]   212.095658: nfsd_file_put:        hash=0xf72 inode=0xffff9291148c7410 ref=3 flags=HASHED|REFERENCED may=READ file=0xffff929103b3ea00
            nfsd-1153  [002]   212.095661: nfsd_compound_status: op=2/2 OP_DELEGRETURN status=0
   kworker/u25:8-148   [002]   212.096713: nfsd_cb_recall_done:  client 62ea82e4:fee7492a stateid 00000003:00000001 status=0

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4layouts.c |  2 +-
 fs/nfsd/nfs4proc.c    |  4 ++++
 fs/nfsd/nfs4state.c   |  4 ++++
 fs/nfsd/trace.h       | 39 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4layouts.c b/fs/nfsd/nfs4layouts.c
index 7018d209b784a..e4e23b2a3e655 100644
--- a/fs/nfsd/nfs4layouts.c
+++ b/fs/nfsd/nfs4layouts.c
@@ -657,7 +657,7 @@ nfsd4_cb_layout_done(struct nfsd4_callback *cb, struct rpc_task *task)
 	ktime_t now, cutoff;
 	const struct nfsd4_layout_ops *ops;
 
-
+	trace_nfsd_cb_layout_done(&ls->ls_stid.sc_stateid, task);
 	switch (task->tk_status) {
 	case 0:
 	case -NFS4ERR_DELAY:
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index e4c0dc577fe35..ce8062c959315 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1604,6 +1604,10 @@ static void nfsd4_cb_offload_release(struct nfsd4_callback *cb)
 static int nfsd4_cb_offload_done(struct nfsd4_callback *cb,
 				 struct rpc_task *task)
 {
+	struct nfsd4_cb_offload *cbo =
+		container_of(cb, struct nfsd4_cb_offload, co_cb);
+
+	trace_nfsd_cb_offload_done(&cbo->co_res.cb_stateid, task);
 	return 1;
 }
 
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 66cf8217ebe57..a0c5658599ead 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -357,6 +357,8 @@ nfsd4_cb_notify_lock_prepare(struct nfsd4_callback *cb)
 static int
 nfsd4_cb_notify_lock_done(struct nfsd4_callback *cb, struct rpc_task *task)
 {
+	trace_nfsd_cb_notify_lock_done(&zero_stateid, task);
+
 	/*
 	 * Since this is just an optimization, we don't try very hard if it
 	 * turns out not to succeed. We'll requeue it on NFS4ERR_DELAY, and
@@ -4760,6 +4762,8 @@ static int nfsd4_cb_recall_done(struct nfsd4_callback *cb,
 {
 	struct nfs4_delegation *dp = cb_to_delegation(cb);
 
+	trace_nfsd_cb_recall_done(&dp->dl_stid.sc_stateid, task);
+
 	if (dp->dl_stid.sc_type == NFS4_CLOSED_DELEG_STID ||
 	    dp->dl_stid.sc_type == NFS4_REVOKED_DELEG_STID)
 	        return 1;
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index c5d4a258680c3..d832429e575e4 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -1449,6 +1449,45 @@ TRACE_EVENT(nfsd_cb_offload,
 		__entry->fh_hash, __entry->count, __entry->status)
 );
 
+DECLARE_EVENT_CLASS(nfsd_cb_done_class,
+	TP_PROTO(
+		const stateid_t *stp,
+		const struct rpc_task *task
+	),
+	TP_ARGS(stp, task),
+	TP_STRUCT__entry(
+		__field(u32, cl_boot)
+		__field(u32, cl_id)
+		__field(u32, si_id)
+		__field(u32, si_generation)
+		__field(int, status)
+	),
+	TP_fast_assign(
+		__entry->cl_boot = stp->si_opaque.so_clid.cl_boot;
+		__entry->cl_id = stp->si_opaque.so_clid.cl_id;
+		__entry->si_id = stp->si_opaque.so_id;
+		__entry->si_generation = stp->si_generation;
+		__entry->status = task->tk_status;
+	),
+	TP_printk("client %08x:%08x stateid %08x:%08x status=%d",
+		__entry->cl_boot, __entry->cl_id, __entry->si_id,
+		__entry->si_generation, __entry->status
+	)
+);
+
+#define DEFINE_NFSD_CB_DONE_EVENT(name)			\
+DEFINE_EVENT(nfsd_cb_done_class, name,			\
+	TP_PROTO(					\
+		const stateid_t *stp,			\
+		const struct rpc_task *task		\
+	),						\
+	TP_ARGS(stp, task))
+
+DEFINE_NFSD_CB_DONE_EVENT(nfsd_cb_recall_done);
+DEFINE_NFSD_CB_DONE_EVENT(nfsd_cb_notify_lock_done);
+DEFINE_NFSD_CB_DONE_EVENT(nfsd_cb_layout_done);
+DEFINE_NFSD_CB_DONE_EVENT(nfsd_cb_offload_done);
+
 #endif /* _NFSD_TRACE_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.43.0



