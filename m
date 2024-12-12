Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B55176AA1;
	Thu, 12 Dec 2024 17:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023044; cv=none; b=TRoFpGLDk/Z0QMxoqVh74aO/t6kOfbtA5ZFl1jP0NknNTU5DhnGxQpdYPCRmbO1TN4nfjKV9KQXaNCNi2MY/QNHiRe8S/tqb9MAvgZkY3i03/NU1K9SS68jHaKn8zG1e8KEiIjGF6wn+CnclW3vdrQ50WGJcPv2CMN/uImh5kA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023044; c=relaxed/simple;
	bh=OnDeUvkC/qU/0VrPupZP+Y2CMRKNfMSp603XnVF0pkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Is/segady48phpwUHfZBjZ/4UXDbSc8xZn7yY3I6JoQgLSMbgmmKLPGt/3D02zmzIo+VSGBw98edoCJNuWbakYrbWoysDxACVGNFjMGa+6BstUxRq16qs9Vn1y288EWVC1ccRHlTP2GhAjTViXzjU+4502acEbQvX9kuOpNMeOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=szhetlel; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="szhetlel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5431CC4CECE;
	Thu, 12 Dec 2024 17:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023043;
	bh=OnDeUvkC/qU/0VrPupZP+Y2CMRKNfMSp603XnVF0pkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=szhetlelKTuQGg25kMzgwJiT6Hw2jQIUJxs9sgTm85XnC92EGzJ0nzCwR0+Z+6juX
	 iRcYZRjbIcgMkRK2wHrRIzlKQWfJZ+y2tRtp/zDYLlUjznRcKoongVD7AY8hmaBUc8
	 e8CE3UCv9L9Y7x9914x3iLJ9+fBibLZ/CC2pe1Y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Marek Vasut <marex@denx.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 405/565] can: ifi_canfd: ifi_canfd_handle_lec_err(): fix {rx,tx}_errors statistics
Date: Thu, 12 Dec 2024 16:00:00 +0100
Message-ID: <20241212144327.667657343@linuxfoundation.org>
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

[ Upstream commit bb03d568bb21b4afe7935d1943bcf68ddea3ea45 ]

The ifi_canfd_handle_lec_err() function was incorrectly incrementing only
the receive error counter, even in cases of bit or acknowledgment errors
that occur during transmission.

Fix the issue by incrementing the appropriate counter based on the
type of error.

Fixes: 5bbd655a8bd0 ("can: ifi: Add more detailed error reporting")
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Reviewed-by: Marek Vasut <marex@denx.de>
Link: https://patch.msgid.link/20241122221650.633981-8-dario.binacchi@amarulasolutions.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/ifi_canfd/ifi_canfd.c | 58 ++++++++++++++++++---------
 1 file changed, 40 insertions(+), 18 deletions(-)

diff --git a/drivers/net/can/ifi_canfd/ifi_canfd.c b/drivers/net/can/ifi_canfd/ifi_canfd.c
index e8318e984bf2f..6a66d63f25c1d 100644
--- a/drivers/net/can/ifi_canfd/ifi_canfd.c
+++ b/drivers/net/can/ifi_canfd/ifi_canfd.c
@@ -393,36 +393,55 @@ static int ifi_canfd_handle_lec_err(struct net_device *ndev)
 		return 0;
 
 	priv->can.can_stats.bus_error++;
-	stats->rx_errors++;
 
 	/* Propagate the error condition to the CAN stack. */
 	skb = alloc_can_err_skb(ndev, &cf);
-	if (unlikely(!skb))
-		return 0;
 
 	/* Read the error counter register and check for new errors. */
-	cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
+	if (likely(skb))
+		cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
 
-	if (errctr & IFI_CANFD_ERROR_CTR_OVERLOAD_FIRST)
-		cf->data[2] |= CAN_ERR_PROT_OVERLOAD;
+	if (errctr & IFI_CANFD_ERROR_CTR_OVERLOAD_FIRST) {
+		stats->rx_errors++;
+		if (likely(skb))
+			cf->data[2] |= CAN_ERR_PROT_OVERLOAD;
+	}
 
-	if (errctr & IFI_CANFD_ERROR_CTR_ACK_ERROR_FIRST)
-		cf->data[3] = CAN_ERR_PROT_LOC_ACK;
+	if (errctr & IFI_CANFD_ERROR_CTR_ACK_ERROR_FIRST) {
+		stats->tx_errors++;
+		if (likely(skb))
+			cf->data[3] = CAN_ERR_PROT_LOC_ACK;
+	}
 
-	if (errctr & IFI_CANFD_ERROR_CTR_BIT0_ERROR_FIRST)
-		cf->data[2] |= CAN_ERR_PROT_BIT0;
+	if (errctr & IFI_CANFD_ERROR_CTR_BIT0_ERROR_FIRST) {
+		stats->tx_errors++;
+		if (likely(skb))
+			cf->data[2] |= CAN_ERR_PROT_BIT0;
+	}
 
-	if (errctr & IFI_CANFD_ERROR_CTR_BIT1_ERROR_FIRST)
-		cf->data[2] |= CAN_ERR_PROT_BIT1;
+	if (errctr & IFI_CANFD_ERROR_CTR_BIT1_ERROR_FIRST) {
+		stats->tx_errors++;
+		if (likely(skb))
+			cf->data[2] |= CAN_ERR_PROT_BIT1;
+	}
 
-	if (errctr & IFI_CANFD_ERROR_CTR_STUFF_ERROR_FIRST)
-		cf->data[2] |= CAN_ERR_PROT_STUFF;
+	if (errctr & IFI_CANFD_ERROR_CTR_STUFF_ERROR_FIRST) {
+		stats->rx_errors++;
+		if (likely(skb))
+			cf->data[2] |= CAN_ERR_PROT_STUFF;
+	}
 
-	if (errctr & IFI_CANFD_ERROR_CTR_CRC_ERROR_FIRST)
-		cf->data[3] = CAN_ERR_PROT_LOC_CRC_SEQ;
+	if (errctr & IFI_CANFD_ERROR_CTR_CRC_ERROR_FIRST) {
+		stats->rx_errors++;
+		if (likely(skb))
+			cf->data[3] = CAN_ERR_PROT_LOC_CRC_SEQ;
+	}
 
-	if (errctr & IFI_CANFD_ERROR_CTR_FORM_ERROR_FIRST)
-		cf->data[2] |= CAN_ERR_PROT_FORM;
+	if (errctr & IFI_CANFD_ERROR_CTR_FORM_ERROR_FIRST) {
+		stats->rx_errors++;
+		if (likely(skb))
+			cf->data[2] |= CAN_ERR_PROT_FORM;
+	}
 
 	/* Reset the error counter, ack the IRQ and re-enable the counter. */
 	writel(IFI_CANFD_ERROR_CTR_ER_RESET, priv->base + IFI_CANFD_ERROR_CTR);
@@ -430,6 +449,9 @@ static int ifi_canfd_handle_lec_err(struct net_device *ndev)
 	       priv->base + IFI_CANFD_INTERRUPT);
 	writel(IFI_CANFD_ERROR_CTR_ER_ENABLE, priv->base + IFI_CANFD_ERROR_CTR);
 
+	if (unlikely(!skb))
+		return 0;
+
 	netif_receive_skb(skb);
 
 	return 1;
-- 
2.43.0



