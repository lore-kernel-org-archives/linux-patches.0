Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5AB345CC4;
	Fri, 21 Nov 2025 13:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731709; cv=none; b=QdULLY84ziXxokyVjb5B7N02krQm4RaR1JVgnr998xH4HOeoWhj69b5+rmBg+nMP8IZc8lvmh9OtocQVYT/B02Od0hBOTiV/irfkRIS3lX2zjb06Tr1QM9fq59my1JJjuRcS/TJj/BOgvpiH6xlCsmB5iBTFdhGgvJZUc5LTyKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731709; c=relaxed/simple;
	bh=PIGL0sp0Z2c81DidEmikLhrJntei1VUc7WR88Hu/XVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhU+GnG0vwepp9hnjpaxKTLH7ypcOy7gXb5fGs80x5DphLfHhZmZ67eDNuCuAHd26CLDe0YjcG7G4PgFv2RdZXLy+/wEhj5ooJeOAvcoqSdHPsqO2qBtECzlTVfkWUWYfFf7R9SDNfjpErC6St45Ue7vAmls/LtI5xlZARdnEQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S2WpPfnb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S2WpPfnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32870C4CEF1;
	Fri, 21 Nov 2025 13:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731709;
	bh=PIGL0sp0Z2c81DidEmikLhrJntei1VUc7WR88Hu/XVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S2WpPfnbHEIlB9hSIyVubt4eEL34eR/6pt4jqMwZCNTNnQJWHlawZBNkR9h7bz8ZG
	 iIPnq5ueO0jPcmJ7VB19sK9qMjzuUBB2Lihh1C6WTfrb5fCXnKcnE7R7N10yUepYxe
	 d6xg4eHmR916KT1zogNQukZJ8H1zEiBsfVgxxpz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Watt <jpewhacker@gmail.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/185] NFS4: Apply delay_retrans to async operations
Date: Fri, 21 Nov 2025 14:10:47 +0100
Message-ID: <20251121130144.605204523@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b0ba9f2bef56b..a4531386c6485 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3612,6 +3612,7 @@ struct nfs4_closedata {
 	} lr;
 	struct nfs_fattr fattr;
 	unsigned long timestamp;
+	unsigned short retrans;
 };
 
 static void nfs4_free_closedata(void *data)
@@ -3640,6 +3641,7 @@ static void nfs4_close_done(struct rpc_task *task, void *data)
 		.state = state,
 		.inode = calldata->inode,
 		.stateid = &calldata->arg.stateid,
+		.retrans = calldata->retrans,
 	};
 
 	if (!nfs4_sequence_done(task, &calldata->res.seq_res))
@@ -3687,6 +3689,7 @@ static void nfs4_close_done(struct rpc_task *task, void *data)
 		default:
 			task->tk_status = nfs4_async_handle_exception(task,
 					server, task->tk_status, &exception);
+			calldata->retrans = exception.retrans;
 			if (exception.retry)
 				goto out_restart;
 	}
@@ -5546,9 +5549,11 @@ static int nfs4_read_done_cb(struct rpc_task *task, struct nfs_pgio_header *hdr)
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
@@ -5662,10 +5667,12 @@ static int nfs4_write_done_cb(struct rpc_task *task,
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
@@ -6677,6 +6684,7 @@ struct nfs4_delegreturndata {
 	struct nfs_fh fh;
 	nfs4_stateid stateid;
 	unsigned long timestamp;
+	unsigned short retrans;
 	struct {
 		struct nfs4_layoutreturn_args arg;
 		struct nfs4_layoutreturn_res res;
@@ -6697,6 +6705,7 @@ static void nfs4_delegreturn_done(struct rpc_task *task, void *calldata)
 		.inode = data->inode,
 		.stateid = &data->stateid,
 		.task_is_privileged = data->args.seq_args.sa_privileged,
+		.retrans = data->retrans,
 	};
 
 	if (!nfs4_sequence_done(task, &data->res.seq_res))
@@ -6768,6 +6777,7 @@ static void nfs4_delegreturn_done(struct rpc_task *task, void *calldata)
 		task->tk_status = nfs4_async_handle_exception(task,
 				data->res.server, task->tk_status,
 				&exception);
+		data->retrans = exception.retrans;
 		if (exception.retry)
 			goto out_restart;
 	}
@@ -7044,6 +7054,7 @@ struct nfs4_unlockdata {
 	struct file_lock fl;
 	struct nfs_server *server;
 	unsigned long timestamp;
+	unsigned short retrans;
 };
 
 static struct nfs4_unlockdata *nfs4_alloc_unlockdata(struct file_lock *fl,
@@ -7098,6 +7109,7 @@ static void nfs4_locku_done(struct rpc_task *task, void *data)
 	struct nfs4_exception exception = {
 		.inode = calldata->lsp->ls_state->inode,
 		.stateid = &calldata->arg.stateid,
+		.retrans = calldata->retrans,
 	};
 
 	if (!nfs4_sequence_done(task, &calldata->res.seq_res))
@@ -7131,6 +7143,7 @@ static void nfs4_locku_done(struct rpc_task *task, void *data)
 			task->tk_status = nfs4_async_handle_exception(task,
 					calldata->server, task->tk_status,
 					&exception);
+			calldata->retrans = exception.retrans;
 			if (exception.retry)
 				rpc_restart_call_prepare(task);
 	}
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index b48d94f099657..b7a08c875514f 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -1660,6 +1660,7 @@ struct nfs_pgio_header {
 	void			*netfs;
 #endif
 
+	unsigned short		retrans;
 	int			pnfs_error;
 	int			error;		/* merge with pnfs_error */
 	unsigned int		good_bytes;	/* boundary of good data */
-- 
2.51.0



