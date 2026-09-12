Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5293241DDE3;
	Sat, 12 Sep 2026 08:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202449; cv=none; b=twf9N5uZ3ekJbDXP48L5bCr/e2/CVQy7wnL9RWn6FKnC+4esy95utry1tdVuUoPbHfambp3n63av8kxetSJ0XbnG7n34qm2xvh5eqbkKAg3H6yVRqwm36Zzeijha6jpe5rWCIuEZ4U1IXD69FCogQ7Vm7CTqqavL30eOylVIdPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202449; c=relaxed/simple;
	bh=XlpHF335lvDXUyVDJZ0BoUkxhM35kJhoDI6BjwRQTzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5nrWFe3bh3WvE9SmNU8r5YTmpKtSeO8luZrja/hCmHXPJYgEP353goMtlATHAQoQW7EK3aWd1TXO4fuGpYi/Oc23qAJ7MWAH+aALcqBqXGNC5ScA57/SVSoDt3nm8C8fCnUDxz95UTFft76COmFQMQNejWZGDE531HdxItwJqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mSuCpQzu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSuCpQzu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CE41F000FF;
	Sat, 12 Sep 2026 08:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202448;
	bh=y13eZQzseBiqfeTHMZkPueiyJn4EAFtpS9kKQWzybos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mSuCpQzu8PxhCpX7Akf7xFHukKJXarifZqy/RVfC/fAZ5yABKImK8zx6uhNvRLh/0
	 NHw2albZyxVALXTu2HsSA4WesGuTfEX+oRouOKLS3KRTqpCwnFgDpr04vROgmK1hFW
	 oov6+Kia70VJDtKGXvUXu5pMpn3E8UJzgqXer4J0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykola Marzhan <mykola@meshstor.io>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1188/1815] md/raid5: round bitmap stripes with sector division
Date: Sat, 12 Sep 2026 08:48:58 +0200
Message-ID: <20260912065716.900371523@linuxfoundation.org>
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
index 83531b4c1068c..d236a0d772d14 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5950,8 +5950,11 @@ static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
 
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
@@ -5969,8 +5972,10 @@ static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
 
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



