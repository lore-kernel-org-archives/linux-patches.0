Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366613624A5;
	Sat, 12 Sep 2026 09:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203996; cv=none; b=Ot2VkCPWWKYmAygHhCinKA4B40wgV9PIzferTQ/zgptZIXIpx/yJHYIHZnj1fLsPZ9wYahirptY9J+7of1c+8zUo+AkF4tikPW8gQY8i+MGYetChMOkjhB0vfAL/3lWcatwdpPljmpcvWDAo0+Sv8mSML3NOVugJtfcG30gefzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203996; c=relaxed/simple;
	bh=hls9SvcfjklHT3+0XPflbboQYuRhod3AfdcJoWUhY10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lyz0dGKiPqfqQGutCOqdP5AjbxLEJiwyAAOfIvOCnC3vB/b16+slmE2dySqR24DGEahvFFwjgolhCBUnhi5tQjQ4wdQnG7v802mUW8dksD6msf9g5E+5QoKcxXDIJ24gS+Vu0OTi/J656ew0PcK7/VFgVmnqpFnOizLFsO6AsQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XPLEPn7d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XPLEPn7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5871F000FF;
	Sat, 12 Sep 2026 09:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203994;
	bh=R4ofD42hB75lEIFGfKCOUb/3WLFDTJAxW/iOmi6LDMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XPLEPn7dBySmYOhuMblY3lCImi3f2xgEmOquI0tWktG8JnSkJbnEg4geaRLJjPeR1
	 B6vrJKn+qvkQMvsdlHGmGNu7LVCN29JK+M6nUScMOWJ66eE4AhhZ0iPfOr4HrldAse
	 IOG64z+excJRKcEhhVSJg4aIMkTApZpb8clCGbgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <xiang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1523/1815] erofs: guard on-disk algorithm IDs against Z_EROFS_COMPRESSION_MAX
Date: Sat, 12 Sep 2026 08:54:33 +0200
Message-ID: <20260912065724.756242281@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Gao Xiang <xiang@kernel.org>

[ Upstream commit 6847d4d1a24a686ca6c8a0f68501a984f9a0d059 ]

All on-disk algorithm IDs should be validated against
supported Z_EROFS_COMPRESSION_MAX.

This includes a partial revert of a previous commit and also adds
validation for encoded extents.

