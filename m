Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704270;
	b=y0pg+CmQhTRpkwFUyT1BnhT5LD7b/EbJnUCletqHfTcVTMDAIqkPhl4XSEq9Az162DeC
	 qrh+4yBGjG5i6RYhD5ERr157UDGv2m+2R1kIdGVegx3tXtkHoV+ZVsEtC4uN5pFespmtU
	 4aYax4JGryoY18a8GznHtwQ/3yxLsX/UbqAmMjUoeZ2hidGyPfLPneZY8BZezrBkp1hI2
	 b9QDYX+u+VPh5Ae0GtBdZ7mtkBliKhptkuTvqIlNIobTGCyhj9hmz6Yya0DFE9cec0aFA
	 Z6L2aVh4kNm/7RaoojVisdVC4CMz+hxsxlds9msKIy6tat7mcOMX2F5xyyIjjOmFR2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704270;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+uge+/nSGGOECQOkRi/w2gmkY89y7hn5IJYiG6Rn4Q4=;
	b=JH/9IN2WRG7LVcnKaded4Gufr5vxA0wJePC9zeXVY3oGQqAscsLRFRxoG8NFFhQPR7kk
	 s2V1ePbNVSsDRX8Ayhxxr3MNArmtdr2uAaX/IgCelcdwFHo8ahuR40PAdlz2zpujvAqk3
	 WI52Hsb22qkwa5Dd/7GeewKWK0iXF/ppgV94I0crIvJxwGVhfY1m6POrtx4UqT4s0ER3Y
	 fd6LhoQq0Z8CvxSazGwlAwgdVJnwTNttDr5VAnQnpbe9fVpXHm+OxqvJckrmSQQ1MxnOM
	 3M0xS9YVTAJSK/HbnDwRL8LIJ1G4lH/rEbd5ghcw0SfYsPqFqtb8EMY+vIUbtJt+LAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k2vsqM39;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAF8606A31C;
	Thu, 26 Nov 2026 14:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k2vsqM39
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2D41F000C6;
	Thu, 26 Nov 2026 14:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704269;
	bh=+uge+/nSGGOECQOkRi/w2gmkY89y7hn5IJYiG6Rn4Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k2vsqM39cciJD2VrQ1u8pJ7Euum3esFgEpbH/au2IgKg+umD4epi//QVnk0qvB/iV
	 QYTINY89P6HBqL3RFsTvTNHVLO2IvDTYTsfLfnR3uuTi9jW9LFnePoPhpWQi1ntWZn
	 gigMAKEMq5CYo3mUvmULxcs0myFbT3REqHNllfzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <damien.lemoal@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/265] null_blk: Improve implicit zone close
Date: Thu, 26 Nov 2026 15:36:35 +0100
Message-ID: <20261126143609.636048952@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <damien.lemoal@wdc.com>

[ Upstream commit 2e8c6e0e1d2d65562c637940747cfa30559f976a ]

When open zone resource management is enabled, that is, when a null_blk
zoned device is created with zone_max_open different than 0, implicitly
or explicitly opening a zone may require implicitly closing a zone
that is already implicitly open. This operation is done using the
function null_close_first_imp_zone(), which search for an implicitly
open zone to close starting from the first sequential zone. This
implementation is simple but may result in the same being constantly
implicitly closed and then implicitly reopened on write, namely, the
lowest numbered zone that is being written.

Avoid this by starting the search for an implicitly open zone starting
from the zone following the last zone that was implicitly closed. The
function null_close_first_imp_zone() is renamed
null_close_imp_open_zone().

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 6f2b59737bf9 ("null_blk: fix opening closed zones at the active zone limit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/null_blk.h |  1 +
 drivers/block/null_blk/zoned.c    | 22 +++++++++++++++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/block/null_blk/null_blk.h b/drivers/block/null_blk/null_blk.h
index 1c23a864a8266..0778d249924a8 100644
--- a/drivers/block/null_blk/null_blk.h
+++ b/drivers/block/null_blk/null_blk.h
@@ -68,6 +68,7 @@ struct nullb_device {
 	unsigned int nr_zones_imp_open;
 	unsigned int nr_zones_exp_open;
 	unsigned int nr_zones_closed;
+	unsigned int imp_close_zone_no;
 	struct nullb_zone *zones;
 	sector_t zone_size_sects;
 	bool need_zone_res_mgmt;
diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index 68712a2c42484..0a3460b78bd92 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -113,6 +113,7 @@ int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
 		pr_info("zone_max_open limit disabled, limit >= zone count\n");
 	}
 	dev->need_zone_res_mgmt = dev->zone_max_active || dev->zone_max_open;
+	dev->imp_close_zone_no = dev->zone_nr_conv;
 
 	for (i = 0; i <  dev->zone_nr_conv; i++) {
 		zone = &dev->zones[i];
@@ -274,13 +275,24 @@ static blk_status_t __null_close_zone(struct nullb_device *dev,
 	return BLK_STS_OK;
 }
 
-static void null_close_first_imp_zone(struct nullb_device *dev)
+static void null_close_imp_open_zone(struct nullb_device *dev)
 {
-	unsigned int i;
+	struct nullb_zone *zone;
+	unsigned int zno, i;
+
+	zno = dev->imp_close_zone_no;
+	if (zno >= dev->nr_zones)
+		zno = dev->zone_nr_conv;
 
 	for (i = dev->zone_nr_conv; i < dev->nr_zones; i++) {
-		if (dev->zones[i].cond == BLK_ZONE_COND_IMP_OPEN) {
-			__null_close_zone(dev, &dev->zones[i]);
+		zone = &dev->zones[zno];
+		zno++;
+		if (zno >= dev->nr_zones)
+			zno = dev->zone_nr_conv;
+
+		if (zone->cond == BLK_ZONE_COND_IMP_OPEN) {
+			__null_close_zone(dev, zone);
+			dev->imp_close_zone_no = zno;
 			return;
 		}
 	}
@@ -308,7 +320,7 @@ static blk_status_t null_check_open(struct nullb_device *dev)
 
 	if (dev->nr_zones_imp_open) {
 		if (null_check_active(dev) == BLK_STS_OK) {
-			null_close_first_imp_zone(dev);
+			null_close_imp_open_zone(dev);
 			return BLK_STS_OK;
 		}
 	}
-- 
2.53.0



