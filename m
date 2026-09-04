Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D94B415F12;
	Fri,  4 Sep 2026 05:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498754; cv=none; b=P+fIGKKvdPMrjhTPqBR3SwJihl4yT2Re3Iuru1khpOompQFmi+ugjR3qChLIl3iqB7ThnQurvgfwuGC5IPo33PAMst+iA5HDP1HNGy6FiLW61UHqmLUQVHHzznHBWvn60FRZKnZkIrORpCbdcs14Qc/PcmwTnMZVhlDEsjlww8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498754; c=relaxed/simple;
	bh=20MkiBGPX7k6QAvuaEJ5spuy7msi25Wno9rw7oeKltQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTuIxMAz2dLt8TxSrqylu1Eji5xtllE/yWOeqPdM5s1r7QorKBdpEpyEMIQKiLn4QpJX4HQNz1h1kGl1Dz3TvBY5SfLYuCT1/T7mRgfhi3O8JidfSpWV/GoGtY0yyPlKi9n+uZHKPQWeDQR+s4UK2uT5yF0ZlpS8UWqEukfVux8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kPoN5tPX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kPoN5tPX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E899D1F00A3D;
	Fri,  4 Sep 2026 05:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498753;
	bh=8Giol/f3JKy7fkHGzuL7kLcN3y+nZUIz5Uq2zgcLaHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kPoN5tPXHP+FIuK6NdIXC1OUXQw19j2oQD/kqb9kxxUeJZ2bOUB45Zi0TKzjG18+B
	 FX9Gf5HNJK18N0ffIYMUgzhAB5RVshv+jIPVng6OZN3ylAIJV7VeYKT+cJe6S8vG8t
	 6OF4PeGJCxAxD7VnfWzRxZcb9rtL00fC6VALg/e8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longlong Xia <xialonglong@kylinos.cn>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jens Axboe <axboe@kernel.dk>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 132/713] zram: fix out-of-bounds access in writeback_store()
Date: Fri,  4 Sep 2026 06:51:40 +0200
Message-ID: <20260904045806.791982417@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Longlong Xia <xialonglong@kylinos.cn>

commit 894913e2d35c46ff19a77530907771ae57862b96 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1244,8 +1244,8 @@ static ssize_t writeback_store(struct de
 			       const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
-	u64 nr_pages = zram->disksize >> PAGE_SHIFT;
-	unsigned long lo = 0, hi = nr_pages;
+	u64 nr_pages;
+	unsigned long lo = 0, hi;
 	struct zram_pp_ctl *pp_ctl = NULL;
 	struct zram_wb_ctl *wb_ctl = NULL;
 	char *args, *param, *val;
@@ -1259,6 +1259,9 @@ static ssize_t writeback_store(struct de
 	if (!zram->backing_dev)
 		return -ENODEV;
 
+	nr_pages = zram->disksize >> PAGE_SHIFT;
+	hi = nr_pages;
+
 	pp_ctl = init_pp_ctl();
 	if (!pp_ctl)
 		return -ENOMEM;


