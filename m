Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A57357CFA;
	Sat, 12 Sep 2026 11:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211469; cv=none; b=CZBtwrQKHFTEh9D5+V2zP4xgwXJjdeWGl4Ae989XMJ0xm0OuUmZ6OCtz1au6/tihIkKZ3ADoJ9fFZMnL6mXs4zhUJo2fxUlLPlsezNe3zvnTSfx07GUF4R02YdPkEMUk1NVK8MUMjVvsOU2U7y/XYasBHL1SdiKtaMuU1nVeUk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211469; c=relaxed/simple;
	bh=hqaDfwh4mDSS6Vh4gmWfAT+f/7sadulVlSNEH56hNW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B6+aVnIRQxEE7ExNwzqF99YIIv7GPeW1g3s27UGVnw+z0NVzQkVWuj6ILM1EEY06VqNF0Bd2Gi/Pe0vbG8axeDM+vfAsJEtNaiKULqAUt4F5/L6RhFxOnf1I5WrQPgQwyBfScMzcGQEvD7fQ0PDNPX+6wGLlZyGG3HS83nmmnqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aAnZrEHE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aAnZrEHE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0197E1F000FF;
	Sat, 12 Sep 2026 11:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211468;
	bh=EXK6EU9A5SERA5ZdtLnzRu8IXySXW2Y+cqFR5YQwPg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aAnZrEHEAgmEIUZBa9gAzFaesTB25F/KM7FxEF+p7N2RW/vMFVc2V5ILPshYqNh0C
	 0xOZ3V1k1jehFpvoEPbytascTr1s4/RxC6HL7Bwp/UZ47224vuKcbhUtt2Ir8S3oDs
	 v6IkyS+7sk+a4ngUuVKWOy6Z6MtIQJoc5QVVe/s8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1235/1518] erofs: error out obviously illegal extents in advance
Date: Sat, 12 Sep 2026 08:56:44 +0200
Message-ID: <20260912065651.443802597@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

[ Upstream commit a5242d37c83abe86df95c6941e2ace9f9055ffcb ]

Detect some corrupted extent cases during metadata parsing rather
than letting them result in harmless decompression failures later:

 - For full-reference compressed extents, the compressed size must
   not exceed the decompressed size, which is a strict on-disk
   layout constraint;

 - For plain (shifted/interlaced) extents, the decoded size must
   not exceed the encoded size, even accounting for partial decoding.

Both ways work but it should be better to report illegal extents as
metadata layout violations rather than deferring as decompression
failure.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Stable-dep-of: 862427ebb81d ("erofs: fix interlaced ztailpacking pclusters")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/decompressor.c |  1 -
 fs/erofs/zmap.c         | 24 +++++++++++++++---------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index e4e59a4e0d90d..2f4cef67cf640 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -142,7 +142,6 @@ static void *z_erofs_lz4_handle_overlap(const struct z_erofs_decompress_req *rq,
 	oend = rq->pageofs_out + rq->outputsize;
 	omargin = PAGE_ALIGN(oend) - oend;
 	if (!rq->partial_decoding && may_inplace &&
-	    rq->outpages >= rq->inpages &&
 	    omargin >= LZ4_DECOMPRESS_INPLACE_MARGIN(rq->inputsize)) {
 		for (i = 0; i < rq->inpages; ++i)
 			if (rq->out[rq->outpages - rq->inpages + i] !=
diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index 103c56b408f4e..a72db36096ca1 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -472,11 +472,6 @@ static int z_erofs_map_blocks_fo(struct inode *inode,
 	}
 
 	if (m.headtype == Z_EROFS_LCLUSTER_TYPE_PLAIN) {
-		if (map->m_llen > map->m_plen) {
-			DBG_BUGON(1);
-			err = -EFSCORRUPTED;
-			goto unmap_out;
-		}
 		if (vi->z_advise & Z_EROFS_ADVISE_INTERLACED_PCLUSTER)
 			map->m_algorithmformat = Z_EROFS_COMPRESSION_INTERLACED;
 		else
@@ -719,10 +714,21 @@ static int z_erofs_map_sanity_check(struct inode *inode,
 			  map->m_algorithmformat, map->m_la, EROFS_I(inode)->nid);
 		return -EOPNOTSUPP;
 	}
-	if (unlikely(map->m_algorithmformat < Z_EROFS_COMPRESSION_MAX &&
-		     !(sbi->available_compr_algs & (1 << map->m_algorithmformat)))) {
-		erofs_err(inode->i_sb, "inconsistent algorithmtype %u for nid %llu",
-			  map->m_algorithmformat, EROFS_I(inode)->nid);
+
+	if (map->m_algorithmformat < Z_EROFS_COMPRESSION_MAX) {
+		if (sbi->available_compr_algs ^ BIT(map->m_algorithmformat)) {
+			erofs_err(inode->i_sb, "inconsistent algorithmtype %u for nid %llu",
+				  map->m_algorithmformat, EROFS_I(inode)->nid);
+			return -EFSCORRUPTED;
+		}
+		if (EROFS_MAP_FULL(map->m_flags) && map->m_llen < map->m_plen) {
+			erofs_err(inode->i_sb, "too much compressed data @ la %llu of nid %llu",
+				  map->m_la, EROFS_I(inode)->nid);
+			return -EFSCORRUPTED;
+		}
+	} else if (map->m_llen > map->m_plen) {
+		erofs_err(inode->i_sb, "not enough plain data on disk @ la %llu of nid %llu",
+			  map->m_la, EROFS_I(inode)->nid);
 		return -EFSCORRUPTED;
 	}
 	if (unlikely(map->m_plen > Z_EROFS_PCLUSTER_MAX_SIZE ||
-- 
2.53.0



