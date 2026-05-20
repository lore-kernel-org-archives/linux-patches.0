Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0D229B78D;
	Wed, 20 May 2026 18:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301247; cv=none; b=ZmRUKvr7SW907xdYfUdupy9qNgLef+8kktxQpqYO4XvNzuTo+EeB2+d+XQvWCg8beA44ooAypHpwcXIqidYMlpxAbZ/YeZSagKO7dkESt662gI4hkmI+F3jg3xNDjgsrc5D4MTLyzU6fQHOqr0JTj0ABdB8peK/AjuRE7i/xWIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301247; c=relaxed/simple;
	bh=M52S+j+nEFc9r0nYdygcoHQ4pruCBtcPAwLxJznnEyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/L+kHnyEjQFXbJN45Np/nefacQrg9iWxQ47/UV2MO6u/DNXS+IKLHUxcLtd9G0PgwGDadJArpHSAFPxYUDej/RPjWHHL1zgbR6bZYWLoRAovVIDoay28vzC+mseuYHnt2c5KP5zg7OFWD36aNu8ok7sj+P+nhrM+GpKM4/ZSwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E4gHcgLo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E4gHcgLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9AE1F00893;
	Wed, 20 May 2026 18:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301246;
	bh=Wj2rTFLtYtjYkiJ7rjE4gP3p28LTHvOA2bnC+UXqw3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E4gHcgLoZsRWWIhwIeI/6XwwPKjRNsYy1623D+IVibqboaXgx4t+rOTlt4lG4nwqu
	 9qMf6atjNAvTDc6SGlFpCQSebiNYh40VKeIKBZgwPpOK1dBffGM5Jy00fz2ATP6tAm
	 48Jc5ItDEofnYaZQSen2N5nIVSG6B65i8dEzEvN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongbo Li <lihongbo22@huawei.com>,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 430/666] erofs: do sanity check on m->type in z_erofs_load_compact_lcluster()
Date: Wed, 20 May 2026 18:20:41 +0200
Message-ID: <20260520162120.592463572@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 1a5223c182fdb3bb3c0ca85cec101c740f685ab6 ]

All below functions will do sanity check on m->type, let's move sanity
check to z_erofs_load_compact_lcluster() for cleanup.
- z_erofs_map_blocks_fo
- z_erofs_get_extent_compressedlen
- z_erofs_get_extent_decompressedlen
- z_erofs_extent_lookback

