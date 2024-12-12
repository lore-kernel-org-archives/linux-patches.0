Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50760222D59;
	Thu, 12 Dec 2024 17:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025592; cv=none; b=bMCgeM0pJmyUGGoRjZ2x8hT5EC9BeWf+RzJhdSZYwv+JVIoCEPGHB0LD0NCqdSqJMSPbhmpybyiU95c/V2pNbZxIjDmtLOuGz4gNEt1f+yvOU4CcWcg8G/PGCsZELKd5slYyeTB0I25Ygemt/TRIjUUf59Eue9qdVG0jJvAhWoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025592; c=relaxed/simple;
	bh=+CVOWJEybh3oDyZCx9DWeKYMwQ3bABCGOwqk7EolnkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XAEKnuIYfFS6kWW3gBx/w1bjfPs1crzqznoqTD7I/BD4UedDWi2O6n5tHm90XFXPwO7i594Y3Zf3J9vqQm7vXUYUy2lWUj3iLRzaDPRjAoWJHs2/gBjJsAYIyEJGT6GZ036ifcYgDB03B5jwWo/tFn5gmc9Jq87l18QoHZKHV/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R12bcIkJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R12bcIkJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81294C4CECE;
	Thu, 12 Dec 2024 17:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025590;
	bh=+CVOWJEybh3oDyZCx9DWeKYMwQ3bABCGOwqk7EolnkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R12bcIkJZXBRJpxJv5wYc5WCtSd8fYJ5orFpTfYT2zp458Jf+cKjVYCErZspFeIRJ
	 bF7dbQuNhe9Ph/4yVDE289/kigBUqj/Upx7c20PIeb/S9MASCQJEB6TxqFUgUDA5r6
	 CTmy3+H6Km+XZGGgqU+rUUYu0CTYLx21abqSdlhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 221/321] can: sun4i_can: sun4i_can_err(): call can_change_state() even if cf is NULL
Date: Thu, 12 Dec 2024 16:02:19 +0100
Message-ID: <20241212144238.707861105@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

[ Upstream commit ee6bf3677ae03569d833795064e17f605c2163c7 ]

Call the function can_change_state() if the allocation of the skb
fails, as it handles the cf parameter when it is null.

Additionally, this ensures that the statistics related to state error
counters (i. e. warning, passive, and bus-off) are updated.

Fixes: 0738eff14d81 ("can: Allwinner A10/A20 CAN Controller support - Kernel module")
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Link: https://patch.msgid.link/20241122221650.633981-3-dario.binacchi@amarulasolutions.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/sun4i_can.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/sun4i_can.c b/drivers/net/can/sun4i_can.c
index c519b6f63b33a..d627fb2948be8 100644
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -614,10 +614,10 @@ static int sun4i_can_err(struct net_device *dev, u8 isrc, u8 status)
 		tx_state = txerr >= rxerr ? state : 0;
 		rx_state = txerr <= rxerr ? state : 0;
 
-		if (likely(skb))
-			can_change_state(dev, cf, tx_state, rx_state);
-		else
-			priv->can.state = state;
+		/* The skb allocation might fail, but can_change_state()
+		 * handles cf == NULL.
+		 */
+		can_change_state(dev, cf, tx_state, rx_state);
 		if (state == CAN_STATE_BUS_OFF)
 			can_bus_off(dev);
 	}
-- 
2.43.0



