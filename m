Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03A837A825;
	Wed, 30 Sep 2026 18:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791339; cv=none; b=erBxYYCRVIYbEQG/h+cGS2AUrCimV63WYZPq3RCliThdJjcsDdhbPryWJ1wtUDoZN0sWDGX0BxADX/Bb/A7r52A1q3KFAz4lQxnmqkMAj6b5swjPxtTtxwZeVK4h8Z+lyMfJXJaQyl21Vdukz8ceOJjAT2nuIALHKsBQK+mwg7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791339; c=relaxed/simple;
	bh=iHwWiZdOm32OQveBT8UdPzKtV/pLqQadxT2h0wFaUEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQXSi5qibCBtOMl7UjrchZWalFq2L5aJYQbyBtadbNAxksN1TYRcT5d86MCblbFIP7+4zNHV9YP9g1jhuRCkZh9j8elmTVRInoF3kuYsQsUgzqTPkkb4bPxkIkcRSsjprdvT4/9Kusv8rht8hkJX5D4mxHmksgXFBAmm2WaHLmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k6dRe4Kk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k6dRe4Kk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577E51F000FF;
	Wed, 30 Sep 2026 18:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791337;
	bh=RFwy+I9utRx8t7Jknv8f1ApUXdK/HMAf4+x2AHQzN70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k6dRe4KkdjvHD4wa7srtN1qK6qUrcufUxDP13dBW6OUU3WityZCeQTvm30N0VsiFx
	 Ws6IBE4MwUOIGws7C8K9dRK+b+Tf1g7qS9Thrqw7H/DdXp2sIf/ywm7SEIyqw4j0TO
	 5gpuiZglGItl9pr1DdCQREhAVrEqaDMCKdHWFti0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Nam Cao <namcao@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 265/752] staging: fbtft: make dirty_lock IRQ-safe
Date: Wed, 30 Sep 2026 17:22:15 +0200
Message-ID: <20260930152404.015012477@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Su <sh_def@163.com>

[ Upstream commit f576944a59f31bcffff121117ebf452c5dd162b7 ]

fbtft_mkdirty() can be reached from the fbcon rendering path while
processing printk() in hardirq context. Meanwhile, dirty_lock is also
taken by fbtft_deferred_io() in workqueue context with local interrupts
enabled.

Lockdep reports a possible IRQ lock inversion involving dirty_lock and
console_owner. A hardirq can interrupt a CPU holding dirty_lock and
enter the console rendering path, which can attempt to acquire
dirty_lock again.

The following lockdep report was observed on an RK3566 system with
CONFIG_PROVE_LOCKING enabled:

  WARNING: possible irq lock inversion dependency detected
  swapper/2/0 just changed the state of lock:
  (console_owner){-...}-{0:0}
  but this lock took another, HARDIRQ-unsafe lock in the past:
  (&par->dirty_lock){+.+.}-{2:2}

  CPU0                    CPU1
  ----                    ----
  lock(&par->dirty_lock);
                         local_irq_disable();
                         lock(console_owner);
                         lock(&par->dirty_lock);
  <Interrupt>
    lock(console_owner);

  *** DEADLOCK ***

Use spin_lock_irqsave() for fbtft_mkdirty() and spin_lock_irq() for
fbtft_deferred_io(). They only access the dirty line range, so the
IRQ-off regions remain short.

Fixes: c296d5f9957c ("staging: fbtft: core support")
Signed-off-by: Hui Su <sh_def@163.com>
Link: https://lore.kernel.org/lkml/20260804173712.176017-1-sh_def@163.com/
Reviewed-by: Nam Cao <namcao@linutronix.de>
Link: https://patch.msgid.link/20260807150953.2811933-3-sh_def@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/fbtft/fbtft-core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/fbtft/fbtft-core.c b/drivers/staging/fbtft/fbtft-core.c
index 67604a4d9a39f..8d7d135835ed4 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -303,6 +303,7 @@ static void fbtft_mkdirty(struct fb_info *info, int y, int height)
 {
 	struct fbtft_par *par = info->par;
 	struct fb_deferred_io *fbdefio = info->fbdefio;
+	unsigned long flags;
 
 	/* special case, needed ? */
 	if (y == -1) {
@@ -311,12 +312,12 @@ static void fbtft_mkdirty(struct fb_info *info, int y, int height)
 	}
 
 	/* Mark display lines/area as dirty */
-	spin_lock(&par->dirty_lock);
+	spin_lock_irqsave(&par->dirty_lock, flags);
 	if (y < par->dirty_lines_start)
 		par->dirty_lines_start = y;
 	if (y + height - 1 > par->dirty_lines_end)
 		par->dirty_lines_end = y + height - 1;
-	spin_unlock(&par->dirty_lock);
+	spin_unlock_irqrestore(&par->dirty_lock, flags);
 
 	/* Schedule deferred_io to update display (no-op if already on queue)*/
 	schedule_delayed_work(&info->deferred_work, fbdefio->delay);
@@ -331,13 +332,13 @@ static void fbtft_deferred_io(struct fb_info *info, struct list_head *pagereflis
 	unsigned int y_low = 0, y_high = 0;
 	int count = 0;
 
-	spin_lock(&par->dirty_lock);
+	spin_lock_irq(&par->dirty_lock);
 	dirty_lines_start = par->dirty_lines_start;
 	dirty_lines_end = par->dirty_lines_end;
 	/* set display line markers as clean */
 	par->dirty_lines_start = par->info->var.yres - 1;
 	par->dirty_lines_end = 0;
-	spin_unlock(&par->dirty_lock);
+	spin_unlock_irq(&par->dirty_lock);
 
 	/* Mark display lines as dirty */
 	list_for_each_entry(pageref, pagereflist, list) {
-- 
2.53.0



