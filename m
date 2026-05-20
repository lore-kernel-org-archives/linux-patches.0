Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C17A3E95A4;
	Wed, 20 May 2026 18:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300107; cv=none; b=l0jt+Vpq/gh2bnkbBbnEYqxTrkwCUYi31njeYlc0O/5PMcOGnHwTW5NeeHPcdSTm1Yp0lmOhuhJIu+exz/F92wdiFRpRKojxcJfQV/ZADGtmdbqSrbaYqIwnlmK9SjTWsTyWctMIVb155buMeqXdatnl0Aaqnos/1i0GNTHmISU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300107; c=relaxed/simple;
	bh=Vr+8N4A7ibyX7gJMIKbL0CuLLBi17+3GhzmptIymxVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JcPULwub6Ne/BoI2kyzmSJIVk1NOU8/JbZiGpscrzhEKm+xowqdKVoYbEeVRKSSgxqzc1Ma+c6RWtYKsOoHVKHtCXKKvkH9sZzY36+aOLhR/W6ONVYfxJK4Mad08kK9MEpUVWHmJFAVXbIhCVvdE73eg9UpbZ91gPsAm652QKnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2tnGwEa1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2tnGwEa1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9085C1F000E9;
	Wed, 20 May 2026 18:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300106;
	bh=I6UTchS8uGSbqN7s/6wgi+BUgXgxzZRQvLnQzQY5GGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2tnGwEa1vHEE+bJqeD8x47PcVjLUbdizlydji4xvg5G5/uRlFOQ7M4vK7LrZx8JsO
	 tLhq310VKGE5cjzCTQoIpTgYYk0vHOiig6FEJaBR50DUsNSYXbQFrLNruC1kdlJm/n
	 26y01rFK7/oPviy9Yee+ylPkLeliPPVfpOYDtFAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rory Little <rory@candelatech.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 049/666] wifi: mt76: mt7921: Place upper limit on station AID
Date: Wed, 20 May 2026 18:14:20 +0200
Message-ID: <20260520162112.304427470@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bc823a7c09bba..6ed2edd054b55 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -802,6 +802,9 @@ int mt7921_mac_sta_add(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
 	int ret, idx;
 
+	if (sta->aid > MT7921_MAX_AID)
+		return -ENOENT;
+
 	idx = mt76_wcid_alloc(dev->mt76.wcid_mask, MT792x_WTBL_STA - 1);
 	if (idx < 0)
 		return -ENOSPC;
@@ -845,6 +848,9 @@ int mt7921_mac_sta_event(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 	struct mt792x_sta *msta = (struct mt792x_sta *)sta->drv_priv;
 	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
 
+	if (sta->aid > MT7921_MAX_AID)
+		return -ENOENT;
+
 	if (ev != MT76_STA_EVENT_ASSOC)
 	    return 0;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index 16c89815c0b8a..7a7e09fcf4b5e 100644
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



