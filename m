Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09E52EA153;
	Tue, 17 Jun 2025 16:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176248; cv=none; b=CtGqJellROttrtntUbvDmvrscd/WiQ1PXnd4m4Y7ApNJGSnVZe6yN720IslDJ3hZVsItGS/nLUnOs5LbWCIi2/0ztg+iYSt5m1yQsadMefMzK8ktMxHkGjh3kFTwXOj0GbODTFB/LQi02HLM5e17r07bBCZ8IedAmWCzjv16lgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176248; c=relaxed/simple;
	bh=g+T0tsJq7HCFp8gdFGnAavLR5SVp1SWeJhi0Ct6VVE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tjx8KbZdD2j1IWBIpEDrZ15KBHN8vCcfI3nmZxK4faaI807FMF4OozBiWA5gX3OoAPafWwjYKAqnDUhjcYR4iy3qdWgw3m62UncX6CgzriO3VD4rfLN6+W9qzuwQvIyXqsVKsSV80V6/3EpSV3KbihFIqIzjPl0fiexPvCw+YRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iAtCvsym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iAtCvsym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC42C4CEE3;
	Tue, 17 Jun 2025 16:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176248;
	bh=g+T0tsJq7HCFp8gdFGnAavLR5SVp1SWeJhi0Ct6VVE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iAtCvsymhJzvw4LxxZDEns9vBged6IehcuqJqMfI0CDtyqot/ZtM1tM3DZ9WYg3Zb
	 x1A1n1o1C00/68cQrbeN4WdtfwDKM0NB4229noJkNtO11vv5dC3EbJT2bvKX6SdK3l
	 bXKm7sGeulmCiSdwf/f+X1/OYfP/K5LySh27yq8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 210/512] net: phy: mscc: Fix memory leak when using one step timestamping
Date: Tue, 17 Jun 2025 17:22:56 +0200
Message-ID: <20250617152428.139890229@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mscc/mscc_ptp.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_ptp.c b/drivers/net/phy/mscc/mscc_ptp.c
index 738a8822fcf01..0173aa3b4ead1 100644
--- a/drivers/net/phy/mscc/mscc_ptp.c
+++ b/drivers/net/phy/mscc/mscc_ptp.c
@@ -1163,18 +1163,24 @@ static void vsc85xx_txtstamp(struct mii_timestamper *mii_ts,
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
2.39.5



