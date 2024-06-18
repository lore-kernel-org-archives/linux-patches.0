Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF2016CD3C;
	Tue, 18 Jun 2024 13:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715671; cv=none; b=oSqc+GS4xwqT2ZqXbxqQJN9CP2BgAG+snFmrPWH3+eGGV+lh4Cs0XFf7lUG5+FDpsDcIjlWEDTWcKAdl1H8ve9OYgUU2/jajp/W7JyPNyF20YltUr7ADQmhp5Mi6FfYN+3RfGHRwL1wWGJ1n1WB7VPOGOHg82HkjGKqdYg6nvNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715671; c=relaxed/simple;
	bh=6F1ZCo2rYcdJRyPwE3J0VRWk8vJTcgeTMJNXcCEb7xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uml38XcE5WHfncEj4E+rsKz3zrum073GsRgkwTUM7eriBTGlXx+cckHrW7kBRfZ2c8rtmAbXM1knu22cGy9kXOh1HFI+IfYQl85GSau7HimdhoHyaVdyYQPDnGjYQmD1fRUg/hdqktbeZlZkpHlm2ZYvhOcN4pCzf/f9NVoOsPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XqM7bX6O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XqM7bX6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61C6C3277B;
	Tue, 18 Jun 2024 13:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715671;
	bh=6F1ZCo2rYcdJRyPwE3J0VRWk8vJTcgeTMJNXcCEb7xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XqM7bX6O8jM+a4E7VODAWKkXXwZF9p//5/96xxfhjt3EeWqcm6kqO4qtAegWf1Dd0
	 rVWDPP/qJwM1AV5T/bfCHy9tl1L1RL/K3rAVxSm9iU7dBhzOMmQYsxs50Vrt/Zk7Rk
	 mjM93xN7NvJf+TvYrSVP0a9arYKrLVlL7e775L8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 388/770] SUNRPC: Trace calls to .rpc_call_done
Date: Tue, 18 Jun 2024 14:34:01 +0200
Message-ID: <20240618123422.253999885@linuxfoundation.org>
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

[ Upstream commit b40887e10dcacc5e8ae3c1a99dcba20877c4831b ]

Introduce a single tracepoint that can replace simple dprintk call
sites in upper layer "rpc_call_done" callbacks. Example:

   kworker/u24:2-1254  [001]   771.026677: rpc_stats_latency:    task:00000001@00000002 xid=0x16a6f3c0 rpcbindv2 GETPORT backlog=446 rtt=101 execute=555
   kworker/u24:2-1254  [001]   771.026677: rpc_task_call_done:   task:00000001@00000002 flags=ASYNC|DYNAMIC|SOFT|SOFTCONN|SENT runstate=RUNNING|ACTIVE status=0 action=rpcb_getport_done
   kworker/u24:2-1254  [001]   771.026678: rpcb_setport:         task:00000001@00000002 status=0 port=20048

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/clntproc.c                    | 3 ---
 fs/lockd/svc4proc.c                    | 2 --
 fs/lockd/svcproc.c                     | 2 --
 fs/nfs/filelayout/filelayout.c         | 2 --
 fs/nfs/flexfilelayout/flexfilelayout.c | 2 --
 fs/nfs/pagelist.c                      | 3 ---
 fs/nfs/write.c                         | 3 ---
 include/trace/events/sunrpc.h          | 1 +
 net/sunrpc/sched.c                     | 1 +
 9 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/fs/lockd/clntproc.c b/fs/lockd/clntproc.c
index b11f2afa84f1f..99fffc9cb9585 100644
--- a/fs/lockd/clntproc.c
+++ b/fs/lockd/clntproc.c
@@ -794,9 +794,6 @@ static void nlmclnt_cancel_callback(struct rpc_task *task, void *data)
 		goto retry_cancel;
 	}
 
