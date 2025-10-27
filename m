Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE0E233735;
	Mon, 27 Oct 2025 19:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593262; cv=none; b=jVjKITqV56ysQJ6BfiEJ//q2doH+J8SAUrZWLk+4OCc1eV0AM8lmUmA5hBBDoWHBAO8IG7qFXXHSOBxAzL67Sd8iaCGLaIJ3R2O0HJQ9gxU346v2hDYj6/D/UPeNupGm8fBRhdi6vDdGo2TjWtn+Jlm2yajFhe8/q4Bi2h6B5Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593262; c=relaxed/simple;
	bh=ddhjY1xpn6azFvGZz2U+CICxCBn2xQPD1uVXN4dblMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/oaK85M2iglJKJ1eM1toF8NMaXr239f6BXfjRCzXV6VqpmltVfBJmqj1Wdz+W4YQSzvpG8/vz+DxVNeXfeG8UcMbWH49VJcfdfnyFZ2mfa0+Uq+fGddcH5OqUmSAj1aeEjS5jUVCQp8ValGp0XOaIBIDzZ7tyns3XC/kJ0vI+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A5UaKRzz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A5UaKRzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC38CC4CEF1;
	Mon, 27 Oct 2025 19:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593262;
	bh=ddhjY1xpn6azFvGZz2U+CICxCBn2xQPD1uVXN4dblMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A5UaKRzzB00ze6GB+TRI95nUFUYk6dkarrj77S3ijBJE2X/KGBnPVXiXVUNU+PKs0
	 H5JzA3vAiD47zLu4wEbJ4sUyLv0UBsMjuShevTLHTLgm3hRKKUL8GxZvxYhwRcSjH/
	 P+yJuDMSc8z/aQlSn3vdMxNedZfX6UYZ8mQQRLOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@csail.mit.edu>,
	Hongbo Li <lihongbo22@huawei.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 037/184] erofs: fix crafted invalid cases for encoded extents
Date: Mon, 27 Oct 2025 19:35:19 +0100
Message-ID: <20251027183515.912028168@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit a429b76114aaca3ef1aff4cd469dcf025431bd11 ]

Robert recently reported two corrupted images that can cause system
crashes, which are related to the new encoded extents introduced
in Linux 6.15:

  - The first one [1] has plen != 0 (e.g. plen == 0x2000000) but
    (plen & Z_EROFS_EXTENT_PLEN_MASK) == 0. It is used to represent
    special extents such as sparse extents (!EROFS_MAP_MAPPED), but
    previously only plen == 0 was handled;

  - The second one [2] has pa 0xffffffffffdcffed and plen 0xb4000,
    then "cur [0xfffffffffffff000] += bvec.bv_len [0x1000]" in
    "} while ((cur += bvec.bv_len) < end);" wraps around, causing an
    out-of-bound access of pcl->compressed_bvecs[] in
    z_erofs_submit_queue().  EROFS only supports 48-bit physical block
    addresses (up to 1EiB for 4k blocks), so add a sanity check to
    enforce this.

Fixes: 1d191b4ca51d ("erofs: implement encoded extent metadata")
Reported-by: Robert Morris <rtm@csail.mit.edu>
Closes: https://lore.kernel.org/r/75022.1759355830@localhost  [1]
Closes: https://lore.kernel.org/r/80524.1760131149@localhost  [2]
Reviewed-by: Hongbo Li <lihongbo22@huawei.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zmap.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index 798223e6da9ce..87032f90fe840 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -596,7 +596,7 @@ static int z_erofs_map_blocks_ext(struct inode *inode,
 			vi->z_fragmentoff = map->m_plen;
 			if (recsz > offsetof(struct z_erofs_extent, pstart_lo))
 				vi->z_fragmentoff |= map->m_pa << 32;
-		} else if (map->m_plen) {
+		} else if (map->m_plen & Z_EROFS_EXTENT_PLEN_MASK) {
 			map->m_flags |= EROFS_MAP_MAPPED |
 				EROFS_MAP_FULL_MAPPED | EROFS_MAP_ENCODED;
 			fmt = map->m_plen >> Z_EROFS_EXTENT_PLEN_FMT_BIT;
@@ -715,6 +715,7 @@ static int z_erofs_map_sanity_check(struct inode *inode,
 				    struct erofs_map_blocks *map)
 {
 	struct erofs_sb_info *sbi = EROFS_I_SB(inode);
+	u64 pend;
 
 	if (!(map->m_flags & EROFS_MAP_ENCODED))
 		return 0;
@@ -732,6 +733,10 @@ static int z_erofs_map_sanity_check(struct inode *inode,
 	if (unlikely(map->m_plen > Z_EROFS_PCLUSTER_MAX_SIZE ||
 		     map->m_llen > Z_EROFS_PCLUSTER_MAX_DSIZE))
 		return -EOPNOTSUPP;
+	/* Filesystems beyond 48-bit physical block addresses are invalid */
+	if (unlikely(check_add_overflow(map->m_pa, map->m_plen, &pend) ||
+		     (pend >> sbi->blkszbits) >= BIT_ULL(48)))
+		return -EFSCORRUPTED;
 	return 0;
 }
 
-- 
2.51.0



