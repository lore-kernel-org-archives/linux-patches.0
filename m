Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625402;
	b=XRSN7Dg3clwzmZjScTtmQ8GvPmh9B+EaId+1/X0J+ngq4aMgF6s1nbvfmg7Hv3P3uK3I
	 YOHP7zn6I2g0/ggk6jfStr5g/0bW60pG+V5TYiPmAvHEKp7VGeXF5Lcj3gK6bZc+xJqOE
	 /8dckehgnf8BrlMkrEDhQnXQd/RD3bS4RHXcnBTxZMn8zjVGCBZBgCNrkV97e0tKltnNl
	 +DVtWAEcxb+ncF67gc2tbztqBGx77FVppTMSLTU+Swh2NzaE/2rajff5Te4z7/+HlkJB7
	 aHw0e7KbToyfhZSDWKd9ni2ENIIumwYLLOYaDeFdW+E6+on7XZANZeQehqe9xiHi0lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625402;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vVCzer4S/rADYsUsEz2r/3CK/gUDSWGeBDKwUmpJNh0=;
	b=jfveb5jf6PeXvJUhc64r9u7SyL4nKzyi1lLqqRRbBNlrth6VaWWyAmGn2tsoZih8vbWI
	 BQ21UCXh9LMu8SHGRM7EudNhHHCJ/M9dOb+dcMQOqCRPm8PpVKdhmOyfyvPRMLAZ7HTlv
	 C/6bf9VXtIlg8rwlTw3T41acDd2Vly61AzwL80dnupFSgJUZIKkOr4ywG7UCwxiCCnWPh
	 9h3eov7TQ6tXyAYSEHnGajBT1tjfIgrBBhtR4sZukaqjrmvU2cNl/5eDQnfptV8BPvdf5
	 HS/+FW2NPwTQZrprxAqdWxZrYg4I0ym3apFiYfb5YMptZVRMWNJWdbnpG/pAORYUcYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nFV03+IK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5012606A32E;
	Wed, 25 Nov 2026 16:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nFV03+IK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3C01F000CF;
	Wed, 25 Nov 2026 16:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625401;
	bh=vVCzer4S/rADYsUsEz2r/3CK/gUDSWGeBDKwUmpJNh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nFV03+IK4YiD2fU9bRWKR7xVhUT9TM48Tgp/sDWfIE889KyBz9b8V1TQK72e16Y15
	 HmcTRYmQc3OzZHoDxiDtmFjS3R6kNr3kXqY8Qphg9ALQpro689XPsBxgplOGPqCELb
	 cO2HTcerGY8qYNs/j0SmdlN+d13JCYKCVJQJ9Wio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 467/816] wifi: mt76: mt7921: fix of_node reference leaks in regd update
Date: Wed, 25 Nov 2026 15:33:35 +0100
Message-ID: <20261125143900.012188052@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Moved the mt7921_regd_channel_update() hunks from regd.c (absent here) into init.c, and omitted the 5GHz !sband goto hunk because init.c has no such check. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/init.c  | 26 ++++++++++++++++---
 .../net/wireless/mediatek/mt76/mt7921/mcu.c   |  7 ++++-
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index 276dfb9c26e0d..016ad2c284166 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -60,6 +60,21 @@ static int mt7921_thermal_init(struct mt792x_phy *phy)
 	return PTR_ERR_OR_ZERO(hwmon);
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
@@ -79,7 +94,7 @@ mt7921_regd_channel_update(struct wiphy *wiphy, struct mt792x_dev *dev)
 		ch = &sband->channels[i];
 		cfreq = ch->center_freq;
 
-		if (np && (!band_np || !mt76_find_channel_node(band_np, ch))) {
+		if (np && !mt7921_regd_dt_has_channel(band_np, ch)) {
 			ch->flags |= IEEE80211_CHAN_DISABLED;
 			continue;
 		}
@@ -88,17 +103,18 @@ mt7921_regd_channel_update(struct wiphy *wiphy, struct mt792x_dev *dev)
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
@@ -110,6 +126,10 @@ mt7921_regd_channel_update(struct wiphy *wiphy, struct mt792x_dev *dev)
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
index e533f1a3e0cba..0e547a5d020c1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -3,6 +3,7 @@
 
 #include <linux/fs.h>
 #include <linux/firmware.h>
+#include <linux/of.h>
 #include "mt7921.h"
 #include "mcu.h"
 #include "../mt76_connac2_mac.h"
@@ -1352,6 +1353,7 @@ int __mt7921_mcu_set_clc(struct mt792x_dev *dev, u8 *alpha2,
 		.acpi_conf = mt792x_acpi_get_flags(&dev->phy),
 		.mtcl_conf = mt792x_acpi_get_mtcl_conf(&dev->phy, alpha2),
 	};
+	struct device_node *np;
 	int ret, valid_cnt = 0;
 	u32 buf_len = 0;
 	u8 *pos;
@@ -1361,8 +1363,11 @@ int __mt7921_mcu_set_clc(struct mt792x_dev *dev, u8 *alpha2,
 
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



