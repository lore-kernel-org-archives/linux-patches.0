Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A76F2E0B6A;
	Wed, 17 Sep 2025 12:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113430; cv=none; b=ib70nXBvh4Jsw+fa5CjqDlQZ/MuMdcjYXVZ0ysw+ofNTOEl2fVm8EkpezDSc5JoL9JioiUacXUFSeglYiD2jYJWeqprbJSlA7eIBRwRbBCshbQ2y8QXuoc5/VSPoBcV7p0jDMYTnLqdKis4WtiI+DyxCSakf7UWL/HuZJRyM3qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113430; c=relaxed/simple;
	bh=UFKcQTEwRx4quCoA+xYd2z+16C94cgzy4SSAmXNHBLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpSYh6MFIAoFw3AZNOdpsxCc6Jler2WQ/4JTvb35hEr3koUuhCB2U4L2vww3KOHbYIauWrTnviCSjzCrK1uQgb4wsqnLE8ZoFzeRWPCn9gk3gJ06wHlSFUYz40OGORsaC2rbUazYNoJEC434Bq0hkQh0QVbcWNFYlPg+JTK1ZaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OwWqo3q0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OwWqo3q0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3230BC4CEF5;
	Wed, 17 Sep 2025 12:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113429;
	bh=UFKcQTEwRx4quCoA+xYd2z+16C94cgzy4SSAmXNHBLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OwWqo3q034gja9/S39Eojrq29SHZH5fSjDDe/z3ztKG48q/jyDep6X2Kj3cSXzUWy
	 QyP5dEwHtWgvwC+z58VOJOL303wHm+AOldm69CB0aCNQy75sVx9a+UhKZmCfup5Ess
	 Y3YATSNetQdhw35Qz4ojN5K++vB9rpn+xMptEkoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/140] nfs/localio: add direct IO enablement with sync and async IO support
Date: Wed, 17 Sep 2025 14:33:21 +0200
Message-ID: <20250917123345.019184916@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit 3feec68563dda59517f83d19123aa287a1dfd068 ]

This commit simply adds the required O_DIRECT plumbing.  It doesn't
address the fact that NFS doesn't ensure all writes are page aligned
(nor device logical block size aligned as required by O_DIRECT).

Because NFS will read-modify-write for IO that isn't aligned, LOCALIO
will not use O_DIRECT semantics by default if/when an application
requests the use of O_DIRECT.  Allow the use of O_DIRECT semantics by:
1: Adding a flag to the nfs_pgio_header struct to allow the NFS
   O_DIRECT layer to signal that O_DIRECT was used by the application
2: Adding a 'localio_O_DIRECT_semantics' NFS module parameter that
   when enabled will cause LOCALIO to use O_DIRECT semantics (this may
   cause IO to fail if applications do not properly align their IO).

