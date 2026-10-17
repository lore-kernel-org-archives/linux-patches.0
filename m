Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A313AFCF0;
	Sat, 17 Oct 2026 17:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257002; cv=none; b=GLYSUpn5Vs51V1d7d9uwY5aNvVRSNiZgVhqj/sA3awsBDfg3K47X/9c697gfanSMNs/ycJwc29z5tCCvorLPm+pCwRnVNll0ehI0HcjP+YncB32IZh6XuQFb5ubY+XqHzAsveosAGgsh/Qkg0cdFyknfffJ5XM5zPLSFU4SmvKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257002; c=relaxed/simple;
	bh=j9LRneYwKhNA6Z+3+/PbbDZGVSaaHEm4IvGwoKzvxTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipn3csGnZ0tYGX1gC6VX751FjnTxbziI7gf77SEB1v33sEJ0kqO38RS2qFLHzJ8+UV2Biz0S2ADqnx5wTqVNerYThRrwdYyABAXmEAWpmL5MGD2PTOhW+64iGLqWw+gUFPVwHh988MSv2rNO2ViufR2pAQQ0nMbCYIs8ZfFofjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KjYO4ivH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KjYO4ivH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE031F000C4;
	Sat, 17 Oct 2026 17:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257001;
	bh=axRfh+Wt9N4j7eMlSIKLByAapzyPKzcRIXS2WgwvYU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KjYO4ivHAJ3jddYuMUcliWyWBHT6IXDCqvWeYBl6v2vtV8wCRSt62pXHQkHdI/bGX
	 G+RWoxI3QJvsqWMwnMSmsoSCxNGMAhZNP6ntdHKiIRx+wMF1PeXrtzYMa6bjNinFBO
	 W0s8K0x7YU4XgYJDrKTYxURlVLKehI4YcWRu8iNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@csail.mit.edu>,
	Hongbo Li <lihongbo22@huawei.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0419/1674] erofs: avoid infinite loops due to corrupted subpage compact indexes
Date: Sat, 17 Oct 2026 17:44:51 +0200
Message-ID: <20261017160441.886529364@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit e13d315ae077bb7c3c6027cc292401bc0f4ec683 ]

Robert reported an infinite loop observed by two crafted images.

The root cause is that `clusterofs` can be larger than `lclustersize`
for !NONHEAD `lclusters` in corrupted subpage compact indexes, e.g.:

  blocksize = lclustersize = 512   lcn = 6   clusterofs = 515

Move the corresponding check for full compress indexes to
`z_erofs_load_lcluster_from_disk()` to also cover subpage compact
compress indexes.

It also fixes the position of `m->type >= Z_EROFS_LCLUSTER_TYPE_MAX`
check, since it should be placed right after
`z_erofs_load_{compact,full}_lcluster()`.

[ Backport to 6.6.y: preserve the switch-based full/compact loader and
  perform the type and cluster-offset validation after either loader
  using z_logical_clusterbits. ]

Fixes: 8d2517aaeea3 ("erofs: fix up compacted indexes for block size < 4096")
Fixes: 1a5223c182fd ("erofs: do sanity check on m->type in z_erofs_load_compact_lcluster()")
Reported-by: Robert Morris <rtm@csail.mit.edu>
Closes: https://lore.kernel.org/r/35167.1760645886@localhost
Reviewed-by: Hongbo Li <lihongbo22@huawei.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zmap.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index 76566c2cbf63e..e53d5239f04d6 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -67,10 +67,6 @@ static int z_erofs_load_full_lcluster(struct z_erofs_maprecorder *m,
 		if (advise & Z_EROFS_LI_PARTIAL_REF)
 			m->partialref = true;
 		m->clusterofs = le16_to_cpu(di->di_clusterofs);
-		if (m->clusterofs >= 1 << vi->z_logical_clusterbits) {
-			DBG_BUGON(1);
-			return -EFSCORRUPTED;
-		}
 		m->pblk = le32_to_cpu(di->di_u.blkaddr);
 		break;
 	default:
@@ -276,14 +272,34 @@ static int z_erofs_load_compact_lcluster(struct z_erofs_maprecorder *m,
 static int z_erofs_load_lcluster_from_disk(struct z_erofs_maprecorder *m,
 					   unsigned int lcn, bool lookahead)
 {
-	switch (EROFS_I(m->inode)->datalayout) {
+	struct erofs_inode *vi = EROFS_I(m->inode);
+	int err;
+
+	switch (vi->datalayout) {
 	case EROFS_INODE_COMPRESSED_FULL:
-		return z_erofs_load_full_lcluster(m, lcn);
+		err = z_erofs_load_full_lcluster(m, lcn);
+		break;
 	case EROFS_INODE_COMPRESSED_COMPACT:
-		return z_erofs_load_compact_lcluster(m, lcn, lookahead);
+		err = z_erofs_load_compact_lcluster(m, lcn, lookahead);
+		break;
 	default:
 		return -EINVAL;
 	}
+	if (err)
+		return err;
+
+	if (m->type >= Z_EROFS_LCLUSTER_TYPE_MAX) {
+		erofs_err(m->inode->i_sb, "unknown type %u @ lcn %u of nid %llu",
+			  m->type, lcn, vi->nid);
+		DBG_BUGON(1);
+		return -EOPNOTSUPP;
+	}
+	if (m->type != Z_EROFS_LCLUSTER_TYPE_NONHEAD &&
+	    m->clusterofs >= (1 << vi->z_logical_clusterbits)) {
+		DBG_BUGON(1);
+		return -EFSCORRUPTED;
+	}
+	return 0;
 }
 
 static int z_erofs_extent_lookback(struct z_erofs_maprecorder *m,
-- 
2.53.0



