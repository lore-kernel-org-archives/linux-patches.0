Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2553932AAB5;
	Fri,  9 Jan 2026 12:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961191; cv=none; b=thbf/Qd9BS8DtZkXTgkst2FboWOIr2Km1pEay68LthDfkSeBwGfqdtGytmQyGN3vvOEs6maKO7PcPFc4H+5GW+7lQiy2P9Bi1Hex3bIWZ995YhtGLLp+NHK5t6yEJycc+rg0OiRPHCBQ7zuIcE8nFn5zHh801zj8ACFnf5KdIxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961191; c=relaxed/simple;
	bh=5lQ2fWMHkzc8GZ6R1fc2FU3uywMeUBbv1GtVYHSp7uY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEyV1sGuDUqrFOY4q/nVe4YMSRd1om2iTyOtTS7YQMXzNrdAuML8acZyaBXbMxzJlhgFEU8yjy0xnYdQOht/XPp1vBIvsOl4zr90mFGzAngdqPKEx5r6OsbtPfDXGdBpC9LTAoVIaAFu5Totc4G18kqO32WDxJnplQknWmYLdbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=axDfMoLb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="axDfMoLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86F3C4CEF1;
	Fri,  9 Jan 2026 12:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961191;
	bh=5lQ2fWMHkzc8GZ6R1fc2FU3uywMeUBbv1GtVYHSp7uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=axDfMoLbuRFG/X0QFjMvgGcEFJIEsOUWXc5TrdutjuWFt03aYsClIkQiZeP8jn7f7
	 Lm7xfbEuDMdnDsUhjq9LyzC/nm+AOGasM9V8GE1xU+OVEQksQEdgHxyIoAZGvS9fOO
	 wzhT80F3g3FlJE/ENindfSTSL01Zj6BSOSAcB+TI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sven Eckelmann (Plasma Cloud)" <se@simonwunderlich.de>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 639/737] wifi: mt76: Fix DTS power-limits on little endian systems
Date: Fri,  9 Jan 2026 12:42:58 +0100
Message-ID: <20260109112158.048505989@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: "Sven Eckelmann (Plasma Cloud)" <se@simonwunderlich.de>

[ Upstream commit 38b845e1f9e810869b0a0b69f202b877b7b7fb12 ]

The power-limits for ru and mcs and stored in the devicetree as bytewise
array (often with sizes which are not a multiple of 4). These arrays have a
prefix which defines for how many modes a line is applied. This prefix is
also only a byte - but the code still tried to fix the endianness of this
byte with a be32 operation. As result, loading was mostly failing or was
sending completely unexpected values to the firmware.

Since the other rates are also stored in the devicetree as bytewise arrays,
just drop the u32 access + be32_to_cpu conversion and directly access them
as bytes arrays.

Cc: stable@vger.kernel.org
Fixes: 22b980badc0f ("mt76: add functions for parsing rate power limits from DT")
Fixes: a9627d992b5e ("mt76: extend DT rate power limits to support 11ax devices")
Signed-off-by: Sven Eckelmann (Plasma Cloud) <se@simonwunderlich.de>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/eeprom.c |   37 ++++++++++++++++++----------
 1 file changed, 24 insertions(+), 13 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/eeprom.c
@@ -245,6 +245,19 @@ mt76_get_of_array(struct device_node *np
 	return prop->value;
 }
 
