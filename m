Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBF115D5B6;
	Sun,  7 Sep 2025 20:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276131; cv=none; b=EnbtSrZuk7ytIbspZsV7tn7Z2XztYBdKYNUwYqItmq9nto4dARSaEqDxAjmHVj34S8AJ3aQfEw93tmutrhjZ4IGi7Q6kOcfWilqtud+TdpcIg+q6AhOWZM7tDvWWYgZrxi0DwFf8QHZTNi1q1HnjL1qFg76hrRu6/Os19QUMAqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276131; c=relaxed/simple;
	bh=lMGVR/QIN3M6vNfgWBnAj5PqsP0ss4UTwvwsvHlnwyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fVv6kFOIfEJAVPaFIUcqCCUKrob64v3TjMy8wPos5Bc61drAiKX+A2gUflF6FhotjV2MPX14TqjeiWslhqpu1rk/XIE1jz3Cdj36q1rxjT5KIaUGlbMPR2PpVDGkbjbRMQux83cIlhtNw6CNwSU3FC8yC2wDPiPWu5rLSS/LlsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5tre0Rl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5tre0Rl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F039CC4CEF0;
	Sun,  7 Sep 2025 20:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276131;
	bh=lMGVR/QIN3M6vNfgWBnAj5PqsP0ss4UTwvwsvHlnwyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P5tre0RlBvr3rslKwLHTgkryy//CWzE3GY+mebrVXHa4c0ucWI38A69P6WHTT1+jk
	 DSU21feTVrRs/tq6y8okQS9K6NOEey3Q6BlxYgb6iivbP9GOrNqCDo9Y+v7uKsaITG
	 gJmgjo3g84diwAKmQr4VqpFZiUpQDdJzbmgNF2I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 27/64] net: phy: mscc: Fix memory leak when using one step timestamping
Date: Sun,  7 Sep 2025 21:58:09 +0200
Message-ID: <20250907195604.141237112@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
References: <20250907195603.394640159@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 846992645b25ec4253167e3f931e4597eb84af56 ]

Fix memory leak when running one-step timestamping. When running
one-step sync timestamping, the HW is configured to insert the TX time
into the frame, so there is no reason to keep the skb anymore. As in
this case the HW will never generate an interrupt to say that the frame
was timestamped, then the frame will never released.
Fix this by freeing the frame in case of one-step timestamping.

Fixes: 7d272e63e0979d ("net: phy: mscc: timestamping and PHC support")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Link: https://patch.msgid.link/20250522115722.2827199-1-horatiu.vultur@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 9b2bfdbf43ad ("phy: mscc: Stop taking ts_lock for tx_queue and use its own lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mscc/mscc_ptp.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_ptp.c b/drivers/net/phy/mscc/mscc_ptp.c
index e30e6ba9da2f4..717435562f1c5 100644
--- a/drivers/net/phy/mscc/mscc_ptp.c
+++ b/drivers/net/phy/mscc/mscc_ptp.c
@@ -1171,18 +1171,24 @@ static void vsc85xx_txtstamp(struct mii_timestamper *mii_ts,
 		container_of(mii_ts, struct vsc8531_private, mii_ts);
 
 	if (!vsc8531->ptp->configured)
-		return;
+		goto out;
 
-	if (vsc8531->ptp->tx_type == HWTSTAMP_TX_OFF) {
-		kfree_skb(skb);
-		return;
-	}
+	if (vsc8531->ptp->tx_type == HWTSTAMP_TX_OFF)
+		goto out;
+
+	if (vsc8531->ptp->tx_type == HWTSTAMP_TX_ONESTEP_SYNC)
+		if (ptp_msg_is_sync(skb, type))
+			goto out;
 
 	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 
 	mutex_lock(&vsc8531->ts_lock);
 	__skb_queue_tail(&vsc8531->ptp->tx_queue, skb);
 	mutex_unlock(&vsc8531->ts_lock);
+	return;
+
+out:
+	kfree_skb(skb);
 }
 
 static bool vsc85xx_rxtstamp(struct mii_timestamper *mii_ts,
-- 
2.50.1



