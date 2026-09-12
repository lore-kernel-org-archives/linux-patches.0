Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4C2429000;
	Sat, 12 Sep 2026 11:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211474; cv=none; b=pVFnKpN0IE1GvyEWHM7y7o7RZi37j91rfRGieIf8ae8C+X6yoWXjxTfOUR3RLx09TauuPT+OVw7zBxLCttpOPBRMYsVd/HGVwP1mJkwXO0Vwkl8KTiH7tVtjCqvNxo5DrNv91/GseGbLrq8a5Xm+228S7KtcYjM1D0LWbxPghU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211474; c=relaxed/simple;
	bh=iwXnHwhfFa5f8ecKDe0VJaDIwL9JpI7J7zRBYZbPZGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FRlzQqO3cGkSitOUG/oVraXGemqviKo+HgNoOK2kM9WoznpuiPvr1jWDat6zc549dk5blPEU6dww9lFuJy+q3lgb5BqMp461UgMNdYQdfyB1Xc0KppbDeBZ0iQ4sjwbJ8TLe/GqFyCAKIzt9fSBLMu8BtHbDjej/FuHIIstLtMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u4H5fEZd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u4H5fEZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065471F000FF;
	Sat, 12 Sep 2026 11:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211473;
	bh=6s4Gdc2RxlrBoU33wtK1h7j6WTKSUz7xroudYtwXAvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u4H5fEZd2L+GZF5T2j66R+O44HxhjTE231YRhTsw3z8BK1ySNLKJfSk+6eok0lZET
	 6xEB1m8dS7rUvLDoHozyFApobWS8zGTXxb6wtZqHeCRQMzbUQPNz+cqN3kSsfpXvtt
	 4/CfqRiaIjMUhDr1oFg0Zh5P4mbF8co88vUEortY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Huang <huanghaiyang83@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <xiang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1236/1518] erofs: fix interlaced ztailpacking pclusters
Date: Sat, 12 Sep 2026 08:56:45 +0200
Message-ID: <20260912065651.466202018@linuxfoundation.org>
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

From: Gao Xiang <xiang@kernel.org>

[ Upstream commit 862427ebb81d1f6abbf74d799790e1694b37b187 ]

On-disk sizes of interlaced pclusters should be block-aligned, and
ztailpacking interlaced pclusters should be invalid at all.

Currently, mkfs.erofs won't generate any interlaced pcluster with
ztailpacking enabled, so this doesn't affect any existing valid
filesystems.

However, crafted images can contain invalid interlaced ztailpacking
pclusters, resulting in an out-of-bounds read from a kmap'd page and
copying irrelevant kernel memory into userspace-visible page cache.

Reported-by: Haiyang Huang <huanghaiyang83@gmail.com>
Closes: https://lore.kernel.org/r/20260806065253.1083865-1-huanghaiyang83@gmail.com
Fixes: fdffc091e6f9 ("erofs: support interlaced uncompressed data for compressed files")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/decompressor.c | 1 +
 fs/erofs/zmap.c         | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index 2f4cef67cf640..fbd59109f46c3 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -304,6 +304,7 @@ static int z_erofs_transform_plain(struct z_erofs_decompress_req *rq,
 		return -EOPNOTSUPP;
 	if (rq->alg == Z_EROFS_COMPRESSION_INTERLACED) {
 		cur = bs - (rq->pageofs_out & (bs - 1));
+		DBG_BUGON(rq->pageofs_in & (bs - 1));
 		pi = (rq->pageofs_in + rq->inputsize - cur) & ~PAGE_MASK;
 		cur = min(cur, rq->outputsize);
 		if (cur && rq->out[0]) {
diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index a72db36096ca1..5530fe1cf282c 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -472,7 +472,8 @@ static int z_erofs_map_blocks_fo(struct inode *inode,
 	}
 
 	if (m.headtype == Z_EROFS_LCLUSTER_TYPE_PLAIN) {
-		if (vi->z_advise & Z_EROFS_ADVISE_INTERLACED_PCLUSTER)
+		if ((vi->z_advise & Z_EROFS_ADVISE_INTERLACED_PCLUSTER) &&
+		    !(map->m_flags & EROFS_MAP_META))
 			map->m_algorithmformat = Z_EROFS_COMPRESSION_INTERLACED;
 		else
 			map->m_algorithmformat = Z_EROFS_COMPRESSION_SHIFTED;
-- 
2.53.0



