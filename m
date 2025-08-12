Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD65E2E36F1;
	Tue, 12 Aug 2025 18:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021802; cv=none; b=r0jovC6fUOKCgR/btOwfST8cSDIW/JUJOcgfkDYFSY9MBAedL68TXw55pUqfq+w5aowFWniz0MSubvR0v4naLCgioPnKkaj6CO3emXuIdYlv03BZxweuqkkZ+C0/yWgIVwqsH2pSiGuCJL9RyxletFcd1VBaa3GlxbtfzAkoCw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021802; c=relaxed/simple;
	bh=XiuSKNm/oXr8X/5Uffx7XToV4jrs5ZiH8jQvgFzIquM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mheUJzqVFfWPlRuWSbQIlW48Yph+YUschsiCMVMnPkHszx+nykjPz4+xSWMTqu6NQzY9Z15/currVa/rHuXaGtg4pYelq0GVZgbqEbvkvo4IqW7WYCtmC3AhqYd2JOP3OAwZKpI0ukcwMMqJP2ROtSydlNuDr/xSJgWsifmHFPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hXHuAvde; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hXHuAvde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAC0C4CEF6;
	Tue, 12 Aug 2025 18:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021802;
	bh=XiuSKNm/oXr8X/5Uffx7XToV4jrs5ZiH8jQvgFzIquM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hXHuAvde3JV5VtB1KUayKRjaYbQleuaDL6zCE/hniy119SAho41e2+MG2hBtReP1Q
	 hnOHjdK4ZkLRypDBwwnXZVQfAa+Qe6p6M7JT53lkSWTIwUaOoiOUgWVEHiP61ipR4T
	 HTVAphUo8L3gzFGuS0CWQzeQukqJ/lxkjSqDBcYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 196/262] pNFS/flexfiles: dont attempt pnfs on fatal DS errors
Date: Tue, 12 Aug 2025 19:29:44 +0200
Message-ID: <20250812173001.487623277@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>

[ Upstream commit f06bedfa62d57f7b67d44aacd6badad2e13a803f ]

When an applications get killed (SIGTERM/SIGINT) while pNFS client performs a connection
to DS, client ends in an infinite loop of connect-disconnect. This
source of the issue, it that flexfilelayoutdev#nfs4_ff_layout_prepare_ds gets an error
on nfs4_pnfs_ds_connect with status ERESTARTSYS, which is set by rpc_signal_task, but
the error is treated as transient, thus retried.

The issue is reproducible with Ctrl+C the following script(there should be ~1000 files in
a directory, client should must not have any connections to DSes):

```
echo 3 > /proc/sys/vm/drop_caches

for i in *
do
   head -1 $i
done
```

The change aims to propagate the nfs4_ff_layout_prepare_ds error state
to the caller that can decide whatever this is a retryable error or not.

