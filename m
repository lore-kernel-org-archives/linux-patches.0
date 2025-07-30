Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F217442C;
	Wed, 30 Jul 2025 09:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868804; cv=none; b=kENH3saTy9wb8UIzVfVgyqmzyYzVRYAPj4nWJizlZWJ+a+H/pTOTDKLEf5jYkZC8vpb07+W4nJ7qGCgk2sxi6NcazaqC4OHYHDAatUvFwuQ9DeylRsg54KRyMq6N8y4YezBVEDIXx0bpgzzJj8wnWVfwUHlT9P5P1a/LunCZ9CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868804; c=relaxed/simple;
	bh=ZySLQLRQ4+0DNQ8z+8ZyhtuloqEIFXenrwyoPIO2paA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ta4H+dmJPg39c/asw7VR0Odc1c4Dp6A8fvcEUxOxTWOXwWH6rDS3OJdZc5pB0Fyy9Fa0McevbmqxflruiFQm6sOeMVX2cmivYpAfaUqnpFHV3/BfeIr697pY2stSjQ/3/JCE1TjjJBPCZ8FOYClLw+rL2hfyjQzPqRx6SRKnyzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VxE+nM+h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VxE+nM+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10257C4CEF5;
	Wed, 30 Jul 2025 09:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868803;
	bh=ZySLQLRQ4+0DNQ8z+8ZyhtuloqEIFXenrwyoPIO2paA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VxE+nM+hZPxFLkLxJYqo0rxv3DCWvH3n1OZ2tTQlAMX3faxRYLpIwRaQBWEgs3n/m
	 tt+245pygdeC/tsmiI9x/jLziW1iB5W725WTl/BqaxHJWEzWfMPrDTftTXCaIyuJ1J
	 gsrLLo5dRqIYHkQJiPvkRIelkdBncYevPjfHnORQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/117] erofs: refine z_erofs_get_extent_compressedlen()
Date: Wed, 30 Jul 2025 11:35:49 +0200
Message-ID: <20250730093236.869836209@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 8f9530aeeb4f756bdfa70510b40e5d28ea3c742e ]

 - Set `compressedblks = 1` directly for non-bigpcluster cases.  This
   simplifies the logic a bit since lcluster sizes larger than one block
   are unsupported and the details remain unclear.

 - For Z_EROFS_LCLUSTER_TYPE_PLAIN pclusters, avoid assuming
   `compressedblks = 1` by default.  Instead, check if
   Z_EROFS_ADVISE_BIG_PCLUSTER_2 is set.

It basically has no impact to existing valid images, but it's useful to
find the gap to prepare for large PLAIN pclusters.

Link: https://lore.kernel.org/r/20250123090109.973463-1-hsiangkao@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Stable-dep-of: b44686c8391b ("erofs: fix large fragment handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/zmap.c |   36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -294,27 +294,23 @@ err_bogus:
 static int z_erofs_get_extent_compressedlen(struct z_erofs_maprecorder *m,
 					    unsigned int initial_lcn)
 {
-	struct super_block *sb = m->inode->i_sb;
-	struct erofs_inode *const vi = EROFS_I(m->inode);
-	struct erofs_map_blocks *const map = m->map;
-	const unsigned int lclusterbits = vi->z_logical_clusterbits;
-	unsigned long lcn;
+	struct inode *inode = m->inode;
+	struct super_block *sb = inode->i_sb;
+	struct erofs_inode *vi = EROFS_I(inode);
+	bool bigpcl1 = vi->z_advise & Z_EROFS_ADVISE_BIG_PCLUSTER_1;
+	bool bigpcl2 = vi->z_advise & Z_EROFS_ADVISE_BIG_PCLUSTER_2;
+	unsigned long lcn = m->lcn + 1;
 	int err;
 
-	DBG_BUGON(m->type != Z_EROFS_LCLUSTER_TYPE_PLAIN &&
-		  m->type != Z_EROFS_LCLUSTER_TYPE_HEAD1 &&
-		  m->type != Z_EROFS_LCLUSTER_TYPE_HEAD2);
+	DBG_BUGON(m->type == Z_EROFS_LCLUSTER_TYPE_NONHEAD);
 	DBG_BUGON(m->type != m->headtype);
 
-	if (m->headtype == Z_EROFS_LCLUSTER_TYPE_PLAIN ||
-	    ((m->headtype == Z_EROFS_LCLUSTER_TYPE_HEAD1) &&
-	     !(vi->z_advise & Z_EROFS_ADVISE_BIG_PCLUSTER_1)) ||
-	    ((m->headtype == Z_EROFS_LCLUSTER_TYPE_HEAD2) &&
-	     !(vi->z_advise & Z_EROFS_ADVISE_BIG_PCLUSTER_2))) {
-		map->m_plen = 1ULL << lclusterbits;
-		return 0;
-	}
-	lcn = m->lcn + 1;
+	if ((m->headtype == Z_EROFS_LCLUSTER_TYPE_HEAD1 && !bigpcl1) ||
+	    ((m->headtype == Z_EROFS_LCLUSTER_TYPE_PLAIN ||
+	      m->headtype == Z_EROFS_LCLUSTER_TYPE_HEAD2) && !bigpcl2) ||
+	    (lcn << vi->z_logical_clusterbits) >= inode->i_size)
+		m->compressedblks = 1;
+
 	if (m->compressedblks)
 		goto out;
 
@@ -339,9 +335,9 @@ static int z_erofs_get_extent_compressed
 	case Z_EROFS_LCLUSTER_TYPE_HEAD2:
 		/*
 		 * if the 1st NONHEAD lcluster is actually PLAIN or HEAD type
-		 * rather than CBLKCNT, it's a 1 lcluster-sized pcluster.
+		 * rather than CBLKCNT, it's a 1 block-sized pcluster.
 		 */
-		m->compressedblks = 1 << (lclusterbits - sb->s_blocksize_bits);
+		m->compressedblks = 1;
 		break;
 	case Z_EROFS_LCLUSTER_TYPE_NONHEAD:
 		if (m->delta[0] != 1)
@@ -356,7 +352,7 @@ static int z_erofs_get_extent_compressed
 		return -EFSCORRUPTED;
 	}
 out:
-	map->m_plen = erofs_pos(sb, m->compressedblks);
+	m->map->m_plen = erofs_pos(sb, m->compressedblks);
 	return 0;
 err_bonus_cblkcnt:
 	erofs_err(sb, "bogus CBLKCNT @ lcn %lu of nid %llu", lcn, vi->nid);


