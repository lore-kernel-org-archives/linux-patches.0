Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615CE4AD4D4;
	Thu, 17 Sep 2026 18:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671554; cv=none; b=sICyLaO7kXkdNihF12OygjbNOIbwNaU+LsgF6DM3f1St5sHTJK3eKu6gB1nUTUJ14GzhxK2gcQaXxaZ5tFaRGsWq0GYwv5V/FWyzbr6imoF88XkyTu/xu6/DlAXpZNJq0ndAxP4q8S09wlhL+bhgCG7G8e0y9XSJV43MmmiJqPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671554; c=relaxed/simple;
	bh=jxhc842B6COhw2arIOdr6xEbobzQNhdCrbQaHefDxZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFN7sunBU/0nTJ46kLTvsyHHrWM18S8xUUh9BS/itMz17p757+dCTOx2IjSQ3Ij41/032+3rmXlEsMuhTYQUrjTir8Rax39mVHGt6mQbHFTgN573fYgwg2nAlBoS1m8BkJSe04/QhCtuju7dMx+P/lqAoDU4lCE2DUz8QepGUW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cyq4+Tvl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cyq4+Tvl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD2B1F000FF;
	Thu, 17 Sep 2026 18:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671552;
	bh=paY3QxWJosME4tONtf54PtxqB8rd/QGbmaP92njw5K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cyq4+TvlpWIP5NBT8KOJQxUEF1xjLzBvHaieFCDp5oE34iG2jHPqkqP6CeDCOMHMW
	 Bt5pmNlGiD8leDvDKJJHdTxzmbS9gNPKJj2v+D5/g0ae1I2BSQCBgFNH6sMKn5vkNH
	 3MmV9Ev6Zot9TZyY4ZsoTWZnhFtAmlq1bZhz00Hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longlong Xia <xialonglong@kylinos.cn>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jens Axboe <axboe@kernel.dk>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1015/1102] zram: fix out-of-bounds access in writeback_store()
Date: Thu, 17 Sep 2026 16:15:58 +0100
Message-ID: <20260917151606.234835907@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Longlong Xia <xialonglong@kylinos.cn>

[ Upstream commit 894913e2d35c46ff19a77530907771ae57862b96 ]

Patch series "zram: fix stale scan bounds after reinitialization".

Both writeback_store() and read_block_state() derive their table scan
bounds from zram->disksize before acquiring dev_lock.  If the device is
reset and reinitialized with a smaller disksize between that read and lock
acquisition, the bound can describe the old table while the scan operates
on the new one.  This can lead to out-of-bounds slot accesses.

Move both bound calculations under dev_lock so each bound remains
consistent with the table throughout its scan.  Keep the fixes separate
because the affected interfaces originate from different commits and can
be backported independently.

This patch (of 2):

writeback_store() calculates the table scan bounds before taking dev_lock.
A reset followed by reconfiguration with a smaller disksize can therefore
replace zram->table while writeback_store() is waiting for the lock.  Once
it acquires the lock, it sees an initialized device but scans the new
table using the old upper bound, resulting in an out-of-bounds access.

Calculate the number of pages while holding dev_lock so the scan bound
matches the table protected by the lock.

Link: https://lore.kernel.org/20260804065919.3970386-1-xialonglong2025@163.com
Link: https://lore.kernel.org/20260804065919.3970386-2-xialonglong2025@163.com
Fixes: a939888ec38b ("zram: support idle/huge page writeback")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ adapted the fix to legacy init_lock locking and single-page bounds validation. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -599,7 +599,7 @@ static ssize_t writeback_store(struct de
 		struct device_attribute *attr, const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
-	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
+	unsigned long nr_pages;
 	unsigned long index = 0;
 	struct bio bio;
 	struct bio_vec bio_vec;
@@ -620,11 +620,9 @@ static ssize_t writeback_store(struct de
 		if (strncmp(buf, PAGE_WB_SIG, sizeof(PAGE_WB_SIG) - 1))
 			return -EINVAL;
 
-		if (kstrtol(buf + sizeof(PAGE_WB_SIG) - 1, 10, &index) ||
-				index >= nr_pages)
+		if (kstrtol(buf + sizeof(PAGE_WB_SIG) - 1, 10, &index))
 			return -EINVAL;
 
-		nr_pages = 1;
 		mode = PAGE_WRITEBACK;
 	}
 
@@ -634,6 +632,15 @@ static ssize_t writeback_store(struct de
 		goto release_init_lock;
 	}
 
+	nr_pages = zram->disksize >> PAGE_SHIFT;
+	if (mode == PAGE_WRITEBACK) {
+		if (index >= nr_pages) {
+			up_read(&zram->init_lock);
+			return -EINVAL;
+		}
+		nr_pages = 1;
+	}
+
 	/* Do not permit concurrent post-processing actions. */
 	if (atomic_xchg(&zram->pp_in_progress, 1)) {
 		up_read(&zram->init_lock);


