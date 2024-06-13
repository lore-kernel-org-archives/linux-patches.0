Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9684181ABF;
	Thu, 13 Jun 2024 12:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281139; cv=none; b=aWuXCo0T+rLmGt7LOVimGx7AfK+zO/Z/KEzY8VXDQfRd5mIxZEgMrFwtSnV00UEg08CSnUz74Lfjs11jhbucQmAHs51eaFjPm4kPse//itRgQjgly/uF+Hpm0f/D2tEnw81uE+6Ml+7mRC/GY1Ag9HWHRFDd9X+EGlYFq6I7Qc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281139; c=relaxed/simple;
	bh=QF1+vh0D1aZCmKpLUrGi9Am+VtwD/qWhooosGN89QKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZroXuUBEQptg1a65I4FyAs3dp0h/vayza7tm7NfFG+VCtJckfijbnFqmwye8Yucyk/O73h1RQx08t9WaMOtRWfcuT7MCytryhZHfgGU1WpNe8Q0XRBgHwLedYi3hNppv19auepfi+8bsGSFaIoGVhOVqZjdU1snvCQfcH4KpP+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wEQTcRk0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wEQTcRk0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC06C2BBFC;
	Thu, 13 Jun 2024 12:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281139;
	bh=QF1+vh0D1aZCmKpLUrGi9Am+VtwD/qWhooosGN89QKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wEQTcRk0+H5lt/wYWPAKXQlTbXaXfWk8p2/F/IrqI3PMwCuQ2da0lNDGfO9tDE4wA
	 NFBiV25YfBS15srVYfyxoXyL+JZ6GNYc1k4MhotsPMEG6H/yaWeUek8jvVidodYaFe
	 c+2yoznQSXUCDFxo2vAKi2vAnrtTZ/xgk5tDTbRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <yuchao0@huawei.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 153/317] f2fs: compress: remove unneeded preallocation
Date: Thu, 13 Jun 2024 13:32:51 +0200
Message-ID: <20240613113253.482912794@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 8f1d49832636d514e949b29ce64370ebebf6d6d2 ]

We will reserve iblocks for compression saved, so during compressed
cluster overwrite, we don't need to preallocate blocks for later
write.

In addition, it adds a bug_on to detect wrong reserved iblock number
in __f2fs_cluster_blocks().

Bug fix in the original patch by Jaegeuk:
If we released compressed blocks having an immutable bit, we can see less
number of compressed block addresses. Let's fix wrong BUG_ON.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 7c5dffb3d90c ("f2fs: compress: fix to relocate check condition in f2fs_{release,reserve}_compress_blocks()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 27 +++------------------------
 fs/f2fs/file.c     |  4 ----
 2 files changed, 3 insertions(+), 28 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 04b6de1a58744..388ed7052d9b6 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -900,6 +900,9 @@ static int __f2fs_cluster_blocks(struct inode *inode,
 					ret++;
 			}
 		}
+
+		f2fs_bug_on(F2FS_I_SB(inode),
+			!compr && ret != cluster_size && !IS_IMMUTABLE(inode));
 	}
 fail:
 	f2fs_put_dnode(&dn);
@@ -960,21 +963,16 @@ static int prepare_compress_overwrite(struct compress_ctx *cc,
 	struct f2fs_sb_info *sbi = F2FS_I_SB(cc->inode);
 	struct address_space *mapping = cc->inode->i_mapping;
 	struct page *page;
-	struct dnode_of_data dn;
 	sector_t last_block_in_bio;
 	unsigned fgp_flag = FGP_LOCK | FGP_WRITE | FGP_CREAT;
 	pgoff_t start_idx = start_idx_of_cluster(cc);
 	int i, ret;
-	bool prealloc;
 
 retry:
 	ret = f2fs_is_compressed_cluster(cc->inode, start_idx);
 	if (ret <= 0)
 		return ret;
 
-	/* compressed case */
-	prealloc = (ret < cc->cluster_size);
-
 	ret = f2fs_init_compress_ctx(cc);
 	if (ret)
 		return ret;
@@ -1032,25 +1030,6 @@ static int prepare_compress_overwrite(struct compress_ctx *cc,
 		}
 	}
 
-	if (prealloc) {
-		f2fs_do_map_lock(sbi, F2FS_GET_BLOCK_PRE_AIO, true);
-
-		set_new_dnode(&dn, cc->inode, NULL, NULL, 0);
-
-		for (i = cc->cluster_size - 1; i > 0; i--) {
-			ret = f2fs_get_block(&dn, start_idx + i);
-			if (ret) {
-				i = cc->cluster_size;
-				break;
-			}
-
-			if (dn.data_blkaddr != NEW_ADDR)
-				break;
-		}
-
-		f2fs_do_map_lock(sbi, F2FS_GET_BLOCK_PRE_AIO, false);
-	}
-
 	if (likely(!ret)) {
 		*fsdata = cc->rpages;
 		*pagep = cc->rpages[offset_in_cluster(cc, index)];
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 678d72a870259..8b136f2dc2d22 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -81,10 +81,6 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 			err = ret;
 			goto err;
 		} else if (ret) {
-			if (ret < F2FS_I(inode)->i_cluster_size) {
-				err = -EAGAIN;
-				goto err;
-			}
 			need_alloc = false;
 		}
 	}
-- 
2.43.0



