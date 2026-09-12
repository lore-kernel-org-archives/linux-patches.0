Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1C0399365;
	Sat, 12 Sep 2026 20:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243343; cv=none; b=k092nRuUBHw0/KCFsbg62SznxLyJCSCZzSKnH+LxbgUVyJ6LPfxqxhucIWUXAG5pv7Z2hJ74cmim+8RkEXrwwD+cja6vyj+DDiPuPT9Fvnhel6X2HrHD+dBSV3LB0Fh6AhdwXikY0F3hUSSwttYxTJGRsMEYmgSwGrlFlcZu/KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243343; c=relaxed/simple;
	bh=DlP7WIe/6pxgyRdLGPexkGJ2Ta/h0LHikPZYCpdS81E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BZHAj/stBPf+UuIAqfbMuu+cc5+msbuy2gLvSWAefyTIWqKSY3oHvmrzvyMYeHlVplrMB0tUeExmdInSJwQqlKtzKYE2xqwdLHMS+7v65xCExcBGQUEVei2blFnMLP99Lf2SVHslW3O6UGa+8LfP5xkjhPmX+F8Rvx94E0HFQck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UPlyv7sp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UPlyv7sp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796E51F000FF;
	Sat, 12 Sep 2026 20:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243342;
	bh=sNGKjk3A77GU6KH/tXunhvXWzcFSSzbUmsdSdmWTee4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UPlyv7sp08VXy4Sjb13RtGpy0xguZ0CRw8HNcAlbRdoxWCrfGC2MWfmi7p6PqoWnU
	 bIxAjXccOJoc1aXp0M4yi3jzdFLG46Mahnu5d2rYhGR/RPJa3uFVke+2rSH60WHqNb
	 6oUid6dVTKDdO7JGX/NCfyU66XnE0YUKpKt5gFDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 722/798] NFSv4/pnfs: Clean up layout get on open
Date: Sat, 12 Sep 2026 09:05:50 +0200
Message-ID: <20260912065533.628769090@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit b4e89bcba2b3a966e043107cb52c682bb860cee7 ]

