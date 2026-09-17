Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDF03B14CC;
	Thu, 17 Sep 2026 18:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668920; cv=none; b=HMLhjrr6oMbw1gow2dyjuThczEttphdwwmeFQlgrL+gMI9uagdDwNnB6P0G8UjaD/b9IJmZcRALt3g0y5IFzgmsJIBZ6rnAE6e/A28eMWmrGb/g3QSyXhE3qYQVmHD6L1mNGTRncGCg8LVX4Cs6qN124lFc2YpqtUGEA2L1zaTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668920; c=relaxed/simple;
	bh=YRjc3h6KW1lFVoxuKwUzGZn4Dqhg21N0LS3BHhjmFJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VifrGxuvFov4Kb1gbSjrH1bwBxUKw3imCD3lq8LFh9aQrWy+2Ga3WjksHLKfrapcE0siFAsCBrj+wDL3d4xXUDbT8nTUQnmSC6PkNadOY4tAtX6Ob3MTrdlc4HQugrrKV6VhQ5auFRMbst1HBtib3bI0hR2RMLkd/+sHImastcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lv3lG2Fb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lv3lG2Fb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82DDF1F000FF;
	Thu, 17 Sep 2026 18:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668919;
	bh=6F9LXXBFR4iTgxqrcHREpuVq4vChnfrNfFw8KEIn55U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lv3lG2Fb211SVfQ1i/VXKGKeJSn9+ZzrjBDmW8RGEjtxF2A+9UvrwtBH84EJ5cWhy
	 zqOqcoiBPDIlmBqOh1mUAGZAoxrFHWJBroDXrU8KZjqea2sX+VNAs7icJs556wAJNL
	 dYUwk7LL/hql6oYfI7MR1Z568xvyWHPsRHhMdyUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Nam Cao <namcao@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0583/1102] staging: fbtft: make dirty_lock IRQ-safe
Date: Thu, 17 Sep 2026 16:08:46 +0100
Message-ID: <20260917151554.588886445@linuxfoundation.org>
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
index 69649c0ef8739..088c31d3b02f2 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -299,6 +299,7 @@ static void fbtft_mkdirty(struct fb_info *info, int y, int height)
 {
 	struct fbtft_par *par = info->par;
 	struct fb_deferred_io *fbdefio = info->fbdefio;
+	unsigned long flags;
 
 	/* special case, needed ? */
 	if (y == -1) {
@@ -307,12 +308,12 @@ static void fbtft_mkdirty(struct fb_info *info, int y, int height)
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
@@ -325,13 +326,13 @@ static void fbtft_deferred_io(struct fb_info *info, struct list_head *pagereflis
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



