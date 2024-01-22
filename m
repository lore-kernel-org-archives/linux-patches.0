Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A7810F1;
	Tue, 23 Jan 2024 02:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975758; cv=none; b=V8waeXKP7HW2M/8e63M2ojhk3Jcyg0KPwMLqr/vIAkjIsUSit5gWReTjnLqojrqbJm2gc/6dgn2wZ0FAvHuKWxlNWQ9PpoIdzwtREYAN1tXl62ueLUTZmPox3DD138Ds54rYVCKHlcce/zMdqFz10+llLF0dVPEu5Rr+gSBMDNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975758; c=relaxed/simple;
	bh=AIySx+WIBp8NSegAp9sC6Iabpr22BdIVkcPTECtCOTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BeTDyfJgpPnTkTrqvnTBdPSp3WH/igrFFtPJnV8sHS9osSjeLi0oCi29Kv6s/IJibUCpfucMxQYkvfgZ0Wu+7j+Yujbej5O5T4PzAKhpejE2bUgAipg6tbc3h1SZf7e+tVeLIBXIBh30KpYI259uWb5slSR9c5cYiB/84yMR1bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7iCydo5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7iCydo5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90195C433C7;
	Tue, 23 Jan 2024 02:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975758;
	bh=AIySx+WIBp8NSegAp9sC6Iabpr22BdIVkcPTECtCOTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7iCydo5LxR0ITv1azqeZiUwgswFp2BmgkvHL3o8eY6aurI8DopqJOQtQOLtmvsTw
	 YclL4OeUg4buPlrdOFXCzNziR+BOLW7LgZ5BoYLLGsJKOUMc+tk1epfynpKdYru2nX
	 N3QhMZPSBqAyUmK0qAhPQnFZ1vj6K0wf6ekp+weg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bugreport@ubisectech.com,
	Yue Hu <huyue2@coolpad.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 541/583] erofs: fix inconsistent per-file compression format
Date: Mon, 22 Jan 2024 15:59:52 -0800
Message-ID: <20240122235828.681122817@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e75edc8f1753..8d1f86487d6e 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -399,7 +399,7 @@ int z_erofs_parse_cfgs(struct super_block *sb, struct erofs_super_block *dsb)
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



