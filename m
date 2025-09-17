Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60AC183CA6;
	Wed, 17 Sep 2025 12:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113224; cv=none; b=WLOP4sq6bXUKWwUKxKux6p6hedoH/CRFwkMdtO58S0WJXaSiJtzpcSOBIx4d9m5MvciVbn8gKYoxvIJFJlhoUo9XDEcLmTJa38PBGedeiE15mo+HqKeAA3tVwAm5n6oNVRjE4sxRw7qD+cWrMwr4+G3+gliamY+4Hsvm0R/GoeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113224; c=relaxed/simple;
	bh=yoo5PxeLg3ol3BJ56hr24Oiw6Wtdn0hi7onCKYrkWiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUYXUtNvxdys3lvfOdpBxsG3mMpuSgKaX5EiD+/s56QiqgRlDv9ymgKUi3FNHHeV1LGUVtyKL2gyCHgAMRmKnBf+nqNUXeed6PRPWr2PWvW616arpXKqGwnKlE6f+nKpjd204IDJeRkn32eV8ieV9lCj5b6pg01b+3z+jV1Oywk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1E5Utl1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1E5Utl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3517C4CEF0;
	Wed, 17 Sep 2025 12:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113224;
	bh=yoo5PxeLg3ol3BJ56hr24Oiw6Wtdn0hi7onCKYrkWiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1E5Utl1vmHMQEu0HxpHlzy+qsdUMdei/mmKVQAeYHgYbf2OTtXYooxS3qGy1yG1o
	 VzE1TOwPFdBcBOsk1iqKSaeFrMTDofTzR34aIcDT7za0BJsnFIZAVOb1+8YMhxB0Ji
	 uKmqlZaGKjNCGAWBRRAD0xFPawatTHSt4T5ZRszw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/140] flexfiles/pNFS: fix NULL checks on result of ff_layout_choose_ds_for_read
Date: Wed, 17 Sep 2025 14:33:12 +0200
Message-ID: <20250917123344.803984510@linuxfoundation.org>
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
index b685e763ef11b..69496aab9583e 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -772,8 +772,11 @@ ff_layout_choose_ds_for_read(struct pnfs_layout_segment *lseg,
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
@@ -803,7 +806,7 @@ ff_layout_choose_best_ds_for_read(struct pnfs_layout_segment *lseg,
 	struct nfs4_pnfs_ds *ds;
 
 	ds = ff_layout_choose_valid_ds_for_read(lseg, start_idx, best_idx);
-	if (ds)
+	if (!IS_ERR(ds))
 		return ds;
 	return ff_layout_choose_any_ds_for_read(lseg, start_idx, best_idx);
 }
@@ -817,7 +820,7 @@ ff_layout_get_ds_for_read(struct nfs_pageio_descriptor *pgio,
 
 	ds = ff_layout_choose_best_ds_for_read(lseg, pgio->pg_mirror_idx,
 					       best_idx);
-	if (ds || !pgio->pg_mirror_idx)
+	if (!IS_ERR(ds) || !pgio->pg_mirror_idx)
 		return ds;
 	return ff_layout_choose_best_ds_for_read(lseg, 0, best_idx);
 }
@@ -867,7 +870,7 @@ ff_layout_pg_init_read(struct nfs_pageio_descriptor *pgio,
 	req->wb_nio = 0;
 
 	ds = ff_layout_get_ds_for_read(pgio, &ds_idx);
-	if (!ds) {
+	if (IS_ERR(ds)) {
 		if (!ff_layout_no_fallback_to_mds(pgio->pg_lseg))
 			goto out_mds;
 		pnfs_generic_pg_cleanup(pgio);
@@ -1071,11 +1074,13 @@ static void ff_layout_resend_pnfs_read(struct nfs_pgio_header *hdr)
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



