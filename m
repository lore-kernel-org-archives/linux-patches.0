Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E904FC354;
	Thu, 17 Sep 2026 17:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664412; cv=none; b=LSSLoBrsd7tE6Zu8WyyisauREosTysqCHRB/Xzybx0w0roZCbuZ3+gLFMx3G0Y3BZ0pCYmrsho82WioFCEVjgHecA343ph3wrxuyuWbb5xCuiDLadT0TCh2FjCct9O2lVVnntWhAud04EObVOq0ok+hhXm5CIxl2VHLcwFkFRFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664412; c=relaxed/simple;
	bh=dz4mdi/96gZMHcaM3VTVAh/sXIbDBoIUrOjn7PevZu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZtwGTTWCVE3GKOOkV6C/G0gXFx2k0q1D1LGl39LTsSeiorHAGM8cYU274CalEXIcxiabIkBE1eApAkChW8j9mcBQbSp0fpFt59gz82h8U7ogDUcmZib5yndOUG5JteVDuY9oZgRXq5t5O5RoWpET2OHXMlTxj0AHzhi2osAGGg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5f175RN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5f175RN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E56C1F0089A;
	Thu, 17 Sep 2026 17:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664411;
	bh=pagZloUmebrTqlY3RgygRy9IhMglJcSnd1MDA7ZQzz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P5f175RNDjl+Nim0z53KJfjyLTuNm6qWz4V1opPjMSWWzpe04NWjtdc/G7GblQL5z
	 5DqQdLxTw7ZF2qtwF/X9QokR4+Savqb+D45jFcKOrjzIMABz9rJb0gqVQiB/ghmpBL
	 Uvj51HG6g7bJtLcI0BfubZ1jnI+Cz/Mtv9fTEKBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcin FM <marcin@lgic.pl>,
	Cristian-Florin Radoi <radoi.chris@gmail.com>,
	George Salukvadze <giosal90@gmail.com>,
	Evgeny Kapusta <3193631@gmail.com>,
	Samu Toljamo <samu.toljamo@gmail.com>,
	Ariel Rosenfeld <ariel.rosenfeld.750@gmail.com>,
	Chapuis Dario <chapuisdario4@gmail.com>,
	=?UTF-8?q?Thibaut=20Fran=C3=A7ois?= <tibo@humeurlibre.fr>,
	=?UTF-8?q?=E5=BC=A0=E6=97=AD=E6=B6=B5?= <Loong.0x00@gmail.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Javier Tia <floss@jetm.me>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0364/1250] wifi: mt76: mt7925: populate EHT 320MHz MCS map in sta_rec
Date: Thu, 17 Sep 2026 16:02:39 +0100
Message-ID: <20260917151601.928083641@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Tia <floss@jetm.me>

[ Upstream commit e7bbd3d8b4f01473676da3aa8be17099e1604459 ]

The sta_rec_eht structure has a mcs_map_bw320 field, and the channel
width mapping includes NL80211_CHAN_WIDTH_320, but the 320MHz MCS/NSS
map was never copied from the station's EHT capabilities to the MCU TLV.
This prevents negotiation of 320MHz channel width even when both the
hardware and firmware advertise support for it.

Add the missing memcpy for the 320MHz MCS map, matching the existing
pattern for BW20, BW80, and BW160.

Tested-by: Marcin FM <marcin@lgic.pl>
Tested-by: Cristian-Florin Radoi <radoi.chris@gmail.com>
Tested-by: George Salukvadze <giosal90@gmail.com>
Tested-by: Evgeny Kapusta <3193631@gmail.com>
Tested-by: Samu Toljamo <samu.toljamo@gmail.com>
Tested-by: Ariel Rosenfeld <ariel.rosenfeld.750@gmail.com>
Tested-by: Chapuis Dario <chapuisdario4@gmail.com>
Tested-by: Thibaut François <tibo@humeurlibre.fr>
Tested-by: 张旭涵 <Loong.0x00@gmail.com>
Reviewed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Javier Tia <floss@jetm.me>
Link: https://patch.msgid.link/20260425195011.790265-5-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index d11c7ff14bc8f..0261814db2c87 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -1690,6 +1690,7 @@ mt7925_mcu_sta_eht_tlv(struct sk_buff *skb, struct ieee80211_link_sta *link_sta)
 		memcpy(eht->mcs_map_bw20, &mcs_map->only_20mhz, sizeof(eht->mcs_map_bw20));
 	memcpy(eht->mcs_map_bw80, &mcs_map->bw._80, sizeof(eht->mcs_map_bw80));
 	memcpy(eht->mcs_map_bw160, &mcs_map->bw._160, sizeof(eht->mcs_map_bw160));
+	memcpy(eht->mcs_map_bw320, &mcs_map->bw._320, sizeof(eht->mcs_map_bw320));
 }
 
 static void
-- 
2.53.0



