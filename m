Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8153AFAE2;
	Wed, 30 Sep 2026 19:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795064; cv=none; b=Rg1hYtrBaDSjjYui9fC7babZU3jP43Y246sjYfhpOk9ndhW6xTRqNapxj+rtC0BipqUIEepULzuoSzywkus5ABAA+IZBZK/AcEAtdlalRJH/lC6dgsnWAhIy81+5/6MuLXHaqQRlhyf0mr/SP8BSyBASyaeJenDfV39Tk6MnG9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795064; c=relaxed/simple;
	bh=evrHZz17gCwhbXVRHKelte74akEE0dcGmMzwLwErWsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hxxd4Z4IGYp/na7/LffoXC9H4sBo1CezHLJEFgb83hqdzdq9mf82KlKqDmU5jn7aiKqKRk/zXZsJzs9eHKnXCdwX8dNohYrAXCoUkwcODzt+PWgsStEJ3S9DgV7n5DnB8eCoSloEu4K1IcV/tv1EOyUQC+Sk/Izz/8FSyu2D+rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rZ9K5g7Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rZ9K5g7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E1B1F00898;
	Wed, 30 Sep 2026 19:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795062;
	bh=0pkEpf5bCYO8VKJ2TpRMu7RSBuys74ZE5NzhsMv6xgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rZ9K5g7ZEBthMWFdZQ1VK6JxnRmZES+YV7UHl+REaPzvJdQluK9y9p1BfJoUFx0Ib
	 r9xaDI2is42Gw659rOz21KOwLEqlEz8WLCTnIWQfLJdIBe4uUuNYBeIxiItGhxCcr6
	 t/nKlJ2EQAQhhGcf1w+G+eBl9JmwbdHEzJ5bSxnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Nam Cao <namcao@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0431/1193] staging: fbtft: make dirty_lock IRQ-safe
Date: Wed, 30 Sep 2026 17:18:35 +0200
Message-ID: <20260930152443.769851650@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5dfe2d7a73e37..e714a3369b9a2 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -302,6 +302,7 @@ static void fbtft_mkdirty(struct fb_info *info, int y, int height)
 {
 	struct fbtft_par *par = info->par;
 	struct fb_deferred_io *fbdefio = info->fbdefio;
+	unsigned long flags;
 
 	/* special case, needed ? */
 	if (y == -1) {
@@ -310,12 +311,12 @@ static void fbtft_mkdirty(struct fb_info *info, int y, int height)
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
@@ -329,13 +330,13 @@ static void fbtft_deferred_io(struct fb_info *info, struct list_head *pagereflis
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



