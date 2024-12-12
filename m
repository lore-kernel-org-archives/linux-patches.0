Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30D7176AA1;
	Thu, 12 Dec 2024 17:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023040; cv=none; b=oVd6PYPtkAYbtohLIe1p1oOMmaNFu8uPOaJpK8MmiphYvx2Vr3qhqaSuhV+ZMujBIoNACIFp56B0vz8Ei1r/o3yRPg4+0zbVGZZfNYM/XcNVwbJ/rou2RqHl2r7Ee0NzamBk4ycNjm3HwcB7pBk3pUouAhljn0m1KWn/NcxPyBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023040; c=relaxed/simple;
	bh=3EB7hgkmG+HysZqHjCGHau9geX/i+glwE5lpenQ4Twc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dAYCM4MCNnAYWZx4iJk6qwpcc7REkB+b32LJXT6cVPW52xCXJHIKp3NQSRSh9e+w14HyiyNtENIxqpkN18qqeJCh2R70kb0jpnhneyI4F9+FbdWTXOqRwI9fFR/J+xG12rWMfKJKNxMGzyU8KMCRwhikYO17pzHeynoRGo/51Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UixLqmJ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UixLqmJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292B1C4CED0;
	Thu, 12 Dec 2024 17:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023040;
	bh=3EB7hgkmG+HysZqHjCGHau9geX/i+glwE5lpenQ4Twc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UixLqmJ/JLUMIZazKkbAsySub+TMrYFNnPi5BaHRDSiTlxyTR4z83hn2X1TBz0qYs
	 JquV3r/+mNDESdfoImosroPMi2uzCVmZSqIuokt3y963d8Qo8yNUA2fNXyCiQbLIM0
	 8Jnt33qX6C80IIIlQVfBLSbFYgOWDBOQ8sz+VbM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 404/565] can: m_can: m_can_handle_lec_err(): fix {rx,tx}_errors statistics
Date: Thu, 12 Dec 2024 15:59:59 +0100
Message-ID: <20241212144327.628575700@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

[ Upstream commit 988d4222bf9039a875a3d48f2fe35c317831ff68 ]

The m_can_handle_lec_err() function was incorrectly incrementing only the
receive error counter, even in cases of bit or acknowledgment errors that
occur during transmission.

Fix the issue by incrementing the appropriate counter based on the
type of error.

Fixes: e0d1f4816f2a ("can: m_can: add Bosch M_CAN controller support")
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Link: https://patch.msgid.link/20241122221650.633981-7-dario.binacchi@amarulasolutions.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index abc3907feb739..a4edd7ab37eb2 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -612,47 +612,60 @@ static int m_can_handle_lec_err(struct net_device *dev,
 	u32 timestamp = 0;
 
 	cdev->can.can_stats.bus_error++;
-	stats->rx_errors++;
 
 	/* propagate the error condition to the CAN stack */
 	skb = alloc_can_err_skb(dev, &cf);
-	if (unlikely(!skb))
-		return 0;
 
 	/* check for 'last error code' which tells us the
 	 * type of the last error to occur on the CAN bus
 	 */
-	cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
+	if (likely(skb))
+		cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
 
 	switch (lec_type) {
 	case LEC_STUFF_ERROR:
 		netdev_dbg(dev, "stuff error\n");
-		cf->data[2] |= CAN_ERR_PROT_STUFF;
+		stats->rx_errors++;
+		if (likely(skb))
+			cf->data[2] |= CAN_ERR_PROT_STUFF;
 		break;
 	case LEC_FORM_ERROR:
 		netdev_dbg(dev, "form error\n");
-		cf->data[2] |= CAN_ERR_PROT_FORM;
+		stats->rx_errors++;
+		if (likely(skb))
+			cf->data[2] |= CAN_ERR_PROT_FORM;
 		break;
 	case LEC_ACK_ERROR:
 		netdev_dbg(dev, "ack error\n");
-		cf->data[3] = CAN_ERR_PROT_LOC_ACK;
+		stats->tx_errors++;
+		if (likely(skb))
+			cf->data[3] = CAN_ERR_PROT_LOC_ACK;
 		break;
 	case LEC_BIT1_ERROR:
 		netdev_dbg(dev, "bit1 error\n");
-		cf->data[2] |= CAN_ERR_PROT_BIT1;
+		stats->tx_errors++;
+		if (likely(skb))
+			cf->data[2] |= CAN_ERR_PROT_BIT1;
 		break;
 	case LEC_BIT0_ERROR:
 		netdev_dbg(dev, "bit0 error\n");
-		cf->data[2] |= CAN_ERR_PROT_BIT0;
+		stats->tx_errors++;
+		if (likely(skb))
+			cf->data[2] |= CAN_ERR_PROT_BIT0;
 		break;
 	case LEC_CRC_ERROR:
 		netdev_dbg(dev, "CRC error\n");
-		cf->data[3] = CAN_ERR_PROT_LOC_CRC_SEQ;
+		stats->rx_errors++;
+		if (likely(skb))
+			cf->data[3] = CAN_ERR_PROT_LOC_CRC_SEQ;
 		break;
 	default:
 		break;
 	}
 
+	if (unlikely(!skb))
+		return 0;
+
 	if (cdev->is_peripheral)
 		timestamp = m_can_get_timestamp(cdev);
 
-- 
2.43.0