Cache the layout in the arguments so we don't have to keep looking it up
from the inode.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: 187bfc974eef ("nfs: refactor pNFS functions using clear_and_wake_up_bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c       |  6 +-----
 fs/nfs/pnfs.c           | 28 ++++++++++++++++------------
 include/linux/nfs_xdr.h |  1 +
 3 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index c455f6a8f61ae..70d373547e255 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -9423,7 +9423,7 @@ nfs4_layoutget_handle_exception(struct rpc_task *task,
 {
 	struct inode *inode = lgp->args.inode;
 	struct nfs_server *server = NFS_SERVER(inode);
-	struct pnfs_layout_hdr *lo;
+	struct pnfs_layout_hdr *lo = lgp->lo;
 	int nfs4err = task->tk_status;
 	int err, status = 0;
 	LIST_HEAD(head);
@@ -9476,7 +9476,6 @@ nfs4_layoutget_handle_exception(struct rpc_task *task,
 	case -NFS4ERR_BAD_STATEID:
 		exception->timeout = 0;
 		spin_lock(&inode->i_lock);
-		lo = NFS_I(inode)->layout;
 		/* If the open stateid was bad, then recover it. */
 		if (!lo || test_bit(NFS_LAYOUT_INVALID_STID, &lo->plh_flags) ||
 		    !nfs4_stateid_match_other(&lgp->args.stateid, &lo->plh_stateid)) {
@@ -9559,9 +9558,6 @@ nfs4_proc_layoutget(struct nfs4_layoutget *lgp, long *timeout)
 
 	dprintk("--> %s\n", __func__);
 
-	/* nfs4_layoutget_release calls pnfs_put_layout_hdr */
-	pnfs_get_layout_hdr(NFS_I(inode)->layout);
-
 	nfs4_init_sequence(&lgp->args.seq_args, &lgp->res.seq_res, 0, 0);
 
 	task = rpc_run_task(&task_setup_data);
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 47b8032f7f477..a627ce98b4561 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1154,8 +1154,7 @@ void pnfs_layoutget_free(struct nfs4_layoutget *lgp)
 	size_t max_pages = lgp->args.layout.pglen / PAGE_SIZE;
 
 	nfs4_free_pages(lgp->args.layout.pages, max_pages);
-	if (lgp->args.inode)
-		pnfs_put_layout_hdr(NFS_I(lgp->args.inode)->layout);
+	pnfs_put_layout_hdr(lgp->lo);
 	put_nfs_open_context(lgp->args.ctx);
 	kfree(lgp);
 }
@@ -2165,6 +2164,9 @@ pnfs_update_layout(struct inode *ino,
 		goto out_put_layout_hdr;
 	}
 
+	lgp->lo = lo;
+	pnfs_get_layout_hdr(lo);
+
 	lseg = nfs4_proc_layoutget(lgp, &timeout);
 	trace_pnfs_update_layout(ino, pos, count, iomode, lo, lseg,
 				 PNFS_UPDATE_LAYOUT_SEND_LAYOUTGET);
@@ -2302,6 +2304,7 @@ static void _lgopen_prepare_attached(struct nfs4_opendata *data,
 		pnfs_put_layout_hdr(lo);
 		return;
 	}
+	lgp->lo = lo;
 	data->lgp = lgp;
 	data->o_arg.lg_args = &lgp->args;
 	data->o_res.lg_res = &lgp->res;
@@ -2310,6 +2313,7 @@ static void _lgopen_prepare_attached(struct nfs4_opendata *data,
 static void _lgopen_prepare_floating(struct nfs4_opendata *data,
 				     struct nfs_open_context *ctx)
 {
+	struct inode *ino = data->dentry->d_inode;
 	struct pnfs_layout_range rng = {
 		.iomode = (data->o_arg.fmode & FMODE_WRITE) ?
 			  IOMODE_RW: IOMODE_READ,
@@ -2318,7 +2322,7 @@ static void _lgopen_prepare_floating(struct nfs4_opendata *data,
 	};
 	struct nfs4_layoutget *lgp;
 
-	lgp = pnfs_alloc_init_layoutget_args(NULL, ctx, &current_stateid,
+	lgp = pnfs_alloc_init_layoutget_args(ino, ctx, &current_stateid,
 					     &rng, GFP_KERNEL);
 	if (!lgp)
 		return;
@@ -2338,6 +2342,8 @@ void pnfs_lgopen_prepare(struct nfs4_opendata *data,
 	/* Could check on max_ops, but currently hardcoded high enough */
 	if (!nfs_server_capable(data->dir->d_inode, NFS_CAP_LGOPEN))
 		return;
+	if (data->lgp)
+		return;
 	if (data->state)
 		_lgopen_prepare_attached(data, ctx);
 	else
@@ -2377,13 +2383,13 @@ void pnfs_parse_lgopen(struct inode *ino, struct nfs4_layoutget *lgp,
 		}
 		return;
 	}
-	if (!lgp->args.inode) {
+	if (!lgp->lo) {
 		lo = _pnfs_grab_empty_layout(ino, ctx);
 		if (!lo)
 			return;
-		lgp->args.inode = ino;
+		lgp->lo = lo;
 	} else
-		lo = NFS_I(lgp->args.inode)->layout;
+		lo = lgp->lo;
 
 	lseg = pnfs_layout_process(lgp);
 	if (!IS_ERR(lseg)) {
@@ -2396,11 +2402,9 @@ void pnfs_parse_lgopen(struct inode *ino, struct nfs4_layoutget *lgp,
 void nfs4_lgopen_release(struct nfs4_layoutget *lgp)
 {
 	if (lgp != NULL) {
-		struct inode *inode = lgp->args.inode;
-		if (inode) {
-			struct pnfs_layout_hdr *lo = NFS_I(inode)->layout;
-			pnfs_clear_first_layoutget(lo);
-			nfs_layoutget_end(lo);
+		if (lgp->lo) {
+			pnfs_clear_first_layoutget(lgp->lo);
+			nfs_layoutget_end(lgp->lo);
 		}
 		pnfs_layoutget_free(lgp);
 	}
@@ -2409,7 +2413,7 @@ void nfs4_lgopen_release(struct nfs4_layoutget *lgp)
 struct pnfs_layout_segment *
 pnfs_layout_process(struct nfs4_layoutget *lgp)
 {
-	struct pnfs_layout_hdr *lo = NFS_I(lgp->args.inode)->layout;
+	struct pnfs_layout_hdr *lo = lgp->lo;
 	struct nfs4_layoutget_res *res = &lgp->res;
 	struct pnfs_layout_segment *lseg;
 	struct inode *ino = lo->plh_inode;
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index 33442fd018a06..a88c1081925ee 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -275,6 +275,7 @@ struct nfs4_layoutget {
 	struct nfs4_layoutget_args args;
 	struct nfs4_layoutget_res res;
 	const struct cred *cred;
+	struct pnfs_layout_hdr *lo;
 	gfp_t gfp_flags;
 };
 
-- 
2.53.0



