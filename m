Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028409;
	b=pEIpPQJysglw21aFjCk0E6g3B09nclOSU3MUxqVcSmsM3kOC0U+cdzpiqzimGcEdi2lA
	 rp7bHG5P9Hvtdym81k17w4pw/ZFf5r9LUcM4dDrv7eFwEKFYy9L+TomqhQLe6G5D50lmo
	 3m/ywxOtbvQDMlKfPE4ohCjusoYwuELYOAPlhnGO9S+bmRkI7k+lhH/dtwLyUmQLqdkfz
	 PL1n2n7wMLt4lWtaJpmxDG6Few0k7QArc6VTVF24RxB6b9e/LGmfafVz+2HSBUe3clvxz
	 on+ncef7uniZHDUPAUm+CWqSyCkOYCCCAkeL7WmetgT853ymNn5AGshcFg1s3aVc4Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028409;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lmWT07alqjpbNsqKNKF5KULWZhlKrcHkWq4FjJbOv44=;
	b=kbKpUlH5bGj+Inuy68DroicxlpM8W3GyscMZ+tM4/46yWcpY9BIuZtvAXYpXHVGe2Ebu
	 bHqguwvfhtpzLh+bUFVGeY7wKSniR8n1fnM58Xr69yYI7o4Rn+jydf8pJ5BPe67d+jeXy
	 OUkN1RS4oUFbNpMxuCf7is7JqgtOf0oVVzVwbG97N8rFNX/2u+ceRgakk3NU8kK6Thmcu
	 QIIZ9wCsA8gTh0elGB5wBkUyMB8PCy0KLyrV6o1wJFq4vH+nrSj+ZDLyEoOOBPRDwycBD
	 V9l7RUV5ySs33NXntbVuU/wteKHPilMGv4c7yc7NUBZc5m4VK3TGCEl/hEtjg96DIQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jWc1vP42;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B527606A332;
	Wed, 18 Nov 2026 19:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jWc1vP42
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C063B1F000C4;
	Wed, 18 Nov 2026 19:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028409;
	bh=lmWT07alqjpbNsqKNKF5KULWZhlKrcHkWq4FjJbOv44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jWc1vP42XVr4oGRaam1tuYI7oI3oioavR+qvcXBC0iMY4/uJK3oL1Eq+6bpOSoKAn
	 N4CY930Hs3tRCalTYUIjGH3SZehwAfdR8NxXO7ioSSFcs9ml9rvJwi9s+erNsgCv2A
	 jwFCheNux591deVy9Z43v7eKbhZlQmY7ajK1rJSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2093/2151] zloop: share more code for opening a zone backing file
Date: Wed, 18 Nov 2026 16:03:48 +0100
Message-ID: <20261118150237.943495309@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b1ec6d6a30242..9e64e1229dd6a 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -813,8 +813,6 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
 {
 	struct zloop_zone *zone = &zlo->zones[zone_no];
 	int oflags = O_RDWR;
-	struct kstat stat;
-	sector_t file_sectors;
 	int ret;
 
 	mutex_init(&zone->lock);
@@ -826,27 +824,33 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
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
@@ -867,30 +871,13 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
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



