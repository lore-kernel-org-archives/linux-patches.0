Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028412;
	b=a9nVimKhgxC9V/06Ry1NOBMvuDX/mnKguZW3YnpXlCFQKMilfTdmdQvl3+7bFznG7np9
	 ddXOEaHYl1UmWhx7U9CJbZ+VOOHWqp7+OEDZMD5M7uR3FZ3Efk9ADpgoD0VrNmcgnXCIN
	 56sysPlCmkS/FukcBNhUp3Z3rohe0tnQaC44TYhY8kzQ0T7hLsUeiDxN07QXUpz+SPMRK
	 Q++AToPRVpVbb4w1HxKeeyZVxV1cXXDXM/2sXhzlBVOzjNlQF+BqBQauYbRyumaUtjUIr
	 nghk5MFdu6E+VTaT/ofTB28GKIKlPzFg1F9MHdZCA56oqzCWIgcs/ftERFZYDd3KARQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028412;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RjMhJo/CgEAwOqrCkvzRh8TubDR6vdvxWbXOEKUMWss=;
	b=3hVUUULjkEWMwNLnThbA3WdCT8VZL0yfQ1ELa/aW8IViscyVsGuwF1+g+lGKBSZ9s6h+
	 6iSVbB8J8o4le+obhfI4CbfSNQfGFNd0Ur9jxxzIdCyQt+pQDHOmtE68rKBGtnVFaW28h
	 8W3eI1tAN0Opt06+v9FU9s35955FgcqT91jvfmIKH3BPR/h4SdshCH2qWan80krGdYSkb
	 /68qWedEUQUOGdBVAIMtBde0XRzKOFVmK9q1hHVBZiPwG/aPgaGVDy2N1y7iM4QY+QXoP
	 k0hXh5SHRae/JgOb43FgUU25omiX4VobBciVSokVXznEm1g4YHjiRwiXN2l/B+Qntyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ipBvfb8Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C461606A334;
	Wed, 18 Nov 2026 19:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ipBvfb8Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FFF91F000C4;
	Wed, 18 Nov 2026 19:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028412;
	bh=RjMhJo/CgEAwOqrCkvzRh8TubDR6vdvxWbXOEKUMWss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ipBvfb8QfL3l8GydLCgwbTz7iVa+ScuYIsPZhQeHs0lNw3PBazX+XO/I4/gUorSoM
	 +P5BAqK9HdrLYliXQb1pTRqRmQz899VODNc4eruNgzMzeKm0u07szoXK+Se0R4KyZz
	 yd8nhYjxN/Cr7BH4H2aIVROIuhjObvAHBFjKLgoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2094/2151] zloop: fput file after failed zone init
Date: Wed, 18 Nov 2026 16:03:49 +0100
Message-ID: <20261118150237.978005950@linuxfoundation.org>
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

[ Upstream commit 134ffb0755626c91af82fc7debc8b6f75f1f777e ]

Clean up after failure in zloop_init_zone, as the caller only cleans up
the zones before the current one.

Fixes: eb0570c7df23 ("block: new zoned loop block device driver")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261029150353.2503201-4-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zloop.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index 9e64e1229dd6a..a485eeb97b379 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -839,7 +839,7 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
 	if (zlo->block_size) {
 		ret = zloop_get_block_size(zlo, zone);
 		if (ret)
-			return ret;
+			goto out_fput;
 	}
 
 	if (zone_no < zlo->nr_conv_zones) {
@@ -854,14 +854,14 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
 		ret = vfs_getattr(&zone->file->f_path, &stat, STATX_SIZE, 0);
 		if (ret < 0) {
 			pr_err("Failed to get zone %u file stat\n", zone_no);
-			return ret;
+			goto out_fput;
 		}
 		file_sectors = stat.size >> SECTOR_SHIFT;
 
 		if (restore && file_sectors != zlo->zone_size) {
 			pr_err("Invalid conventional zone %u file size (%llu sectors != %llu)\n",
 			       zone_no, file_sectors, zlo->zone_capacity);
-			return ret;
+			goto out_fput;
 		}
 
 		ret = vfs_truncate(&zone->file->f_path,
@@ -869,15 +869,21 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
 		if (ret < 0) {
 			pr_err("Failed to truncate zone %u file (err=%d)\n",
 			       zone_no, ret);
-			return ret;
+			goto out_fput;
 		}
 	} else {
 		/* Sequential zone file. */
 		mutex_lock(&zone->lock);
 		ret = zloop_update_seq_zone(zlo, zone_no);
 		mutex_unlock(&zone->lock);
+		if (ret)
+			goto out_fput;
 	}
 
+	return 0;
+
+out_fput:
+	fput(zone->file);
 	return ret;
 }
 
-- 
2.53.0



