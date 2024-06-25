Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AD0146A67;
	Tue, 25 Jun 2024 09:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309145; cv=none; b=bHDudNTZC8T5Q5P/AR0LuFDjOGBS89fBaFndEUhEwVI9yYGiLpuOdqH6bpI44gQp0Rv6ECYjlr1F6dOQbT1jaa62OXemH/1pQvoEHVF7UjFsKRuDIA3kDCgdi77j6r1CavtNVdujuaz/1AMHQrHCucgg6FUVJr9luFsr/FmIt4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309145; c=relaxed/simple;
	bh=mp8cXV1d7K9F2iJYl+x2l3jLpmdr2eG+A3jXTSZB7DI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axEG6VlJ6uK9sozxxJLzptlmDgncIjZ8reF9gOYnqHN7NsZE86OF3m4H9FOf3gdgONzgyV3h6Cp27rNG7u8//SEXJH/XfeW5kCX3oYzLA5/ppCGUc0hW9Y2zsVsBUSLJBV8i5Eb78NjM3+D6nJ6hMwOIpvszIciYTl4pwKONMMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wr1q8QWd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wr1q8QWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21DEC32781;
	Tue, 25 Jun 2024 09:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309145;
	bh=mp8cXV1d7K9F2iJYl+x2l3jLpmdr2eG+A3jXTSZB7DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wr1q8QWdKAy8fPxmBEReA9RHUlZ6OXBWgHADNGx/CLIKgd6gRYpVG69OjAI7kVQV/
	 iF0twyJeJjyRaF+YHnVvXtLxSzObq2bYNH4OgS/RRBPQMFQz2xmKVIRgdK4wKF7/Qu
	 jbyNArr+cKD9DFyZ5PMBGnQTcZIpvR72SePOksRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/192] qca_spi: Make interrupt remembering atomic
Date: Tue, 25 Jun 2024 11:32:35 +0200
Message-ID: <20240625085540.360308638@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1822f2ad8f0dd..2ac1b1b96e6a4 100644
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
index 5f3c11fb3fa27..b697a9e6face6 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -48,6 +48,8 @@
 
 #define MAX_DMA_BURST_LEN 5000
 
+#define SPI_INTR 0
+
 /*   Modules parameters     */
 #define QCASPI_CLK_SPEED_MIN 1000000
 #define QCASPI_CLK_SPEED_MAX 16000000
@@ -592,14 +594,14 @@ qcaspi_spi_thread(void *data)
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
@@ -613,8 +615,7 @@ qcaspi_spi_thread(void *data)
 			msleep(QCASPI_QCA7K_REBOOT_TIME_MS);
 		}
 
-		if (qca->intr_svc != qca->intr_req) {
-			qca->intr_svc = qca->intr_req;
+		if (test_and_clear_bit(SPI_INTR, &qca->intr)) {
 			start_spi_intr_handling(qca, &intr_cause);
 
 			if (intr_cause & SPI_INT_CPU_ON) {
@@ -676,7 +677,7 @@ qcaspi_intr_handler(int irq, void *data)
 {
 	struct qcaspi *qca = data;
 
-	qca->intr_req++;
+	set_bit(SPI_INTR, &qca->intr);
 	if (qca->spi_thread)
 		wake_up_process(qca->spi_thread);
 
@@ -692,8 +693,7 @@ qcaspi_netdev_open(struct net_device *dev)
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



