Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E18318131;
	Wed,  3 Dec 2025 15:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776895; cv=none; b=PIgyRmyn6CimwOFNt0GgdQ17TyMs7YhGa+Stl5ydrVQN8KJK7eFd/Cv+imc8xZs5ZN+KfVnxQ+MfhIVrFnNXsNFEKtNTmnOlPxOrhyzXdx1rtF+z8NE1xCn+euzqrAI14MqKGroEBaVpEBM0wlaqBXuMnlCpKCOa0e/WILTTAIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776895; c=relaxed/simple;
	bh=chDk7tYDTScLhpd3/Ulxj05Hc5CcRyCgnpNIGRBuQSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mICbr8jTgnr2sWSFlqljxjyPNH6mPXt/Wr3Nr10zaX+fNF9QgzgNBSM50xhkGm+apKKOEGlfqvEKmJJOLbJ75oO8h6nlc1ohfKN3edbXpk4RJMUF1CyRN1tL7gqEMclH8pgtgMMCCqvaHIKxgRKtVRLT0kYeRrqmatxG+o9Z0BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WEW02NmN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WEW02NmN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC28C4CEF5;
	Wed,  3 Dec 2025 15:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776895;
	bh=chDk7tYDTScLhpd3/Ulxj05Hc5CcRyCgnpNIGRBuQSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WEW02NmNmhH4wJxkkGgowAOMFABIoDWBof92J8dIJ8DdC5I6FAriXkmnbPVGcxlfR
	 Iwr6iIwWw9KhzG3It1Jn567LQYn/SbTpG6eeHwrRlAFHLKBLprmlH4ty3rg7uctb2F
	 34ZcvA0AhG4rb6w3v0vFpOYo1xQo4ISpdRI4Rgho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 002/146] can: gs_usb: gs_usb_xmit_callback(): fix handling of failed transmitted URBs
Date: Wed,  3 Dec 2025 16:26:20 +0100
Message-ID: <20251203152346.550648565@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 69b8d6da651bf..fa9bab8c89aea 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -750,8 +750,21 @@ static void gs_usb_xmit_callback(struct urb *urb)
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