This commit is derived from code developed by Weston Andros Adamson.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Stable-dep-of: 992203a1fba5 ("nfs/localio: restore creds before releasing pageio data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/nfs/localio.rst | 13 ++++
 fs/nfs/direct.c                           |  1 +
 fs/nfs/localio.c                          | 93 ++++++++++++++++++++---
 include/linux/nfs_xdr.h                   |  1 +
 4 files changed, 98 insertions(+), 10 deletions(-)

diff --git a/Documentation/filesystems/nfs/localio.rst b/Documentation/filesystems/nfs/localio.rst
index bd1967e2eab32..20fc901a08f4d 100644
--- a/Documentation/filesystems/nfs/localio.rst
+++ b/Documentation/filesystems/nfs/localio.rst
@@ -306,6 +306,19 @@ is issuing IO to the underlying local filesystem that it is sharing with
 the NFS server. See: fs/nfs/localio.c:nfs_local_doio() and
 fs/nfs/localio.c:nfs_local_commit().
 
+With normal NFS that makes use of RPC to issue IO to the server, if an
+application uses O_DIRECT the NFS client will bypass the pagecache but
+the NFS server will not. Because the NFS server's use of buffered IO
+affords applications to be less precise with their alignment when
+issuing IO to the NFS client. LOCALIO can be configured to use O_DIRECT
+semantics by setting the 'localio_O_DIRECT_semantics' nfs module
+parameter to Y, e.g.:
+
+  echo Y > /sys/module/nfs/parameters/localio_O_DIRECT_semantics
+
+Once enabled, it will cause LOCALIO to use O_DIRECT semantics (this may
+cause IO to fail if applications do not properly align their IO).
+
 Security
 ========
 
diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index c1f1b826888c9..f159cfc125adc 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -320,6 +320,7 @@ static void nfs_read_sync_pgio_error(struct list_head *head, int error)
 static void nfs_direct_pgio_init(struct nfs_pgio_header *hdr)
 {
 	get_dreq(hdr->dreq);
+	set_bit(NFS_IOHDR_ODIRECT, &hdr->flags);
 }
 
 static const struct nfs_pgio_completion_ops nfs_direct_read_completion_ops = {
diff --git a/fs/nfs/localio.c b/fs/nfs/localio.c
index ab305dfc71269..8fb145124e93b 100644
--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -35,6 +35,7 @@ struct nfs_local_kiocb {
 	struct bio_vec		*bvec;
 	struct nfs_pgio_header	*hdr;
 	struct work_struct	work;
+	void (*aio_complete_work)(struct work_struct *);
 	struct nfsd_file	*localio;
 };
 
@@ -50,6 +51,11 @@ static void nfs_local_fsync_work(struct work_struct *work);
 static bool localio_enabled __read_mostly = true;
 module_param(localio_enabled, bool, 0644);
 
+static bool localio_O_DIRECT_semantics __read_mostly = false;
+module_param(localio_O_DIRECT_semantics, bool, 0644);
+MODULE_PARM_DESC(localio_O_DIRECT_semantics,
+		 "LOCALIO will use O_DIRECT semantics to filesystem.");
+
 static inline bool nfs_client_is_local(const struct nfs_client *clp)
 {
 	return !!test_bit(NFS_CS_LOCAL_IO, &clp->cl_flags);
@@ -287,10 +293,19 @@ nfs_local_iocb_alloc(struct nfs_pgio_header *hdr,
 		kfree(iocb);
 		return NULL;
 	}
-	init_sync_kiocb(&iocb->kiocb, file);
+
+	if (localio_O_DIRECT_semantics &&
+	    test_bit(NFS_IOHDR_ODIRECT, &hdr->flags)) {
+		iocb->kiocb.ki_filp = file;
+		iocb->kiocb.ki_flags = IOCB_DIRECT;
+	} else
+		init_sync_kiocb(&iocb->kiocb, file);
+
 	iocb->kiocb.ki_pos = hdr->args.offset;
 	iocb->hdr = hdr;
 	iocb->kiocb.ki_flags &= ~IOCB_APPEND;
+	iocb->aio_complete_work = NULL;
+
 	return iocb;
 }
 
@@ -345,6 +360,18 @@ nfs_local_pgio_release(struct nfs_local_kiocb *iocb)
 	nfs_local_hdr_release(hdr, hdr->task.tk_ops);
 }
 
+/*
+ * Complete the I/O from iocb->kiocb.ki_complete()
+ *
+ * Note that this function can be called from a bottom half context,
+ * hence we need to queue the rpc_call_done() etc to a workqueue
+ */
+static inline void nfs_local_pgio_aio_complete(struct nfs_local_kiocb *iocb)
+{
+	INIT_WORK(&iocb->work, iocb->aio_complete_work);
+	queue_work(nfsiod_workqueue, &iocb->work);
+}
+
 static void
 nfs_local_read_done(struct nfs_local_kiocb *iocb, long status)
 {
@@ -367,6 +394,23 @@ nfs_local_read_done(struct nfs_local_kiocb *iocb, long status)
 			status > 0 ? status : 0, hdr->res.eof);
 }
 
