Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025899;
	b=aQD6WwjdmnMP+kwh2teYliKHDiQISHsAx8LwjCQ/YUfGwU54GlLpXdUm8VXZdFJImYc8
	 +NE7cafvadgStnGE1410Xvbi+SilRyvdf2T0D6OTmLDv9jClA5XrBL87GMvit4j2MRbPP
	 ner1x/vmm3pXr2fNkCOAf2kzqx4Yrwkq+WwTC1ZFl2U++i2vBbbn12F01i8UK6s+1w3dZ
	 UbJRXXCuv1YjduH24rTXL9PlgC94gRDC4c9o/9PILseWLrZvmWd0Lz+pi62/jUoSA6+20
	 QkxxurHxmtEieRIE7+2hvJ2QAUGEiuHfG6Gw7gKLuOpuXrjEJ0QTi2AfuuPMiu3qiUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025899;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZUMA+LTfh3TOlbeR/8LkVjwpZeR5e4GVHQvk0PvTInk=;
	b=jzOJMWjNj9n9hM9I/42Nwp62AH3D1zEac+b67j0EEanl99kWiEVVaQzAbqEvQjBLeVJ1
	 9bKCTvNzXa35iogQtsFu6r43w/ItNDL9gBfOuIvUHUshK8pg75MxdmznCeiC9wzjZmh7a
	 rSGS2r5boHTKH1N8O6OB5YtPjc1x6TUb0YjS/c54hW8AQRIR0KRylRwzYuEQDf9zQzBeJ
	 xCfiouTFBxJnKxNdkZLlpotZs7WFqPCwp/C7Ii4GF80/PSsGg+w/WCbfi5alhlBbTxMJ4
	 blUFQczVpagmtIO2xtBLt+PQOCCOhfR1idLNgOz+pLmgdZnGkrOBSLWmHzC/3P2m53Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="u3/EFrK3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98264606A320;
	Wed, 18 Nov 2026 18:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u3/EFrK3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66621F000C5;
	Wed, 18 Nov 2026 18:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025899;
	bh=ZUMA+LTfh3TOlbeR/8LkVjwpZeR5e4GVHQvk0PvTInk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u3/EFrK3FjhdEv+9Dug+aJy6Em6Kr8A4LKZVChQ2EMAxgGzeP8tTKplWKxb31GI5Q
	 tPfaUL5GYC1xvlfpDgWs+hwypXLI/f2j/cu6VkzQgWrSBxHToQ0Vn3Xlld5URd2iaa
	 Mpog1p5kOytcuT3Ceu0uZFJksjMBPjmuS2Ee+z2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1201/2151] wifi: mt76: mt7925: fix lock inversion between dev->mutex and iflist_mtx
Date: Wed, 18 Nov 2026 15:48:56 +0100
Message-ID: <20261118150205.956945318@linuxfoundation.org>
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

From: Devin Wittmayer <lucid_duck@justthetip.ca>

[ Upstream commit 3208623121309a42f878364aff3c770f597d6a70 ]

mt7925_config() has the same inversion as mt7921_config(): it holds
dev->mutex across ieee80211_iterate_active_interfaces(), which takes
local->iflist_mtx, while mac80211 calls drv_unassign_vif_chanctx() with
iflist_mtx already held.

.config is only reached through drv_config(), which asserts the wiphy
mutex, so use ieee80211_iterate_active_interfaces_mtx() here too.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260810045338.118923-3-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 70068c9eb8ea8..79c72a7289d36 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -793,9 +793,9 @@ static int mt7925_config(struct ieee80211_hw *hw, int radio_idx, u32 changed)
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
-		ieee80211_iterate_active_interfaces(hw,
-						    IEEE80211_IFACE_ITER_RESUME_ALL,
-						    mt7925_sniffer_interface_iter, dev);
+		ieee80211_iterate_active_interfaces_mtx(hw,
+							IEEE80211_IFACE_ITER_RESUME_ALL,
+							mt7925_sniffer_interface_iter, dev);
 	}
 
 out:
-- 
2.53.0



