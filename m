Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104805187ED;
	Thu, 17 Sep 2026 17:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664415; cv=none; b=ETIDc0MdeQ1U4F/XVvsS9k/xkbdnC+kZfIPBf20fgMSsypHD26kmp4/dhcXXCPWk/45KEcbMMqiaxTdfLuVDyx+vj3ZCzaBzoOZLNG/HAvpTcMKMhPKIiTTXiNuLMEOgUi6aM7/VFeRC5UoLisu8LWDf/08+fqjER42zSfrjCnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664415; c=relaxed/simple;
	bh=NDUqruglZFXcor8UJFeHhNoziUxhDWiv0ZdtIPBupGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ML/nQFiSBlcsGHtnnUKgVXxMtpq2Ho8hWzPxGhxDtwVq2cnpYs1TxfzlMKWNknXk9HNBk1VfEXXQpiL0zOYMOkzMO/L6iIXmtZgfMKDF8VH0e/tG9sKI+esBBFRUwj3uiD7QKi11m65VuIlaks8ueF5I3b27gt471b+x/sywX64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lpH0mhrU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lpH0mhrU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1331F000FF;
	Thu, 17 Sep 2026 17:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664413;
	bh=AQWQzBgs9kZ4SbKffycKOfdVoY2VpuxuT3vF4AcSUew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lpH0mhrUudgs3ziFoI44MgNZoXvm6d8okdpLL6lx37AsAKCR2rdj51IZ64lXHt1fo
	 VT74vkW53NP3/7QNEQqVAUHYJUc0W0BKhzCpLx16M4WTtY6alNCjw39R6PJ8o2dlqg
	 I+IQZArQvVl6J0nAOJCMKI1A360nBCDU4Ggk+ZQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E5=BC=A0=E6=97=AD=E6=B6=B5?= <Loong.0x00@gmail.com>,
	Marcin FM <marcin@lgic.pl>,
	Cristian-Florin Radoi <radoi.chris@gmail.com>,
	George Salukvadze <giosal90@gmail.com>,
	Evgeny Kapusta <3193631@gmail.com>,
	Samu Toljamo <samu.toljamo@gmail.com>,
	Ariel Rosenfeld <ariel.rosenfeld.750@gmail.com>,
	Chapuis Dario <chapuisdario4@gmail.com>,
	=?UTF-8?q?Thibaut=20Fran=C3=A7ois?= <tibo@humeurlibre.fr>,
	Sean Wang <sean.wang@mediatek.com>,
	Javier Tia <floss@jetm.me>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0365/1250] wifi: mt76: mt7925: add 320MHz bandwidth to bss_rlm_tlv
Date: Thu, 17 Sep 2026 16:02:40 +0100
Message-ID: <20260917151601.954629336@linuxfoundation.org>
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

[ Upstream commit efc9a10d1de1763baecd2031c1c6dfe6aac9ac38 ]

bss_rlm_tlv() in mt7925_mcu_bss_rlm_tlv() has no case for
NL80211_CHAN_WIDTH_320. When associated to a 320MHz BSS, the switch
falls through to default and sends bw=0 (CMD_CBW_20MHZ) to firmware
via BSS_RLM TLV. Firmware then configures the RX radio for 20MHz
and cannot decode the AP's 320MHz frames, resulting in complete data
path failure at 320MHz.

Add the missing NL80211_CHAN_WIDTH_320 case with CMD_CBW_320MHZ and
center_chan2.

Tested on ASUS RT-BE92U: 320MHz throughput goes from 0 Mbps to
841 Mbps (iperf3 -t30 -P8), PHY 4803 Mbps EHT-MCS11.

Reported-by: 张旭涵 <Loong.0x00@gmail.com>
Closes: https://github.com/openwrt/mt76/issues/927
Tested-by: 张旭涵 <Loong.0x00@gmail.com>
Tested-by: Marcin FM <marcin@lgic.pl>
Tested-by: Cristian-Florin Radoi <radoi.chris@gmail.com>
Tested-by: George Salukvadze <giosal90@gmail.com>
Tested-by: Evgeny Kapusta <3193631@gmail.com>
Tested-by: Samu Toljamo <samu.toljamo@gmail.com>
Tested-by: Ariel Rosenfeld <ariel.rosenfeld.750@gmail.com>
Tested-by: Chapuis Dario <chapuisdario4@gmail.com>
Tested-by: Thibaut François <tibo@humeurlibre.fr>
Reviewed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Javier Tia <floss@jetm.me>
Link: https://patch.msgid.link/20260425195011.790265-3-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 0261814db2c87..8b1e1d2ed2546 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2339,6 +2339,10 @@ void mt7925_mcu_bss_rlm_tlv(struct sk_buff *skb, struct mt76_phy *phy,
 	case NL80211_CHAN_WIDTH_160:
 		req->bw = CMD_CBW_160MHZ;
 		break;
+	case NL80211_CHAN_WIDTH_320:
+		req->bw = CMD_CBW_320MHZ;
+		req->center_chan2 = ieee80211_frequency_to_channel(freq2);
+		break;
 	case NL80211_CHAN_WIDTH_5:
 		req->bw = CMD_CBW_5MHZ;
 		break;
-- 
2.53.0



