Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212081;
	b=BvJUGiudh6xW+KfKJaRKG+tAEn0ZvuPSSDVgcElohooFjyRb1GAGMIubNkbEZPqbruHC
	 WsLbMflG1daSPnGl/Fq/T6JrsnmNnADFFbOLpmG+Zkqe9m8+Of+0IsWLF5oIeLoTbUs/k
	 loGZu/GVNArTtIsMi57Rfv1xWZCv2WbyIGkT1QKbFejQ92nTb2qF9mOUGH/UQ8YQgOZBg
	 mq7yX6s5wKN7f7gicikueVWPX4THAnowX7r/rx844bBKht6xBTsB2eT0/gYlyd7coYwpz
	 UfbBrQcDPAuPdgiW8ythAxYXDbKWpsaibXDaB4/Tlsq0V9a8Ud2K765AtOPQqk8C2EA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212081;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bjhU02gxS7DIj4q7F3e170aB1qeURyjbbqBzBXojq28=;
	b=prPE4AlBuVmqoL1KbGM01cGS+QN8+iC912dAbhLulGtZcn+gg6L8OM6KrZYTHjiFwwcW
	 m/wCOQQbVPvkUOOE/TTojc/d1WI2DiFJMfG335ndrdlgGuImqfiUKNK4jBCT94u1yg3p3
	 t47lFaeUF2hcqBXN70QZO6F8yg9SQXCYMxqrWuck8KfNz1R1fLXJdOMJv+dvJsXXt3sSr
	 JLuNFcG1Wg+GJY5wml2aLVn5HEgWV1gJ+250qOKA3SusUJGZKydOXCYPF/3hB+FApboVw
	 wJ+U0HE4HmMdsFEM2iN/WRzg6xcNddPv2YPuTzh+TZvvvPcSF3AX+38dxAyzReDd3wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y4M90fip;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C59606A31A;
	Wed, 28 Oct 2026 18:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y4M90fip
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7411F01825;
	Wed, 28 Oct 2026 18:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212081;
	bh=bjhU02gxS7DIj4q7F3e170aB1qeURyjbbqBzBXojq28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y4M90fip2zt/qAoNKHQMPpojRChRiaBXmTReYdI7/c3aBBkwWh4HE8CIWDVKfIs8h
	 ES1o+TDl1hKXFGMmy43cxpr/Dbri02wJ1JBi3J1cPjp4d4NWLUcTvMHbigXiiX0wjN
	 yV7/tv0IMdO43RCb1fCg2udZazunQD0jKTGGW9cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0032/1887] wifi: rtl8xxxu: fix use-after-free from rx_urb_wq on stop
Date: Wed, 28 Oct 2026 17:35:28 +0100
Message-ID: <20261028170459.957648734@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit 6c080026ecc17eecb103f8927c64ea73a74bb818 ]

rtl8xxxu arms rx_urb_wq from the RX completion path:
rtl8xxxu_rx_complete() hands the URB to rtl8xxxu_queue_rx_urb(), which
queues it on rx_urb_pending_list and, once the list grows past
RTL8XXXU_RX_URB_PENDING_WATER, schedules rx_urb_wq.  The worker
rtl8xxxu_rx_urb_work() drains rx_urb_pending_list, recovers priv through
container_of, and resubmits each URB through rtl8xxxu_submit_rx_urb(),
which anchors it on rx_anchor and dereferences priv->udev.

rtl8xxxu_stop() cancels the sibling work items (c2hcmd_work, ra_watchdog,
update_beacon_work) but never cancels rx_urb_wq, so a worker armed during
the last burst of RX traffic can run rtl8xxxu_rx_urb_work() after
rtl8xxxu_disconnect() has called ieee80211_free_hw(), which frees priv,
producing a use-after-free.  The window opens under active RX traffic
(pending count above the watermark) followed by a disconnect.

