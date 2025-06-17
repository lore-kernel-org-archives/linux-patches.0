Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598FD2DFF2E;
	Tue, 17 Jun 2025 16:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177340; cv=none; b=geMFaw4hjvV7nu06Lu5aIcDA6UljKczUMBFcXU80E35JDU8bmW58fp1CLy+dLSc9p+Gyrsvuj+DGAZCb9w0zKMziuyKECeb0pz1emlhm1TkPld+iMXPxaWAqXJct7dxpcugvLULhhpNjlMmusrqGKn6RWYaOtdPF80Xl4MQG9d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177340; c=relaxed/simple;
	bh=iA8boxvHaTzVo+6RCWbAvUza5GNNu1IVC82hAp5NiQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TX2HyG8jNuiN7xYsIwHhjm/r4I1WL7XtLRtw+8DWteW8TBKH9AcS6hWPeewa7/rWd8o/79/3C29Efu2JBQ13oEPQEjjkMXvdKPvZP4xrF4SHqkV5R1IVw+s63jC1338xYvltiDigKBVYjaFNZCAUW/hOzZQ/+nz2hPOCSM/n2sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TUlNYpd3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TUlNYpd3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30DBC4CEE3;
	Tue, 17 Jun 2025 16:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177340;
	bh=iA8boxvHaTzVo+6RCWbAvUza5GNNu1IVC82hAp5NiQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TUlNYpd3cwcijDZ88V3Gs229ucuf8lve31J+hKQm3u4EjbNoISezpwuiP+PEjiPRV
	 3R3nVq/WpDiEWrvlegoI46sOb3atZcK/yS4xqHM+5pTtLbbWbtknE2UWUZFFcZZf01
	 lTvzcWS/9wkW2JPMifHcjppONPdV2Cvgtam4ThM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qasim Ijaz <qasdev00@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 292/780] wifi: mt76: mt7996: avoid null deref in mt7996_stop_phy()
Date: Tue, 17 Jun 2025 17:20:00 +0200
Message-ID: <20250617152503.358281454@linuxfoundation.org>
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

From: Qasim Ijaz <qasdev00@gmail.com>

[ Upstream commit a0bdd3d1b94d22dd9d255fd148eb9183ea0a822f ]

In mt7996_stop_phy() the mt7996_phy structure is
dereferenced before the null sanity check which could
lead to a null deref.

Fix by moving the dereference operation after the
sanity check.

Fixes: 69d54ce7491d ("wifi: mt76: mt7996: switch to single multi-radio wiphy")
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
Link: https://patch.msgid.link/20250421111344.11484-1-qasdev00@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 5ec4f97932865..8698c4345af0c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -68,11 +68,13 @@ static int mt7996_start(struct ieee80211_hw *hw)
 
 static void mt7996_stop_phy(struct mt7996_phy *phy)
 {
-	struct mt7996_dev *dev = phy->dev;
+	struct mt7996_dev *dev;
 
 	if (!phy || !test_bit(MT76_STATE_RUNNING, &phy->mt76->state))
 		return;
 
+	dev = phy->dev;
+
 	cancel_delayed_work_sync(&phy->mt76->mac_work);
 
 	mutex_lock(&dev->mt76.mutex);
-- 
2.39.5



