Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA61038F658;
	Sat, 17 Oct 2026 17:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259998; cv=none; b=n7FOlfOaLJkznWogoNsD0OPQJoE3nbnJeMlE4vre1xu+5EoaZMJ3dhobbYQvoy5IEUpkQbD6ha1z8GTrmYxxC+7i2jHmYv0kSGVrJTNq918wpnxZevwHjbS/bd37H4x9RzZJ28X2ml7a7UpGJb7OTMTc3KgTFJJE8ssBCOV97uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259998; c=relaxed/simple;
	bh=4DwiTQXljuGI90TOZ/9u8xiF/izjC3wzWtxm09mNAZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QEzb+2uq2r+I1nJ4VALj3FsD8Sse7rnesgtFWwlEMuLJfSqbV/oAluQ77CrszZ8sz/Iy8kwDPkSbfo7TleChCRsZ1iujynGrbM/vJXDSVHUdcj1SlCcJk3tfxb89TeGwHHTiGeVefzYTbzQILmzSee2fEO/E7xHVNFTEkFikKcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+7USu6C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+7USu6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C47F1F000C4;
	Sat, 17 Oct 2026 17:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259997;
	bh=QkaH9FFxoPK3li6gLpBkzI1HAjzmeRdVQ7H+MXmrYPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y+7USu6CtazjHighWGKQVkNLKXpIY1GTlQpfMrK26Z1uSR4BIk+6YMx5o4YHfqJAD
	 Sp+QJ7sQTJ8dx9g2Vt6ALhL/3Ew8ABzESIwJeLrEQyuLs+BvwZJPNcnUoTriuW60I2
	 5bxuefQ224G89KqZlvCIizhA/RNjgSxtTNcAw41U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Huang <huanghaiyang83@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <xiang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1398/1674] erofs: fix interlaced ztailpacking pclusters
Date: Sat, 17 Oct 2026 18:01:10 +0200
Message-ID: <20261017160507.060583700@linuxfoundation.org>
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
 fs/erofs/zmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index 990322b228cb3..8c227ff5b8472 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -559,7 +559,8 @@ static int z_erofs_do_map_blocks(struct inode *inode,
 			err = -EFSCORRUPTED;
 			goto unmap_out;
 		}
-		afmt = vi->z_advise & Z_EROFS_ADVISE_INTERLACED_PCLUSTER ?
+		afmt = (vi->z_advise & Z_EROFS_ADVISE_INTERLACED_PCLUSTER) &&
+		       !(map->m_flags & EROFS_MAP_META) ?
 			Z_EROFS_COMPRESSION_INTERLACED :
 			Z_EROFS_COMPRESSION_SHIFTED;
 	} else {
-- 
2.53.0



