Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68841DE3B8;
	Mon,  6 Jan 2025 15:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178373; cv=none; b=DcrVcKPbNwl71jkgIIMLji+I2OvCrW/18ZQIoYaqtJ0dx/hgcsVu4qE3jR+je23+JlyyduvzZ20jJhpV20+0pnYlYCKM2ibtD+ugO+Hz1nwE/HCpomlhw57nZpG5fs6qmZwXCi0HRgKqGb71cEI4hlUMeHMJfGGXaMxyxDNLgAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178373; c=relaxed/simple;
	bh=vhVHcLj8WtXRL/hb8aJBMVn16c8lf95lvDJbuaiuNRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bLtGl3znYQSyYcaZoGqhpokACwWZx+xdhC4gsh3ICEBAXyowN0Op9toOwZnvadrXrjkS27PzVFFrpoKFeM4gF21/8hSg3KEdVTZ+/JP4DdVr6CVnkZrZolWXIEg51bxx+XpXhmpplRx6K5xVtBZfnQjnMWbGoATTGsCQ8j621K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DTDaEmnk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DTDaEmnk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44AB6C4CED6;
	Mon,  6 Jan 2025 15:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178373;
	bh=vhVHcLj8WtXRL/hb8aJBMVn16c8lf95lvDJbuaiuNRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DTDaEmnkBhy2YyCxC9+IKSDsuWG62VMpQ25ilg4Y4cRhO0vp23a3wyCR8WwZzAL08
	 uYKR1iQ/6HFCme9dUrf1+EPsdEg3H7tRjHp07m+5jXGsQ2NnjVMjnpPjN+K6e4er7m
	 JXJGD5Jkqw6jOMVCxwrHOFJEx4V7IqbEGIQSO2v0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/138] drivers/block/zram/zram_drv.c: do not keep dangling zcomp pointer after zram reset
Date: Mon,  6 Jan 2025 16:17:01 +0100
Message-ID: <20250106151136.903449593@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit 6d2453c3dbc5f70eafc1c866289a90a1fc57ce18 ]

We do all reset operations under write lock, so we don't need to save
->disksize and ->comp to stack variables.  Another thing is that ->comp is
freed during zram reset, but comp pointer is not NULL-ed, so zram keeps
the freed pointer value.

Link: https://lkml.kernel.org/r/20220824035100.971816-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 74363ec674cb ("zram: fix uninitialized ZRAM not releasing backing device")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zram/zram_drv.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 8f38e5a1a63f..8e13586be8c9 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1690,9 +1690,6 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
 
 static void zram_reset_device(struct zram *zram)
 {
-	struct zcomp *comp;
-	u64 disksize;
-
 	down_write(&zram->init_lock);
 
 	zram->limit_pages = 0;
@@ -1702,18 +1699,16 @@ static void zram_reset_device(struct zram *zram)
 		return;
 	}
 
-	comp = zram->comp;
-	disksize = zram->disksize;
-	zram->disksize = 0;
-
 	set_capacity_and_notify(zram->disk, 0);
 	part_stat_set_all(&zram->disk->part0, 0);
 
 	up_write(&zram->init_lock);
 	/* I/O operation under all of CPU are done so let's free */
-	zram_meta_free(zram, disksize);
+	zram_meta_free(zram, zram->disksize);
+	zram->disksize = 0;
 	memset(&zram->stats, 0, sizeof(zram->stats));
-	zcomp_destroy(comp);
+	zcomp_destroy(zram->comp);
+	zram->comp = NULL;
 	reset_bdev(zram);
 }
 
-- 
2.39.5



