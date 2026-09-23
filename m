Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA8151C356;
	Wed, 23 Sep 2026 14:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175294; cv=none; b=Uxm5osftC5PnvsE2TQXtfSig99ii8nXlxm/USlFb3FErC1pSerm1f79VDwK6YGzigXzLDj5777dshyWbsCmy1IXKDkImN4hawvaHQFfZ1ykj10N44qfQOiAeSf2shX8f8vb2dX8ug0EsJbk00TezUAYZe9jh94yRMNT8uV4fKKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175294; c=relaxed/simple;
	bh=tSZHHoM/LC6+fCPIBakbSl0ijHURviwDWQ705ftXxBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QeolRi7UYndKIrE5nEuIf66mLwLIMQP8cbqehuYgSrpCOvzmTq543zC8xh6lm8Ji8i9O3HaTNTlDni82Skfnfp6Dp6vRPC115PMlecYCIB5n3E42u+TsaB+dJhXkOT99yuE6RtjGN7JuzFk/ABLA35ZIXAuULQ76Rw6VXINlNHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p53iAG6t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p53iAG6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B678F1F00893;
	Wed, 23 Sep 2026 14:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175292;
	bh=Bjg+w6S3ysx8tjwAKXxQb94D2z3TjTwlWx2hJg6RGcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p53iAG6tH7lgVMjf4TqOV5iC3iWRpjf8Lp7pIv50TYAtmn7o+CngXHKNvHV6YU9gn
	 tmLWZkXRjlys40fmMt5DJ6LnTzyy2pAL0G/fGPPrT/0DXdUBaAhkSQ/E6tp5OKmgDT
	 bJii3OO5icR0FMkqej/Rj5dk21BNYTL0ksVy0qPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 381/398] xfs: add a xfs_rmap_inode_owner helper
Date: Wed, 23 Sep 2026 16:07:35 +0200
Message-ID: <20260923140653.336079567@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit f882fc7dd9f04f73d94379deb9e68d8db613c976 ]

Add a small wrapper for initializing the rmap owner to i_ino.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Stable-dep-of: 4d3c07591534 ("xfs: fix under-reservation of blocks when repairing sf directories")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    2 +-
 fs/xfs/libxfs/xfs_rmap.h |    2 ++
 fs/xfs/scrub/bmap.c      |    6 +++---
 fs/xfs/scrub/reap.c      |    3 +--
 4 files changed, 7 insertions(+), 6 deletions(-)

--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -820,7 +820,7 @@ xfs_bmap_local_to_extents(
 	args.mp = ip->i_mount;
 	args.total = total;
 	args.minlen = args.maxlen = args.prod = 1;
-	xfs_rmap_ino_owner(&args.oinfo, ip->i_ino, whichfork, 0);
+	xfs_rmap_inode_owner(&args.oinfo, ip, whichfork, 0);
 
 	/*
 	 * Allocate a block.  We know we need only one, since the
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -35,6 +35,8 @@ xfs_rmap_ino_owner(
 	if (whichfork == XFS_ATTR_FORK)
 		oi->oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
 }
+#define xfs_rmap_inode_owner(oi, ip, whichfork, offset) \
+	xfs_rmap_ino_owner(oi, (ip)->i_ino, whichfork, offset)
 
 static inline bool
 xfs_rmap_should_skip_owner_update(
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -352,7 +352,7 @@ xchk_bmap_rt_iextent_xref(
 	case XFS_DATA_FORK:
 		xchk_bmap_xref_rmap(info, irec, rgbno);
 		if (!xfs_is_reflink_inode(info->sc->ip)) {
-			xfs_rmap_ino_owner(&oinfo, info->sc->ip->i_ino,
+			xfs_rmap_inode_owner(&oinfo, info->sc->ip,
 					info->whichfork, irec->br_startoff);
 			xchk_xref_is_only_rt_owned_by(info->sc, rgbno,
 					irec->br_blockcount, &oinfo);
@@ -407,7 +407,7 @@ xchk_bmap_iextent_xref(
 	case XFS_DATA_FORK:
 		xchk_bmap_xref_rmap(info, irec, agbno);
 		if (!xfs_is_reflink_inode(info->sc->ip)) {
-			xfs_rmap_ino_owner(&oinfo, info->sc->ip->i_ino,
+			xfs_rmap_inode_owner(&oinfo, info->sc->ip,
 					info->whichfork, irec->br_startoff);
 			xchk_xref_is_only_owned_by(info->sc, agbno,
 					irec->br_blockcount, &oinfo);
@@ -419,7 +419,7 @@ xchk_bmap_iextent_xref(
 		break;
 	case XFS_ATTR_FORK:
 		xchk_bmap_xref_rmap(info, irec, agbno);
-		xfs_rmap_ino_owner(&oinfo, info->sc->ip->i_ino,
+		xfs_rmap_inode_owner(&oinfo, info->sc->ip,
 				info->whichfork, irec->br_startoff);
 		xchk_xref_is_only_owned_by(info->sc, agbno, irec->br_blockcount,
 				&oinfo);
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -1249,8 +1249,7 @@ xreap_bmapi_select(
 	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
 			sc->sa.pag);
 
-	xfs_rmap_ino_owner(&oinfo, rs->ip->i_ino, rs->whichfork,
-			imap->br_startoff);
+	xfs_rmap_inode_owner(&oinfo, rs->ip, rs->whichfork, imap->br_startoff);
 	error = xfs_rmap_has_other_keys(cur, agbno, 1, &oinfo, crosslinked);
 	if (error)
 		goto out_cur;


