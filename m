Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828881;
	b=zAhSsQ+jf0BJnIyjyjf3J1FrHOTVRboRcswPiMyFBCGYxbMpsqpbw7fcdroh27qAfy7Q
	 dzVAq3za4zLtyE3m6aZs9qAq0nmx/MXdV+9wr0szjnnE3gpU+vLf41f7BEgt7jWYCE5Zg
	 EXUeQIQsWqXjAcjvJgJeuLfOb+I+TERdvhPbhNiDieT5l9J7S5lM9LXOoeACYaIfec3qU
	 cyBIGu4wci+pmxYUSffvDKI6L2yFzDVFg7lgY07ZtU2Udo+79MISpkci7Jx82SSJ3FH8e
	 9JduIihFiBXC2mapiLU60kEOBZnWnoCPBi3IJafhEN+kQC1Xxzuuc+6/XNhR+JoPzQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828881;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NrfklpwiMVOGSd+ej3WVdf7tEvXLUiq2j/DuoWPPPE4=;
	b=e/ap49riHN9v8x8wXY3aU2Ehtyq1JULD9bAvs7elzJjyR68N3RvzzSq4cYQSWO700S9c
	 sD7YLlP7x1n0r2IT4egKDhifSYuO74tJTsiChFXgtlLkupaGVI3uba0WkYKqy7Nt8jRky
	 ZOIwPVTHRn54zvisrHltvfcBWLYXTwqb6FMBY3bJTT1njYy8nLKD3274lJisyaf6j8EcL
	 YEnFW9Qx49recpwe98ishJElz83G8s0ZsVwlJJeEOaNzZheItnhJ3237ewMhTrEGGNtU2
	 /F8DSFuVoJoYUg33nvyB1JjCRpB3HZOOkApPdcZps3DG0puuzvzl42eHKMFvdZX3SmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A2GJhOMu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595166071AC2;
	Wed,  4 Nov 2026 21:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A2GJhOMu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4BE1F00A17;
	Wed,  4 Nov 2026 21:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828881;
	bh=NrfklpwiMVOGSd+ej3WVdf7tEvXLUiq2j/DuoWPPPE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A2GJhOMufssgCST0S9XSCcdbN7EhIIqDghB7TZ0BLl1c+sh/smL/kAnNs5j1C8bEI
	 BWlodIlOORoAzVRFXDr3x5c+0qRooJcSWtKsLkaQ+yf12ojUuznRI/iL7yP2ySOLpE
	 Njm7w6SmceWISVLQCz1OoMZSmZVXze4zYftsOe5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 299/547] xfs: mark cow extents bad if theres no rmap mapping for them
Date: Wed,  4 Nov 2026 16:08:03 -0500
Message-ID: <20261104211046.695195843@linuxfoundation.org>
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
@@ -200,29 +200,35 @@ xrep_cow_mark_missing_staging_rmap(
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
@@ -263,10 +269,12 @@ xrep_cow_find_bad(
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
@@ -278,7 +286,7 @@ xrep_cow_find_bad(
 
 	/* Mark any CoW fork extents that are shared. */
 	rc_low.rc_startblock = xc->irec_startbno;
-	rc_high.rc_startblock = xc->irec_startbno + xc->irec.br_blockcount - 1;
+	rc_high.rc_startblock = irec_end - 1;
 	rc_low.rc_domain = rc_high.rc_domain = XFS_REFC_DOMAIN_SHARED;
 	error = xfs_refcount_query_range(sc->sa.refc_cur, &rc_low, &rc_high,
 			xrep_cow_mark_shared_staging, xc);
@@ -287,7 +295,7 @@ xrep_cow_find_bad(
 
 	/* Make sure there are CoW staging extents for the whole mapping. */
 	rc_low.rc_startblock = xc->irec_startbno;
-	rc_high.rc_startblock = xc->irec_startbno + xc->irec.br_blockcount - 1;
+	rc_high.rc_startblock = irec_end - 1;
 	rc_low.rc_domain = rc_high.rc_domain = XFS_REFC_DOMAIN_COW;
 	xc->next_bno = xc->irec_startbno;
 	error = xfs_refcount_query_range(sc->sa.refc_cur, &rc_low, &rc_high,
@@ -295,11 +303,10 @@ xrep_cow_find_bad(
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
@@ -308,11 +315,20 @@ xrep_cow_find_bad(
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
@@ -344,9 +360,11 @@ xrep_cow_find_bad_rt(
 	struct xfs_rmap_irec		rm_high = { 0 };
 	struct xfs_scrub		*sc = xc->sc;
 	struct xfs_rtgroup		*rtg;
+	xfs_agblock_t			irec_end;
 	int				error = 0;
 
 	xc->irec_startbno = xfs_rtb_to_rgbno(sc->mp, xc->irec.br_startblock);
+	irec_end = xc->irec_startbno + xc->irec.br_blockcount;
 
 	rtg = xfs_rtgroup_get(sc->mp,
 			xfs_rtb_to_rgno(sc->mp, xc->irec.br_startblock));
@@ -360,7 +378,7 @@ xrep_cow_find_bad_rt(
 
 	/* Mark any CoW fork extents that are shared. */
 	rc_low.rc_startblock = xc->irec_startbno;
-	rc_high.rc_startblock = xc->irec_startbno + xc->irec.br_blockcount - 1;
+	rc_high.rc_startblock = irec_end - 1;
 	rc_low.rc_domain = rc_high.rc_domain = XFS_REFC_DOMAIN_SHARED;
 	error = xfs_refcount_query_range(sc->sr.refc_cur, &rc_low, &rc_high,
 			xrep_cow_mark_shared_staging, xc);
@@ -369,7 +387,7 @@ xrep_cow_find_bad_rt(
 
 	/* Make sure there are CoW staging extents for the whole mapping. */
 	rc_low.rc_startblock = xc->irec_startbno;
-	rc_high.rc_startblock = xc->irec_startbno + xc->irec.br_blockcount - 1;
+	rc_high.rc_startblock = irec_end - 1;
 	rc_low.rc_domain = rc_high.rc_domain = XFS_REFC_DOMAIN_COW;
 	xc->next_bno = xc->irec_startbno;
 	error = xfs_refcount_query_range(sc->sr.refc_cur, &rc_low, &rc_high,
@@ -377,11 +395,10 @@ xrep_cow_find_bad_rt(
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
@@ -389,12 +406,21 @@ xrep_cow_find_bad_rt(
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


