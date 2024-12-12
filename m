Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61C52080FC;
	Thu, 12 Dec 2024 15:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015739; cv=none; b=DXJRNhllzBfdjI4a2IS0/TZa8PjC0izLSHN0H6VkMigkl3oZvQ+4cMI6mSzhiFdNxg3Pn8E0VcwR59DdI16JuJHotmAz+1gr5bn9F4Z49ql3qQp9JDbrXcKNIn4HQvacpeKlVEhuu7Cq/w18O/w2XgZPmYGppxGMcxwH9PnpsMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015739; c=relaxed/simple;
	bh=KH2sxKWJq/kxh1YpWBzgXoWixfAfdGSFVcKqZUxW6F4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bT+nO2hAqaWZirroyn0PFxBYog3BwidKS5gRjtttkj07W0+vUaRquQrdreCkVnBvoPKS0VLi6wSZvA50z5PX5NANkCCBXQoOimrYP94l2OnlzPsStxwkAI8IKkbNm1kC0E7qvcExCWg/liPkX++TQ3igQRccJ9c2mIj+q4OQqFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nlGyLbR7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlGyLbR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C85C4CECE;
	Thu, 12 Dec 2024 15:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015739;
	bh=KH2sxKWJq/kxh1YpWBzgXoWixfAfdGSFVcKqZUxW6F4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlGyLbR78Ta1QDvVGWrVsv3P9BcGB56EOyphyQp0tHqZwRFuAcsgDAz1QVlCaeoY7
	 7FtdXYX+pM283/elmaSl11X6dLpL1zt+SI/YxZeZlBw7QeRSnm3ACBBn+vQUz8rR4Z
	 d5pH5xpjPW3OBs45e01FgLiXckRVDzaWMPdeR+Ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/466] can: m_can: m_can_handle_lec_err(): fix {rx,tx}_errors statistics
Date: Thu, 12 Dec 2024 15:52:58 +0100
Message-ID: <20241212144307.034955962@linuxfoundation.org>
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
index 16e9e7d7527d9..533bcb77c9f93 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -695,47 +695,60 @@ static int m_can_handle_lec_err(struct net_device *dev,
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



