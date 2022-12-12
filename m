Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACC828ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:51:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A42C433D2;
	Mon, 12 Dec 2022 13:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670853090;
	bh=cDNZWKlTuyYCb8XyZI8wd0mMCTaPUMwCU7yluAAaa4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tKR7evxiOS4V2knd1cQiKLWn+i9r/vKXyIqS5D63S+NF6q0ozT62FRuHoSGPzJTUs
	 6daIbXHeyUpkYYoAXxJqF4ov9GZ+U1Ku15VCe40kVCHe6MVYkwKsbhqnkN+8Z7X0kx
	 opjJAfv5ui0ZuDj4ITFau9YB47Wr/ffmAw4Gh3pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Jungclaus <frank.jungclaus@esd.eu>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 49/49] can: esd_usb: Allow REC and TEC to return to zero
Date: Mon, 12 Dec 2022 14:19:27 +0100
Message-Id: <20221212130916.109154029@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130913.666185567@linuxfoundation.org>
References: <20221212130913.666185567@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Frank Jungclaus <frank.jungclaus@esd.eu>

[ Upstream commit 918ee4911f7a41fb4505dff877c1d7f9f64eb43e ]

We don't get any further EVENT from an esd CAN USB device for changes
on REC or TEC while those counters converge to 0 (with ecc == 0). So
when handling the "Back to Error Active"-event force txerr = rxerr =
0, otherwise the berr-counters might stay on values like 95 forever.

Also, to make life easier during the ongoing development a
netdev_dbg() has been introduced to allow dumping error events send by
an esd CAN USB device.

Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
Link: https://lore.kernel.org/all/20221130202242.3998219-2-frank.jungclaus@esd.eu
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/esd_usb2.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index d4e6b40f0ed4..ffdee5aeb8a9 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -239,6 +239,10 @@ static void esd_usb2_rx_event(struct esd_usb2_net_priv *priv,
 		u8 rxerr = msg->msg.rx.data[2];
 		u8 txerr = msg->msg.rx.data[3];
 
+		netdev_dbg(priv->netdev,
+			   "CAN_ERR_EV_EXT: dlc=%#02x state=%02x ecc=%02x rec=%02x tec=%02x\n",
+			   msg->msg.rx.dlc, state, ecc, rxerr, txerr);
+
 		skb = alloc_can_err_skb(priv->netdev, &cf);
 		if (skb == NULL) {
 			stats->rx_dropped++;
@@ -265,6 +269,8 @@ static void esd_usb2_rx_event(struct esd_usb2_net_priv *priv,
 				break;
 			default:
 				priv->can.state = CAN_STATE_ERROR_ACTIVE;
+				txerr = 0;
+				rxerr = 0;
 				break;
 			}
 		} else {
-- 
2.35.1



