Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847B0266573;
	Tue,  8 Apr 2025 11:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110695; cv=none; b=Mo1VN1fccDp3YEVsXF6Vz2MTmO9u7OlkTdSP2RwZFmdolNz+LOGJGIID7xI2LugMNCxeYC2pHBxnP7mf7RdxQ1mkUGYZ+p9rTdbT0w0ajwq2yONerYnNVndJosRUVFH/2JQoK4AjqeA19MNj5ROTiyU1RJj3Uz21WK6Hbb1eI6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110695; c=relaxed/simple;
	bh=/cgs2zfrl1XMx66RZYWQE0OqwIX5d7TtcKwaZpPoIHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MB65DnlfbkLNTzJYmaZ+kre1hhHHT5tFvsR3fKlS3hs6meItJeDqSE6s63h5akXi19s7gDwEhQWNU7aJbI2OBoyXZZe7N6Wowximy/gMLfHLFuP0c1eGbCHJ/m0LlVvWW/E88+WzOnoZGFd9rBNYDPGHgtU/Fmiy+1LFAoJXyaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DOxjZPJ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DOxjZPJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13440C4CEE5;
	Tue,  8 Apr 2025 11:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110695;
	bh=/cgs2zfrl1XMx66RZYWQE0OqwIX5d7TtcKwaZpPoIHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DOxjZPJ/kbnOe9kK4SG89N7V70RFbUgMUfW1/uixyi0gxCt6NYcdEnSOFhIuwIsmC
	 a7/FdCpe0tvSoQvojQeC6eVYCvtB5mV9S4CiNhBA/Z9iq+g8d2CAc3klp9BhQxkPLw
	 4W71zPxQJvIHVwckco6mdDzFH7mQC9IhTXEpPrls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 158/731] null_blk: introduce badblocks_once parameter
Date: Tue,  8 Apr 2025 12:40:55 +0200
Message-ID: <20250408104917.950898953@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

[ Upstream commit 800c24391676143695d284f70af297b28a809886 ]

When IO errors happen on real storage devices, the IOs repeated to the
same target range can success by virtue of recovery features by devices,
such as reserved block assignment. To simulate such IO errors and
recoveries, introduce the new parameter badblocks_once parameter. When
this parameter is set to 1, the specified badblocks are cleared after
the first IO error, so that the next IO to the blocks succeed.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://lore.kernel.org/r/20250226100613.1622564-3-shinichiro.kawasaki@wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: d301f164c3fb ("badblocks: use sector_t instead of int to avoid truncation of badblocks length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c     | 11 ++++++++---
 drivers/block/null_blk/null_blk.h |  1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 18520d0e38c61..164c62f20f109 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -473,6 +473,7 @@ NULLB_DEVICE_ATTR(shared_tags, bool, NULL);
 NULLB_DEVICE_ATTR(shared_tag_bitmap, bool, NULL);
 NULLB_DEVICE_ATTR(fua, bool, NULL);
 NULLB_DEVICE_ATTR(rotational, bool, NULL);
+NULLB_DEVICE_ATTR(badblocks_once, bool, NULL);
 
 static ssize_t nullb_device_power_show(struct config_item *item, char *page)
 {
@@ -593,6 +594,7 @@ CONFIGFS_ATTR_WO(nullb_device_, zone_offline);
 
 static struct configfs_attribute *nullb_device_attrs[] = {
 	&nullb_device_attr_badblocks,
+	&nullb_device_attr_badblocks_once,
 	&nullb_device_attr_blocking,
 	&nullb_device_attr_blocksize,
 	&nullb_device_attr_cache_size,
@@ -1315,10 +1317,13 @@ static inline blk_status_t null_handle_badblocks(struct nullb_cmd *cmd,
 	sector_t first_bad;
 	int bad_sectors;
 
-	if (badblocks_check(bb, sector, nr_sectors, &first_bad, &bad_sectors))
-		return BLK_STS_IOERR;
+	if (!badblocks_check(bb, sector, nr_sectors, &first_bad, &bad_sectors))
+		return BLK_STS_OK;
 
-	return BLK_STS_OK;
+	if (cmd->nq->dev->badblocks_once)
+		badblocks_clear(bb, first_bad, bad_sectors);
+
+	return BLK_STS_IOERR;
 }
 
 static inline blk_status_t null_handle_memory_backed(struct nullb_cmd *cmd,
diff --git a/drivers/block/null_blk/null_blk.h b/drivers/block/null_blk/null_blk.h
index 6f9fe61710870..3c4c07f0418b0 100644
--- a/drivers/block/null_blk/null_blk.h
+++ b/drivers/block/null_blk/null_blk.h
@@ -63,6 +63,7 @@ struct nullb_device {
 	unsigned long flags; /* device flags */
 	unsigned int curr_cache;
 	struct badblocks badblocks;
+	bool badblocks_once;
 
 	unsigned int nr_zones;
 	unsigned int nr_zones_imp_open;
-- 
2.39.5



