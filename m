Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022281;
	b=TizrBOZmcMrmZVzIQPCuLVDNj+Qxn8ZmumMjEE784ponNuvmflaumtpjmNoUwHt1c1NI
	 tq57h+rp1evxHnFZpro9uljoZeV6ojv8GwrM9Xf9n/ipOz/qJeBKiNQ6xU/2S5/OcCaHM
	 pjTE/XjTr01dqdnmQ2ej61j2WhNq/VpoUcGbORroOVq795GCB3VsU+28ejkoPpXpm9vpA
	 6OZStgjtRZBDsXD3jeoGqP0RU8kihC6Rx57ZKNcPjO4Xz7ttY3iH7204zbZv4FJuyP5+f
	 VRvPQC/90VxNHpMEHkTzHZJR9+6Fxf75u4k9Wr8Kqoe6uIAOsYqbiwQtmBLRTfqV8mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022281;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tPda5cIU/bVVsBXly0E9tS5LJb+MCM90C6Oj6c3QzA4=;
	b=SyDlpaTN8bn0s+cpelYdipfxY2MfhJyLvI9N2aPHbXB8Db7ghm+Od1qyGFe5ccAcavU4
	 DHv1lMnCm3rkhpKSo5bHhVPp6pcBULIf/msSkza+mFYsBgxjKaunM52tgFRAUetYwDo/h
	 h913jFaiO89iafJFTWDD2LIL0HH39DT1Ie2FFsdWy+iJ07UtoWDAsb/pIBRR8XDRYLGRw
	 XeZ1uDib2+a8Z9ugwaqmyLvZH3lbGjAxmL5haMi5yCeqr7KeOHLDuHK+DTXfXAvf74txQ
	 DzmUc9vD49yzayrGeHABl3zofmQxQfoH+IiGgn92CwepyBvInJZcnva5YrLhAeXSxQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PRwz6Jjr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C3A606A31C;
	Wed, 18 Nov 2026 17:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PRwz6Jjr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479E61F000C4;
	Wed, 18 Nov 2026 17:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022280;
	bh=tPda5cIU/bVVsBXly0E9tS5LJb+MCM90C6Oj6c3QzA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PRwz6Jjr25HwalM0tECEl6gD4zhD5LTnR5eKf4nVYgnYnSFCnwhWGvbT1OjXML9DT
	 wGtAE/7omkez8SR843kEKP8ydgPRABpcC5Af3bl4ctpci7ZN7wE8pIcgnmRTPpdwbG
	 O6X45lKhLpanEXymM1InpqHH/lYvw5hdghSH2Si0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2606/2651] zloop: share more code for opening a zone backing file
Date: Wed, 18 Nov 2026 16:04:06 +0100
Message-ID: <20261118150418.079018646@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 5e9929e2f03c79574e76605e1a82509575db2d30 ]

Use a common path for opening and querying the block size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261029150353.2503201-3-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 134ffb075562 ("zloop: fput file after failed zone init")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zloop.c | 65 +++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 39 deletions(-)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index c61a93b806894..0f37fb373a051 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -1097,8 +1097,6 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
 {
 	struct zloop_zone *zone = &zlo->zones[zone_no];
 	int oflags = O_RDWR;
-	struct kstat stat;
-	sector_t file_sectors;
 	int ret;
 
 	mutex_init(&zone->lock);
@@ -1112,27 +1110,33 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
 	if (!opts->buffered_io)
 		oflags |= O_DIRECT;
 
+	zone->file = zloop_filp_open_fmt(oflags, 0600, "%s/%u/%s-%06u",
+				zlo->base_dir, zlo->id,
+				zone_no < zlo->nr_conv_zones ? "cnv" : "seq",
+				zone_no);
+	if (IS_ERR(zone->file)) {
+		pr_err("Failed to open zone %u file %s/%u/%s-%06u (err=%ld)",
+		       zone_no, zlo->base_dir, zlo->id,
+		       zone_no < zlo->nr_conv_zones ? "cnv" : "seq",
+		       zone_no, PTR_ERR(zone->file));
+		return PTR_ERR(zone->file);
+	}
+
+	if (zlo->block_size) {
+		ret = zloop_get_block_size(zlo, zone);
+		if (ret)
+			return ret;
+	}
+
 	if (zone_no < zlo->nr_conv_zones) {
+		sector_t file_sectors;
+		struct kstat stat;
+
 		/* Conventional zone file. */
 		set_bit(ZLOOP_ZONE_CONV, &zone->flags);
 		zone->cond = BLK_ZONE_COND_NOT_WP;
 		zone->wp = U64_MAX;
 
-		zone->file = zloop_filp_open_fmt(oflags, 0600, "%s/%u/cnv-%06u",
-					zlo->base_dir, zlo->id, zone_no);
-		if (IS_ERR(zone->file)) {
-			pr_err("Failed to open zone %u file %s/%u/cnv-%06u (err=%ld)",
-			       zone_no, zlo->base_dir, zlo->id, zone_no,
-			       PTR_ERR(zone->file));
-			return PTR_ERR(zone->file);
-		}
-
-		if (!zlo->block_size) {
-			ret = zloop_get_block_size(zlo, zone);
-			if (ret)
-				return ret;
-		}
-
 		ret = vfs_getattr(&zone->file->f_path, &stat, STATX_SIZE, 0);
 		if (ret < 0) {
 			pr_err("Failed to get zone %u file stat\n", zone_no);
@@ -1153,30 +1157,13 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
 			       zone_no, ret);
 			return ret;
 		}
-
-		return 0;
-	}
-
-	/* Sequential zone file. */
-	zone->file = zloop_filp_open_fmt(oflags, 0600, "%s/%u/seq-%06u",
-					 zlo->base_dir, zlo->id, zone_no);
-	if (IS_ERR(zone->file)) {
-		pr_err("Failed to open zone %u file %s/%u/seq-%06u (err=%ld)",
-		       zone_no, zlo->base_dir, zlo->id, zone_no,
-		       PTR_ERR(zone->file));
-		return PTR_ERR(zone->file);
-	}
-
-	if (!zlo->block_size) {
-		ret = zloop_get_block_size(zlo, zone);
-		if (ret)
-			return ret;
+	} else {
+		/* Sequential zone file. */
+		mutex_lock(&zone->lock);
+		ret = zloop_update_seq_zone(zlo, zone_no);
+		mutex_unlock(&zone->lock);
 	}
 
-	mutex_lock(&zone->lock);
-	ret = zloop_update_seq_zone(zlo, zone_no);
-	mutex_unlock(&zone->lock);
-
 	return ret;
 }
 
-- 
2.53.0



