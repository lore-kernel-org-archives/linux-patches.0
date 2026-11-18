Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019121;
	b=dCEVVIrGRehg9XMJ6hVYDXhrLQjxtVBWeAqX73qKiwA0nRVhiwPg7WgOWBHN7xnWvBqa
	 RB8QPw6/Dhou6Zv+5ql3+E0RouSEA7m//JfUpEu0R4xVf2nKGORzwpW/gWMbxeCUCaPlJ
	 iQgIvoDztI9Rgo3hiy8sjR2jyB85/U+Qbgf6ygT7YqwsUPdai3RAP+fLzUfcRYZDn2xxR
	 cilA8mtJUglcX3UdvNyTlEJ2DYjEdjqKkbv65oZMQhtW0OI6H+TtC4Ww7xc7x6GEmeSS9
	 KbbfEhDGuPeaYsOuC0WCBmYF2zKaEFFENtyaa+Tjg0FMwIEEUQoLRrG6aTRt+J6B7ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=luK+cLGFc8aM3rNj8E+mJ4vnZ6QDu1bLM+rbpzpNfns=;
	b=fpcLCkFGk/tetYQf0VbMiyTcDWBxBNW1QAmFVZnu31mkXoGTrwHDclKHzVXwXNKk94p9
	 DDJOAoO1xLXvZ5iWLAliqL4r3oRwQSwSc7ODS391TYzIx21xtR8ZP+8XAzuHcseamECFZ
	 mH1IB7VdL2EpnJrBM6kkDT3rj/zIRQhq3pATUj2srdM0PzISyYY8fdxvhnRIQznKzDAxZ
	 Ai1xSLT1B2/L+9kbFFmkbcgDIWzB46ngz/H8KeIfyhC4dMPALaEZBLxOHYehnwOiqtSOH
	 V5YW7otru55u6epwA9LRxZXins7K2pc6UlRqwtif4uHagdNrnZsFvsQr5Mcyh7YzC6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=retFPzYw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF67606A31C;
	Wed, 18 Nov 2026 16:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=retFPzYw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1B41F000C4;
	Wed, 18 Nov 2026 16:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019121;
	bh=luK+cLGFc8aM3rNj8E+mJ4vnZ6QDu1bLM+rbpzpNfns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=retFPzYwbT0j1jZF83jZAyMLbDwJKUJe9q0g9cqbBZ/6fZVVyywgfb3HoN6+x8MeH
	 PM1LOs3cxGYLGa35oaYgWLktGymkfjwsro1SjwMxOknZa4RKp1jiw160ISjaNTUVXi
	 DBDlrkQdLR+oxbmuCOA5ulwT4gwrd5tDXm08ejok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1441/2651] wifi: mt76: mt7921: honour FIF_FCSFAIL instead of hardcoding drop_err
Date: Wed, 18 Nov 2026 15:44:41 +0100
Message-ID: <20261118150339.921156654@linuxfoundation.org>
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

From: Devin Wittmayer <lucid_duck@justthetip.ca>

[ Upstream commit f8794eb3ff6dedbba0337c5197626b62da0ef057 ]

When a monitor interface asks to see frames that failed their checksum,
mac80211 passes the request down to the driver. mt7921 works out the
answer, sends it to the firmware as a receive filter, and then configures
the sniffer with a hardcoded byte telling it to drop those frames anyway.
The answer is used once and never kept, so the sniffer never gets to see
it.

That matters to anyone using monitor mode to judge a link honestly, which
is most of the reason to be in monitor mode at all.

Mark Anthony Agarro posted the same change for mt7925: keep what mac80211
asked for on the phy, and read it back when the sniffer is configured.
This does that for mt7921, and applies on top of it, since that patch is
what adds the field.

https://lore.kernel.org/linux-wireless/20260826091757.469953-1-markanthonyagarro@gmail.com/

The stored value is read in one place only, configuring the sniffer, which
has a single caller, and that call sits inside a branch reached only by a
monitor interface. Nothing else changes.

Measured on an MT7922 with a read-only probe on the command as the driver
sends it, so these are the driver's own bytes rather than an inference
from what came back:

  request  arm      drop_err
  none     stock    1 1 1 1
  none     patched  1 1 1 1
  fcsfail  stock    1 1
  fcsfail  patched  0 0

Stock sends the drop byte whether or not anyone asked for it. Patched
sends it only when nobody did. Withdrawing the request and making it again
inside one driver load moves the byte back and forth, 0 then 1 then 0
across three changes, so nothing sticks once set.

If it does appear to stick when trying this against an MT7927, that is
mac80211 rather than the driver. It raises the filter count
unconditionally when a monitor comes up, but skips lowering it again for
drivers that set NO_VIRTUAL_MONITOR, and that is the only chip in this
family which does.

Fixes: 914189af23b8 ("wifi: mt76: mt7921: fix channel switch fail in monitor mode")
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260826231029.39632-1-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   | 8 +++-----
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h | 5 +++++
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 623ccb41a368a..d041df807f615 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -668,12 +668,8 @@ static void mt7921_configure_filter(struct ieee80211_hw *hw,
 				    unsigned int *total_flags,
 				    u64 multicast)
 {
-#define MT7921_FILTER_FCSFAIL    BIT(2)
-#define MT7921_FILTER_CONTROL    BIT(5)
-#define MT7921_FILTER_OTHER_BSS  BIT(6)
-#define MT7921_FILTER_ENABLE     BIT(31)
-
 	struct mt792x_dev *dev = mt792x_hw_dev(hw);
+	struct mt792x_phy *phy = mt792x_hw_phy(hw);
 	u32 flags = MT7921_FILTER_ENABLE;
 
 #define MT7921_FILTER(_fif, _type) do {			\
@@ -685,6 +681,8 @@ static void mt7921_configure_filter(struct ieee80211_hw *hw,
 	MT7921_FILTER(FIF_CONTROL, CONTROL);
 	MT7921_FILTER(FIF_OTHER_BSS, OTHER_BSS);
 
+	phy->rxfilter = flags;
+
 	mt792x_mutex_acquire(dev);
 	mt7921_mcu_set_rxfilter(dev, flags, 0, 0);
 	mt792x_mutex_release(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 40546005c743b..c90d0da706a1a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -1231,7 +1231,7 @@ int mt7921_mcu_config_sniffer(struct mt792x_vif *vif,
 			.len = cpu_to_le16(sizeof(req.tlv)),
 			.control_ch = chandef->chan->hw_value,
 			.center_ch = ieee80211_frequency_to_channel(freq1),
-			.drop_err = 1,
+			.drop_err = !(vif->phy->rxfilter & MT7921_FILTER_FCSFAIL),
 		},
 	};
 	if (chandef->chan->band < ARRAY_SIZE(ch_band))
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index fb8654b7c5e7e..f7ed11353d289 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -7,6 +7,11 @@
 #include "../mt792x.h"
 #include "regs.h"
 
+#define MT7921_FILTER_FCSFAIL		BIT(2)
+#define MT7921_FILTER_CONTROL		BIT(5)
+#define MT7921_FILTER_OTHER_BSS		BIT(6)
+#define MT7921_FILTER_ENABLE		BIT(31)
+
 #define MT7921_MAX_AID                  20
 
 #define MT7921_TX_RING_SIZE		2048
-- 
2.53.0



