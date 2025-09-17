Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC4E1E489;
	Wed, 17 Sep 2025 12:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113095; cv=none; b=NZ94LN9ZOwyRW/hjCdTY8V2FcVFFuJg/LQPqp2NRjMxG0TlgnPf7PqdFv9hTbb7Xlhdafcm8PK1i+LHzIA6RRkaCUnWgJAooU2IdcL995m00/ebp3Jhf+gFzSd05FiUmpqpSaYXNE4Syyr7jBzocm+EMiPPB/h5aCDq07jksjd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113095; c=relaxed/simple;
	bh=XDL5Uw3lLfNYvyAAxutpf3yG+Bh525e+6d4IRGfgdfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6zx3fn/exNmpKjRNk2r2+3o9zyYLuV4uc4Cd/3fXg+45nudouh4CqarY6g1maRxrAghwl4a771hVwRRF5Xzy6LoafHpJ5xgTAuqncgkTEU8HT9v9tGP4xKEx0eXtHZvA03tCHQrwBC9rhWSAoGNE4Z8EBIbHQV17EcATB71UuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DT9F+9vZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DT9F+9vZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5F4C4CEF0;
	Wed, 17 Sep 2025 12:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113095;
	bh=XDL5Uw3lLfNYvyAAxutpf3yG+Bh525e+6d4IRGfgdfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DT9F+9vZVoJXEvqnIgQuNqZGBo+2r+6DszGm899/05CFNUh3Q9t1d02MENnu3ylDm
	 QIahL8ozbDHDZP1ObyQ4g3iy+CZXmVb53G2eTbDaZiSOiFnqLhK5uyAqwt/lfePTUW
	 n320buAksMQ7+PQH4QMCYomWoc6sLNi8S5ScmQEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 170/189] erofs: get rid of {get,put}_page() for ztailpacking data
Date: Wed, 17 Sep 2025 14:34:40 +0200
Message-ID: <20250917123356.033383701@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 96debe8c27ee2494bbd78abf3744745a84a745f1 ]

The compressed data for the ztailpacking feature is fetched from
the metadata inode (e.g., bd_inode), which is folio-based.

Therefore, the folio interface should be used instead.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250626085459.339830-1-hsiangkao@linux.alibaba.com
Stable-dep-of: 131897c65e2b ("erofs: fix invalid algorithm for encoded extents")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 9bb53f00c2c62..33c61f3b667c3 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -805,6 +805,7 @@ static int z_erofs_pcluster_begin(struct z_erofs_frontend *fe)
 	struct erofs_map_blocks *map = &fe->map;
 	struct super_block *sb = fe->inode->i_sb;
 	struct z_erofs_pcluster *pcl = NULL;
+	void *ptr;
 	int ret;
 
 	DBG_BUGON(fe->pcl);
@@ -854,15 +855,13 @@ static int z_erofs_pcluster_begin(struct z_erofs_frontend *fe)
 		/* bind cache first when cached decompression is preferred */
 		z_erofs_bind_cache(fe);
 	} else {
-		void *mptr;
-
-		mptr = erofs_read_metabuf(&map->buf, sb, map->m_pa, false);
-		if (IS_ERR(mptr)) {
-			ret = PTR_ERR(mptr);
+		ptr = erofs_read_metabuf(&map->buf, sb, map->m_pa, false);
+		if (IS_ERR(ptr)) {
+			ret = PTR_ERR(ptr);
 			erofs_err(sb, "failed to get inline data %d", ret);
 			return ret;
 		}
-		get_page(map->buf.page);
+		folio_get(page_folio(map->buf.page));
 		WRITE_ONCE(fe->pcl->compressed_bvecs[0].page, map->buf.page);
 		fe->pcl->pageofs_in = map->m_pa & ~PAGE_MASK;
 		fe->mode = Z_EROFS_PCLUSTER_FOLLOWED_NOINPLACE;
@@ -1325,9 +1324,8 @@ static int z_erofs_decompress_pcluster(struct z_erofs_backend *be, int err)
 
 	/* must handle all compressed pages before actual file pages */
 	if (pcl->from_meta) {
-		page = pcl->compressed_bvecs[0].page;
+		folio_put(page_folio(pcl->compressed_bvecs[0].page));
 		WRITE_ONCE(pcl->compressed_bvecs[0].page, NULL);
-		put_page(page);
 	} else {
 		/* managed folios are still left in compressed_bvecs[] */
 		for (i = 0; i < pclusterpages; ++i) {
-- 
2.51.0



