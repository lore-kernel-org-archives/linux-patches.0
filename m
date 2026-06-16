Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60EE26B0A9;
	Tue, 16 Jun 2026 15:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623329; cv=none; b=gcH7rhaLaWkkI9sts2VA8D7QGBFvjkczB5wj2sU4uWEM573S1m4UnGHILd66LsWBSiwBkLuW8oY1Ac5sJj2KFAYdCBKlAJJZla1hoHADD8RGeWDZ4i9Muv976wCExsmzXeCoQU28wqnd3TOTtc0/cTx0YIFTJjImqSk3vtia4G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623329; c=relaxed/simple;
	bh=wderISA0kBWDOqeJIZ03BEuIKuY2mkWjfAPZdPESFFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYGGAQmpPpuf+ClwTLRntM2B2FO4/0eLR+UP4YFMBCJwEEumMhndfvmpRQdMrVQC4psEIZbCiFjsVmj2EaWthRx5HttAs25zCK7Qf1oIyTg99ZPvDdccIeijooxsywXG3Tv9X2T5rnATtQ+m/fDvw8wTUvBUv1OseW29nLuQGOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZBq8JdX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZBq8JdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54DD1F000E9;
	Tue, 16 Jun 2026 15:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623327;
	bh=zouz3215zAQAeUd/pDFWT7e79yLluZnH86zcErMNjR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zZBq8JdX+hY6qEDj2HqwsudHRT2a3hlCyEFyy+Y/tntOarefK5pkQNODKs0Pr3JVi
	 LDPcW8DXuPy1PEB9s2fa5x4mEn/qo5dyKbWB06wFrGPrD+pwInr+2MBqf/h1a2mzYD
	 on//HjAnPISrKnmVW02MVTNLJ7ig2jDjNhZriqY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 127/378] net: mctp: usb: fix race between urb completion and rx_retry cancellation
Date: Tue, 16 Jun 2026 20:25:58 +0530
Message-ID: <20260616145117.019884007@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit 54665dce982689e2fd99b32e9a0dcc204fda8a51 ]

It's possible that sequencing between setting ->stopped and cancelling
the rx_retry work (in ndo_stop) could leave us with an urb queued:

    T1: ndo_stop                  T2: rx_retry_work
    ------------                  ----------------
                                  LD: ->stopped => false
    ST: ->stopped <= true
    usb_kill_urb()
                                  mctp_usb_rx_queue()
                                    usb_submit_urb()
    cancel_delayed_work_sync()

That urb completion can then re-schedule rx_retry_work.

Strenghen the sequencing between the stop (preventing another requeue)
and the cancel by updating both atomically under a new rx lock. After
setting ->rx_stopped, and cancelling pending work, we know that the
requeue cannot occur, so all that's left is killing any pending urb.

Fixes: 0791c0327a6e ("net: mctp: Add MCTP USB transport driver")
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Link: https://patch.msgid.link/20260608-dev-mctp-usb-rx-requeue-v2-1-29a3aa507609@codeconstruct.com.au
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-usb.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/mctp/mctp-usb.c b/drivers/net/mctp/mctp-usb.c
index 3b5dff14417747..cf6f6a93a45112 100644
--- a/drivers/net/mctp/mctp-usb.c
+++ b/drivers/net/mctp/mctp-usb.c
@@ -22,7 +22,6 @@
 struct mctp_usb {
 	struct usb_device *usbdev;
 	struct usb_interface *intf;
-	bool stopped;
 
 	struct net_device *netdev;
 
@@ -32,6 +31,9 @@ struct mctp_usb {
 	struct urb *tx_urb;
 	struct urb *rx_urb;
 
+	/* enforces atomic access to rx_stopped and requeuing the retry work */
+	spinlock_t rx_lock;
+	bool rx_stopped;
 	struct delayed_work rx_retry_work;
 };
 
@@ -122,6 +124,7 @@ static const unsigned long RX_RETRY_DELAY = HZ / 4;
 
 static int mctp_usb_rx_queue(struct mctp_usb *mctp_usb, gfp_t gfp)
 {
+	unsigned long flags;
 	struct sk_buff *skb;
 	int rc;
 
@@ -147,7 +150,10 @@ static int mctp_usb_rx_queue(struct mctp_usb *mctp_usb, gfp_t gfp)
 	return rc;
 
 err_retry:
-	schedule_delayed_work(&mctp_usb->rx_retry_work, RX_RETRY_DELAY);
+	spin_lock_irqsave(&mctp_usb->rx_lock, flags);
+	if (!mctp_usb->rx_stopped)
+		schedule_delayed_work(&mctp_usb->rx_retry_work, RX_RETRY_DELAY);
+	spin_unlock_irqrestore(&mctp_usb->rx_lock, flags);
 	return rc;
 }
 
@@ -248,9 +254,6 @@ static void mctp_usb_rx_retry_work(struct work_struct *work)
 	struct mctp_usb *mctp_usb = container_of(work, struct mctp_usb,
 						 rx_retry_work.work);
 
-	if (READ_ONCE(mctp_usb->stopped))
-		return;
-
 	mctp_usb_rx_queue(mctp_usb, GFP_KERNEL);
 }
 
@@ -258,7 +261,7 @@ static int mctp_usb_open(struct net_device *dev)
 {
 	struct mctp_usb *mctp_usb = netdev_priv(dev);
 
-	WRITE_ONCE(mctp_usb->stopped, false);
+	WRITE_ONCE(mctp_usb->rx_stopped, false);
 
 	netif_start_queue(dev);
 
@@ -268,17 +271,21 @@ static int mctp_usb_open(struct net_device *dev)
 static int mctp_usb_stop(struct net_device *dev)
 {
 	struct mctp_usb *mctp_usb = netdev_priv(dev);
+	unsigned long flags;
 
 	netif_stop_queue(dev);
 
 	/* prevent RX submission retry */
-	WRITE_ONCE(mctp_usb->stopped, true);
+	spin_lock_irqsave(&mctp_usb->rx_lock, flags);
+	mctp_usb->rx_stopped = true;
+	cancel_delayed_work(&mctp_usb->rx_retry_work);
+	spin_unlock_irqrestore(&mctp_usb->rx_lock, flags);
+
+	flush_delayed_work(&mctp_usb->rx_retry_work);
 
 	usb_kill_urb(mctp_usb->rx_urb);
 	usb_kill_urb(mctp_usb->tx_urb);
 
-	cancel_delayed_work_sync(&mctp_usb->rx_retry_work);
-
 	return 0;
 }
 
@@ -331,6 +338,7 @@ static int mctp_usb_probe(struct usb_interface *intf,
 	dev->netdev = netdev;
 	dev->usbdev = interface_to_usbdev(intf);
 	dev->intf = intf;
+	spin_lock_init(&dev->rx_lock);
 	usb_set_intfdata(intf, dev);
 
 	dev->ep_in = ep_in->bEndpointAddress;
-- 
2.53.0



