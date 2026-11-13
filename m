Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585984;
	b=X5i8H5/bYe0Q9EYh8UMj35mRIfEuBmyOZ8oyHBQkCP+UAbDhfvZxuO3AMTclQJv2+3y3
	 QFcJsu6cmOKj8tASI8v0M+77YE05bp6Lq9/bAEYcYS5fpU7IdgAq5QB5FjnsWdShrh3gO
	 FXuagi/z+x2YFKEz9QURMEA+cfirbbWX59xgn2gI6ZX/6z1CXkS7wzV+PUP9N5s7OOaSe
	 4zJuYUpcUg+cLIgihOCkO2CvaXisRgeEk0GebqFMsxYbBMuLmnR52TBpfUAjXLRmyS+o6
	 ae+qQz+qACuOwlvItDwG34fOvMN7Ou0OpH2jH0gy+Ch5jrof/51P8Y18jzeKfXpihkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585984;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F7Uv95lRIeLStSQeOSoyMGEVIsUxKmyGVvUd9yxu6BE=;
	b=KDyAX9yyEr6O7hKI2hwhmrjtOGH5VGZbOnEA0oZh1VB2RRzTusS926vphQvAnzGGpiEL
	 c44Oq/bLhyjkRcR8kmIacmQ1MrI/8KQ2aqTc1C3ALvEVigN3kvhSSkByMkfdaQyBlQt4c
	 keZ+FV0yC5SZ/W5wsD1OCGo7ZH469N+bUH0L2MpogovKCqzK0T8MMLwai3mffNla5Wy4T
	 UaRDma+1J8twrAv2cmfd1DgpkDFNNU1XyKUMnKuLK8LaQhoe24O30GWt2n4YRTnk9Z3Ot
	 nrxbeWOOhpLBeajwNVJ40n63WjTTcZYlwN8Gb1IzhQLOD9HnBBgHldCFMQilS8t5vxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UFQo4WJh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB156072317;
	Fri, 13 Nov 2026 16:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UFQo4WJh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6091F000C4;
	Fri, 13 Nov 2026 16:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585984;
	bh=F7Uv95lRIeLStSQeOSoyMGEVIsUxKmyGVvUd9yxu6BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UFQo4WJhg6oKutqawRG2qy2DjNfA97vh6yR0Vmxw6PwwcPpxuIygXAsMX8kb3mSoj
	 fyxld4an9nTgUkqTjq0sASOxHf3Sz94taPtvf8y9mToGGILFY+XdwLta25Jz6zlGgI
	 Omul/Uwt484AH/KtSaWQ7kN3xrLBdp6DyAP4lzaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 029/686] xfs: improve dirent bounds checking in scrub and repair
Date: Fri, 13 Nov 2026 10:42:42 -0500
Message-ID: <20261113153821.972554974@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

[ Upstream commit 5d470234d04dae6fe2ca2cf4b9ef277b78c7e05a ]

LOLLM complains that we don't do enough bounds checking of the directory
entries in directory blocks when we're looking for errors or trying to
salvage entries.  Let's improve that with more detailed checks.

Cc: stable@vger.kernel.org # v4.16
Fixes: ce92d29ddf9908 ("xfs: directory scrubber must walk through data block to offset")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/dir.c        | 68 +++++++++++++++++++++++++++++++++------
 fs/xfs/scrub/dir_repair.c | 37 ++++++++++++++++++---
 2 files changed, 91 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 2f73baee0f0b4..495fdf3b519ae 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -323,11 +323,24 @@ xchk_dir_check_unused(
 	struct xchk_da_btree		*ds,
 	struct xfs_buf			*bp,
 	unsigned int			iter_off,
-	unsigned int			end)
+	unsigned int			end,
+	xfs_dablk_t			rec_bno)
 {
 	struct xfs_dir2_data_unused	*dup = bp->b_addr + iter_off;
+	unsigned int			advance;
+
+	if (iter_off + sizeof(*dup) > end) {
+		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+		return -1;
+	}
+
+	advance = xfs_dir2_data_unusedsize(be16_to_cpu(dup->length));
+	if (!advance || iter_off + advance > end) {
+		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+		return -1;
+	}
 
-	return be16_to_cpu(dup->length);
+	return advance;
 }
 
 /*
@@ -341,15 +354,31 @@ xchk_dir_check_entry(
 	struct xfs_buf			*bp,
 	unsigned int			iter_off,
 	unsigned int			end,
-	struct xfs_dir2_data_entry	*dent)
+	struct xfs_dir2_data_entry	*dent,
+	xfs_dablk_t			rec_bno)
 {
 	struct xfs_dir2_data_entry	*dep = bp->b_addr + iter_off;
 	struct xfs_mount		*mp = ds->state->mp;
+	unsigned int			advance;
+
+	/* must have namelen */
+	advance = offsetof(typeof(*dep), name);
+	if (iter_off + advance >= end) {
+		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+		return -1;
+	}
+
+	/* Don't walk off the end of the block. */
+	advance = xfs_dir2_data_entsize(mp, dep->namelen);
+	if (!advance || iter_off + advance > end) {
+		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+		return -1;
+	}
 
 	if (dep == dent)
 		return 0;
 
