Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABB22135C1;
	Thu, 12 Dec 2024 15:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017503; cv=none; b=nPPYwxZa/6Zp6THEyPsi9PGJpg4rLuhbBdJ4mgBD3oDjdWiIO2ujFOB8azXUviIUiSWBm3Nl91sdRQV9luXPughzTWBY7VOIWc1IdYvqr/OPLvQcIzcbzIHytzEVPO6vq0fv1LVupITykkd7cwIb90Ptc0VocSj+kqbOJom4DH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017503; c=relaxed/simple;
	bh=X6G81xybd5pUf+yzAKk6y82d0wPcM3oV1k5LJHd7NHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1f3PPawi4vJqeBK6MqUEpoUsI3CePkwl0s/Tvt6nMiyx5/c+0q9FiygAwXRTUVIAalTnG1oTmzjE33nYmy8nMwXN8gATkuEmxx1tfArXyliLJDyAtcpnqzJn9hHUqVdZtK25+y96AOa8Am+2moqpWwSyRRVnUtJyIsl7+b+Enk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=glIPbyyS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="glIPbyyS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625EFC4CED4;
	Thu, 12 Dec 2024 15:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017502;
	bh=X6G81xybd5pUf+yzAKk6y82d0wPcM3oV1k5LJHd7NHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=glIPbyyS+phNw5rBbsil83udCPXgR9JnSsb1KaIQ4OVdkkdhxdN5wg+GapnaOxbUL
	 wfl+LyNh8JIWXaJQ04UQ7W4odQPrtKyERn5QCzSciFDinRLVYK7W352F0TdeFuVRh9
	 VmE8+q7WUJ+6Ozs7NasNwenp+onjTAHIawJJgdpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/356] can: sun4i_can: sun4i_can_err(): call can_change_state() even if cf is NULL
Date: Thu, 12 Dec 2024 15:55:27 +0100
Message-ID: <20241212144244.944660443@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ab8d017846869..80f7aa2531dc0 100644
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -629,10 +629,10 @@ static int sun4i_can_err(struct net_device *dev, u8 isrc, u8 status)
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



