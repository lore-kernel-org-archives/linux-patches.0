Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9D94E73A1;
	Thu, 17 Sep 2026 15:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659136; cv=none; b=Sv2HLTYqWPspuOPzNtX3n7/Jz2uWsApe05WZrw7VBkEedPlqGyxRIRx4Z3/03jKU87ZtYCr7DQ7SEITXDbhg5+SOsZ22CMDKEsrlVVpmNrhY9t9y7Mc+2CuIhJIMSdH1TBinETbGTh64jGO8RupnbV5XZ30QlXvp0TDAKzCUDn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659136; c=relaxed/simple;
	bh=FEACG1IPFlfPPoA9Esbw8p7Q76QCPzJz9QAopjlSwEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BY01jvxj2Gb6oot6qPmyO1+fsge2Z2tmDe7zdAR9LDOZKg2eHP6MUf8XnK2rn0OtAkjfeeOyeJaYFQyv/WtZrUatyJVzgmJRqOFeoKgPMxbSqhFJATWW7N8ukPHF+K67Kkls8nxUV5H4DYO5s/iuy+e9hjmBoa2oCGUhsHlrA+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TKXLYk5R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TKXLYk5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FACA1F00898;
	Thu, 17 Sep 2026 15:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659123;
	bh=Iv5Etim3MyYuLlHlcvpPTs/B/sX0+ElGDSHAwhPdTLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TKXLYk5RLOrptEO7dghqmGd/7o+XgJzEPbyyvAgytRsO3H6HJg68We/ND427YDuVk
	 7sNHqdECR8mCIeqBp8XyJyCg0jY64Kw9QFSeGu02B6RID+M9I5M7+53Lh63NoMgiO/
	 uwxm7fHSSnTTsk/wJmHWrR8PKncix6sWgwHX2bI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Nam Cao <namcao@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 150/733] staging: fbtft: make dirty_lock IRQ-safe
Date: Thu, 17 Sep 2026 16:07:38 +0100
Message-ID: <20260917151354.794206303@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
index ca0c38221c16b..7925d974de801 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -298,14 +298,15 @@ static void fbtft_mkdirty(struct fb_info *info, int y, int height)
 {
 	struct fbtft_par *par = info->par;
 	struct fb_deferred_io *fbdefio = info->fbdefio;
+	unsigned long flags;
 
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
@@ -318,13 +319,13 @@ static void fbtft_deferred_io(struct fb_info *info, struct list_head *pagereflis
 	struct fb_deferred_io_pageref *pageref;
 	unsigned int y_low = 0, y_high = 0;
 
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



