Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848533546D0;
	Wed, 20 May 2026 16:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294617; cv=none; b=BhF3a8JvZSDsc9ulpOyft88r3NEGjRJUbGxl6XYJR4A3vTDMkOtdcRarrJgysyN9IeoE6UuMtg4VJDRa0hLs2uPCpmw2quz0xNCD6jZIWzFTG+zBNJOPaYb9V7X1W42/Dk+24oJ4cD1q9Muws7FFDD0kjpxMxEaPA3nkWZIu9yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294617; c=relaxed/simple;
	bh=egHmz+xnSxWIwnUh1clLyIghgTkCifM01Jl434CSPf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKMhXAHrV2nbeiPAZjkzoQFWySgUreGx3zF3TAiLbcQyMIgth5XySwS75xTULblcnhFmhlpeTCn1D/JGecrgY74y4f3Zrzf3bw0TE2rH+6qGWJ4m8I7US34RLT3Xdeb2Be7vibHYrXoU3Ie368RQlBC/TeNBxEtXZzq7e60K1kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e0QlQ4KJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e0QlQ4KJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05C61F00893;
	Wed, 20 May 2026 16:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294616;
	bh=r3nPhq/BC0CJ/An3rBRbrj31pbmE3woufvDyMdYlBOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e0QlQ4KJF+wQGZV5tQ2E7f+u0hiSxwxNt14fcMStH9G7fc+eenGiaN8KmNibPvFag
	 F4vXC6+i17pdR4rqZyBd+Yy3a4OIKB64Jth711nKErlQcScDfym/5LHWcyFXFdJmCT
	 NHItMlU5uxGo6BUS0B30XgR0hScyNog+1mp6N7hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rory Little <rory@candelatech.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0107/1146] wifi: mt76: mt7921: Place upper limit on station AID
Date: Wed, 20 May 2026 18:05:57 +0200
Message-ID: <20260520162150.761885587@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rory Little <rory@candelatech.com>

[ Upstream commit 4d0bf21e3e20619d51d06c0c36207aabab8b712c ]

Any station configured with an AID over 20 causes a firmware crash.
This situation occurred in our testing using an AP interface on 7922
hardware, with a modified hostapd, sourced from Mediatek's OpenWRT
feeds.

In stock hostapd, station AIDs begin counting at 1, and this
configuration is prevented with an upper limit on associated stations.
However, the modified hostapd began allocation at 65, which caused the
firmware to crash. This fix does not allow these AIDs to work, but will
prevent the firmware crash.

This crash was only seen on IFTYPE_AP interfaces, and the fix does not
appear to have an effect on IFTYPE_STATION behavior.

Fixes: 5c14a5f944b9 ("mt76: mt7921: introduce mt7921e support")
Signed-off-by: Rory Little <rory@candelatech.com>
Link: https://patch.msgid.link/20250904000711.3033860-1-rory@candelatech.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   | 6 ++++++
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 021335805acb3..f42e40f9663d8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -808,6 +808,9 @@ int mt7921_mac_sta_add(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
 	int ret, idx;
 
+	if (sta->aid > MT7921_MAX_AID)
+		return -ENOENT;
+
 	idx = mt76_wcid_alloc(dev->mt76.wcid_mask, MT792x_WTBL_STA - 1);
 	if (idx < 0)
 		return -ENOSPC;
@@ -851,6 +854,9 @@ int mt7921_mac_sta_event(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 	struct mt792x_sta *msta = (struct mt792x_sta *)sta->drv_priv;
 	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
 
+	if (sta->aid > MT7921_MAX_AID)
+		return -ENOENT;
+
 	if (ev != MT76_STA_EVENT_ASSOC)
 	    return 0;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index 83fc7f49ff848..ad92af98e3145 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -7,6 +7,8 @@
 #include "../mt792x.h"
 #include "regs.h"
 
+#define MT7921_MAX_AID                  20
+
 #define MT7921_TX_RING_SIZE		2048
 #define MT7921_TX_MCU_RING_SIZE		256
 #define MT7921_TX_FWDL_RING_SIZE	128
-- 
2.53.0



