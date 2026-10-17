Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3A7377A92;
	Sat, 17 Oct 2026 16:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254966; cv=none; b=Jp/Hi2lluDHcyJURwGre3UCU532i6/ZVbc1AVgWCP8f9sbWmrT93j88H9GymdqlsVifsD4ISEq9Ti/y0GzdDbz1+wNF9dCO+BFW5GZvlmvOzrhGx5shwRqelCyurAzQwDB/KhFOA5xaguGH76CHVpqukhhnu4XrMKqEE7TspEHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254966; c=relaxed/simple;
	bh=Ou2GDFBMrBNzWyAOlyff6pYm1hRDdPzkS4wyRayQog4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7OOg1k7N+fkT4Q8wjvjQZruLNKh5VeNebybAt9QYfxZmM7mFOGtHfUIU8ogBu65hSFfLyWCqzshhI7cgZ56rksg+LyNdD9nwWND4aSnMusYevF3J44fH0JBsvdODTPmxHRGKepOWH8oAPQ4ydehFXdxoWQfZiLxHJX6AYgKdaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ekyRvsYm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ekyRvsYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824561F000C4;
	Sat, 17 Oct 2026 16:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254965;
	bh=UhPhjL4ux8vW3rxySnXxDht16+3a85UZT80j0ih91Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ekyRvsYmrLKnTdWt0dqVwtxYtD3+ZaSFaFOBqep4DiNq17hOtm8zQwNTYgvxPIJ5K
	 0NBgbmc78DZsJKM0oHHascUbP1x5A/KQG27TN8J61whuogXxWLABoZ4hWYcX8YWpzo
	 YKi72s98elILDgweceF+rxQ1XO3uA3oA3Wjvdbzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Huang <huanghaiyang83@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <xiang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 621/869] erofs: fix interlaced ztailpacking pclusters
Date: Sat, 17 Oct 2026 17:57:42 +0200
Message-ID: <20261017160052.950210581@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
 fs/erofs/zmap.c         | 8 +++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index 39695addce076..d965a3f3073b7 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -312,6 +312,7 @@ static int z_erofs_transform_plain(struct z_erofs_decompress_req *rq,
 		return -EOPNOTSUPP;
 	if (rq->alg == Z_EROFS_COMPRESSION_INTERLACED) {
 		cur = bs - (rq->pageofs_out & (bs - 1));
+		DBG_BUGON(rq->pageofs_in & (bs - 1));
 		pi = (rq->pageofs_in + rq->inputsize - cur) & ~PAGE_MASK;
 		cur = min(cur, rq->outputsize);
 		if (cur && rq->out[0]) {
diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index af1046908c626..eb14dda612a9e 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -477,9 +477,11 @@ static int z_erofs_do_map_blocks(struct inode *inode,
 			err = -EFSCORRUPTED;
 			goto unmap_out;
 		}
-		afmt = vi->z_advise & Z_EROFS_ADVISE_INTERLACED_PCLUSTER ?
-			Z_EROFS_COMPRESSION_INTERLACED :
-			Z_EROFS_COMPRESSION_SHIFTED;
+		if ((vi->z_advise & Z_EROFS_ADVISE_INTERLACED_PCLUSTER) &&
+		    !(map->m_flags & EROFS_MAP_META))
+			afmt = Z_EROFS_COMPRESSION_INTERLACED;
+		else
+			afmt = Z_EROFS_COMPRESSION_SHIFTED;
 	} else {
 		afmt = m.headtype == Z_EROFS_LCLUSTER_TYPE_HEAD2 ?
 			vi->z_algorithmtype[1] : vi->z_algorithmtype[0];
-- 
2.53.0



