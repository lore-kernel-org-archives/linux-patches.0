Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43F12949E0;
	Thu, 17 Sep 2026 17:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665340; cv=none; b=HiTjV5rk0AOcX3WH4C3DOYf6C+IIf955zcnE/Svm6Jrqj5HgSmd2Qwk8jDfWMQ39ttay6rEjr8/t53tzzCjnB2J9sMAY2BSFtBmXssd7GBwui0UdnTxdH9uU25gEh8jAXP+s9iVjLwFjgsAV+tzIbZ0dbh0kU7jpl6Tq9RGmmzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665340; c=relaxed/simple;
	bh=aoLHV31LiBGpSnE/T7855FehHkxIBYG8wvlVlKUcTm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HF53sI9NWbTOnXaliSmXVvnygfPcSxXJ7eo4etwGRGWBpYKmo2hS07PY6oBe0D1An9l2PhAyQxWXwHX+HzirOc5QnLo+rEyAPAvBFO96JTFM6tlGWmDdCuVSwa51ozpWn1frs5eac6byziM9+c23PJ55cmUU1O0ZQx5SF1g4pM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGW3T8Ho; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGW3T8Ho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234BE1F000FF;
	Thu, 17 Sep 2026 17:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665338;
	bh=915PgdFRqVBGVOZQ3uMKFdKsHiGbh5+k0bvP0K2pxeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NGW3T8Ho1FACKsJKr+mjkhKDR7zWBMoHIu4w1nMnmSMEe4sIFe3IelQx6v9a/h6Af
	 nMAm2UZjSy6UNGHZ/TTWGFMNhzSGd7KuPQsyC4jsrl0xBfkrAH2GQILKAI2vFmSBPV
	 vXAOuAxpn51fR4Zz02zrh3cmXgk9Lp8CI5mky1W4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0672/1250] net: ethernet: oa_tc6: Interrupt is active low, level triggered.
Date: Thu, 17 Sep 2026 16:07:47 +0100
Message-ID: <20260917151610.102508511@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>

[ Upstream commit b542d13fab0f556660ce5f10179fb3ae66bdb9a4 ]

According OPEN Alliance 10BASET1x MAC-PHY Serial Interface
specification, interrupt is active low, level triggered.

Code used edge triggered interrupt which has the risk of losing an
interrupt on instances like when interrupt is disabled. Level
triggered interrupt won't be deasserted unless handler runs and
clear the interrupting conditions.

Interrupt handler mechanism is changed to threaded irq from
interrupt handler and kernel thread waiting on work queue.
Threaded irq mechanism is best suited for level triggered interrupt
as it disables the interrupt until handler is run in thread level,
while giving us an ability to have interrupt context handler to
signal the threaded irq handler.

Introduced a logic to disable the device interrupt on error. Error
could be due in data chunk's header and footer or SPI interface itself.
This will avoid having repeated interrupts, in case the driver couldn't
recover from the error condition with the available recovery mechanism.

Fixes: 2c6ce5354453 ("net: ethernet: oa_tc6: implement mac-phy interrupt")
Signed-off-by: Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
Link: https://patch.msgid.link/20260611-level-trigger-v5-1-4533a9e85ce2@onsemi.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 172c974113bf ("net: ethernet: oa_tc6: Improve the error recovery")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/oa_tc6.c | 126 ++++++++++++++++++++--------------
 1 file changed, 76 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/oa_tc6.c b/drivers/net/ethernet/oa_tc6.c
index cfe1f6e3cd12c..cf5249f81651f 100644
--- a/drivers/net/ethernet/oa_tc6.c
+++ b/drivers/net/ethernet/oa_tc6.c
@@ -7,6 +7,7 @@
 
 #include <linux/bitfield.h>
 #include <linux/iopoll.h>
+#include <linux/interrupt.h>
 #include <linux/mdio.h>
 #include <linux/phy.h>
 #include <linux/oa_tc6.h>
@@ -44,6 +45,8 @@
 #define INT_MASK0_LOSS_OF_FRAME_ERR_MASK	BIT(4)
 #define INT_MASK0_RX_BUFFER_OVERFLOW_ERR_MASK	BIT(3)
 #define INT_MASK0_TX_PROTOCOL_ERR_MASK		BIT(0)
+#define INT_MASK0_ALL_INTERRUPTS                (GENMASK(5, 0) | \
+						 GENMASK(12, 7))
 
 /* PHY Clause 22 registers base address and mask */
 #define OA_TC6_PHY_STD_REG_ADDR_BASE		0xFF00
