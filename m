Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B84149DF4;
	Tue, 25 Jun 2024 09:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308442; cv=none; b=J5+2Nno4lDhVcBkonzUy8nbly/dugyutR4Chg3uSP0dYhz75d4C6yG2mcZ5AbX9tNHkRgxZga5ltIM/9IsijCpw7AHnf98t1xTBKfJdgebJ/SZUze5egC8uui4mzQeJ/5mbjht6yNlGM1Kh6G/AsMbyHaCJ6XsaLNx7uDcm8IZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308442; c=relaxed/simple;
	bh=DN5FpbIJE8yFfiyRjGGJdrYBOFEIHKaXzqhAR8npmmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HATQ0lJ4nNRSOuLFvRNcFpGJ9dFZOs60ZJXoQBYkNaDEk13kz1eARUe0gk5CYzi19TqEvxMRXvLC/x9hKuimD6p7JLv3frbFy0tg2t/lNNHLDeu4GJNkpnXlwtNTeCwWATMfRY+UyUlb1Fj+dryBymvJWf3r6/16mPZzBeFOlPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uTfIPh0E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uTfIPh0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9925FC32781;
	Tue, 25 Jun 2024 09:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308442;
	bh=DN5FpbIJE8yFfiyRjGGJdrYBOFEIHKaXzqhAR8npmmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uTfIPh0ETfsQMAFRzkJvwMcw0uGFPQnqI6KbL8+iCNTsLbf/fdm4gA09R0bvNrJm+
	 TFTb/9X09/ZiomvQoTi+hWHtqgYza/Btyqaplrae1q5f/br1llvZ1ncnsBjckMapa0
	 XuFjWYhAfatZoxWaHtMOEx7jnub33RmOi4//alNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 122/250] qca_spi: Make interrupt remembering atomic
Date: Tue, 25 Jun 2024 11:31:20 +0200
Message-ID: <20240625085552.751049026@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index ff3b89e9028e9..ad06da0fdaa04 100644
--- a/drivers/net/ethernet/qualcomm/qca_debug.c
+++ b/drivers/net/ethernet/qualcomm/qca_debug.c
@@ -98,10 +98,8 @@ qcaspi_info_show(struct seq_file *s, void *what)
 
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
index 5799ecc88a875..8f7ce6b51a1c9 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -35,6 +35,8 @@
 
 #define MAX_DMA_BURST_LEN 5000
 
+#define SPI_INTR 0
+
 /*   Modules parameters     */
 #define QCASPI_CLK_SPEED_MIN 1000000
 #define QCASPI_CLK_SPEED_MAX 16000000
@@ -579,14 +581,14 @@ qcaspi_spi_thread(void *data)
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
@@ -600,8 +602,7 @@ qcaspi_spi_thread(void *data)
 			msleep(QCASPI_QCA7K_REBOOT_TIME_MS);
 		}
 
-		if (qca->intr_svc != qca->intr_req) {
-			qca->intr_svc = qca->intr_req;
+		if (test_and_clear_bit(SPI_INTR, &qca->intr)) {
 			start_spi_intr_handling(qca, &intr_cause);
 
 			if (intr_cause & SPI_INT_CPU_ON) {
@@ -663,7 +664,7 @@ qcaspi_intr_handler(int irq, void *data)
 {
 	struct qcaspi *qca = data;
 
-	qca->intr_req++;
+	set_bit(SPI_INTR, &qca->intr);
 	if (qca->spi_thread)
 		wake_up_process(qca->spi_thread);
 
@@ -679,8 +680,7 @@ qcaspi_netdev_open(struct net_device *dev)
 	if (!qca)
 		return -EINVAL;
 
-	qca->intr_req = 1;
-	qca->intr_svc = 0;
+	set_bit(SPI_INTR, &qca->intr);
 	qca->sync = QCASPI_SYNC_UNKNOWN;
 	qcafrm_fsm_init_spi(&qca->frm_handle);
 
diff --git a/drivers/net/ethernet/qualcomm/qca_spi.h b/drivers/net/ethernet/qualcomm/qca_spi.h
index d59cb2352ceec..8f4808695e820 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.h
+++ b/drivers/net/ethernet/qualcomm/qca_spi.h
@@ -81,8 +81,7 @@ struct qcaspi {
 	struct qcafrm_handle frm_handle;
 	struct sk_buff *rx_skb;
 
-	unsigned int intr_req;
-	unsigned int intr_svc;
+	unsigned long intr;
 	u16 reset_count;
 
 #ifdef CONFIG_DEBUG_FS
-- 
2.43.0



