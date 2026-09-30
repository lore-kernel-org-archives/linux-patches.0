Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BCE4DDB23;
	Wed, 30 Sep 2026 16:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786934; cv=none; b=JiX//c3MLIjV4OiwvS6afV86PAr0kMBQytQxnT07HHELOlZIeZi+aP044aAEpvsot3YohZM622EbQ2CbCdKUucfl7QMPKWc4p1MSSrq9AANZROg+ucJjjprup1aIY3iKdyZMPnaYScXrlC62j7Qa94IwK5gPCi1bKdAl2hTAZmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786934; c=relaxed/simple;
	bh=Ns3/iWHCAK7YU8ZUbkz4tizzXTjlIB5Mg1bqismtGes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNKVFO710WYxTxS0pTCLnp9D88w5C4AwGGT7QvS1wUY1fL7IQ9nA43AUhfriivX0FzVmC64CPAfXE7DJbXVU30BwPRdVxfmmvZZuyP5AuCOZi77BMhEEEDh5Oj4Ue4ClezOL+hlQgJ3ITGd4wH9S9+rWlxd8Ga1GCAhHR8yH+BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yggtIRR1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yggtIRR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701241F000FF;
	Wed, 30 Sep 2026 16:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786933;
	bh=HWwUbZHdOSeJ8dOACInlQgSx11Fk36CvAgK1H2aOW94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yggtIRR17U27fLZnxq7THi3ctNyut5kt7OTBm+deeNzev+G6+qMBJ3SLgGFrGqybN
	 aa9D0rED2khcUQXtZfZqKq9vzZCQ0uquHkalkHiDROmfJA8J/9x+tmOl9GieGdNZma
	 GkAfah70ymPY47fNP4J+8qBBsMekoOI+vX0tLdJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZHOU Jiaxiang <me@fxti.xyz>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 051/457] scsi: block: Fix zones_cond out-of-bounds write on zone report
Date: Wed, 30 Sep 2026 17:22:36 +0200
Message-ID: <20260930152347.136874792@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: ZHOU Jiaxiang <me@fxti.xyz>

[ Upstream commit 7c431d61b69a3fd0784c20aa4cd0b8fb501b5653 ]

blk_revalidate_disk_zones() sizes the zones_cond array from the disk
capacity and zone size, but the index used by blk_revalidate_zone_cond()
comes from the device-driven report_zones() walk and is never checked
against the array size. A device reporting more zones than fit the array
makes blk_zone_set_cond() write out of bounds.

One way to reach this is a zone count exceeding 32 bits: both
blk_revalidate_zone_args.nr_zones and struct zoned_disk_info.nr_zones are
unsigned int, so a disk advertising more than UINT_MAX zones (e.g.  2^32 +
1024 zones of one 512-byte logical block) gets its zone count truncated to
a small value, undersizing the array while the report walk keeps counting
upward.

Check the index against the array size before storing the zone condition,
and refuse to revalidate when the zone count does not fit 32 bits.

Fixes: 6e945ffb6555 ("block: use zone condition to determine conventional zones")
Signed-off-by: ZHOU Jiaxiang <me@fxti.xyz>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://patch.msgid.link/7815D1B293A8F55E+20260916135822.32584-2-me@fxti.xyz
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-zoned.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index ca30caec838e7..dd6bc679210c8 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -2048,12 +2048,17 @@ static int disk_revalidate_zone_resources(struct gendisk *disk,
 				struct blk_revalidate_zone_args *args)
 {
 	struct queue_limits *lim = &disk->queue->limits;
+	unsigned long long nr_zones;
 	unsigned int pool_size;
 	int ret = 0;
 
 	args->disk = disk;
-	args->nr_zones =
-		DIV_ROUND_UP_ULL(get_capacity(disk), lim->chunk_sectors);
+	nr_zones = DIV_ROUND_UP_ULL(get_capacity(disk), lim->chunk_sectors);
+	if (nr_zones > UINT_MAX) {
+		pr_warn("%s: Too many zones (%llu)\n", disk->disk_name, nr_zones);
+		return -EINVAL;
+	}
+	args->nr_zones = nr_zones;
 
 	/* Cached zone conditions: 1 byte per zone */
 	args->zones_cond = kzalloc(args->nr_zones, GFP_NOIO);
@@ -2161,6 +2166,12 @@ static int blk_revalidate_zone_cond(struct blk_zone *zone, unsigned int idx,
 {
 	enum blk_zone_cond cond = zone->cond;
 
+	if (idx >= args->nr_zones) {
+		pr_warn("%s: Zone report index %u exceeds zone count %u\n",
+			args->disk->disk_name, idx, args->nr_zones);
+		return -EINVAL;
+	}
+
 	/* Check that the zone condition is consistent with the zone type. */
 	switch (cond) {
 	case BLK_ZONE_COND_NOT_WP:
-- 
2.53.0



