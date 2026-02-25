Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2C11D5ABA;
	Wed, 25 Feb 2026 01:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982840; cv=none; b=mw3OPV5J7Zjd/+hkwd07j/55hhXgtMK3OTamyT5lU/xZyPXyjBX54axtq9keav1y7nthythYWActtQ01PSm/1ojTwHwLzWfBUta0Of8pIGfRqBkjTTwuNAYdVXbprQcwAKjmCpiCA/QPMxgOHDrqfURQ+IUyz9pmDt8BXiTdm7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982840; c=relaxed/simple;
	bh=wDDWa8Mo8SYCccJJwGRn0s3raO5V9reVT5nypudL3Zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cf8g70grdy8zenOLa6KqsS2Kp1hrETgRyjQ+wtaxm2tZF8Yd/FG2HjDiTIWiA9HhOJGpy0WrbNMVvm/AfrOeH0/dQmPHt3ViG1srlfXJdN+Ev/NMYhd2dEt2H94TFy/TIyPaZNuhBxWBcnhC/mDq1gGQFqf02v7Ud4OoXfkTsXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GsmDvf5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GsmDvf5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E379EC116D0;
	Wed, 25 Feb 2026 01:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982840;
	bh=wDDWa8Mo8SYCccJJwGRn0s3raO5V9reVT5nypudL3Zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GsmDvf5SORMSEKSVcsQLp1X2yNuiIUX64n7wKbnvVQo7iwvZgoCdc5jENYaNSmnYb
	 xwidsvqWuj0q1LeeYe/PLzuGrCiprMvlYdQ9CU5AcCsldj9pdcDAqBOjCgFObj1UHA
	 WrnJZGdqN/ipPyfdpFe57YhmSswbghBHkgv/PvfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 032/781] erofs: fix inline data read failure for ztailpacking pclusters
Date: Tue, 24 Feb 2026 17:12:21 -0800
Message-ID: <20260225012400.488389853@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit c134a40f86efb8d6b5a949ef70e06d5752209be5 ]

Compressed folios for ztailpacking pclusters must be valid before adding
these pclusters to I/O chains. Otherwise, z_erofs_decompress_pcluster()
may assume they are already valid and then trigger a NULL pointer
dereference.

It is somewhat hard to reproduce because the inline data is in the same
block as the tail of the compressed indexes, which are usually read just
before. However, it may still happen if a fatal signal arrives while
read_mapping_folio() is running, as shown below:

 erofs: (device dm-1): z_erofs_pcluster_begin: failed to get inline data -4
 Unable to handle kernel NULL pointer dereference at virtual address 0000000000000008

 ...

 pc : z_erofs_decompress_queue+0x4c8/0xa14
 lr : z_erofs_decompress_queue+0x160/0xa14
 sp : ffffffc08b3eb3a0
 x29: ffffffc08b3eb570 x28: ffffffc08b3eb418 x27: 0000000000001000
 x26: ffffff8086ebdbb8 x25: ffffff8086ebdbb8 x24: 0000000000000001
 x23: 0000000000000008 x22: 00000000fffffffb x21: dead000000000700
 x20: 00000000000015e7 x19: ffffff808babb400 x18: ffffffc089edc098
 x17: 00000000c006287d x16: 00000000c006287d x15: 0000000000000004
 x14: ffffff80ba8f8000 x13: 0000000000000004 x12: 00000006589a77c9
 x11: 0000000000000015 x10: 0000000000000000 x9 : 0000000000000000
 x8 : 0000000000000000 x7 : 0000000000000000 x6 : 000000000000003f
 x5 : 0000000000000040 x4 : ffffffffffffffe0 x3 : 0000000000000020
 x2 : 0000000000000008 x1 : 0000000000000000 x0 : 0000000000000000
 Call trace:
  z_erofs_decompress_queue+0x4c8/0xa14
  z_erofs_runqueue+0x908/0x97c
  z_erofs_read_folio+0x128/0x228
  filemap_read_folio+0x68/0x128
  filemap_get_pages+0x44c/0x8b4
  filemap_read+0x12c/0x5b8
  generic_file_read_iter+0x4c/0x15c
  do_iter_readv_writev+0x188/0x1e0
  vfs_iter_read+0xac/0x1a4
  backing_file_read_iter+0x170/0x34c
  ovl_read_iter+0xf0/0x140
  vfs_read+0x28c/0x344
  ksys_read+0x80/0xf0
  __arm64_sys_read+0x24/0x34
  invoke_syscall+0x60/0x114
  el0_svc_common+0x88/0xe4
  do_el0_svc+0x24/0x30
  el0_svc+0x40/0xa8
  el0t_64_sync_handler+0x70/0xbc
  el0t_64_sync+0x1bc/0x1c0

Fix this by reading the inline data before allocating and adding
the pclusters to the I/O chains.

Fixes: cecf864d3d76 ("erofs: support inline data decompression")
Reported-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-and-tested-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index c62908f1ce478..b71fcf4be484a 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -805,14 +805,26 @@ static int z_erofs_pcluster_begin(struct z_erofs_frontend *fe)
 	struct erofs_map_blocks *map = &fe->map;
 	struct super_block *sb = fe->inode->i_sb;
 	struct z_erofs_pcluster *pcl = NULL;
-	void *ptr;
+	void *ptr = NULL;
 	int ret;
 
 	DBG_BUGON(fe->pcl);
 	/* must be Z_EROFS_PCLUSTER_TAIL or pointed to previous pcluster */
 	DBG_BUGON(!fe->head);
 
-	if (!(map->m_flags & EROFS_MAP_META)) {
+	if (map->m_flags & EROFS_MAP_META) {
+		ret = erofs_init_metabuf(&map->buf, sb,
+					 erofs_inode_in_metabox(fe->inode));
+		if (ret)
+			return ret;
+		ptr = erofs_bread(&map->buf, map->m_pa, false);
+		if (IS_ERR(ptr)) {
+			erofs_err(sb, "failed to read inline data %pe @ pa %llu of nid %llu",
+				  ptr, map->m_pa, EROFS_I(fe->inode)->nid);
+			return PTR_ERR(ptr);
+		}
+		ptr = map->buf.page;
+	} else {
 		while (1) {
 			rcu_read_lock();
 			pcl = xa_load(&EROFS_SB(sb)->managed_pslots, map->m_pa);
@@ -852,18 +864,8 @@ static int z_erofs_pcluster_begin(struct z_erofs_frontend *fe)
 		/* bind cache first when cached decompression is preferred */
 		z_erofs_bind_cache(fe);
 	} else {
-		ret = erofs_init_metabuf(&map->buf, sb,
-					 erofs_inode_in_metabox(fe->inode));
-		if (ret)
-			return ret;
-		ptr = erofs_bread(&map->buf, map->m_pa, false);
-		if (IS_ERR(ptr)) {
-			ret = PTR_ERR(ptr);
-			erofs_err(sb, "failed to get inline folio %d", ret);
-			return ret;
-		}
-		folio_get(page_folio(map->buf.page));
-		WRITE_ONCE(fe->pcl->compressed_bvecs[0].page, map->buf.page);
+		folio_get(page_folio((struct page *)ptr));
+		WRITE_ONCE(fe->pcl->compressed_bvecs[0].page, ptr);
 		fe->pcl->pageofs_in = map->m_pa & ~PAGE_MASK;
 		fe->mode = Z_EROFS_PCLUSTER_FOLLOWED_NOINPLACE;
 	}
-- 
2.51.0



