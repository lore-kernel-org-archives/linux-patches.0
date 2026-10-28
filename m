Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216390;
	b=pe7F+N4XPq/4ghyKYQiY9tgUWNgkVNhu5xy9g3R8/cdcMzqj6FpfAbpvIweMU0FlAdV2
	 taXPVkxqweYGLdKdGY6qDRjMDdmFqquAlltLSEQs8Ua1gxeTbZgtFBQ8wV2ZpVrVA9brz
	 vds8YIMkcGhv4XgkNbxBySeRo5SnSD87nNdGb8nwWtSzJ/07IaBlw8yKvqyZlPUlZ0ZaF
	 6xaKyLyOdwbz+KAYoiplrlkKlYd3/dY/scu07vrqiaA++hVTnc3HX2k2G7H0JM2faFfG3
	 T+0F6wZCjBuzyE2uxyW7FGcutXgI8ob3NQhyRfs/xvnlvH9my1ztUa0WSh3a9kO8JfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216390;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ab78U59qGS+qWOruqI1Ho4kAdvg2jmwp6gJfNILlNpU=;
	b=lr0uu9BrdjARrczS6E7FxIZqszNFw/x0/uZy738fjyVTAdJtfScvxSy6JyZf3DoUCcKr
	 nJCnnte8msg5asajbP23Lz8NQ1VItzLUckU9AdLONlzbQQbirtvfG0Gvvd+qScn5at1Cz
	 v2F1xgL76XkHiPXMHC64FOf/Rg9HfUM40kyFl3IGVGP8buUeTRqAaHbKhHA/Iy6zUJJfl
	 8lVjYjouOmwD/yEzpJHQoSxdmCCsAPFhdTzZY9iHvl1qAa8ZcsguCx6Sn7EItgqdTcGnk
	 skdyDbm8/VCopwCnH8ml4aWNem942PAz3b5JhZThvxLssgHX21bg0Proi6KSExYkI1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1JUekQf7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67299606A31A;
	Wed, 28 Oct 2026 19:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1JUekQf7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C881F01825;
	Wed, 28 Oct 2026 19:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216390;
	bh=ab78U59qGS+qWOruqI1Ho4kAdvg2jmwp6gJfNILlNpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1JUekQf7rrtc3+rN7+UTI1VFsmKK2i6DgcYp6ihICAxBkwNh1Bm57BAdiMT/I41aV
	 OxKGabUg7afW9JXLlrYNUg4f8g61unArbsuefu2aOF1qUPNEyQ/X/pzx0rIQDB7D9u
	 1lPUSBoTcR3QrUxFH2sY1gXFE2LXqmFIjPFJJ4+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Huang <huanghaiyang83@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <xiang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1539/1887] erofs: fix interlaced ztailpacking pclusters
Date: Wed, 28 Oct 2026 18:00:35 +0100
Message-ID: <20261028170534.488387347@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c120de200eb37..9159461be6109 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -577,7 +577,8 @@ static int z_erofs_do_map_blocks(struct inode *inode,
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