Reviewed-by: Hongbo Li <lihongbo22@huawei.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250708110928.3110375-1-chao@kernel.org
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Stable-dep-of: 2d8c7edcb661 ("erofs: unify lcn as u64 for 32-bit platforms")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zmap.c | 103 +++++++++++++++++++-----------------------------
 1 file changed, 41 insertions(+), 62 deletions(-)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index a03700cbd2c1c..fe193a7e83a85 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -240,6 +240,13 @@ static int z_erofs_load_compact_lcluster(struct z_erofs_maprecorder *m,
 static int z_erofs_load_lcluster_from_disk(struct z_erofs_maprecorder *m,
 					   unsigned int lcn, bool lookahead)
 {
+	if (m->type >= Z_EROFS_LCLUSTER_TYPE_MAX) {
+		erofs_err(m->inode->i_sb, "unknown type %u @ lcn %u of nid %llu",
+				m->type, lcn, EROFS_I(m->inode)->nid);
+		DBG_BUGON(1);
+		return -EOPNOTSUPP;
+	}
+
 	switch (EROFS_I(m->inode)->datalayout) {
 	case EROFS_INODE_COMPRESSED_FULL:
 		return z_erofs_load_full_lcluster(m, lcn);
@@ -265,12 +272,7 @@ static int z_erofs_extent_lookback(struct z_erofs_maprecorder *m,
 		if (err)
 			return err;
 
-		if (m->type >= Z_EROFS_LCLUSTER_TYPE_MAX) {
-			erofs_err(sb, "unknown type %u @ lcn %lu of nid %llu",
-				  m->type, lcn, vi->nid);
-			DBG_BUGON(1);
-			return -EOPNOTSUPP;
-		} else if (m->type == Z_EROFS_LCLUSTER_TYPE_NONHEAD) {
+		if (m->type == Z_EROFS_LCLUSTER_TYPE_NONHEAD) {
 			lookback_distance = m->delta[0];
 			if (!lookback_distance)
 				break;
@@ -325,25 +327,18 @@ static int z_erofs_get_extent_compressedlen(struct z_erofs_maprecorder *m,
 	DBG_BUGON(lcn == initial_lcn &&
 		  m->type == Z_EROFS_LCLUSTER_TYPE_NONHEAD);
 
-	if (m->type == Z_EROFS_LCLUSTER_TYPE_NONHEAD) {
-		if (m->delta[0] != 1) {
-			erofs_err(sb, "bogus CBLKCNT @ lcn %lu of nid %llu", lcn, vi->nid);
-			DBG_BUGON(1);
-			return -EFSCORRUPTED;
-		}
-		if (m->compressedblks)
-			goto out;
-	} else if (m->type < Z_EROFS_LCLUSTER_TYPE_MAX) {
-		/*
-		 * if the 1st NONHEAD lcluster is actually PLAIN or HEAD type
-		 * rather than CBLKCNT, it's a 1 block-sized pcluster.
-		 */
-		m->compressedblks = 1;
-		goto out;
+	if (m->type == Z_EROFS_LCLUSTER_TYPE_NONHEAD && m->delta[0] != 1) {
+		erofs_err(sb, "bogus CBLKCNT @ lcn %lu of nid %llu", lcn, vi->nid);
+		DBG_BUGON(1);
+		return -EFSCORRUPTED;
 	}
-	erofs_err(sb, "cannot found CBLKCNT @ lcn %lu of nid %llu", lcn, vi->nid);
-	DBG_BUGON(1);
-	return -EFSCORRUPTED;
+
+	/*
+	 * if the 1st NONHEAD lcluster is actually PLAIN or HEAD type rather
+	 * than CBLKCNT, it's a 1 block-sized pcluster.
+	 */
+	if (m->type != Z_EROFS_LCLUSTER_TYPE_NONHEAD || !m->compressedblks)
+		m->compressedblks = 1;
 out:
 	m->map->m_plen = erofs_pos(sb, m->compressedblks);
 	return 0;
@@ -379,11 +374,6 @@ static int z_erofs_get_extent_decompressedlen(struct z_erofs_maprecorder *m)
 			if (lcn != headlcn)
 				break;	/* ends at the next HEAD lcluster */
 			m->delta[1] = 1;
-		} else {
-			erofs_err(inode->i_sb, "unknown type %u @ lcn %llu of nid %llu",
-				  m->type, lcn, vi->nid);
-			DBG_BUGON(1);
-			return -EOPNOTSUPP;
 		}
 		lcn += m->delta[1];
 	}
@@ -421,44 +411,33 @@ static int z_erofs_do_map_blocks(struct inode *inode,
 	map->m_flags = EROFS_MAP_MAPPED | EROFS_MAP_ENCODED;
 	end = (m.lcn + 1ULL) << lclusterbits;
 
-	switch (m.type) {
-	case Z_EROFS_LCLUSTER_TYPE_PLAIN:
-	case Z_EROFS_LCLUSTER_TYPE_HEAD1:
-	case Z_EROFS_LCLUSTER_TYPE_HEAD2:
-		if (endoff >= m.clusterofs) {
-			m.headtype = m.type;
-			map->m_la = (m.lcn << lclusterbits) | m.clusterofs;
-			/*
-			 * For ztailpacking files, in order to inline data more
-			 * effectively, special EOF lclusters are now supported
-			 * which can have three parts at most.
-			 */
-			if (ztailpacking && end > inode->i_size)
-				end = inode->i_size;
-			break;
-		}
-		/* m.lcn should be >= 1 if endoff < m.clusterofs */
-		if (!m.lcn) {
-			erofs_err(sb, "invalid logical cluster 0 at nid %llu",
-				  vi->nid);
-			err = -EFSCORRUPTED;
-			goto unmap_out;
+	if (m.type != Z_EROFS_LCLUSTER_TYPE_NONHEAD && endoff >= m.clusterofs) {
+		m.headtype = m.type;
+		map->m_la = (m.lcn << lclusterbits) | m.clusterofs;
+		/*
+		 * For ztailpacking files, in order to inline data more
+		 * effectively, special EOF lclusters are now supported
+		 * which can have three parts at most.
+		 */
+		if (ztailpacking && end > inode->i_size)
+			end = inode->i_size;
+	} else {
+		if (m.type != Z_EROFS_LCLUSTER_TYPE_NONHEAD) {
+			/* m.lcn should be >= 1 if endoff < m.clusterofs */
+			if (!m.lcn) {
+				erofs_err(sb, "invalid logical cluster 0 at nid %llu",
+					  vi->nid);
+				err = -EFSCORRUPTED;
+				goto unmap_out;
+			}
+			end = (m.lcn << lclusterbits) | m.clusterofs;
+			map->m_flags |= EROFS_MAP_FULL_MAPPED;
+			m.delta[0] = 1;
 		}
-		end = (m.lcn << lclusterbits) | m.clusterofs;
-		map->m_flags |= EROFS_MAP_FULL_MAPPED;
-		m.delta[0] = 1;
-		fallthrough;
-	case Z_EROFS_LCLUSTER_TYPE_NONHEAD:
 		/* get the corresponding first chunk */
 		err = z_erofs_extent_lookback(&m, m.delta[0]);
 		if (err)
 			goto unmap_out;
-		break;
-	default:
-		erofs_err(sb, "unknown type %u @ offset %llu of nid %llu",
-			  m.type, ofs, vi->nid);
-		err = -EOPNOTSUPP;
-		goto unmap_out;
 	}
 	if (m.partialref)
 		map->m_flags |= EROFS_MAP_PARTIAL_REF;
-- 
2.53.0



