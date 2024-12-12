Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C33D2397AD;
	Thu, 12 Dec 2024 16:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020626; cv=none; b=RiayHWivzn46Smy+Tgjy6/kJngatidI1N0zuzDUka3mnjC2kg9E/NQv7DbCR6zFm9+ZkLb6j5yw0Cx5A92jjb3pYkt4UuDjNbcEzaHbtbgKWrz5xr05k+27Cugp90MiL2hiSSoK6L/9CggCEtEHsf8IKJjZZZx1P4Wt0qvr0Dfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020626; c=relaxed/simple;
	bh=OK1cr0ehcQXYqenS2UxXjnQQOjUpUifIHLJOED4bhxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ul9cgz33QVMw+0ZhJnVa8ZyAAZG9CZKM0Aa/J24l2FFGoaW4+Tg8oEbcHYiaBS2ZhIGv0lI6Edlz5zXGaWAQhsjDK860xsMOn4vW4HjLdp7A8GZEX84uZtcFtb9hrGdUKO72AJ6IpmiNePNC8j5iKEee8Nt7Nb+NcculHXCuPOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smunRdkc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smunRdkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE610C4CECE;
	Thu, 12 Dec 2024 16:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020626;
	bh=OK1cr0ehcQXYqenS2UxXjnQQOjUpUifIHLJOED4bhxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smunRdkcaOUrc0O/pshkFdUYWGI1In4lbADCVXh5PvwS+gP95sDq6Ni3adQUn1hwr
	 pdek0JofPVWaGJXAtKweYKKcKT5678I5EPUTi9R9/bDuqaBmtHC1WxQcleqGosIoXp
	 30yRBFOXVYPNX/AABQgvx0HRM9V8BvFREea0Xc9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 516/772] can: sun4i_can: sun4i_can_err(): call can_change_state() even if cf is NULL
Date: Thu, 12 Dec 2024 15:57:41 +0100
Message-ID: <20241212144411.280763023@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c3a6b028ea4d6..6bf721eda65d2 100644
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -630,10 +630,10 @@ static int sun4i_can_err(struct net_device *dev, u8 isrc, u8 status)
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



