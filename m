Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5111E332EA7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301256; cv=none; b=fESrwp3jpRpM3Tk6Gc5Pgyo0PES2hS5CLgqPzMxRuDHtMzvxOZUUpzA1ReUYd2fVu9qjxRYNjnqt8gh+4iPLGAK+4m1A7xbXhsNCf2rqy8DqhZDe/cgaIVYfVH2LpmklXqGLQwaa4vEr5srYov4Ab+K6Wi01BdxEZyWvYYhUwsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301256; c=relaxed/simple;
	bh=H4+M4frMpuu9VZziEWFTpF/5sUXIheXRCgWyulN+qZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQHcqFbxfPhifZfPAN0Wjii2NzsHeHgYOFEMOlRpWiHphZUdoSh7gdLBBJpao6/wY6d+6/Mu5VcpNxHo0dCVdZrwO/pQajOZ2OFuOn8ZJ+wkPlbf2cxqup5o8QafHs9O4ggmQUbeUiiAwaqIwsU277hfYKyAmoh0b2uv4QlGb60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jP9wsEuz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jP9wsEuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1F2C116D0;
	Sat, 28 Feb 2026 17:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301256;
	bh=H4+M4frMpuu9VZziEWFTpF/5sUXIheXRCgWyulN+qZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jP9wsEuz99VsjiNCM2dyDexQB5TPdnymSe22Uc40H3eeqnsbczK3uz6fpJ6C4Rj81
	 nJl68H0trOnRgFtUCH5ygIVpsdluqlYecKfpuvTtzADcvZtINSC/QRbCh2ztvCOF6B
	 hu/6YVbSA252M4z4np0eWplKoEUhjOXD3hSg6a9sH5dG/haykyR/RUUibxQQ4C6JZq
	 vpW1o7LXQ0by0W9Qn0A3ySS1i1cM1c6dfSnyKsRlEOwBpBZNvG7y5BgyKEIaoMoF52
	 8UYR71YbKzArI8Qis8+7pr9l6XGxRr9KOWuFG7eKhIOQtWpJ51D5XwRtTM5JRE7/X+
	 iv//gTGxXvbjg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>,
	syzbot+d988dc155e740d76a331@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 439/752] erofs: fix interlaced plain identification for encoded extents
Date: Sat, 28 Feb 2026 12:42:30 -0500
Message-ID: <20260228174750.1542406-439-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 4a2d046e4b13202a6301a993961f5b30ae4d7119 ]

Only plain data whose start position and on-disk physical length are
both aligned to the block size should be classified as interlaced
plain extents. Otherwise, it must be treated as shifted plain extents.

This issue was found by syzbot using a crafted compressed image
containing plain extents with unaligned physical lengths, which can
cause OOB read in z_erofs_transform_plain().

Reported-and-tested-by: syzbot+d988dc155e740d76a331@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/699d5714.050a0220.cdd3c.03e7.GAE@google.com
Fixes: 1d191b4ca51d ("erofs: implement encoded extent metadata")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zmap.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index c8d8e129eb4ba..30775502b56da 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -513,6 +513,7 @@ static int z_erofs_map_blocks_ext(struct inode *inode,
 	unsigned int recsz = z_erofs_extent_recsize(vi->z_advise);
 	erofs_off_t pos = round_up(Z_EROFS_MAP_HEADER_END(erofs_iloc(inode) +
 				   vi->inode_isize + vi->xattr_isize), recsz);
+	unsigned int bmask = sb->s_blocksize - 1;
 	bool in_mbox = erofs_inode_in_metabox(inode);
 	erofs_off_t lend = inode->i_size;
 	erofs_off_t l, r, mid, pa, la, lstart;
@@ -596,17 +597,17 @@ static int z_erofs_map_blocks_ext(struct inode *inode,
 			map->m_flags |= EROFS_MAP_MAPPED |
 				EROFS_MAP_FULL_MAPPED | EROFS_MAP_ENCODED;
 			fmt = map->m_plen >> Z_EROFS_EXTENT_PLEN_FMT_BIT;
+			if (map->m_plen & Z_EROFS_EXTENT_PLEN_PARTIAL)
+				map->m_flags |= EROFS_MAP_PARTIAL_REF;
+			map->m_plen &= Z_EROFS_EXTENT_PLEN_MASK;
 			if (fmt)
 				map->m_algorithmformat = fmt - 1;
-			else if (interlaced && !erofs_blkoff(sb, map->m_pa))
+			else if (interlaced && !((map->m_pa | map->m_plen) & bmask))
 				map->m_algorithmformat =
 					Z_EROFS_COMPRESSION_INTERLACED;
 			else
 				map->m_algorithmformat =
 					Z_EROFS_COMPRESSION_SHIFTED;
-			if (map->m_plen & Z_EROFS_EXTENT_PLEN_PARTIAL)
-				map->m_flags |= EROFS_MAP_PARTIAL_REF;
-			map->m_plen &= Z_EROFS_EXTENT_PLEN_MASK;
 		}
 	}
 	map->m_llen = lend - map->m_la;
-- 
2.51.0

