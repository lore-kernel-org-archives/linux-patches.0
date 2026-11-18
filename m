Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025896;
	b=K/Dk0g7ZTx5ZVyvnmmUDvWlcE7hTJ67wplQklnEPevcWObMmxJ1OC/iaoQmt9IPUcgq0
	 8meHusXGMcX5w9DPSCxIPJIl2gC0/K0zvbiCfr3qHyvbnp1FG2GASq9EsQvcu2IKsnSfL
	 8K7o6dOp0GWaXJlA5ug8XtD/32IIU7X1rElgky+oHWPjLrVt9kLoXu7rCUdpoWCEO5OIG
	 nNlOHOpVH4/TpjYxmNusqo9O3eJmn0K/6NCiinruGXkMVgRb4qnikmne/1v4Z9tTpHKg3
	 4uFSJtRvBGFVFkoep1FHVKCdCpdOUE11OTl88FNHvrkJA85pGgPZBYJvPh+WrAZ9UHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025896;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3kdmqzckF4Nmerurkyc7mdaljNII/NCQPrKCKcp2KM4=;
	b=FVTKZ4Pe7Qnu06jdL7LadPgs2j9l4bzZ1OOtZEuqs/dkW+nn144eKK30ReRLfII/kxZ2
	 E4VeZNGcNnVc1rFLQExkEtMIPnPkIApg7cyVv2AtZWExrkVdlkKQAGDE2lsoTARAEnGME
	 l81zDg52rLA0pHLSudJ59UmFhwYNIfwb3nEqWrCEETKHljaj7ScUd/lorce94Clj9nyaM
	 btlpu0Nhl8P1TkSjrOMCqBt4y/r1vk+Y3n+ZfvMLz2wNftYh/bWWTI3z+uZzoA9wN4ooe
	 FVrmDRmYNXm5pdYMNM7Duz1fO7o3REcmm5yyDneQZ27D2NXMRD7AD9k85pD6qaVPu/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gf9HHEUs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06F860A2606;
	Wed, 18 Nov 2026 18:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gf9HHEUs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4FF1F000CD;
	Wed, 18 Nov 2026 18:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025896;
	bh=3kdmqzckF4Nmerurkyc7mdaljNII/NCQPrKCKcp2KM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gf9HHEUsqzas1MHvbBAepSJlWBe22yOWtza97Nv17wfS5MfqYAQldTZRFxX0RDQHp
	 8WS99314F7IDFW7VhfaB8NaNWDih9YrEZmbNaIS4lU9qXuV1fOMh93ctSOnfuJyCU4
	 r/2JJCILhn8ifYLWUmPsbfRrrRd/vFR/wAd+tLBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1240/2151] wifi: mt76: mt792x: compute the assoc RSSI from the chain signals
Date: Wed, 18 Nov 2026 15:49:35 +0100
Message-ID: <20261118150207.341383827@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 3f1d9ba49076f..c9620369cd3b8 100644
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



