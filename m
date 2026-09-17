Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0817D55C1CF;
	Thu, 17 Sep 2026 15:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660598; cv=none; b=q5yyPuf4L/g1km/fxEl87t3EDSRV5Bk2ZRFRO6ilTQs63UJdMxqG/ODGE8MFZFkHblhDyxrqYA66YEvosey8ex8lBz+cjq5Z8cs2KtKLBw/vXlQT5wXiTHdbtkuKtyAFtEAquZgxZmclMAJZh3LhvI+l23wWz176ygSeafVfGts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660598; c=relaxed/simple;
	bh=e8Svpg9BuXsGVeDy+lFpGMg4ojZmzplM6MSwBHb8Ark=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLppA7lJVjaGlG2qYfTc14+zognf/pwuOhfgX3HIKNbRuDoEAnGPSF9pSUVBxS9vN3+gmEn3VNzqpsXha90YwBYGY4ORx1qsMhF+zf6LCZI6Kn+N6wpPzKVSwI5qO4J7g3snwIMHcZSRyFg++KktNDQuCbNQ9U5GkXvAoR9Yf9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dMSE1l5T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dMSE1l5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616141F00899;
	Thu, 17 Sep 2026 15:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660596;
	bh=wbUO5KCSf0SZDgarlsnSJ+Txzg8DJNXMxZ1nRdWlJaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dMSE1l5TGjGk9sAWYSTVI6gGDjX/eU62+/O4oAjLzxhNLIgUo2uzPLGUBUem57AIJ
	 afk4q3E5iO3AJoAUvvmGiSxMz4mP6ShUE1Suq6BBzFbe+nyNRw515wGk7pUUQ7ftBO
	 DCLSuR71z/OFqQ2xII/rJtK26K/rCK3sV0YKLB5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 645/733] xfs: snapshot old AGFL before rewriting it
Date: Thu, 17 Sep 2026 16:15:53 +0100
Message-ID: <20260917151408.679234907@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 3466dfef0a20f842363958deea55be9f1d26818a upstream.

LOLLM complains that we can't undo an attempt at fixing the AGFL if
anything goes wrong during the rewrite, so take a snapshot of the whole
buffer so that we can restore it.  Move the xrep_agfl_update_agf call so
that we only update the AGF if the AGFL update is 100% successful.

While we're at it, fix leaking the used_extents bitmap if the disunion
operation fails.

Cc: stable@vger.kernel.org # v4.19
Fixes: 0e93d3f43ec7d3 ("xfs: repair the AGFL")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader_repair.c |   35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -668,14 +668,16 @@ xrep_agfl_init_header(
 	struct xfs_scrub	*sc,
 	struct xfs_buf		*agfl_bp,
 	struct xagb_bitmap	*agfl_extents,
-	xfs_agblock_t		flcount)
+	xfs_agblock_t		flcount,
+	struct xfs_agfl		*old_agfl)
 {
 	struct xrep_agfl_fill	af = {
 		.sc		= sc,
 		.flcount	= flcount,
 	};
 	struct xfs_mount	*mp = sc->mp;
-	struct xfs_agfl		*agfl;
+	struct xfs_agfl		*agfl = XFS_BUF_TO_AGFL(agfl_bp);
+	const size_t		agfl_sz = BBTOB(agfl_bp->b_length);
 	int			error;
 
 	ASSERT(flcount <= xfs_agfl_size(mp));
@@ -684,8 +686,8 @@ xrep_agfl_init_header(
 	 * Start rewriting the header by setting the bno[] array to
 	 * NULLAGBLOCK, then setting AGFL header fields.
 	 */
-	agfl = XFS_BUF_TO_AGFL(agfl_bp);
-	memset(agfl, 0xFF, BBTOB(agfl_bp->b_length));
+	memcpy(old_agfl, agfl, agfl_sz);
+	memset(agfl, 0xFF, agfl_sz);
 	agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
 	agfl->agfl_seqno = cpu_to_be32(pag_agno(sc->sa.pag));
 	uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
@@ -700,13 +702,18 @@ xrep_agfl_init_header(
 	xagb_bitmap_walk(agfl_extents, xrep_agfl_fill, &af);
 	error = xagb_bitmap_disunion(agfl_extents, &af.used_extents);
 	if (error)
-		return error;
+		goto err_undo;
 
 	/* Write new AGFL to disk. */
 	xfs_trans_buf_set_type(sc->tp, agfl_bp, XFS_BLFT_AGFL_BUF);
-	xfs_trans_log_buf(sc->tp, agfl_bp, 0, BBTOB(agfl_bp->b_length) - 1);
+	xfs_trans_log_buf(sc->tp, agfl_bp, 0, agfl_sz - 1);
 	xagb_bitmap_destroy(&af.used_extents);
 	return 0;
+
+err_undo:
+	xagb_bitmap_destroy(&af.used_extents);
+	memcpy(agfl, old_agfl, agfl_sz);
+	return error;
 }
 
 /* Repair the AGFL. */
@@ -718,6 +725,7 @@ xrep_agfl(
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_buf		*agf_bp;
 	struct xfs_buf		*agfl_bp;
+	struct xfs_agfl		*old_agfl;
 	xfs_agblock_t		flcount;
 	int			error;
 
@@ -725,6 +733,10 @@ xrep_agfl(
 	if (!xfs_has_rmapbt(mp))
 		return -EOPNOTSUPP;
 
+	old_agfl = kzalloc(BBTOB(XFS_FSS_TO_BB(mp, 1)), XCHK_GFP_FLAGS);
+	if (!old_agfl)
+		return -ENOMEM;
+
 	xagb_bitmap_init(&agfl_extents);
 
 	/*
@@ -734,7 +746,7 @@ xrep_agfl(
 	 */
 	error = xfs_alloc_read_agf(sc->sa.pag, sc->tp, 0, &agf_bp);
 	if (error)
-		return error;
+		goto err_old_agfl;
 
 	/*
 	 * Make sure we have the AGFL buffer, as scrub might have decided it
@@ -745,7 +757,7 @@ xrep_agfl(
 						XFS_AGFL_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &agfl_bp, NULL);
 	if (error)
-		return error;
+		goto err_old_agfl;
 	agfl_bp->b_ops = &xfs_agfl_buf_ops;
 
 	/* Gather all the extents we're going to put on the new AGFL. */
@@ -762,10 +774,11 @@ xrep_agfl(
 	 * we adjust the AGF flcount (which can fail) so avoid updating any
 	 * buffers until we know that part works.
 	 */
-	xrep_agfl_update_agf(sc, agf_bp, flcount);
-	error = xrep_agfl_init_header(sc, agfl_bp, &agfl_extents, flcount);
+	error = xrep_agfl_init_header(sc, agfl_bp, &agfl_extents, flcount,
+			old_agfl);
 	if (error)
 		goto err;
+	xrep_agfl_update_agf(sc, agf_bp, flcount);
 
 	/*
 	 * Ok, the AGFL should be ready to go now.  Roll the transaction to
@@ -785,6 +798,8 @@ xrep_agfl(
 
 err:
 	xagb_bitmap_destroy(&agfl_extents);
+err_old_agfl:
+	kfree(old_agfl);
 	return error;
 }
 


