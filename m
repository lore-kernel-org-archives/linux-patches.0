Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF3E7F476;
	Mon,  8 Apr 2024 13:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583083; cv=none; b=vGVtuvmnaYyuXzrjFy0/KaNXxZtIM9kbZIWvj82Ee9xr1ccE/I+NDM5cMAxFbqu5DBQynP4KQ7UsAoN7fhZRDldEDoYqPQi5UVeY5UqU8A7yi5RyVLqKKhX9KnyF2zwJ5h07lHmA7T6UU6INndS9LquZeHH6+Mz//p4jpH4QTbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583083; c=relaxed/simple;
	bh=kj5LCRFHOzom7+d9bz1pGc7WMz6+vNfwrBPBfO2QVkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0Hu3cpTd9Jpmj2AW8jz66K42GO4ukaIfVw/Yvb/QQ17xMkzkQnAIgVBqyFI9XDoB3UPmwRwgmtsc8xPgTrAKKVbYb5kCqZNNmZ9wj3Q2tCur/Q9qiKjTgcv6reIlh7cCEbZYYC70eWn+ANpP77gHV1Iu2HJ5p+mDSWHru0/TKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j4JS/Iyh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j4JS/Iyh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55A4C433C7;
	Mon,  8 Apr 2024 13:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583083;
	bh=kj5LCRFHOzom7+d9bz1pGc7WMz6+vNfwrBPBfO2QVkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j4JS/IyhAROi39zOLmVzrLnWm9OPMky3aq8XYDq2tEdA+IZ4Gin9m7Vodi/8kmDQb
	 wRdRZYeh5+vKSvvJk/LhlNQIAVGZtaC6jSHwkeE2JzFeXyVSdc8v+gtBv8Atm3m1x8
	 LTIN1bH2kvStJUfFIMsnkV0iABM38YuaDG5GJvso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Barker <paul.barker.ct@bp.renesas.com>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 155/252] net: ravb: Always update error counters
Date: Mon,  8 Apr 2024 14:57:34 +0200
Message-ID: <20240408125311.470330018@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

From: Paul Barker <paul.barker.ct@bp.renesas.com>

[ Upstream commit 101b76418d7163240bc74a7e06867dca0e51183e ]

The error statistics should be updated each time the poll function is
called, even if the full RX work budget has been consumed. This prevents
the counts from becoming stuck when RX bandwidth usage is high.

This also ensures that error counters are not updated after we've
re-enabled interrupts as that could result in a race condition.

Also drop an unnecessary space.

Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
Signed-off-by: Paul Barker <paul.barker.ct@bp.renesas.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/20240402145305.82148-2-paul.barker.ct@bp.renesas.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 14595d23b1903..c6897e6ea362d 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1307,6 +1307,15 @@ static int ravb_poll(struct napi_struct *napi, int budget)
 	netif_wake_subqueue(ndev, q);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	/* Receive error message handling */
+	priv->rx_over_errors = priv->stats[RAVB_BE].rx_over_errors;
+	if (info->nc_queues)
+		priv->rx_over_errors += priv->stats[RAVB_NC].rx_over_errors;
+	if (priv->rx_over_errors != ndev->stats.rx_over_errors)
+		ndev->stats.rx_over_errors = priv->rx_over_errors;
+	if (priv->rx_fifo_errors != ndev->stats.rx_fifo_errors)
+		ndev->stats.rx_fifo_errors = priv->rx_fifo_errors;
+
 	if (!unmask)
 		goto out;
 
@@ -1323,14 +1332,6 @@ static int ravb_poll(struct napi_struct *napi, int budget)
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	/* Receive error message handling */
-	priv->rx_over_errors =  priv->stats[RAVB_BE].rx_over_errors;
-	if (info->nc_queues)
-		priv->rx_over_errors += priv->stats[RAVB_NC].rx_over_errors;
-	if (priv->rx_over_errors != ndev->stats.rx_over_errors)
-		ndev->stats.rx_over_errors = priv->rx_over_errors;
-	if (priv->rx_fifo_errors != ndev->stats.rx_fifo_errors)
-		ndev->stats.rx_fifo_errors = priv->rx_fifo_errors;
 out:
 	return budget - quota;
 }
-- 
2.43.0



