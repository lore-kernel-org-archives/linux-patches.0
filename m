Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1978E200A5
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:36:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FCAC433C8;
	Tue,  1 Aug 2023 09:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882588;
	bh=IL+VdK/5jPyUbaMo+pUBujrTQsAS5CMhpEHn3I2e+dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=psFQnhYw6BE31CEyBr0GOKI47PGlw2wmwwCWqBHsP0T47HmNXvJj+wic4yxl2vi/F
	 d1TcUA7SzV6OQkSSlmMPBsjhm4VzNe2ccgCcJZhaX3pJRfozwANqq6oXnRYwZoxGS/
	 IOZumZvmrKHJAcb1SrNRbij9kPSdoPeHAnY53AX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 160/228] can: gs_usb: gs_can_close(): add missing set of CAN state to CAN_STATE_STOPPED
Date: Tue,  1 Aug 2023 11:20:18 +0200
Message-ID: <20230801091928.664205744@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit f8a2da6ec2417cca169fa85a8ab15817bccbb109 upstream.

After an initial link up the CAN device is in ERROR-ACTIVE mode. Due
to a missing CAN_STATE_STOPPED in gs_can_close() it doesn't change to
STOPPED after a link down:

| ip link set dev can0 up
| ip link set dev can0 down
| ip --details link show can0
| 13: can0: <NOARP,ECHO> mtu 16 qdisc pfifo_fast state DOWN mode DEFAULT group default qlen 10
|     link/can  promiscuity 0 allmulti 0 minmtu 0 maxmtu 0
|     can state ERROR-ACTIVE restart-ms 1000

Add missing assignment of CAN_STATE_STOPPED in gs_can_close().

Cc: stable@vger.kernel.org
Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN devices")
Link: https://lore.kernel.org/all/20230718-gs_usb-fix-can-state-v1-1-f19738ae2c23@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/gs_usb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -989,6 +989,8 @@ static int gs_can_close(struct net_devic
 	usb_kill_anchored_urbs(&dev->tx_submitted);
 	atomic_set(&dev->active_tx_urbs, 0);
 
+	dev->can.state = CAN_STATE_STOPPED;
+
 	/* reset the device */
 	rc = gs_cmd_reset(dev);
 	if (rc < 0)


