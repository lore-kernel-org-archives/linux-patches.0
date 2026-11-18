Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019141;
	b=MqRmsjZ2/9vKBEZ2hkEGexJOY4ZryIg9bcnbi+faVAB8gyvLi1tUpQYsENmL5JSWL38e
	 cCNZ8IUSJmn5wXjYNuwyvAYMok2zAQztOJjoGszWrGHTX5/2sK2Qrk/Z29Z9IuEEDPLcy
	 qa6HyLTPEvW1EmYeRR6g3uONi6mjcOCzcnDaDSM0GrHSzzrTlpxmgP/YTvPHl3SoRo07t
	 8EbwMZEejPrdKyRNAD5dvnNiQhNM8oMQsMCvqqcS4dLjQWiSqV73p/m956SqENQi2Cyii
	 ak2j7/jXafVd7IRU9f9TT/XU+h6DSFVstt9FNjL+1e41hjc8h7FcdH5ZzIoNd53b6hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WTW7unawDEpQ1c0zdR0tIpwnVVF7BjTdHHjHQ/MH72E=;
	b=grQ9TUTqVSA9y9KoQV1sGIAVjWY8Fax/59LBLw4MmpySRO1nFVTIyE8bokZbqN6XdVfk
	 qEH5ULSUdCdkwgEvzK0dsYEsf4xW2hEYRjyBaR6uvgg+inD6a7Le0mmz6tHHotAPiaGga
	 fhbeDCm7m+NXkNYkqSRvYsWvNtRem9E7V+lpu7Uc4RvE2vTaCVN4Vx37PkPGB87aXKhBT
	 sHIE3cOVC3Y+OeHK0Q75hBfr9gjKiC276VmvEgrqvUZYRFFYOSMIO86R+UDTpAVZjlCCh
	 2fbc2d+Wl1yK3rD6popWew/sD5l5KiTLR60lYnNr9uvjUJMW4NQU8HbUSxVoX1TJSsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NV0ZTYqU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E52606A325;
	Wed, 18 Nov 2026 16:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NV0ZTYqU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A521F000C4;
	Wed, 18 Nov 2026 16:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019141;
	bh=WTW7unawDEpQ1c0zdR0tIpwnVVF7BjTdHHjHQ/MH72E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NV0ZTYqUjNFmqbM1WxvcSSJCphlg4/BE0dblvz8Lyv/AZSebBpCbFIoWuxKE289Hz
	 HLfHolDhiBewARpB4tn/hnKhU7H/E1wFaSV1Q86oFbXZEzN6nSQNI3qGUYUnRYCG+b
	 Vzx06oHjrIQbfnDWVXq3H1vA5sJ+FugY2WnrD28M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1491/2651] wifi: mt76: mt7921: fix of_node reference leaks in regd update
Date: Wed, 18 Nov 2026 15:45:31 +0100
Message-ID: <20261118150341.697012459@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 2f209a8dca88507bc094de370e582adefc55723e ]

mt7921_regd_channel_update() and __mt7921_mcu_set_clc() never
release the nodes returned by mt76_find_power_limits_node(),
of_get_child_by_name() and mt76_find_channel_node(). Each regulatory
domain change and each CLC update on a device with DT power limits
leaks these references.

