Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE18D33C8;
	Tue, 23 Jan 2024 00:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970148; cv=none; b=TCeUjvPSGpXJY74wgzObbLjfEOl71zR7sBv/9dPf9KjhgkliBPQF+O+pQhRugh88tD6dUO715RvQx+VAzdyHVoGNGwbh/chBPCOjNCfnKTqSoH8m4jdYievzYOyK1owhus5JYbNn44npgaV/ewYzo1iPXzD4RhtbgM75wSJIOx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970148; c=relaxed/simple;
	bh=VlBxsSmEMe4XRrh9rNCcUxAZr454fYjhOH5P4AY1Cy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ckj1zdV3nRsWD5p+O1ZSlsDD8ik5yhAL28q6K6kfJRBfq1ddEckupygXb42iwsFfTjs2E3xnILKOeHFsBlR3pus6xAmxRlMy7V3syGABzpvPZyaQ/utP8A90WMsabR9fBF+aZnX/CVRNUiEJhXkOnGDMS8vXGi+Nutgqqxvb6w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RcFRvp6H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RcFRvp6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1653C433F1;
	Tue, 23 Jan 2024 00:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970148;
	bh=VlBxsSmEMe4XRrh9rNCcUxAZr454fYjhOH5P4AY1Cy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RcFRvp6HGhLPdMoCCbYaYVTbr31xRLjsDjikijosiqFQWkwzeYF+ckv8dXEQOIVZ8
	 rj8JE+n0ffzP0QmfqbXX0QpglN0UP0m3iFsk/+n36aw3A825k5kUxeM4JLJyvGM8TN
	 1xEi+fwBa8UjBM2EEFdSnzGXYRoX5j6yhmWEpS0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bugreport@ubisectech.com,
	Yue Hu <huyue2@coolpad.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 599/641] erofs: fix inconsistent per-file compression format
Date: Mon, 22 Jan 2024 15:58:23 -0800
Message-ID: <20240122235836.957048728@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 118a8cf504d7dfa519562d000f423ee3ca75d2c4 ]

EROFS can select compression algorithms on a per-file basis, and each
per-file compression algorithm needs to be marked in the on-disk
superblock for initialization.

However, syzkaller can generate inconsistent crafted images that use
an unsupported algorithmtype for specific inodes, e.g. use MicroLZMA
algorithmtype even it's not set in `sbi->available_compr_algs`.  This
can lead to an unexpected "BUG: kernel NULL pointer dereference" if
the corresponding decompressor isn't built-in.

Fix this by checking against `sbi->available_compr_algs` for each
m_algorithmformat request.  Incorrect !erofs_sb_has_compr_cfgs preset
bitmap is now fixed together since it was harmless previously.

Reported-by: <bugreport@ubisectech.com>
Fixes: 8f89926290c4 ("erofs: get compression algorithms directly on mapping")
Fixes: 622ceaddb764 ("erofs: lzma compression support")
Reviewed-by: Yue Hu <huyue2@coolpad.com>
Link: https://lore.kernel.org/r/20240113150602.1471050-1-hsiangkao@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/decompressor.c |  2 +-
 fs/erofs/zmap.c         | 23 +++++++++++++----------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index 021be5feb1bc..af98e88908ee 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -398,7 +398,7 @@ int z_erofs_parse_cfgs(struct super_block *sb, struct erofs_super_block *dsb)
 	int size, ret = 0;
 
 	if (!erofs_sb_has_compr_cfgs(sbi)) {
-		sbi->available_compr_algs = Z_EROFS_COMPRESSION_LZ4;
+		sbi->available_compr_algs = 1 << Z_EROFS_COMPRESSION_LZ4;
 		return z_erofs_load_lz4_config(sb, dsb, NULL, 0);
 	}
 
diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index 7b55111fd533..7a1a24ae4a2d 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -458,7 +458,7 @@ static int z_erofs_do_map_blocks(struct inode *inode,
 		.map = map,
 	};
 	int err = 0;
-	unsigned int lclusterbits, endoff;
+	unsigned int lclusterbits, endoff, afmt;
 	unsigned long initial_lcn;
 	unsigned long long ofs, end;
 
@@ -547,17 +547,20 @@ static int z_erofs_do_map_blocks(struct inode *inode,
 			err = -EFSCORRUPTED;
 			goto unmap_out;
 		}
-		if (vi->z_advise & Z_EROFS_ADVISE_INTERLACED_PCLUSTER)
-			map->m_algorithmformat =
-				Z_EROFS_COMPRESSION_INTERLACED;
-		else
-			map->m_algorithmformat =
-				Z_EROFS_COMPRESSION_SHIFTED;
-	} else if (m.headtype == Z_EROFS_LCLUSTER_TYPE_HEAD2) {
-		map->m_algorithmformat = vi->z_algorithmtype[1];
+		afmt = vi->z_advise & Z_EROFS_ADVISE_INTERLACED_PCLUSTER ?
+			Z_EROFS_COMPRESSION_INTERLACED :
+			Z_EROFS_COMPRESSION_SHIFTED;
 	} else {
-		map->m_algorithmformat = vi->z_algorithmtype[0];
+		afmt = m.headtype == Z_EROFS_LCLUSTER_TYPE_HEAD2 ?
+			vi->z_algorithmtype[1] : vi->z_algorithmtype[0];
+		if (!(EROFS_I_SB(inode)->available_compr_algs & (1 << afmt))) {
+			erofs_err(inode->i_sb, "inconsistent algorithmtype %u for nid %llu",
+				  afmt, vi->nid);
+			err = -EFSCORRUPTED;
+			goto unmap_out;
+		}
 	}
+	map->m_algorithmformat = afmt;
 
 	if ((flags & EROFS_GET_BLOCKS_FIEMAP) ||
 	    ((flags & EROFS_GET_BLOCKS_READMORE) &&
-- 
2.43.0



