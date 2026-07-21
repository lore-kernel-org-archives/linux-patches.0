Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5556246EC65;
	Tue, 21 Jul 2026 18:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659580; cv=none; b=mjOxTGxGNDsqfpUCtvFLkUYUchtBEPsqM4n9mGHSKo38WTvewlRDOoSE0wC2YEbFVeE3QTiySe/JU5vsRTkNL0GWgp5IXb8LNK5Mu+fTdKDuVDeTryN7qWWtkPL+iywpqOj0EPk5ukAR0uJH7fP29kvtB/8wgS3DKLHSWexqiOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659580; c=relaxed/simple;
	bh=SSSko2WMXRt8g1B9Ih+g/13CGk8KCENBeoOA/dkRRYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgxOPAFsbMvC690UhwG8eTzzWEUsBAAJ4FFEHNLV/fIdTxHPMoqMgFfsOP546g8IPOcqIZaTNG0pNJWlE6F4+zzRcCeyBVpcBDQqz3PD9qI8vfoMmdWMj9QkOUD0S9kgLvuUDn7UWMbKwDwS2KHiamTajDOPuAFXbVzX7BnvBH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opz4hpyU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opz4hpyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5231F000E9;
	Tue, 21 Jul 2026 18:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659579;
	bh=CIu2z6z3Z7cV03fjMQJgx6adyA1EJL3bCmV1e60LFzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=opz4hpyUQhQhU4bEYxgHlUWWgXWSxqngeRBR4F/gE1XkB4mUDAwHPyJ/M6XKqXmoP
	 vNd3dEP4QoaAQQxf2HN1D9n17kzj10zzMAH53udVllLJ3v4IWhJjWFCLDcmd/X4cwy
	 NR696+0UaPfFsR5XPfkOZI1pbke34kDs3xhaa5c4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1572/1611] xfs: use bio_reuse in the zone GC code
Date: Tue, 21 Jul 2026 17:28:08 +0200
Message-ID: <20260721152550.826895185@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

[ Upstream commit 0506d32f7c52e41f6e8db7c337e0ce6374c6ffbb ]

Replace our somewhat fragile code to reuse the bio, which caused a
regression in the past with the block layer bio_reuse helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: open-coded the bio_reuse logic at the call site as 6.18 lacks
  commit 7ca44303f9f6 ("block: add a bio_reuse helper") ]
Stable-dep-of: ae3692c7f440 ("xfs: add newly added RTGs to the free pool in growfs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_zone_gc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -812,9 +812,8 @@ xfs_zone_gc_write_chunk(
 {
 	struct xfs_zone_gc_data	*data = chunk->data;
 	struct xfs_mount	*mp = chunk->ip->i_mount;
-	phys_addr_t		bvec_paddr =
-		bvec_phys(bio_first_bvec_all(&chunk->bio));
 	struct xfs_gc_bio	*split_chunk;
+	unsigned short		vcnt, i;
 
 	if (chunk->bio.bi_status)
 		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
@@ -826,10 +825,11 @@ xfs_zone_gc_write_chunk(
 	WRITE_ONCE(chunk->state, XFS_GC_BIO_NEW);
 	list_move_tail(&chunk->entry, &data->writing);
 
+	vcnt = chunk->bio.bi_vcnt;
 	bio_reset(&chunk->bio, mp->m_rtdev_targp->bt_bdev, REQ_OP_WRITE);
-	bio_add_folio_nofail(&chunk->bio, chunk->scratch->folio, chunk->len,
-			offset_in_folio(chunk->scratch->folio, bvec_paddr));
-
+	for (i = 0; i < vcnt; i++)
+		chunk->bio.bi_iter.bi_size += chunk->bio.bi_io_vec[i].bv_len;
+	chunk->bio.bi_vcnt = vcnt;
 	while ((split_chunk = xfs_zone_gc_split_write(data, chunk)))
 		xfs_zone_gc_submit_write(data, split_chunk);
 	xfs_zone_gc_submit_write(data, chunk);