Fixes: 131897c65e2b ("erofs: fix invalid algorithm for encoded extents")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/internal.h |  2 +-
 fs/erofs/zmap.c     | 35 +++++++++++++++++++++--------------
 2 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 57bd21859c65d..bee2f50c8488f 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -269,7 +269,7 @@ struct erofs_inode {
 #ifdef CONFIG_EROFS_FS_ZIP
 		struct {
 			unsigned short z_advise;
-			unsigned char  z_algorithmtype[2];
+			unsigned char  z_algofmt[2];
 			unsigned char  z_lclusterbits;
 			union {
 				u64    z_tailextent_headlcn;
diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index b5411b579fd90..b316a50efe383 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -488,10 +488,9 @@ static int z_erofs_map_blocks_fo(struct inode *inode,
 			map->m_algorithmformat = Z_EROFS_COMPRESSION_INTERLACED;
 		else
 			map->m_algorithmformat = Z_EROFS_COMPRESSION_SHIFTED;
-	} else if (m.headtype == Z_EROFS_LCLUSTER_TYPE_HEAD2) {
-		map->m_algorithmformat = vi->z_algorithmtype[1];
 	} else {
-		map->m_algorithmformat = vi->z_algorithmtype[0];
+		map->m_algorithmformat =
+			vi->z_algofmt[m.headtype == Z_EROFS_LCLUSTER_TYPE_HEAD2];
 	}
 
 	if ((flags & EROFS_GET_BLOCKS_FIEMAP) ||
@@ -605,9 +604,14 @@ static int z_erofs_map_blocks_ext(struct inode *inode,
 			if (map->m_plen & Z_EROFS_EXTENT_PLEN_PARTIAL)
 				map->m_flags |= EROFS_MAP_PARTIAL_REF;
 			map->m_plen &= Z_EROFS_EXTENT_PLEN_MASK;
-			if (fmt)
-				map->m_algorithmformat = fmt - 1;
-			else if (interlaced && !((map->m_pa | map->m_plen) & bmask))
+			if (fmt) {
+				map->m_algorithmformat = --fmt;
+				if (fmt >= Z_EROFS_COMPRESSION_MAX) {
+					erofs_err(sb, "unknown algorithm %d @ pos %llu for nid %llu, please upgrade kernel",
+						  fmt, map->m_la, vi->nid);
+					return -EOPNOTSUPP;
+				}
+			} else if (interlaced && !((map->m_pa | map->m_plen) & bmask))
 				map->m_algorithmformat =
 					Z_EROFS_COMPRESSION_INTERLACED;
 			else
@@ -625,7 +629,7 @@ static int z_erofs_fill_inode(struct inode *inode, struct erofs_map_blocks *map)
 	struct super_block *const sb = inode->i_sb;
 	struct z_erofs_map_header *h;
 	erofs_off_t pos;
-	int err = 0;
+	int err = 0, nr;
 
 	if (test_bit(EROFS_I_Z_INITED_BIT, &vi->flags)) {
 		/*
@@ -668,12 +672,19 @@ static int z_erofs_fill_inode(struct inode *inode, struct erofs_map_blocks *map)
 		goto done;
 	}
 
-	vi->z_algorithmtype[0] = h->h_algorithmtype & 15;
-	vi->z_algorithmtype[1] = h->h_algorithmtype >> 4;
 	if (vi->z_advise & Z_EROFS_ADVISE_FRAGMENT_PCLUSTER)
 		vi->z_fragmentoff = le32_to_cpu(h->h_fragmentoff);
 	else if (vi->z_advise & Z_EROFS_ADVISE_INLINE_PCLUSTER)
 		vi->z_idata_size = le16_to_cpu(h->h_idata_size);
+	for (nr = 0; nr < 2; ++nr) {
+		vi->z_algofmt[nr] = (h->h_algorithmtype >> (4 * nr)) & 15;
+		if (vi->z_algofmt[nr] >= Z_EROFS_COMPRESSION_MAX) {
+			erofs_err(sb, "unknown HEAD%u format %u for nid %llu, please upgrade kernel",
+				  nr + 1, vi->z_algofmt[nr], vi->nid);
+			err = -EOPNOTSUPP;
+			goto out_unlock;
+		}
+	}
 
 	if (!erofs_sb_has_big_pcluster(EROFS_SB(sb)) &&
 	    vi->z_advise & (Z_EROFS_ADVISE_BIG_PCLUSTER_1 |
@@ -721,12 +732,8 @@ static int z_erofs_map_sanity_check(struct inode *inode,
 
 	if (!(map->m_flags & EROFS_MAP_MAPPED))
 		return 0;
-	if (unlikely(map->m_algorithmformat >= Z_EROFS_COMPRESSION_RUNTIME_MAX)) {
-		erofs_err(inode->i_sb, "unknown algorithm %d @ pos %llu for nid %llu, please upgrade kernel",
-			  map->m_algorithmformat, map->m_la, EROFS_I(inode)->nid);
-		return -EOPNOTSUPP;
-	}
 
+	DBG_BUGON(map->m_algorithmformat >= Z_EROFS_COMPRESSION_RUNTIME_MAX);
 	if (map->m_algorithmformat < Z_EROFS_COMPRESSION_MAX) {
 		if (!(sbi->available_compr_algs & BIT(map->m_algorithmformat))) {
 			erofs_err(inode->i_sb, "inconsistent algorithmtype %u for nid %llu",
-- 
2.53.0



