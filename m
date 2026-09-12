Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0273806DD;
	Sat, 12 Sep 2026 12:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217518; cv=none; b=Qp0qEwKF98/pR0nCva70Rf5xu7P1266sp5ARYBwFrT71DX9FSco3oXFVxRdD05jncjtfd4jwT27O7VVXO62Lyw3Jg+XuYeRHqk/u8D3TdR+D5NiQ1l5RwOupNlOkSHomo8WlokK8nsd/LW8Uz4RuMwzTfnbvy3ZHntFzGyPRzOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217518; c=relaxed/simple;
	bh=AIiUnVUbcYhE88bvCHxrY6jKj7ZtLX5T6XhFSmjOxTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S28+7IZoSQsTwUVlXNAX6cFsfno2AlyD9epwVeugoaQbrlcorvuygkEQtefakleuTE9U3ROqo2F/79Nwkjvfqw0H0ssQ5QvsqP82WvfXH9ZvGUbcbWbmUtMc0S5xKA13YuJ7ot6rnZLsXnGBiDumnikwv0U1RtYg90bCJ7UqTXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DN3VAADm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DN3VAADm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8761F000FF;
	Sat, 12 Sep 2026 12:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217512;
	bh=/e/aqjLM5m7bdSsyIQ7FSb4sdjVPXoiVxwjbaTaZhDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DN3VAADmkSDro00beg1B5nk3qZVU1t/qoxbEKID8o5tN/AJYdQ2xTTEe0NDgqpPuM
	 I5+bpwcsiMTGHM9NqCmyCoXLSlpmWBo1TtazbrMvQGxE6260NaPDXgAgK6VJZ6HDBj
	 Hb5bsXNkwqjGLKK7H/eSyBLSP+A53Q4upj8mZejs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykola Marzhan <mykola@meshstor.io>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0955/1376] md/raid5: round bitmap stripes with sector division
Date: Sat, 12 Sep 2026 08:56:21 +0200
Message-ID: <20260912065628.845665145@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ef1a1a8507792..bdd620d89c672 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5918,8 +5918,11 @@ static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
 
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
@@ -5937,8 +5940,10 @@ static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
 
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