@@ -121,14 +124,13 @@ struct oa_tc6 {
 	struct sk_buff *ongoing_tx_skb;
 	struct sk_buff *waiting_tx_skb;
 	struct sk_buff *rx_skb;
-	struct task_struct *spi_thread;
-	wait_queue_head_t spi_wq;
 	u16 tx_skb_offset;
 	u16 spi_data_tx_buf_offset;
 	u16 tx_credits;
 	u8 rx_chunks_available;
 	bool rx_buf_overflow;
 	bool int_flag;
+	bool disable_traffic;
 };
 
 enum oa_tc6_header_type {
@@ -669,6 +671,38 @@ static void oa_tc6_cleanup_ongoing_tx_skb(struct oa_tc6 *tc6)
 	}
 }
 
+static void oa_tc6_cleanup_waiting_tx_skb(struct oa_tc6 *tc6)
+{
+	if (tc6->waiting_tx_skb) {
+		tc6->netdev->stats.tx_dropped++;
+		kfree_skb(tc6->waiting_tx_skb);
+		tc6->waiting_tx_skb = NULL;
+	}
+}
+
+static void oa_tc6_free_pending_skbs(struct oa_tc6 *tc6)
+{
+	oa_tc6_cleanup_ongoing_tx_skb(tc6);
+	oa_tc6_cleanup_ongoing_rx_skb(tc6);
+	oa_tc6_cleanup_waiting_tx_skb(tc6);
+}
+
+/* If the failure is at SPI interface level, masking and clearing
+ * the interrupt of the device won't work. Since SPI interrupt is
+ * disabled, it should stop the repeated interrupts.
+ */
+static void oa_tc6_disable_traffic(struct oa_tc6 *tc6)
+{
+	u32 regval = INT_MASK0_ALL_INTERRUPTS;
+
+	tc6->disable_traffic = true;
+	oa_tc6_free_pending_skbs(tc6);
+	oa_tc6_write_register(tc6, OA_TC6_REG_INT_MASK0, regval);
+	oa_tc6_read_register(tc6, OA_TC6_REG_STATUS0, &regval);
+	oa_tc6_write_register(tc6, OA_TC6_REG_STATUS0, regval);
+	dev_err(&tc6->spi->dev, "Device interrupt disabled to avoid interrupt storm");
+}
+
 static int oa_tc6_process_extended_status(struct oa_tc6 *tc6)
 {
 	u32 value;
@@ -1116,29 +1150,29 @@ static int oa_tc6_try_spi_transfer(struct oa_tc6 *tc6)
 	return 0;
 }
 
