Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E1322145E;
	Thu, 12 Dec 2024 17:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023036; cv=none; b=MVt2RzHYR6gl9+rFq3cH9cy8AcAK9aOQ5canoHP6rks2v15akGkIuaOQD/bHoYyp52H44SSYVrBk/cI5pFrbu8GqYy2uidNzNry9gX8Vi4cqz6E8xQzLR/82Z1cLXV2Vz4lGkZb5nYESvuDMJ4Tgsh+P+DGUm6t6ysOEbTp33bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023036; c=relaxed/simple;
	bh=5/6pXRi5GzFGJQU/W0PQzLc2RSbbpklfozAbiE3Flg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZVd98xxeQ3UMrGFQrI8kU5pGaMMH+8rPtf+OWbOBjALjVfyIAIYz0p6ZmP9q9h/wKHCwX3TWandQIYVLsxeIFFDkMTY9T+zjjrel6mttp9KkuZOeUIO9QVsvjuqTRoy89BIdOmCYfOUNpyrK4CbZ75gyQyz2D2akGJQLoWUUY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AqxamKPj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AqxamKPj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43EF6C4CECE;
	Thu, 12 Dec 2024 17:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023036;
	bh=5/6pXRi5GzFGJQU/W0PQzLc2RSbbpklfozAbiE3Flg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AqxamKPjJ6OoZK1/xUph3r8L3Xb/2FfDq+3k1DDSRH0eSk3Pe3LizOsBWp82Mjd5z
	 FPTMh09oOwUTHpN9yytYNDQ6XdYrZL0EKZByMQ1YS2cjM13ZJ/QG3iqt92ucHMRRsf
	 I2gIp31lLPHgn/SFOyAdhfqMp5OrhyOmphFHws0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 403/565] can: sun4i_can: sun4i_can_err(): call can_change_state() even if cf is NULL
Date: Thu, 12 Dec 2024 15:59:58 +0100
Message-ID: <20241212144327.587584499@linuxfoundation.org>
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
index ab9adfe92a94b..aad1882a9be11 100644
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -613,10 +613,10 @@ static int sun4i_can_err(struct net_device *dev, u8 isrc, u8 status)
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



