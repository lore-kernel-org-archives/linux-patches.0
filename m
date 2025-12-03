Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C9435773A;
	Wed,  3 Dec 2025 16:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780991; cv=none; b=RwRKBki4c4HcVo3QoSnDK4p1a9NS/WpBPPU3siBrZIpJF9gEl5ywqfM2eoIf3ogJVehy8P8X3ahvsiFHQ8OFgvvSGxgue+FTTgdu8G/Qz7ODcHTh9guD0hRZhoKFLFT9FT6kA7a/ymUH91mniMJempLCt98ikWUyjTzKZA19f8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780991; c=relaxed/simple;
	bh=kyu61827eusv7o+Xc5WCxvmxgEB1RyUjVTr00biKF0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNMixEpWg4YQuCYG944su/m7JMXAfaflR1Z9wOABguzQ6HuS0CIpgVmpRjTNKWpzBP0/Zm1YHnhFCPOWle8D76i4QCKFEwIndHfu4FZxmuJmgvZIn4sFnxyKoTF1d1t2C4DDJzi6WermXK1ybtiqxGsK8qq1CKWkIcZ/XNO8tQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xjnzb76z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xjnzb76z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B74C4CEF5;
	Wed,  3 Dec 2025 16:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780990;
	bh=kyu61827eusv7o+Xc5WCxvmxgEB1RyUjVTr00biKF0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xjnzb76z8mqTncjb62XF+XLnCc9Kb27qiNS0eO6fpCZAmfCpdXdrGD8QhnjHsvqe4
	 njilTeAFzSyxcxiv5OwlA0LWsksLEOdfda4V1hiHBulNg9JCpesXJxbICSxUHWrMOg
	 Xe2h1JcW+QpdGoOShn0JqwiVqJ7SpiUIAG2ZMY2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 02/93] can: gs_usb: gs_usb_xmit_callback(): fix handling of failed transmitted URBs
Date: Wed,  3 Dec 2025 16:28:55 +0100
Message-ID: <20251203152336.589978347@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 516a0cd1c03fa266bb67dd87940a209fd4e53ce7 ]

The driver lacks the cleanup of failed transfers of URBs. This reduces the
number of available URBs per error by 1. This leads to reduced performance
and ultimately to a complete stop of the transmission.

If the sending of a bulk URB fails do proper cleanup:
- increase netdev stats
- mark the echo_sbk as free
- free the driver's context and do accounting
- wake the send queue

Closes: https://github.com/candle-usb/candleLight_fw/issues/187
Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN devices")
Link: https://patch.msgid.link/20251114-gs_usb-fix-usb-callbacks-v1-1-a29b42eacada@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/gs_usb.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 9bd61fd8e5013..1ba6395a5a667 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -747,8 +747,21 @@ static void gs_usb_xmit_callback(struct urb *urb)
 	struct gs_can *dev = txc->dev;
 	struct net_device *netdev = dev->netdev;
 
-	if (urb->status)
-		netdev_info(netdev, "usb xmit fail %u\n", txc->echo_id);
+	if (!urb->status)
+		return;
+
+	if (urb->status != -ESHUTDOWN && net_ratelimit())
+		netdev_info(netdev, "failed to xmit URB %u: %pe\n",
+			    txc->echo_id, ERR_PTR(urb->status));
+
+	netdev->stats.tx_dropped++;
+	netdev->stats.tx_errors++;
+
+	can_free_echo_skb(netdev, txc->echo_id, NULL);
+	gs_free_tx_context(txc);
+	atomic_dec(&dev->active_tx_urbs);
+
+	netif_wake_queue(netdev);
 }
 
 static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
-- 
2.51.0



