Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B077193097;
	Wed,  3 Jul 2024 11:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005772; cv=none; b=FygxiWIx6cO1D4xBhrdTQZbbnobWwt123zbG9ro0SfDoFA2qE/7xHZh4WS6U44FJOoQFZNP4O1z5jxSsHv5q0r1Nls1v2ljm+x9G+lMcJhY67sUE3JydyqdQ0rZLUBtu6ZvCSxFVood783XHuWkkCf1EAkIvU2SyTNGhY3Xt+N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005772; c=relaxed/simple;
	bh=GfwJNBnwSfJ+uWOUiUNpfM3n7ruEJdqJPwdY30+zAYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ai9puup9NMShhWXIdoXlxcgV6l1K34ebZVsQghDPEEjhF9JzpiyRIZvVrOCwqUesD0RwB01zi4aXAm56qNInEMGwfeL3RQdYKs83HUva/d59S90k5nQinVEFPPjubTslJCijpp1BupAsMkvVnAKsz8SxE+ALCRGcvCGFXvvMeN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I1GpvQQa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I1GpvQQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B88C2BD10;
	Wed,  3 Jul 2024 11:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005772;
	bh=GfwJNBnwSfJ+uWOUiUNpfM3n7ruEJdqJPwdY30+zAYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I1GpvQQaMNebudKefJkQgVBQktLA+pZ0pi781Ak7lMPTng07IKdt6fFdeHHTWuUlW
	 IqBiBEzA3Ot5X0zmYBcz57bsGbUuIdvxD0U0JnCd0WnfQRfXmKXyq+efTdlxj9IDlK
	 hdFnlLY0zmBxP2iQ2hw0nzACsx1CbN4KRbJw76Bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 192/356] qca_spi: Make interrupt remembering atomic
Date: Wed,  3 Jul 2024 12:38:48 +0200
Message-ID: <20240703102920.368788475@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit 2d7198278ece01818cd95a3beffbdf8b2a353fa0 ]

The whole mechanism to remember occurred SPI interrupts is not atomic,
which could lead to unexpected behavior. So fix this by using atomic bit
operations instead.

Fixes: 291ab06ecf67 ("net: qualcomm: new Ethernet over SPI driver for QCA7000")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/20240614145030.7781-1-wahrenst@gmx.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qualcomm/qca_debug.c |  6 ++----
 drivers/net/ethernet/qualcomm/qca_spi.c   | 16 ++++++++--------
 drivers/net/ethernet/qualcomm/qca_spi.h   |  3 +--
 3 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/qca_debug.c b/drivers/net/ethernet/qualcomm/qca_debug.c
index 8b61bebd96e4b..9819a0c810f5c 100644
--- a/drivers/net/ethernet/qualcomm/qca_debug.c
+++ b/drivers/net/ethernet/qualcomm/qca_debug.c
@@ -111,10 +111,8 @@ qcaspi_info_show(struct seq_file *s, void *what)
 
 	seq_printf(s, "IRQ              : %d\n",
 		   qca->spi_dev->irq);
-	seq_printf(s, "INTR REQ         : %u\n",
-		   qca->intr_req);
-	seq_printf(s, "INTR SVC         : %u\n",
-		   qca->intr_svc);
+	seq_printf(s, "INTR             : %lx\n",
+		   qca->intr);
 
 	seq_printf(s, "SPI max speed    : %lu\n",
 		   (unsigned long)qca->spi_dev->max_speed_hz);
diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/ethernet/qualcomm/qca_spi.c
index e02f6ac0125d1..385e4c62ca03c 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -49,6 +49,8 @@
 
 #define MAX_DMA_BURST_LEN 5000
 
+#define SPI_INTR 0
+
 /*   Modules parameters     */
 #define QCASPI_CLK_SPEED_MIN 1000000
 #define QCASPI_CLK_SPEED_MAX 16000000
@@ -593,14 +595,14 @@ qcaspi_spi_thread(void *data)
 			continue;
 		}
 
-		if ((qca->intr_req == qca->intr_svc) &&
+		if (!test_bit(SPI_INTR, &qca->intr) &&
 		    !qca->txr.skb[qca->txr.head])
 			schedule();
 
 		set_current_state(TASK_RUNNING);
 
-		netdev_dbg(qca->net_dev, "have work to do. int: %d, tx_skb: %p\n",
-			   qca->intr_req - qca->intr_svc,
+		netdev_dbg(qca->net_dev, "have work to do. int: %lu, tx_skb: %p\n",
+			   qca->intr,
 			   qca->txr.skb[qca->txr.head]);
 
 		qcaspi_qca7k_sync(qca, QCASPI_EVENT_UPDATE);
@@ -614,8 +616,7 @@ qcaspi_spi_thread(void *data)
 			msleep(QCASPI_QCA7K_REBOOT_TIME_MS);
 		}
 
-		if (qca->intr_svc != qca->intr_req) {
-			qca->intr_svc = qca->intr_req;
+		if (test_and_clear_bit(SPI_INTR, &qca->intr)) {
 			start_spi_intr_handling(qca, &intr_cause);
 
 			if (intr_cause & SPI_INT_CPU_ON) {
@@ -677,7 +678,7 @@ qcaspi_intr_handler(int irq, void *data)
 {
 	struct qcaspi *qca = data;
 
-	qca->intr_req++;
+	set_bit(SPI_INTR, &qca->intr);
 	if (qca->spi_thread)
 		wake_up_process(qca->spi_thread);
 
@@ -693,8 +694,7 @@ qcaspi_netdev_open(struct net_device *dev)
 	if (!qca)
 		return -EINVAL;
 
-	qca->intr_req = 1;
-	qca->intr_svc = 0;
+	set_bit(SPI_INTR, &qca->intr);
 	qca->sync = QCASPI_SYNC_UNKNOWN;
 	qcafrm_fsm_init_spi(&qca->frm_handle);
 
diff --git a/drivers/net/ethernet/qualcomm/qca_spi.h b/drivers/net/ethernet/qualcomm/qca_spi.h
index 3067356106f0b..58ad910068d4b 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.h
+++ b/drivers/net/ethernet/qualcomm/qca_spi.h
@@ -93,8 +93,7 @@ struct qcaspi {
 	struct qcafrm_handle frm_handle;
 	struct sk_buff *rx_skb;
 
-	unsigned int intr_req;
-	unsigned int intr_svc;
+	unsigned long intr;
 	u16 reset_count;
 
 #ifdef CONFIG_DEBUG_FS
-- 
2.43.0



