Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48FB3233FC;
	Wed, 17 Sep 2025 12:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113250; cv=none; b=NXmygdJAj0WAWk1XpKYthnP6CvE73Dxqbxpv7NX7RpEg2P5ZksWEKbhtir9aMN84xHD3KEYJab7wqZgN24Ty77TGYZQGy0TQ7+VbTYpslsNA3abPf7+Z44N9JXgvC/bvh2wME9EtPgVmosvP7uisieNePyFsLByT6bQIdWHv+Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113250; c=relaxed/simple;
	bh=0JqWGvFj9oxCzZ+L+BuAhFPBnx6vKP6vdokmciKXfEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4xrC1rC4q0ft+zsg1xnMg/VVHAKoVHYAunp1gCmtcs8/PsTJKeJsjGkvn2lkdsjwSPqMoXAY49qe+vyDbd/laVTip7MRdyZkH5f8JNR08udHjtue7iazij6w4GY59MkcZoW5g9D7PhihVvRehQ99nAYHUN38lrMMDNV4WnqtKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gqgA8IUY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqgA8IUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4D2C4CEFF;
	Wed, 17 Sep 2025 12:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113250;
	bh=0JqWGvFj9oxCzZ+L+BuAhFPBnx6vKP6vdokmciKXfEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gqgA8IUYi+BPpxBLvVHJflfTz+At7+FTFCuXqeGFfR0L4/6+Go+A3f0mx0NKOh3Y0
	 U89aAExNFKYQJ1nMnTOMhJ9ewadE2GLR4Vt7PNkTByVh/H989IcmzLWm6odweCC9Ef
	 8F1dcNTANqWB/ib9JF54LQboVaJDsNYYknYVA1ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/140] nfs/localio: remove extra indirect nfs_to call to check {read,write}_iter
Date: Wed, 17 Sep 2025 14:33:20 +0200
Message-ID: <20250917123344.995022051@linuxfoundation.org>
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

[ Upstream commit 0978e5b85fc0867f53c5f4e5b7d2a5536a623e16 ]

Push the read_iter and write_iter availability checks down to
nfs_do_local_read and nfs_do_local_write respectively.

This eliminates a redundant nfs_to->nfsd_file_file() call.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: 992203a1fba5 ("nfs/localio: restore creds before releasing pageio data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/localio.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/fs/nfs/localio.c b/fs/nfs/localio.c
index 21b2b38fae9f3..ab305dfc71269 100644
--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -274,7 +274,7 @@ nfs_local_iocb_free(struct nfs_local_kiocb *iocb)
 
 static struct nfs_local_kiocb *
 nfs_local_iocb_alloc(struct nfs_pgio_header *hdr,
-		     struct nfsd_file *localio, gfp_t flags)
+		     struct file *file, gfp_t flags)
 {
 	struct nfs_local_kiocb *iocb;
 
@@ -287,9 +287,8 @@ nfs_local_iocb_alloc(struct nfs_pgio_header *hdr,
 		kfree(iocb);
 		return NULL;
 	}
-	init_sync_kiocb(&iocb->kiocb, nfs_to->nfsd_file_file(localio));
+	init_sync_kiocb(&iocb->kiocb, file);
 	iocb->kiocb.ki_pos = hdr->args.offset;
-	iocb->localio = localio;
 	iocb->hdr = hdr;
 	iocb->kiocb.ki_flags &= ~IOCB_APPEND;
 	return iocb;
@@ -396,13 +395,19 @@ nfs_do_local_read(struct nfs_pgio_header *hdr,
 		  const struct rpc_call_ops *call_ops)
 {
 	struct nfs_local_kiocb *iocb;
+	struct file *file = nfs_to->nfsd_file_file(localio);
+
+	/* Don't support filesystems without read_iter */
+	if (!file->f_op->read_iter)
+		return -EAGAIN;
 
 	dprintk("%s: vfs_read count=%u pos=%llu\n",
 		__func__, hdr->args.count, hdr->args.offset);
 
-	iocb = nfs_local_iocb_alloc(hdr, localio, GFP_KERNEL);
+	iocb = nfs_local_iocb_alloc(hdr, file, GFP_KERNEL);
 	if (iocb == NULL)
 		return -ENOMEM;
+	iocb->localio = localio;
 
 	nfs_local_pgio_init(hdr, call_ops);
 	hdr->res.eof = false;
@@ -570,14 +575,20 @@ nfs_do_local_write(struct nfs_pgio_header *hdr,
 		   const struct rpc_call_ops *call_ops)
 {
 	struct nfs_local_kiocb *iocb;
+	struct file *file = nfs_to->nfsd_file_file(localio);
+
+	/* Don't support filesystems without write_iter */
+	if (!file->f_op->write_iter)
+		return -EAGAIN;
 
 	dprintk("%s: vfs_write count=%u pos=%llu %s\n",
 		__func__, hdr->args.count, hdr->args.offset,
 		(hdr->args.stable == NFS_UNSTABLE) ?  "unstable" : "stable");
 
-	iocb = nfs_local_iocb_alloc(hdr, localio, GFP_NOIO);
+	iocb = nfs_local_iocb_alloc(hdr, file, GFP_NOIO);
 	if (iocb == NULL)
 		return -ENOMEM;
+	iocb->localio = localio;
 
 	switch (hdr->args.stable) {
 	default:
@@ -603,16 +614,9 @@ int nfs_local_doio(struct nfs_client *clp, struct nfsd_file *localio,
 		   const struct rpc_call_ops *call_ops)
 {
 	int status = 0;
-	struct file *filp = nfs_to->nfsd_file_file(localio);
 
 	if (!hdr->args.count)
 		return 0;
-	/* Don't support filesystems without read_iter/write_iter */
-	if (!filp->f_op->read_iter || !filp->f_op->write_iter) {
-		nfs_local_disable(clp);
-		status = -EAGAIN;
-		goto out;
-	}
 
 	switch (hdr->rw_mode) {
 	case FMODE_READ:
@@ -626,8 +630,10 @@ int nfs_local_doio(struct nfs_client *clp, struct nfsd_file *localio,
 			hdr->rw_mode);
 		status = -EINVAL;
 	}
-out:
+
 	if (status != 0) {
+		if (status == -EAGAIN)
+			nfs_local_disable(clp);
 		nfs_to_nfsd_file_put_local(localio);
 		hdr->task.tk_status = status;
 		nfs_local_hdr_release(hdr, call_ops);
-- 
2.51.0



