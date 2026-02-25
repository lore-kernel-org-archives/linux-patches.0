Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E14918B0A;
	Wed, 25 Feb 2026 01:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983350; cv=none; b=WZVaQOZY3hrLx4QLVR9qrmUzsc5tRwDlL1fCcftk18ygFeMh/CvVBLDhWWRQ4ZUtMHOZkalC3QyDDPv6tOHFrtp9AccmxunG2yY+XZr72HMzJiW55CrLxPRKNShfBrtc+V/MHtNwUCgTxgasBQeMGs55XnGR8QeWFZIOev5HxdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983350; c=relaxed/simple;
	bh=4GzRTBINmHtpN/cWDWKJVwoh120xq9BiFkh3PBnsxfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+aumNxs3FN9hjIbgHYeZ4uZUqkxK+80gfG0Js1Qc50fujgyz9OqeigIEDyBWyP4oAUKX/tpF5zbndPGhTq+AybW3av+ZgAV8e2dhb5C3A5FzxowuGVU+ZE+kqtMDsgKwQDhXclmV+luFTmc7S84hjdwimWSYBSD36KpHcgeP8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OT9nHcFI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OT9nHcFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8FBC116D0;
	Wed, 25 Feb 2026 01:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983350;
	bh=4GzRTBINmHtpN/cWDWKJVwoh120xq9BiFkh3PBnsxfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OT9nHcFI4pG5q+qVuXlOH9gQzGb4Qpytt6pO4WQJUw0B9eEcHfK3DNuw0ShrDx4Kw
	 ZSl9RPMEp8fDJOH72z6ijBM3V0fiEzlKia9i6OU+9oyBP2aw4wxiDOuON/d+T7cwO+
	 H2q21T9TNSecDi42sfCFt2tD0A5Dr4V4NdzubDMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 477/781] NFS/localio: Handle short writes by retrying
Date: Tue, 24 Feb 2026 17:19:46 -0800
Message-ID: <20260225012411.513020659@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 615762059d284b863f9163b53679d95b3dcdd495 ]

The current code for handling short writes in localio just truncates the
I/O and then sets an error. While that is close to how the ordinary NFS
code behaves, it does mean there is a chance the data that got written
is lost because it isn't persisted.
To fix this, change localio so that the upper layers can direct the
behaviour to persist any unstable data by rewriting it, and then
continuing writing until an ENOSPC is hit.

Fixes: 70ba381e1a43 ("nfs: add LOCALIO support")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/localio.c | 64 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 47 insertions(+), 17 deletions(-)

diff --git a/fs/nfs/localio.c b/fs/nfs/localio.c
index 41fbcb3f9167e..00bbac6c9fe40 100644
--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -58,6 +58,11 @@ struct nfs_local_fsync_ctx {
 static bool localio_enabled __read_mostly = true;
 module_param(localio_enabled, bool, 0644);
 
+static int nfs_local_do_read(struct nfs_local_kiocb *iocb,
+			     const struct rpc_call_ops *call_ops);
+static int nfs_local_do_write(struct nfs_local_kiocb *iocb,
+			      const struct rpc_call_ops *call_ops);
+
 static inline bool nfs_client_is_local(const struct nfs_client *clp)
 {
 	return !!rcu_access_pointer(clp->cl_uuid.net);
@@ -542,13 +547,50 @@ nfs_local_iocb_release(struct nfs_local_kiocb *iocb)
 	nfs_local_iocb_free(iocb);
 }
 
-static void
-nfs_local_pgio_release(struct nfs_local_kiocb *iocb)
+static void nfs_local_pgio_restart(struct nfs_local_kiocb *iocb,
+				   struct nfs_pgio_header *hdr)
+{
+	int status = 0;
+
+	iocb->kiocb.ki_pos = hdr->args.offset;
+	iocb->kiocb.ki_flags &= ~(IOCB_DSYNC | IOCB_SYNC | IOCB_DIRECT);
+	iocb->kiocb.ki_complete = NULL;
+	iocb->aio_complete_work = NULL;
+	iocb->end_iter_index = -1;
+
+	switch (hdr->rw_mode) {
+	case FMODE_READ:
+		nfs_local_iters_init(iocb, ITER_DEST);
+		status = nfs_local_do_read(iocb, hdr->task.tk_ops);
+		break;
+	case FMODE_WRITE:
+		nfs_local_iters_init(iocb, ITER_SOURCE);
+		status = nfs_local_do_write(iocb, hdr->task.tk_ops);
+		break;
+	default:
+		status = -EOPNOTSUPP;
+	}
+
+	if (status != 0) {
+		nfs_local_iocb_release(iocb);
+		hdr->task.tk_status = status;
+		nfs_local_hdr_release(hdr, hdr->task.tk_ops);
+	}
+}
+
+static void nfs_local_pgio_release(struct nfs_local_kiocb *iocb)
 {
 	struct nfs_pgio_header *hdr = iocb->hdr;
+	struct rpc_task *task = &hdr->task;
+
+	task->tk_action = NULL;
+	task->tk_ops->rpc_call_done(task, hdr);
 
-	nfs_local_iocb_release(iocb);
-	nfs_local_hdr_release(hdr, hdr->task.tk_ops);
+	if (task->tk_action == NULL) {
+		nfs_local_iocb_release(iocb);
+		task->tk_ops->rpc_release(hdr);
+	} else
+		nfs_local_pgio_restart(iocb, hdr);
 }
 
 /*
@@ -773,19 +815,7 @@ static void nfs_local_write_done(struct nfs_local_kiocb *iocb)
 		pr_info_ratelimited("nfs: Unexpected direct I/O write alignment failure\n");
 	}
 
-	/* Handle short writes as if they are ENOSPC */
-	status = hdr->res.count;
-	if (status > 0 && status < hdr->args.count) {
-		hdr->mds_offset += status;
-		hdr->args.offset += status;
-		hdr->args.pgbase += status;
-		hdr->args.count -= status;
-		nfs_set_pgio_error(hdr, -ENOSPC, hdr->args.offset);
-		status = -ENOSPC;
-		/* record -ENOSPC in terms of nfs_local_pgio_done */
-		(void) nfs_local_pgio_done(iocb, status, true);
-	}
-	if (hdr->task.tk_status < 0)
+	if (status < 0)
 		nfs_reset_boot_verifier(hdr->inode);
 }
 
-- 
2.51.0



