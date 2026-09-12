Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80D729D288;
	Sat, 12 Sep 2026 19:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242894; cv=none; b=ganB+nkMNIb4ID4sj3ok49hlFpI/sZS0PEphCZL0gWYxJx1nFPk9ELGi9RlhXsYbSbEtZhGuEsts12lWf6UVTkTLPngzQcrgiHzyINEKuEMvS6fn7kxJKjBmXLlgh562icnynZg1VE5MiwaB7PLHnunKNUEJmQSSSZ7AtRKA3gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242894; c=relaxed/simple;
	bh=/yKZQFfiqTEWQEZJtEMDacEcpsXYSNPSnXn/tzQpbIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xp8QHAtnQO+vDTzecyXdUBex5HsONy/kyDvOGTTSKEgAfzLRWX5AJkmj92Wls2ogq7PAP6sCgXtaH0tosDBSEHmDf86T+ANnXhaTKbpu8KlF/kI3LRvxVJ94St3zQe96jxKDJYNJ2tyJtuzXgPJhVU6WJ7Q/HSC3wP0LR+6TrgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AFQmv7bB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AFQmv7bB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0AC31F000FF;
	Sat, 12 Sep 2026 19:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242893;
	bh=i5B13cWAGsA30zvzMEqr1HpbswtScTcMjjrf9F6XPiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AFQmv7bB7o8GMF9fUvTWjDHRYPshznBUuSW3VDWW5FA8xos/v6XTMvinnLA7egq60
	 UVBrNVqhaeZw9S7N9LQ9Vg4DyMUnc6sGv61QBm7C8eaTny9DmQ8gCp23H7vLtdVqzf
	 ULWcbBskUZCiN3vmLAN7pfRT3W9JThDRT5WwrFCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 557/798] wifi: mt76: mt7915: use little-endian for bss_info_ra wire fields
Date: Sat, 12 Sep 2026 09:03:05 +0200
Message-ID: <20260912065529.895800392@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 04280d0a56be4264720e7b205daaa332c715e5ec ]

train_up_high_thres, train_up_rule_rssi and low_traffic_thres were
declared as host-native short in a firmware-facing TLV and assigned
host-order constants, so on a big-endian host the firmware received
byte-swapped rate-adaptation thresholds. Declare them __le16 and convert
with cpu_to_le16().

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Link: https://patch.msgid.link/20260724124813.3961474-12-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 6 +++---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 53caa5f63a057..ea9e288014aa2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -913,9 +913,9 @@ mt7915_mcu_bss_ra_tlv(struct sk_buff *skb, struct ieee80211_vif *vif,
 	ra->rx_streams = max_nss;
 	ra->algo = 4;
 	ra->train_up_rule = 2;
-	ra->train_up_high_thres = 110;
-	ra->train_up_rule_rssi = -70;
-	ra->low_traffic_thres = 2;
+	ra->train_up_high_thres = cpu_to_le16(110);
+	ra->train_up_rule_rssi = cpu_to_le16(-70);
+	ra->low_traffic_thres = cpu_to_le16(2);
 	ra->phy_cap = cpu_to_le32(0xfdf);
 	ra->interval = cpu_to_le32(500);
 	ra->fast_interval = cpu_to_le32(100);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h
index c656d66385c4b..75a7c30e5cd74 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h
@@ -393,9 +393,9 @@ struct bss_info_ra {
 	u8 antenna_idx;
 	u8 train_up_rule;
 	u8 rsv[3];
-	unsigned short train_up_high_thres;
-	short train_up_rule_rssi;
-	unsigned short low_traffic_thres;
+	__le16 train_up_high_thres;
+	__le16 train_up_rule_rssi;
+	__le16 low_traffic_thres;
 	__le16 max_phyrate;
 	__le32 phy_cap;
 	__le32 interval;
-- 
2.53.0



