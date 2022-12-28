Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46661875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B53C433EF;
	Wed, 28 Dec 2022 15:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243176;
	bh=zK5RTB56eEkFgp0quFy23i6FgJ6xr0MJOsoiN8iWKPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nOFotZkuttyz/G13er/fnzh6LUj7lkJxdAUNCHEBmiQvyIPTnQc+bLL6RYNypWeV2
	 kUIaDTkMagdSoRim5TNxmESlDVdQTtlqSmszulgK5vl3zah1KCp9atv4Y5AH+kBLRW
	 FiYHiXs3hp0J+CDQezeILZZi/HaSmXEV6EQ7Vra0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0459/1146] wifi: mt76: mt7915: Fix chainmask calculation on mt7915 DBDC
Date: Wed, 28 Dec 2022 15:33:18 +0100
Message-Id: <20221228144342.649873076@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>

[ Upstream commit de147cc28985a2a09e5d6d179fc5ef59b22fc058 ]

mt7915 does not have a per-band number of chains unlike the other chips,
it only has a total number of chains.  Yet the current code would
consider the total number as a per-band number.

For example, it would report that a 2x2 + 2x2 DBDC card have 4 chains on
each band and set chainmask to 0b1111 for the first interface and
0b11110000 for the second.

Fixes: 99ad32a4ca3a ("mt76: mt7915: add support for MT7986")
Co-developed-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
index 83bced0c0785..0bce0ce51be0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
@@ -194,6 +194,7 @@ void mt7915_eeprom_parse_hw_cap(struct mt7915_dev *dev,
 	nss = path;
 	if (dev->dbdc_support) {
 		if (is_mt7915(&dev->mt76)) {
+			path = min_t(u8, path, 2);
 			nss = FIELD_GET(MT_EE_WIFI_CONF3_TX_PATH_B0,
 					eeprom[MT_EE_WIFI_CONF + 3]);
 			if (phy->band_idx)
-- 
2.35.1



