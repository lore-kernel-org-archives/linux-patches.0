Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CF92590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35BBAC433D2;
	Sun, 22 Jan 2023 15:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400888;
	bh=oZuBzO6ZT434qBqCT7tN8/CmV+R8TK0qntjD5ogcrXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0IVz9r7CHEgKU3hJ4MDMkwSOO62NhsQk8NfM9dhJJKRKGSlBz9uaud+ZgxBUoMn9Q
	 Ij6uTVXNnGtNQ2Y72VBxrx4uszdArDPQAx6qn9Epy+o/CsZ9PinCIwNnYRzSLllJJ9
	 2OItYXtRXtro8T0Oll9BLSeMDZfIJkwinq2sGrYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/193] fbdev: omapfb: avoid stack overflow warning
Date: Sun, 22 Jan 2023 16:02:38 +0100
Message-Id: <20230122150247.728975360@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 634cf6ead93988b0da9ac054521ab63a3ba189db ]

The dsi_irq_stats structure is a little too big to fit on the
stack of a 32-bit task, depending on the specific gcc options:

fbdev/omap2/omapfb/dss/dsi.c: In function 'dsi_dump_dsidev_irqs':
fbdev/omap2/omapfb/dss/dsi.c:1621:1: error: the frame size of 1064 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

Since this is only a debugfs file, performance is not critical,
so just dynamically allocate it, and print an error message
in there in place of a failure code when the allocation fails.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/omap2/omapfb/dss/dsi.c | 28 ++++++++++++++--------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/video/fbdev/omap2/omapfb/dss/dsi.c b/drivers/video/fbdev/omap2/omapfb/dss/dsi.c
index 54b0f034c2ed..7cddb7b8ae34 100644
--- a/drivers/video/fbdev/omap2/omapfb/dss/dsi.c
+++ b/drivers/video/fbdev/omap2/omapfb/dss/dsi.c
@@ -1536,22 +1536,28 @@ static void dsi_dump_dsidev_irqs(struct platform_device *dsidev,
 {
 	struct dsi_data *dsi = dsi_get_dsidrv_data(dsidev);
 	unsigned long flags;
-	struct dsi_irq_stats stats;
+	struct dsi_irq_stats *stats;
+
+	stats = kzalloc(sizeof(*stats), GFP_KERNEL);
+	if (!stats) {
+		seq_printf(s, "out of memory\n");
+		return;
+	}
 
 	spin_lock_irqsave(&dsi->irq_stats_lock, flags);
 
-	stats = dsi->irq_stats;
+	*stats = dsi->irq_stats;
 	memset(&dsi->irq_stats, 0, sizeof(dsi->irq_stats));
 	dsi->irq_stats.last_reset = jiffies;
 
 	spin_unlock_irqrestore(&dsi->irq_stats_lock, flags);
 
 	seq_printf(s, "period %u ms\n",
-			jiffies_to_msecs(jiffies - stats.last_reset));
+			jiffies_to_msecs(jiffies - stats->last_reset));
 
-	seq_printf(s, "irqs %d\n", stats.irq_count);
+	seq_printf(s, "irqs %d\n", stats->irq_count);
 #define PIS(x) \
-	seq_printf(s, "%-20s %10d\n", #x, stats.dsi_irqs[ffs(DSI_IRQ_##x)-1])
+	seq_printf(s, "%-20s %10d\n", #x, stats->dsi_irqs[ffs(DSI_IRQ_##x)-1])
 
 	seq_printf(s, "-- DSI%d interrupts --\n", dsi->module_id + 1);
 	PIS(VC0);
@@ -1575,10 +1581,10 @@ static void dsi_dump_dsidev_irqs(struct platform_device *dsidev,
 
 #define PIS(x) \
 	seq_printf(s, "%-20s %10d %10d %10d %10d\n", #x, \
-			stats.vc_irqs[0][ffs(DSI_VC_IRQ_##x)-1], \
-			stats.vc_irqs[1][ffs(DSI_VC_IRQ_##x)-1], \
-			stats.vc_irqs[2][ffs(DSI_VC_IRQ_##x)-1], \
-			stats.vc_irqs[3][ffs(DSI_VC_IRQ_##x)-1]);
+			stats->vc_irqs[0][ffs(DSI_VC_IRQ_##x)-1], \
+			stats->vc_irqs[1][ffs(DSI_VC_IRQ_##x)-1], \
+			stats->vc_irqs[2][ffs(DSI_VC_IRQ_##x)-1], \
+			stats->vc_irqs[3][ffs(DSI_VC_IRQ_##x)-1]);
 
 	seq_printf(s, "-- VC interrupts --\n");
 	PIS(CS);
@@ -1594,7 +1600,7 @@ static void dsi_dump_dsidev_irqs(struct platform_device *dsidev,
 
 #define PIS(x) \
 	seq_printf(s, "%-20s %10d\n", #x, \
-			stats.cio_irqs[ffs(DSI_CIO_IRQ_##x)-1]);
+			stats->cio_irqs[ffs(DSI_CIO_IRQ_##x)-1]);
 
 	seq_printf(s, "-- CIO interrupts --\n");
 	PIS(ERRSYNCESC1);
@@ -1618,6 +1624,8 @@ static void dsi_dump_dsidev_irqs(struct platform_device *dsidev,
 	PIS(ULPSACTIVENOT_ALL0);
 	PIS(ULPSACTIVENOT_ALL1);
 #undef PIS
+
+	kfree(stats);
 }
 
 static void dsi1_dump_irqs(struct seq_file *s)
-- 
2.35.1



