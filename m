Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019144;
	b=xkXK3Q2AcpOvv2Fp3T/xCdfvjGD5r6nmLq2qqhPb93pQrHzhp569NdZQ1vHmCEIHX+Pt
	 TB7yAd+NVyuJoHahnHCSTQR+SK/P4w0A329l7w0bv5mvvxIExrUyaC66XYp/cw0ddaCGp
	 OO8x1vmpPMozjfbuNaCfd5QJEl7RHef86AMxGghDDGxSuxWEs0EzvuUcqH7EUovFrQ/+R
	 c3uQs+eJwW4oX/j9l9Fxlf8fEyZOu+iPrSAc1soIGcmi69nkS9L6c53vedBtcXVyFZEMn
	 u+7O7FppSm8PzGiXokr/5gAVNTc1tJp4UdTQ/kuRRiGsuc4t83zYdq2tvE5ZSo1LpxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019144;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EPiuItMP0QxLRVVrOQEGXZl3QVhd3OXlwIq074PMk+Q=;
	b=FZV0LrAjAu+BQzteoJou51ImBqBdRh3JD83pAc1qhsBbIY8w/xKiaMUdi2D8sgPcR4Tt
	 /PN6sEGyidebUvc+ZeXj+WlIcGVWkkf5qHy0ly9tIKWUdfYjFFw6vtDnaarkU5SkWNK8K
	 1Xz3Wa5T9JF8FC3rP77tcjxHizgjh3A4D69eblCi2BDf4ZWxBS6D8UkrEX6Xgy9RValAG
	 Qzo90hA0pft/I2ZLZ3yjM8yea1oeagquaSLv9UJskxx9JU6zIcRWV4F0mz7cGa37BnDpA
	 dceifk52l/bKozXj48Vp4Mgv7KVk9Vjbf/CaI25aRUS9AY3/X8DtnbhdkGk6vjMpfQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HGdo+2JS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A239606A31C;
	Wed, 18 Nov 2026 16:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HGdo+2JS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FBD1F000C4;
	Wed, 18 Nov 2026 16:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019143;
	bh=EPiuItMP0QxLRVVrOQEGXZl3QVhd3OXlwIq074PMk+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HGdo+2JSTw6Waa/V6lj38rO7RNqi/BgCkXPEz6nlUE2DHzgbqMORW6/nGmLVkJ0TE
	 HNm/6y2U6vWeSolssRcG6JlImbXLVn8WZQDcQFSSCOAt0UZzDsKNzay4awPrfVhgiD
	 4U8URBUuL25rWhi0EzIfpiydfITrA9w1gi4Iu5Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1492/2651] wifi: mt76: mt792x: compute the assoc RSSI from the chain signals
Date: Wed, 18 Nov 2026 15:45:32 +0100
Message-ID: <20261118150341.732579887@linuxfoundation.org>
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

[ Upstream commit 2d12f56631ef307e58651b560ccda1f324a059f9 ]

mt792x_mac_rssi_iter() adds status->signal of auth and assoc response
frames to the BSS RSSI average, which mt7921_mcu_sta_update() and
mt7925_mcu_sta_update() send to the firmware as the station RCPI.
mt7925 never sets status->signal, since mt76_rx_convert() computes it
from the chain values later. The average is thus fed 0 dBm on mt7925.

Compute the signal from the chain values, as mt76_rx_convert() and
mt76_check_sta() do, and skip a frame without a valid chain signal. On
mt7921, the average now follows the combined value instead of the
strongest chain.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Link: https://patch.msgid.link/20261007112419.1277594-4-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt792x_mac.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_mac.c b/drivers/net/wireless/mediatek/mt76/mt792x_mac.c
index 1e20b333cc612..ebf4c32924c45 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_mac.c
@@ -165,14 +165,16 @@ mt792x_mac_rssi_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 	struct mt76_rx_status *status = (struct mt76_rx_status *)skb->cb;
 	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
 	struct ieee80211_hdr *hdr = mt76_skb_get_hdr(skb);
+	int signal;
 
-	if (status->signal > 0)
+	signal = mt76_rx_signal(status->chains, status->chain_signal);
+	if (signal > 0 || signal <= -128)
 		return;
 
 	if (!ether_addr_equal(vif->addr, hdr->addr1))
 		return;
 
-	ewma_rssi_add(&mvif->bss_conf.rssi, -status->signal);
+	ewma_rssi_add(&mvif->bss_conf.rssi, -signal);
 }
 
 void mt792x_mac_assoc_rssi(struct mt792x_dev *dev, struct sk_buff *skb)
-- 
2.53.0



