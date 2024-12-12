Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C56D2EAE5;
	Thu, 12 Dec 2024 15:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015729; cv=none; b=SCLQuNans+AsMta+2XzIfEV0VahbxvOXyM3qs6XowwN8ptZpvayu58u4NwyTg9+LXokH/x3oLVD243+1LhnR0ZGrgpRcYZju3LiB4VgG95Z2AUSM1PZIg45Jy+9pSAotogNHX5RliabA2603UwBnpQ5Ecgz3LS7ogT5ZoIMVgrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015729; c=relaxed/simple;
	bh=8eWgrFXTw/7EGihvHVxQdkb/cw3SSif3/6Q1A82f1uM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qL1LgbdkwHU4ECFijDjABMadR+yhNUYLMtjH7ep0RNSqpiUdHGonFyub5LJLsP/HsUT2sHQQlqu2YrA8ZaKDOSEP07IcJ22dgGudvHuF9QcY3huNcXesn7+44+oJ+nYS4FC9E1Z61rzKzaWnWCKz5Z4/7d6ha2+vorokel+3GNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ktsClGLT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ktsClGLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48389C4CECE;
	Thu, 12 Dec 2024 15:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015728;
	bh=8eWgrFXTw/7EGihvHVxQdkb/cw3SSif3/6Q1A82f1uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ktsClGLTRbJxvqKPGffEyOzeFKygGfEGUPW7CDgS7XFlxSFNH+zT27M04mMUnxxV3
	 d+0hUPACoJ5sj6t6VAfet3vZ4cnV0fj4QIetyZmpOY4WzuaeJcYJQL/0QTh+taXrjt
	 TGlbMOLLuAGDDcGF5IIbHluMJxV8DqREG2XpKDM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 006/466] can: c_can: c_can_handle_bus_err(): update statistics if skb allocation fails
Date: Thu, 12 Dec 2024 15:52:55 +0100
Message-ID: <20241212144306.916192015@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

[ Upstream commit 9e66242504f49e17481d8e197730faba7d99c934 ]

Ensure that the statistics are always updated, even if the skb
allocation fails.

Fixes: 4d6d26537940 ("can: c_can: fix {rx,tx}_errors statistics")
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Link: https://patch.msgid.link/20241122221650.633981-2-dario.binacchi@amarulasolutions.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/c_can/c_can_main.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/can/c_can/c_can_main.c b/drivers/net/can/c_can/c_can_main.c
index 511615dc33419..cc371d0c9f3c7 100644
--- a/drivers/net/can/c_can/c_can_main.c
+++ b/drivers/net/can/c_can/c_can_main.c
@@ -1014,49 +1014,57 @@ static int c_can_handle_bus_err(struct net_device *dev,
 
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
+		if (likely(skb))
+			cf->data[2] |= CAN_ERR_PROT_STUFF;
 		stats->rx_errors++;
 		break;
 	case LEC_FORM_ERROR:
 		netdev_dbg(dev, "form error\n");
-		cf->data[2] |= CAN_ERR_PROT_FORM;
+		if (likely(skb))
+			cf->data[2] |= CAN_ERR_PROT_FORM;
 		stats->rx_errors++;
 		break;
 	case LEC_ACK_ERROR:
 		netdev_dbg(dev, "ack error\n");
-		cf->data[3] = CAN_ERR_PROT_LOC_ACK;
+		if (likely(skb))
+			cf->data[3] = CAN_ERR_PROT_LOC_ACK;
 		stats->tx_errors++;
 		break;
 	case LEC_BIT1_ERROR:
 		netdev_dbg(dev, "bit1 error\n");
-		cf->data[2] |= CAN_ERR_PROT_BIT1;
+		if (likely(skb))
+			cf->data[2] |= CAN_ERR_PROT_BIT1;
 		stats->tx_errors++;
 		break;
 	case LEC_BIT0_ERROR:
 		netdev_dbg(dev, "bit0 error\n");
-		cf->data[2] |= CAN_ERR_PROT_BIT0;
+		if (likely(skb))
+			cf->data[2] |= CAN_ERR_PROT_BIT0;
 		stats->tx_errors++;
 		break;
 	case LEC_CRC_ERROR:
 		netdev_dbg(dev, "CRC error\n");
-		cf->data[3] = CAN_ERR_PROT_LOC_CRC_SEQ;
+		if (likely(skb))
+			cf->data[3] = CAN_ERR_PROT_LOC_CRC_SEQ;
 		stats->rx_errors++;
 		break;
 	default:
 		break;
 	}
 
+	if (unlikely(!skb))
+		return 0;
+
 	netif_receive_skb(skb);
 	return 1;
 }
-- 
2.43.0



