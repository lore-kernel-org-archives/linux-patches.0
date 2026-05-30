Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486A521B191;
	Sat, 30 May 2026 17:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163083; cv=none; b=ni5uu6vdxUR7VWENA/em9MNnPMgtl12c6WchWVZV/Hdi3f7KndpDzFvCXCDuhTWILBWwybociwNuvmKiMP93EYj3Z8xCNX8qe02wUhJFzLm1P7i30u1r9ySHWwG2CL6FzLWq7beFzaCkDCDA8kWOU1DDd8MW1WvthLDrVtiExZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163083; c=relaxed/simple;
	bh=X5z+pdsyRLu9GljFKRbu3jPd486WVOF2baUP3GGPPak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrkCD0lorx4VhUnd5HTzT47sX/Kh82ldZwnaA1duPQEEdOk/2ONwokC47JU2fBfOukVdU2diviXVAaV8hlTpFChZxG9YHYMk9H0J3u2qmZuIz8mvIvlOVntpZtZqPp62RhXLbBAG9Vm2LCeNnUSsaaTqyqBYGMsR/qfmFzVEgLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lpwSGN0z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lpwSGN0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1731F00893;
	Sat, 30 May 2026 17:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163082;
	bh=33d6Hl4tveScE8+AatM5F8hcEU6mz4785QqW/hqxBic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lpwSGN0zzY9OXVq7KtBkSiDMZSRoSFyCBDXbjMCLdnh7IiKUrN72VSMb93puoBQ/6
	 6HhYQ2XxOyA9McAZen6jQSoJqYRENDBGBLek7ZLtCAyj+hGG0QX4YidR2V8U7rEoc2
	 oQrHGckWHM3GQCf2INe5I3GYYNXB3yg2qppaqOWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Charles Xu <charles_xu@189.cn>
Subject: [PATCH 5.15 149/776] can: gs_usb: gs_usb_xmit_callback(): fix handling of failed transmitted URBs
Date: Sat, 30 May 2026 17:57:43 +0200
Message-ID: <20260530160244.305397364@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Charles Xu <charles_xu@189.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/gs_usb.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -467,8 +467,21 @@ static void gs_usb_xmit_callback(struct
 	struct gs_can *dev = txc->dev;
 	struct net_device *netdev = dev->netdev;
 
-	if (urb->status)
-		netdev_info(netdev, "usb xmit fail %d\n", txc->echo_id);
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
 
 	usb_free_coherent(urb->dev,
 			  urb->transfer_buffer_length,


