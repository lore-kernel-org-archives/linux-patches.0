Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E4652ED3C;
	Thu, 17 Sep 2026 15:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659059; cv=none; b=m+yBsgMmGaQLLeJdSFzRflB+BpN+N8ROS8zov+ys4vwvJxx+Jap2x+A2/MDozSp5aBfwhinITCvoq3QyytPCUeJwu6dvyo9v8TXZMLsA8yfmbMHDSb1ijOlnab+u9pOL66hIWlBV9UuaX+pIrJCJ+tQAhMu5nDxPornH6WVoj9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659059; c=relaxed/simple;
	bh=W585pMIAqc7YdwjlTlFdA1Ab//GcFfLEusjhGIJVSYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xdte4COF72164KypKDiZbbO+ZAupW8jVt7IN2ehvmdgHhwRANRmkoaMkYfXLC9cbbvczDo4jOcHDUNM5ni5Ltpataeof3456qL5o7TpC49xVQQE+6ntqNMBZyi1KCnwEm2xRP7J8oVmI/WW0meXSzGzxtIVryfDpopmaQbTpWCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TYr52R3z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TYr52R3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80BA21F00898;
	Thu, 17 Sep 2026 15:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659055;
	bh=bdDJ6zzAjEJQOAHEv1jt3rguB/QzmaUP3OERxns5gP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TYr52R3zWAG/achWLL9gpmXtInC6LVVZg19uqBfSc5wkeIpQpXUl0EzB3lcnmE6Jl
	 vD/USOWnoKR4KyNodffdaXRAA+cpVkSiS5wDtswVS2lHTayD1iXt1Z5mcPjY/NjTRE
	 gnC2xnuFYyDsjgTo7eYCQL0hmwK3oJDmkKfjC/g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 129/733] net: ethernet: oa_tc6: Protect skb pointer used by two different kernel instances
Date: Thu, 17 Sep 2026 16:07:17 +0100
Message-ID: <20260917151354.236433262@linuxfoundation.org>
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

From: Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>

[ Upstream commit 5443d9c4f55d46634b95432e1e8a40b824019bbb ]

Threaded IRQ uses waiting_tx_skb. Transmit path also uses this pointer
without any mutual exclusion protection. As a result, it might leak skb
buffer, particularly if threaded IRQ sets disable_traffic true after
start_xmit already checked and found that disable_traffic being false,
if they happen to run on different cores.

On fatal error, where disable_traffic is set, transmit function drops the
packet and return NETDEV_TX_OK. Due to this change, skb_linearize call
is moved up to the beginning of the transmit function.

Since skb buffer may be freed from different contexts, dev_kfree_skb_any
is used to free skb buffer now, replacing one of the kfree_skb call.

oa_tc6_exit disables the irq before setting disable_traffic true.

Fixes: b542d13fab0f ("net: ethernet: oa_tc6: Interrupt is active low, level triggered.")
Signed-off-by: Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
Link: https://patch.msgid.link/20260824-fix-race-condition-and-crash-v7-1-4323279b18f2@onsemi.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/oa_tc6.c | 109 ++++++++++++++++++++++++----------
 1 file changed, 76 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/oa_tc6.c b/drivers/net/ethernet/oa_tc6.c
index fb219542e90d3..d283e81358e65 100644
--- a/drivers/net/ethernet/oa_tc6.c
+++ b/drivers/net/ethernet/oa_tc6.c
@@ -639,6 +639,26 @@ static int oa_tc6_enable_data_transfer(struct oa_tc6 *tc6)
 	return oa_tc6_write_register(tc6, OA_TC6_REG_CONFIG0, value);
 }
 
