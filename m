Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5525399004;
	Sat, 12 Sep 2026 20:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243226; cv=none; b=tJYbRDPXOmBV/btxciVlFwXkFjEmKSE/BbZwD8Jfw2q7SP1rlEvC1ZnYVfnHN5FuPg5LpDsRsCNl1AjfUHI0CFR265hUZM5Y0oHcVM7+iEfm21aP+48/rX3704K1jnon7qHBwLGVn6Q7yctp2ws/KFX9t+Rv6z88QLXozXyI378=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243226; c=relaxed/simple;
	bh=8hyg5VhnzgdTl4Q2hEDb4bZORa7omm2STf9vPd4cO9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NkGio8SG8nJegvt3iKG2srBXSX/bq37gF0q3x3mxPo07NwNyzWRknMvT+0J0XNCjjTtqAn0mSuQZcHHyjOd/A/u9VfuQOxd+Z1rCq3XS3XzTX0V3iGee7kRHWs0gmxjKyCwJlPM8TyHSVf44XaCGKUTOfHmgqw1dpfZNWzunAmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YXvc/XbW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YXvc/XbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6681F000FF;
	Sat, 12 Sep 2026 20:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243225;
	bh=mdq2nBu1UuqX7Gkt+iMpHJcoussQOeUDw4i8Iha6nyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YXvc/XbW0k6dKIuDN0v/2WTEoDj/BSHCX4B1eR92W2zbu4ugZJmu5/gVAj68MIZLJ
	 37gmdm9gdp6DeO5wIfBHDbWQGeT0R2RSR20KMvLSTlSAHacCr3Cqtkb5plcUHjPvmS
	 qfd/foEX5mTatEb+CQMmiTRGAXX7DQmvyVy8EoYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 680/798] ubi: fastmap: Use the bitmap API to allocate bitmaps
Date: Sat, 12 Sep 2026 09:05:08 +0200
Message-ID: <20260912065532.689595708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



