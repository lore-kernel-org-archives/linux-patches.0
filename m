Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5159392829;
	Sat, 17 Oct 2026 17:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258651; cv=none; b=Iwb7NPtVqULX318R/xaumhhlkEpyN+3FOJtrGCVycYCWMDVR25EZAlvuHqbQT3kEurl5fOsdX08CjLcxSJu/tN9V9rwzHn21IhOwjcqBZVd5rLxxnp++wOhGf2+MgXLCqDSkxDBzLyleOfmVl6DrUcHRWe4TU7RDBHWpC19Mp8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258651; c=relaxed/simple;
	bh=H2oNiFGFZPoCxKlBDeGi3Yr1TmOd3FB9SdVQfeywvrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DqYWAa0TUQf9cYCV8qElADlMgS4IBF9N+6uLSezSPS/k9vzkVGETTdzWeF88z5YZvCaFVMx5CTt6FFd/3uWf2Kiv0kmkK3sU5gBUlCmVT/d00yQXStFPnerlW8YahsmZzDx2byOIuBp62xy8uRvDp/pGVKX1NaISd2ia3XTTe/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CHOjCu5q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CHOjCu5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5141F000C4;
	Sat, 17 Oct 2026 17:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258649;
	bh=WaSDynTbGGvXyLLDnr6B2j29QauBns/rtyvGWYL7/NU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CHOjCu5q4bDCnuoxI9um6rR0ezy/QGrELqcjKrycWutCp8SQVUczTkZow8ho7BsgF
	 7qLX2U5DptGxc5hA3nGYs05XKqYye4JOl0Dri5d3M+Qj4P+Rs45EQ2Fvw76zep5nE0
	 fWOG5+EcFuxgDC3ajM9LVPFmWGI5FA2P4nXzZkFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0954/1674] erofs: fix inline data read failure for ztailpacking pclusters
Date: Sat, 17 Oct 2026 17:53:46 +0200
Message-ID: <20261017160455.614263654@linuxfoundation.org>
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
 fs/erofs/zdata.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 5b3eb4a227934..08af755ebd8e4 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -863,9 +863,20 @@ static int z_erofs_pcluster_begin(struct z_erofs_decompress_frontend *fe)
 
 	if (!(map->m_flags & EROFS_MAP_META)) {
 		grp = erofs_find_workgroup(sb, blknr);
-	} else if ((map->m_pa & ~PAGE_MASK) + map->m_plen > PAGE_SIZE) {
-		DBG_BUGON(1);
-		return -EFSCORRUPTED;
+	} else {
+		void *mptr;
+
+		if ((map->m_pa & ~PAGE_MASK) + map->m_plen > PAGE_SIZE) {
+			DBG_BUGON(1);
+			return -EFSCORRUPTED;
+		}
+
+		mptr = erofs_read_metabuf(&map->buf, sb, blknr, EROFS_NO_KMAP);
+		if (IS_ERR(mptr)) {
+			ret = PTR_ERR(mptr);
+			erofs_err(sb, "failed to get inline data %d", ret);
+			return ret;
+		}
 	}
 
 	if (grp) {
@@ -888,14 +899,6 @@ static int z_erofs_pcluster_begin(struct z_erofs_decompress_frontend *fe)
 		/* bind cache first when cached decompression is preferred */
 		z_erofs_bind_cache(fe);
 	} else {
-		void *mptr;
-
-		mptr = erofs_read_metabuf(&map->buf, sb, blknr, EROFS_NO_KMAP);
-		if (IS_ERR(mptr)) {
-			ret = PTR_ERR(mptr);
-			erofs_err(sb, "failed to get inline data %d", ret);
-			return ret;
-		}
 		get_page(map->buf.page);
 		WRITE_ONCE(fe->pcl->compressed_bvecs[0].page, map->buf.page);
 		fe->pcl->pageofs_in = map->m_pa & ~PAGE_MASK;
-- 
2.53.0



