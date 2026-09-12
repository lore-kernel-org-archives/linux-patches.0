Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14808F4F1;
	Sat, 12 Sep 2026 19:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240036; cv=none; b=EGXVvinbZxmyKJt01qTsM/Q4v1r937oUDs2p1SCsQKR+sdb5FJ1JQKXVBO5dYno74Hw4sB0AX6XjKR3xWMQPGDRk67ju/2v6eomFLK+Q969IZU+9sWGliDOSB3PoBtY8dzZuNSE3JhNuUvIAKtjtJQ7sh9jnffRzvONq1t7Y9A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240036; c=relaxed/simple;
	bh=2/eBMFMUW4CnnHrV7hkLU1Tj52CuCVkl2sCh6jVDeZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UGkQ7uOk9/cIhcWKQzVOHafq9gPipFuTLinZ5QO3beEogVWfJYNmi5SxVJxrnQTad+9e/aCDJTe3p+jc8UZZVDek9nbGYmJ9bZD/A6k615a0Wb61wkCm/cXddL8dEWO3bUs4+jC3d91ttJD8rsiQcj1wsQfTQHFVS2Y/oL2bIvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JyRVIEuS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JyRVIEuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0C41F000FF;
	Sat, 12 Sep 2026 19:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240035;
	bh=A8UnOq65qiyWUcAk/Ml6FuTlWSrwqsTVJHWj3AqZ7gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JyRVIEuSR79eYiS5gJgt9oSUW0HaBvdTSGv0kbpJtDfwd/Cxv56WoXmyiHugWToLs
	 Teil+aN7g4dENrtemmgI8S7p38nbbNb5kxc0iiGjAXDB7KwYkk/mrCeabdpAegL8hz
	 qdX7AaZUd2HMMVNMvCby9bQwPSmpI4NMcfFgiCbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 786/935] ubi: fastmap: Use the bitmap API to allocate bitmaps
Date: Sat, 12 Sep 2026 09:03:36 +0200
Message-ID: <20260912065544.857295879@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit e7f35da21f6f8c6a8c7d262dd4e4bd32e3083f79 ]

Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.

It is less verbose and it improves the semantic.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Stable-dep-of: 420477a84f1e ("UBI: Preserve torture flag when rescheduling failed erasures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/fastmap.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 8081fc760d34f..1060e19205d2a 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -20,8 +20,7 @@ static inline unsigned long *init_seen(struct ubi_device *ubi)
 	if (!ubi_dbg_chk_fastmap(ubi))
 		return NULL;
 
-	ret = kcalloc(BITS_TO_LONGS(ubi->peb_count), sizeof(unsigned long),
-		      GFP_KERNEL);
+	ret = bitmap_zalloc(ubi->peb_count, GFP_KERNEL);
 	if (!ret)
 		return ERR_PTR(-ENOMEM);
 
@@ -34,7 +33,7 @@ static inline unsigned long *init_seen(struct ubi_device *ubi)
  */
 static inline void free_seen(unsigned long *seen)
 {
-	kfree(seen);
+	bitmap_free(seen);
 }
 
 /**
@@ -1109,8 +1108,7 @@ int ubi_fastmap_init_checkmap(struct ubi_volume *vol, int leb_count)
 	if (!ubi->fast_attach)
 		return 0;
 
-	vol->checkmap = kcalloc(BITS_TO_LONGS(leb_count), sizeof(unsigned long),
-				GFP_KERNEL);
+	vol->checkmap = bitmap_zalloc(leb_count, GFP_KERNEL);
 	if (!vol->checkmap)
 		return -ENOMEM;
 
@@ -1119,7 +1117,7 @@ int ubi_fastmap_init_checkmap(struct ubi_volume *vol, int leb_count)
 
 void ubi_fastmap_destroy_checkmap(struct ubi_volume *vol)
 {
-	kfree(vol->checkmap);
+	bitmap_free(vol->checkmap);
 }
 
 /**
-- 
2.53.0



