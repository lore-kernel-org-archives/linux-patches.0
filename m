Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB062EA46B;
	Fri, 21 Nov 2025 13:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730931; cv=none; b=DhaS63N91UvGGPpmVd1PIJlcT0iEbNdv1T/fjPHNF1uw0i06uZRA+cC0nau2RfXk+fuUdoxl15W0INgAM+o3Y+2AESI4pkRZQzeZ35YXWZN80OXt7F8crdQbOKoEwfRGspZPxitMq/McTax6Z0PLAHUUq1xFrE+W3xc2DHbzMJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730931; c=relaxed/simple;
	bh=tVye0QXRpCstWaOoi7YEGyzQ32WYtez70NJex5LcEPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFSZh5pNXc4vrsgQUi+Kqp1eghWuig2yu3ttZW8OSb5DlMzGPxoPuldhAwwnY1iRlQLMRLUoZptyg+qpPyTJEAACpQZGy/WHKooG1sGHt4VsiKhu468DahtIIqa8YfPeaG7HWFzB2iFElIX7aAyhdvw351y0L8IcbD/Dq+WPlTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KVgzGhnI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVgzGhnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B149C4CEF1;
	Fri, 21 Nov 2025 13:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730930;
	bh=tVye0QXRpCstWaOoi7YEGyzQ32WYtez70NJex5LcEPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KVgzGhnIdWGAcPdtzJ/WgwaMOeWVQzlxuw6szcTbcJh9ZbO8L+Qvt8M46D+khRFUs
	 cL2dHvcLOoIPnDqrdw88fZrnNh4CvkwjXBTWy10gUhP8Yih3jd8pjQcvv1vTiUi+jH
	 BHTLnfjXJBhwewpY4txcwAgna1Fdrrax1Q0kL0GY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Watt <jpewhacker@gmail.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 031/247] NFS4: Apply delay_retrans to async operations
Date: Fri, 21 Nov 2025 14:09:38 +0100
Message-ID: <20251121130155.721506734@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Watt <jpewhacker@gmail.com>

[ Upstream commit 7a84394f02ab1985ebbe0a8d6f6d69bd040de4b3 ]

The setting of delay_retrans is applied to synchronous RPC operations
because the retransmit count is stored in same struct nfs4_exception
that is passed each time an error is checked. However, for asynchronous
operations (READ, WRITE, LOCKU, CLOSE, DELEGRETURN), a new struct
nfs4_exception is made on the stack each time the task callback is
invoked. This means that the retransmit count is always zero and thus
delay_retrans never takes effect.

Apply delay_retrans to these operations by tracking and updating their
retransmit count.

Change-Id: Ieb33e046c2b277cb979caa3faca7f52faf0568c9
Signed-off-by: Joshua Watt <jpewhacker@gmail.com>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c       | 13 +++++++++++++
 include/linux/nfs_xdr.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index b76da06864e53..e5fa29dcdd114 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3636,6 +3636,7 @@ struct nfs4_closedata {
 	} lr;
 	struct nfs_fattr fattr;
 	unsigned long timestamp;
+	unsigned short retrans;
 };
 
 static void nfs4_free_closedata(void *data)
@@ -3664,6 +3665,7 @@ static void nfs4_close_done(struct rpc_task *task, void *data)
 		.state = state,
 		.inode = calldata->inode,
 		.stateid = &calldata->arg.stateid,
+		.retrans = calldata->retrans,
 	};
 
 	if (!nfs4_sequence_done(task, &calldata->res.seq_res))
@@ -3711,6 +3713,7 @@ static void nfs4_close_done(struct rpc_task *task, void *data)
 		default:
 			task->tk_status = nfs4_async_handle_exception(task,
 					server, task->tk_status, &exception);
+			calldata->retrans = exception.retrans;
 			if (exception.retry)
 				goto out_restart;
 	}
@@ -5593,9 +5596,11 @@ static int nfs4_read_done_cb(struct rpc_task *task, struct nfs_pgio_header *hdr)
 			.inode = hdr->inode,
 			.state = hdr->args.context->state,
 			.stateid = &hdr->args.stateid,
+			.retrans = hdr->retrans,
 		};
 		task->tk_status = nfs4_async_handle_exception(task,
 				server, task->tk_status, &exception);
+		hdr->retrans = exception.retrans;
 		if (exception.retry) {
 			rpc_restart_call_prepare(task);
 			return -EAGAIN;
@@ -5709,10 +5714,12 @@ static int nfs4_write_done_cb(struct rpc_task *task,
 			.inode = hdr->inode,
 			.state = hdr->args.context->state,
 			.stateid = &hdr->args.stateid,
+			.retrans = hdr->retrans,
 		};
 		task->tk_status = nfs4_async_handle_exception(task,
 				NFS_SERVER(inode), task->tk_status,
 				&exception);
+		hdr->retrans = exception.retrans;
 		if (exception.retry) {
 			rpc_restart_call_prepare(task);
 			return -EAGAIN;
@@ -6726,6 +6733,7 @@ struct nfs4_delegreturndata {
 	struct nfs_fh fh;
 	nfs4_stateid stateid;
 	unsigned long timestamp;
+	unsigned short retrans;
 	struct {
 		struct nfs4_layoutreturn_args arg;
 		struct nfs4_layoutreturn_res res;
@@ -6746,6 +6754,7 @@ static void nfs4_delegreturn_done(struct rpc_task *task, void *calldata)
 		.inode = data->inode,
 		.stateid = &data->stateid,
 		.task_is_privileged = data->args.seq_args.sa_privileged,
+		.retrans = data->retrans,
 	};
 
 	if (!nfs4_sequence_done(task, &data->res.seq_res))
@@ -6817,6 +6826,7 @@ static void nfs4_delegreturn_done(struct rpc_task *task, void *calldata)
 		task->tk_status = nfs4_async_handle_exception(task,
 				data->res.server, task->tk_status,
 				&exception);
+		data->retrans = exception.retrans;
 		if (exception.retry)
 			goto out_restart;
 	}
@@ -7093,6 +7103,7 @@ struct nfs4_unlockdata {
 	struct file_lock fl;
 	struct nfs_server *server;
 	unsigned long timestamp;
+	unsigned short retrans;
 };
 
 static struct nfs4_unlockdata *nfs4_alloc_unlockdata(struct file_lock *fl,
@@ -7147,6 +7158,7 @@ static void nfs4_locku_done(struct rpc_task *task, void *data)
 	struct nfs4_exception exception = {
 		.inode = calldata->lsp->ls_state->inode,
 		.stateid = &calldata->arg.stateid,
+		.retrans = calldata->retrans,
 	};
 
 	if (!nfs4_sequence_done(task, &calldata->res.seq_res))
@@ -7180,6 +7192,7 @@ static void nfs4_locku_done(struct rpc_task *task, void *data)
 			task->tk_status = nfs4_async_handle_exception(task,
 					calldata->server, task->tk_status,
 					&exception);
+			calldata->retrans = exception.retrans;
 			if (exception.retry)
 				rpc_restart_call_prepare(task);
 	}
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index ac4bff6e99135..ea437e468a91c 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -1659,6 +1659,7 @@ struct nfs_pgio_header {
 	void			*netfs;
 #endif
 
+	unsigned short		retrans;
 	int			pnfs_error;
 	int			error;		/* merge with pnfs_error */
 	unsigned int		good_bytes;	/* boundary of good data */
-- 
2.51.0