Signed-off-by: Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
Link: https://lore.kernel.org/r/20250627071751.189663-1-tigran.mkrtchyan@desy.de
Fixes: 260f32adb88d ("pNFS/flexfiles: Check the result of nfs4_pnfs_ds_connect")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c    | 26 ++++++++++++++---------
 fs/nfs/flexfilelayout/flexfilelayoutdev.c |  6 +++---
 2 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index 0a26444fe202..7354b6b10478 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -745,14 +745,14 @@ ff_layout_choose_ds_for_read(struct pnfs_layout_segment *lseg,
 {
 	struct nfs4_ff_layout_segment *fls = FF_LAYOUT_LSEG(lseg);
 	struct nfs4_ff_layout_mirror *mirror;
-	struct nfs4_pnfs_ds *ds;
+	struct nfs4_pnfs_ds *ds = ERR_PTR(-EAGAIN);
 	u32 idx;
 
 	/* mirrors are initially sorted by efficiency */
 	for (idx = start_idx; idx < fls->mirror_array_cnt; idx++) {
 		mirror = FF_LAYOUT_COMP(lseg, idx);
 		ds = nfs4_ff_layout_prepare_ds(lseg, mirror, false);
-		if (!ds)
+		if (IS_ERR(ds))
 			continue;
 
 		if (check_device &&
@@ -760,10 +760,10 @@ ff_layout_choose_ds_for_read(struct pnfs_layout_segment *lseg,
 			continue;
 
 		*best_idx = idx;
-		return ds;
+		break;
 	}
 
-	return NULL;
+	return ds;
 }
 
 static struct nfs4_pnfs_ds *
@@ -933,7 +933,7 @@ ff_layout_pg_init_write(struct nfs_pageio_descriptor *pgio,
 	for (i = 0; i < pgio->pg_mirror_count; i++) {
 		mirror = FF_LAYOUT_COMP(pgio->pg_lseg, i);
 		ds = nfs4_ff_layout_prepare_ds(pgio->pg_lseg, mirror, true);
-		if (!ds) {
+		if (IS_ERR(ds)) {
 			if (!ff_layout_no_fallback_to_mds(pgio->pg_lseg))
 				goto out_mds;
 			pnfs_generic_pg_cleanup(pgio);
@@ -1839,6 +1839,7 @@ ff_layout_read_pagelist(struct nfs_pgio_header *hdr)
 	u32 idx = hdr->pgio_mirror_idx;
 	int vers;
 	struct nfs_fh *fh;
+	bool ds_fatal_error = false;
 
 	dprintk("--> %s ino %lu pgbase %u req %zu@%llu\n",
 		__func__, hdr->inode->i_ino,
@@ -1846,8 +1847,10 @@ ff_layout_read_pagelist(struct nfs_pgio_header *hdr)
 
 	mirror = FF_LAYOUT_COMP(lseg, idx);
 	ds = nfs4_ff_layout_prepare_ds(lseg, mirror, false);
-	if (!ds)
+	if (IS_ERR(ds)) {
+		ds_fatal_error = nfs_error_is_fatal(PTR_ERR(ds));
 		goto out_failed;
+	}
 
 	ds_clnt = nfs4_ff_find_or_create_ds_client(mirror, ds->ds_clp,
 						   hdr->inode);
@@ -1888,7 +1891,7 @@ ff_layout_read_pagelist(struct nfs_pgio_header *hdr)
 	return PNFS_ATTEMPTED;
 
 out_failed:
-	if (ff_layout_avoid_mds_available_ds(lseg))
+	if (ff_layout_avoid_mds_available_ds(lseg) && !ds_fatal_error)
 		return PNFS_TRY_AGAIN;
 	trace_pnfs_mds_fallback_read_pagelist(hdr->inode,
 			hdr->args.offset, hdr->args.count,
@@ -1909,11 +1912,14 @@ ff_layout_write_pagelist(struct nfs_pgio_header *hdr, int sync)
 	int vers;
 	struct nfs_fh *fh;
 	u32 idx = hdr->pgio_mirror_idx;
+	bool ds_fatal_error = false;
 
 	mirror = FF_LAYOUT_COMP(lseg, idx);
 	ds = nfs4_ff_layout_prepare_ds(lseg, mirror, true);
-	if (!ds)
+	if (IS_ERR(ds)) {
+		ds_fatal_error = nfs_error_is_fatal(PTR_ERR(ds));
 		goto out_failed;
+	}
 
 	ds_clnt = nfs4_ff_find_or_create_ds_client(mirror, ds->ds_clp,
 						   hdr->inode);
@@ -1956,7 +1962,7 @@ ff_layout_write_pagelist(struct nfs_pgio_header *hdr, int sync)
 	return PNFS_ATTEMPTED;
 
 out_failed:
-	if (ff_layout_avoid_mds_available_ds(lseg))
+	if (ff_layout_avoid_mds_available_ds(lseg) && !ds_fatal_error)
 		return PNFS_TRY_AGAIN;
 	trace_pnfs_mds_fallback_write_pagelist(hdr->inode,
 			hdr->args.offset, hdr->args.count,
@@ -1998,7 +2004,7 @@ static int ff_layout_initiate_commit(struct nfs_commit_data *data, int how)
 	idx = calc_ds_index_from_commit(lseg, data->ds_commit_index);
 	mirror = FF_LAYOUT_COMP(lseg, idx);
 	ds = nfs4_ff_layout_prepare_ds(lseg, mirror, true);
-	if (!ds)
+	if (IS_ERR(ds))
 		goto out_err;
 
 	ds_clnt = nfs4_ff_find_or_create_ds_client(mirror, ds->ds_clp,
diff --git a/fs/nfs/flexfilelayout/flexfilelayoutdev.c b/fs/nfs/flexfilelayout/flexfilelayoutdev.c
index d21c5ecfbf1c..95d5dca67145 100644
--- a/fs/nfs/flexfilelayout/flexfilelayoutdev.c
+++ b/fs/nfs/flexfilelayout/flexfilelayoutdev.c
@@ -370,11 +370,11 @@ nfs4_ff_layout_prepare_ds(struct pnfs_layout_segment *lseg,
 			  struct nfs4_ff_layout_mirror *mirror,
 			  bool fail_return)
 {
-	struct nfs4_pnfs_ds *ds = NULL;
+	struct nfs4_pnfs_ds *ds;
 	struct inode *ino = lseg->pls_layout->plh_inode;
 	struct nfs_server *s = NFS_SERVER(ino);
 	unsigned int max_payload;
-	int status;
+	int status = -EAGAIN;
 
 	if (!ff_layout_init_mirror_ds(lseg->pls_layout, mirror))
 		goto noconnect;
@@ -412,7 +412,7 @@ nfs4_ff_layout_prepare_ds(struct pnfs_layout_segment *lseg,
 	ff_layout_send_layouterror(lseg);
 	if (fail_return || !ff_layout_has_available_ds(lseg))
 		pnfs_error_mark_layout_for_return(ino, lseg);
-	ds = NULL;
+	ds = ERR_PTR(status);
 out:
 	return ds;
 }
-- 
2.39.5