-	return xfs_dir2_data_entsize(mp, dep->namelen);
+	return advance;
 }
 
 /* Scrub a directory btree record. */
@@ -377,6 +406,7 @@ xchk_dir_rec(
 	xfs_dahash_t			hash;
 	struct xfs_dir3_icleaf_hdr	hdr;
 	unsigned int			tag;
+	bool				foundit = false;
 	int				error;
 
 	ASSERT(blk->magic == XFS_DIR2_LEAF1_MAGIC ||
@@ -421,33 +451,44 @@ xchk_dir_rec(
 	dent = bp->b_addr + off;
 
 	/* Make sure we got a real directory entry. */
-	iter_off = geo->data_entry_offset;
 	end = xfs_dir3_data_end_offset(geo, bp->b_addr);
 	if (!end) {
 		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 		goto out_relse;
 	}
-	for (;;) {
+	iter_off = geo->data_entry_offset;
+	while (iter_off < end) {
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + iter_off;
 		int				advance;
 
-		if (iter_off >= end) {
+		/* must have freetag */
+		advance = offsetof(typeof(*dup), length);
+		if (iter_off + advance >= end) {
 			xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 			goto out_relse;
 		}
 
 		if (dup->freetag == cpu_to_be16(XFS_DIR2_DATA_FREE_TAG))
-			advance = xchk_dir_check_unused(ds, bp, iter_off, end);
+			advance = xchk_dir_check_unused(ds, bp, iter_off, end,
+					rec_bno);
 		else
 			advance = xchk_dir_check_entry(ds, bp, iter_off, end,
-					dent);
+					dent, rec_bno);
 		if (advance < 0)
 			goto out_relse;
-		if (!advance)
+		if (!advance) {
+			foundit = true;
 			break;
+		}
 		iter_off += advance;
 	}
 
+	/* Hash tree must point to the exact dirent */
+	if (!foundit) {
+		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+		goto out_relse;
+	}
+
 	/* Retrieve the entry, sanity check it, and compare hashes. */
 	ino = be64_to_cpu(dent->inumber);
 	hash = be32_to_cpu(ent->hashval);
@@ -459,6 +500,13 @@ xchk_dir_rec(
 		goto out_relse;
 	}
 
+	/* Name must not overflow end of block */
+	if ((char *)dent->name + dent->namelen >
+	    (char *)bp->b_addr + BBTOB(bp->b_length)) {
+		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+		goto out_relse;
+	}
+
 	/* Does the directory hash match? */
 	dname.name = dent->name;
 	dname.len = dent->namelen;
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index f8e88b638c43d..c7fd39fd83a48 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -473,8 +473,16 @@ xrep_dir_recover_unused(
 	unsigned int			end)
 {
 	struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
+	unsigned int			advance;
+
+	if (offset + sizeof(*dup) > end)
+		return 0;
+
+	advance = xfs_dir2_data_unusedsize(be16_to_cpu(dup->length));
+	if (!advance || offset + advance > end)
+		return 0;
 
-	return be16_to_cpu(dup->length);
+	return advance;
 }
 
 /*
@@ -492,11 +500,14 @@ xrep_dir_recover_entry(
 	unsigned int			advance;
 	int				error;
 
+	/* must have namelen */
+	advance = offsetof(typeof(*dep), name);
+	if (offset + advance >= end)
+		return 0;
+
 	/* Don't walk off the end of the block. */
 	advance = xfs_dir2_data_entsize(rd->sc->mp, dep->namelen);
-	if (!advance)
-		return 0;
-	if (offset + advance > end)
+	if (!advance || offset + advance > end)
 		return 0;
 
 	/* Ok, let's save this entry. */
@@ -534,6 +545,11 @@ xrep_dir_recover_data(
 		if (xchk_should_terminate(rd->sc, &error))
 			return error;
 
+		/* must have freetag */
+		advance = offsetof(typeof(*dup), length);
+		if (offset + advance >= end)
+			break;
+
 		if (dup->freetag == cpu_to_be16(XFS_DIR2_DATA_FREE_TAG))
 			advance = xrep_dir_recover_unused(bp, offset, end);
 		else
@@ -565,6 +581,19 @@ xrep_dir_recover_sf(
 	hdr = ifp->if_data;
 	end = (unsigned char *)ifp->if_data + ifp->if_bytes;
 
+	/* sf header must be big enough for count/i8count */
+	if (!hdr || ifp->if_bytes < 2)
+		return 0;
+
+	/* and large enough for the parent inumber */
+	if (hdr->i8count) {
+		if (ifp->if_bytes < offsetof(struct xfs_dir2_sf_hdr, parent[8]))
+			return 0;
+	} else {
+		if (ifp->if_bytes < offsetof(struct xfs_dir2_sf_hdr, parent[4]))
+			return 0;
+	}
+
 	ino = xfs_dir2_sf_get_parent_ino(hdr);
 	trace_xrep_dir_salvaged_parent(rd->sc->ip, ino);
 
-- 
2.53.0



