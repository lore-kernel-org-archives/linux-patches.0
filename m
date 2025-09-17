Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C617737C110;
	Wed, 17 Sep 2025 12:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113692; cv=none; b=Jk0v5H5hXt5OBTn0ufXYkF+VAOdJfNbzed2xJ9Xu9aHtMl1lXxaZlj7fyieHf8zjPL/EMK8vcgT8KXApBQp8HxukIF8RIgftpux8We20MHxeJWtlhekR0UifKKgdr37f3N5gY++ti+R+q58v1/IbDNBmr9nbm5catov3iUNw+9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113692; c=relaxed/simple;
	bh=0PzziW6aDPtTpVoxESG6l1oB/9A6nvusD4ELYO7A8iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rViwigVTyISCK5gOQ6ms+fqWReWOo3YpTducMCxbGh2RH2hzy3ZEL3VxPyvZw3QK0hZpbDWokscIlSPIORajNXqVBOiGN9kdcaDV5+ZwV32eTqBdiokKQ4ogTVEKCEcuxMKYowEacee43AM6gJIAgLTkT3CbpCB5ZksO/DiVRJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LY50tpMW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LY50tpMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8ADC4CEF0;
	Wed, 17 Sep 2025 12:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113692;
	bh=0PzziW6aDPtTpVoxESG6l1oB/9A6nvusD4ELYO7A8iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LY50tpMWLvzeBEESmSMQup9qdpoXlsJcvJ/1Jo/X30DD1cDbvxwSBEFb8s8gpS8ZR
	 cfKI+drExjU/Pv2BQLMXFyt2hd+4cuRtsp9piQqmEgRPf2huqta3P/ZY2my4jhGyJW
	 g4UGQDmpQDRKeF0HwsTAHM/i3DnT0Y4R5enwBusc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/101] flexfiles/pNFS: fix NULL checks on result of ff_layout_choose_ds_for_read
Date: Wed, 17 Sep 2025 14:33:52 +0200
Message-ID: <20250917123337.095274223@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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
index 7354b6b104783..b05dd4d3ed653 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -756,8 +756,11 @@ ff_layout_choose_ds_for_read(struct pnfs_layout_segment *lseg,
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
@@ -787,7 +790,7 @@ ff_layout_choose_best_ds_for_read(struct pnfs_layout_segment *lseg,
 	struct nfs4_pnfs_ds *ds;
 
 	ds = ff_layout_choose_valid_ds_for_read(lseg, start_idx, best_idx);
-	if (ds)
+	if (!IS_ERR(ds))
 		return ds;
 	return ff_layout_choose_any_ds_for_read(lseg, start_idx, best_idx);
 }
@@ -801,7 +804,7 @@ ff_layout_get_ds_for_read(struct nfs_pageio_descriptor *pgio,
 
 	ds = ff_layout_choose_best_ds_for_read(lseg, pgio->pg_mirror_idx,
 					       best_idx);
-	if (ds || !pgio->pg_mirror_idx)
+	if (!IS_ERR(ds) || !pgio->pg_mirror_idx)
 		return ds;
 	return ff_layout_choose_best_ds_for_read(lseg, 0, best_idx);
 }
@@ -859,7 +862,7 @@ ff_layout_pg_init_read(struct nfs_pageio_descriptor *pgio,
 	req->wb_nio = 0;
 
 	ds = ff_layout_get_ds_for_read(pgio, &ds_idx);
-	if (!ds) {
+	if (IS_ERR(ds)) {
 		if (!ff_layout_no_fallback_to_mds(pgio->pg_lseg))
 			goto out_mds;
 		pnfs_generic_pg_cleanup(pgio);
@@ -1063,11 +1066,13 @@ static void ff_layout_resend_pnfs_read(struct nfs_pgio_header *hdr)
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



