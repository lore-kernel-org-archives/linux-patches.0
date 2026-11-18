Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036358;
	b=VamRrMXomHdL2vQrWEkMxptidd6DpK0CzrZ6ZfhhSnNbAQI+JsPD6MmFZHzPOtzktcb3
	 T+LWA3ohrM+5Fh+prLQAgF7vj5OalLwdGoqtQCSnxdh+wHlJSzez2fpEqok5vQOgsZE1a
	 U55dB8vMKWDa1PLR5zya1/hEbPDDNSoA+XoxvpiZCglxOZ3cFKRPHbBZYCBrVVyQyX/lq
	 F+6TAfY/E6CDrtnQ1AQH5oWL1MVPMz9iAcVaYNdSt6+7LpgHQ7stbln2JDoozAy01eoGb
	 WdmmagMYxw/0Pptcr185ZXa+B1BqQTjbPW+DCKB8wyu+g9A6+na49OW3qmZJBn3K1xQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8y2quvzUsN3ENQOQRHBj+Gr1pgW3v0i3PtEs+wqHW+w=;
	b=xuk6HDSwdradB1/dccZgkb6R6kYiFFYWJtWj/9y1fP+UGShfLaNFVRcF4MeT5S8NlM6/
	 p7PVr/qfna0hdcFMAEQsFtsGdIFHYp4ARaR9nChFUe2iLVaGEpW2g11rhDr/g6jhmhz2A
	 sY/5i3xBDbh5dSNKsrGTZTYE29NaQcytk1DG4jUGeksTcFmxYc2QSDOGVMUOhYNHV0Uo8
	 dHee7hNVl8vab3Fsq5lZyhx95cDOvP+TDtSd1OO9uga+z0Qx5qlE+tPjWYXbJXFyw5RqF
	 OSn0siCa/HoQWvq5WgjfVpu0M10fnBx2ax9g72nzynnGMiROIGQB3cK1g7kW33SV3Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lcfnOIgx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94B2606A339;
	Wed, 18 Nov 2026 21:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lcfnOIgx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B241F000C8;
	Wed, 18 Nov 2026 21:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036358;
	bh=8y2quvzUsN3ENQOQRHBj+Gr1pgW3v0i3PtEs+wqHW+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lcfnOIgxQ5SuE7WMZcfQ/nWktfXR7CaTx5R58Co0x8+G9ydBDVGEDrHsSep/+++7K
	 wrfhDWFapIz+xR441+uzpzTOjuca2LwESo2ppBbyr3dlQO4KI837X7abRmIL9cy0jM
	 QmIabub404y9oHS4zJsTJjCbfoG7C2EhhafXBS94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1032/3318] wifi: mt76: Fix of_node reference leak in mt76_get_rate_power_limits()
Date: Wed, 18 Nov 2026 15:27:34 +0100
Message-ID: <20261118150350.852271473@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 8d604c899f7bd1a76a2eb21c0b706c02878abd36 ]

mt76_find_power_limits_node() and mt76_find_channel_node() return nodes
with the reference held, but mt76_get_rate_power_limits() overwrites the
"txpower-<band>" node reference and never releases the channel node
reference, leaking both.

Drop the intermediate and the channel node reference on every exit path,
and take a reference on the fallback node returned by
mt76_find_power_limits_node() so the caller's of_node_put() is balanced.

Fixes: 22b980badc0f ("mt76: add functions for parsing rate power limits from DT")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917121944.2150737-1-vulab@iscas.ac.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/eeprom.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/eeprom.c b/drivers/net/wireless/mediatek/mt76/eeprom.c
index 1663090e58bb6..94fb491aa80b4 100644
--- a/drivers/net/wireless/mediatek/mt76/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/eeprom.c
@@ -217,12 +217,14 @@ mt76_find_power_limits_node(struct mt76_dev *dev)
 		struct property *regd = of_find_property(cur, "regdomain", NULL);
 
 		if (!country && !regd) {
-			fallback = cur;
+			of_node_put(fallback);
+			fallback = of_node_get(cur);
 			continue;
 		}
 
 		if (mt76_string_prop_find(country, dev->alpha2) ||
 		    mt76_string_prop_find(regd, region_name)) {
+			of_node_put(fallback);
 			of_node_put(np);
 			return cur;
 		}
@@ -346,7 +348,7 @@ s8 mt76_get_rate_power_limits(struct mt76_phy *phy,
 			      s8 target_power)
 {
 	struct mt76_dev *dev = phy->dev;
-	struct device_node *np;
+	struct device_node *np, *band_np;
 	const s8 *val;
 	char name[16];
 	u32 mcs_rates = dev->drv->mcs_rates;
@@ -379,15 +381,18 @@ s8 mt76_get_rate_power_limits(struct mt76_phy *phy,
 		band = '6';
 		break;
 	default:
+		of_node_put(np);
 		return target_power;
 	}
 
 	snprintf(name, sizeof(name), "txpower-%cg", band);
-	np = of_get_child_by_name(np, name);
-	if (!np)
+	band_np = of_get_child_by_name(np, name);
+	of_node_put(np);
+	if (!band_np)
 		return target_power;
 
-	np = mt76_find_channel_node(np, chan);
+	np = mt76_find_channel_node(band_np, chan);
+	of_node_put(band_np);
 	if (!np)
 		return target_power;
 
@@ -412,6 +417,8 @@ s8 mt76_get_rate_power_limits(struct mt76_phy *phy,
 				     ARRAY_SIZE(dest->ru), val, len,
 				     target_power, txs_delta, &max_power);
 
+	of_node_put(np);
+
 	return max_power;
 }
 EXPORT_SYMBOL_GPL(mt76_get_rate_power_limits);
-- 
2.53.0



