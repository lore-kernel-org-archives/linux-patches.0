Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEF4209F27;
	Thu, 12 Dec 2024 15:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015677; cv=none; b=ZsRHWAtmdSv4GNsboWL6jVg5zmw0t+KLow0nIb+gILCtH27yzkX6HRyZFT/JnO33KECr0I+63bN2F5u9EY7pMcIhU8sviMF+mQHU/kM7tx4VjZj+Cy4ocCRXqRj+SkmDtrXu3RTFu6DzG2RsGreVy3WAGH/gRxaQFyX9x3o6ySg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015677; c=relaxed/simple;
	bh=HPGA72MuhH19vVjZBqE/eIEUGuTp5/JmVcQuMsZhz8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIvATw4gMqqnL3tM0BAMRnCrc2HYvGhN8J1aOtkHTTbPjEG+PbVV+PjBDrRGdpnJbkNqcIgk3qoOffyHrke7eJfX61nGoeY0xzzVzd4YM9Aw2u2MQ4cJZlEbINWv2E6Ven7qWdxD9mVtgtz1JRIj3NvJ6Ci9rr5UIIoPiowOE1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDK8p3tZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDK8p3tZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43665C4CECE;
	Thu, 12 Dec 2024 15:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015676;
	bh=HPGA72MuhH19vVjZBqE/eIEUGuTp5/JmVcQuMsZhz8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDK8p3tZuOzD4h5qndmV3y3LLnQZMy5CILkhxa1xVTILB2J3ukoxGDcNzLYdnIGBS
	 /yka/1ktc4j3anCXUI2amyS+l2hBRWLRe8tVpJ1b4/aaq562Xk0vLCwWPSevwst+Qq
	 Mo266lD4yDR9St+cIAsrs0fK9hgxVneCLaLjIbD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/466] can: f81604: f81604_handle_can_bus_errors(): fix {rx,tx}_errors statistics
Date: Thu, 12 Dec 2024 15:53:04 +0100
Message-ID: <20241212144307.289590206@linuxfoundation.org>
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

[ Upstream commit d7b916540c2ba3d2a88c27b2a6287b39d8eac052 ]

The f81604_handle_can_bus_errors() function only incremented the receive
error counter and never the transmit error counter, even if the ECC_DIR
flag reported that an error had occurred during transmission.

Increment the receive/transmit error counter based on the value of the
ECC_DIR flag.

Fixes: 88da17436973 ("can: usb: f81604: add Fintek F81604 support")
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Link: https://patch.msgid.link/20241122221650.633981-13-dario.binacchi@amarulasolutions.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/f81604.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/usb/f81604.c b/drivers/net/can/usb/f81604.c
index bc0c8903fe779..e0cfa1460b0b8 100644
--- a/drivers/net/can/usb/f81604.c
+++ b/drivers/net/can/usb/f81604.c
@@ -526,7 +526,6 @@ static void f81604_handle_can_bus_errors(struct f81604_port_priv *priv,
 		netdev_dbg(netdev, "bus error interrupt\n");
 
 		priv->can.can_stats.bus_error++;
-		stats->rx_errors++;
 
 		if (skb) {
 			cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
@@ -548,10 +547,15 @@ static void f81604_handle_can_bus_errors(struct f81604_port_priv *priv,
 
 			/* set error location */
 			cf->data[3] = data->ecc & F81604_SJA1000_ECC_SEG;
+		}
 
-			/* Error occurred during transmission? */
-			if ((data->ecc & F81604_SJA1000_ECC_DIR) == 0)
+		/* Error occurred during transmission? */
+		if ((data->ecc & F81604_SJA1000_ECC_DIR) == 0) {
+			stats->tx_errors++;
+			if (skb)
 				cf->data[2] |= CAN_ERR_PROT_TX;
+		} else {
+			stats->rx_errors++;
 		}
 
 		set_bit(F81604_CLEAR_ECC, &priv->clear_flags);
-- 
2.43.0