+/* Called when a frame that is meant to be transmitted, is dropped. */
+static void oa_tc6_drop_tx_skb(struct oa_tc6 *tc6, struct sk_buff *skb)
+{
+	if (skb) {
+		tc6->netdev->stats.tx_dropped++;
+		dev_kfree_skb_any(skb);
+	}
+}
+
+static struct sk_buff *oa_tc6_detach_waiting_tx_skb(struct oa_tc6 *tc6)
+{
+	struct sk_buff *skb;
+
+	lockdep_assert_held(&tc6->tx_skb_lock);
+	skb = tc6->waiting_tx_skb;
+	tc6->waiting_tx_skb = NULL;
+
+	return skb;
+}
+
 static void oa_tc6_cleanup_ongoing_rx_skb(struct oa_tc6 *tc6)
 {
 	if (tc6->rx_skb) {
@@ -650,26 +670,30 @@ static void oa_tc6_cleanup_ongoing_rx_skb(struct oa_tc6 *tc6)
 
 static void oa_tc6_cleanup_ongoing_tx_skb(struct oa_tc6 *tc6)
 {
-	if (tc6->ongoing_tx_skb) {
-		tc6->netdev->stats.tx_dropped++;
-		kfree_skb(tc6->ongoing_tx_skb);
-		tc6->ongoing_tx_skb = NULL;
-	}
+	oa_tc6_drop_tx_skb(tc6, tc6->ongoing_tx_skb);
+	tc6->ongoing_tx_skb = NULL;
 }
 
 static void oa_tc6_cleanup_waiting_tx_skb(struct oa_tc6 *tc6)
 {
-	if (tc6->waiting_tx_skb) {
-		tc6->netdev->stats.tx_dropped++;
-		kfree_skb(tc6->waiting_tx_skb);
-		tc6->waiting_tx_skb = NULL;
-	}
+	struct sk_buff *skb;
+
+	spin_lock_bh(&tc6->tx_skb_lock);
+	skb = oa_tc6_detach_waiting_tx_skb(tc6);
+	spin_unlock_bh(&tc6->tx_skb_lock);
+
+	oa_tc6_drop_tx_skb(tc6, skb);
 }
 
-static void oa_tc6_free_pending_skbs(struct oa_tc6 *tc6)
+static void oa_tc6_free_ongoing_skbs(struct oa_tc6 *tc6)
 {
 	oa_tc6_cleanup_ongoing_tx_skb(tc6);
 	oa_tc6_cleanup_ongoing_rx_skb(tc6);
+}
+
+static void oa_tc6_free_pending_skbs(struct oa_tc6 *tc6)
+{
+	oa_tc6_free_ongoing_skbs(tc6);
 	oa_tc6_cleanup_waiting_tx_skb(tc6);
 }
 
@@ -680,9 +704,15 @@ static void oa_tc6_free_pending_skbs(struct oa_tc6 *tc6)
 static void oa_tc6_disable_traffic(struct oa_tc6 *tc6)
 {
 	u32 regval = OA_TC6_INT_MASK0_ALL_INTERRUPTS;
+	struct sk_buff *skb;
 
+	spin_lock_bh(&tc6->tx_skb_lock);
 	tc6->disable_traffic = true;
-	oa_tc6_free_pending_skbs(tc6);
+	skb = oa_tc6_detach_waiting_tx_skb(tc6);
+	spin_unlock_bh(&tc6->tx_skb_lock);
+
+	oa_tc6_drop_tx_skb(tc6, skb);
+	oa_tc6_free_ongoing_skbs(tc6);
 	oa_tc6_write_register(tc6, OA_TC6_REG_INT_MASK0, regval);
 	oa_tc6_read_register(tc6, OA_TC6_REG_STATUS0, &regval);
 	oa_tc6_write_register(tc6, OA_TC6_REG_STATUS0, regval);
@@ -1123,8 +1153,7 @@ static int oa_tc6_try_spi_transfer(struct oa_tc6 *tc6)
 			if (ret == -EAGAIN)
 				continue;
 
-			oa_tc6_cleanup_ongoing_tx_skb(tc6);
-			oa_tc6_cleanup_ongoing_rx_skb(tc6);
+			oa_tc6_free_ongoing_skbs(tc6);
 			netdev_err(tc6->netdev, "Device error: %d\n", ret);
 			return ret;
 		}
@@ -1146,15 +1175,20 @@ static irqreturn_t oa_tc6_macphy_threaded_irq(int irq, void *data)
 	 * no need to attempt spi transfer, once it fails. Pending skbs
 	 * are already freed.
 	 */
-	if (!tc6->disable_traffic) {
-		while (tc6->int_flag ||
-		       (tc6->waiting_tx_skb && tc6->tx_credits)) {
-			ret = oa_tc6_try_spi_transfer(tc6);
-			if (ret) {
-				disable_irq_nosync(tc6->spi->irq);
-				oa_tc6_disable_traffic(tc6);
-				break;
-			}
+	spin_lock_bh(&tc6->tx_skb_lock);
+	if (tc6->disable_traffic) {
+		spin_unlock_bh(&tc6->tx_skb_lock);
+		return IRQ_HANDLED;
+	}
+	spin_unlock_bh(&tc6->tx_skb_lock);
+
+	while (tc6->int_flag ||
+	       (tc6->waiting_tx_skb && tc6->tx_credits)) {
+		ret = oa_tc6_try_spi_transfer(tc6);
+		if (ret) {
+			disable_irq_nosync(tc6->spi->irq);
+			oa_tc6_disable_traffic(tc6);
+			break;
 		}
 	}
 
@@ -1233,23 +1267,30 @@ EXPORT_SYMBOL_GPL(oa_tc6_zero_align_receive_frame_enable);
  * @tc6: oa_tc6 struct.
  * @skb: socket buffer in which the ethernet frame is stored.
  *
- * Return: NETDEV_TX_OK if the transmit ethernet frame skb added in the tx_skb_q
- * otherwise returns NETDEV_TX_BUSY.
+ * Return: NETDEV_TX_OK either on successful queueing of the packet for
+ * transmission, or on packet getting dropped. Packet can be dropped due to
+ * failure in linearizing the buffer or disable_traffic is set due to
+ * earlier fatal error. Returns NETDEV_TX_BUSY when there is no room
+ * to queue the packet.
  */
 netdev_tx_t oa_tc6_start_xmit(struct oa_tc6 *tc6, struct sk_buff *skb)
 {
-	if (tc6->disable_traffic || tc6->waiting_tx_skb) {
-		netif_stop_queue(tc6->netdev);
-		return NETDEV_TX_BUSY;
-	}
-
 	if (skb_linearize(skb)) {
-		dev_kfree_skb_any(skb);
-		tc6->netdev->stats.tx_dropped++;
+		oa_tc6_drop_tx_skb(tc6, skb);
 		return NETDEV_TX_OK;
 	}
 
 	spin_lock_bh(&tc6->tx_skb_lock);
+	if (tc6->waiting_tx_skb) {
+		netif_stop_queue(tc6->netdev);
+		spin_unlock_bh(&tc6->tx_skb_lock);
+		return NETDEV_TX_BUSY;
+	}
+	if (tc6->disable_traffic) {
+		spin_unlock_bh(&tc6->tx_skb_lock);
+		oa_tc6_drop_tx_skb(tc6, skb);
+		return NETDEV_TX_OK;
+	}
 	tc6->waiting_tx_skb = skb;
 	spin_unlock_bh(&tc6->tx_skb_lock);
 
@@ -1403,8 +1444,10 @@ EXPORT_SYMBOL_GPL(oa_tc6_init);
  */
 void oa_tc6_exit(struct oa_tc6 *tc6)
 {
-	tc6->disable_traffic = true;
 	disable_irq(tc6->spi->irq);
+	spin_lock_bh(&tc6->tx_skb_lock);
+	tc6->disable_traffic = true;
+	spin_unlock_bh(&tc6->tx_skb_lock);
 	oa_tc6_phy_exit(tc6);
 	oa_tc6_free_pending_skbs(tc6);
 }
-- 
2.53.0



