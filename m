Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216087;
	b=e9oGBatd2Xt7yqwGXpuGgBXCEuxtYhWeQir1WuFm5D1mN0m+navdkt5IDOB5ny5Z7gfm
	 PiN1hAIqOc9QdX8LvYdHuhVomtzzwH//mwvUpM7kD67v/qSIJuoyjil2NkG4N3wPEfqmS
	 KCBT7Lh/WeF+Y4hMHKjQBt1G9C6cnSrdjoOaGBIpZD8BoXbwoTXie8ZnD3oMWsyEJAdMM
	 fddgoMIbWzPzYsad7FsOUcign/2fIdtHvVRAOpSMMU52fEObsDITq+H6gJ6bBrQBvsBwH
	 mqWiuZdH6rLupDlbr13whUUAZBFMinw88GKQoYhq/4Snva/HehRZkBTQ5wZAz5sN+Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216087;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iAXHTBqjcYve51OuhvykMVLi9Yt+Xx9r7lcb/6+nk44=;
	b=Vl5c6BA1WDFsGQjAyu7uJfKy53nFR+sLJPH1Feij8aF3Nh5Mi81HzUIyW6K/UV8L/kjr
	 UAy2YJTtCB2GV+6fzps+A08RAAg+u/Ft/FJfmx0mxogpy8ujWkzh6S7H+QWjIKVrUQy+t
	 0zCI0ym7FMAwqs8hLyttvVzDnTgfoCOYXM1li8USnRr8oC6B1VLxZ1xJGgJbfbuAPil6B
	 HnxJrSQzXnruG2blYYXxEyDGbe92dY6y8tGOQa8czPIx4FHNXjPS625/KCOVCJUUJBeAE
	 YfASPsDRi+IJzj4Ps2cKoHAAtzlpsoBA8quiNc8pRFDT8oBW94dUkLfQliw30DYTglg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sc4m34dI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8504B606A31C;
	Wed, 28 Oct 2026 19:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sc4m34dI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9FBE1F01825;
	Wed, 28 Oct 2026 19:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216087;
	bh=iAXHTBqjcYve51OuhvykMVLi9Yt+Xx9r7lcb/6+nk44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sc4m34dI4rJjquSqlrnsrXqGLHnT7E9rWtctcem2IjPfxFUYFSrGnBAOs/KRTfrg4
	 pqFpbMG6K8GkLfhCdt5gniwuWjhI0hvVrAukVMZ7DQxnnGu6aCgKxsGQ05wi/ivEn8
	 cCbkTLxQquc+WPzmspuVt/NIfRxL4JmIUIgoBZq8=
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
Subject: [PATCH 6.1 1436/1887] zram: fix out-of-bounds access in writeback_store()
Date: Wed, 28 Oct 2026 17:58:52 +0100
Message-ID: <20261028170532.138022584@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zram/zram_drv.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 740ca88bb6733..b8a2cb2f901cf 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -644,7 +644,7 @@ static ssize_t writeback_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
-	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
+	unsigned long nr_pages;
 	unsigned long index = 0;
 	struct bio bio;
 	struct bio_vec bio_vec;
@@ -663,11 +663,9 @@ static ssize_t writeback_store(struct device *dev,
 		if (strncmp(buf, PAGE_WB_SIG, sizeof(PAGE_WB_SIG) - 1))
 			return -EINVAL;
 
-		if (kstrtol(buf + sizeof(PAGE_WB_SIG) - 1, 10, &index) ||
-				index >= nr_pages)
+		if (kstrtol(buf + sizeof(PAGE_WB_SIG) - 1, 10, &index))
 			return -EINVAL;
 
-		nr_pages = 1;
 		mode = PAGE_WRITEBACK;
 	}
 
@@ -682,6 +680,15 @@ static ssize_t writeback_store(struct device *dev,
 		goto release_init_lock;
 	}
 
+	nr_pages = zram->disksize >> PAGE_SHIFT;
+	if (mode == PAGE_WRITEBACK) {
+		if (index >= nr_pages) {
+			ret = -EINVAL;
+			goto release_init_lock;
+		}
+		nr_pages = 1;
+	}
+
 	page = alloc_page(GFP_KERNEL);
 	if (!page) {
 		ret = -ENOMEM;
-- 
2.53.0