+static void nfs_local_read_aio_complete_work(struct work_struct *work)
+{
+	struct nfs_local_kiocb *iocb =
+		container_of(work, struct nfs_local_kiocb, work);
+
+	nfs_local_pgio_release(iocb);
+}
+
+static void nfs_local_read_aio_complete(struct kiocb *kiocb, long ret)
+{
+	struct nfs_local_kiocb *iocb =
+		container_of(kiocb, struct nfs_local_kiocb, kiocb);
+
+	nfs_local_read_done(iocb, ret);
+	nfs_local_pgio_aio_complete(iocb); /* Calls nfs_local_read_aio_complete_work */
+}
+
 static void nfs_local_call_read(struct work_struct *work)
 {
 	struct nfs_local_kiocb *iocb =
@@ -381,10 +425,10 @@ static void nfs_local_call_read(struct work_struct *work)
 	nfs_local_iter_init(&iter, iocb, READ);
 
 	status = filp->f_op->read_iter(&iocb->kiocb, &iter);
-	WARN_ON_ONCE(status == -EIOCBQUEUED);
-
-	nfs_local_read_done(iocb, status);
-	nfs_local_pgio_release(iocb);
+	if (status != -EIOCBQUEUED) {
+		nfs_local_read_done(iocb, status);
+		nfs_local_pgio_release(iocb);
+	}
 
 	revert_creds(save_cred);
 }
@@ -412,6 +456,11 @@ nfs_do_local_read(struct nfs_pgio_header *hdr,
 	nfs_local_pgio_init(hdr, call_ops);
 	hdr->res.eof = false;
 
+	if (iocb->kiocb.ki_flags & IOCB_DIRECT) {
+		iocb->kiocb.ki_complete = nfs_local_read_aio_complete;
+		iocb->aio_complete_work = nfs_local_read_aio_complete_work;
+	}
+
 	INIT_WORK(&iocb->work, nfs_local_call_read);
 	queue_work(nfslocaliod_workqueue, &iocb->work);
 
@@ -541,6 +590,24 @@ nfs_local_write_done(struct nfs_local_kiocb *iocb, long status)
 	nfs_local_pgio_done(hdr, status);
 }
 
+static void nfs_local_write_aio_complete_work(struct work_struct *work)
+{
+	struct nfs_local_kiocb *iocb =
+		container_of(work, struct nfs_local_kiocb, work);
+
+	nfs_local_vfs_getattr(iocb);
+	nfs_local_pgio_release(iocb);
+}
+
+static void nfs_local_write_aio_complete(struct kiocb *kiocb, long ret)
+{
+	struct nfs_local_kiocb *iocb =
+		container_of(kiocb, struct nfs_local_kiocb, kiocb);
+
+	nfs_local_write_done(iocb, ret);
+	nfs_local_pgio_aio_complete(iocb); /* Calls nfs_local_write_aio_complete_work */
+}
+
 static void nfs_local_call_write(struct work_struct *work)
 {
 	struct nfs_local_kiocb *iocb =
@@ -559,11 +626,11 @@ static void nfs_local_call_write(struct work_struct *work)
 	file_start_write(filp);
 	status = filp->f_op->write_iter(&iocb->kiocb, &iter);
 	file_end_write(filp);
-	WARN_ON_ONCE(status == -EIOCBQUEUED);
-
-	nfs_local_write_done(iocb, status);
-	nfs_local_vfs_getattr(iocb);
-	nfs_local_pgio_release(iocb);
+	if (status != -EIOCBQUEUED) {
+		nfs_local_write_done(iocb, status);
+		nfs_local_vfs_getattr(iocb);
+		nfs_local_pgio_release(iocb);
+	}
 
 	revert_creds(save_cred);
 	current->flags = old_flags;
@@ -599,10 +666,16 @@ nfs_do_local_write(struct nfs_pgio_header *hdr,
 	case NFS_FILE_SYNC:
 		iocb->kiocb.ki_flags |= IOCB_DSYNC|IOCB_SYNC;
 	}
+
 	nfs_local_pgio_init(hdr, call_ops);
 
 	nfs_set_local_verifier(hdr->inode, hdr->res.verf, hdr->args.stable);
 
+	if (iocb->kiocb.ki_flags & IOCB_DIRECT) {
+		iocb->kiocb.ki_complete = nfs_local_write_aio_complete;
+		iocb->aio_complete_work = nfs_local_write_aio_complete_work;
+	}
+
 	INIT_WORK(&iocb->work, nfs_local_call_write);
 	queue_work(nfslocaliod_workqueue, &iocb->work);
 
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index 12d8e47bc5a38..b48d94f099657 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -1637,6 +1637,7 @@ enum {
 	NFS_IOHDR_RESEND_PNFS,
 	NFS_IOHDR_RESEND_MDS,
 	NFS_IOHDR_UNSTABLE_WRITES,
+	NFS_IOHDR_ODIRECT,
 };
 
 struct nfs_io_completion;
-- 
2.51.0



