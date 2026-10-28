Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216136;
	b=enmiv20RgCUpz5HgeDIvwUhR7Ob4z4oZxuSc6aeZGP2xjNGjBsx/lkfEx7DtUht1JQQF
	 cx2uoKgkPJgVvy5UdzTs/NDO/3uhGxa0j//vG5ebVSr1Yt3dQFbXeyWF0kJLNzRB7lSq1
	 BV7D0eF69/Gk+YxTzh2bTAa/NV/g8u1XZNfXAFezISDdbwa75m+fSLN5vOn52A0Y6k8cO
	 ZEdxtGjX5X1nsHN6EXsxpr+5U88iDCVtw39pwqHNKkAkfrJO3TJQo9XJPfrnd8gHxL4/Y
	 5SoLaEJ8I56eRCa4XRLABxGfXZ1izl+qrbRgodFv//FPke+fLzHL6KXu67BeRE/jmXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216136;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MIS4g0q1r7J9O47b37yrHi2frQkI7khtN4FhYndBMoA=;
	b=KFaRLqTzXS9/HGdWrc7RVaAyJraI6hgB8z/3XeOD1R1pS3HkAv3vKmjACYX1GySS/mPn
	 HRYlbbap6fmCZvmiV+N2W8Csjy6JbCIbFAbMBLi8nvc4y0dsT98KVPIFV9xK142Fo9qxo
	 NYcw9Y5DYJl0E2RhfbUNDpQm2N3mxiq2Ts+8AQX5SZRS8lemhytDQHx8FD6KQlW39xNoz
	 oRNzKocTlLP6v2RuwtszhZShReMmgOtmQuTtLZbHdiOpjPb8szA3MQNqdMkrTAZHqmIkt
	 zBFxt1jD9lX2eWdlcaLRgqhJvZFWi5k9wpEW9OqQGeDlhAKUQZsiBa5SmknNsO8gIHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NWS9MfZO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA7A606A31A;
	Wed, 28 Oct 2026 19:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NWS9MfZO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CFA1F01825;
	Wed, 28 Oct 2026 19:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216136;
	bh=MIS4g0q1r7J9O47b37yrHi2frQkI7khtN4FhYndBMoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NWS9MfZOjr03ybK5U8Oc/n3mKoiPzOpV2GII/eH2RkxUclY5EvCGn7sOnhGSQGW9K
	 SsqPhidfwvTkXGPJ7bLB2nLMssf0S7+zGB6kQZaqW37i/aqaYPIeoZAUK/zxx7vR6z
	 luqlodSC8TcYvZ2N1AJjBmt1pzlHAJ7T21Fq7EJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1451/1887] erofs: fix inline data read failure for ztailpacking pclusters
Date: Wed, 28 Oct 2026 17:59:07 +0100
Message-ID: <20261028170532.479431960@linuxfoundation.org>
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
 fs/erofs/zdata.c | 44 +++++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index f3d859e6ffbcc..7dbfdfab6e35c 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -689,6 +689,7 @@ static int z_erofs_collector_begin(struct z_erofs_decompress_frontend *fe)
 {
 	struct erofs_map_blocks *map = &fe->map;
 	struct erofs_workgroup *grp = NULL;
+	void *ptr = NULL;
 	int ret;
 
 	DBG_BUGON(fe->pcl);
@@ -704,6 +705,19 @@ static int z_erofs_collector_begin(struct z_erofs_decompress_frontend *fe)
 		return -EFSCORRUPTED;
 	}
 
+	if (map->m_flags & EROFS_MAP_META) {
+		ptr = erofs_read_metabuf(&map->buf, fe->inode->i_sb,
+					 erofs_blknr(fe->inode->i_sb, map->m_pa),
+					 EROFS_NO_KMAP);
+		if (IS_ERR(ptr)) {
+			ret = PTR_ERR(ptr);
+			erofs_err(fe->inode->i_sb,
+				  "failed to get inline page, err %d", ret);
+			return ret;
+		}
+		ptr = map->buf.page;
+	}
+
 	if (grp) {
 		fe->pcl = container_of(grp, struct z_erofs_pcluster, obj);
 		ret = -EEXIST;
@@ -719,6 +733,15 @@ static int z_erofs_collector_begin(struct z_erofs_decompress_frontend *fe)
 	}
 	z_erofs_bvec_iter_begin(&fe->biter, &fe->pcl->bvset,
 				Z_EROFS_INLINE_BVECS, fe->pcl->vcnt);
+	if (z_erofs_is_inline_pcluster(fe->pcl)) {
+		get_page(ptr);
+		WRITE_ONCE(fe->pcl->compressed_bvecs[0].page, ptr);
+		fe->pcl->pageofs_in = map->m_pa & ~PAGE_MASK;
+		fe->mode = Z_EROFS_PCLUSTER_FOLLOWED_NOINPLACE;
+	} else {
+		/* bind cache first when cached decompression is preferred */
+		z_erofs_bind_cache(fe);
+	}
 	/* since file-backed online pages are traversed in reverse order */
 	fe->icur = z_erofs_pclusterpages(fe->pcl);
 	return 0;
@@ -840,27 +863,6 @@ static int z_erofs_do_read_page(struct z_erofs_decompress_frontend *fe,
 	if (err)
 		goto out;
 
-	if (z_erofs_is_inline_pcluster(fe->pcl)) {
-		void *mp;
-
-		mp = erofs_read_metabuf(&fe->map.buf, inode->i_sb,
-					erofs_blknr(inode->i_sb, map->m_pa),
-					EROFS_NO_KMAP);
-		if (IS_ERR(mp)) {
-			err = PTR_ERR(mp);
-			erofs_err(inode->i_sb,
-				  "failed to get inline page, err %d", err);
-			goto out;
-		}
-		get_page(fe->map.buf.page);
-		WRITE_ONCE(fe->pcl->compressed_bvecs[0].page,
-			   fe->map.buf.page);
-		fe->pcl->pageofs_in = map->m_pa & ~PAGE_MASK;
-		fe->mode = Z_EROFS_PCLUSTER_FOLLOWED_NOINPLACE;
-	} else {
-		/* bind cache first when cached decompression is preferred */
-		z_erofs_bind_cache(fe);
-	}
 hitted:
 	/*
 	 * Ensure the current partial page belongs to this submit chain rather
-- 
2.53.0



