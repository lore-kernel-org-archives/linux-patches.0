Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB96B29B78D;
	Wed, 20 May 2026 18:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301131; cv=none; b=fUMjqYYvPPKczASc952X06UHUqv3x1d4/QrCfuWc79E7kLlzwBMrGMnzfT5Y/PdlpiPqE4elYfn371CNTnFQ8wy6omkRN7ONFvezUjednx/twCYFPkV6mmlQ19c8/PwOYq/5A0fhpf5uIYx2TIDbMaU/898L8IMchoUD3lgu2yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301131; c=relaxed/simple;
	bh=lfsTD+mH7sn7OVdCT3ALtDZ1UoMVRvdaK0GqrUWUOO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AcKWZljNlB/CdvsDp6pCK3AWC7f7bFBLcnJrEmfOwO8Uo4y1mvoUlBnYg8wxIvTQ96vAmZTDEpx97HqUCP4DqYkIlMWsBet6pdi0ZglE5ZV6P5r9EgEwn00HY1XA0Ad8Txn2eIeWP3RYb9ixJfHpzKk5GModh77WwIYAsQqnR8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XxLuaedQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XxLuaedQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5CA1F000E9;
	Wed, 20 May 2026 18:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301130;
	bh=2RJL0RzxN0on4KtYHlpGJnLWNPtQwPq+AxPyDwg5EGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XxLuaedQnseUqPEEwi6MbFwAOwhXwmD2Vly1JckFH+D/Ux0FsdtgBvQ88hclwAS4s
	 12JvVbXlPmdQufPYeGWMZ5l7duF9UA7zl6xgFdq9oMTTiGNbDHtHrzk2nF9qgp8R3o
	 15URMR1Idwl/92g+fE2OSnpA2GSmUDJJj4QN0DFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@csail.mit.edu>,
	Hongbo Li <lihongbo22@huawei.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 431/666] erofs: avoid infinite loops due to corrupted subpage compact indexes
Date: Wed, 20 May 2026 18:20:42 +0200
Message-ID: <20260520162120.614242402@linuxfoundation.org>
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

Fixes: 8d2517aaeea3 ("erofs: fix up compacted indexes for block size < 4096")
Fixes: 1a5223c182fd ("erofs: do sanity check on m->type in z_erofs_load_compact_lcluster()")
Reported-by: Robert Morris <rtm@csail.mit.edu>
Closes: https://lore.kernel.org/r/35167.1760645886@localhost
Reviewed-by: Hongbo Li <lihongbo22@huawei.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Stable-dep-of: 2d8c7edcb661 ("erofs: unify lcn as u64 for 32-bit platforms")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zmap.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index fe193a7e83a85..d0371ca374ce2 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -55,10 +55,6 @@ static int z_erofs_load_full_lcluster(struct z_erofs_maprecorder *m,
 	} else {
 		m->partialref = !!(advise & Z_EROFS_LI_PARTIAL_REF);
 		m->clusterofs = le16_to_cpu(di->di_clusterofs);
-		if (m->clusterofs >= 1 << vi->z_lclusterbits) {
-			DBG_BUGON(1);
-			return -EFSCORRUPTED;
-		}
 		m->pblk = le32_to_cpu(di->di_u.blkaddr);
 	}
 	return 0;
@@ -240,21 +236,29 @@ static int z_erofs_load_compact_lcluster(struct z_erofs_maprecorder *m,
 static int z_erofs_load_lcluster_from_disk(struct z_erofs_maprecorder *m,
 					   unsigned int lcn, bool lookahead)
 {
+	struct erofs_inode *vi = EROFS_I(m->inode);
+	int err;
+
+	if (vi->datalayout == EROFS_INODE_COMPRESSED_COMPACT) {
+		err = z_erofs_load_compact_lcluster(m, lcn, lookahead);
+	} else {
+		DBG_BUGON(vi->datalayout != EROFS_INODE_COMPRESSED_FULL);
+		err = z_erofs_load_full_lcluster(m, lcn);
+	}
+	if (err)
+		return err;
+
 	if (m->type >= Z_EROFS_LCLUSTER_TYPE_MAX) {
 		erofs_err(m->inode->i_sb, "unknown type %u @ lcn %u of nid %llu",
-				m->type, lcn, EROFS_I(m->inode)->nid);
+			  m->type, lcn, EROFS_I(m->inode)->nid);
 		DBG_BUGON(1);
 		return -EOPNOTSUPP;
+	} else if (m->type != Z_EROFS_LCLUSTER_TYPE_NONHEAD &&
+		   m->clusterofs >= (1 << vi->z_lclusterbits)) {
+		DBG_BUGON(1);
+		return -EFSCORRUPTED;
 	}
-
-	switch (EROFS_I(m->inode)->datalayout) {
-	case EROFS_INODE_COMPRESSED_FULL:
-		return z_erofs_load_full_lcluster(m, lcn);
-	case EROFS_INODE_COMPRESSED_COMPACT:
-		return z_erofs_load_compact_lcluster(m, lcn, lookahead);
-	default:
-		return -EINVAL;
-	}
+	return 0;
 }
 
 static int z_erofs_extent_lookback(struct z_erofs_maprecorder *m,
-- 
2.53.0



