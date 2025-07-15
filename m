Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121C02E2EEF;
	Tue, 15 Jul 2025 13:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587329; cv=none; b=PNGMCN7mNe95EG/FajNoNPvM8ViB/z6XsbEEVpJBB0VcJAZ7p6Hh9e+/QxqJoPurk31O6BS9vAI7IJ/u/KG8AMHbD7WSjsFbBxtCEVg2UfPa17C3f8ceRtSFNOsQ12Q8eFOFOi5pHHoLHwBBwzY1nVXitHUMzBcJrv0TzFa4czA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587329; c=relaxed/simple;
	bh=7VQQBq1JxtiKGYS2xWFEpsi++KdibzHpjWNl7NCCFsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u//JJfyspAodDD0BQCYvIEUCzad4L0DVj4YJZaUoXo30Cl5WNodXVOIevqN45UlvpAxVlJRMqRGb56K+eEsuq2qnCWkwaJ2FqRySAibtiELl+CcKsfQ/8vFoGXgmgTxyn8WHz88P/x+gmmyfyopTJZtVeiMi65tsra7Ajsvh6Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RbQTUK+P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RbQTUK+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B799C4CEE3;
	Tue, 15 Jul 2025 13:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587329;
	bh=7VQQBq1JxtiKGYS2xWFEpsi++KdibzHpjWNl7NCCFsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RbQTUK+PfeDEXOuI7jWw6f027n3yE44KVOSueTmSzaPN1ROocI9fh8OcpYYNnCiCB
	 7FjYKK3jH5PoTSqSmaTqQJI59ivF/MgPNeLj3MUettDSS+CX1qVgvf8KSpR+7wWRLy
	 K7521VE+dntPO4n6ORk8zLrvrLNg3RGqGqJoBTio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Hu <huyue2@coolpad.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 59/88] erofs: remove the member readahead from struct z_erofs_decompress_frontend
Date: Tue, 15 Jul 2025 15:14:35 +0200
Message-ID: <20250715130756.932211838@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yue Hu <huyue2@coolpad.com>

[ Upstream commit ef4b4b46c6aaf8edeea9a79320627fe10993f153 ]

The struct member is only used to add REQ_RAHEAD during I/O submission.
So it is cleaner to pass it as a parameter than keep it in the struct.

Also, rename function z_erofs_get_sync_decompress_policy() to
z_erofs_is_sync_decompress() for better clarity and conciseness.

Signed-off-by: Yue Hu <huyue2@coolpad.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20230524063944.1655-1-zbestahu@gmail.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Stable-dep-of: 99f7619a77a0 ("erofs: fix to add missing tracepoint in erofs_read_folio()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 94e9e0bf3bbd1..8018f31d2dbca 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -407,7 +407,6 @@ struct z_erofs_decompress_frontend {
 	z_erofs_next_pcluster_t owned_head;
 	enum z_erofs_pclustermode mode;
 
-	bool readahead;
 	/* used for applying cache strategy on the fly */
 	bool backmost;
 	erofs_off_t headoffset;
@@ -949,7 +948,7 @@ static int z_erofs_do_read_page(struct z_erofs_decompress_frontend *fe,
 	return err;
 }
 
-static bool z_erofs_get_sync_decompress_policy(struct erofs_sb_info *sbi,
+static bool z_erofs_is_sync_decompress(struct erofs_sb_info *sbi,
 				       unsigned int readahead_pages)
 {
 	/* auto: enable for read_folio, disable for readahead */
@@ -1482,7 +1481,7 @@ static void z_erofs_decompressqueue_endio(struct bio *bio)
 static void z_erofs_submit_queue(struct z_erofs_decompress_frontend *f,
 				 struct page **pagepool,
 				 struct z_erofs_decompressqueue *fgq,
-				 bool *force_fg)
+				 bool *force_fg, bool readahead)
 {
 	struct super_block *sb = f->inode->i_sb;
 	struct address_space *mc = MNGD_MAPPING(EROFS_SB(sb));
@@ -1568,7 +1567,7 @@ static void z_erofs_submit_queue(struct z_erofs_decompress_frontend *f,
 				bio->bi_iter.bi_sector = (sector_t)cur <<
 					(sb->s_blocksize_bits - 9);
 				bio->bi_private = q[JQ_SUBMIT];
-				if (f->readahead)
+				if (readahead)
 					bio->bi_opf |= REQ_RAHEAD;
 				++nr_bios;
 			}
@@ -1604,13 +1603,13 @@ static void z_erofs_submit_queue(struct z_erofs_decompress_frontend *f,
 }
 
 static void z_erofs_runqueue(struct z_erofs_decompress_frontend *f,
-			     struct page **pagepool, bool force_fg)
+			     struct page **pagepool, bool force_fg, bool ra)
 {
 	struct z_erofs_decompressqueue io[NR_JOBQUEUES];
 
 	if (f->owned_head == Z_EROFS_PCLUSTER_TAIL)
 		return;
-	z_erofs_submit_queue(f, pagepool, io, &force_fg);
+	z_erofs_submit_queue(f, pagepool, io, &force_fg, ra);
 
 	/* handle bypass queue (no i/o pclusters) immediately */
 	z_erofs_decompress_queue(&io[JQ_BYPASS], pagepool);
@@ -1708,8 +1707,8 @@ static int z_erofs_read_folio(struct file *file, struct folio *folio)
 	(void)z_erofs_collector_end(&f);
 
 	/* if some compressed cluster ready, need submit them anyway */
-	z_erofs_runqueue(&f, &pagepool,
-			 z_erofs_get_sync_decompress_policy(sbi, 0));
+	z_erofs_runqueue(&f, &pagepool, z_erofs_is_sync_decompress(sbi, 0),
+			 false);
 
 	if (err)
 		erofs_err(inode->i_sb, "failed to read, err [%d]", err);
@@ -1727,7 +1726,6 @@ static void z_erofs_readahead(struct readahead_control *rac)
 	struct page *pagepool = NULL, *head = NULL, *page;
 	unsigned int nr_pages;
 
-	f.readahead = true;
 	f.headoffset = readahead_pos(rac);
 
 	z_erofs_pcluster_readmore(&f, rac, f.headoffset +
@@ -1758,7 +1756,7 @@ static void z_erofs_readahead(struct readahead_control *rac)
 	(void)z_erofs_collector_end(&f);
 
 	z_erofs_runqueue(&f, &pagepool,
-			 z_erofs_get_sync_decompress_policy(sbi, nr_pages));
+			 z_erofs_is_sync_decompress(sbi, nr_pages), true);
 	erofs_put_metabuf(&f.map.buf);
 	erofs_release_pages(&pagepool);
 }
-- 
2.39.5



