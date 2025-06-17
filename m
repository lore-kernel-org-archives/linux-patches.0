Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E402DFF22;
	Tue, 17 Jun 2025 16:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177747; cv=none; b=LJbT+o3bRcou6dI2RjiA9JiDhBlIyUz8JjtOLCViGAMQGf/OVDVB2jczhDFQ0pgmtwEt87zs3UHW+wwkLZcm9WcmncTBhcOC+jqcRFnFMbvNQdiXkHCYIMbOLZMAzhs+4RYNfC00kyh6pcKBNbUlQVakKnVDxiZlaZN3V7chRrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177747; c=relaxed/simple;
	bh=Sjdu81OQgEGMxqcqD5/i1gSY1GBq0aH01RhMJj9FBnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B8cj8Wg9AOu7EyS+T4OWCfIGi60nmNhruzADGWt37FErDstoFjjAbziF9GnkR2CzktVZYCCh0hUKkNVtNlF011yrLZ5VUgDhC7xHnfaLsmL9shqc/PjRLWMwiPImdS7+5KaB4bGrIMJ5btDjiboUOPOr84S26HbUVT2Q+Ip6M3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UzstQSla; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UzstQSla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED08C4CEF3;
	Tue, 17 Jun 2025 16:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177747;
	bh=Sjdu81OQgEGMxqcqD5/i1gSY1GBq0aH01RhMJj9FBnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UzstQSlaNN9B0Dk6iVtRDg55QQ9vSBRnVWnPhhIdQjj9VXQv37TFcAXaxeFc1CEmQ
	 SJikH9aY2dMsgWpXpBtCRY/rYpqfCYgEq0wlrzVqFa047HU465spDthc4x1gwX/Mt+
	 CYn/t+HK9ffo6HYtvcE7AjgIO5JbbMnZCP4sT7WE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 332/780] net: phy: mscc: Fix memory leak when using one step timestamping
Date: Tue, 17 Jun 2025 17:20:40 +0200
Message-ID: <20250617152504.973374899@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index ed8fb14a7f215..6f96f2679f0bf 100644
--- a/drivers/net/phy/mscc/mscc_ptp.c
+++ b/drivers/net/phy/mscc/mscc_ptp.c
@@ -1166,18 +1166,24 @@ static void vsc85xx_txtstamp(struct mii_timestamper *mii_ts,
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



