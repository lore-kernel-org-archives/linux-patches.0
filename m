Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645EE173355;
	Wed,  3 Jul 2024 11:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004744; cv=none; b=AQf5e3PhRk/IiDZk9My0bwdWCImbPG6A6eKJ85JXDyRRzmdSWB8PCgxgeA5HfNYxY0Jf8vpNSdcIIYmE6WI+ii/FbfTnjv/QR6aza6hos85o9zpk25m8vYjieA1bZLkmbzR3CRDi/PeNO19BJBxVColky5iD+Gu0FRGHbeJBuCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004744; c=relaxed/simple;
	bh=aPdjMLTU6cVAq3mODHy94ZOoUb2VV7ehS1LTcg0aXMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E87OxNTW5Yzac8wVatFfB6C4prZYncMyUHq8rXuZHRsHFWTPG7kplTMeUGKlOpBtlCkFli/qoxqru5t3YrrfTHqDvduFXQaR7hnnj/kRTxvJNMZmDY45xBIS5XKT0R6nAkMIipVP7hXXricS+Pf7QC02H4wGQY/zQyeQmW/pG7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gLIx+5xk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gLIx+5xk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D425AC4AF0C;
	Wed,  3 Jul 2024 11:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004744;
	bh=aPdjMLTU6cVAq3mODHy94ZOoUb2VV7ehS1LTcg0aXMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gLIx+5xkMCSV9oSGoEcB5g/L7ysMs4sGX0bk5YJEQplFjW/o0lM0sXHU2uFXOmH7v
	 cin119dAm/PE/ynzsuAY3fhC8PhP+ZIr8j1zVMW3jX/7fug+TtqxOVoUFpntkQU5tS
	 jf5p2VFix41y/LwIHbx8MBaKhZFGPLg50wv/2QjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 144/290] qca_spi: Make interrupt remembering atomic
Date: Wed,  3 Jul 2024 12:38:45 +0200
Message-ID: <20240703102909.623088483@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/ethernet/qualcomm/qca_debug.c |    6 ++----
 drivers/net/ethernet/qualcomm/qca_spi.c   |   16 ++++++++--------
 drivers/net/ethernet/qualcomm/qca_spi.h   |    3 +--
 3 files changed, 11 insertions(+), 14 deletions(-)

--- a/drivers/net/ethernet/qualcomm/qca_debug.c
+++ b/drivers/net/ethernet/qualcomm/qca_debug.c
@@ -110,10 +110,8 @@ qcaspi_info_show(struct seq_file *s, voi
 
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
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -49,6 +49,8 @@
 
 #define MAX_DMA_BURST_LEN 5000
 
+#define SPI_INTR 0
+
 /*   Modules parameters     */
 #define QCASPI_CLK_SPEED_MIN 1000000
 #define QCASPI_CLK_SPEED_MAX 16000000
@@ -585,14 +587,14 @@ qcaspi_spi_thread(void *data)
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
@@ -606,8 +608,7 @@ qcaspi_spi_thread(void *data)
 			msleep(QCASPI_QCA7K_REBOOT_TIME_MS);
 		}
 
-		if (qca->intr_svc != qca->intr_req) {
-			qca->intr_svc = qca->intr_req;
+		if (test_and_clear_bit(SPI_INTR, &qca->intr)) {
 			start_spi_intr_handling(qca, &intr_cause);
 
 			if (intr_cause & SPI_INT_CPU_ON) {
@@ -669,7 +670,7 @@ qcaspi_intr_handler(int irq, void *data)
 {
 	struct qcaspi *qca = data;
 
-	qca->intr_req++;
+	set_bit(SPI_INTR, &qca->intr);
 	if (qca->spi_thread &&
 	    qca->spi_thread->state != TASK_RUNNING)
 		wake_up_process(qca->spi_thread);
@@ -686,8 +687,7 @@ qcaspi_netdev_open(struct net_device *de
 	if (!qca)
 		return -EINVAL;
 
-	qca->intr_req = 1;
-	qca->intr_svc = 0;
+	set_bit(SPI_INTR, &qca->intr);
 	qca->sync = QCASPI_SYNC_UNKNOWN;
 	qcafrm_fsm_init_spi(&qca->frm_handle);
 
--- a/drivers/net/ethernet/qualcomm/qca_spi.h
+++ b/drivers/net/ethernet/qualcomm/qca_spi.h
@@ -92,8 +92,7 @@ struct qcaspi {
 	struct qcafrm_handle frm_handle;
 	struct sk_buff *rx_skb;
 
-	unsigned int intr_req;
-	unsigned int intr_svc;
+	unsigned long intr;
 	u16 reset_count;
 
 #ifdef CONFIG_DEBUG_FS


