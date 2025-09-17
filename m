Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB4930CB51;
	Wed, 17 Sep 2025 12:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113101; cv=none; b=rzFt2sJSvYpDAP8O969NQrSZ5hcO16zMZHjWuWj/ccgGn8XGarWA/xbB4y0qwCx6b3o6fyJ0WEldOgxy7nwBxbHgb4qhg4c3IHZijNu5CTiXTxEEy2uYAkYtDqqWqS0jvd8LEP2g24lclp6b+PlN7t+QzgwDYu6+/nF6ja9/RRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113101; c=relaxed/simple;
	bh=EI1G9mB/M03txTvR6kFjiE4cBrp3VB2yrqXjo9uBuPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1x76vZym6b4gkg+htC5CBegds+D3oJQ/e6EOIjorwMiq8B4DzBlZjb/D6lJuxf/sVUQ2/+I/H7FObh2FvHaJyqdejVQdQZ4DTAtZWHrlUd3AiwRM8NlIzUdiItsKWlBtQoCoc9kCvrRfeCB/mCJABNxHQwSzWHXYDC/Xg3O5eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JbxAxGy5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JbxAxGy5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7CBC4CEF0;
	Wed, 17 Sep 2025 12:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113101;
	bh=EI1G9mB/M03txTvR6kFjiE4cBrp3VB2yrqXjo9uBuPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JbxAxGy5Dxh4LNq9nwS/n/u6P6L+d+kvoxRiYGmYS2OrGdOT0wdVbc0q/bQu5rmZK
	 SpezYqHPHlupUATwkwxX+vRwfJpdoTlkxT1SxnAwdoQXbhw5oe1WznxZDYZUn9PRF0
	 dAXuprHZLFaprtVq2OYTX1RVPibV3136eawq7zf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 172/189] erofs: unify meta buffers in z_erofs_fill_inode()
Date: Wed, 17 Sep 2025 14:34:42 +0200
Message-ID: <20250917123356.082582101@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit df50848bcd9f17e4e60e6d5823d0e8fe8982bbab ]

There is no need to keep additional local metabufs since we already
have one in `struct erofs_map_blocks`.

This was actually a leftover when applying meta buffers to zmap
operations, see commit 09c543798c3c ("erofs: use meta buffers for
zmap operations").

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250716064152.3537457-1-hsiangkao@linux.alibaba.com
Stable-dep-of: 131897c65e2b ("erofs: fix invalid algorithm for encoded extents")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zmap.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index 301afd9be4e30..cd33a5d29406c 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -641,13 +641,12 @@ static int z_erofs_map_blocks_ext(struct inode *inode,
 	return 0;
 }
 
-static int z_erofs_fill_inode_lazy(struct inode *inode)
+static int z_erofs_fill_inode(struct inode *inode, struct erofs_map_blocks *map)
 {
 	struct erofs_inode *const vi = EROFS_I(inode);
 	struct super_block *const sb = inode->i_sb;
 	int err, headnr;
 	erofs_off_t pos;
-	struct erofs_buf buf = __EROFS_BUF_INITIALIZER;
 	struct z_erofs_map_header *h;
 
 	if (test_bit(EROFS_I_Z_INITED_BIT, &vi->flags)) {
@@ -667,7 +666,7 @@ static int z_erofs_fill_inode_lazy(struct inode *inode)
 		goto out_unlock;
 
 	pos = ALIGN(erofs_iloc(inode) + vi->inode_isize + vi->xattr_isize, 8);
-	h = erofs_read_metabuf(&buf, sb, pos);
+	h = erofs_read_metabuf(&map->buf, sb, pos);
 	if (IS_ERR(h)) {
 		err = PTR_ERR(h);
 		goto out_unlock;
@@ -705,7 +704,7 @@ static int z_erofs_fill_inode_lazy(struct inode *inode)
 		erofs_err(sb, "unknown HEAD%u format %u for nid %llu, please upgrade kernel",
 			  headnr + 1, vi->z_algorithmtype[headnr], vi->nid);
 		err = -EOPNOTSUPP;
-		goto out_put_metabuf;
+		goto out_unlock;
 	}
 
 	if (!erofs_sb_has_big_pcluster(EROFS_SB(sb)) &&
@@ -714,7 +713,7 @@ static int z_erofs_fill_inode_lazy(struct inode *inode)
 		erofs_err(sb, "per-inode big pcluster without sb feature for nid %llu",
 			  vi->nid);
 		err = -EFSCORRUPTED;
-		goto out_put_metabuf;
+		goto out_unlock;
 	}
 	if (vi->datalayout == EROFS_INODE_COMPRESSED_COMPACT &&
 	    !(vi->z_advise & Z_EROFS_ADVISE_BIG_PCLUSTER_1) ^
@@ -722,27 +721,25 @@ static int z_erofs_fill_inode_lazy(struct inode *inode)
 		erofs_err(sb, "big pcluster head1/2 of compact indexes should be consistent for nid %llu",
 			  vi->nid);
 		err = -EFSCORRUPTED;
-		goto out_put_metabuf;
+		goto out_unlock;
 	}
 
 	if (vi->z_idata_size ||
 	    (vi->z_advise & Z_EROFS_ADVISE_FRAGMENT_PCLUSTER)) {
-		struct erofs_map_blocks map = {
+		struct erofs_map_blocks tm = {
 			.buf = __EROFS_BUF_INITIALIZER
 		};
 
-		err = z_erofs_map_blocks_fo(inode, &map,
+		err = z_erofs_map_blocks_fo(inode, &tm,
 					    EROFS_GET_BLOCKS_FINDTAIL);
-		erofs_put_metabuf(&map.buf);
+		erofs_put_metabuf(&tm.buf);
 		if (err < 0)
-			goto out_put_metabuf;
+			goto out_unlock;
 	}
 done:
 	/* paired with smp_mb() at the beginning of the function */
 	smp_mb();
 	set_bit(EROFS_I_Z_INITED_BIT, &vi->flags);
-out_put_metabuf:
-	erofs_put_metabuf(&buf);
 out_unlock:
 	clear_and_wake_up_bit(EROFS_I_BL_Z_BIT, &vi->flags);
 	return err;
@@ -760,7 +757,7 @@ int z_erofs_map_blocks_iter(struct inode *inode, struct erofs_map_blocks *map,
 		map->m_la = inode->i_size;
 		map->m_flags = 0;
 	} else {
-		err = z_erofs_fill_inode_lazy(inode);
+		err = z_erofs_fill_inode(inode, map);
 		if (!err) {
 			if (vi->datalayout == EROFS_INODE_COMPRESSED_FULL &&
 			    (vi->z_advise & Z_EROFS_ADVISE_EXTENTS))
-- 
2.51.0



