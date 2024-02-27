Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDFB13B2B4;
	Tue, 27 Feb 2024 14:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043655; cv=none; b=KduTd6OOWFE5IETEu8ljQ9bGMGY4FqmLvjarS97LZakHshFCHpj7CNX30w2ggch/Rx8cxUJs5a0B3AsqBW+rBj82WwhLl61wlkDKxITGkZVNYhEjC6BT1hnRlMjO19OyetsNQP0aXT4TeQThsbzvYo+8JrfXUZiAFH/QfOpcbQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043655; c=relaxed/simple;
	bh=Kx7iqq5AmS4419V3U4+gnLZm7wOoAk+pw/cBc6sRs0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fq4SygoPMvNOvSvhgZmRoBYdU3PF1FgGfxixfGkwM840icd1sl5ic+D2D0oYbHWOQ0kF1lxkDWwI3pkbEqCs0IHKSqIw3EgQwUZRBax5r3mAUJ9+7f2LuESofe4wtwFa2jWhULpjDJqu69rurW/a4PqwNCiTd5mQnfNaQeT5JlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fIz/hrnp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fIz/hrnp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D88C43390;
	Tue, 27 Feb 2024 14:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043655;
	bh=Kx7iqq5AmS4419V3U4+gnLZm7wOoAk+pw/cBc6sRs0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fIz/hrnpmYE0CY08bacEzS7tkASj+ApR4UuyjeE7VwOeXAjL/nVPr+9OAJBpngINy
	 GkGV7qbtTkfMODPbg07JV0F8Fsj1ZGP3Q73/ehqU9pmolOLk2fINj3M3uqmDgGAvh1
	 P+YQkwniLnadT1p79h667a0CFDc7jLrD3BH56jkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bugreport@ubisectech.com,
	Yue Hu <huyue2@coolpad.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 6.1 186/195] erofs: fix inconsistent per-file compression format
Date: Tue, 27 Feb 2024 14:27:27 +0100
Message-ID: <20240227131616.540945753@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

commit 118a8cf504d7dfa519562d000f423ee3ca75d2c4 upstream.

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
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Yue Hu <huyue2@coolpad.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/decompressor.c |    2 +-
 fs/erofs/zmap.c         |   23 +++++++++++++----------
 2 files changed, 14 insertions(+), 11 deletions(-)

--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -396,7 +396,7 @@ int z_erofs_parse_cfgs(struct super_bloc
 	int size, ret = 0;
 
 	if (!erofs_sb_has_compr_cfgs(sbi)) {
-		sbi->available_compr_algs = Z_EROFS_COMPRESSION_LZ4;
+		sbi->available_compr_algs = 1 << Z_EROFS_COMPRESSION_LZ4;
 		return z_erofs_load_lz4_config(sb, dsb, NULL, 0);
 	}
 
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -610,7 +610,7 @@ static int z_erofs_do_map_blocks(struct
 		.map = map,
 	};
 	int err = 0;
-	unsigned int lclusterbits, endoff;
+	unsigned int lclusterbits, endoff, afmt;
 	unsigned long initial_lcn;
 	unsigned long long ofs, end;
 
@@ -700,17 +700,20 @@ static int z_erofs_do_map_blocks(struct
 			err = -EFSCORRUPTED;
 			goto unmap_out;
 		}
-		if (vi->z_advise & Z_EROFS_ADVISE_INTERLACED_PCLUSTER)
-			map->m_algorithmformat =
-				Z_EROFS_COMPRESSION_INTERLACED;
-		else
-			map->m_algorithmformat =
-				Z_EROFS_COMPRESSION_SHIFTED;
-	} else if (m.headtype == Z_EROFS_VLE_CLUSTER_TYPE_HEAD2) {
-		map->m_algorithmformat = vi->z_algorithmtype[1];
+		afmt = vi->z_advise & Z_EROFS_ADVISE_INTERLACED_PCLUSTER ?
+			Z_EROFS_COMPRESSION_INTERLACED :
+			Z_EROFS_COMPRESSION_SHIFTED;
 	} else {
-		map->m_algorithmformat = vi->z_algorithmtype[0];
+		afmt = m.headtype == Z_EROFS_VLE_CLUSTER_TYPE_HEAD2 ?
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


