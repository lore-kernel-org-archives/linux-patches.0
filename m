Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA1A4E36FA;
	Thu, 17 Sep 2026 18:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668860; cv=none; b=TkAX/D7qsTLLlS7/t1fO6eTyGYh82A7ZtwNjwl7ODmOoi9tQpfJPk1n2YQngvVjg2atF22CiWz6NxTfs+9YdsefzDgd4xg7V+gyzlMOHKvfQBezfQwWRtoc8PWZGSbX+EO+Ub3edPvoly+80NvZL/kNbnErSMDNp7VcYGb9MJ2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668860; c=relaxed/simple;
	bh=oAgT+pGP5hM8Qb8uMDuDX6c6wJN0HLnPjFaG9sXVjV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYeW783hcbZyablNt3jtw2YzWqYWkt/9MgpdTiAxK2eGf2fBuxV7YQjcjJUd/07IHkWF5PxpppURjBdk1Y5v30yOo7EhHCAQQ5I4GnEXTUOW4bVAIu5s0y2XCSAwkrfc00SAakPA20gQ6+tg/NynFWRowAbZPB1hZZNWL+0mwu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BVD4sCRB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BVD4sCRB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8181F000FF;
	Thu, 17 Sep 2026 18:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668859;
	bh=lBLEU5rYL+xTicf1lAnAyxBz4xCG/FrBiveWw2Sojdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BVD4sCRB7q+Uw0qzdVOME9fu3ySVyRpklrYODj0O2XVKcQ2XB5LwOfWWVLfsFWQIf
	 HJSH43iGRpQBdV4zmGXroEq72WcOTvlfxaYwLuKZ7LCI9ejCBPT2gS4xLvU+VN/6sX
	 nZ2Q1l5JMWBfxwV41x2wTy2tJYf1s0kTur5EBod8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0565/1102] net: ethernet: oa_tc6: Protect skb pointer used by two different kernel instances
Date: Thu, 17 Sep 2026 16:08:28 +0100
Message-ID: <20260917151554.078314590@linuxfoundation.org>
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
Stable-dep-of: 172c974113bf ("net: ethernet: oa_tc6: Improve the error recovery")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/oa_tc6.c | 109 ++++++++++++++++++++++++----------
 1 file changed, 76 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/oa_tc6.c b/drivers/net/ethernet/oa_tc6.c
index 85bd55de36197..322a04f6fe21f 100644
--- a/drivers/net/ethernet/oa_tc6.c
+++ b/drivers/net/ethernet/oa_tc6.c
@@ -640,6 +640,26 @@ static int oa_tc6_enable_data_transfer(struct oa_tc6 *tc6)
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
@@ -651,26 +671,30 @@ static void oa_tc6_cleanup_ongoing_rx_skb(struct oa_tc6 *tc6)
 
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
 
@@ -681,9 +705,15 @@ static void oa_tc6_free_pending_skbs(struct oa_tc6 *tc6)
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
@@ -1124,8 +1154,7 @@ static int oa_tc6_try_spi_transfer(struct oa_tc6 *tc6)
 			if (ret == -EAGAIN)
 				continue;
 
-			oa_tc6_cleanup_ongoing_tx_skb(tc6);
-			oa_tc6_cleanup_ongoing_rx_skb(tc6);
+			oa_tc6_free_ongoing_skbs(tc6);
 			netdev_err(tc6->netdev, "Device error: %d\n", ret);
 			return ret;
 		}
@@ -1147,15 +1176,20 @@ static irqreturn_t oa_tc6_macphy_threaded_irq(int irq, void *data)
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
 
@@ -1234,23 +1268,30 @@ EXPORT_SYMBOL_GPL(oa_tc6_zero_align_receive_frame_enable);
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
 
@@ -1404,8 +1445,10 @@ EXPORT_SYMBOL_GPL(oa_tc6_init);
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



