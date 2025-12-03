Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96582FD1D7;
	Wed,  3 Dec 2025 16:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780550; cv=none; b=ILKiGaa79KMpLhmRT0qLxkk0zWFiON+C5kyL1da/E5Vx6tXY09ZxNX0MPgIRfWUQ92dL9OljKn+8CEX2uyVCGywLHc4KQzFg+n3OtlO38Izun7/QUZTqi9Gih+ovi59b9bHba7JABkoRCwnD1wIH8rWXkczUBx5pO5xiwiZ8rAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780550; c=relaxed/simple;
	bh=7I94jGwYRrjsfJG9jt1Qfvq3q96OoNgZ8xGN7asFYLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2wnPdxhvJKauwxTsPniBLfxUy9NYJVEQ3UT2laH5R7BkpLTQTNIFTM8ukH5pmbFKBLRxB8kqzQNZVLYHkcv7CzwWBTE9oPpxxQg06g62UUjG6nhKNZzDBua+bvRo4XkJKsPsHG3YNUaSi/h+dAJfQSl95bCwEZTcjsAfuo/tl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=khlv9s9J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="khlv9s9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25833C4CEF5;
	Wed,  3 Dec 2025 16:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780550;
	bh=7I94jGwYRrjsfJG9jt1Qfvq3q96OoNgZ8xGN7asFYLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=khlv9s9JHAQ3UXVWdpOFG6tD3DlwKTOr3uxcL8+8/hhGE/f8N5cqL4+K3T1NgCoxr
	 /4S3gUS7hWZHs8ETZCsnEw+pokgb1kivdvV0K/P4xBz0jtqMFIFoEBZlPeoY0WRyiu
	 ERyQqkfxrRGj2+qTyVCy2A2V8045r7ZKKGdafiNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 002/132] can: gs_usb: gs_usb_xmit_callback(): fix handling of failed transmitted URBs
Date: Wed,  3 Dec 2025 16:28:01 +0100
Message-ID: <20251203152343.381338558@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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
index fb904dc28b8ee..fd34945d831e9 100644
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



