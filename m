Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831556;
	b=glVqKZXfnrf0b5xNxuuM7Lz/7blx5PWSt+N5UYRKMSJgZYoobd5HEqEqe+mIhojEaatJ
	 sUqI5HyW28wWkzPoAmasWCFpvvYou5dA0yxjDTQ1flvCTt7l8fpSl+U/QmCxtEAv+SdRh
	 ErbCBxBtKniEnmMu74eEn1GT5jO/KDC3BATCU4H9Xer7M4UdeIqBFBr5o1BxbqPXS9yuy
	 4MxazmEm5eIbQpjSrxN9gcFBWsrXkyCkZQCjB9yixdX6f5iPUi2roA0nop5L7OKDfG6qu
	 NoFu5RHJ5UBGYc1fEBKwqLmtvcoj18643PwvKP5skKJTOEJML7aAXWSCNpWIDj9vkGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831556;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nHXMNpw5A4I54MIHdJrc31ll7/nfYbD0wrumZhc1M4Q=;
	b=jyY+CtPEW2BVtYEwQrOFswACMdrsBOoEAA6gdeKo5T3wdIztCSXC/6jOHCytXHLWif2k
	 JAax7PtxeFuSe/fafw/Hj+Yr/MEmMRaBIeWNdSDSt+2uvSHhJDLvfgkXjC6rmtFOFPWkU
	 o95TK7VBPo2Bav6HXENTcPetbykYEmKqmNINX0R1sUTZ4Is0NXL9ATcphK3hXPT+LWZjO
	 QH4M70MnxhLDj3pR43d8M3ZM4AGo22Y//PypV3Hx0K0qmWv0YbRS0FoRBY0e40ojjshwd
	 Chal2+zYrd815gQME8irIOOLKR4X7EVAhNtZPIeWNasoQci8JvLu8dqUFAzkPmtjjeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z7JXqlM6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17D1606A844;
	Wed,  4 Nov 2026 22:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z7JXqlM6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8E81F00A1C;
	Wed,  4 Nov 2026 22:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831555;
	bh=nHXMNpw5A4I54MIHdJrc31ll7/nfYbD0wrumZhc1M4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z7JXqlM6B/LNKV8s0q3ehrh6ChNHcTcPXcGeQH2+YTO4NNItSte+6Ff6VN6E8N3MO
	 8aIE5f/wokjoGkauHlEyOv9LVuEXsBuOnY3ceciTHuiodFhu/0nUXigGoBXhKRp4kQ
	 4AufyqloOgPGmGVCO9XS2VeqwekNBAICvPxjePSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0774/1005] xfs: mark cow extents bad if theres no rmap mapping for them
Date: Wed,  4 Nov 2026 16:08:27 -0500
Message-ID: <20261104211105.059633220@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 2ffc0619c9c2881443c5fffb10db8f2bc0aa2ce8 upstream.

LOLLM noticed that we fail to mark cow staging extents as bad if there's
a cow staging extent but no rmap record for the cow staging event.
Close this gap.

Cc: stable@vger.kernel.org # v6.8
Fixes: dbbdbd0086320a ("xfs: repair problems in CoW forks")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/cow_repair.c |   84 ++++++++++++++++++++++++++++++----------------
 1 file changed, 55 insertions(+), 29 deletions(-)