Release every node after use. This relies on
mt76_find_power_limits_node() also returning a reference for the
fallback node, which it does since commit 3a62c9f7ec3d ("wifi: mt76:
Fix of_node reference leak in mt76_get_rate_power_limits()").

Fixes: 09382d8f8641 ("wifi: mt76: mt7921: update the channel usage when the regd domain changed")
Link: https://patch.msgid.link/20261007112419.1277594-3-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/mcu.c   |  7 ++++-
 .../net/wireless/mediatek/mt76/mt7921/regd.c  | 28 ++++++++++++++++---
 2 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index c90d0da706a1a..fec5205b33ca4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -3,6 +3,7 @@
 
 #include <linux/fs.h>
 #include <linux/firmware.h>
+#include <linux/of.h>
 #include "mt7921.h"
 #include "regd.h"
 #include "mcu.h"
@@ -1359,6 +1360,7 @@ int __mt7921_mcu_set_clc(struct mt792x_dev *dev, u8 *alpha2,
 		.acpi_conf = mt792x_acpi_get_flags(&dev->phy),
 		.mtcl_conf = mt792x_acpi_get_mtcl_conf(&dev->phy, alpha2),
 	};
+	struct device_node *np;
 	int ret, valid_cnt = 0;
 	u32 buf_len = 0;
 	u8 *pos;
@@ -1368,8 +1370,11 @@ int __mt7921_mcu_set_clc(struct mt792x_dev *dev, u8 *alpha2,
 
 	if (dev->phy.chip_cap & MT792x_CHIP_CAP_CLC_EVT_EN)
 		req.cap |= CLC_CAP_EVT_EN;
-	if (mt76_find_power_limits_node(&dev->mt76))
+
+	np = mt76_find_power_limits_node(&dev->mt76);
+	if (np)
 		req.cap |= CLC_CAP_DTS_EN;
+	of_node_put(np);
 
 	buf_len = le32_to_cpu(clc->len) - sizeof(*clc);
 	pos = clc->data;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/regd.c b/drivers/net/wireless/mediatek/mt76/mt7921/regd.c
index fcdeb65cd8ef2..699617d9e48f7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/regd.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/regd.c
@@ -28,6 +28,21 @@ bool mt7921_regd_clc_supported(struct mt792x_dev *dev)
 	return true;
 }
 
+static bool
+mt7921_regd_dt_has_channel(struct device_node *band_np,
+			   struct ieee80211_channel *ch)
+{
+	struct device_node *chan_np;
+
+	if (!band_np)
+		return false;
+
+	chan_np = mt76_find_channel_node(band_np, ch);
+	of_node_put(chan_np);
+
+	return !!chan_np;
+}
+
 static void
 mt7921_regd_channel_update(struct wiphy *wiphy, struct mt792x_dev *dev)
 {
@@ -43,14 +58,14 @@ mt7921_regd_channel_update(struct wiphy *wiphy, struct mt792x_dev *dev)
 
 	sband = wiphy->bands[NL80211_BAND_5GHZ];
 	if (!sband)
-		return;
+		goto out;
 
 	band_np = np ? of_get_child_by_name(np, "txpower-5g") : NULL;
 	for (i = 0; i < sband->n_channels; i++) {
 		ch = &sband->channels[i];
 		cfreq = ch->center_freq;
 
-		if (np && (!band_np || !mt76_find_channel_node(band_np, ch))) {
+		if (np && !mt7921_regd_dt_has_channel(band_np, ch)) {
 			ch->flags |= IEEE80211_CHAN_DISABLED;
 			continue;
 		}
@@ -59,17 +74,18 @@ mt7921_regd_channel_update(struct wiphy *wiphy, struct mt792x_dev *dev)
 		if (IS_UNII_INVALID(0, 5845, 5925))
 			ch->flags |= IEEE80211_CHAN_DISABLED;
 	}
+	of_node_put(band_np);
 
 	sband = wiphy->bands[NL80211_BAND_6GHZ];
 	if (!sband)
-		return;
+		goto out;
 
 	band_np = np ? of_get_child_by_name(np, "txpower-6g") : NULL;
 	for (i = 0; i < sband->n_channels; i++) {
 		ch = &sband->channels[i];
 		cfreq = ch->center_freq;
 
-		if (np && (!band_np || !mt76_find_channel_node(band_np, ch))) {
+		if (np && !mt7921_regd_dt_has_channel(band_np, ch)) {
 			ch->flags |= IEEE80211_CHAN_DISABLED;
 			continue;
 		}
@@ -81,6 +97,10 @@ mt7921_regd_channel_update(struct wiphy *wiphy, struct mt792x_dev *dev)
 		    IS_UNII_INVALID(4, 6875, 7125))
 			ch->flags |= IEEE80211_CHAN_DISABLED;
 	}
+	of_node_put(band_np);
+
+out:
+	of_node_put(np);
 }
 
 int __mt7921_mcu_regd_update(struct mt792x_dev *dev, u8 *alpha2,
-- 
2.53.0