+static const s8 *
+mt76_get_of_array_s8(struct device_node *np, char *name, size_t *len, int min)
+{
+	struct property *prop = of_find_property(np, name, NULL);
+
+	if (!prop || !prop->value || prop->length < min)
+		return NULL;
+
+	*len = prop->length;
+
+	return prop->value;
+}
+
 static struct device_node *
 mt76_find_channel_node(struct device_node *np, struct ieee80211_channel *chan)
 {
@@ -284,7 +297,7 @@ mt76_get_txs_delta(struct device_node *n
 }
 
 static void
-mt76_apply_array_limit(s8 *pwr, size_t pwr_len, const __be32 *data,
+mt76_apply_array_limit(s8 *pwr, size_t pwr_len, const s8 *data,
 		       s8 target_power, s8 nss_delta, s8 *max_power)
 {
 	int i;
@@ -293,15 +306,14 @@ mt76_apply_array_limit(s8 *pwr, size_t p
 		return;
 
 	for (i = 0; i < pwr_len; i++) {
-		pwr[i] = min_t(s8, target_power,
-			       be32_to_cpu(data[i]) + nss_delta);
+		pwr[i] = min_t(s8, target_power, data[i] + nss_delta);
 		*max_power = max(*max_power, pwr[i]);
 	}
 }
 
 static void
 mt76_apply_multi_array_limit(s8 *pwr, size_t pwr_len, s8 pwr_num,
-			     const __be32 *data, size_t len, s8 target_power,
+			     const s8 *data, size_t len, s8 target_power,
 			     s8 nss_delta, s8 *max_power)
 {
 	int i, cur;
@@ -309,8 +321,7 @@ mt76_apply_multi_array_limit(s8 *pwr, si
 	if (!data)
 		return;
 
-	len /= 4;
-	cur = be32_to_cpu(data[0]);
+	cur = data[0];
 	for (i = 0; i < pwr_num; i++) {
 		if (len < pwr_len + 1)
 			break;
@@ -325,7 +336,7 @@ mt76_apply_multi_array_limit(s8 *pwr, si
 		if (!len)
 			break;
 
-		cur = be32_to_cpu(data[0]);
+		cur = data[0];
 	}
 }
 
@@ -336,7 +347,7 @@ s8 mt76_get_rate_power_limits(struct mt7
 {
 	struct mt76_dev *dev = phy->dev;
 	struct device_node *np;
-	const __be32 *val;
+	const s8 *val;
 	char name[16];
 	u32 mcs_rates = dev->drv->mcs_rates;
 	u32 ru_rates = ARRAY_SIZE(dest->ru[0]);
@@ -382,21 +393,21 @@ s8 mt76_get_rate_power_limits(struct mt7
 
 	txs_delta = mt76_get_txs_delta(np, hweight8(phy->antenna_mask));
 
-	val = mt76_get_of_array(np, "rates-cck", &len, ARRAY_SIZE(dest->cck));
+	val = mt76_get_of_array_s8(np, "rates-cck", &len, ARRAY_SIZE(dest->cck));
 	mt76_apply_array_limit(dest->cck, ARRAY_SIZE(dest->cck), val,
 			       target_power, txs_delta, &max_power);
 
-	val = mt76_get_of_array(np, "rates-ofdm",
-				&len, ARRAY_SIZE(dest->ofdm));
+	val = mt76_get_of_array_s8(np, "rates-ofdm",
+				   &len, ARRAY_SIZE(dest->ofdm));
 	mt76_apply_array_limit(dest->ofdm, ARRAY_SIZE(dest->ofdm), val,
 			       target_power, txs_delta, &max_power);
 
-	val = mt76_get_of_array(np, "rates-mcs", &len, mcs_rates + 1);
+	val = mt76_get_of_array_s8(np, "rates-mcs", &len, mcs_rates + 1);
 	mt76_apply_multi_array_limit(dest->mcs[0], ARRAY_SIZE(dest->mcs[0]),
 				     ARRAY_SIZE(dest->mcs), val, len,
 				     target_power, txs_delta, &max_power);
 
-	val = mt76_get_of_array(np, "rates-ru", &len, ru_rates + 1);
+	val = mt76_get_of_array_s8(np, "rates-ru", &len, ru_rates + 1);
 	mt76_apply_multi_array_limit(dest->ru[0], ARRAY_SIZE(dest->ru[0]),
 				     ARRAY_SIZE(dest->ru), val, len,
 				     target_power, txs_delta, &max_power);


