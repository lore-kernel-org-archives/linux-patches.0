Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81896846C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5A1C433D2;
	Fri, 10 Mar 2023 14:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458719;
	bh=2NwVWmCApKFq+wySqKOGkZbZSuZ2ZIWdxnJiHPo6NmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gbm+sHE6CgxgmFc+4m1+c6nM8P/RczdbYfPJJ6HQd7LyS5SbUxGeOyqdIjhyDG1xH
	 hZVVG2ktsqj2l9dsPgx0WpG1zmUTFlZptbR1wiTLEJqWwTY3gxbGX1CtXEf0xSDGjk
	 guDfbg5uBZXrAXaRrlaAzRiaw6Ae8dQsNtU8d4qU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Jungclaus <frank.jungclaus@esd.eu>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/357] can: esd_usb: Move mislocated storage of SJA1000_ECC_SEG bits in case of a bus error
Date: Fri, 10 Mar 2023 14:36:20 +0100
Message-Id: <20230310133738.023229837@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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

[ Upstream commit 118469f88180438ef43dee93d71f77c00e7b425d ]

Move the supply for cf->data[3] (bit stream position of CAN error), in
case of a bus- or protocol-error, outside of the "switch (ecc &
SJA1000_ECC_MASK){}"-statement, because this bit stream position is
independent of the error type.

Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
Link: https://lore.kernel.org/all/20230216190450.3901254-2-frank.jungclaus@esd.eu
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/esd_usb2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index 73c5343e609bc..c9ccce6c60b46 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -278,7 +278,6 @@ static void esd_usb2_rx_event(struct esd_usb2_net_priv *priv,
 				cf->data[2] |= CAN_ERR_PROT_STUFF;
 				break;
 			default:
-				cf->data[3] = ecc & SJA1000_ECC_SEG;
 				break;
 			}
 
@@ -286,6 +285,9 @@ static void esd_usb2_rx_event(struct esd_usb2_net_priv *priv,
 			if (!(ecc & SJA1000_ECC_DIR))
 				cf->data[2] |= CAN_ERR_PROT_TX;
 
+			/* Bit stream position in CAN frame as the error was detected */
+			cf->data[3] = ecc & SJA1000_ECC_SEG;
+
 			if (priv->can.state == CAN_STATE_ERROR_WARNING ||
 			    priv->can.state == CAN_STATE_ERROR_PASSIVE) {
 				cf->data[1] = (txerr > rxerr) ?
-- 
2.39.2



