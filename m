Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BEB1549F
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6426C433D2;
	Mon,  8 May 2023 09:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539994;
	bh=R6qexKvTMJNCeTfeuuWfunLi4lUS6rKWFa1Taf6sDwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PKri4ByQ+oZhyooUDK5uwr/sRJ43OhbBqoJNI/7g58ZUFxbJIMXpz/tc9Aze//rrn
	 9j1uEs+V/hbQdckyd9b02mL7UPPuHO4+txS/xyu2f8usyznHyOeIyzXUZNvCeAw9tV
	 D9YfM3+hGdYTvOIXRYfx+jfGMgO+8GL3tWJM13Ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jassi Brar <jaswinder.singh@linaro.org>,
	Valentina Fernandez <valentina.fernandezalanis@microchip.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 203/611] mailbox: mpfs: switch to txdone_poll
Date: Mon,  8 May 2023 11:40:45 +0200
Message-Id: <20230508094428.972476796@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit b5984a9844fc45cd301a28fb56f3de95f7e20f3c ]

The system controller on PolarFire SoC has no interrupt to signify that
the TX has been completed. The interrupt instead signals that a service
requested by the mailbox client has succeeded. If a service fails, there
will be no interrupt delivered.

Switch to polling the busy register to determine whether transmission
has completed.

Fixes: 83d7b1560810 ("mbox: add polarfire soc system controller mailbox")
Acked-by: Jassi Brar <jaswinder.singh@linaro.org>
Tested-by: Valentina Fernandez <valentina.fernandezalanis@microchip.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox-mpfs.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/mailbox/mailbox-mpfs.c b/drivers/mailbox/mailbox-mpfs.c
index 853901acaeec2..08aa840cccaca 100644
--- a/drivers/mailbox/mailbox-mpfs.c
+++ b/drivers/mailbox/mailbox-mpfs.c
@@ -79,6 +79,13 @@ static bool mpfs_mbox_busy(struct mpfs_mbox *mbox)
 	return status & SCB_STATUS_BUSY_MASK;
 }
 
+static bool mpfs_mbox_last_tx_done(struct mbox_chan *chan)
+{
+	struct mpfs_mbox *mbox = (struct mpfs_mbox *)chan->con_priv;
+
+	return !mpfs_mbox_busy(mbox);
+}
+
 static int mpfs_mbox_send_data(struct mbox_chan *chan, void *data)
 {
 	struct mpfs_mbox *mbox = (struct mpfs_mbox *)chan->con_priv;
@@ -182,7 +189,6 @@ static irqreturn_t mpfs_mbox_inbox_isr(int irq, void *data)
 
 	mpfs_mbox_rx_data(chan);
 
-	mbox_chan_txdone(chan, 0);
 	return IRQ_HANDLED;
 }
 
@@ -212,6 +218,7 @@ static const struct mbox_chan_ops mpfs_mbox_ops = {
 	.send_data = mpfs_mbox_send_data,
 	.startup = mpfs_mbox_startup,
 	.shutdown = mpfs_mbox_shutdown,
+	.last_tx_done = mpfs_mbox_last_tx_done,
 };
 
 static int mpfs_mbox_probe(struct platform_device *pdev)
@@ -247,7 +254,8 @@ static int mpfs_mbox_probe(struct platform_device *pdev)
 	mbox->controller.num_chans = 1;
 	mbox->controller.chans = mbox->chans;
 	mbox->controller.ops = &mpfs_mbox_ops;
-	mbox->controller.txdone_irq = true;
+	mbox->controller.txdone_poll = true;
+	mbox->controller.txpoll_period = 10u;
 
 	ret = devm_mbox_controller_register(&pdev->dev, &mbox->controller);
 	if (ret) {
-- 
2.39.2



