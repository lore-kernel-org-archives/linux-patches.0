Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2647A37E2E5;
	Thu, 20 Aug 2026 15:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238400; cv=none; b=DqOz682AZpgBzR8fE9WzshdY10HLsoc7dzMOwXxShT4vNtCMVY0cgTYssghO6a/kmLcLpApS7DRdv67BY/atuuo058XiRY2tLgaGAnzwvk0YMRYXQKOowC7OpJ+OCImdx8I8wKsp1iz9/nsVo0W9gHRsrNgPauP7dv+3YsDQKO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238400; c=relaxed/simple;
	bh=9YMXFn9vxLUQZ1DzZ0NdtNHiTMyLOujWhz3wYGYNpSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WBGPBFa9u0eTE/WOPiGlGct9xmNlErpeBkVFovFaP37dqaxi9nDaTa80/W9z23ii58oMpHDbkH3iWvcdXC8pMzYJIa3imm2TV/O+gNkIjVm4F94h2P+RQj/Q0d22BquCQbaZskSmSsFwSe4sY++qgA48Po5lUbsttKStPkZ3EYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B7CzdJ8b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B7CzdJ8b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5212C1F000E9;
	Thu, 20 Aug 2026 15:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238398;
	bh=+o6zd/E9x0L5PRiiTH7oIVkfvsSMzVaAt0e3JoeK2vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B7CzdJ8b7649AyeRoSsUCnr6dlUuCBdLu3pQscA34ytNV7PGwmFfabKyF0PtKiJok
	 mW11o5wGhItokI5F6EGe1tM6NP0LHFtPX3E+TDXRODpyeJzSjXYBLR8TkOA+ktP+Na
	 Xcyn8GZPsyPs3kDSY53RBEtFio3Uct+cYjxJzP5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.1 133/228] xfs: only check mergeability of bnobt records
Date: Thu, 20 Aug 2026 16:54:35 +0200
Message-ID: <20260820145248.650448944@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 	if (xfs_alloc_check_irec(to_perag(bs->cur->bc_group), &irec) != NULL) {
@@ -144,7 +144,8 @@ xchk_allocbt_rec(
 		return 0;
 	}
 
-	xchk_allocbt_mergeable(bs, ca, &irec);
+	if (bs->sc->sm->sm_type == XFS_SCRUB_TYPE_BNOBT)
+		xchk_allocbt_mergeable(bs, ca, &irec);
 	xchk_allocbt_xref(bs->sc, &irec);
 
 	return 0;


