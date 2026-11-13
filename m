Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590873;
	b=gkDjDlrANlS4M5gicu3KeotUJGGCtDafCfOsY3I4bQ9M5MzHj9m2XBSeWic+gHbLJefu
	 3ERbiwRH1viRU5K+Pfvs4roIHTWUp0XUTlZT+SZsfJ2ispuFaosglKGkpCkFcmUjSwDWd
	 lhAz/axvv3nZA6Zy+wcdJj07/n+YEjebxgASoKWq0LxjVf7hG5/xqGJZqip3WagGfP8cg
	 I1aoX78mLHOb5NHvhAV71/72zF73mrsT1oyJiHprPRYlll0RA0abCnO660gWDb1froVGB
	 Y85R58xWHxMNwKrdXbjt5ptJ5mGs7B+y2cClmQWFfcEgJEpHdKgHjsndaaX4NFHD4gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590873;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=21O9dfQ8+y4k98ID/qFw53cOQEvx9WAk3TcTZHwUJ50=;
	b=OC2Wap4uAJSp5DIKVsSUNCFZaxyeA72MP7kNSA2pMifFxhZ15dGxeIPUbip2Qo0nUB4G
	 2NSSCE8SJAEjieAsKHHilWlJQEtGIJagvBYbtLw18cKPFg0CWpuiOTKeR8W2y4zqhEq97
	 sqPEGy5yS2JZnF1ZX6LPaoOm1UHMPlo+4CuNtTST2zsuxmWWCssZ5i3qMZd1Y3QbNOLOR
	 FEfUrTSwzjbWHsw0YzzqBYqe21S81WohD/LzoG+ck20Oq06ATbljYyeZhcnJqDBWl+KjW
	 njHbG7TpCLDdCNwqUcoRcwzP8wMGVFYbFZ+31kA0s20GStfPTHyBAC86wfAcIVtta6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m4uUaA7h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0416606D4A9;
	Fri, 13 Nov 2026 17:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m4uUaA7h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5BF1F000C5;
	Fri, 13 Nov 2026 17:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590872;
	bh=21O9dfQ8+y4k98ID/qFw53cOQEvx9WAk3TcTZHwUJ50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m4uUaA7hg2cZNW2dVKBgWO9T0bV+78B+VsZOWSU2bTKtdYjKZqb5BCEoiWk/OQTGe
	 cFJ9vizYkh0QP1hehFZJJVE6NKqA7rNj42eN4PxtVWoXpDJ6J4vqg7t1Lawg16MVoY
	 rAkGRlB0t3UugWM1SmkeWxyptrgfq53ZQuX2GvP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/670] xfs: mark cow extents bad if theres no rmap mapping for them
Date: Fri, 13 Nov 2026 10:43:54 -0500
Message-ID: <20261113153813.920267472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 2ffc0619c9c2881443c5fffb10db8f2bc0aa2ce8 ]

LOLLM noticed that we fail to mark cow staging extents as bad if there's
a cow staging extent but no rmap record for the cow staging event.
Close this gap.

Cc: stable@vger.kernel.org # v6.8
Fixes: dbbdbd0086320a ("xfs: repair problems in CoW forks")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: Replaced xfs_gbno_to_fsb() and xfs_agbno_to_fsb() calls with the existing XFS_AGB_TO_FSB() macro. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/cow_repair.c | 66 +++++++++++++++++++++++++--------------
 1 file changed, 42 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
index e8f7cfd4dd22b..853744729577b 100644
--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -194,30 +194,37 @@ xrep_cow_mark_missing_staging_rmap(
 	void				*priv)
 {
 	struct xrep_cow			*xc = priv;
-	xfs_fsblock_t			fsbno;
-	xfs_agblock_t			rec_bno;
-	xfs_extlen_t			rec_len;
-	unsigned int			adj;
+	const xfs_agblock_t		rec_end =
+			rec->rm_startblock + rec->rm_blockcount;
+	int				error = 0;
 
-	if (rec->rm_owner == XFS_RMAP_OWN_COW)
-		return 0;
-
-	rec_bno = rec->rm_startblock;
-	rec_len = rec->rm_blockcount;
-	if (rec_bno < xc->irec_startbno) {
-		adj = xc->irec_startbno - rec_bno;
-		rec_len -= adj;
-		rec_bno += adj;
+	/* Was there a gap since the last rmap? */
+	if (xc->next_bno < rec->rm_startblock) {
+		error = xrep_cow_mark_file_range(xc,
+				XFS_AGB_TO_FSB(xc->sc->mp, cur->bc_ag.pag->pag_agno,
+					       xc->next_bno),
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
+				XFS_AGB_TO_FSB(xc->sc->mp, cur->bc_ag.pag->pag_agno,
+					       bad_bno),
+				bad_end - bad_bno);
+		if (error)
+			return error;
 	}
 
-	fsbno = XFS_AGB_TO_FSB(xc->sc->mp, cur->bc_ag.pag->pag_agno, rec_bno);
-	return xrep_cow_mark_file_range(xc, fsbno, rec_len);
+	xc->next_bno = max(xc->next_bno, rec_end);
+	return error;
 }
 
 /*
@@ -235,10 +242,12 @@ xrep_cow_find_bad(
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
@@ -250,7 +259,7 @@ xrep_cow_find_bad(
 
 	/* Mark any CoW fork extents that are shared. */
 	rc_low.rc_startblock = xc->irec_startbno;
-	rc_high.rc_startblock = xc->irec_startbno + xc->irec.br_blockcount - 1;
+	rc_high.rc_startblock = irec_end - 1;
 	rc_low.rc_domain = rc_high.rc_domain = XFS_REFC_DOMAIN_SHARED;
 	error = xfs_refcount_query_range(sc->sa.refc_cur, &rc_low, &rc_high,
 			xrep_cow_mark_shared_staging, xc);
@@ -259,7 +268,7 @@ xrep_cow_find_bad(
 
 	/* Make sure there are CoW staging extents for the whole mapping. */
 	rc_low.rc_startblock = xc->irec_startbno;
-	rc_high.rc_startblock = xc->irec_startbno + xc->irec.br_blockcount - 1;
+	rc_high.rc_startblock = irec_end - 1;
 	rc_low.rc_domain = rc_high.rc_domain = XFS_REFC_DOMAIN_COW;
 	xc->next_bno = xc->irec_startbno;
 	error = xfs_refcount_query_range(sc->sa.refc_cur, &rc_low, &rc_high,
@@ -267,12 +276,11 @@ xrep_cow_find_bad(
 	if (error)
 		goto out_sa;
 
-	if (xc->next_bno < xc->irec_startbno + xc->irec.br_blockcount) {
+	if (xc->next_bno < irec_end) {
 		error = xrep_cow_mark_file_range(xc,
 				XFS_AGB_TO_FSB(sc->mp, pag->pag_agno,
 					       xc->next_bno),
-				xc->irec_startbno + xc->irec.br_blockcount -
-				xc->next_bno);
+				irec_end - xc->next_bno);
 		if (error)
 			goto out_sa;
 	}
@@ -281,11 +289,21 @@ xrep_cow_find_bad(
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
+				XFS_AGB_TO_FSB(sc->mp, pag->pag_agno,
+					       xc->next_bno),
+				irec_end - xc->next_bno);
+		if (error)
+			goto out_sa;
+	}
+
 	/*
 	 * If userspace is forcing us to rebuild the CoW fork or someone turned
 	 * on the debugging knob, replace everything in the CoW fork.
-- 
2.53.0



