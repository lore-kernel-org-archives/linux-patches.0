Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DC13F0A96;
	Thu, 20 Aug 2026 15:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239574; cv=none; b=JpBYznJQZoTIn851TLcahrDl0DlzbtmoLGnM3VEuVVdbcqFXeN6vtDj4Nz8uj2VKGwaRfks4dUPVeQbo1mUdwRklfysQ5DpZwgaE0YpTkho4eyy0ABTfUj7DIeQy6Dw6dmpLNG6IFCTf+lFtBOSmiKc1P8+P/zFdbDcLh7bryGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239574; c=relaxed/simple;
	bh=Wt6q7HaqGrBJtoKKlYJ77UeQ4+xIAOoX0/2jESuoMAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=duTmyMkSLCBCrit6qZdpRpgSM306fPzX5vTElQ2Sp31xGJSixw5Uq/kUzxrZj5033c4KhsVeXiivZqXpDada21ZqP7lkJCkSnteeEEr7Pg1UtT4qh5IW235jUgCAY3E12ntMiKh+jOmCy+WRzkgf94yzkllOkGAfLaJaU0pHrW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fz/X4GM0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fz/X4GM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD781F000E9;
	Thu, 20 Aug 2026 15:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239573;
	bh=84lumzgcbIjPQqmNzSLvf7jwyYR+7k9SogPtVhXOX/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fz/X4GM05ByT01Vhe6OBhvzl2UPDQ4VUph63uAJz+g6PcwQxk8fdE9Yh4loRNNY98
	 BBU4TVJz41+RYxgDA3SvkXdvPX44n28u0PCSnlGvungCZKyF5diarYfs508r3WGQsE
	 jJ2jJ0RBExNg8yIsl7FDc6GLLEYUfTJkrF6HJFpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 094/220] xfs: only check mergeability of bnobt records
Date: Thu, 20 Aug 2026 16:54:44 +0200
Message-ID: <20260820145226.303742081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 97efed1091a50e4dbf31307015138b43a972d2e4 upstream.

In the cntbt (free space by block count) btree, records are not supposed
to be in startblock order.  Hence the mergeability check is pointless.
Remove it, since it does nothing, as LOLLM points out.

Cc: stable@vger.kernel.org # v6.4
Fixes: d5784ae82778d9 ("xfs: flag free space btree records that could be merged")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -136,7 +136,7 @@ xchk_allocbt_rec(
 	const union xfs_btree_rec	*rec)
 {
 	struct xfs_alloc_rec_incore	irec;
-	struct xchk_alloc	*ca = bs->private;
+	struct xchk_alloc		*ca = bs->private;
 
 	xfs_alloc_btrec_to_irec(rec, &irec);
 	if (xfs_alloc_check_irec(bs->cur->bc_ag.pag, &irec) != NULL) {
@@ -144,7 +144,8 @@ xchk_allocbt_rec(
 		return 0;
 	}
 
-	xchk_allocbt_mergeable(bs, ca, &irec);
+	if (bs->sc->sm->sm_type == XFS_SCRUB_TYPE_BNOBT)
+		xchk_allocbt_mergeable(bs, ca, &irec);
 	xchk_allocbt_xref(bs->sc, &irec);
 
 	return 0;


