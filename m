Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60DA3624A5;
	Sat, 12 Sep 2026 09:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203991; cv=none; b=ive97cVU05RmqViyVE9Hjoplg7MLutfNr/TVbqKhXAneUvJC66a7WI8OxyOhLqm16XKbNdiEO1jLKbj/PN85LgmNKPkIQe163Toxco4MNAReOUrMafAvvEOt6cTBkvLQ90lCMWMgCrgeahcyirpO9WqoOxJCp/X6c+4jqgsGDZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203991; c=relaxed/simple;
	bh=lZnOmlfapQ5scHZUTYatfoR3ymzGtP6EhDLvDE/cOAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPiWmJQA4W8npT875daRXpzXwaI5JSS471xJq10viAOi5i6JlHsD+M0KyJMpTZZM5KOn2jSNKGVA+bIZH6Kjrltr3ih9Uu72FJd8LXncak6GVsLkIvABTV02UPEHHEWMtYXdRtEeKKOKy0E3WaK26PQ7RNsXvmMD9fkfmr4IiTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UyTbXlET; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UyTbXlET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB421F000FF;
	Sat, 12 Sep 2026 09:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203989;
	bh=ep6PbrsKseKOzn0ybVf/NIq6jL8YvXsvBMIPX8t9rj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UyTbXlETAniV1wFiqDS2WLslYVlCZ5g7SiRapFh/qhHgZvLnBrEdKTFrTSQ7m47V7
	 2m07RpUMx0Ta76bn6bA0SdmpxzJhUUTbjal5oBHozAlkiT4e3HWOUyXXMb1XXit11J
	 8m/fv93/mW3lzUT3HP0EUtX+bV+gWdMEMebfDHY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Huang <huanghaiyang83@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <xiang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1522/1815] erofs: fix interlaced ztailpacking pclusters
Date: Sat, 12 Sep 2026 08:54:32 +0200
Message-ID: <20260912065724.732133414@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <xiang@kernel.org>

[ Upstream commit 862427ebb81d1f6abbf74d799790e1694b37b187 ]

On-disk sizes of interlaced pclusters should be block-aligned, and
ztailpacking interlaced pclusters should be invalid at all.

Currently, mkfs.erofs won't generate any interlaced pcluster with
ztailpacking enabled, so this doesn't affect any existing valid
filesystems.

However, crafted images can contain invalid interlaced ztailpacking
pclusters, resulting in an out-of-bounds read from a kmap'd page and
copying irrelevant kernel memory into userspace-visible page cache.

Reported-by: Haiyang Huang <huanghaiyang83@gmail.com>
Closes: https://lore.kernel.org/r/20260806065253.1083865-1-huanghaiyang83@gmail.com
Fixes: fdffc091e6f9 ("erofs: support interlaced uncompressed data for compressed files")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/decompressor.c | 1 +
 fs/erofs/zmap.c         | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index 3c54e95964c9f..27caf4bebddc3 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -299,6 +299,7 @@ static const char *z_erofs_transform_plain(struct z_erofs_decompress_req *rq,
 		return ERR_PTR(-EOPNOTSUPP);
 	if (rq->alg == Z_EROFS_COMPRESSION_INTERLACED) {
 		cur = bs - (rq->pageofs_out & (bs - 1));
+		DBG_BUGON(rq->pageofs_in & (bs - 1));
 		pi = (rq->pageofs_in + rq->inputsize - cur) & ~PAGE_MASK;
 		cur = min(cur, rq->outputsize);
 		if (cur && rq->out[0]) {
diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index 5811556a7b71f..b5411b579fd90 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -483,7 +483,8 @@ static int z_erofs_map_blocks_fo(struct inode *inode,
 	}
 
 	if (m.headtype == Z_EROFS_LCLUSTER_TYPE_PLAIN) {
-		if (vi->z_advise & Z_EROFS_ADVISE_INTERLACED_PCLUSTER)
+		if ((vi->z_advise & Z_EROFS_ADVISE_INTERLACED_PCLUSTER) &&
+		    !(map->m_flags & EROFS_MAP_META))
 			map->m_algorithmformat = Z_EROFS_COMPRESSION_INTERLACED;
 		else
 			map->m_algorithmformat = Z_EROFS_COMPRESSION_SHIFTED;
-- 
2.53.0



