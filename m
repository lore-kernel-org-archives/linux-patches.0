Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622546;
	b=MkVyk7DpjcpEAuZQBb5N35XX2Je7G38risLumCcbXwTMtl6dV7GN8c4uPDEyAaw38tIx
	 fctOnm6FLv9MAYbWoiISKjvjaL3GmXhCEWtjzyoOizXoYau3bdeDr5099osLzi2itG4hU
	 7EwE486QalWYwt1c8GKSf22dG0eSE4kiwKKNkvLqTQ/5LZUYa+494ZZMFADHYLiwji3VA
	 mUHO4LzCse2OnnUc3h5Bzvc0hpWH+1IMeIUACoCBJns0gPPKq81HDLaL0QuYijgnYy6r1
	 zNc1Py0W7l99rrFpPX8pJHvX8iEGUhThDrCtU43s+bf0LrVUCbmpgA5t8mRuqvYjWsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RWe8Q31iTU6dNmtbGgoRdWtI12Zf2gbbDwiQOTdf+uw=;
	b=3svt9bk5VPjVFVhxSRhDWcz8pdWl4WD+OktaXdb11aUsjR86RG3+ao/PoToe/1OfO4zu
	 u50vwZmPLMqqxANpdJktfX2HIhoeV/RkDJqepStZqkLGYz/ESVF/4CCqhH9rTxwezxXSJ
	 uZ6YzrtWoNa5U0r3nGvJa/RnoCMpSXcu3IgDYfr1ToGgjXFhNt0IsxI5nhtU2OaTOflWM
	 oFi/9mBaHrfr3V/v/y95cUQnxRCGemzo2ojL2BdwDZjaxbF6+CFXRKDBYCZ64auP/ajL4
	 VKDufHcMp3zlK5E0EHaJgkGT4TmOwLOCM0dGRIbE7fM9sfrqGvL4Y2CeqvtK1o2cqcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Quu0qErP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C632C606A321;
	Wed, 25 Nov 2026 16:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Quu0qErP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1021F000CA;
	Wed, 25 Nov 2026 16:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622546;
	bh=RWe8Q31iTU6dNmtbGgoRdWtI12Zf2gbbDwiQOTdf+uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Quu0qErP68bbNGKMBYWMPTaYLWBEDE84HzsZXaiOOYBdqswESX4Uj7RT/RYS5NyJ3
	 ijMWOKM8hNsxQ8zmJ8zA65be/fcthjruTZpmm/LmIZVA9nl+VtjimfruEgKkd+WntI
	 0FTaafNaHf1Aci/R4hUkhhOA19yAiLsghXMG4ZRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 572/990] wifi: mt76: mt7921: fix of_node reference leaks in regd update
Date: Wed, 25 Nov 2026 15:32:19 +0100
Message-ID: <20261125143835.491379195@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Applied the fix inside mt7921_regd_channel_update() in init.c (no regd.c here) and inlined the mt7921_regd_dt_has_channel() helper, with no goto out on the 5 GHz check. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/init.c  | 31 ++++++++++++++-----
 .../net/wireless/mediatek/mt76/mt7921/mcu.c   |  7 ++++-
 2 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index b9098a7331b1a..67a3b3dcf60a2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -67,7 +67,7 @@ mt7921_regd_channel_update(struct wiphy *wiphy, struct mt792x_dev *dev)
 	(!(dev->phy.clc_chan_conf & BIT(idx)) && (cfreq) >= (sfreq) && (cfreq) <= (efreq))
 	struct ieee80211_supported_band *sband;
 	struct mt76_dev *mdev = &dev->mt76;
-	struct device_node *np, *band_np;
+	struct device_node *np, *band_np, *chan_np;
 	struct ieee80211_channel *ch;
 	int i, cfreq;
 
@@ -79,28 +79,39 @@ mt7921_regd_channel_update(struct wiphy *wiphy, struct mt792x_dev *dev)
 		ch = &sband->channels[i];
 		cfreq = ch->center_freq;
 
-		if (np && (!band_np || !mt76_find_channel_node(band_np, ch))) {
-			ch->flags |= IEEE80211_CHAN_DISABLED;
-			continue;
+		if (np) {
+			chan_np = band_np ?
+				  mt76_find_channel_node(band_np, ch) : NULL;
+			of_node_put(chan_np);
+			if (!chan_np) {
+				ch->flags |= IEEE80211_CHAN_DISABLED;
+				continue;
+			}
 		}
 
 		/* UNII-4 */
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
-			ch->flags |= IEEE80211_CHAN_DISABLED;
-			continue;
+		if (np) {
+			chan_np = band_np ?
+				  mt76_find_channel_node(band_np, ch) : NULL;
+			of_node_put(chan_np);
+			if (!chan_np) {
+				ch->flags |= IEEE80211_CHAN_DISABLED;
+				continue;
+			}
 		}
 
 		/* UNII-5/6/7/8 */
@@ -110,6 +121,10 @@ mt7921_regd_channel_update(struct wiphy *wiphy, struct mt792x_dev *dev)
 		    IS_UNII_INVALID(4, 6875, 7125))
 			ch->flags |= IEEE80211_CHAN_DISABLED;
 	}
+	of_node_put(band_np);
+
+out:
+	of_node_put(np);
 }
 
 void mt7921_regd_update(struct mt792x_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 7363a553a007d..5e6e3cb4d5e15 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -3,6 +3,7 @@
 
 #include <linux/fs.h>
 #include <linux/firmware.h>
+#include <linux/of.h>
 #include "mt7921.h"
 #include "mcu.h"
 #include "../mt76_connac2_mac.h"
@@ -1361,6 +1362,7 @@ int __mt7921_mcu_set_clc(struct mt792x_dev *dev, u8 *alpha2,
 		.acpi_conf = mt792x_acpi_get_flags(&dev->phy),
 		.mtcl_conf = mt792x_acpi_get_mtcl_conf(&dev->phy, alpha2),
 	};
+	struct device_node *np;
 	int ret, valid_cnt = 0;
 	u32 buf_len = 0;
 	u8 *pos;
@@ -1370,8 +1372,11 @@ int __mt7921_mcu_set_clc(struct mt792x_dev *dev, u8 *alpha2,
 
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
-- 
2.53.0