--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -199,29 +199,35 @@ xrep_cow_mark_missing_staging_rmap(
 	void				*priv)
 {
 	struct xrep_cow			*xc = priv;
-	xfs_agblock_t			rec_bno;
-	xfs_extlen_t			rec_len;
-	unsigned int			adj;
-
-	if (rec->rm_owner == XFS_RMAP_OWN_COW)
-		return 0;
+	const xfs_agblock_t		rec_end =
+			rec->rm_startblock + rec->rm_blockcount;
+	int				error = 0;
 
-	rec_bno = rec->rm_startblock;
-	rec_len = rec->rm_blockcount;
-	if (rec_bno < xc->irec_startbno) {
-		adj = xc->irec_startbno - rec_bno;
-		rec_len -= adj;
-		rec_bno += adj;
+	/* Was there a gap since the last rmap? */
+	if (xc->next_bno < rec->rm_startblock) {
+		error = xrep_cow_mark_file_range(xc,
+				xfs_gbno_to_fsb(cur->bc_group, xc->next_bno),
+				rec->rm_startblock - xc->next_bno);
+		if (error)
+			return error;
 	}
 
-	if (rec_bno + rec_len > xc->irec_startbno + xc->irec.br_blockcount) {
-		adj = (rec_bno + rec_len) -
-		      (xc->irec_startbno + xc->irec.br_blockcount);
-		rec_len -= adj;
+	if (rec->rm_owner != XFS_RMAP_OWN_COW) {
+		const xfs_agblock_t	bad_bno =
+				max(xc->irec_startbno, rec->rm_startblock);
+		const xfs_agblock_t	irec_end =
+				xc->irec_startbno + xc->irec.br_blockcount;
+		const xfs_extlen_t	bad_end = min(irec_end, rec_end);
+
+		error = xrep_cow_mark_file_range(xc,
+				xfs_gbno_to_fsb(cur->bc_group, bad_bno),
+				bad_end - bad_bno);
+		if (error)
+			return error;
 	}
 
-	return xrep_cow_mark_file_range(xc,
-			xfs_gbno_to_fsb(cur->bc_group, rec_bno), rec_len);
+	xc->next_bno = max(xc->next_bno, rec_end);
+	return error;
 }
 
 /*
@@ -239,10 +245,12 @@ xrep_cow_find_bad(
 	struct xfs_perag		*pag;
 	struct xfs_scrub		*sc = xc->sc;
 	xfs_agnumber_t			agno;
+	xfs_agblock_t			irec_end;
 	int				error;
 
 	agno = XFS_FSB_TO_AGNO(sc->mp, xc->irec.br_startblock);
 	xc->irec_startbno = XFS_FSB_TO_AGBNO(sc->mp, xc->irec.br_startblock);
+	irec_end = xc->irec_startbno + xc->irec.br_blockcount;
 
 	pag = xfs_perag_get(sc->mp, agno);
 	if (!pag)
@@ -254,7 +262,7 @@ xrep_cow_find_bad(
 
 	/* Mark any CoW fork extents that are shared. */
 	rc_low.rc_startblock = xc->irec_startbno;
-	rc_high.rc_startblock = xc->irec_startbno + xc->irec.br_blockcount - 1;
+	rc_high.rc_startblock = irec_end - 1;
 	rc_low.rc_domain = rc_high.rc_domain = XFS_REFC_DOMAIN_SHARED;
 	error = xfs_refcount_query_range(sc->sa.refc_cur, &rc_low, &rc_high,
 			xrep_cow_mark_shared_staging, xc);
@@ -263,7 +271,7 @@ xrep_cow_find_bad(
 
 	/* Make sure there are CoW staging extents for the whole mapping. */
 	rc_low.rc_startblock = xc->irec_startbno;
-	rc_high.rc_startblock = xc->irec_startbno + xc->irec.br_blockcount - 1;
+	rc_high.rc_startblock = irec_end - 1;
 	rc_low.rc_domain = rc_high.rc_domain = XFS_REFC_DOMAIN_COW;
 	xc->next_bno = xc->irec_startbno;
 	error = xfs_refcount_query_range(sc->sa.refc_cur, &rc_low, &rc_high,
@@ -271,11 +279,10 @@ xrep_cow_find_bad(
 	if (error)
 		goto out_sa;
 
-	if (xc->next_bno < xc->irec_startbno + xc->irec.br_blockcount) {
+	if (xc->next_bno < irec_end) {
 		error = xrep_cow_mark_file_range(xc,
 				xfs_agbno_to_fsb(pag, xc->next_bno),
-				xc->irec_startbno + xc->irec.br_blockcount -
-				xc->next_bno);
+				irec_end - xc->next_bno);
 		if (error)
 			goto out_sa;
 	}
@@ -284,11 +291,20 @@ xrep_cow_find_bad(
 	rm_low.rm_startblock = xc->irec_startbno;
 	memset(&rm_high, 0xFF, sizeof(rm_high));
 	rm_high.rm_startblock = xc->irec_startbno + xc->irec.br_blockcount - 1;
+	xc->next_bno = xc->irec_startbno;
 	error = xfs_rmap_query_range(sc->sa.rmap_cur, &rm_low, &rm_high,
 			xrep_cow_mark_missing_staging_rmap, xc);
 	if (error)
 		goto out_sa;
 
+	if (xc->next_bno < irec_end) {
+		error = xrep_cow_mark_file_range(xc,
+				xfs_agbno_to_fsb(pag, xc->next_bno),
+				irec_end - xc->next_bno);
+		if (error)
+			goto out_sa;
+	}
+
 	/*
 	 * If userspace is forcing us to rebuild the CoW fork or someone turned
 	 * on the debugging knob, replace everything in the CoW fork.
@@ -319,9 +335,11 @@ xrep_cow_find_bad_rt(
 	struct xfs_rmap_irec		rm_high = { 0 };
 	struct xfs_scrub		*sc = xc->sc;
 	struct xfs_rtgroup		*rtg;
+	xfs_agblock_t			irec_end;
 	int				error = 0;
 
 	xc->irec_startbno = xfs_rtb_to_rgbno(sc->mp, xc->irec.br_startblock);
+	irec_end = xc->irec_startbno + xc->irec.br_blockcount;
 
 	rtg = xfs_rtgroup_get(sc->mp,
 			xfs_rtb_to_rgno(sc->mp, xc->irec.br_startblock));
@@ -335,7 +353,7 @@ xrep_cow_find_bad_rt(
 
 	/* Mark any CoW fork extents that are shared. */
 	rc_low.rc_startblock = xc->irec_startbno;
-	rc_high.rc_startblock = xc->irec_startbno + xc->irec.br_blockcount - 1;
+	rc_high.rc_startblock = irec_end - 1;
 	rc_low.rc_domain = rc_high.rc_domain = XFS_REFC_DOMAIN_SHARED;
 	error = xfs_refcount_query_range(sc->sr.refc_cur, &rc_low, &rc_high,
 			xrep_cow_mark_shared_staging, xc);
@@ -344,7 +362,7 @@ xrep_cow_find_bad_rt(
 
 	/* Make sure there are CoW staging extents for the whole mapping. */
 	rc_low.rc_startblock = xc->irec_startbno;
-	rc_high.rc_startblock = xc->irec_startbno + xc->irec.br_blockcount - 1;
+	rc_high.rc_startblock = irec_end - 1;
 	rc_low.rc_domain = rc_high.rc_domain = XFS_REFC_DOMAIN_COW;
 	xc->next_bno = xc->irec_startbno;
 	error = xfs_refcount_query_range(sc->sr.refc_cur, &rc_low, &rc_high,
@@ -352,11 +370,10 @@ xrep_cow_find_bad_rt(
 	if (error)
 		goto out_sr;
 
-	if (xc->next_bno < xc->irec_startbno + xc->irec.br_blockcount) {
+	if (xc->next_bno < irec_end) {
 		error = xrep_cow_mark_file_range(xc,
 				xfs_rgbno_to_rtb(rtg, xc->next_bno),
-				xc->irec_startbno + xc->irec.br_blockcount -
-				xc->next_bno);
+				irec_end - xc->next_bno);
 		if (error)
 			goto out_sr;
 	}
@@ -364,12 +381,21 @@ xrep_cow_find_bad_rt(
 	/* Mark any area has an rmap that isn't a COW staging extent. */
 	rm_low.rm_startblock = xc->irec_startbno;
 	memset(&rm_high, 0xFF, sizeof(rm_high));
-	rm_high.rm_startblock = xc->irec_startbno + xc->irec.br_blockcount - 1;
+	rm_high.rm_startblock = irec_end - 1;
+	xc->next_bno = xc->irec_startbno;
 	error = xfs_rmap_query_range(sc->sr.rmap_cur, &rm_low, &rm_high,
 			xrep_cow_mark_missing_staging_rmap, xc);
 	if (error)
 		goto out_sr;
 
+	if (xc->next_bno < irec_end) {
+		error = xrep_cow_mark_file_range(xc,
+				xfs_rgbno_to_rtb(rtg, xc->next_bno),
+				irec_end - xc->next_bno);
+		if (error)
+			goto out_sr;
+	}
+
 	/*
 	 * If userspace is forcing us to rebuild the CoW fork or someone
 	 * turned on the debugging knob, replace everything in the


