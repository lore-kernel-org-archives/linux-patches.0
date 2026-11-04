Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829036;
	b=g3HjwCXDn0e9l8PfVhAl4QN7LLfTAPJM2ptONMehQS/DmmcsnviMJYSp+xGg7XoRytCG
	 AOGZKS10mUw4YuG2qD7PfSijN0xll2/MtwiAEXm6chgcS8biEiIXZL62xu69qqip1hP5x
	 QQmJi3LMmlLDyKqwd3Qfx3CtWoBF+7rOLXdDxULOJyKK7jYF/2+LCRHlGBsdM0QbsALoK
	 HO+U8LZgFyo4CXPlDlBFLzu/6ds4N3T2AxHbo0It6jnZ+f/rxoIk1wBecF0r/CwPedPBd
	 4+gM8MeTQ/oVrqdOzJMNZMknkwPUTnuUQlBs+kW+XnplOYzhAqPD2u5Y8H22dAl/QAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829036;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pigIbhEok0GsgMSC92k5/6i/TfN3/n01YIuy897acwU=;
	b=0W3c6F314AFqS+Jl3NAzYhKXRrx7AZM5DBvh0eq0f7jiH7DfyiATWn60HfFp9z5/X13Q
	 CkrXsPZ/vc4D/9RNBbSmFlM6aLoapa0oXUxQak/K3I8vY2rvaTdBIK8qD1MCd7K2YhaWt
	 RyRvdI7T5rRZQy3fY3eD5WFyD6kpuUB+RKvAfnN1V/DKPbpAA2YaSLeYXQ56kpkbvQepX
	 5bkARhvdJwYQ4Kpu7imVi+q6uBfGmTSNQxPmIXYtibZhEMAs6Ewy7sUrttnLjCIGQrcxT
	 bRCXvFn/2QWqfbMVvBXaUHEPUwP7F57w/d3uG752fvt77fDjuIUeNKbCCUAtrE0H0MA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SfcaCbaW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD65D6080790;
	Wed,  4 Nov 2026 21:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SfcaCbaW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DEA31F000C1;
	Wed,  4 Nov 2026 21:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829035;
	bh=pigIbhEok0GsgMSC92k5/6i/TfN3/n01YIuy897acwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SfcaCbaWbKJcmodqFjcUshWW5wDN3mqgwQOv0kQC9JekvFoGzveqOc8EMeJkEnpYW
	 isQCgXoaBKnBGXS43PqJ4HlA5PAIZMDSXsWuM5LF0fLM8dqw9dI38F/RrRCKAZgZ+V
	 K+L76H2L8CLjquBey0ISvR6few8fCngD3uVc5ZX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 7.3 403/547] NFSv4/flexfiles: Use the full 64-bit offset for read DS selection
Date: Wed,  4 Nov 2026 16:09:47 -0500
Message-ID: <20261104211049.764944812@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <ben.coddington@hammerspace.com>

commit 448591e1f82902e5714bd436d6367adc7fbaea90 upstream.

The read data-server selection helpers declare their offset parameter
as u32, truncating the file offset before nfs4_ff_layout_calc_dss_id()
computes the stripe index.  The write path already passes the full
offset; make the read path match.

Fixes: 4934ccbeaed3 ("NFSv4/flexfiles: Read path updates for striped layouts")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Benjamin Coddington <bcodding@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -878,7 +878,7 @@ ff_layout_mark_ds_reachable(struct pnfs_
 static struct nfs4_pnfs_ds *
 ff_layout_choose_ds_for_read(struct pnfs_layout_segment *lseg,
 			     u32 start_idx, u32 *best_idx,
-			     u32 offset, u32 *dss_id,
+			     u64 offset, u32 *dss_id,
 			     bool check_device)
 {
 	struct nfs4_ff_layout_segment *fls = FF_LAYOUT_LSEG(lseg);
@@ -914,7 +914,7 @@ ff_layout_choose_ds_for_read(struct pnfs
 static struct nfs4_pnfs_ds *
 ff_layout_choose_any_ds_for_read(struct pnfs_layout_segment *lseg,
 				 u32 start_idx, u32 *best_idx,
-				 u32 offset, u32 *dss_id)
+				 u64 offset, u32 *dss_id)
 {
 	return ff_layout_choose_ds_for_read(lseg, start_idx, best_idx,
 					    offset, dss_id, false);
@@ -923,7 +923,7 @@ ff_layout_choose_any_ds_for_read(struct
 static struct nfs4_pnfs_ds *
 ff_layout_choose_valid_ds_for_read(struct pnfs_layout_segment *lseg,
 				   u32 start_idx, u32 *best_idx,
-				   u32 offset, u32 *dss_id)
+				   u64 offset, u32 *dss_id)
 {
 	return ff_layout_choose_ds_for_read(lseg, start_idx, best_idx,
 					    offset, dss_id, true);
@@ -932,7 +932,7 @@ ff_layout_choose_valid_ds_for_read(struc
 static struct nfs4_pnfs_ds *
 ff_layout_choose_best_ds_for_read(struct pnfs_layout_segment *lseg,
 				  u32 start_idx, u32 *best_idx,
-				  u32 offset, u32 *dss_id)
+				  u64 offset, u32 *dss_id)
 {
 	struct nfs4_pnfs_ds *ds;
 
@@ -947,7 +947,7 @@ ff_layout_choose_best_ds_for_read(struct
 static struct nfs4_pnfs_ds *
 ff_layout_get_ds_for_read(struct nfs_pageio_descriptor *pgio,
 			  u32 *best_idx,
-			  u32 offset,
+			  u64 offset,
 			  u32 *dss_id)
 {
 	struct pnfs_layout_segment *lseg = pgio->pg_lseg;


