Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AED1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BE9C433D2;
	Wed, 28 Dec 2022 15:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241453;
	bh=ea7/DX0DUqreOuWBiXYFkHJIeizsMAwd2iDKksw/lYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ihHMNeywr83Lwi72ksTNHQlrEBlf11zR58l0mMaCONAE6eqtpMJgvOW+qghrKGHDs
	 nThCR197Rk7ASkEdyuJAS7KIRcPkFKgi8n22IFtNIoDFMnYDAAMeSP+RQgrf8JMzLj
	 ZgjsvY8zSGOG9iuRlO9jKgcbQMb4pTQwV0drcrlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jimmy Assarsson <extja@kvaser.com>,
	Anssi Hannula <anssi.hannula@bitwise.fi>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0248/1146] can: kvaser_usb_leaf: Set Warning state even without bus errors
Date: Wed, 28 Dec 2022 15:29:47 +0100
Message-Id: <20221228144336.871877825@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Anssi Hannula <anssi.hannula@bitwise.fi>

[ Upstream commit df1b7af2761b935f63b4a53e789d41ed859edf61 ]

kvaser_usb_leaf_rx_error_update_can_state() sets error state according
to error counters when the hardware does not indicate a specific state
directly.

However, this is currently gated behind a check for
M16C_STATE_BUS_ERROR which does not always seem to be set when error
counters are increasing, and may not be set when error counters are
decreasing.

This causes the CAN_STATE_ERROR_WARNING state to not be set in some
cases even when appropriate.

Change the code to set error state from counters even without
M16C_STATE_BUS_ERROR.

The Error-Passive case seems superfluous as it is already set via
M16C_STATE_BUS_PASSIVE flag above, but it is kept for now.

Tested with 0bfd:0124 Kvaser Mini PCI Express 2xHS FW 4.18.778.

Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
Tested-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/all/20221010185237.319219-6-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 20 ++++++++-----------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 5d96ab85d04c..a6a26085bc15 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -961,20 +961,16 @@ kvaser_usb_leaf_rx_error_update_can_state(struct kvaser_usb_net_priv *priv,
 		new_state = CAN_STATE_BUS_OFF;
 	} else if (es->status & M16C_STATE_BUS_PASSIVE) {
 		new_state = CAN_STATE_ERROR_PASSIVE;
-	} else if (es->status & M16C_STATE_BUS_ERROR) {
+	} else if ((es->status & M16C_STATE_BUS_ERROR) &&
+		   cur_state >= CAN_STATE_BUS_OFF) {
 		/* Guard against spurious error events after a busoff */
-		if (cur_state < CAN_STATE_BUS_OFF) {
-			if (es->txerr >= 128 || es->rxerr >= 128)
-				new_state = CAN_STATE_ERROR_PASSIVE;
-			else if (es->txerr >= 96 || es->rxerr >= 96)
-				new_state = CAN_STATE_ERROR_WARNING;
-			else if (cur_state > CAN_STATE_ERROR_ACTIVE)
-				new_state = CAN_STATE_ERROR_ACTIVE;
-		}
-	}
-
-	if (!es->status)
+	} else if (es->txerr >= 128 || es->rxerr >= 128) {
+		new_state = CAN_STATE_ERROR_PASSIVE;
+	} else if (es->txerr >= 96 || es->rxerr >= 96) {
+		new_state = CAN_STATE_ERROR_WARNING;
+	} else {
 		new_state = CAN_STATE_ERROR_ACTIVE;
+	}
 
 	if (new_state != cur_state) {
 		tx_state = (es->txerr >= es->rxerr) ? new_state : 0;
-- 
2.35.1



