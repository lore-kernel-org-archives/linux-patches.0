Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183EF2236EB;
	Tue, 30 Sep 2025 15:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244919; cv=none; b=rB7hw4DkTW+Ia0Ot0Bjmc62hTQw9zjz3+sVy9xMFIbDu/3DfURzL0q/wX4mbWjFfFxutKIfoQD+kv7rGcOpEzNmuTqrgxrBxhlpxvhmIiWeIQk/3CShfktOlqoRaUhRHDMaC9Vei06GxAVdn1NOF1kXitUpkj16zI80cTE539EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244919; c=relaxed/simple;
	bh=GmDLFnqZ1a+A3ZklGIVL/k3CyNTr+RbsxUZoUOgG2vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8dqtjdwl1lCBtt3KVQ6DaaJ+qWIA+QFEoieOff6b4U4JlXAZdmq1mV+bJI/lA5MLYqKqB+X+XeHhw4cmYxD+zoOTs9eArhCOOgBQ0gGFt6UAeuxNxrsveVoVLkfilLQtiSGYUomBipoT5bzcFIBZ0vCSa4J+kReRAa+o/XW2H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UmwVQVTX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UmwVQVTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A689C4CEF0;
	Tue, 30 Sep 2025 15:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244919;
	bh=GmDLFnqZ1a+A3ZklGIVL/k3CyNTr+RbsxUZoUOgG2vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UmwVQVTXa7qX6E/HddSJpvz+wUVh0CHix5uJgv9V5Xpjn6fVjSWTPgSOFLn85nM+2
	 hNbubrS9Bk30Dkwg/4Oga6NL9tgqv7uQ46hHILz98cMys89mmhPwcbWyuqDgI6AqV3
	 QRPyrtGmrIDMyvYaSnMPGiDx+1LaJuO5u+KscDPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 010/151] flexfiles/pNFS: fix NULL checks on result of ff_layout_choose_ds_for_read
Date: Tue, 30 Sep 2025 16:45:40 +0200
Message-ID: <20250930143828.008348162@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>

[ Upstream commit 5a46d2339a5ae268ede53a221f20433d8ea4f2f9 ]

Recent commit f06bedfa62d5 ("pNFS/flexfiles: don't attempt pnfs on fatal DS
errors") has changed the error return type of ff_layout_choose_ds_for_read() from
NULL to an error pointer. However, not all code paths have been updated
to match the change. Thus, some non-NULL checks will accept error pointers
as a valid return value.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: f06bedfa62d5 ("pNFS/flexfiles: don't attempt pnfs on fatal DS errors")
Signed-off-by: Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index 14c7de8fd7812..798e2e32b3fb6 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -750,8 +750,11 @@ ff_layout_choose_ds_for_read(struct pnfs_layout_segment *lseg,
 			continue;
 
 		if (check_device &&
-		    nfs4_test_deviceid_unavailable(&mirror->mirror_ds->id_node))
+		    nfs4_test_deviceid_unavailable(&mirror->mirror_ds->id_node)) {
+			// reinitialize the error state in case if this is the last iteration
+			ds = ERR_PTR(-EINVAL);
 			continue;
+		}
 
 		*best_idx = idx;
 		break;
@@ -781,7 +784,7 @@ ff_layout_choose_best_ds_for_read(struct pnfs_layout_segment *lseg,
 	struct nfs4_pnfs_ds *ds;
 
 	ds = ff_layout_choose_valid_ds_for_read(lseg, start_idx, best_idx);
-	if (ds)
+	if (!IS_ERR(ds))
 		return ds;
 	return ff_layout_choose_any_ds_for_read(lseg, start_idx, best_idx);
 }
@@ -795,7 +798,7 @@ ff_layout_get_ds_for_read(struct nfs_pageio_descriptor *pgio,
 
 	ds = ff_layout_choose_best_ds_for_read(lseg, pgio->pg_mirror_idx,
 					       best_idx);
-	if (ds || !pgio->pg_mirror_idx)
+	if (!IS_ERR(ds) || !pgio->pg_mirror_idx)
 		return ds;
 	return ff_layout_choose_best_ds_for_read(lseg, 0, best_idx);
 }
@@ -856,7 +859,7 @@ ff_layout_pg_init_read(struct nfs_pageio_descriptor *pgio,
 	req->wb_nio = 0;
 
 	ds = ff_layout_get_ds_for_read(pgio, &ds_idx);
-	if (!ds) {
+	if (IS_ERR(ds)) {
 		if (!ff_layout_no_fallback_to_mds(pgio->pg_lseg))
 			goto out_mds;
 		pnfs_generic_pg_cleanup(pgio);
@@ -1066,11 +1069,13 @@ static void ff_layout_resend_pnfs_read(struct nfs_pgio_header *hdr)
 {
 	u32 idx = hdr->pgio_mirror_idx + 1;
 	u32 new_idx = 0;
+	struct nfs4_pnfs_ds *ds;
 
-	if (ff_layout_choose_any_ds_for_read(hdr->lseg, idx, &new_idx))
-		ff_layout_send_layouterror(hdr->lseg);
-	else
+	ds = ff_layout_choose_any_ds_for_read(hdr->lseg, idx, &new_idx);
+	if (IS_ERR(ds))
 		pnfs_error_mark_layout_for_return(hdr->inode, hdr->lseg);
+	else
+		ff_layout_send_layouterror(hdr->lseg);
 	pnfs_read_resend_pnfs(hdr, new_idx);
 }
 
-- 
2.51.0



