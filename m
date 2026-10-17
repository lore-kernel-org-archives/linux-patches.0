Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616183B8BBB;
	Sat, 17 Oct 2026 17:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258873; cv=none; b=WbWz6/fRHuJOtsZ2x2KeLr70lmooAEYtylf8TBPe9zLXAPMTWLHtgpAjpAtrE2n4gJHUwnl9+l4vmuKASNmpnWSoCVkBuYVn4TvEBYX+6zzoCLSxVPrVkmdie8Mu/MGPdrDQ2EtJ1+phhoZB2R3jVqn2KUA551ZjBOxmJjd2xsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258873; c=relaxed/simple;
	bh=28r2vArt/7kNEBFsSArnah+a5w0QlxVstol73DdsvIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tw3R5DDsUPZ+ndV7nWaOirqBXMsqK3zByIvGJTag5bPYxeibhXktVXroePdvC/IM/m1Iod2wRjvznvKNyMoZ5NyS+UDv4gAasp7lFVidAB4CVObmeFF2aZzfC4+pEYCog4vuXI86o7NQg5vwordognR6yyqkR5049jvEAzftPoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ofv+o8Yu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ofv+o8Yu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14B31F000C5;
	Sat, 17 Oct 2026 17:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258872;
	bh=ripnIOyqhTxvcW0Bh6lgRvx+Z20JnlGXCFE7iuWkG+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ofv+o8YupfCfEjvnngIOFEYbeqJiSI7s6zXR563CT2hoR1sGQ88nNZ6939G3fgIex
	 VAZPhtg+0Wukxy7XMqFz+iEKYnZaGNXztGtYgEcMgsLYh+RMJjrxMZNs9e8582U/Dd
	 9bQzIxSNu6nxsoRNKQERvK+19lO0Jbo6EDP8Vtkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rory Little <rory@candelatech.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1028/1674] wifi: mt76: mt7921: Place upper limit on station AID
Date: Sat, 17 Oct 2026 17:55:00 +0200
Message-ID: <20261017160457.520672670@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   | 3 +++
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 5ffe08b8b85c4..8f0976e9c295e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -726,6 +726,9 @@ int mt7921_mac_sta_add(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
 	int ret, idx;
 
+	if (sta->aid > MT7921_MAX_AID)
+		return -ENOENT;
+
 	idx = mt76_wcid_alloc(dev->mt76.wcid_mask, MT792x_WTBL_STA - 1);
 	if (idx < 0)
 		return -ENOSPC;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index 87dd06855f685..bb54832358f56 100644
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



