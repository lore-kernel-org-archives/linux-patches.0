Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4034F468C10;
	Sat, 12 Sep 2026 10:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210137; cv=none; b=YV+thCnQJN57WeVbtfTQiMyYDEVsp+0z/a7eTQS9VsmkfP+beVlQ2IasudRrrk6Z33UeW02d8NF4oXiQgg35eRBgUeM7Ex4rk58e0BJw8fEBjZeDQLUSyVAmf0OqdA0h4ys0FUSfLfGt76PFpuOT6vxN53SmZHn9vVWxDXPIzdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210137; c=relaxed/simple;
	bh=GpY6RWCQ8Q+LlbYSG9Ar2ixKBzk5CsW1m9CVnBk/RO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PfWctvhm/Fs4Pw+oDvbiM/lnvPkLsAe9y7A42nCw1kxjLNZk/CgHHugIZGffNOMl9EAXqZKmE1fxvYsmEqCMAwAA9yGO3qKgx7P78+OlOCCfqvp1UY6jRi4/hUYNU85Re0bmkqQBG8oeEnrAHgZfJOFNHqTfQ+TjKFbCqtbMpRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j3a0Rw2i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3a0Rw2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B941F000FF;
	Sat, 12 Sep 2026 10:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210133;
	bh=R1Y4SaiJgHUNSMm+6LK04SqFDYTYH05ImfJo/Qd4tLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j3a0Rw2imZEcYsiScOPKHeD0BVLGKXhUoWXL9dabdfR2GEOozNHZgG9PscqdLVaHK
	 7hfJoVjS6vGaCJbtiMXpDoMzzwbz9Aicaofoa8MQJerdG5doa3Kf7KNQ2tMVJSEvsN
	 IgYA4+JFeW+2SkYzGs+H05W7MXad/hQDutbmoMUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykola Marzhan <mykola@meshstor.io>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0962/1518] md/raid5: round bitmap stripes with sector division
Date: Sat, 12 Sep 2026 08:52:11 +0200
Message-ID: <20260912065645.222932341@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai@fygo.io>

[ Upstream commit 17ea021ae74987d6064c8195c4922fa025753892 ]

raid5_bitmap_sector_map() aligns the array range to full RAID5 stripe
widths before converting it to component sectors. That width is
chunk_sectors multiplied by the number of data disks, and it is not
always a power of two.

Reproduce with a 4-disk RAID5, 1024-sector chunks, and three data disks.
The full-stripe width is 3072 sectors. For a one-sector write at array
sector 3072, correct rounding gives array range [3072, 6144), which maps
to component range [1024, 2048). The old round_down()/round_up() logic
instead gives [1024, 4096), which maps to [0, 1024).

Use sector_div() based arithmetic so the rounded range is aligned to the
actual RAID5 stripe width.

The deterministic mapper test now reports the fixed component range as
[1024, 2048), while the old mask-based range was [0, 1024).

Fixes: 9c89f604476c ("md/raid5: implement pers->bitmap_sector()")
Reported-by: Mykola Marzhan <mykola@meshstor.io>
Link: https://lore.kernel.org/all/20260726185916.2223460-1-mykola@meshstor.io/
Tested-by: Mykola Marzhan <mykola@meshstor.io>
Link: https://patch.msgid.link/20260802195038.164272-6-yukuai@kernel.org
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0a0e241e3979b..8ff8cce3da7bf 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5922,8 +5922,11 @@ static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
 
 	sectors_per_chunk = conf->chunk_sectors *
 		(conf->raid_disks - conf->max_degraded);
-	start = round_down(start, sectors_per_chunk);
-	end = round_up(end, sectors_per_chunk);
+	sector_div(start, sectors_per_chunk);
+	start *= sectors_per_chunk;
+	if (sector_div(end, sectors_per_chunk))
+		end++;
+	end *= sectors_per_chunk;
 
 	start = raid5_compute_sector(conf, start, 0, &dd_idx, NULL);
 	end = raid5_compute_sector(conf, end, 0, &dd_idx, NULL);
@@ -5941,8 +5944,10 @@ static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
 
 	sectors_per_chunk = conf->prev_chunk_sectors *
 		(conf->previous_raid_disks - conf->max_degraded);
-	prev_start = round_down(prev_start, sectors_per_chunk);
-	prev_end = round_down(prev_end, sectors_per_chunk);
+	sector_div(prev_start, sectors_per_chunk);
+	prev_start *= sectors_per_chunk;
+	sector_div(prev_end, sectors_per_chunk);
+	prev_end *= sectors_per_chunk;
 
 	prev_start = raid5_compute_sector(conf, prev_start, 1, &dd_idx, NULL);
 	prev_end = raid5_compute_sector(conf, prev_end, 1, &dd_idx, NULL);
-- 
2.53.0



