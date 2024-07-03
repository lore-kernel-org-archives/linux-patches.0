Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E0217966F;
	Wed,  3 Jul 2024 11:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004882; cv=none; b=huVmbW0dUhm41vJSgaxHx7Pbo4mGewPal8fr7Bo2eOe2JgDR961Y7SQAzRAhRxHX86RR2i+Fz6PIKUWTc9u9tgkSDP62myRHTNPFY24YVCK5Msi/yPlRnavGDUN6vBU+BHbTutsdNOLCvvETHCoZhiYuD0mi7uR3reJj1S2VgAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004882; c=relaxed/simple;
	bh=yuAdcLpJCuuIcfHksCD5BcdjELYcx9rGWd7RQPJlewc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0bNOOFuczibdXldmBHu9NZ4ejmdBAH3NVmw34R0RvuCXems3xQGuGcP8ruQSVPKjSnqSLEzzHMrt66f/9lTtH8vETJSQ30dOI0008m1BZ4gFr9GpX2MzIP11kF+31RZ8dedWRJSJ4Qfy4/68r8Isq5mWfYk3FSfXxIt22TAbIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PKITz3+D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PKITz3+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C9BC2BD10;
	Wed,  3 Jul 2024 11:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004882;
	bh=yuAdcLpJCuuIcfHksCD5BcdjELYcx9rGWd7RQPJlewc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PKITz3+D8+PnBV30k2EmFMU2MY+fUOYmXm9J+ljpLWo7dFmJu6LjjMDh5t6U/XY3n
	 eagOEPbLppUcLffFyvLjMT3VjW1LaRJrFN2JfGhfZb5r+fUvWXwwxJvCdyUiyT3JId
	 fnKgZgYJB3dWbukk1ltc0Hk6HLVgV/1Adm4zAudk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 187/290] r8169: remove nr_frags argument from rtl_tx_slots_avail
Date: Wed,  3 Jul 2024 12:39:28 +0200
Message-ID: <20240703102911.233944382@linuxfoundation.org>
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

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 83c317d7b36bb3858cf1cb86d2635ec3f3bd6ea3 ]

The only time when nr_frags isn't SKB_MAX_FRAGS is when entering
rtl8169_start_xmit(). However we can use SKB_MAX_FRAGS also here
because when queue isn't stopped there should always be room for
MAX_SKB_FRAGS + 1 descriptors.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/3d1f2ad7-31d5-2cac-4f4a-394f8a3cab63@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c71e3a5cffd5 ("r8169: Fix possible ring buffer corruption on fragmented Tx packets.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index b678fd1436a4c..dbf885f4dd01d 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4247,13 +4247,12 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 	return true;
 }
 
-static bool rtl_tx_slots_avail(struct rtl8169_private *tp,
-			       unsigned int nr_frags)
+static bool rtl_tx_slots_avail(struct rtl8169_private *tp)
 {
 	unsigned int slots_avail = tp->dirty_tx + NUM_TX_DESC - tp->cur_tx;
 
 	/* A skbuff with nr_frags needs nr_frags+1 entries in the tx queue */
-	return slots_avail > nr_frags;
+	return slots_avail > MAX_SKB_FRAGS;
 }
 
 /* Versions RTL8102e and from RTL8168c onwards support csum_v2 */
@@ -4288,7 +4287,7 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 
 	txd_first = tp->TxDescArray + entry;
 
-	if (unlikely(!rtl_tx_slots_avail(tp, frags))) {
+	if (unlikely(!rtl_tx_slots_avail(tp))) {
 		if (net_ratelimit())
 			netdev_err(dev, "BUG! Tx Ring full when queue awake!\n");
 		goto err_stop_0;
@@ -4333,7 +4332,7 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 
 	WRITE_ONCE(tp->cur_tx, tp->cur_tx + frags + 1);
 
-	stop_queue = !rtl_tx_slots_avail(tp, MAX_SKB_FRAGS);
+	stop_queue = !rtl_tx_slots_avail(tp);
 	if (unlikely(stop_queue)) {
 		/* Avoid wrongly optimistic queue wake-up: rtl_tx thread must
 		 * not miss a ring update when it notices a stopped queue.
@@ -4348,7 +4347,7 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 		 * can't.
 		 */
 		smp_mb__after_atomic();
-		if (rtl_tx_slots_avail(tp, MAX_SKB_FRAGS))
+		if (rtl_tx_slots_avail(tp))
 			netif_start_queue(dev);
 		door_bell = true;
 	}
@@ -4502,10 +4501,8 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 		 * ring status.
 		 */
 		smp_store_mb(tp->dirty_tx, dirty_tx);
-		if (netif_queue_stopped(dev) &&
-		    rtl_tx_slots_avail(tp, MAX_SKB_FRAGS)) {
+		if (netif_queue_stopped(dev) && rtl_tx_slots_avail(tp))
 			netif_wake_queue(dev);
-		}
 		/*
 		 * 8168 hack: TxPoll requests are lost when the Tx packets are
 		 * too close. Let's kick an extra TxPoll request when a burst
-- 
2.43.0