There are two teardown races to close:

  * rtl8xxxu_queue_rx_urb() decided whether to enqueue under rx_urb_lock
    but called schedule_work() after dropping the lock.  A completion
    that observed shutdown == false and released the lock could then call
    schedule_work() after rtl8xxxu_stop() had set shutdown and
    cancel_work_sync() had already returned, arming the worker to run
    after the teardown.  Move schedule_work() under the same !shutdown
    branch so the arming decision is atomic with the shutdown check.

  * rtl8xxxu_rx_urb_work() anchors every URB it drained back onto
    rx_anchor through rtl8xxxu_submit_rx_urb().  A worker still running
    when usb_kill_anchored_urbs(&priv->rx_anchor) returned would submit a
    URB that escaped the kill.  In rtl8xxxu_stop(), call
    cancel_work_sync(&priv->rx_urb_wq) before the kill so the worker is
    drained first.

After priv->shutdown is set under rx_urb_lock, completions can no longer
queue rx_urb_wq. cancel_work_sync() then drains the last queued or running
worker, and the following usb_kill_anchored_urbs() kills the URBs it may
have submitted.

rtl8xxxu_disconnect() is covered because ieee80211_unregister_hw()
guarantees .stop() runs for a live interface before ieee80211_free_hw()
frees priv.  The probe error path needs no cancel: rx_urb_wq is
INIT_WORK()'d there but cannot have been scheduled, since no URB is
submitted before ieee80211_register_hw() succeeds.

This bug was found by static analysis.

Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
Cc: stable@vger.kernel.org
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260630033117.3377-1-fanwu01@zju.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index c1bc55f0e4c01..20a7537d2cae8 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5263,14 +5263,19 @@ static void rtl8xxxu_queue_rx_urb(struct rtl8xxxu_priv *priv,
 {
 	struct sk_buff *skb;
 	unsigned long flags;
-	int pending = 0;
 
 	spin_lock_irqsave(&priv->rx_urb_lock, flags);
 
 	if (!priv->shutdown) {
 		list_add_tail(&rx_urb->list, &priv->rx_urb_pending_list);
 		priv->rx_urb_pending_count++;
-		pending = priv->rx_urb_pending_count;
+		/*
+		 * Arm the worker under rx_urb_lock so this is atomic with the
+		 * shutdown check: moving it out of the lock would let a
+		 * completion arm the work after rtl8xxxu_stop() canceled it.
+		 */
+		if (priv->rx_urb_pending_count > RTL8XXXU_RX_URB_PENDING_WATER)
+			schedule_work(&priv->rx_urb_wq);
 	} else {
 		skb = (struct sk_buff *)rx_urb->urb.context;
 		dev_kfree_skb_irq(skb);
@@ -5278,9 +5283,6 @@ static void rtl8xxxu_queue_rx_urb(struct rtl8xxxu_priv *priv,
 	}
 
 	spin_unlock_irqrestore(&priv->rx_urb_lock, flags);
-
-	if (pending > RTL8XXXU_RX_URB_PENDING_WATER)
-		schedule_work(&priv->rx_urb_wq);
 }
 
 static void rtl8xxxu_rx_urb_work(struct work_struct *work)
@@ -6529,6 +6531,13 @@ static void rtl8xxxu_stop(struct ieee80211_hw *hw)
 	priv->shutdown = true;
 	spin_unlock_irqrestore(&priv->rx_urb_lock, flags);
 
+	/*
+	 * Cancel before killing rx_anchor: the worker re-anchors every URB
+	 * it drained via rtl8xxxu_submit_rx_urb(), so a worker still running
+	 * after the kill could submit a URB that escapes it.
+	 */
+	cancel_work_sync(&priv->rx_urb_wq);
+
 	usb_kill_anchored_urbs(&priv->rx_anchor);
 	usb_kill_anchored_urbs(&priv->tx_anchor);
 	if (priv->usb_interrupts)
-- 
2.53.0



