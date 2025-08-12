Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4621E29BD9D;
	Tue, 12 Aug 2025 19:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026580; cv=none; b=rTdmkdxfOr3nnncoQy9lXqU8IEAGJePPY+7k8jTwOXWGnWUcMWPyYNYO7g5HL6h14qX8B+y0XX9tLPJ6o0FgIOOtmlNv2bi0/xyQOORXb5JNiA0AEcVVyPTpEaTlByk7sdGeFE6s02hN0+wD5SnMG3mNn2UvlchTLUQ0DxJXiDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026580; c=relaxed/simple;
	bh=rn52w+RAZLUyx2u5az3GpfvHEozHAZ0aoWAjgygFcA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ssm9w9xshwGha1NNkxdxExjxXTgMEbzaFm/ZSuABsKpdqsssnzZ84yG3lYHMuJiFGCqKjz3Rok9Gwl69JV3YAa+7vCEIUoKgXf83eb5K+O2/mJSxVr+QrNMViIWKMaNvtyi+A1i+NzLynlbQSSXmZTsnKtRaf8/1G1e3bwhyeVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Epl9z6W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Epl9z6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7954C4CEF0;
	Tue, 12 Aug 2025 19:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026580;
	bh=rn52w+RAZLUyx2u5az3GpfvHEozHAZ0aoWAjgygFcA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Epl9z6WcB9781Ge0PupOAmys19XQ4Ck7YqAavUTNhYGayHYtnScstG5zrLqKRC05
	 n6yuiB2cm0md7iQXXibIeAyjeDafDVsJFX95pl3Q0sm7r4LkKAbCmCPaOAOAEn2XH+
	 XYhTtwECXCFTRqDzyOBVKliRpC33zbZQ/iV0pSlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 380/480] pNFS/flexfiles: dont attempt pnfs on fatal DS errors
Date: Tue, 12 Aug 2025 19:49:48 +0200
Message-ID: <20250812174413.101520111@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4bea008dbebd..8dc921d83538 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -762,14 +762,14 @@ ff_layout_choose_ds_for_read(struct pnfs_layout_segment *lseg,
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
@@ -777,10 +777,10 @@ ff_layout_choose_ds_for_read(struct pnfs_layout_segment *lseg,
 			continue;
 
 		*best_idx = idx;
-		return ds;
+		break;
 	}
 
-	return NULL;
+	return ds;
 }
 
 static struct nfs4_pnfs_ds *
@@ -942,7 +942,7 @@ ff_layout_pg_init_write(struct nfs_pageio_descriptor *pgio,
 	for (i = 0; i < pgio->pg_mirror_count; i++) {
 		mirror = FF_LAYOUT_COMP(pgio->pg_lseg, i);
 		ds = nfs4_ff_layout_prepare_ds(pgio->pg_lseg, mirror, true);
-		if (!ds) {
+		if (IS_ERR(ds)) {
 			if (!ff_layout_no_fallback_to_mds(pgio->pg_lseg))
 				goto out_mds;
 			pnfs_generic_pg_cleanup(pgio);
@@ -1867,6 +1867,7 @@ ff_layout_read_pagelist(struct nfs_pgio_header *hdr)
 	u32 idx = hdr->pgio_mirror_idx;
 	int vers;
 	struct nfs_fh *fh;
+	bool ds_fatal_error = false;
 
 	dprintk("--> %s ino %lu pgbase %u req %zu@%llu\n",
 		__func__, hdr->inode->i_ino,
@@ -1874,8 +1875,10 @@ ff_layout_read_pagelist(struct nfs_pgio_header *hdr)
 
 	mirror = FF_LAYOUT_COMP(lseg, idx);
 	ds = nfs4_ff_layout_prepare_ds(lseg, mirror, false);
-	if (!ds)
+	if (IS_ERR(ds)) {
+		ds_fatal_error = nfs_error_is_fatal(PTR_ERR(ds));
 		goto out_failed;
+	}
 
 	ds_clnt = nfs4_ff_find_or_create_ds_client(mirror, ds->ds_clp,
 						   hdr->inode);
@@ -1923,7 +1926,7 @@ ff_layout_read_pagelist(struct nfs_pgio_header *hdr)
 	return PNFS_ATTEMPTED;
 
 out_failed:
-	if (ff_layout_avoid_mds_available_ds(lseg))
+	if (ff_layout_avoid_mds_available_ds(lseg) && !ds_fatal_error)
 		return PNFS_TRY_AGAIN;
 	trace_pnfs_mds_fallback_read_pagelist(hdr->inode,
 			hdr->args.offset, hdr->args.count,
@@ -1945,11 +1948,14 @@ ff_layout_write_pagelist(struct nfs_pgio_header *hdr, int sync)
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
@@ -2000,7 +2006,7 @@ ff_layout_write_pagelist(struct nfs_pgio_header *hdr, int sync)
 	return PNFS_ATTEMPTED;
 
 out_failed:
-	if (ff_layout_avoid_mds_available_ds(lseg))
+	if (ff_layout_avoid_mds_available_ds(lseg) && !ds_fatal_error)
 		return PNFS_TRY_AGAIN;
 	trace_pnfs_mds_fallback_write_pagelist(hdr->inode,
 			hdr->args.offset, hdr->args.count,
@@ -2043,7 +2049,7 @@ static int ff_layout_initiate_commit(struct nfs_commit_data *data, int how)
 	idx = calc_ds_index_from_commit(lseg, data->ds_commit_index);
 	mirror = FF_LAYOUT_COMP(lseg, idx);
 	ds = nfs4_ff_layout_prepare_ds(lseg, mirror, true);
-	if (!ds)
+	if (IS_ERR(ds))
 		goto out_err;
 
 	ds_clnt = nfs4_ff_find_or_create_ds_client(mirror, ds->ds_clp,
diff --git a/fs/nfs/flexfilelayout/flexfilelayoutdev.c b/fs/nfs/flexfilelayout/flexfilelayoutdev.c
index 656d5c50bbce..30365ec782bb 100644
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
@@ -418,7 +418,7 @@ nfs4_ff_layout_prepare_ds(struct pnfs_layout_segment *lseg,
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