-static int oa_tc6_spi_thread_handler(void *data)
+static irqreturn_t oa_tc6_macphy_threaded_irq(int irq, void *data)
 {
 	struct oa_tc6 *tc6 = data;
-	int ret;
-
-	while (likely(!kthread_should_stop())) {
-		/* This kthread will be waken up if there is a tx skb or mac-phy
-		 * interrupt to perform spi transfer with tx chunks.
-		 */
-		wait_event_interruptible(tc6->spi_wq, tc6->int_flag ||
-					 (tc6->waiting_tx_skb &&
-					 tc6->tx_credits) ||
-					 kthread_should_stop());
-
-		if (kthread_should_stop())
-			break;
+	int ret = 0;
 
-		ret = oa_tc6_try_spi_transfer(tc6);
-		if (ret)
-			return ret;
+	/* It is possible that interrupt woke the thread before it is
+	 * disabled. Until we come up with good recovery mechanism,
+	 * no need to attempt spi transfer, once it fails. Pending skbs
+	 * are already freed.
+	 */
+	if (!tc6->disable_traffic) {
+		while (tc6->int_flag ||
+		       (tc6->waiting_tx_skb && tc6->tx_credits)) {
+			ret = oa_tc6_try_spi_transfer(tc6);
+			if (ret) {
+				disable_irq_nosync(tc6->spi->irq);
+				oa_tc6_disable_traffic(tc6);
+				break;
+			}
+		}
 	}
 
-	return 0;
+	return IRQ_HANDLED;
 }
 
 static int oa_tc6_update_buffer_status_from_register(struct oa_tc6 *tc6)
@@ -1172,11 +1206,15 @@ static irqreturn_t oa_tc6_macphy_isr(int irq, void *data)
 	 *   the previous rx footer.
 	 * - extended status event not reported in the previous rx footer.
 	 */
-	tc6->int_flag = true;
-	/* Wake spi kthread to perform spi transfer */
-	wake_up_interruptible(&tc6->spi_wq);
-
-	return IRQ_HANDLED;
+	if (tc6->disable_traffic)
+		disable_irq_nosync(tc6->spi->irq);
+	else
+		tc6->int_flag = true;
+	/* Wake IRQ thread to perform spi transfer . In case
+	 * disable_traffic is set, threaded irq may run again
+	 * one more time.
+	 */
+	return IRQ_WAKE_THREAD;
 }
 
 /**
@@ -1213,7 +1251,7 @@ EXPORT_SYMBOL_GPL(oa_tc6_zero_align_receive_frame_enable);
  */
 netdev_tx_t oa_tc6_start_xmit(struct oa_tc6 *tc6, struct sk_buff *skb)
 {
-	if (tc6->waiting_tx_skb) {
+	if (tc6->disable_traffic || tc6->waiting_tx_skb) {
 		netif_stop_queue(tc6->netdev);
 		return NETDEV_TX_BUSY;
 	}
@@ -1228,8 +1266,8 @@ netdev_tx_t oa_tc6_start_xmit(struct oa_tc6 *tc6, struct sk_buff *skb)
 	tc6->waiting_tx_skb = skb;
 	spin_unlock_bh(&tc6->tx_skb_lock);
 
-	/* Wake spi kthread to perform spi transfer */
-	wake_up_interruptible(&tc6->spi_wq);
+	/* Wake the threaded IRQ to perform spi transfer. */
+	irq_wake_thread(tc6->spi->irq, tc6);
 
 	return NETDEV_TX_OK;
 }
@@ -1322,24 +1360,15 @@ struct oa_tc6 *oa_tc6_init(struct spi_device *spi, struct net_device *netdev)
 		goto phy_exit;
 	}
 
-	init_waitqueue_head(&tc6->spi_wq);
-
-	tc6->spi_thread = kthread_run(oa_tc6_spi_thread_handler, tc6,
-				      "oa-tc6-spi-thread");
-	if (IS_ERR(tc6->spi_thread)) {
-		dev_err(&tc6->spi->dev, "Failed to create SPI thread\n");
-		goto phy_exit;
-	}
-
-	sched_set_fifo(tc6->spi_thread);
-
-	ret = devm_request_irq(&tc6->spi->dev, tc6->spi->irq, oa_tc6_macphy_isr,
-			       IRQF_TRIGGER_FALLING, dev_name(&tc6->spi->dev),
-			       tc6);
+	ret = devm_request_threaded_irq(&tc6->spi->dev, tc6->spi->irq,
+					oa_tc6_macphy_isr,
+					oa_tc6_macphy_threaded_irq,
+					IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+					dev_name(&tc6->spi->dev), tc6);
 	if (ret) {
 		dev_err(&tc6->spi->dev, "Failed to request macphy isr %d\n",
 			ret);
-		goto kthread_stop;
+		goto phy_exit;
 	}
 
 	/* oa_tc6_sw_reset_macphy() function resets and clears the MAC-PHY reset
@@ -1349,12 +1378,10 @@ struct oa_tc6 *oa_tc6_init(struct spi_device *spi, struct net_device *netdev)
 	 * 7.7 and 9.2.8.8 in the OPEN Alliance specification for more details.
 	 */
 	tc6->int_flag = true;
-	wake_up_interruptible(&tc6->spi_wq);
+	irq_wake_thread(tc6->spi->irq, tc6);
 
 	return tc6;
 
-kthread_stop:
-	kthread_stop(tc6->spi_thread);
 phy_exit:
 	oa_tc6_phy_exit(tc6);
 	return NULL;
@@ -1367,11 +1394,10 @@ EXPORT_SYMBOL_GPL(oa_tc6_init);
  */
 void oa_tc6_exit(struct oa_tc6 *tc6)
 {
+	tc6->disable_traffic = true;
+	disable_irq(tc6->spi->irq);
 	oa_tc6_phy_exit(tc6);
-	kthread_stop(tc6->spi_thread);
-	dev_kfree_skb_any(tc6->ongoing_tx_skb);
-	dev_kfree_skb_any(tc6->waiting_tx_skb);
-	dev_kfree_skb_any(tc6->rx_skb);
+	oa_tc6_free_pending_skbs(tc6);
 }
 EXPORT_SYMBOL_GPL(oa_tc6_exit);
 
-- 
2.53.0



