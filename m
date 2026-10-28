Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208141;
	b=fHGfrlScFCxeEty0L0xy8GlvoWh1aUqbYDFcWly0a/WsAj1XG5xY3CfxnPz7di7j6GZ7
	 hRQl+53Gk8++EjQ4KLebBzWuJ4FGHy/1HGazW3/3QO6ApiDHAxnzvvQqBjNHri8gwtf7F
	 jXUeF8nTtLIBdbIPVwITHF6SckT9AGsXcnHFQQJiTpzf2Y4vYNkVuJOjYhzZrqsrV3xsm
	 9QZo8Pyo9jQ0vj5R9y+6AgI5F4ZJ3hlwfoFZ8da7ufryeqOix14Bi1Ob0IpElsLDUpPuF
	 EepVx4aT0tA6EYDxtlXHQd1c1VA6ISblxjw6dH3NB5aVn3M1TT9T/BfU2xdCDOxUpbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SWTZSdr/4ZI9sJtn51nlgFmNrxxKx8Q3QqjR1sYsquo=;
	b=d879CvBYKsZj9kWNMkNTHWZPjqITHS9D7GLijupF3FqGpdnfP8nd1DiDo4PI1k8RM/lP
	 P+xVMqDO4KGwJSuZnl+vhM47BLWNWjFU8vqRpinBMGS6jmFGQwwCOGRMAqxfKnrDjK3yZ
	 3FAB6rcntU/eHQ5am3mbCl2ci4vRpj0q+fADCvtPuDczoZoZpOVmr0dHgzfvgAV5fXYQu
	 GJydXyGfn/8fVFtswt8XEMdpEv9lTg4hW9iWJkU2d8JcA4xBaDuCpmqWQygezSggDIF70
	 P9cR/C57JN+HnryW8k8rk+DFUINmUMt+f62Buk6PhMR6N4+LO9KiiP4CB81PuSWxlFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l+vTxTh7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8477606A31A;
	Wed, 28 Oct 2026 17:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l+vTxTh7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B961F01825;
	Wed, 28 Oct 2026 17:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208140;
	bh=SWTZSdr/4ZI9sJtn51nlgFmNrxxKx8Q3QqjR1sYsquo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l+vTxTh7jRf+aRsJNrW8ty6hVABzx7UAhnl/g5tcleJHEB9B62WNPro9Qn9lJstS9
	 TLcPR5j7GBr05wG8X9YnIO6JPr08WeY4k0OpeA8WnmYNIKYEnhgSzP07Wsm1iaMIQP
	 RZZ3Ish7RtH7IC30omqgqIec1AqMofY1hn2sn7CI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/516] wifi: rtl8xxxu: fix use-after-free from rx_urb_wq on stop
Date: Wed, 28 Oct 2026 17:52:48 +0100
Message-ID: <20261028170003.912731116@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7cf2693619c92..ff161685ad75f 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5171,14 +5171,19 @@ static void rtl8xxxu_queue_rx_urb(struct rtl8xxxu_priv *priv,
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
@@ -5186,9 +5191,6 @@ static void rtl8xxxu_queue_rx_urb(struct rtl8xxxu_priv *priv,
 	}
 
 	spin_unlock_irqrestore(&priv->rx_urb_lock, flags);
-
-	if (pending > RTL8XXXU_RX_URB_PENDING_WATER)
-		schedule_work(&priv->rx_urb_wq);
 }
 
 static void rtl8xxxu_rx_urb_work(struct work_struct *work)
@@ -6464,6 +6466,13 @@ static void rtl8xxxu_stop(struct ieee80211_hw *hw)
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



