Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E253D7D66;
	Wed, 20 May 2026 17:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298926; cv=none; b=SPEq+fFmyPZwAhmDjw0j+/eAdVFkAOtSU0XbMQTv1RIh4IQ3xzC7wtJFvdzvQrPnmPB1c3snWLMRupRdSfuAkFmTVqyPmkmnc05kMFMbBfBoafBMRRgQ9mRJTVfURgdRSn7YkGNcVhrFTzTSV+i/nvG8SU4bZ9qZZVKtLxVhIxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298926; c=relaxed/simple;
	bh=9Z176OZ9Gf2Tb9ePHZPyimWrw76HHsKPNnP5p/jmhdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUw4RxlKZAAbDM6vjTZAKKcUSPLQDoOnPsAdDPK7jhYjyR4xuzZVbo7MhG8znpBMDspmMlDa6cXmO1SrDrI7d8XZgavx+tZrfuxcIEFePuFW7FSrtf+79EsVsMjQr7Bm3aMJYKxuCx216X7plt7sO9uckqjal58+YamNU2v8ZUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ov248NJn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ov248NJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AAF71F000E9;
	Wed, 20 May 2026 17:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298925;
	bh=aY3fAlApDbqjY96sH53ZQy/FbWrAWXJ6V59LH4YJYjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ov248NJnb70Gb4F4NnluPdK/mPJrlEEU8hvy4joHaArGNLvqxHOe4gvUOzwQ4OrJL
	 1h4sGGKXvPJioFe1+2oOKGxWLTvr0/zJeB5v5ebYImXwVdx20dz/g7jUmIHaedHczX
	 io7i8fX7pkMRT5q3k/N4mdjyR3CjMbOa0cNFrjJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 596/957] erofs: unify lcn as u64 for 32-bit platforms
Date: Wed, 20 May 2026 18:17:59 +0200
Message-ID: <20260520162147.457267827@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 2d8c7edcb661812249469f4a5b62e9339118846f ]

As sashiko reported [1], `lcn` was typed as `unsigned long` (or
`unsigned int` sometimes), which is only 32 bits wide on 32-bit
platforms, which causes `(lcn << lclusterbits)` to be truncated
at 4 GiB.

In order to consolidate the logic, just use `u64` consistently
around the codebase.

[1] https://sashiko.dev/r/20260420034612.1899973-1-hsiangkao%40linux.alibaba.com

Fixes: 152a333a5895 ("staging: erofs: add compacted compression indexes support")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zmap.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index 30775502b56da..abf7ddc64c63b 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -10,7 +10,7 @@
 struct z_erofs_maprecorder {
 	struct inode *inode;
 	struct erofs_map_blocks *map;
-	unsigned long lcn;
+	u64 lcn;
 	/* compression extent information gathered */
 	u8  type, headtype;
 	u16 clusterofs;
@@ -20,8 +20,7 @@ struct z_erofs_maprecorder {
 	bool partialref, in_mbox;
 };
 
-static int z_erofs_load_full_lcluster(struct z_erofs_maprecorder *m,
-				      unsigned long lcn)
+static int z_erofs_load_full_lcluster(struct z_erofs_maprecorder *m, u64 lcn)
 {
 	struct inode *const inode = m->inode;
 	struct erofs_inode *const vi = EROFS_I(inode);
@@ -94,7 +93,7 @@ static int get_compacted_la_distance(unsigned int lobits,
 }
 
 static int z_erofs_load_compact_lcluster(struct z_erofs_maprecorder *m,
-					 unsigned long lcn, bool lookahead)
+					 u64 lcn, bool lookahead)
 {
 	struct inode *const inode = m->inode;
 	struct erofs_inode *const vi = EROFS_I(inode);
@@ -234,7 +233,7 @@ static int z_erofs_load_compact_lcluster(struct z_erofs_maprecorder *m,
 }
 
 static int z_erofs_load_lcluster_from_disk(struct z_erofs_maprecorder *m,
-					   unsigned int lcn, bool lookahead)
+					   u64 lcn, bool lookahead)
 {
 	struct erofs_inode *vi = EROFS_I(m->inode);
 	int err;
@@ -249,7 +248,7 @@ static int z_erofs_load_lcluster_from_disk(struct z_erofs_maprecorder *m,
 		return err;
 
 	if (m->type >= Z_EROFS_LCLUSTER_TYPE_MAX) {
-		erofs_err(m->inode->i_sb, "unknown type %u @ lcn %u of nid %llu",
+		erofs_err(m->inode->i_sb, "unknown type %u @ lcn %llu of nid %llu",
 			  m->type, lcn, EROFS_I(m->inode)->nid);
 		DBG_BUGON(1);
 		return -EOPNOTSUPP;
@@ -269,7 +268,7 @@ static int z_erofs_extent_lookback(struct z_erofs_maprecorder *m,
 	const unsigned int lclusterbits = vi->z_lclusterbits;
 
 	while (m->lcn >= lookback_distance) {
-		unsigned long lcn = m->lcn - lookback_distance;
+		u64 lcn = m->lcn - lookback_distance;
 		int err;
 
 		if (!lookback_distance)
@@ -286,7 +285,7 @@ static int z_erofs_extent_lookback(struct z_erofs_maprecorder *m,
 		m->map->m_la = (lcn << lclusterbits) | m->clusterofs;
 		return 0;
 	}
-	erofs_err(sb, "bogus lookback distance %u @ lcn %lu of nid %llu",
+	erofs_err(sb, "bogus lookback distance %u @ lcn %llu of nid %llu",
 		  lookback_distance, m->lcn, vi->nid);
 	DBG_BUGON(1);
 	return -EFSCORRUPTED;
@@ -300,7 +299,7 @@ static int z_erofs_get_extent_compressedlen(struct z_erofs_maprecorder *m,
 	struct erofs_inode *vi = EROFS_I(inode);
 	bool bigpcl1 = vi->z_advise & Z_EROFS_ADVISE_BIG_PCLUSTER_1;
 	bool bigpcl2 = vi->z_advise & Z_EROFS_ADVISE_BIG_PCLUSTER_2;
-	unsigned long lcn = m->lcn + 1;
+	u64 lcn = m->lcn + 1;
 	int err;
 
 	DBG_BUGON(m->type == Z_EROFS_LCLUSTER_TYPE_NONHEAD);
@@ -331,7 +330,7 @@ static int z_erofs_get_extent_compressedlen(struct z_erofs_maprecorder *m,
 		  m->type == Z_EROFS_LCLUSTER_TYPE_NONHEAD);
 
 	if (m->type == Z_EROFS_LCLUSTER_TYPE_NONHEAD && m->delta[0] != 1) {
-		erofs_err(sb, "bogus CBLKCNT @ lcn %lu of nid %llu", lcn, vi->nid);
+		erofs_err(sb, "bogus CBLKCNT @ lcn %llu of nid %llu", lcn, vi->nid);
 		DBG_BUGON(1);
 		return -EFSCORRUPTED;
 	}
-- 
2.53.0