-	dprintk("lockd: cancel status %u (task %u)\n",
-			status, task->tk_pid);
-
 	switch (status) {
 	case NLM_LCK_GRANTED:
 	case NLM_LCK_DENIED_GRACE_PERIOD:
diff --git a/fs/lockd/svc4proc.c b/fs/lockd/svc4proc.c
index e10ae2c41279e..176b468a61c75 100644
--- a/fs/lockd/svc4proc.c
+++ b/fs/lockd/svc4proc.c
@@ -269,8 +269,6 @@ nlm4svc_proc_granted(struct svc_rqst *rqstp)
  */
 static void nlm4svc_callback_exit(struct rpc_task *task, void *data)
 {
-	dprintk("lockd: %5u callback returned %d\n", task->tk_pid,
-			-task->tk_status);
 }
 
 static void nlm4svc_callback_release(void *data)
diff --git a/fs/lockd/svcproc.c b/fs/lockd/svcproc.c
index 99696d3f6dd66..4dc1b40a489a2 100644
--- a/fs/lockd/svcproc.c
+++ b/fs/lockd/svcproc.c
@@ -301,8 +301,6 @@ nlmsvc_proc_granted(struct svc_rqst *rqstp)
  */
 static void nlmsvc_callback_exit(struct rpc_task *task, void *data)
 {
-	dprintk("lockd: %5u callback returned %d\n", task->tk_pid,
-			-task->tk_status);
 }
 
 void nlmsvc_release_call(struct nlm_rqst *call)
diff --git a/fs/nfs/filelayout/filelayout.c b/fs/nfs/filelayout/filelayout.c
index 45eec08ec904f..2ed8b6885b091 100644
--- a/fs/nfs/filelayout/filelayout.c
+++ b/fs/nfs/filelayout/filelayout.c
@@ -293,8 +293,6 @@ static void filelayout_read_call_done(struct rpc_task *task, void *data)
 {
 	struct nfs_pgio_header *hdr = data;
 
-	dprintk("--> %s task->tk_status %d\n", __func__, task->tk_status);
-
 	if (test_bit(NFS_IOHDR_REDO, &hdr->flags) &&
 	    task->tk_status == 0) {
 		nfs41_sequence_done(task, &hdr->res.seq_res);
diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index f2ae271fe7ec7..a263bfec4244d 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -1419,8 +1419,6 @@ static void ff_layout_read_call_done(struct rpc_task *task, void *data)
 {
 	struct nfs_pgio_header *hdr = data;
 
-	dprintk("--> %s task->tk_status %d\n", __func__, task->tk_status);
-
 	if (test_bit(NFS_IOHDR_REDO, &hdr->flags) &&
 	    task->tk_status == 0) {
 		nfs4_sequence_done(task, &hdr->res.seq_res);
diff --git a/fs/nfs/pagelist.c b/fs/nfs/pagelist.c
index 17fef6eb490c5..d79a3b6cb0701 100644
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -870,9 +870,6 @@ static void nfs_pgio_result(struct rpc_task *task, void *calldata)
 	struct nfs_pgio_header *hdr = calldata;
 	struct inode *inode = hdr->inode;
 
-	dprintk("NFS: %s: %5u, (status %d)\n", __func__,
-		task->tk_pid, task->tk_status);
-
 	if (hdr->rw_ops->rw_done(task, hdr, inode) != 0)
 		return;
 	if (task->tk_status < 0)
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 4cf0606919794..2bde35921f2b2 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1809,9 +1809,6 @@ static void nfs_commit_done(struct rpc_task *task, void *calldata)
 {
 	struct nfs_commit_data	*data = calldata;
 
-        dprintk("NFS: %5u nfs_commit_done (status %d)\n",
-                                task->tk_pid, task->tk_status);
-
 	/* Call the NFS version-specific code */
 	NFS_PROTO(data->inode)->commit_done(task, data);
 	trace_nfs_commit_done(task, data);
diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index fce071f39f51f..56e4a57d25382 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -394,6 +394,7 @@ DEFINE_RPC_RUNNING_EVENT(complete);
 DEFINE_RPC_RUNNING_EVENT(timeout);
 DEFINE_RPC_RUNNING_EVENT(signalled);
 DEFINE_RPC_RUNNING_EVENT(end);
+DEFINE_RPC_RUNNING_EVENT(call_done);
 
 DECLARE_EVENT_CLASS(rpc_task_queued,
 
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index a00890962e115..a4c9d410eb8d5 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -821,6 +821,7 @@ void rpc_exit_task(struct rpc_task *task)
 	else if (task->tk_client)
 		rpc_count_iostats(task, task->tk_client->cl_metrics);
 	if (task->tk_ops->rpc_call_done != NULL) {
+		trace_rpc_task_call_done(task, task->tk_ops->rpc_call_done);
 		task->tk_ops->rpc_call_done(task, task->tk_calldata);
 		if (task->tk_action != NULL) {
 			/* Always release the RPC slot and buffer memory */
-- 
2.43.0



